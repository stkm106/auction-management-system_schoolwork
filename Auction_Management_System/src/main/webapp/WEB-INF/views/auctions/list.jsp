<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="section-white">
    <div class="container">
        <div class="page-header">
            <div>
                <h1>Phiên đấu giá</h1>
                <div class="breadcrumb-custom">Trang chủ &gt; Đấu giá</div>
            </div>
        </div>

        <form class="filter-bar mb-4" method="get" action="${ctx}/auctions">
            <div class="row g-2 align-items-end">
                <div class="col-md-4">
                    <input type="text" name="keyword" class="form-control" placeholder="Tìm kiếm theo tên sản phẩm, mã phiên..." value="${param.keyword}">
                </div>
                <div class="col-md-3">
                    <select name="status" class="form-select">
                        <option value="">Tất cả trạng thái</option>
                        <option value="Open" ${param.status == 'Open' ? 'selected' : ''}>Đang diễn ra</option>
                        <option value="Upcoming" ${param.status == 'Upcoming' ? 'selected' : ''}>Sắp diễn ra</option>
                        <option value="Closed" ${param.status == 'Closed' ? 'selected' : ''}>Đã kết thúc</option>
                        <option value="Cancelled" ${param.status == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                    </select>
                </div>
                <div class="col-md-5 d-flex gap-2">
                    <button type="submit" class="btn btn-dark px-4">Lọc</button>
                    <a href="${ctx}/auctions" class="btn btn-outline-secondary px-4">Đặt lại</a>
                </div>
            </div>
        </form>

        <div class="row g-4">
            <c:forEach var="a" items="${auctions}">
                <c:set var="img" value="${productImageMap[a.productID]}"/>
                <c:set var="name" value="${productMap[a.productID]}"/>
                <div class="col-lg-4 col-md-6">
                    <div class="card product-card">
                        <div class="card-img-wrap">
                            <c:choose>
                                <c:when test="${a.effectiveStatus == 'Open'}"><span class="badge-live">Đang diễn ra</span></c:when>
                                <c:when test="${a.effectiveStatus == 'Upcoming'}"><span class="badge-live badge-upcoming">Sắp diễn ra</span></c:when>
                                <c:otherwise><span class="badge-live" style="background:#6c757d">${a.effectiveStatus}</span></c:otherwise>
                            </c:choose>
                            <c:choose>
                                <c:when test="${not empty img and (fn:startsWith(img, 'http://') or fn:startsWith(img, 'https://'))}">
                                    <img src="${img}" alt="${name}">
                                </c:when>
                                <c:when test="${not empty img}">
                                    <img src="${ctx}/resources/images/products/${img}" alt="${name}">
                                </c:when>
                                <c:otherwise>
                                    <div class="img-placeholder">Chưa có ảnh</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="card-body">
                            <h6 class="fw-bold">
                                <c:choose>
                                    <c:when test="${not empty name}">${name}</c:when>
                                    <c:otherwise>Phiên #${a.auctionID}</c:otherwise>
                                </c:choose>
                            </h6>
                            <div class="price-gold mb-1"><fmt:formatNumber value="${a.currentPrice}" groupingUsed="true"/> &#8363;</div>
                            <p class="small text-muted mb-2">
                                <fmt:formatDate value="${a.startTime}" pattern="dd/MM/yyyy HH:mm"/>
                                -
                                <fmt:formatDate value="${a.endTime}" pattern="dd/MM/yyyy HH:mm"/>
                            </p>
                            <a href="${ctx}/auctions/detail/${a.auctionID}" class="btn btn-gold btn-sm w-100">Xem chi tiết</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty auctions}">
                <div class="col-12 text-center text-muted py-5">Không tìm thấy phiên đấu giá phù hợp.</div>
            </c:if>
        </div>

        <div class="small text-muted mt-3">Hiển thị ${auctions.size()} phiên đấu giá</div>
    </div>
</div>
