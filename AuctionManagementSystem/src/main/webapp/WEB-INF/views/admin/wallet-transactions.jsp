<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Giao dịch ví</title>
    <link href="${pageContext.request.contextPath}/css/auctionpro.css" rel="stylesheet"/>
</head>
<body>
<div class="admin-wrap">
    <%@ include file="../shared/admin-sidebar.jsp" %>
    <div class="admin-main">
        <h1>Giao dịch ví toàn hệ thống</h1>
        <table class="data-table">
            <thead><tr><th>Loại</th><th>Số tiền</th><th>Mô tả</th><th>Thời gian</th></tr></thead>
            <tbody>
            <c:forEach var="t" items="${transactions}">
                <tr>
                    <td>${t.transactionType}</td>
                    <td><tags:formatVnd value="${t.amount}"/></td>
                    <td>${t.description}</td>
                    <td><fmt:formatDate value="${t.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
