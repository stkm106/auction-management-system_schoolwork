<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<div class="sidebar">
    <a href="${pageContext.request.contextPath}/home" class="sidebar-logo" title="Về trang chủ AuctionPro">
        <i class="fa-solid fa-gavel"></i>
        <span>AuctionPro</span>
    </a>
    <ul>
        <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa-solid fa-gauge-high"></i> Bảng điều khiển</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-user-group"></i> Người dùng</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/categories"><i class="fa-solid fa-folder-tree"></i> Danh mục</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/products"><i class="fa-solid fa-box-open"></i> Sản phẩm</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/auctions"><i class="fa-solid fa-hammer"></i> Đấu giá</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/bids"><i class="fa-solid fa-hand-holding-dollar"></i> Lượt đặt giá</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/payments"><i class="fa-solid fa-credit-card"></i> Thanh toán</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/wallet-transactions"><i class="fa-solid fa-wallet"></i> Giao dịch ví</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/reports"><i class="fa-solid fa-chart-pie"></i> Báo cáo</a></li>
        <li><a href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a></li>
    </ul>
</div>
