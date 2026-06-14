<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="pageTitle" value="Ví"/>
<%@ include file="../shared/header.jsp" %>

<section class="page-section">
    <div class="section-title"><h2>Ví điện tử</h2><p>Nạp tiền, theo dõi số dư và lịch sử giao dịch</p></div>

    <c:if test="${param.success == '1'}"><div class="alert-success">Nạp tiền thành công!</div></c:if>
    <c:if test="${not empty param.error}"><div class="alert-danger">${param.error}</div></c:if>

    <div class="wallet-cards">
        <div class="wallet-card"><p>Số dư khả dụng</p><h3><tags:formatVnd value="${wallet.balance}"/></h3></div>
        <div class="wallet-card"><p>Đang khóa (cọc)</p><h3><tags:formatVnd value="${wallet.lockedBalance}"/></h3></div>
        <div class="wallet-card"><p>Tổng</p><h3><tags:formatVnd value="${wallet.balance + wallet.lockedBalance}"/></h3></div>
    </div>

    <div class="form-card" style="max-width:480px;margin-bottom:30px">
        <div class="form-card-header">
            <h3><i class="fa-solid fa-circle-plus"></i> Nạp tiền vào ví</h3>
            <p>Số tiền nạp tối thiểu 1.000 ₫</p>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/wallet/topup">
            <div class="form-group">
                <label class="form-label" for="amount"><i class="fa-solid fa-coins"></i> Số tiền (VND)</label>
                <input class="form-control" id="amount" type="number" step="1000" min="1000" name="amount" placeholder="VD: 1000000" required>
            </div>
            <div class="form-actions" style="margin-top:16px">
                <button class="btn-navy" type="submit"><i class="fa-solid fa-wallet"></i> Nạp tiền</button>
            </div>
        </form>
    </div>

    <div class="form-card">
        <div class="form-card-header">
            <h3><i class="fa-solid fa-list"></i> Lịch sử giao dịch</h3>
            <p>Tất cả giao dịch nạp tiền, cọc, thanh toán</p>
        </div>
        <table class="data-table">
            <thead><tr><th>Loại</th><th>Số tiền</th><th>Mô tả</th><th>Ngày</th></tr></thead>
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
            <c:if test="${empty transactions}">
                <tr><td colspan="4" style="text-align:center;color:#999;padding:24px">Chưa có giao dịch</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</section>

<%@ include file="../shared/footer.jsp" %>
