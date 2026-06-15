<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="uri" value="${pageContext.request.requestURI}"/>
<div class="sidebar">
    <a href="${pageContext.request.contextPath}/home" class="sidebar-logo" title="Về trang chủ AuctionPro">
        <i class="fa-solid fa-gavel"></i>
        <span>AuctionPro</span>
    </a>
    <p class="sidebar-role-badge"><i class="fa-solid fa-chart-line"></i> Quản lý đấu giá</p>
    <ul>
        <li><a href="${pageContext.request.contextPath}/manager/dashboard" class="${fn:contains(uri, '/manager/dashboard') ? 'active' : ''}"><i class="fa-solid fa-gauge-high"></i> Bảng điều khiển</a></li>
        <li><a href="${pageContext.request.contextPath}/manager/auctions" class="${fn:contains(uri, '/manager/auctions') ? 'active' : ''}"><i class="fa-solid fa-hammer"></i> Phiên đấu giá</a></li>
        <li><a href="${pageContext.request.contextPath}/manager/reports" class="${fn:contains(uri, '/manager/reports') ? 'active' : ''}"><i class="fa-solid fa-chart-pie"></i> Báo cáo</a></li>
        <li><a href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a></li>
    </ul>
</div>
