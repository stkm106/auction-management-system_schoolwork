<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="panelTitle" value="Phiên đấu giá"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<%@ include file="../shared/manager-head.jsp" %>
</head>
<body>
<div class="admin-wrap">
    <%@ include file="../shared/manager-sidebar.jsp" %>
    <div class="admin-main">
        <h1 class="admin-page-title"><i class="fa-solid fa-hammer"></i> Quản lý phiên đấu giá</h1>
        <p class="panel-intro">Theo dõi giá hiện tại, lịch bắt đầu/kết thúc và kết thúc phiên khi cần thiết.</p>

        <form class="admin-filter" method="get">
            <div class="form-group filter-search">
                <label class="form-label" for="keyword"><i class="fa-solid fa-magnifying-glass"></i> Tìm sản phẩm</label>
                <input class="form-control" id="keyword" name="keyword" placeholder="Tên sản phẩm..." value="${keyword}">
            </div>
            <div class="form-group filter-role">
                <label class="form-label" for="status">Trạng thái</label>
                <select class="form-control admin-select" id="status" name="status">
                    <option value="">Tất cả</option>
                    <option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>Đang diễn ra</option>
                    <option value="UPCOMING" ${status == 'UPCOMING' ? 'selected' : ''}>Sắp diễn ra</option>
                    <option value="ENDED" ${status == 'ENDED' ? 'selected' : ''}>Đã kết thúc</option>
                </select>
            </div>
            <button class="btn-gold btn-filter" type="submit"><i class="fa-solid fa-filter"></i> Lọc</button>
        </form>

        <div class="admin-table-wrap">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Sản phẩm</th>
                        <th>Trạng thái</th>
                        <th>Giá hiện tại</th>
                        <th>Bắt đầu</th>
                        <th>Kết thúc</th>
                        <th>Bid</th>
                        <th></th>
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
                        <td>
                            <c:choose>
                                <c:when test="${a.status == 'ACTIVE'}"><span class="badge badge-active">Đang diễn ra</span></c:when>
                                <c:when test="${a.status == 'UPCOMING'}"><span class="badge badge-pending">Sắp diễn ra</span></c:when>
                                <c:when test="${a.status == 'ENDED'}"><span class="badge" style="background:#e2e8f0;color:#475569">Đã kết thúc</span></c:when>
                                <c:otherwise>${a.status}</c:otherwise>
                            </c:choose>
                        </td>
                        <td><tags:formatVnd value="${a.currentPrice}"/></td>
                        <td><fmt:formatDate value="${a.startTime}" pattern="dd/MM/yy HH:mm"/></td>
                        <td><fmt:formatDate value="${a.endTime}" pattern="dd/MM/yy HH:mm"/></td>
                        <td>${a.bidCount}</td>
                        <td>
                            <c:if test="${a.status == 'ACTIVE'}">
                                <form method="post" action="${pageContext.request.contextPath}/manager/auctions/end" class="table-inline-form">
                                    <input type="hidden" name="auctionId" value="${a.auctionId}">
                                    <button class="btn-sm btn-sm-navy" type="submit" onclick="return confirm('Kết thúc phiên này?')">
                                        <i class="fa-solid fa-stop"></i> Kết thúc
                                    </button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty auctions}">
                    <tr><td colspan="8" class="table-empty">Không tìm thấy phiên đấu giá</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
