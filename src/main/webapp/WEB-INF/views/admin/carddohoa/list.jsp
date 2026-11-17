<%-- Danh sách card đồ họa - bảng CardDoHoa (T12). Dữ liệu do CardDoHoaServlet chuẩn bị. --%>
<%@ include file="/WEB-INF/views/admin/layout/header.jspf" %>

<div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
    <h1 class="h3 mb-0">Quản lý card đồ họa</h1>
    <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/card-do-hoa/them">+ Thêm card đồ họa</a>
</div>

<form class="row g-2 mb-3" method="get" action="${pageContext.request.contextPath}/admin/card-do-hoa">
    <div class="col-sm-8 col-md-6">
        <input type="search" name="tuKhoa" class="form-control" maxlength="60"
               placeholder="Tìm theo model hoặc hãng..." value="<c:out value='${tuKhoa}'/>">
    </div>
    <div class="col-auto">
        <button type="submit" class="btn btn-outline-primary">Tìm kiếm</button>
    </div>
    <c:if test="${not empty tuKhoa}">
        <div class="col-auto">
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/card-do-hoa">Xóa bộ lọc</a>
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
                <c:when test="${not empty tuKhoa}">Không tìm thấy card đồ họa nào khớp "<c:out value="${tuKhoa}"/>".</c:when>
                <c:otherwise>Chưa có card đồ họa nào.</c:otherwise>
            </c:choose>
        </div>
    </c:when>

    <c:otherwise>
        <p class="text-muted mb-2">
            Tìm thấy <strong>${tongSo}</strong> card đồ họa
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
                        <th>Tên model</th>
                        <th class="text-center">Loại</th>
                        <th class="text-center">VRAM</th>
                        <th class="text-center">Số sản phẩm</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="gpu" items="${danhSach}" varStatus="vt">
                        <tr>
                            <td class="text-center">${sttBatDau + vt.count}</td>
                            <td>${gpu.maCardDoHoa}</td>
                            <td><c:out value="${gpu.hangSanXuat}"/></td>
                            <td class="fw-semibold"><c:out value="${gpu.tenModel}"/></td>
                            <td class="text-center">
                                <span class="badge ${gpu.loaiCard == 'ROI' ? 'text-bg-primary' : 'text-bg-light border'}">
                                    <c:out value="${gpu.loaiCardHienThi}"/>
                                </span>
                            </td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${empty gpu.boNhoVramGB}"><span class="text-muted">dùng chung RAM</span></c:when>
                                    <c:otherwise>${gpu.boNhoVramGB} GB</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">${gpu.soSanPham}</td>
                            <td class="text-center text-nowrap">
                                <c:url var="urlSua" value="/admin/card-do-hoa/sua">
                                    <c:param name="ma" value="${gpu.maCardDoHoa}"/>
                                </c:url>
                                <a class="btn btn-sm btn-outline-primary" href="${urlSua}">Sửa</a>
                                <form method="post" action="${pageContext.request.contextPath}/admin/card-do-hoa/xoa" class="d-inline"
                                      data-xac-nhan="Xóa card đồ họa &quot;<c:out value='${gpu.tenModel}'/>&quot;? Thao tác này không thể hoàn tác."
                                      onsubmit="return confirm(this.dataset.xacNhan);">
                                    <input type="hidden" name="maCardDoHoa" value="${gpu.maCardDoHoa}">
                                    <input type="hidden" name="tuKhoa" value="<c:out value='${tuKhoa}'/>">
                                    <input type="hidden" name="trang" value="${trang}">
                                    <button type="submit" class="btn btn-sm btn-outline-danger"
                                            title="${gpu.soSanPham > 0 ? 'Card đang được sản phẩm sử dụng - hệ thống sẽ không cho xóa' : 'Xóa card đồ họa'}">Xóa</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <c:if test="${tongTrang > 1}">
            <nav class="mt-3" aria-label="Phân trang card đồ họa">
                <ul class="pagination flex-wrap">
                    <li class="page-item ${trang == 1 ? 'disabled' : ''}">
                        <c:url var="urlTruoc" value="/admin/card-do-hoa">
                            <c:param name="tuKhoa" value="${tuKhoa}"/>
                            <c:param name="trang" value="${trang - 1}"/>
                        </c:url>
                        <a class="page-link" href="${urlTruoc}">&laquo; Trước</a>
                    </li>
                    <c:forEach var="i" begin="1" end="${tongTrang}">
                        <c:url var="urlTrang" value="/admin/card-do-hoa">
                            <c:param name="tuKhoa" value="${tuKhoa}"/>
                            <c:param name="trang" value="${i}"/>
                        </c:url>
                        <li class="page-item ${i == trang ? 'active' : ''}">
                            <a class="page-link" href="${urlTrang}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${trang == tongTrang ? 'disabled' : ''}">
                        <c:url var="urlSau" value="/admin/card-do-hoa">
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
