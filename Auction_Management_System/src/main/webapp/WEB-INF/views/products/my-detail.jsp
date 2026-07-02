<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="page-header">
    <div>
        <h1>Chi tiết sản phẩm</h1>
        <div class="breadcrumb-custom">Tài khoản &gt; Sản phẩm của tôi &gt; ${product.productName}</div>
    </div>
    <div>
        <a href="${ctx}/products/my" class="btn btn-outline-secondary btn-sm">Quay lại danh sách</a>
    </div>
</div>

<div class="row g-4">
    <div class="col-lg-8">
        <div class="profile-card mb-4">
            <div class="profile-card-body">
                <div class="row g-4 align-items-start">
                    <div class="col-md-5">
                        <div class="card-img-wrap rounded overflow-hidden" style="height:260px;">
                            <c:choose>
                                <c:when test="${not empty product.imageURL and (fn:startsWith(product.imageURL, 'http://') or fn:startsWith(product.imageURL, 'https://'))}">
                                    <img src="${product.imageURL}" alt="${product.productName}" class="w-100 h-100" style="object-fit:cover;">
                                </c:when>
                                <c:when test="${not empty product.imageURL}">
                                    <img src="${ctx}/resources/images/products/${product.imageURL}" alt="${product.productName}" class="w-100 h-100" style="object-fit:cover;">
                                </c:when>
                                <c:otherwise>
                                    <div class="img-placeholder h-100">Chưa có ảnh</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-7">
                        <h4 class="fw-bold mb-2">${product.productName}</h4>
                        <div class="text-muted small mb-3">Mã: ${product.productCode}</div>
                        <div class="mb-3">
                            <div class="text-muted small">Giá khởi điểm</div>
                            <div class="price-gold fs-4 fw-bold">
                                <fmt:formatNumber value="${product.startingPrice}" groupingUsed="true"/> &#8363;
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="text-muted small">Trạng thái</div>
                            <c:choose>
                                <c:when test="${product.status == 'Pending'}">
                                    <span class="badge-status badge-pending">Chờ duyệt</span>
                                </c:when>
                                <c:when test="${product.status == 'Rejected'}">
                                    <span class="badge-status badge-locked">Từ chối</span>
                                </c:when>
                                <c:when test="${product.status == 'Approved' && auction == null}">
                                    <span class="badge-status badge-active">Đã duyệt &mdash; Chờ tạo phiên đấu giá</span>
                                </c:when>
                                <c:when test="${product.status == 'Approved' && auction != null}">
                                    <c:choose>
                                        <c:when test="${auction.effectiveStatus == 'Upcoming'}">
                                            <span class="badge-status badge-pending">Đã duyệt &mdash; Phiên sắp diễn ra</span>
                                        </c:when>
                                        <c:when test="${auction.effectiveStatus == 'Open'}">
                                            <span class="badge-status badge-active">Đang đấu giá</span>
                                        </c:when>
                                        <c:when test="${auction.effectiveStatus == 'Closed'}">
                                            <span class="badge-status badge-ended">Phiên đã kết thúc</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-status">${auction.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-status">${product.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div>
                            <div class="text-muted small mb-1">Mô tả</div>
                            <p class="mb-0">${not empty product.description ? product.description : '—'}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-4">
        <div class="profile-card mb-4">
            <div class="profile-card-body">
                <h5 class="mb-3">Thông tin thêm</h5>
                <div class="mb-3">
                    <div class="text-muted small">Danh mục</div>
                    <div class="fw-semibold">${not empty category ? category.categoryName : '—'}</div>
                </div>
                <div class="mb-3">
                    <div class="text-muted small">Ngày đăng</div>
                    <div class="fw-semibold">
                        <c:choose>
                            <c:when test="${not empty product.createdAt}">
                                <fmt:formatDate value="${product.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <c:if test="${auction != null}">
            <div class="profile-card">
                <div class="profile-card-body">
                    <h5 class="mb-3">Phiên đấu giá</h5>
                    <div class="mb-2">
                        <div class="text-muted small">Mã phiên</div>
                        <div class="fw-semibold">AUC-${auction.auctionID}</div>
                    </div>
                    <div class="mb-2">
                        <div class="text-muted small">Giá hiện tại</div>
                        <div class="price-gold fw-bold">
                            <fmt:formatNumber value="${auction.currentPrice}" groupingUsed="true"/> &#8363;
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="text-muted small">Kết thúc</div>
                        <div class="fw-semibold">
                            <fmt:formatDate value="${auction.endTime}" pattern="dd/MM/yyyy HH:mm"/>
                        </div>
                    </div>
                    <a href="${ctx}/auctions/detail/${auction.auctionID}" class="btn btn-gold btn-sm w-100">Xem phiên đấu giá</a>
                </div>
            </div>
        </c:if>
    </div>
</div>
