<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="customer-dashboard">
    <div class="welcome-banner mb-4">
        <h1 class="h3 fw-bold mb-1">Chào mừng, ${user.fullName} 👋</h1>
        <p class="text-muted mb-0">Theo dõi phiên đấu giá, đơn hàng và ví của bạn tại một nơi.</p>
    </div>

    <div class="row g-4">
        <div class="col-xl-8">
            <div class="row g-3 mb-4">
                <div class="col-md-6 col-lg-3">
                    <div class="kpi-card">
                        <div class="kpi-label">Phiên đã tham gia</div>
                        <div class="kpi-value">${bidCount}</div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="kpi-card">
                        <div class="kpi-label">Đơn hàng của tôi</div>
                        <div class="kpi-value">${orderCount}</div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="kpi-card">
                        <div class="kpi-label">Số dư ví</div>
                        <div class="kpi-value price-gold"><fmt:formatNumber value="${walletBalance}" groupingUsed="true"/> &#8363;</div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="kpi-card">
                        <div class="kpi-label">Sản phẩm đang bán</div>
                        <div class="kpi-value">${myProductCount}</div>
                    </div>
                </div>
            </div>

            <div class="profile-card mb-4">
                <div class="profile-card-body">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0">Phiên đấu giá đang diễn ra</h5>
                        <a href="${ctx}/auctions" class="small text-decoration-none">Xem tất cả</a>
                    </div>
                    <div class="row g-3">
                        <c:forEach var="a" items="${activeAuctions}">
                            <c:set var="product" value="${productMap[a.productID]}"/>
                            <div class="col-md-6">
                                <div class="card product-card h-100">
                                    <div class="card-img-wrap" style="height:140px;">
                                        <c:choose>
                                            <c:when test="${a.effectiveStatus == 'Open'}"><span class="badge-live">Đang diễn ra</span></c:when>
                                            <c:otherwise><span class="badge-live badge-upcoming">Sắp diễn ra</span></c:otherwise>
                                        </c:choose>
                                        <c:choose>
                                            <c:when test="${not empty product and not empty product.imageURL}">
                                                <img src="${ctx}/resources/images/products/${product.imageURL}" alt="${product.productName}">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="img-placeholder">Chưa có ảnh</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="card-body p-3">
                                        <h6 class="fw-bold mb-1">${not empty product ? product.productName : 'Phiên #'}${a.auctionID}</h6>
                                        <div class="small text-muted mb-1">Giá hiện tại</div>
                                        <div class="price-gold mb-2"><fmt:formatNumber value="${a.currentPrice}" groupingUsed="true"/> &#8363;</div>
                                        <div class="small text-muted">
                                            Kết thúc: <fmt:formatDate value="${a.endTime}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                        <a href="${ctx}/auctions/detail/${a.auctionID}" class="btn btn-gold btn-sm w-100 mt-2">Xem chi tiết</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty activeAuctions}">
                            <div class="col-12 text-center text-muted py-4">Chưa có phiên đấu giá đang diễn ra.</div>
                        </c:if>
                    </div>
                </div>
            </div>

            <div class="data-table-wrap">
                <div class="p-3 border-bottom">
                    <h5 class="mb-0">Hoạt động gần đây</h5>
                </div>
                <table class="table data-table mb-0">
                    <thead>
                    <tr>
                        <th>Thời gian</th>
                        <th>Nội dung</th>
                        <th>Sản phẩm</th>
                        <th>Số tiền</th>
                        <th>Trạng thái</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="act" items="${recentActivities}">
                        <tr>
                            <td><fmt:formatDate value="${act.time}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td>${act.content}</td>
                            <td>${act.product}</td>
                            <td class="price-gold"><fmt:formatNumber value="${act.amount}" groupingUsed="true"/> &#8363;</td>
                            <td><span class="badge-status badge-active">${act.status}</span></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentActivities}">
                        <tr><td colspan="5" class="text-center text-muted py-4">Chưa có hoạt động nào.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="col-xl-4">
            <div class="profile-card mb-4">
                <div class="profile-card-body">
                    <h5 class="mb-3">Thông tin tài khoản</h5>
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <span class="avatar-lg">${fn:substring(user.fullName, 0, 1)}</span>
                        <div>
                            <strong>${user.fullName}</strong>
                            <div class="small text-muted">Khách hàng</div>
                        </div>
                    </div>
                    <div class="small mb-1"><span class="text-muted">Email:</span> ${user.email}</div>
                    <div class="small"><span class="text-muted">SĐT:</span> ${not empty user.phone ? user.phone : '—'}</div>
                </div>
            </div>

            <div class="profile-card mb-4 wallet-widget">
                <div class="profile-card-body">
                    <h5 class="mb-2">Số dư ví</h5>
                    <div class="price-gold fs-4 fw-bold mb-3"><fmt:formatNumber value="${walletBalance}" groupingUsed="true"/> &#8363;</div>
                    <div class="d-grid gap-2">
                        <a href="${ctx}/wallet" class="btn btn-gold">Nạp tiền</a>
                        <a href="${ctx}/wallet" class="btn btn-outline-secondary btn-sm">Lịch sử giao dịch</a>
                    </div>
                </div>
            </div>

            <div class="profile-card mb-4">
                <div class="profile-card-body">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0">Sản phẩm bạn đang bán</h5>
                        <a href="${ctx}/products/my" class="small">Xem tất cả</a>
                    </div>
                    <c:forEach var="p" items="${myProductsPreview}">
                        <div class="selling-item d-flex justify-content-between align-items-center py-2 border-bottom">
                            <span class="small fw-semibold">${p.productName}</span>
                            <c:choose>
                                <c:when test="${p.status == 'Approved'}">
                                    <span class="badge-status badge-active">Đã duyệt</span>
                                </c:when>
                                <c:when test="${p.status == 'Pending'}">
                                    <span class="badge-status badge-pending">Chờ duyệt</span>
                                </c:when>
                                <c:when test="${p.status == 'Rejected'}">
                                    <span class="badge-status badge-locked">Từ chối</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-status">${p.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:forEach>
                    <c:if test="${empty myProductsPreview}">
                        <p class="text-muted small mb-0">Bạn chưa có sản phẩm nào.</p>
                    </c:if>
                </div>
            </div>

            <div class="profile-card">
                <div class="profile-card-body">
                    <h5 class="mb-3">Thông báo mới</h5>
                    <c:forEach var="n" items="${notifications}">
                        <div class="notification-item py-2 border-bottom">
                            <div class="small">${n.content}</div>
                            <div class="text-muted" style="font-size:0.75rem;">
                                <fmt:formatDate value="${n.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty notifications}">
                        <p class="text-muted small mb-0">Không có thông báo mới.</p>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

