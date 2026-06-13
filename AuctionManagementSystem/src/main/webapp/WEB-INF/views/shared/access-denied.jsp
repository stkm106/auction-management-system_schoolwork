<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<div class="container mt-5 text-center">
    <h2>Access Denied</h2>
    <p>You do not have permission to view this page.</p>
    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Go Home</a>
</div>
<%@ include file="footer.jsp" %>
