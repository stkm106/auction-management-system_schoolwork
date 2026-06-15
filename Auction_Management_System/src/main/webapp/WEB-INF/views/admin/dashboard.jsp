<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="adminTitle" value="Bảng điều khiển"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<%@ include file="../shared/admin-head.jsp" %>
</head>
<body>
<div class="admin-wrap">
    <%@ include file="../shared/admin-sidebar.jsp" %>
    <div class="admin-main">
        <h1 class="admin-page-title"><i class="fa-solid fa-gauge-high"></i> Bảng điều khiển</h1>
        <div class="admin-stats">
            <div class="admin-stat-card"><i class="fa-solid fa-users"></i><h2>${totalUsers}</h2><p>Người dùng</p></div>
            <div class="admin-stat-card"><i class="fa-solid fa-gavel"></i><h2>${totalAuctions}</h2><p>Phiên đấu giá</p></div>
            <div class="admin-stat-card"><i class="fa-solid fa-clock"></i><h2>${activeAuctions}</h2><p>Đang diễn ra</p></div>
            <div class="admin-stat-card"><i class="fa-solid fa-coins"></i><h2><tags:formatVnd value="${revenue}"/></h2><p>Phí sàn</p></div>
        </div>
        <table class="data-table">
            <thead><tr><th>ID</th><th>Sản phẩm</th><th>Giá hiện tại</th><th>Trạng thái</th></tr></thead>
            <tbody>
            <c:forEach var="a" items="${recentAuctions}">
                <tr>
                    <td>${a.auctionId}</td>
                    <td><strong>${a.productName}</strong></td>
                    <td><tags:formatVnd value="${a.currentPrice}"/></td>
                    <td>
                        <span class="badge ${a.status == 'ACTIVE' ? 'badge-active' : 'badge-pending'}">
                            <c:choose>
                                <c:when test="${a.status == 'ACTIVE'}">Đang diễn ra</c:when>
                                <c:when test="${a.status == 'UPCOMING'}">Sắp diễn ra</c:when>
                                <c:when test="${a.status == 'ENDED'}">Đã kết thúc</c:when>
                                <c:otherwise>${a.status}</c:otherwise>
                            </c:choose>
                        </span>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
