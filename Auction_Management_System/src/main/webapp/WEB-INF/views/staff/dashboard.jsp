<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="panelTitle" value="Bảng điều khiển"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<%@ include file="../shared/staff-head.jsp" %>
</head>
<body>
<div class="admin-wrap">
    <%@ include file="../shared/staff-sidebar.jsp" %>
    <div class="admin-main">
        <h1 class="admin-page-title"><i class="fa-solid fa-gauge-high"></i> Bảng điều khiển nhân viên</h1>
        <p class="panel-intro">Xin chào <strong>${sessionScope.user.fullName}</strong> — xử lý giao dịch hàng ngày, cập nhật trạng thái sản phẩm và phiên đấu giá.</p>

        <div class="admin-stats">
            <a href="${pageContext.request.contextPath}/staff/payments" class="admin-stat-card" style="text-decoration:none;color:inherit">
                <i class="fa-solid fa-credit-card"></i>
                <h2>${pendingPaymentCount}</h2>
                <p>Thanh toán chờ</p>
            </a>
            <a href="${pageContext.request.contextPath}/staff/products" class="admin-stat-card" style="text-decoration:none;color:inherit">
                <i class="fa-solid fa-box-open"></i>
                <h2>${pendingProductCount}</h2>
                <p>Sản phẩm chờ duyệt</p>
            </a>
            <a href="${pageContext.request.contextPath}/staff/auctions" class="admin-stat-card" style="text-decoration:none;color:inherit">
                <i class="fa-solid fa-hammer"></i>
                <h2>${activeAuctionCount}</h2>
                <p>Phiên đang diễn ra</p>
            </a>
        </div>

        <div class="admin-form-card">
            <h3><i class="fa-solid fa-list-check"></i> Công việc chính</h3>
            <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:16px">
                <a href="${pageContext.request.contextPath}/staff/products" style="text-decoration:none;color:inherit;padding:16px;border:1px solid #e2e8f0;border-radius:12px">
                    <strong style="color:var(--navy)"><i class="fa-solid fa-check text-gold"></i> Duyệt sản phẩm</strong>
                    <p style="font-size:13px;color:#64748b;margin:8px 0 0">Phê duyệt hoặc từ chối SP người bán đăng</p>
                </a>
                <a href="${pageContext.request.contextPath}/staff/auctions" style="text-decoration:none;color:inherit;padding:16px;border:1px solid #e2e8f0;border-radius:12px">
                    <strong style="color:var(--navy)"><i class="fa-solid fa-stop text-gold"></i> Kết thúc phiên</strong>
                    <p style="font-size:13px;color:#64748b;margin:8px 0 0">Đóng phiên đấu giá đang ACTIVE</p>
                </a>
                <a href="${pageContext.request.contextPath}/staff/payments" style="text-decoration:none;color:inherit;padding:16px;border:1px solid #e2e8f0;border-radius:12px">
                    <strong style="color:var(--navy)"><i class="fa-solid fa-eye text-gold"></i> Theo dõi thanh toán</strong>
                    <p style="font-size:13px;color:#64748b;margin:8px 0 0">Giám sát hóa đơn chờ khách thanh toán</p>
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
