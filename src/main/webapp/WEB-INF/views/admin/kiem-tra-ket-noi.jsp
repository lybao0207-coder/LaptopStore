<%-- Trang TẠM THỜI kiểm tra kết nối CSDL (T2), hiển thị bằng layout Admin (T3). Dữ liệu do KiemTraKetNoiServlet chuẩn bị. --%>
<%@ include file="/WEB-INF/views/admin/layout/header.jspf" %>

<h1 class="h3 mb-3">Kiểm tra kết nối CSDL</h1>

<c:choose>
    <c:when test="${ketNoiThanhCong}">
        <div class="alert alert-success fw-bold">KẾT NỐI THÀNH CÔNG</div>
    </c:when>
    <c:otherwise>
        <div class="alert alert-danger fw-bold">KẾT NỐI THẤT BẠI</div>
    </c:otherwise>
</c:choose>

<div class="card">
    <div class="card-body p-0">
        <table class="table table-bordered table-striped mb-0">
            <tbody>
            <c:forEach var="dong" items="${thongTin}">
                <tr>
                    <th class="w-25"><c:out value="${dong.key}"/></th>
                    <td class="text-break"><c:out value="${dong.value}"/></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<c:if test="${not empty ketQuaDao}">
    <h2 class="h5 mt-4 mb-3">Kiểm tra DAO các bảng danh mục (T4, T9.1, T10-T12 - chỉ đọc, không ghi CSDL)</h2>
    <div class="card">
        <div class="card-body p-0">
            <table class="table table-bordered mb-0 align-middle">
                <thead class="table-light">
                <tr><th>Nội dung kiểm tra</th><th>Mong đợi</th><th>Thực tế</th><th>Kết quả</th></tr>
                </thead>
                <tbody>
                <c:forEach var="dongKq" items="${ketQuaDao}">
                    <tr>
                        <td><c:out value="${dongKq[0]}"/></td>
                        <td><c:out value="${dongKq[1]}"/></td>
                        <td class="text-break"><c:out value="${dongKq[2]}"/></td>
                        <td class="fw-bold ${dongKq[3] == 'ĐẠT' ? 'text-success' : (dongKq[3] == 'XEM' ? 'text-secondary' : 'text-danger')}">
                            <c:out value="${dongKq[3]}"/>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</c:if>

<c:if test="${not ketNoiThanhCong}">
    <p class="mt-3">Chi tiết đầy đủ nằm trong log của Tomcat (thư mục <code>logs</code>).</p>
</c:if>

<%@ include file="/WEB-INF/views/admin/layout/footer.jspf" %>
