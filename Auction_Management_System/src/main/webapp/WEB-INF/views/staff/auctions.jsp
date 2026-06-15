<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="panelTitle" value="Phiên đấu giá"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<%@ include file="../shared/staff-head.jsp" %>
</head>
<body>
<div class="admin-wrap">
    <%@ include file="../shared/staff-sidebar.jsp" %>
    <div class="admin-main">
        <h1 class="admin-page-title"><i class="fa-solid fa-hammer"></i> Phiên đấu giá đang diễn ra</h1>
        <p class="panel-intro">Cập nhật trạng thái phiên — kết thúc đấu giá để xác định người thắng và tạo hóa đơn thanh toán.</p>

        <form class="admin-filter admin-filter-compact" method="get">
            <div class="form-group filter-search">
                <label class="form-label" for="keyword"><i class="fa-solid fa-magnifying-glass"></i> Tìm phiên</label>
                <input class="form-control" id="keyword" name="keyword" placeholder="Tên sản phẩm..." value="${keyword}">
            </div>
            <button class="btn-gold btn-filter" type="submit"><i class="fa-solid fa-filter"></i> Lọc</button>
        </form>

        <div class="admin-table-wrap">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Sản phẩm</th>
                        <th>Giá hiện tại</th>
                        <th>Lượt bid</th>
                        <th>Cọc 10%</th>
                        <th>Xử lý</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="a" items="${auctions}">
                    <tr>
                        <td>${a.auctionId}</td>
                        <td>
                            <div class="table-product-cell">
                                <img class="table-thumb" src="${a.primaryImage}" alt="${a.productName}"
                                     onerror="this.src='https://via.placeholder.com/52?text=DG'">
                                <div class="table-product-meta">
                                    <strong>${a.productName}</strong>
                                    <small>${a.sellerName}</small>
                                </div>
                            </div>
                        </td>
                        <td><tags:formatVnd value="${a.currentPrice}"/></td>
                        <td>${a.bidCount}</td>
                        <td><tags:formatVnd value="${a.depositAmount}"/></td>
                        <td>
                            <form method="post" action="${pageContext.request.contextPath}/staff/auctions/end" class="table-inline-form">
                                <input type="hidden" name="auctionId" value="${a.auctionId}">
                                <button class="btn-sm btn-sm-navy" type="submit" onclick="return confirm('Kết thúc phiên đấu giá này?')">
                                    <i class="fa-solid fa-stop"></i> Kết thúc
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty auctions}">
                    <tr><td colspan="6" class="table-empty">Không có phiên đang diễn ra</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
