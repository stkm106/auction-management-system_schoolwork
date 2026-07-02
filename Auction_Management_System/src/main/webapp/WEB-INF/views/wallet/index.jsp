<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="page-header">
    <div>
        <h1>Quản lý ví người dùng</h1>
        <div class="breadcrumb-custom">Trang chủ &gt; Quản lý ví</div>
    </div>
    <div class="d-flex gap-2">
        <button class="btn btn-outline-secondary btn-sm">Xuất Excel</button>
        <a href="${ctx}/wallet/deposit" class="btn btn-gold btn-sm">+ Nạp tiền</a>
    </div>
</div>

<div class="row g-3 mb-4">
    <div class="col-md-3 col-6">
        <div class="kpi-card">
            <div class="kpi-label">Số dư hiện tại</div>
            <div class="kpi-value text-success"><fmt:formatNumber value="${wallet.balance}" groupingUsed="true" maxFractionDigits="0"/> &#8363;</div>
        </div>
    </div>
    <div class="col-md-3 col-6">
        <div class="kpi-card">
            <div class="kpi-label">Trạng thái ví</div>
            <div class="kpi-value" style="font-size:1.1rem">Hoạt động</div>
        </div>
    </div>
    <div class="col-md-3 col-6">
        <div class="kpi-card">
            <div class="kpi-label">Giao dịch đấu giá tháng</div>
            <div class="kpi-value"><fmt:formatNumber value="${monthlyTransactionCount}" groupingUsed="true" maxFractionDigits="0"/></div>
        </div>
    </div>
    <div class="col-md-3 col-6">
        <div class="kpi-card">
            <div class="kpi-label">Số dư khóa</div>
            <div class="kpi-value"><fmt:formatNumber value="0" groupingUsed="true" maxFractionDigits="0"/> &#8363;</div>
        </div>
    </div>
</div>

<div class="detail-card text-center py-5 mb-4">
    <p class="text-muted mb-2">Số dư khả dụng</p>
    <h1 class="price-gold mb-4" style="font-size:2.5rem"><fmt:formatNumber value="${wallet.balance}" groupingUsed="true" maxFractionDigits="0"/> &#8363;</h1>
    <a href="${ctx}/wallet/deposit" class="btn btn-gold px-4">Nạp tiền vào ví</a>
</div>

<c:if test="${not empty transactions}">
    <div class="detail-card">
        <h5 class="mb-3">Lịch sử biến động ví</h5>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th>Thời gian</th>
                    <th>Loại</th>
                    <th class="text-end">Số tiền</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="tx" items="${transactions}">
                    <tr>
                        <td><fmt:formatDate value="${tx.transactionDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${tx.transactionType == 'Deposit'}">Nạp tiền</c:when>
                                <c:when test="${tx.transactionType == 'Payment'}">Thanh toán / Cọc đấu giá</c:when>
                                <c:when test="${tx.transactionType == 'Sale'}">Doanh thu bán hàng</c:when>
                                <c:when test="${tx.transactionType == 'Refund'}">Hoàn tiền cọc</c:when>
                                <c:otherwise>${tx.transactionType}</c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-end">
                            <fmt:formatNumber value="${tx.amount}" groupingUsed="true" maxFractionDigits="0"/> &#8363;
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</c:if>
