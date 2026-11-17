<%-- Form card đồ họa (bảng CardDoHoa) dùng chung cho thêm / sửa - T12.
     Dữ liệu do CardDoHoaServlet chuẩn bị: gpu, loi, cheDo, danhSachHang, danhSachLoai (mã -> nhãn). --%>
<%@ include file="/WEB-INF/views/admin/layout/header.jspf" %>
<c:set var="laSua" value="${cheDo == 'sua'}"/>

<nav aria-label="breadcrumb">
    <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/card-do-hoa">Card đồ họa</a></li>
        <li class="breadcrumb-item active" aria-current="page">${laSua ? 'Sửa card đồ họa' : 'Thêm card đồ họa'}</li>
    </ol>
</nav>

<h1 class="h3 mb-3">
    <c:choose>
        <c:when test="${laSua}">Sửa card đồ họa <span class="text-muted">#${gpu.maCardDoHoa}</span></c:when>
        <c:otherwise>Thêm card đồ họa</c:otherwise>
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
        Mã: <strong>${gpu.maCardDoHoa}</strong> &middot; Số sản phẩm đang dùng card này: <strong>${gpu.soSanPham}</strong>
    </div>
</c:if>

<div class="card">
    <div class="card-body">
        <form method="post" novalidate action="${pageContext.request.contextPath}/admin/card-do-hoa/${laSua ? 'sua' : 'them'}">
            <c:if test="${laSua}">
                <input type="hidden" name="maCardDoHoa" value="${gpu.maCardDoHoa}">
            </c:if>

            <div class="row g-3">
                <div class="col-md-6">
                    <label for="hangSanXuat" class="form-label">Hãng <span class="text-danger">*</span></label>
                    <select id="hangSanXuat" name="hangSanXuat" class="form-select ${not empty loi.hangSanXuat ? 'is-invalid' : ''}">
                        <option value="">-- Chọn hãng --</option>
                        <c:forEach var="hang" items="${danhSachHang}">
                            <option value="${hang}" ${hang == gpu.hangSanXuat ? 'selected' : ''}>${hang}</option>
                        </c:forEach>
                    </select>
                    <c:if test="${not empty loi.hangSanXuat}"><div class="invalid-feedback"><c:out value="${loi.hangSanXuat}"/></div></c:if>
                </div>

                <div class="col-md-6">
                    <label for="tenModel" class="form-label">Tên model <span class="text-danger">*</span></label>
                    <input type="text" id="tenModel" name="tenModel" maxlength="60" placeholder="VD: NVIDIA GeForce RTX 4060 8GB"
                           class="form-control ${not empty loi.tenModel ? 'is-invalid' : ''}" value="<c:out value='${gpu.tenModel}'/>">
                    <c:if test="${not empty loi.tenModel}"><div class="invalid-feedback"><c:out value="${loi.tenModel}"/></div></c:if>
                    <div class="form-text">Không trùng. Tối đa 60 ký tự, không dấu.</div>
                </div>

                <div class="col-md-6">
                    <label for="loaiCard" class="form-label">Loại card <span class="text-danger">*</span></label>
                    <select id="loaiCard" name="loaiCard" class="form-select ${not empty loi.loaiCard ? 'is-invalid' : ''}">
                        <option value="">-- Chọn loại --</option>
                        <c:forEach var="loai" items="${danhSachLoai}">
                            <option value="${loai.key}" ${loai.key == gpu.loaiCard ? 'selected' : ''}>${loai.value}</option>
                        </c:forEach>
                    </select>
                    <c:if test="${not empty loi.loaiCard}"><div class="invalid-feedback"><c:out value="${loi.loaiCard}"/></div></c:if>
                </div>

                <div class="col-md-6">
                    <label for="boNhoVramGB" class="form-label">VRAM (GB)</label>
                    <input type="text" inputmode="numeric" id="boNhoVramGB" name="boNhoVramGB" maxlength="3"
                           class="form-control ${not empty loi.boNhoVramGB ? 'is-invalid' : ''}"
                           value="<c:out value='${not empty loi.boNhoVramGB ? param.boNhoVramGB : gpu.boNhoVramGB}'/>">
                    <c:if test="${not empty loi.boNhoVramGB}"><div class="invalid-feedback"><c:out value="${loi.boNhoVramGB}"/></div></c:if>
                    <div class="form-text">Card <strong>rời</strong>: bắt buộc, 1 - 48. Card <strong>tích hợp</strong>: để trống (dùng chung RAM).</div>
                </div>
            </div>

            <div class="mt-4">
                <button type="submit" class="btn btn-primary">${laSua ? 'Lưu thay đổi' : 'Lưu'}</button>
                <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/card-do-hoa">Hủy</a>
            </div>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/views/admin/layout/footer.jspf" %>
