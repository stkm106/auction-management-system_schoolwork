<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="page-header">
    <div>
        <h1>Thanh toán của tôi</h1>
        <div class="breadcrumb-custom">Tài khoản &gt; Thanh toán của tôi</div>
    </div>
</div>

<c:if test="${not empty success}">
    <div class="alert alert-success">${success}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<div class="data-table-wrap">
    <table class="table data-table mb-0">
        <thead>
        <tr>
            <th>Mã</th>
            <th>Phiên đấu giá</th>
            <th>Tổng giá thắng</th>
            <th>Đã cọc</th>
            <th>Còn phải trả</th>
            <th>Hạn thanh toán</th>
            <th>Trạng thái</th>
            <th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="p" items="${payments}">
            <tr>
                <td>${p.paymentID}</td>
                <td>#${p.auctionID}</td>
                <td>
                    <fmt:formatNumber value="${not empty p.totalAmount ? p.totalAmount : p.amount}" groupingUsed="true"/> &#8363;
                </td>
                <td><fmt:formatNumber value="${p.depositAmount != null ? p.depositAmount : 0}" groupingUsed="true"/> &#8363;</td>
                <td class="price-gold"><fmt:formatNumber value="${p.amount}" groupingUsed="true"/> &#8363;</td>
                <td>
                    <c:choose>
                        <c:when test="${not empty p.dueDate}">
                            <fmt:formatDate value="${p.dueDate}" pattern="dd/MM/yyyy HH:mm"/>
                        </c:when>
                        <c:otherwise>-</c:otherwise>
                    </c:choose>
                </td>
                <td>${p.status}</td>
                <td>
                    <a href="${ctx}/payments/my-payments/detail/${p.paymentID}" class="btn btn-sm btn-outline-primary" title="Chi tiết">Chi tiết</a>
                    <c:if test="${p.status == 'Pending' and p.amount == 0}">
                        <span class="small text-muted">Đã trừ đủ qua tiền cọc</span>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty payments}">
            <tr>
                <td colspan="8" class="text-center text-muted py-4">Chưa có giao dịch thanh toán.</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>
