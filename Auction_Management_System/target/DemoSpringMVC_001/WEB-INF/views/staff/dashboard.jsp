<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="pageTitle" value="Bảng điều khiển nhân viên"/>
<%@ include file="../shared/header.jsp" %>
<div class="container mt-4">
    <h2>Bảng điều khiển nhân viên</h2>
    <p>Xin chào, ${sessionScope.user.fullName}</p>
    <div class="row mt-3">
        <div class="col-md-4">
            <div class="card p-3 mb-3">
                <h5>Thanh toán chờ xử lý</h5>
                <c:forEach var="p" items="${pendingPayments}">
                    <div class="border-bottom py-2">
                        #${p.paymentId} - ${p.productName} - <tags:formatVnd value="${p.amount}"/>
                        <span class="badge bg-warning">
                            <c:choose>
                                <c:when test="${p.status == 'PENDING'}">Chờ thanh toán</c:when>
                                <c:when test="${p.status == 'PAID'}">Đã thanh toán</c:when>
                                <c:otherwise>${p.status}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </c:forEach>
                <c:if test="${empty pendingPayments}"><p class="text-muted">Không có thanh toán chờ.</p></c:if>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-3 mb-3">
                <h5>Sản phẩm chờ duyệt</h5>
                <c:forEach var="p" items="${pendingProducts}">
                    <div class="border-bottom py-2">
                        ${p.name} - <tags:formatVnd value="${p.startingPrice}"/>
                        <form method="post" action="${pageContext.request.contextPath}/staff/products/approve" class="d-inline">
                            <input type="hidden" name="productId" value="${p.productId}">
                            <button class="btn btn-sm btn-primary">Duyệt</button>
                        </form>
                    </div>
                </c:forEach>
                <c:if test="${empty pendingProducts}"><p class="text-muted">Không có sản phẩm chờ duyệt.</p></c:if>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-3 mb-3">
                <h5>Phiên đấu giá đang diễn ra</h5>
                <ul class="list-group list-group-flush">
                    <c:forEach var="a" items="${activeAuctions}">
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            ${a.productName} - <tags:formatVnd value="${a.currentPrice}"/>
                            <form method="post" action="${pageContext.request.contextPath}/staff/auctions/end">
                                <input type="hidden" name="auctionId" value="${a.auctionId}">
                                <button class="btn btn-sm btn-outline-danger">Kết thúc</button>
                            </form>
                        </li>
                    </c:forEach>
                </ul>
                <c:if test="${empty activeAuctions}"><p class="text-muted">Không có phiên đang diễn ra.</p></c:if>
            </div>
        </div>
    </div>
</div>
<%@ include file="../shared/footer.jsp" %>
