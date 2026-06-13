<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payments</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/dashboard.css" rel="stylesheet">
</head>
<body>
<div class="wrapper">
    <%@ include file="../shared/admin-sidebar.jsp" %>
    <div class="main-content">
        <h2>Thanh toán</h2>
        <table class="table table-bordered bg-white">
            <thead><tr><th>ID</th><th>Sản phẩm</th><th>Người mua</th><th>Số tiền</th><th>Phí sàn</th><th>Trạng thái</th></tr></thead>
            <tbody>
            <c:forEach var="p" items="${payments}">
                <tr>
                    <td><a href="${pageContext.request.contextPath}/invoice?id=${p.paymentId}">#${p.paymentId}</a></td>
                    <td>${p.productName}</td>
                    <td>${p.buyerName}</td>
                    <td><tags:formatVnd value="${p.amount}"/></td>
                    <td><tags:formatVnd value="${p.platformFee}"/></td>
                    <td>${p.status}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
