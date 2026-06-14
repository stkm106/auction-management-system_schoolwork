<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="pageTitle" value="Lịch sử đặt giá"/>
<%@ include file="../shared/header.jsp" %>
<section class="page-section">
<h2 style="color:var(--navy);margin-bottom:25px">Lịch sử đặt giá &amp; tiền cọc</h2>
<table class="data-table" style="margin-bottom:30px">
<thead><tr><th>Sản phẩm</th><th>Số tiền</th><th>Thời gian</th></tr></thead>
<tbody><c:forEach var="b" items="${bids}">
<tr><td>${b.productName}</td><td><tags:formatVnd value="${b.bidAmount}"/></td>
<td><fmt:formatDate value="${b.bidTime}" pattern="dd/MM/yyyy HH:mm"/></td></tr></c:forEach></tbody></table>
<h3 style="margin-bottom:15px">Tiền cọc</h3>
<table class="data-table"><thead><tr><th>Sản phẩm</th><th>Số tiền</th><th>Trạng thái</th></tr></thead>
<tbody><c:forEach var="d" items="${deposits}">
<tr><td>${d.productName}</td><td><tags:formatVnd value="${d.depositAmount}"/></td><td>
    <c:choose>
        <c:when test="${d.status == 'LOCKED'}">Đang khóa</c:when>
        <c:when test="${d.status == 'REFUNDED'}">Đã hoàn</c:when>
        <c:when test="${d.status == 'USED_FOR_PAYMENT'}">Đã dùng thanh toán</c:when>
        <c:when test="${d.status == 'FORFEITED'}">Đã mất cọc</c:when>
        <c:otherwise>${d.status}</c:otherwise>
    </c:choose>
</td></tr>
</c:forEach></tbody></table></section>
<%@ include file="../shared/footer.jsp" %>
