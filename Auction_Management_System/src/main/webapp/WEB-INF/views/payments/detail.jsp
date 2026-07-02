<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="page-header">
    <div>
        <h1>Chi tiết đơn hàng đã bán</h1>
        <div class="breadcrumb-custom">Trang chủ &gt; Giao dịch &amp; Thanh toán &gt; Chi tiết đơn hàng</div>
    </div>
    <div>
        <a href="${ctx}/payments" class="btn btn-outline-secondary btn-sm">Quay lại danh sách</a>
    </div>
</div>

<div class="row g-4">
    <div class="col-lg-8">
        <div class="profile-card mb-4">
            <div class="profile-card-body">
                <h5 class="mb-3">Thông tin giao dịch</h5>
                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="text-muted small">Mã giao dịch</div>
                        <div class="fw-semibold">#TXN-${payment.paymentID}</div>
                    </div>
                    <div class="col-md-6">
                        <div class="text-muted small">Trạng thái thanh toán</div>
                        <div>
                            <c:choose>
                                <c:when test="${payment.status == 'Paid'}">
                                    <span class="badge-status badge-active">Đã thanh toán</span>
                                </c:when>
                                <c:when test="${payment.status == 'Pending'}">
                                    <span class="badge-status badge-pending">Chờ xử lý</span>
                                </c:when>
                                <c:when test="${payment.status == 'Failed'}">
                                    <span class="badge-status badge-locked">Thất bại</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-status badge-locked">${payment.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="text-muted small">Số tiền thanh toán</div>
                        <div class="price-gold fw-bold fs-5">
                            <fmt:formatNumber value="${payment.amount}" groupingUsed="true"/> &#8363;
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
                        <div class="text-muted small">Phương thức thanh toán</div>
                        <div class="fw-semibold">Ví điện tử</div>
                    </div>
                    <div class="col-md-6">
                        <div class="text-muted small">Mã phiên đấu giá</div>
                        <div class="fw-semibold">AUC-${payment.auctionID}</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="profile-card mb-4">
            <div class="profile-card-body">
                <h5 class="mb-3">Thông tin sản phẩm</h5>
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
                                <div class="row g-3">
                                    <div class="col-12">
                                        <div class="text-muted small">Tên sản phẩm</div>
                                        <div class="fw-bold fs-5">${product.productName}</div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="text-muted small">Mã sản phẩm</div>
                                        <div class="fw-semibold">${product.productCode}</div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="text-muted small">Danh mục</div>
                                        <div class="fw-semibold">${not empty categoryName ? categoryName : 'N/A'}</div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="text-muted small">Giá khởi điểm</div>
                                        <div class="fw-semibold">
                                            <fmt:formatNumber value="${product.startingPrice}" groupingUsed="true"/> &#8363;
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="text-muted small">Giá bán (giá thắng)</div>
                                        <div class="price-gold fw-bold">
                                            <fmt:formatNumber value="${payment.amount}" groupingUsed="true"/> &#8363;
                                        </div>
                                    </div>
                                    <div class="col-12">
                                        <div class="text-muted small">Mô tả</div>
                                        <div>${not empty product.description ? product.description : '—'}</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted mb-0">Không tìm thấy thông tin sản phẩm liên kết.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <c:if test="${not empty auction}">
            <div class="profile-card">
                <div class="profile-card-body">
                    <h5 class="mb-3">Thông tin phiên đấu giá</h5>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <div class="text-muted small">Trạng thái phiên</div>
                            <div>
                                <c:choose>
                                    <c:when test="${auction.effectiveStatus == 'Closed'}">
                                        <span class="badge-status badge-ended">Đã kết thúc</span>
                                    </c:when>
                                    <c:when test="${auction.effectiveStatus == 'Open'}">
                                        <span class="badge-status badge-active">Đang diễn ra</span>
                                    </c:when>
                                    <c:when test="${auction.effectiveStatus == 'Upcoming'}">
                                        <span class="badge-status badge-pending">Sắp diễn ra</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-status">${auction.effectiveStatus}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="text-muted small">Thời gian bắt đầu</div>
                            <div class="fw-semibold">
                                <fmt:formatDate value="${auction.startTime}" pattern="dd/MM/yyyy HH:mm"/>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="text-muted small">Thời gian kết thúc</div>
                            <div class="fw-semibold">
                                <fmt:formatDate value="${auction.endTime}" pattern="dd/MM/yyyy HH:mm"/>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="text-muted small">Giá cuối cùng</div>
                            <div class="price-gold fw-bold">
                                <fmt:formatNumber value="${auction.currentPrice}" groupingUsed="true"/> &#8363;
                            </div>
                        </div>
                    </div>
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
                        <div class="mb-2"><span class="text-muted small">Họ tên:</span> <strong>${buyer.fullName}</strong></div>
                        <div class="mb-2"><span class="text-muted small">Tài khoản:</span> ${buyer.username}</div>
                        <div class="mb-2"><span class="text-muted small">Email:</span> ${buyer.email}</div>
                        <div class="mb-2"><span class="text-muted small">Số điện thoại:</span> ${not empty buyer.phone ? buyer.phone : '—'}</div>
                        <div><span class="text-muted small">Địa chỉ:</span> ${not empty buyer.address ? buyer.address : '—'}</div>
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
                        <div class="mb-2"><span class="text-muted small">Họ tên:</span> <strong>${seller.fullName}</strong></div>
                        <div class="mb-2"><span class="text-muted small">Tài khoản:</span> ${seller.username}</div>
                        <div class="mb-2"><span class="text-muted small">Email:</span> ${seller.email}</div>
                        <div class="mb-2"><span class="text-muted small">Số điện thoại:</span> ${not empty seller.phone ? seller.phone : '—'}</div>
                        <div><span class="text-muted small">Địa chỉ:</span> ${not empty seller.address ? seller.address : '—'}</div>
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
           onclick="return confirm('Xác nhận đã thanh toán?')">Xác nhận thanh toán</a>
        <a href="${ctx}/payments/cancel/${payment.paymentID}" class="btn btn-outline-danger"
           onclick="return confirm('Hủy giao dịch này?')">Hủy giao dịch</a>
    </div>
</c:if>

