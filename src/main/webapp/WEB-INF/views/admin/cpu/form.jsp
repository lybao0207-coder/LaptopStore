<%-- Form CPU (bảng BoXuLy) dùng chung cho thêm / sửa - T11.
     Dữ liệu do BoXuLyServlet chuẩn bị: cpu, loi, cheDo, danhSachHang.
     Ô số bị lỗi: hiển thị lại đúng giá trị người dùng vừa gõ (param.*) để họ sửa. --%>
<%@ include file="/WEB-INF/views/admin/layout/header.jspf" %>
<c:set var="laSua" value="${cheDo == 'sua'}"/>

<nav aria-label="breadcrumb">
    <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/cpu">CPU</a></li>
        <li class="breadcrumb-item active" aria-current="page">${laSua ? 'Sửa CPU' : 'Thêm CPU'}</li>
    </ol>
</nav>

<h1 class="h3 mb-3">
    <c:choose>
        <c:when test="${laSua}">Sửa CPU <span class="text-muted">#${cpu.maBoXuLy}</span></c:when>
        <c:otherwise>Thêm CPU</c:otherwise>
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
        Mã: <strong>${cpu.maBoXuLy}</strong> &middot; Số sản phẩm đang dùng CPU này: <strong>${cpu.soSanPham}</strong>
    </div>
</c:if>

<div class="card">
    <div class="card-body">
        <form method="post" novalidate action="${pageContext.request.contextPath}/admin/cpu/${laSua ? 'sua' : 'them'}">
            <c:if test="${laSua}">
                <input type="hidden" name="maBoXuLy" value="${cpu.maBoXuLy}">
            </c:if>

            <div class="row g-3">
                <div class="col-md-4">
                    <label for="hangSanXuat" class="form-label">Hãng <span class="text-danger">*</span></label>
                    <select id="hangSanXuat" name="hangSanXuat" class="form-select ${not empty loi.hangSanXuat ? 'is-invalid' : ''}">
                        <option value="">-- Chọn hãng --</option>
                        <c:forEach var="hang" items="${danhSachHang}">
                            <option value="${hang}" ${hang == cpu.hangSanXuat ? 'selected' : ''}>${hang}</option>
                        </c:forEach>
                    </select>
                    <c:if test="${not empty loi.hangSanXuat}"><div class="invalid-feedback"><c:out value="${loi.hangSanXuat}"/></div></c:if>
                </div>

                <div class="col-md-4">
                    <label for="dongChip" class="form-label">Dòng chip <span class="text-danger">*</span></label>
                    <input type="text" id="dongChip" name="dongChip" maxlength="30" placeholder="VD: Core i5, Ryzen 7"
                           class="form-control ${not empty loi.dongChip ? 'is-invalid' : ''}" value="<c:out value='${cpu.dongChip}'/>">
                    <c:if test="${not empty loi.dongChip}"><div class="invalid-feedback"><c:out value="${loi.dongChip}"/></div></c:if>
                    <div class="form-text">Dùng cho bộ lọc CPU. Tối đa 30 ký tự, không dấu.</div>
                </div>

                <div class="col-md-4">
                    <label for="tenModel" class="form-label">Tên model <span class="text-danger">*</span></label>
                    <input type="text" id="tenModel" name="tenModel" maxlength="50" placeholder="VD: Core i5-1335U"
                           class="form-control ${not empty loi.tenModel ? 'is-invalid' : ''}" value="<c:out value='${cpu.tenModel}'/>">
                    <c:if test="${not empty loi.tenModel}"><div class="invalid-feedback"><c:out value="${loi.tenModel}"/></div></c:if>
                    <div class="form-text">Không trùng. Tối đa 50 ký tự, không dấu.</div>
                </div>

                <div class="col-md-4">
                    <label for="soNhan" class="form-label">Số nhân <span class="text-danger">*</span></label>
                    <input type="text" inputmode="numeric" id="soNhan" name="soNhan" maxlength="3"
                           class="form-control ${not empty loi.soNhan ? 'is-invalid' : ''}"
                           value="<c:out value='${not empty loi.soNhan ? param.soNhan : cpu.soNhan}'/>">
                    <c:if test="${not empty loi.soNhan}"><div class="invalid-feedback"><c:out value="${loi.soNhan}"/></div></c:if>
                    <div class="form-text">1 - 64.</div>
                </div>

                <div class="col-md-4">
                    <label for="soLuongLuong" class="form-label">Số luồng <span class="text-danger">*</span></label>
                    <input type="text" inputmode="numeric" id="soLuongLuong" name="soLuongLuong" maxlength="3"
                           class="form-control ${not empty loi.soLuongLuong ? 'is-invalid' : ''}"
                           value="<c:out value='${not empty loi.soLuongLuong ? param.soLuongLuong : cpu.soLuongLuong}'/>">
                    <c:if test="${not empty loi.soLuongLuong}"><div class="invalid-feedback"><c:out value="${loi.soLuongLuong}"/></div></c:if>
                    <div class="form-text">Lớn hơn hoặc bằng số nhân, tối đa 128.</div>
                </div>

                <div class="col-md-4">
                    <label for="xungNhipToiDaGHz" class="form-label">Xung nhịp tối đa (GHz)</label>
                    <input type="text" inputmode="decimal" id="xungNhipToiDaGHz" name="xungNhipToiDaGHz" maxlength="4" placeholder="VD: 4.5"
                           class="form-control ${not empty loi.xungNhipToiDaGHz ? 'is-invalid' : ''}"
                           value="<c:out value='${not empty loi.xungNhipToiDaGHz ? param.xungNhipToiDaGHz : cpu.xungNhipToiDaGHz}'/>">
                    <c:if test="${not empty loi.xungNhipToiDaGHz}"><div class="invalid-feedback"><c:out value="${loi.xungNhipToiDaGHz}"/></div></c:if>
                    <div class="form-text">Không bắt buộc, 1 - 7, tối đa 2 chữ số thập phân.</div>
                </div>
            </div>

            <div class="mt-4">
                <button type="submit" class="btn btn-primary">${laSua ? 'Lưu thay đổi' : 'Lưu'}</button>
                <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/cpu">Hủy</a>
            </div>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/views/admin/layout/footer.jspf" %>
