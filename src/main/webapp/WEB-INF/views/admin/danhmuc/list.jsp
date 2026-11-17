<%-- Danh sách danh mục (T5). Dữ liệu do DanhMucServlet chuẩn bị: danhSach, tongSo, tongTrang, trang, sttBatDau, tuKhoa. --%>
<%@ include file="/WEB-INF/views/admin/layout/header.jspf" %>

<div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
    <h1 class="h3 mb-0">Quản lý danh mục</h1>
    <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/danh-muc/them">+ Thêm danh mục</a>
</div>

<%-- Ô tìm kiếm: gửi bằng GET để URL giữ được từ khóa khi chuyển trang --%>
<form class="row g-2 mb-3" method="get" action="${pageContext.request.contextPath}/admin/danh-muc">
    <div class="col-sm-8 col-md-6">
        <input type="search" name="tuKhoa" class="form-control" maxlength="100"
               placeholder="Tìm theo tên danh mục..." value="<c:out value='${tuKhoa}'/>">
    </div>
    <div class="col-auto">
        <button type="submit" class="btn btn-outline-primary">Tìm kiếm</button>
    </div>
    <c:if test="${not empty tuKhoa}">
        <div class="col-auto">
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/danh-muc">Xóa bộ lọc</a>
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
                <c:when test="${not empty tuKhoa}">Không tìm thấy danh mục nào có tên chứa "<c:out value="${tuKhoa}"/>".</c:when>
                <c:otherwise>Chưa có danh mục nào.</c:otherwise>
            </c:choose>
        </div>
    </c:when>

    <c:otherwise>
        <p class="text-muted mb-2">
            Tìm thấy <strong>${tongSo}</strong> danh mục
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
                        <th>Tên danh mục</th>
                        <th>Đường dẫn URL</th>
                        <th>Mô tả</th>
                        <th class="text-center">Trạng thái</th>
                        <th class="text-center">Số sản phẩm</th>
                        <th>Ngày tạo</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="dm" items="${danhSach}" varStatus="vt">
                        <tr>
                            <td class="text-center">${sttBatDau + vt.count}</td>
                            <td>${dm.maDanhMuc}</td>
                            <td class="fw-semibold"><c:out value="${dm.tenDanhMuc}"/></td>
                            <td><code><c:out value="${dm.duongDanUrl}"/></code></td>
                            <td class="text-truncate" style="max-width: 260px" title="<c:out value='${dm.moTa}'/>">
                                <c:out value="${dm.moTa}"/>
                            </td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${dm.dangHoatDong}"><span class="badge text-bg-success">Đang hoạt động</span></c:when>
                                    <c:otherwise><span class="badge text-bg-secondary">Ngừng hoạt động</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">${dm.soSanPham}</td>
                            <td class="text-nowrap"><c:out value="${dm.ngayTaoHienThi}"/></td>
                            <td class="text-center text-nowrap">
                                <c:url var="urlSua" value="/admin/danh-muc/sua">
                                    <c:param name="ma" value="${dm.maDanhMuc}"/>
                                </c:url>
                                <a class="btn btn-sm btn-outline-primary" href="${urlSua}">Sửa</a>
                                <%-- Xóa bằng POST; hộp thoại xác nhận đọc nội dung từ data-xac-nhan (đã escape) để tránh chèn mã vào JavaScript.
                                     Gửi kèm từ khóa và trang hiện tại để quay lại đúng chỗ sau khi xóa. --%>
                                <form method="post" action="${pageContext.request.contextPath}/admin/danh-muc/xoa" class="d-inline"
                                      data-xac-nhan="Xóa danh mục &quot;<c:out value='${dm.tenDanhMuc}'/>&quot;? Thao tác này không thể hoàn tác."
                                      onsubmit="return confirm(this.dataset.xacNhan);">
                                    <input type="hidden" name="maDanhMuc" value="${dm.maDanhMuc}">
                                    <input type="hidden" name="tuKhoa" value="<c:out value='${tuKhoa}'/>">
                                    <input type="hidden" name="trang" value="${trang}">
                                    <button type="submit" class="btn btn-sm btn-outline-danger"
                                            title="${dm.soSanPham > 0 ? 'Danh mục đang có sản phẩm - hệ thống sẽ không cho xóa' : 'Xóa danh mục'}">Xóa</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <%-- Phân trang: chỉ hiện khi có từ 2 trang trở lên; c:url tự mã hóa từ khóa tiếng Việt trên URL --%>
        <c:if test="${tongTrang > 1}">
            <nav class="mt-3" aria-label="Phân trang danh mục">
                <ul class="pagination flex-wrap">
                    <li class="page-item ${trang == 1 ? 'disabled' : ''}">
                        <c:url var="urlTruoc" value="/admin/danh-muc">
                            <c:param name="tuKhoa" value="${tuKhoa}"/>
                            <c:param name="trang" value="${trang - 1}"/>
                        </c:url>
                        <a class="page-link" href="${urlTruoc}">&laquo; Trước</a>
                    </li>
                    <c:forEach var="i" begin="1" end="${tongTrang}">
                        <c:url var="urlTrang" value="/admin/danh-muc">
                            <c:param name="tuKhoa" value="${tuKhoa}"/>
                            <c:param name="trang" value="${i}"/>
                        </c:url>
                        <li class="page-item ${i == trang ? 'active' : ''}">
                            <a class="page-link" href="${urlTrang}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${trang == tongTrang ? 'disabled' : ''}">
                        <c:url var="urlSau" value="/admin/danh-muc">
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
