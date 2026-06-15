<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="pageTitle" value="Trang chủ"/>
<%@ include file="../shared/header.jsp" %>

<section class="hero">
    <div class="hero-content">
        <h1>Hệ thống <span>Đấu giá Trực tuyến</span></h1>
        <p>Nền tảng đấu giá tập trung với ví điện tử, tiền cọc 10%, đặt giá, thanh toán, phí sàn và lịch sử giao dịch đầy đủ.</p>
        <div class="hero-buttons">
            <a href="${pageContext.request.contextPath}/auctions" class="hero-btn primary-btn">Khám phá đấu giá</a>
        </div>
    </div>
    <div class="hero-image">
        <img src="https://images.unsplash.com/photo-1511919884226-fd3cad34687c?q=80&w=1200&auto=format&fit=crop" alt="Đấu giá">
    </div>
</section>

<section class="features">
    <div class="feature-card"><i class="fa-solid fa-user-lock"></i><h3>Xác thực</h3><p>Đăng ký, đăng nhập và phân quyền theo vai trò.</p></div>
    <div class="feature-card"><i class="fa-solid fa-gavel"></i><h3>Đặt giá &amp; Cọc</h3><p>Khóa cọc 10%, hoàn tiền khi thua, mất cọc nếu không thanh toán.</p></div>
    <div class="feature-card"><i class="fa-solid fa-wallet"></i><h3>Ví điện tử</h3><p>Số dư, tiền khóa và lịch sử giao dịch ví.</p></div>
    <div class="feature-card"><i class="fa-solid fa-chart-line"></i><h3>Báo cáo</h3><p>Doanh thu, sản phẩm phổ biến, thống kê đặt giá.</p></div>
</section>

<section class="section">
    <div class="section-title">
        <h2>Phiên đấu giá nổi bật</h2>
        <p>Đang diễn ra — cần khóa cọc trước khi đặt giá.</p>
    </div>
    <div class="auction-grid">
        <c:forEach var="a" items="${featured}">
            <div class="auction-card">
                <div class="auction-image">
                    <img src="${a.primaryImage}" alt="${a.productName}" onerror="this.src='https://via.placeholder.com/400x240?text=Không+có+ảnh'">
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
                    <div class="auction-price">
                        <h3><tags:formatVnd value="${a.currentPrice}"/></h3>
                        <span>${a.bidCount} lượt đặt giá</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/auction-detail?id=${a.auctionId}" class="auction-btn" style="display:block;text-align:center;">Đặt giá</a>
                </div>
            </div>
        </c:forEach>
    </div>
</section>

<section class="dashboard">
    <div class="section-title">
        <h2 style="color:white;">Thống kê hệ thống</h2>
        <p style="color:#cbd3e4;">Dữ liệu thời gian thực từ cơ sở dữ liệu.</p>
    </div>
    <div class="dashboard-grid">
        <div class="dashboard-card"><i class="fa-solid fa-gavel"></i><h2>${totalAuctions}</h2><p>Phiên đấu giá</p></div>
        <div class="dashboard-card"><i class="fa-solid fa-users"></i><h2>${totalUsers}</h2><p>Người dùng</p></div>
        <div class="dashboard-card"><i class="fa-solid fa-money-bill"></i><h2><tags:formatVnd value="${totalRevenue}"/></h2><p>Doanh thu sàn</p></div>
        <div class="dashboard-card"><i class="fa-solid fa-chart-column"></i><h2>${totalBids}</h2><p>Tổng lượt đặt giá</p></div>
    </div>
</section>

<section class="section partners-section">
    <div class="section-title">
        <h2>Các đối tác hợp tác</h2>
        <p>Đồng hành cùng AuctionPro trong hệ sinh thái đấu giá trực tuyến</p>
    </div>
    <div class="partners-grid">
        <div class="partner-card">
            <div class="partner-logo"><i class="fa-solid fa-building-columns"></i></div>
            <h3>Vietcombank</h3>
            <p>Đối tác thanh toán &amp; nạp ví</p>
        </div>
        <div class="partner-card">
            <div class="partner-logo"><i class="fa-solid fa-credit-card"></i></div>
            <h3>MoMo</h3>
            <p>Ví điện tử liên kết</p>
        </div>
        <div class="partner-card">
            <div class="partner-logo"><i class="fa-solid fa-truck-fast"></i></div>
            <h3>Giao Hàng Nhanh</h3>
            <p>Vận chuyển sản phẩm đấu giá</p>
        </div>
        <div class="partner-card">
            <div class="partner-logo"><i class="fa-solid fa-shield-halved"></i></div>
            <h3>Bảo hiểm PJICO</h3>
            <p>Bảo vệ giao dịch đấu giá</p>
        </div>
        <div class="partner-card">
            <div class="partner-logo"><i class="fa-solid fa-gem"></i></div>
            <h3>PNJ</h3>
            <p>Đối tác trang sức cao cấp</p>
        </div>
        <div class="partner-card">
            <div class="partner-logo"><i class="fa-solid fa-laptop"></i></div>
            <h3>CellphoneS</h3>
            <p>Thiết bị điện tử đấu giá</p>
        </div>
    </div>
</section>

<%@ include file="../shared/footer.jsp" %>
