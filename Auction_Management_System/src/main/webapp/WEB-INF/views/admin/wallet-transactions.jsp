<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="adminTitle" value="Giao dịch ví"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<%@ include file="../shared/admin-head.jsp" %>
</head>
<body>
<div class="admin-wrap">
    <%@ include file="../shared/admin-sidebar.jsp" %>
    <div class="admin-main">
        <h1 class="admin-page-title"><i class="fa-solid fa-wallet"></i> Giao dịch ví toàn hệ thống</h1>
        <table class="data-table">
            <thead><tr><th>Loại</th><th>Số tiền</th><th>Mô tả</th><th>Thời gian</th></tr></thead>
            <tbody>
            <c:forEach var="t" items="${transactions}">
                <tr>
                    <td>
                        <c:choose>
                            <c:when test="${t.transactionType == 'TOP_UP'}">Nạp tiền</c:when>
                            <c:when test="${t.transactionType == 'DEPOSIT_LOCK'}">Khóa cọc</c:when>
                            <c:when test="${t.transactionType == 'DEPOSIT_REFUND'}">Hoàn cọc</c:when>
                            <c:when test="${t.transactionType == 'DEPOSIT_FORFEIT'}">Mất cọc</c:when>
                            <c:when test="${t.transactionType == 'PAYMENT'}">Thanh toán</c:when>
                            <c:when test="${t.transactionType == 'SALE_INCOME'}">Thu nhập bán</c:when>
                            <c:when test="${t.transactionType == 'PLATFORM_FEE'}">Phí sàn</c:when>
                            <c:otherwise>${t.transactionType}</c:otherwise>
                        </c:choose>
                    </td>
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
