<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="adminTitle" value="Lượt đặt giá"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<%@ include file="../shared/admin-head.jsp" %>
</head>
<body>
<div class="admin-wrap">
    <%@ include file="../shared/admin-sidebar.jsp" %>
    <div class="admin-main">
        <h1 class="admin-page-title"><i class="fa-solid fa-hand-holding-dollar"></i> Hoạt động đặt giá</h1>
        <div class="admin-table-wrap">
        <table class="data-table">
            <thead><tr><th>ID</th><th>Sản phẩm</th><th>Người đặt giá</th><th>Số tiền</th><th>Thời gian</th></tr></thead>
            <tbody>
            <c:forEach var="b" items="${bids}">
                <tr>
                    <td>${b.bidId}</td>
                    <td><strong>${b.productName}</strong></td>
                    <td>${b.bidderName}</td>
                    <td><tags:formatVnd value="${b.bidAmount}"/></td>
                    <td><fmt:formatDate value="${b.bidTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        </div>
    </div>
</div>
</body>
</html>
