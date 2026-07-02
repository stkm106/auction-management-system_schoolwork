<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="page-header">
    <div>
        <h1>Giá đã đặt</h1>
        <div class="breadcrumb-custom">Tài khoản &gt; Giá đã đặt</div>
    </div>
</div>

<div class="data-table-wrap">
    <table class="table data-table mb-0">
        <thead>
        <tr>
            <th>Mã giá</th>
            <th>Phiên đấu giá</th>
            <th>Số tiền</th>
            <th>Thời gian</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="b" items="${bids}">
            <tr>
                <td>${b.bidID}</td>
                <td>
                    <a href="${ctx}/auctions/detail/${b.auctionID}">#${b.auctionID}</a>
                </td>
                <td><fmt:formatNumber value="${b.bidAmount}" groupingUsed="true"/> &#8363;</td>
                <td><fmt:formatDate value="${b.bidTime}" pattern="dd/MM/yyyy HH:mm"/></td>
            </tr>
        </c:forEach>
        <c:if test="${empty bids}">
            <tr>
                <td colspan="4" class="text-center text-muted py-4">Bạn chưa đặt giá nào.</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>
