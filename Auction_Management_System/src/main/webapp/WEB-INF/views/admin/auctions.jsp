<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="adminTitle" value="Quản lý đấu giá"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<%@ include file="../shared/admin-head.jsp" %>
</head>
<body>
<div class="admin-wrap">
    <%@ include file="../shared/admin-sidebar.jsp" %>
    <div class="admin-main">
        <h1 class="admin-page-title"><i class="fa-solid fa-hammer"></i> Quản lý đấu giá</h1>
        <table class="data-table">
            <thead><tr><th>ID</th><th>Sản phẩm</th><th>Giá</th><th>Cọc</th><th>Trạng thái</th><th>Thao tác</th></tr></thead>
            <tbody>
            <c:forEach var="a" items="${auctions}">
                <tr>
                    <td>${a.auctionId}</td>
                    <td><strong>${a.productName}</strong></td>
                    <td><tags:formatVnd value="${a.currentPrice}"/></td>
                    <td><tags:formatVnd value="${a.depositAmount}"/></td>
                    <td>
                        <span class="badge ${a.status == 'ACTIVE' ? 'badge-active' : a.status == 'ENDED' ? 'badge-sold' : 'badge-pending'}">
                            <c:choose>
                                <c:when test="${a.status == 'ACTIVE'}">Đang diễn ra</c:when>
                                <c:when test="${a.status == 'UPCOMING'}">Sắp diễn ra</c:when>
                                <c:when test="${a.status == 'ENDED'}">Đã kết thúc</c:when>
                                <c:otherwise>${a.status}</c:otherwise>
                            </c:choose>
                        </span>
                    </td>
                    <td>
                        <form method="post" action="${pageContext.request.contextPath}/admin/auctions/end" class="table-inline-form">
                            <input type="hidden" name="auctionId" value="${a.auctionId}">
                            <button class="btn-sm btn-sm-navy" type="submit" onclick="return confirm('Kết thúc phiên và chọn người thắng?')">
                                <i class="fa-solid fa-flag-checkered"></i> Kết thúc
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
