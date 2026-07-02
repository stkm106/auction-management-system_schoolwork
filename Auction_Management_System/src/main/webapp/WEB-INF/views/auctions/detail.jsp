<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="auction-detail-page">
    <div class="container">
        <nav class="small text-muted mb-3">
            <a href="${ctx}/">Trang chủ</a> &gt;
            <a href="${ctx}/auctions">Đấu giá</a> &gt;
            <span>Chi tiết phiên</span>
        </nav>

        <c:if test="${not empty bidError}">
            <div class="alert alert-danger">${bidError}</div>
        </c:if>
        <c:if test="${not empty bidSuccess}">
            <div class="alert alert-success">${bidSuccess}</div>
        </c:if>

        <div class="row g-4">
            <div class="${auction.effectiveStatus == 'Open' ? 'col-lg-8' : 'col-12'}">
                <div class="detail-card">
                    <div class="gallery-main mb-3">
                        <c:choose>
                            <c:when test="${not empty product and not empty product.imageURL}">
                                <img src="${ctx}/resources/images/products/${product.imageURL}" alt="${product.productName}">
                            </c:when>
                            <c:otherwise>
                                <img src="https://images.unsplash.com/photo-1578666118859-6c1a8c4b8e2b?w=800&h=500&fit=crop" alt="Sản phẩm">
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <h2 class="fw-bold">${not empty product ? product.productName : 'Phiên đấu giá #'}${auction.auctionID}</h2>
                    <p class="auction-meta">Mã phiên: AUC-${auction.auctionID} | Trạng thái:
                        <c:choose>
                            <c:when test="${auction.effectiveStatus == 'Open'}">
                                <span class="badge-status badge-active">Đang diễn ra</span>
                            </c:when>
                            <c:when test="${auction.effectiveStatus == 'Upcoming'}">
                                <span class="badge-status badge-pending">Sắp diễn ra</span>
                            </c:when>
                            <c:when test="${auction.effectiveStatus == 'Closed'}">
                                <span class="badge-status badge-ended">Đã kết thúc</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge-status badge-pending">${auction.effectiveStatus}</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <c:if test="${auction.status == 'Closed' and not empty auction.winnerID}">
                        <div class="alert alert-success py-2">
                            Người thắng: ${not empty usernameMap[auction.winnerID] ? usernameMap[auction.winnerID] : auction.winnerID} với giá
                            <strong><fmt:formatNumber value="${auction.currentPrice}" groupingUsed="true"/> &#8363;</strong>
                        </div>
                    </c:if>

                    <div class="row g-3 my-3">
                        <div class="col-md-3">
                            <div class="p-3 rounded stat-box">
                                <span class="stat-label">Giá khởi điểm</span>
                                <div class="stat-value price-text">
                                    <fmt:formatNumber value="${startingPrice}" groupingUsed="true"/> &#8363;
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="p-3 rounded stat-box">
                                <span class="stat-label">Giá hiện tại</span>
                                <div class="stat-value price-text">
                                    <fmt:formatNumber value="${auction.currentPrice}" groupingUsed="true"/> &#8363;
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="p-3 rounded stat-box">
                                <span class="stat-label">Tiền cọc tham gia</span>
                                <div class="stat-value price-text">
                                    <fmt:formatNumber value="${depositAmount}" groupingUsed="true"/> &#8363;
                                </div>
                                <small class="text-muted">10% giá khởi điểm</small>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="p-3 rounded stat-box">
                                <span class="stat-label">Kết thúc</span>
                                <div class="stat-value">
                                    <fmt:formatDate value="${auction.endTime}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>
                            </div>
                        </div>
                    </div>

                    <c:if test="${not empty product}">
                        <h5 class="mt-4">Mô tả sản phẩm</h5>
                        <p>${product.description}</p>
                    </c:if>
                </div>

                <div class="detail-card">
                    <h5 class="mb-3">Lịch sử trả giá</h5>
                    <table class="table data-table mb-0">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Thành viên</th>
                            <th>Giá trả</th>
                            <th>Thời gian</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="b" items="${bids}" varStatus="st">
                            <tr>
                                <td>${st.count}</td>
                                <td>${not empty usernameMap[b.userID] ? usernameMap[b.userID] : b.userID}</td>
                                <td class="price-gold"><fmt:formatNumber value="${b.bidAmount}" groupingUsed="true"/> &#8363;</td>
                                <td>${b.bidTime}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty bids}">
                            <tr><td colspan="4" class="text-center text-muted">Chưa có lượt trả giá</td></tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <c:if test="${auction.effectiveStatus == 'Open'}">
            <div class="col-lg-4">
                <div class="detail-card bid-sidebar">
                    <c:choose>
                        <c:when test="${empty sessionUser}">
                            <h5 class="mb-3">Tham gia đấu giá</h5>
                            <p class="text-muted">Vui lòng đăng nhập tài khoản khách hàng để tham gia đấu giá.</p>
                            <a href="${ctx}/login" class="btn btn-gold w-100">Đăng nhập</a>
                        </c:when>
                        <c:when test="${isOwner}">
                            <h5 class="mb-3">Sản phẩm của bạn</h5>
                            <p class="text-muted mb-0">Bạn là người bán. Không thể tham gia đấu giá sản phẩm của chính mình.</p>
                        </c:when>
                        <c:when test="${!canBid}">
                            <h5 class="mb-3">Đặt giá</h5>
                            <p class="text-muted mb-0">Chỉ tài khoản khách hàng mới có thể tham gia đấu giá.</p>
                        </c:when>
                        <c:when test="${!hasJoined}">
                            <h5 class="mb-3">Tham gia đấu giá</h5>
                            <p class="small text-muted">
                                Bạn cần đặt cọc <strong><fmt:formatNumber value="${depositAmount}" groupingUsed="true"/> &#8363;</strong>
                                (10% giá khởi điểm) trước khi trả giá.
                            </p>
                            <c:if test="${not empty walletBalance}">
                                <p class="small mb-3">Số dư ví: <strong><fmt:formatNumber value="${walletBalance}" groupingUsed="true"/> &#8363;</strong></p>
                            </c:if>
                            <button type="button" class="btn btn-gold w-100 py-2" data-bs-toggle="modal" data-bs-target="#joinAuctionModal">
                                Tham gia đấu giá
                            </button>
                        </c:when>
                        <c:otherwise>
                            <h5 class="mb-3">Đặt giá</h5>
                            <div class="alert alert-success py-2 small mb-3">
                                Bạn đã đặt cọc <fmt:formatNumber value="${depositAmount}" groupingUsed="true"/> &#8363; và được phép trả giá.
                            </div>
                            <form method="post" action="${ctx}/bids/place">
                                <input type="hidden" name="auctionID" value="${auction.auctionID}">
                                <div class="mb-3">
                                    <label class="form-label">Số tiền trả giá</label>
                                    <input type="number" name="bidAmount" class="form-control form-control-lg" required
                                           step="1000" placeholder="Nhập số tiền cao hơn giá hiện tại">
                                </div>
                                <button type="submit" class="btn btn-gold w-100 py-2 mb-3">Đặt giá ngay</button>
                            </form>
                        </c:otherwise>
                    </c:choose>

                    <div class="p-3 rounded note-box mt-3">
                        <strong class="small">Quy tắc đấu giá</strong>
                        <ul class="small mb-0 ps-3 mt-1">
                            <li>Số dư ví phải lớn hơn giá khởi điểm (<fmt:formatNumber value="${startingPrice}" groupingUsed="true"/> &#8363;) mới được trả giá</li>
                            <li>Tiền cọc bằng 10% giá khởi điểm ban đầu</li>
                            <li>Người bán không được tham gia đấu giá sản phẩm của chính mình</li>
                            <li>Người không thắng được hoàn tiền cọc</li>
                            <li>Người thắng chỉ thanh toán phần còn lại</li>
                            <li>Người thắng có ${paymentDueDays} ngày để thanh toán</li>
                            <li>Quá hạn sẽ mất tiền cọc</li>
                        </ul>
                    </div>
                </div>
            </div>
            </c:if>
        </div>
    </div>
</div>

<div class="modal fade" id="joinAuctionModal" tabindex="-1" aria-labelledby="joinAuctionModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="joinAuctionModalLabel">Quy tắc tham gia đấu giá</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p class="mb-3">Để tham gia phiên đấu giá này, bạn cần đồng ý các quy tắc sau:</p>
                <ul class="mb-3">
                    <li>Số dư ví phải lớn hơn giá khởi điểm: <strong><fmt:formatNumber value="${startingPrice}" groupingUsed="true"/> &#8363;</strong></li>
                    <li>Tiền cọc: <strong><fmt:formatNumber value="${depositAmount}" groupingUsed="true"/> &#8363;</strong> (10% giá khởi điểm)</li>
                    <li>Người bán không được tham gia đấu giá sản phẩm của chính mình</li>
                    <li>Tiền cọc sẽ bị trừ từ ví của bạn ngay khi xác nhận</li>
                    <li>Nếu bạn không thắng, tiền cọc sẽ được hoàn lại sau khi phiên kết thúc</li>
                    <li>Nếu bạn thắng, tiền cọc được tính vào giá mua; bạn chỉ trả phần còn lại</li>
                    <li>Bạn có <strong>${paymentDueDays} ngày</strong> để thanh toán phần còn lại</li>
                    <li>Nếu quá hạn thanh toán, bạn sẽ <strong>mất tiền cọc</strong></li>
                </ul>
                <c:if test="${not empty walletBalance}">
                    <div class="alert alert-light border mb-0">
                        Số dư ví hiện tại: <strong><fmt:formatNumber value="${walletBalance}" groupingUsed="true"/> &#8363;</strong><br>
                        Sau khi cọc còn lại:
                        <strong><fmt:formatNumber value="${walletBalance - depositAmount}" groupingUsed="true"/> &#8363;</strong>
                    </div>
                </c:if>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                <form method="post" action="${ctx}/auctions/join/${auction.auctionID}" class="d-inline">
                    <button type="submit" class="btn btn-gold">Đồng ý và đặt cọc</button>
                </form>
            </div>
        </div>
    </div>
</div>
