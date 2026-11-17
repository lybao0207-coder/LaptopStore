<%-- Form danh mục dùng chung cho thêm (T6, cheDo = "them") và sửa (T7, cheDo = "sua").
     Dữ liệu do DanhMucServlet chuẩn bị: dm (dữ liệu đang nhập / hiện tại), loi (map tên ô -> thông báo lỗi), cheDo. --%>
<%@ include file="/WEB-INF/views/admin/layout/header.jspf" %>
<c:set var="laSua" value="${cheDo == 'sua'}"/>

<nav aria-label="breadcrumb">
    <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/danh-muc">Danh mục</a></li>
        <li class="breadcrumb-item active" aria-current="page">${laSua ? 'Sửa danh mục' : 'Thêm danh mục'}</li>
    </ol>
</nav>

<h1 class="h3 mb-3">
    <c:choose>
        <c:when test="${laSua}">Sửa danh mục <span class="text-muted">#${dm.maDanhMuc}</span></c:when>
        <c:otherwise>Thêm danh mục</c:otherwise>
    </c:choose>
</h1>

<c:if test="${not empty loi.chung}">
    <div class="alert alert-danger"><c:out value="${loi.chung}"/></div>
</c:if>
<c:if test="${not empty loi and empty loi.chung}">
    <div class="alert alert-warning">Dữ liệu chưa hợp lệ, vui lòng kiểm tra các ô được đánh dấu đỏ.</div>
</c:if>

<%-- Thông tin chỉ đọc khi sửa: mã và ngày tạo do DB quản lý, không cho sửa --%>
<c:if test="${laSua}">
    <div class="alert alert-light border small">
        Mã: <strong>${dm.maDanhMuc}</strong> &middot;
        Ngày tạo: <strong><c:out value="${dm.ngayTaoHienThi}"/></strong> &middot;
        Số sản phẩm thuộc danh mục: <strong>${dm.soSanPham}</strong>
    </div>
</c:if>

<div class="card">
    <div class="card-body">
        <form method="post" novalidate
              action="${pageContext.request.contextPath}/admin/danh-muc/${laSua ? 'sua' : 'them'}">
            <c:if test="${laSua}">
                <input type="hidden" name="maDanhMuc" value="${dm.maDanhMuc}">
            </c:if>

            <div class="mb-3">
                <label for="tenDanhMuc" class="form-label">Tên danh mục <span class="text-danger">*</span></label>
                <input type="text" id="tenDanhMuc" name="tenDanhMuc" maxlength="100" required
                       class="form-control ${not empty loi.tenDanhMuc ? 'is-invalid' : ''}"
                       value="<c:out value='${dm.tenDanhMuc}'/>">
                <c:if test="${not empty loi.tenDanhMuc}">
                    <div class="invalid-feedback"><c:out value="${loi.tenDanhMuc}"/></div>
                </c:if>
                <div class="form-text">Từ 2 đến 100 ký tự, không trùng với danh mục đã có.</div>
            </div>

            <div class="mb-3">
                <label for="duongDanUrl" class="form-label">Đường dẫn URL</label>
                <input type="text" id="duongDanUrl" name="duongDanUrl" maxlength="120"
                       class="form-control ${not empty loi.duongDanUrl ? 'is-invalid' : ''}"
                       placeholder="Để trống để tự tạo từ tên, VD: do-hoa-ky-thuat"
                       value="<c:out value='${dm.duongDanUrl}'/>">
                <c:if test="${not empty loi.duongDanUrl}">
                    <div class="invalid-feedback"><c:out value="${loi.duongDanUrl}"/></div>
                </c:if>
                <div class="form-text">Chỉ gồm a-z, 0-9 và dấu -, tối đa 120 ký tự, không trùng.</div>
            </div>

            <div class="mb-3">
                <label for="moTa" class="form-label">Mô tả</label>
                <textarea id="moTa" name="moTa" rows="3" maxlength="500"
                          class="form-control ${not empty loi.moTa ? 'is-invalid' : ''}"><c:out value="${dm.moTa}"/></textarea>
                <c:if test="${not empty loi.moTa}">
                    <div class="invalid-feedback"><c:out value="${loi.moTa}"/></div>
                </c:if>
                <div class="form-text">Không bắt buộc, tối đa 500 ký tự.</div>
            </div>

            <div class="form-check mb-1">
                <input class="form-check-input" type="checkbox" id="dangHoatDong" name="dangHoatDong" value="1"
                       ${dm.dangHoatDong ? 'checked' : ''}>
                <label class="form-check-label" for="dangHoatDong">Đang hoạt động</label>
            </div>
            <div class="form-text mb-4">
                Bỏ chọn để chuyển danh mục sang "Ngừng hoạt động" (không xóa dữ liệu, sản phẩm vẫn giữ nguyên).
            </div>

            <button type="submit" class="btn btn-primary">${laSua ? 'Lưu thay đổi' : 'Lưu'}</button>
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/danh-muc">Hủy</a>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/views/admin/layout/footer.jspf" %>
