<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Home"/>
<%@ include file="../shared/header.jsp" %>

<section class="hero">
    <div class="hero-content">
        <h1>Online Auction <span>Management System</span></h1>
        <p>A centralized auction platform with wallet, 10% deposit, bidding, payments, platform fees, and full transaction history.</p>
        <div class="hero-buttons">
            <a href="${pageContext.request.contextPath}/auctions" class="hero-btn primary-btn">Explore Auctions</a>
            <a href="${pageContext.request.contextPath}/admin/reports" class="hero-btn secondary-btn">View Reports</a>
        </div>
    </div>
    <div class="hero-image">
        <img src="https://images.unsplash.com/photo-1511919884226-fd3cad34687c?q=80&w=1200&auto=format&fit=crop" alt="Auction">
    </div>
</section>

<section class="features">
    <div class="feature-card"><i class="fa-solid fa-user-lock"></i><h3>Authentication</h3><p>Registration, login, role-based authorization.</p></div>
    <div class="feature-card"><i class="fa-solid fa-gavel"></i><h3>Bidding + Deposit</h3><p>10% deposit lock, refund when lose, forfeit if no payment.</p></div>
    <div class="feature-card"><i class="fa-solid fa-wallet"></i><h3>E-Wallet</h3><p>Balance, locked balance, wallet transaction history.</p></div>
    <div class="feature-card"><i class="fa-solid fa-chart-line"></i><h3>Reports</h3><p>Revenue, popular items, bidding statistics.</p></div>
</section>

<section class="section">
    <div class="section-title">
        <h2>Featured Auction Items</h2>
        <p>Live auctions — deposit required before bidding.</p>
    </div>
    <div class="auction-grid">
        <c:forEach var="a" items="${featured}">
            <div class="auction-card">
                <div class="auction-image">
                    <img src="${a.primaryImage}" alt="${a.productName}" onerror="this.src='https://via.placeholder.com/400x240?text=No+Image'">
                    <div class="auction-status">${a.status}</div>
                </div>
                <div class="auction-content">
                    <div class="auction-category">${a.categoryName}</div>
                    <div class="auction-title">${a.productName}</div>
                    <div class="auction-price">
                        <h3><tags:formatVnd value="${a.currentPrice}"/></h3>
                        <span>${a.bidCount} Bids</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/auction-detail?id=${a.auctionId}" class="auction-btn" style="display:block;text-align:center;">Place Bid</a>
                </div>
            </div>
        </c:forEach>
    </div>
</section>

<section class="dashboard">
    <div class="section-title">
        <h2 style="color:white;">System Statistics</h2>
        <p style="color:#cbd3e4;">Real-time data from database.</p>
    </div>
    <div class="dashboard-grid">
        <div class="dashboard-card"><i class="fa-solid fa-gavel"></i><h2>${totalAuctions}</h2><p>Auctions</p></div>
        <div class="dashboard-card"><i class="fa-solid fa-users"></i><h2>${totalUsers}</h2><p>Users</p></div>
        <div class="dashboard-card"><i class="fa-solid fa-money-bill"></i><h2><tags:formatVnd value="${totalRevenue}"/></h2><p>Doanh thu sàn</p></div>
        <div class="dashboard-card"><i class="fa-solid fa-chart-column"></i><h2>${totalBids}</h2><p>Total Bids</p></div>
    </div>
</section>

<section class="section">
    <div class="section-title"><h2>System User Roles</h2></div>
    <div class="roles">
        <div class="role-card"><i class="fa-solid fa-user-shield"></i><h3>Administrator</h3><p>Manage users, products, auctions, reports.</p></div>
        <div class="role-card"><i class="fa-solid fa-briefcase"></i><h3>Auction Manager</h3><p>Monitor operations and analytics.</p></div>
        <div class="role-card"><i class="fa-solid fa-user-gear"></i><h3>Staff</h3><p>Approve products, process payments.</p></div>
        <div class="role-card"><i class="fa-solid fa-user"></i><h3>Customer</h3><p>Buy, sell, bid, wallet, payments.</p></div>
    </div>
</section>

<%@ include file="../shared/footer.jsp" %>
