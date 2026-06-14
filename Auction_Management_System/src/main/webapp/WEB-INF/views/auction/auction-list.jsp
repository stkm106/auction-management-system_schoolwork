<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="pageTitle" value="Danh sách đấu giá"/>
<%@ include file="../shared/header.jsp" %>

<section class="page-section">
    <div class="section-title"><h2>Danh sách đấu giá</h2><p>Tìm kiếm, lọc và đặt giá (cọc 10%)</p></div>

    <form class="filter-bar" method="get">
        <div class="form-group">
            <label class="form-label" for="keyword"><i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm</label>
            <input class="form-control" id="keyword" name="keyword" placeholder="Tên sản phẩm..." value="${keyword}">
        </div>
        <div class="form-group" style="max-width:200px">
            <label class="form-label" for="categoryId">Danh mục</label>
            <select class="form-control" id="categoryId" name="categoryId">
                <option value="">Tất cả</option>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat.categoryId}" ${categoryId == cat.categoryId ? 'selected' : ''}>${cat.name}</option>
                </c:forEach>
            </select>
        </div>
        <div class="form-group" style="max-width:180px">
            <label class="form-label" for="status">Trạng thái</label>
            <select class="form-control" id="status" name="status">
                <option value="">Tất cả</option>
                <option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>Đang diễn ra</option>
                <option value="UPCOMING" ${status == 'UPCOMING' ? 'selected' : ''}>Sắp diễn ra</option>
                <option value="ENDED" ${status == 'ENDED' ? 'selected' : ''}>Đã kết thúc</option>
            </select>
        </div>
        <button class="btn-gold" type="submit"><i class="fa-solid fa-filter"></i> Lọc</button>
    </form>

    <div class="auction-grid">
        <c:forEach var="a" items="${auctions}">
            <div class="auction-card">
                <div class="auction-image">
                    <img src="${a.primaryImage}" alt="${a.productName}" onerror="this.src='https://via.placeholder.com/400x240'">
                    <div class="auction-status">
                        <c:choose>
                            <c:when test="${a.status == 'ACTIVE'}">Đang diễn ra</c:when>
                            <c:when test="${a.status == 'UPCOMING'}">Sắp diễn ra</c:when>
                            <c:when test="${a.status == 'ENDED'}">Đã kết thúc</c:when>
                            <c:otherwise>${a.status}</c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="auction-content">
                    <div class="auction-category">${a.categoryName}</div>
                    <div class="auction-title">${a.productName}</div>
                    <div class="auction-price"><h3><tags:formatVnd value="${a.currentPrice}"/></h3><span>${a.bidCount} lượt đặt giá</span></div>
                    <p style="font-size:13px;color:#888;margin-bottom:12px">Tiền cọc: <tags:formatVnd value="${a.depositAmount}"/> (${a.depositPercent}%)</p>
                    <a href="${pageContext.request.contextPath}/auction-detail?id=${a.auctionId}" class="auction-btn" style="display:block;text-align:center">Xem &amp; Đặt giá</a>
                </div>
            </div>
        </c:forEach>
    </div>
</section>

<%@ include file="../shared/footer.jsp" %>
