<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bids</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/dashboard.css" rel="stylesheet">
</head>
<body>
<div class="wrapper">
    <%@ include file="../shared/admin-sidebar.jsp" %>
    <div class="main-content">
        <h2>Hoạt động đặt giá</h2>
        <table class="table table-bordered bg-white">
            <thead><tr><th>ID</th><th>Sản phẩm</th><th>Người bid</th><th>Số tiền</th><th>Thời gian</th></tr></thead>
            <tbody>
            <c:forEach var="b" items="${bids}">
                <tr>
                    <td>${b.bidId}</td>
                    <td>${b.productName}</td>
                    <td>${b.bidderName}</td>
                    <td><tags:formatVnd value="${b.bidAmount}"/></td>
                    <td><fmt:formatDate value="${b.bidTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
