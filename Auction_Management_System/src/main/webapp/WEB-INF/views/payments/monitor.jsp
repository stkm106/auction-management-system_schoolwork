<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="winningPrice" value="${not empty payment.totalAmount ? payment.totalAmount : payment.amount}"/>

<div class="page-header">
    <div>
        <h1>Giám sát giao dịch</h1>
        <div class="breadcrumb-custom">Trang chủ &gt; Giám sát giao dịch &gt; Chi tiết</div>
    </div>
    <div>
        <a href="${ctx}/payments" class="btn btn-outline-secondary btn-sm">Quay lại danh sách</a>
    </div>
</div>

<div class="alert alert-light border mb-4">
    <strong>Chế độ giám sát.</strong> Staff chỉ theo dõi giao dịch, không thực hiện thao tác mua bán thay người dùng.
</div>

<div class="row g-4">
    <div class="col-lg-8">
        <div class="profile-card mb-4">
            <div class="profile-card-body">
                <h5 class="mb-3">Tóm tắt giao dịch</h5>
                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="text-muted small">Mã giao dịch</div>
                        <div class="fw-semibold">#TXN-${payment.paymentID}</div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-muted small">Phiên đấu giá</div>
                        <div class="fw-semibold">AUC-${payment.auctionID}</div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-muted small">Trạng thái</div>
                        <div>
                            <c:choose>
                                <c:when test="${payment.status == 'Paid'}">
                                    <span class="badge-status badge-active">Đã thanh toán</span>
                                </c:when>
                                <c:when test="${payment.status == 'Pending'}">
                                    <span class="badge-status badge-pending">Chờ xử lý</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-status badge-locked">${payment.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-muted small">Giá thắng</div>
                        <div class="price-gold fw-bold">
                            <fmt:formatNumber value="${winningPrice}" groupingUsed="true"/> &#8363;
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-muted small">Tiền cọc</div>
                        <div class="fw-semibold">
                            <fmt:formatNumber value="${payment.depositAmount != null ? payment.depositAmount : 0}" groupingUsed="true"/> &#8363;
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-muted small">Còn phải trả</div>
                        <div class="fw-semibold">
                            <fmt:formatNumber value="${payment.amount}" groupingUsed="true"/> &#8363;
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-muted small">Ngày thanh toán</div>
                        <div class="fw-semibold">
                            <c:choose>
                                <c:when test="${not empty payment.paymentDate}">
                                    <fmt:formatDate value="${payment.paymentDate}" pattern="dd/MM/yyyy HH:mm"/>
                                </c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-muted small">Hạn thanh toán</div>
                        <div class="fw-semibold">
                            <c:choose>
                                <c:when test="${not empty payment.dueDate}">
                                    <fmt:formatDate value="${payment.dueDate}" pattern="dd/MM/yyyy HH:mm"/>
                                </c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <c:if test="${payment.status == 'Paid' && payment.fundsReleased}">
                        <div class="col-md-4">
                            <div class="text-muted small">Người bán nhận (90%)</div>
                            <div class="fw-semibold text-success">
                                <fmt:formatNumber value="${payment.sellerAmount}" groupingUsed="true"/> &#8363;
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="text-muted small">Phí hệ thống (10%)</div>
                            <div class="fw-semibold">
                                <fmt:formatNumber value="${payment.commissionAmount}" groupingUsed="true"/> &#8363;
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <c:if test="${not empty product}">
            <div class="profile-card">
                <div class="profile-card-body">
                    <h5 class="mb-3">Sản phẩm liên quan</h5>
                    <div class="fw-bold">${product.productName}</div>
                    <div class="small text-muted">${product.productCode} | ${not empty categoryName ? categoryName : 'N/A'}</div>
                </div>
            </div>
        </c:if>
    </div>

    <div class="col-lg-4">
        <div class="profile-card mb-4">
            <div class="profile-card-body">
                <h5 class="mb-3">Người mua</h5>
                <c:choose>
                    <c:when test="${not empty buyer}">
                        <div class="mb-1"><strong>${buyer.fullName}</strong></div>
                        <div class="small text-muted">${buyer.username} | ${buyer.email}</div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted mb-0">User #${payment.buyerID}</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="profile-card">
            <div class="profile-card-body">
                <h5 class="mb-3">Người bán</h5>
                <c:choose>
                    <c:when test="${not empty seller}">
                        <div class="mb-1"><strong>${seller.fullName}</strong></div>
                        <div class="small text-muted">${seller.username} | ${seller.email}</div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted mb-0">—</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<c:if test="${perm.managePayments && payment.status == 'Pending'}">
    <div class="d-flex gap-2 mt-4">
        <a href="${ctx}/payments/paid/${payment.paymentID}" class="btn btn-success"
           onclick="return confirm('Xác nhận đã thanh toán?')">Xác nhận thanh toán (Admin)</a>
        <a href="${ctx}/payments/cancel/${payment.paymentID}" class="btn btn-outline-danger"
           onclick="return confirm('Hủy giao dịch này?')">Hủy giao dịch</a>
    </div>
</c:if>
