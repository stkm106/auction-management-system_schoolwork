<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="page-header">
    <div>
        <h1>Quản lý phiên đấu giá</h1>
        <div class="breadcrumb-custom">Trang chủ &gt; Quản lý phiên đấu giá</div>
    </div>
    <div class="d-flex gap-2">
        <button class="btn btn-outline-secondary btn-sm">Xuất Excel</button>
        <c:if test="${perm.createAuction}">
            <a href="${ctx}/auctions/create" class="btn btn-gold btn-sm">+ Tạo phiên</a>
        </c:if>
    </div>
</div>

<div class="filter-bar">
    <form class="row g-2 align-items-end" method="get" action="${ctx}/auctions/manage">
        <div class="col-md-4">
            <input type="text" name="keyword" class="form-control" placeholder="Tìm kiếm theo sản phẩm..." value="${param.keyword}">
        </div>
        <div class="col-md-2">
            <select name="status" class="form-select">
                <option value="">Tất cả trạng thái</option>
                <option value="Open" ${param.status == 'Open' ? 'selected' : ''}>Đang diễn ra</option>
                <option value="Closed" ${param.status == 'Closed' ? 'selected' : ''}>Đã kết thúc</option>
                <option value="Upcoming" ${param.status == 'Upcoming' ? 'selected' : ''}>Sắp diễn ra</option>
                <option value="Cancelled" ${param.status == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
            </select>
        </div>
        <div class="col-md-2">
            <input type="date" name="fromDate" class="form-control" value="${param.fromDate}" placeholder="Từ ngày">
        </div>
        <div class="col-md-4 d-flex gap-2">
            <button type="submit" class="btn btn-dark">Lọc</button>
            <a href="${ctx}/auctions/manage" class="btn btn-outline-secondary">Đặt lại</a>
        </div>
    </form>
</div>

<div class="data-table-wrap">
    <table class="table data-table mb-0">
        <thead>
        <tr>
            <th>ID</th>
            <th>Sản phẩm</th>
            <th>Giá khởi điểm</th>
            <th>Giá hiện tại</th>
            <th>Thời gian bắt đầu</th>
            <th>Thời gian kết thúc</th>
            <th>Trạng thái</th>
            <th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="a" items="${auctions}">
            <tr>
                <td>${a.auctionID}</td>
                <td><strong>${productMap[a.productID] != null ? productMap[a.productID] : 'SP #'}${a.productID}</strong></td>
                <td class="price-gold">
                    <c:if test="${productPriceMap[a.productID] != null}">
                        <fmt:formatNumber value="${productPriceMap[a.productID]}" groupingUsed="true"/> &#8363;
                    </c:if>
                </td>
                <td class="price-gold"><fmt:formatNumber value="${a.currentPrice}" groupingUsed="true"/> &#8363;</td>
                <td><fmt:formatDate value="${a.startTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                <td><fmt:formatDate value="${a.endTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                <td>
                    <c:choose>
                        <c:when test="${a.effectiveStatus == 'Open'}">
                            <span class="badge-status badge-active">Đang diễn ra</span>
                        </c:when>
                        <c:when test="${a.effectiveStatus == 'Closed'}">
                            <span class="badge-status badge-ended">Đã kết thúc</span>
                        </c:when>
                        <c:when test="${a.effectiveStatus == 'Upcoming'}">
                            <span class="badge-status badge-pending">Sắp diễn ra</span>
                        </c:when>
                        <c:when test="${a.effectiveStatus == 'Cancelled'}">
                            <span class="badge-status badge-locked">Đã hủy</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge-status badge-locked">${a.effectiveStatus}</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <div class="d-flex gap-1">
                        <a href="${ctx}/auctions/detail/${a.auctionID}" class="btn btn-sm btn-outline-primary" title="Xem">&#128065;</a>
                        <c:if test="${perm.manageAuctions}">
                            <c:if test="${a.status == 'Upcoming' && a.effectiveStatus == 'Open'}">
                                <a href="${ctx}/auctions/start/${a.auctionID}" class="btn btn-sm btn-outline-success" title="Bắt đầu">&#9654;</a>
                            </c:if>
                            <c:if test="${a.effectiveStatus == 'Open'}">
                                <a href="${ctx}/auctions/close/${a.auctionID}" class="btn btn-sm btn-outline-warning" title="Kết thúc">&#9632;</a>
                            </c:if>
                            <a href="${ctx}/auctions/delete/${a.auctionID}" class="btn btn-sm btn-outline-danger"
                               onclick="return confirm('Xóa phiên đấu giá này?')" title="Xóa">&#128465;</a>
                        </c:if>
                    </div>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<div class="d-flex justify-content-between align-items-center mt-3 small text-muted">
    <span>Hiển thị ${auctions.size()} phiên đấu giá</span>
</div>
