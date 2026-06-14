<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Winners</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/dashboard.css" rel="stylesheet">
</head>
<body>
<div class="wrapper">
    <%@ include file="../shared/admin-sidebar.jsp" %>
    <div class="main-content">
        <h2>Người thắng</h2>
        <table class="table table-bordered bg-white">
            <thead><tr><th>Phiên đấu giá</th><th>Người thắng</th><th>Giá thắng</th><th>Ngày</th></tr></thead>
            <tbody>
            <c:forEach var="w" items="${winners}">
                <tr>
                    <td>${w.itemName}</td>
                    <td>${w.fullName}</td>
                    <td><tags:formatVnd value="${w.winningBid}"/></td>
                    <td><fmt:formatDate value="${w.announcedAt}" pattern="dd/MM/yyyy"/></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
