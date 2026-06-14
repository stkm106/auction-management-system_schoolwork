<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="pageTitle" value="${auction.productName}"/>
<%@ include file="../shared/header.jsp" %>

<section class="page-section">
    <c:if test="${param.success == '1'}"><div class="alert-success">Đặt giá thành công!</div></c:if>
    <c:if test="${param.deposit == '1'}"><div class="alert-success">Đã khóa tiền cọc!</div></c:if>
    <c:if test="${not empty param.error}"><div class="alert-danger">${param.error}</div></c:if>

    <div class="detail-grid">
        <div class="detail-card">
            <img src="${auction.primaryImage}" style="width:100%;border-radius:16px" alt="${auction.productName}" onerror="this.src='https://via.placeholder.com/500'">
        </div>
        <div class="detail-card">
            <span class="badge badge-active">
                <c:choose>
                    <c:when test="${auction.status == 'ACTIVE'}">Đang diễn ra</c:when>
                    <c:when test="${auction.status == 'UPCOMING'}">Sắp diễn ra</c:when>
                    <c:when test="${auction.status == 'ENDED'}">Đã kết thúc</c:when>
                    <c:otherwise>${auction.status}</c:otherwise>
                </c:choose>
            </span>
            <h1 style="color:var(--navy);margin:15px 0">${auction.productName}</h1>
            <p class="text-gold">${auction.categoryName} · Người bán: ${auction.sellerName}</p>
            <h2 class="text-gold" style="margin:20px 0"><tags:formatVnd value="${auction.currentPrice}"/></h2>
            <p style="line-height:1.7;color:#555">${auction.description}</p>
            <p style="margin-top:12px"><strong>Tiền cọc bắt buộc:</strong> <tags:formatVnd value="${auction.depositAmount}"/> (${auction.depositPercent}%)</p>

            <c:if test="${not empty wallet}">
                <div class="wallet-info">
                    <span>Số dư: <strong><tags:formatVnd value="${wallet.balance}"/></strong></span>
                    <span>Đang khóa: <strong><tags:formatVnd value="${wallet.lockedBalance}"/></strong></span>
                </div>
            </c:if>

            <c:if test="${auction.status == 'ACTIVE' && not empty sessionScope.user}">
                <div class="bid-panel">
                    <c:if test="${!hasDeposit}">
                        <p class="bid-panel-title"><i class="fa-solid fa-lock"></i> Bước 1 — Khóa tiền cọc</p>
                        <form method="post" action="${pageContext.request.contextPath}/lock-deposit" class="form-stack" style="margin-bottom:24px">
                            <input type="hidden" name="auctionId" value="${auction.auctionId}">
                            <button class="btn-outline-navy" type="submit" style="width:100%">
                                <i class="fa-solid fa-shield-halved"></i> Khóa cọc ${auction.depositPercent}% (<tags:formatVnd value="${auction.depositAmount}"/>)
                            </button>
                        </form>
                    </c:if>
                    <c:if test="${hasDeposit}">
                        <p class="bid-panel-title" style="color:#155724"><i class="fa-solid fa-circle-check"></i> Đã khóa cọc — sẵn sàng đặt giá</p>
                    </c:if>

                    <p class="bid-panel-title"><i class="fa-solid fa-gavel"></i> Bước 2 — Đặt giá</p>
                    <form method="post" action="${pageContext.request.contextPath}/placeBid" class="form-inline-row">
                        <input type="hidden" name="auctionId" value="${auction.auctionId}">
                        <div class="form-group" style="flex:2">
                            <label class="form-label" for="bidAmount">Số tiền đặt giá (VND)</label>
                            <input class="form-control" id="bidAmount" type="number" step="1000" min="0" name="bidAmount"
                                   placeholder="Tối thiểu: ${minBid}" required>
                            <p class="form-hint">Giá tối thiểu: <tags:formatVnd value="${minBid}"/></p>
                        </div>
                        <button class="btn-navy" type="submit"><i class="fa-solid fa-gavel"></i> Đặt giá</button>
                    </form>
                </div>
            </c:if>
            <c:if test="${empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/login" class="btn-navy" style="display:block;text-align:center;margin-top:24px">
                    <i class="fa-solid fa-right-to-bracket"></i> Đăng nhập để đặt giá
                </a>
            </c:if>
        </div>
    </div>

    <div class="detail-card" style="margin-top:30px">
        <h3 style="color:var(--navy);margin-bottom:20px"><i class="fa-solid fa-clock-rotate-left text-gold"></i> Lịch sử đặt giá</h3>
        <table class="data-table">
            <thead><tr><th>Người bid</th><th>Số tiền</th><th>Thời gian</th></tr></thead>
            <tbody>
            <c:forEach var="b" items="${bids}">
                <tr>
                    <td>${b.bidderName}</td>
                    <td><tags:formatVnd value="${b.bidAmount}"/></td>
                    <td><fmt:formatDate value="${b.bidTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                </tr>
            </c:forEach>
            <c:if test="${empty bids}">
                <tr><td colspan="3" style="text-align:center;color:#999;padding:24px">Chưa có lượt đặt giá nào</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</section>

<%@ include file="../shared/footer.jsp" %>
