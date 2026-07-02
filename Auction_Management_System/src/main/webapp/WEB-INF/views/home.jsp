<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<section class="hero-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6">
                <p class="text-warning mb-2">Nền tảng đấu giá trực tuyến hàng đầu</p>
                <h1 class="hero-title">Đấu giá dễ dàng<br><span>Sở hữu xứng tầm</span></h1>
                <p class="text-white-50 mt-3 mb-4" style="max-width:520px">
                    Tham gia đấu giá minh bạch, an toàn với hàng ngàn sản phẩm cao cấp từ khắp cả nước.
                </p>
                <a href="${ctx}/auctions" class="btn btn-gold btn-lg">Khám phá ngay &rarr;</a>
            </div>
            <div class="col-lg-6 text-center d-none d-lg-block">
                <img src="https://images.unsplash.com/photo-1568667256549-094345857637?w=700&h=450&fit=crop"
                     class="img-fluid rounded-4 shadow-lg" alt="Auction">
            </div>
        </div>
    </div>
</section>

<div class="container">
    <div class="feature-bar">
        <div class="row">
            <div class="col-md-3 col-6 feature-item">
                <div class="fi-icon">&#128737;</div>
                <strong>Uy tín & Minh bạch</strong>
                <p class="small text-muted mb-0">Quy trình đấu giá công khai</p>
            </div>
            <div class="col-md-3 col-6 feature-item">
                <div class="fi-icon">&#9878;</div>
                <strong>Đa dạng sản phẩm</strong>
                <p class="small text-muted mb-0">Gốm sứ, đồng hồ, nghệ thuật...</p>
            </div>
            <div class="col-md-3 col-6 feature-item">
                <div class="fi-icon">&#128101;</div>
                <strong>Cộng đồng tin cậy</strong>
                <p class="small text-muted mb-0">Hàng ngàn thành viên</p>
            </div>
            <div class="col-md-3 col-6 feature-item">
                <div class="fi-icon">&#127911;</div>
                <strong>Hỗ trợ chuyên nghiệp</strong>
                <p class="small text-muted mb-0">24/7 hotline</p>
            </div>
        </div>
    </div>
</div>

<section class="section-white">
    <div class="container">
        <div class="section-title">
            <h2>Sản phẩm đấu giá nổi bật</h2>
            <div class="underline"></div>
        </div>

        <div class="row g-4">
            <c:forEach var="p" items="${products}" begin="0" end="7">
                <div class="col-lg-3 col-md-4 col-sm-6">
                    <div class="card product-card">
                        <div class="card-img-wrap">
                            <span class="badge-live">Đang đấu giá</span>
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
                            <p class="small text-muted mb-2">${p.description}</p>
                            <div class="price-gold">${p.startingPrice} &#8363;</div>
                            <a href="${ctx}/products/detail/${p.productID}" class="btn btn-gold btn-sm w-100 mt-2">Xem chi tiết</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty products}">
                <div class="col-12 text-center text-muted py-5">Chưa có sản phẩm. Hãy thêm sản phẩm trong admin.</div>
            </c:if>
        </div>
    </div>
</section>

<section class="stats-bar">
    <div class="container">
        <div class="row text-center g-4">
            <div class="col-md-3 col-6">
                <div class="stat-number">10.000+</div>
                <div class="text-white-50">Sản phẩm đã đấu giá</div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-number">25.000+</div>
                <div class="text-white-50">Thành viên đăng ký</div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-number">98%</div>
                <div class="text-white-50">Giao dịch thành công</div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-number">5+</div>
                <div class="text-white-50">Năm kinh nghiệm</div>
            </div>
        </div>
    </div>
</section>
