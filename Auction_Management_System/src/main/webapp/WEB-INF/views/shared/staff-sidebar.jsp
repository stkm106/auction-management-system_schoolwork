<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="uri" value="${pageContext.request.requestURI}"/>
<div class="sidebar">
    <a href="${pageContext.request.contextPath}/home" class="sidebar-logo" title="Về trang chủ AuctionPro">
        <i class="fa-solid fa-gavel"></i>
        <span>AuctionPro</span>
    </a>
    <p class="sidebar-role-badge"><i class="fa-solid fa-user-tie"></i> Nhân viên</p>
    <ul>
        <li><a href="${pageContext.request.contextPath}/staff/dashboard" class="${fn:contains(uri, '/staff/dashboard') ? 'active' : ''}"><i class="fa-solid fa-gauge-high"></i> Bảng điều khiển</a></li>
        <li><a href="${pageContext.request.contextPath}/staff/products" class="${fn:contains(uri, '/staff/products') ? 'active' : ''}"><i class="fa-solid fa-box-open"></i> Duyệt sản phẩm</a></li>
        <li><a href="${pageContext.request.contextPath}/staff/auctions" class="${fn:contains(uri, '/staff/auctions') ? 'active' : ''}"><i class="fa-solid fa-hammer"></i> Phiên đấu giá</a></li>
        <li><a href="${pageContext.request.contextPath}/staff/payments" class="${fn:contains(uri, '/staff/payments') ? 'active' : ''}"><i class="fa-solid fa-credit-card"></i> Thanh toán chờ</a></li>
        <li><a href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a></li>
    </ul>
</div>
