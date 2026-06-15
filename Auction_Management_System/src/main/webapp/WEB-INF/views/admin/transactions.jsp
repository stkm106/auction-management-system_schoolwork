<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Transaction History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/dashboard.css" rel="stylesheet">
</head>
<body>
<div class="wrapper">
    <%@ include file="../shared/admin-sidebar.jsp" %>
    <div class="main-content">
        <h2>Transaction History</h2>
        <table class="table table-bordered bg-white">
            <thead><tr><th>ID</th><th>Item</th><th>User</th><th>Result</th><th>Date</th></tr></thead>
            <tbody>
            <c:forEach var="t" items="${transactions}">
                <tr>
                    <td>${t.transactionId}</td>
                    <td>${t.itemName}</td>
                    <td>${t.fullName}</td>
                    <td><span class="badge bg-success">${t.result}</span></td>
                    <td><fmt:formatDate value="${t.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
