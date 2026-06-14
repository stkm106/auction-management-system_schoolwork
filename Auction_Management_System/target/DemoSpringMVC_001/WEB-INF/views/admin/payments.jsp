<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="adminTitle" value="Thanh toán"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<%@ include file="../shared/admin-head.jsp" %>
</head>
<body>
<div class="admin-wrap">
    <%@ include file="../shared/admin-sidebar.jsp" %>
    <div class="admin-main">
        <h1 class="admin-page-title"><i class="fa-solid fa-credit-card"></i> Thanh toán</h1>
        <table class="data-table">
            <thead><tr><th>ID</th><th>Sản phẩm</th><th>Người mua</th><th>Số tiền</th><th>Phí sàn</th><th>Trạng thái</th></tr></thead>
            <tbody>
            <c:forEach var="p" items="${payments}">
                <tr>
                    <td><a href="${pageContext.request.contextPath}/invoice?id=${p.paymentId}" style="color:var(--gold);font-weight:600">#${p.paymentId}</a></td>
                    <td><strong>${p.productName}</strong></td>
                    <td>${p.buyerName}</td>
                    <td><tags:formatVnd value="${p.amount}"/></td>
                    <td><tags:formatVnd value="${p.platformFee}"/></td>
                    <td>
                        <span class="badge ${p.status == 'PAID' ? 'badge-active' : p.status == 'FAILED' ? 'badge-rejected' : 'badge-pending'}">
                            <c:choose>
                                <c:when test="${p.status == 'PENDING'}">Chờ thanh toán</c:when>
                                <c:when test="${p.status == 'PAID'}">Đã thanh toán</c:when>
                                <c:when test="${p.status == 'FAILED'}">Thất bại</c:when>
                                <c:otherwise>${p.status}</c:otherwise>
                            </c:choose>
                        </span>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
