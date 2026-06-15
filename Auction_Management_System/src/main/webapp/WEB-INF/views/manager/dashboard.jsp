<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="panelTitle" value="Bảng điều khiển"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<%@ include file="../shared/manager-head.jsp" %>
</head>
<body>
<div class="admin-wrap">
    <%@ include file="../shared/manager-sidebar.jsp" %>
    <div class="admin-main">
        <h1 class="admin-page-title"><i class="fa-solid fa-gauge-high"></i> Bảng điều khiển quản lý</h1>
        <p class="panel-intro">Giám sát vận hành đấu giá, theo dõi doanh thu phí sàn và tình hình phiên đang diễn ra.</p>

        <div class="admin-stats">
            <div class="admin-stat-card">
                <i class="fa-solid fa-coins"></i>
                <h2><tags:formatVnd value="${revenue}"/></h2>
                <p>Phí sàn thu được</p>
            </div>
            <div class="admin-stat-card">
                <i class="fa-solid fa-gavel"></i>
                <h2>${totalAuctions}</h2>
                <p>Tổng phiên đấu giá</p>
            </div>
            <div class="admin-stat-card">
                <i class="fa-solid fa-clock"></i>
                <h2>${activeAuctions}</h2>
                <p>Đang diễn ra</p>
            </div>
            <div class="admin-stat-card">
                <i class="fa-solid fa-credit-card"></i>
                <h2>${pendingPayments}</h2>
                <p>Thanh toán chờ</p>
            </div>
        </div>

        <div style="display:grid;grid-template-columns:1fr 1fr;gap:24px">
            <div class="admin-form-card">
                <h3><i class="fa-solid fa-chart-column"></i> Doanh thu theo sản phẩm</h3>
                <ul style="list-style:none;padding:0;margin:0">
                    <c:forEach var="s" items="${revenueStats}">
                        <li style="display:flex;justify-content:space-between;padding:10px 0;border-bottom:1px solid #eee;font-size:14px">
                            <span>${s.label}</span>
                            <strong style="color:var(--navy)"><tags:formatVnd value="${s.value}"/></strong>
                        </li>
                    </c:forEach>
                    <c:if test="${empty revenueStats}"><li class="table-empty">Chưa có dữ liệu</li></c:if>
                </ul>
            </div>
            <div class="admin-form-card">
                <h3><i class="fa-solid fa-star"></i> Sản phẩm phổ biến</h3>
                <ul style="list-style:none;padding:0;margin:0">
                    <c:forEach var="s" items="${popularProducts}">
                        <li style="display:flex;justify-content:space-between;padding:10px 0;border-bottom:1px solid #eee;font-size:14px">
                            <span>${s.label}</span>
                            <strong style="color:var(--gold)">${s.count} bid</strong>
                        </li>
                    </c:forEach>
                    <c:if test="${empty popularProducts}"><li class="table-empty">Chưa có dữ liệu</li></c:if>
                </ul>
            </div>
        </div>

        <div class="admin-form-card" style="margin-top:24px">
            <h3><i class="fa-solid fa-link"></i> Truy cập nhanh</h3>
            <div style="display:flex;gap:12px;flex-wrap:wrap">
                <a href="${pageContext.request.contextPath}/manager/auctions" class="btn-sm btn-sm-gold" style="text-decoration:none">
                    <i class="fa-solid fa-hammer"></i> Quản lý phiên & lịch
                </a>
                <a href="${pageContext.request.contextPath}/manager/reports" class="btn-sm btn-sm-navy" style="text-decoration:none">
                    <i class="fa-solid fa-chart-pie"></i> Báo cáo chi tiết
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
