<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="pageTitle" value="Lịch sử bid"/>
<%@ include file="../shared/header.jsp" %>
<section class="page-section">
<h2 style="color:var(--navy);margin-bottom:25px">Lịch sử đặt giá & tiền cọc</h2>
<table class="data-table" style="margin-bottom:30px">
<thead><tr><th>Sản phẩm</th><th>Số tiền</th><th>Thời gian</th></tr></thead>
<tbody><c:forEach var="b" items="${bids}">
<tr><td>${b.productName}</td><td><tags:formatVnd value="${b.bidAmount}"/></td>
<td><fmt:formatDate value="${b.bidTime}" pattern="dd/MM/yyyy HH:mm"/></td></tr></c:forEach></tbody></table>
<h3 style="margin-bottom:15px">Tiền cọc</h3>
<table class="data-table"><thead><tr><th>Sản phẩm</th><th>Số tiền</th><th>Trạng thái</th></tr></thead>
<tbody><c:forEach var="d" items="${deposits}">
<tr><td>${d.productName}</td><td><tags:formatVnd value="${d.depositAmount}"/></td><td>${d.status}</td></tr>
</c:forEach></tbody></table></section>
<%@ include file="../shared/footer.jsp" %>
