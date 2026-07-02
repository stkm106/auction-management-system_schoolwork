<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="winningPrice" value="${not empty payment.totalAmount ? payment.totalAmount : payment.amount}"/>

<div class="page-header">
    <div>
        <h1>Chi tiết đơn hàng của tôi</h1>
        <div class="breadcrumb-custom">Tài khoản &gt; Thanh toán của tôi &gt; Chi tiết đơn hàng</div>
    </div>
    <div>
        <a href="${ctx}/payments/my-payments" class="btn btn-outline-secondary btn-sm">Quay lại</a>
    </div>
</div>

<div class="row g-4">
    <div class="col-lg-8">
        <div class="profile-card mb-4">
            <div class="profile-card-body">
                <h5 class="mb-3">Thông tin thanh toán</h5>
                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="text-muted small">Mã giao dịch</div>
                        <div class="fw-semibold">#TXN-${payment.paymentID}</div>
                    </div>
                    <div class="col-md-6">
                        <div class="text-muted small">Trạng thái</div>
                        <div>
                            <c:choose>
                                <c:when test="${payment.status == 'Paid'}">
                                    <span class="badge-status badge-active">Đã thanh toán</span>
                                </c:when>
                                <c:when test="${payment.status == 'Pending'}">
                                    <span class="badge-status badge-pending">Chờ thanh toán</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-status badge-locked">${payment.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="text-muted small">Tổng giá thắng</div>
                        <div class="price-gold fw-bold fs-5">
                            <fmt:formatNumber value="${winningPrice}" groupingUsed="true"/> &#8363;
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="text-muted small">Tiền cọc đã trả</div>
                        <div class="fw-semibold">
                            <fmt:formatNumber value="${payment.depositAmount != null ? payment.depositAmount : 0}" groupingUsed="true"/> &#8363;
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="text-muted small">Còn phải trả</div>
                        <div class="fw-bold">
                            <fmt:formatNumber value="${payment.amount}" groupingUsed="true"/> &#8363;
                        </div>
                    </div>
                    <div class="col-md-6">
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
                    <div class="col-md-6">
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
                    <div class="col-md-6">
                        <div class="text-muted small">Phương thức</div>
                        <div class="fw-semibold">Ví điện tử</div>
                    </div>
                    <c:if test="${payment.status == 'Paid' && payment.fundsReleased}">
                        <div class="col-md-6">
                            <div class="text-muted small">Người bán nhận (90%)</div>
                            <div class="fw-semibold text-success">
                                <fmt:formatNumber value="${payment.sellerAmount}" groupingUsed="true"/> &#8363;
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="text-muted small">Phí hệ thống (10%)</div>
                            <div class="fw-semibold">
                                <fmt:formatNumber value="${payment.commissionAmount}" groupingUsed="true"/> &#8363;
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <div class="profile-card mb-4">
            <div class="profile-card-body">
                <h5 class="mb-3">Sản phẩm đã mua</h5>
                <c:choose>
                    <c:when test="${not empty product}">
                        <div class="row g-3 align-items-start">
                            <div class="col-md-4">
                                <div class="table-thumb" style="width:100%;height:180px;border-radius:12px;overflow:hidden;">
                                    <c:choose>
                                        <c:when test="${not empty product.imageURL and (fn:startsWith(product.imageURL, 'http://') or fn:startsWith(product.imageURL, 'https://'))}">
                                            <img src="${product.imageURL}" alt="${product.productName}" style="width:100%;height:100%;object-fit:cover;">
                                        </c:when>
                                        <c:when test="${not empty product.imageURL}">
                                            <img src="${ctx}/resources/images/products/${product.imageURL}" alt="${product.productName}" style="width:100%;height:100%;object-fit:cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="img-placeholder h-100 d-flex align-items-center justify-content-center">Chưa có ảnh</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-8">
                                <div class="fw-bold fs-5 mb-2">${product.productName}</div>
                                <div class="text-muted small mb-1">Mã: ${product.productCode} | ${not empty categoryName ? categoryName : 'N/A'}</div>
                                <div class="mb-2">${not empty product.description ? product.description : '—'}</div>
                                <div class="small">Giá khởi điểm:
                                    <fmt:formatNumber value="${product.startingPrice}" groupingUsed="true"/> &#8363;
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted mb-0">Không tìm thấy thông tin sản phẩm.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <div class="col-lg-4">
        <div class="profile-card mb-4">
            <div class="profile-card-body">
                <h5 class="mb-3">Người bán</h5>
                <c:choose>
                    <c:when test="${not empty seller}">
                        <div class="mb-2"><span class="text-muted small">Họ tên:</span> <strong>${seller.fullName}</strong></div>
                        <div class="mb-2"><span class="text-muted small">Email:</span> ${seller.email}</div>
                        <div><span class="text-muted small">SĐT:</span> ${not empty seller.phone ? seller.phone : '—'}</div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted mb-0">—</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <c:if test="${payment.status == 'Pending' and payment.amount > 0}">
            <div class="profile-card">
                <div class="profile-card-body">
                    <h5 class="mb-3">Thanh toán</h5>
                    <p class="small text-muted">Thanh toán phần còn lại từ ví của bạn.</p>
                    <form method="post" action="${ctx}/payments/pay/${payment.paymentID}">
                        <button type="submit" class="btn btn-gold w-100"
                                onclick="return confirm('Thanh toán phần còn lại từ ví?')">
                            Thanh toán ngay
                        </button>
                    </form>
                </div>
            </div>
        </c:if>
    </div>
</div>
