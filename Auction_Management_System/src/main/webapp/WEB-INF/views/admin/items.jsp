<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Items</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/dashboard.css" rel="stylesheet">
</head>
<body>
<div class="wrapper">
    <%@ include file="../shared/admin-sidebar.jsp" %>
    <div class="main-content">
        <div class="d-flex justify-content-between mb-3">
            <h2>Items</h2>
            <a href="${pageContext.request.contextPath}/admin/items/form" class="btn btn-primary">Add Item</a>
        </div>
        <table class="table table-bordered bg-white">
            <thead><tr><th>ID</th><th>Name</th><th>Start</th><th>Current</th><th>Image</th></tr></thead>
            <tbody>
            <c:forEach var="i" items="${items}">
                <tr>
                    <td>${i.itemId}</td>
                    <td>${i.itemName}</td>
                    <td><tags:formatVnd value="${i.startPrice}"/></td>
                    <td><tags:formatVnd value="${i.currentPrice}"/></td>
                    <td>${i.image}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
