<%-- Danh sách CPU - bảng BoXuLy (T11). Dữ liệu do BoXuLyServlet chuẩn bị. --%>
<%@ include file="/WEB-INF/views/admin/layout/header.jspf" %>

<div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
    <h1 class="h3 mb-0">Quản lý CPU</h1>
    <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/cpu/them">+ Thêm CPU</a>
</div>

<form class="row g-2 mb-3" method="get" action="${pageContext.request.contextPath}/admin/cpu">
    <div class="col-sm-8 col-md-6">
        <input type="search" name="tuKhoa" class="form-control" maxlength="50"
               placeholder="Tìm theo model, dòng chip hoặc hãng..." value="<c:out value='${tuKhoa}'/>">
    </div>
    <div class="col-auto">
        <button type="submit" class="btn btn-outline-primary">Tìm kiếm</button>
    </div>
    <c:if test="${not empty tuKhoa}">
        <div class="col-auto">
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/cpu">Xóa bộ lọc</a>
        </div>
    </c:if>
</form>

<c:choose>
    <c:when test="${not empty loiTaiDuLieu}">
        <div class="alert alert-danger"><c:out value="${loiTaiDuLieu}"/></div>
    </c:when>

    <c:when test="${tongSo == 0}">
        <div class="alert alert-info">
            <c:choose>
                <c:when test="${not empty tuKhoa}">Không tìm thấy CPU nào khớp "<c:out value="${tuKhoa}"/>".</c:when>
                <c:otherwise>Chưa có CPU nào.</c:otherwise>
            </c:choose>
        </div>
    </c:when>

    <c:otherwise>
        <p class="text-muted mb-2">
            Tìm thấy <strong>${tongSo}</strong> CPU
            <c:if test="${not empty tuKhoa}"> khớp "<c:out value="${tuKhoa}"/>"</c:if>
            - trang ${trang}/${tongTrang}.
        </p>

        <div class="card">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th class="text-center">STT</th>
                        <th>Mã</th>
                        <th>Hãng</th>
                        <th>Dòng chip</th>
                        <th>Tên model</th>
                        <th class="text-center">Nhân / Luồng</th>
                        <th class="text-center">Xung tối đa</th>
                        <th class="text-center">Số sản phẩm</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="cpu" items="${danhSach}" varStatus="vt">
                        <tr>
                            <td class="text-center">${sttBatDau + vt.count}</td>
                            <td>${cpu.maBoXuLy}</td>
                            <td><c:out value="${cpu.hangSanXuat}"/></td>
                            <td><c:out value="${cpu.dongChip}"/></td>
                            <td class="fw-semibold"><c:out value="${cpu.tenModel}"/></td>
                            <td class="text-center">${cpu.soNhan} / ${cpu.soLuongLuong}</td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${empty cpu.xungNhipToiDaGHz}"><span class="text-muted">-</span></c:when>
                                    <c:otherwise>${cpu.xungNhipToiDaGHz} GHz</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">${cpu.soSanPham}</td>
                            <td class="text-center text-nowrap">
                                <c:url var="urlSua" value="/admin/cpu/sua">
                                    <c:param name="ma" value="${cpu.maBoXuLy}"/>
                                </c:url>
                                <a class="btn btn-sm btn-outline-primary" href="${urlSua}">Sửa</a>
                                <form method="post" action="${pageContext.request.contextPath}/admin/cpu/xoa" class="d-inline"
                                      data-xac-nhan="Xóa CPU &quot;<c:out value='${cpu.tenModel}'/>&quot;? Thao tác này không thể hoàn tác."
                                      onsubmit="return confirm(this.dataset.xacNhan);">
                                    <input type="hidden" name="maBoXuLy" value="${cpu.maBoXuLy}">
                                    <input type="hidden" name="tuKhoa" value="<c:out value='${tuKhoa}'/>">
                                    <input type="hidden" name="trang" value="${trang}">
                                    <button type="submit" class="btn btn-sm btn-outline-danger"
                                            title="${cpu.soSanPham > 0 ? 'CPU đang được sản phẩm sử dụng - hệ thống sẽ không cho xóa' : 'Xóa CPU'}">Xóa</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <c:if test="${tongTrang > 1}">
            <nav class="mt-3" aria-label="Phân trang CPU">
                <ul class="pagination flex-wrap">
                    <li class="page-item ${trang == 1 ? 'disabled' : ''}">
                        <c:url var="urlTruoc" value="/admin/cpu">
                            <c:param name="tuKhoa" value="${tuKhoa}"/>
                            <c:param name="trang" value="${trang - 1}"/>
                        </c:url>
                        <a class="page-link" href="${urlTruoc}">&laquo; Trước</a>
                    </li>
                    <c:forEach var="i" begin="1" end="${tongTrang}">
                        <c:url var="urlTrang" value="/admin/cpu">
                            <c:param name="tuKhoa" value="${tuKhoa}"/>
                            <c:param name="trang" value="${i}"/>
                        </c:url>
                        <li class="page-item ${i == trang ? 'active' : ''}">
                            <a class="page-link" href="${urlTrang}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${trang == tongTrang ? 'disabled' : ''}">
                        <c:url var="urlSau" value="/admin/cpu">
                            <c:param name="tuKhoa" value="${tuKhoa}"/>
                            <c:param name="trang" value="${trang + 1}"/>
                        </c:url>
                        <a class="page-link" href="${urlSau}">Sau &raquo;</a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </c:otherwise>
</c:choose>

<%@ include file="/WEB-INF/views/admin/layout/footer.jspf" %>
