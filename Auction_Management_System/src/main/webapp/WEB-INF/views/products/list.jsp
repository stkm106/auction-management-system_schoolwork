<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="section-white">
    <div class="container">
        <div class="page-header">
            <div>
                <h1>Sản phẩm đấu giá</h1>
                <div class="breadcrumb-custom">Trang chủ &gt; Sản phẩm</div>
            </div>
        </div>

        <form class="filter-bar mb-4" method="get" action="${ctx}/products/search">
            <div class="row g-2">
                <div class="col-md-8">
                    <input type="text" name="keyword" class="form-control" placeholder="Tìm kiếm sản phẩm..." value="${param.keyword}">
                </div>
                <div class="col-md-4">
                    <button class="btn btn-dark w-100">Tìm kiếm</button>
                </div>
            </div>
        </form>

        <div class="row g-4">
            <c:forEach var="p" items="${products}">
                <div class="col-lg-3 col-md-4 col-sm-6">
                    <div class="card product-card">
                        <div class="card-img-wrap">
                            <span class="badge-live badge-upcoming">Chờ tạo phiên đấu giá</span>
                            <c:choose>
                                <c:when test="${not empty p.imageURL and (fn:startsWith(p.imageURL, 'http://') or fn:startsWith(p.imageURL, 'https://'))}">
                                    <img src="${p.imageURL}" alt="${p.productName}">
                                </c:when>
                                <c:when test="${not empty p.imageURL}">
                                    <img src="${ctx}/resources/images/products/${p.imageURL}" alt="${p.productName}">
                                </c:when>
                                <c:otherwise>
                                    <div class="img-placeholder">Chưa có ảnh</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="card-body">
                            <h6 class="fw-bold">${p.productName}</h6>
                            <p class="small text-muted">${p.description}</p>
                            <div class="price-gold mb-2"><fmt:formatNumber value="${p.startingPrice}" groupingUsed="true"/> &#8363;</div>
                            <a href="${ctx}/products/detail/${p.productID}" class="btn btn-gold btn-sm w-100">Chi tiết</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty products}">
                <div class="col-12 text-center text-muted py-5">
                    Chưa có sản phẩm đã duyệt nào chờ tạo phiên đấu giá.
                </div>
            </c:if>
        </div>
    </div>
</div>
