<%-- Form thương hiệu dùng chung cho thêm (cheDo = "them") và sửa (cheDo = "sua") - T10.
     Dữ liệu do ThuongHieuServlet chuẩn bị: th, loi (map tên ô -> thông báo lỗi), cheDo.
     D30: không có ô nhập logo; khi sửa chỉ hiển thị đường dẫn logo hiện có. --%>
<%@ include file="/WEB-INF/views/admin/layout/header.jspf" %>
<c:set var="laSua" value="${cheDo == 'sua'}"/>

<nav aria-label="breadcrumb">
    <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/thuong-hieu">Thương hiệu</a></li>
        <li class="breadcrumb-item active" aria-current="page">${laSua ? 'Sửa thương hiệu' : 'Thêm thương hiệu'}</li>
    </ol>
</nav>

<h1 class="h3 mb-3">
    <c:choose>
        <c:when test="${laSua}">Sửa thương hiệu <span class="text-muted">#${th.maThuongHieu}</span></c:when>
        <c:otherwise>Thêm thương hiệu</c:otherwise>
    </c:choose>
</h1>

<c:if test="${not empty loi.chung}">
    <div class="alert alert-danger"><c:out value="${loi.chung}"/></div>
</c:if>
<c:if test="${not empty loi and empty loi.chung}">
    <div class="alert alert-warning">Dữ liệu chưa hợp lệ, vui lòng kiểm tra các ô được đánh dấu đỏ.</div>
</c:if>

<c:if test="${laSua}">
    <div class="alert alert-light border small">
        Mã: <strong>${th.maThuongHieu}</strong> &middot;
        Ngày tạo: <strong><c:out value="${th.ngayTaoHienThi}"/></strong> &middot;
        Số sản phẩm: <strong>${th.soSanPham}</strong> &middot;
        Logo: <strong><c:out value="${empty th.duongDanLogo ? '(chưa có)' : th.duongDanLogo}"/></strong>
        <span class="text-muted">(chưa hỗ trợ đổi logo)</span>
    </div>
</c:if>

<div class="card">
    <div class="card-body">
        <form method="post" novalidate
              action="${pageContext.request.contextPath}/admin/thuong-hieu/${laSua ? 'sua' : 'them'}">
            <c:if test="${laSua}">
                <input type="hidden" name="maThuongHieu" value="${th.maThuongHieu}">
            </c:if>

            <div class="mb-3">
                <label for="tenThuongHieu" class="form-label">Tên thương hiệu <span class="text-danger">*</span></label>
                <input type="text" id="tenThuongHieu" name="tenThuongHieu" maxlength="100" required
                       class="form-control ${not empty loi.tenThuongHieu ? 'is-invalid' : ''}"
                       value="<c:out value='${th.tenThuongHieu}'/>">
                <c:if test="${not empty loi.tenThuongHieu}">
                    <div class="invalid-feedback"><c:out value="${loi.tenThuongHieu}"/></div>
                </c:if>
                <div class="form-text">Từ 2 đến 100 ký tự, không trùng với thương hiệu đã có.</div>
            </div>

            <div class="mb-3">
                <label for="duongDanUrl" class="form-label">Đường dẫn URL</label>
                <input type="text" id="duongDanUrl" name="duongDanUrl" maxlength="120"
                       class="form-control ${not empty loi.duongDanUrl ? 'is-invalid' : ''}"
                       placeholder="Để trống để tự tạo từ tên, VD: dell"
                       value="<c:out value='${th.duongDanUrl}'/>">
                <c:if test="${not empty loi.duongDanUrl}">
                    <div class="invalid-feedback"><c:out value="${loi.duongDanUrl}"/></div>
                </c:if>
                <div class="form-text">Chỉ gồm a-z, 0-9 và dấu -, tối đa 120 ký tự, không trùng.</div>
            </div>

            <div class="mb-3">
                <label for="quocGia" class="form-label">Quốc gia</label>
                <input type="text" id="quocGia" name="quocGia" maxlength="50"
                       class="form-control ${not empty loi.quocGia ? 'is-invalid' : ''}"
                       placeholder="VD: Mỹ, Đài Loan" value="<c:out value='${th.quocGia}'/>">
                <c:if test="${not empty loi.quocGia}">
                    <div class="invalid-feedback"><c:out value="${loi.quocGia}"/></div>
                </c:if>
                <div class="form-text">Không bắt buộc, tối đa 50 ký tự.</div>
            </div>

            <div class="form-check mb-1">
                <input class="form-check-input" type="checkbox" id="dangHoatDong" name="dangHoatDong" value="1"
                       ${th.dangHoatDong ? 'checked' : ''}>
                <label class="form-check-label" for="dangHoatDong">Đang hoạt động</label>
            </div>
            <div class="form-text mb-4">
                Bỏ chọn để chuyển sang "Ngừng hoạt động" (không xóa dữ liệu; thương hiệu không còn trong combo box chọn mới).
            </div>

            <button type="submit" class="btn btn-primary">${laSua ? 'Lưu thay đổi' : 'Lưu'}</button>
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/thuong-hieu">Hủy</a>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/views/admin/layout/footer.jspf" %>
