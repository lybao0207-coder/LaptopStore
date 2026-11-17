<%-- Danh sách thương hiệu (T10). Dữ liệu do ThuongHieuServlet chuẩn bị: danhSach, tongSo, tongTrang, trang, sttBatDau, tuKhoa. --%>
<%@ include file="/WEB-INF/views/admin/layout/header.jspf" %>

<div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
    <h1 class="h3 mb-0">Quản lý thương hiệu</h1>
    <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/thuong-hieu/them">+ Thêm thương hiệu</a>
</div>

<form class="row g-2 mb-3" method="get" action="${pageContext.request.contextPath}/admin/thuong-hieu">
    <div class="col-sm-8 col-md-6">
        <input type="search" name="tuKhoa" class="form-control" maxlength="100"
               placeholder="Tìm theo tên thương hiệu..." value="<c:out value='${tuKhoa}'/>">
    </div>
    <div class="col-auto">
        <button type="submit" class="btn btn-outline-primary">Tìm kiếm</button>
    </div>
    <c:if test="${not empty tuKhoa}">
        <div class="col-auto">
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/thuong-hieu">Xóa bộ lọc</a>
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
                <c:when test="${not empty tuKhoa}">Không tìm thấy thương hiệu nào có tên chứa "<c:out value="${tuKhoa}"/>".</c:when>
                <c:otherwise>Chưa có thương hiệu nào.</c:otherwise>
            </c:choose>
        </div>
    </c:when>

    <c:otherwise>
        <p class="text-muted mb-2">
            Tìm thấy <strong>${tongSo}</strong> thương hiệu
            <c:if test="${not empty tuKhoa}"> có tên chứa "<c:out value="${tuKhoa}"/>"</c:if>
            - trang ${trang}/${tongTrang}.
        </p>

        <div class="card">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th class="text-center">STT</th>
                        <th>Mã</th>
                        <th>Tên thương hiệu</th>
                        <th>Đường dẫn URL</th>
                        <th>Quốc gia</th>
                        <th>Logo (đường dẫn)</th>
                        <th class="text-center">Trạng thái</th>
                        <th class="text-center">Số sản phẩm</th>
                        <th>Ngày tạo</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="th" items="${danhSach}" varStatus="vt">
                        <tr>
                            <td class="text-center">${sttBatDau + vt.count}</td>
                            <td>${th.maThuongHieu}</td>
                            <td class="fw-semibold"><c:out value="${th.tenThuongHieu}"/></td>
                            <td><code><c:out value="${th.duongDanUrl}"/></code></td>
                            <td><c:out value="${th.quocGia}"/></td>
                            <td class="small text-muted"><c:out value="${empty th.duongDanLogo ? '(chưa có)' : th.duongDanLogo}"/></td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${th.dangHoatDong}"><span class="badge text-bg-success">Đang hoạt động</span></c:when>
                                    <c:otherwise><span class="badge text-bg-secondary">Ngừng hoạt động</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">${th.soSanPham}</td>
                            <td class="text-nowrap"><c:out value="${th.ngayTaoHienThi}"/></td>
                            <td class="text-center text-nowrap">
                                <c:url var="urlSua" value="/admin/thuong-hieu/sua">
                                    <c:param name="ma" value="${th.maThuongHieu}"/>
                                </c:url>
                                <a class="btn btn-sm btn-outline-primary" href="${urlSua}">Sửa</a>
                                <%-- Xóa bằng POST + hộp thoại xác nhận (nội dung lấy từ data-xac-nhan đã escape) --%>
                                <form method="post" action="${pageContext.request.contextPath}/admin/thuong-hieu/xoa" class="d-inline"
                                      data-xac-nhan="Xóa thương hiệu &quot;<c:out value='${th.tenThuongHieu}'/>&quot;? Thao tác này không thể hoàn tác."
                                      onsubmit="return confirm(this.dataset.xacNhan);">
                                    <input type="hidden" name="maThuongHieu" value="${th.maThuongHieu}">
                                    <input type="hidden" name="tuKhoa" value="<c:out value='${tuKhoa}'/>">
                                    <input type="hidden" name="trang" value="${trang}">
                                    <button type="submit" class="btn btn-sm btn-outline-danger"
                                            title="${th.soSanPham > 0 ? 'Thương hiệu đang có sản phẩm - hệ thống sẽ không cho xóa' : 'Xóa thương hiệu'}">Xóa</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <c:if test="${tongTrang > 1}">
            <nav class="mt-3" aria-label="Phân trang thương hiệu">
                <ul class="pagination flex-wrap">
                    <li class="page-item ${trang == 1 ? 'disabled' : ''}">
                        <c:url var="urlTruoc" value="/admin/thuong-hieu">
                            <c:param name="tuKhoa" value="${tuKhoa}"/>
                            <c:param name="trang" value="${trang - 1}"/>
                        </c:url>
                        <a class="page-link" href="${urlTruoc}">&laquo; Trước</a>
                    </li>
                    <c:forEach var="i" begin="1" end="${tongTrang}">
                        <c:url var="urlTrang" value="/admin/thuong-hieu">
                            <c:param name="tuKhoa" value="${tuKhoa}"/>
                            <c:param name="trang" value="${i}"/>
                        </c:url>
                        <li class="page-item ${i == trang ? 'active' : ''}">
                            <a class="page-link" href="${urlTrang}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${trang == tongTrang ? 'disabled' : ''}">
                        <c:url var="urlSau" value="/admin/thuong-hieu">
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
