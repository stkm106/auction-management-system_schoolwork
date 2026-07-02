<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<footer class="public-footer">
    <div class="container d-flex flex-wrap justify-content-between align-items-center gap-2">
        <span>&copy; 2026 AuctionPro. Mọi quyền được bảo lưu.</span>
        <span>
            <a href="#" class="text-white-50 me-2">Chính sách bảo mật</a> |
            <a href="#" class="text-white-50 mx-2">Điều khoản sử dụng</a> |
            <a href="#" class="text-white-50 ms-2">Hỗ trợ</a>
        </span>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${ctx}/resources/js/script.js"></script>

<c:if test="${closeDocument != false}">
    </body>
    </html>
</c:if>
