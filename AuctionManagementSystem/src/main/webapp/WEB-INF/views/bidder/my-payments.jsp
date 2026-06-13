<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="pageTitle" value="Thanh toán"/>
<%@ include file="../shared/header.jsp" %>
<section class="page-section">
<h2 style="color:var(--navy)">Thanh toán của tôi</h2>
<c:if test="${param.success == '1'}"><div class="alert-success">Thanh toán thành công!</div></c:if>
<c:if test="${not empty param.error}"><div class="alert-danger">${param.error}</div></c:if>
<table class="data-table">
<thead><tr><th>Sản phẩm</th><th>Tổng tiền</th><th>Cọc đã dùng</th><th>Phí sàn</th><th>Trạng thái</th><th></th></tr></thead>
<tbody><c:forEach var="p" items="${payments}">
<tr>
<td>${p.productName}</td>
<td><tags:formatVnd value="${p.amount}"/></td>
<td><tags:formatVnd value="${p.depositUsed}"/></td>
<td><tags:formatVnd value="${p.platformFee}"/></td>
<td>${p.status}</td>
<td><c:if test="${p.status == 'PENDING'}">
<form method="post" action="${pageContext.request.contextPath}/payment/pay"><input type="hidden" name="paymentId" value="${p.paymentId}">
<button class="btn btn-register" style="border:none;cursor:pointer">Thanh toán</button></form></c:if></td>
</tr>
</c:forEach></tbody></table></section>
<%@ include file="../shared/footer.jsp" %>
