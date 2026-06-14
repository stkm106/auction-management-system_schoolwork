<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="adminTitle" value="Duyệt sản phẩm"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<%@ include file="../shared/admin-head.jsp" %>
</head>
<body>
<div class="admin-wrap">
    <%@ include file="../shared/admin-sidebar.jsp" %>
    <div class="admin-main">
        <h1 class="admin-page-title"><i class="fa-solid fa-box-open"></i> Duyệt sản phẩm</h1>
        <table class="data-table">
            <thead>
                <tr><th>ID</th><th>Tên</th><th>Người bán</th><th>Giá khởi điểm</th><th>Trạng thái</th><th>Duyệt</th></tr>
            </thead>
            <tbody>
            <c:forEach var="p" items="${products}">
                <tr>
                    <td>${p.productId}</td>
                    <td><strong>${p.name}</strong></td>
                    <td>${p.sellerName}</td>
                    <td><tags:formatVnd value="${p.startingPrice}"/></td>
                    <td>
                        <span class="badge ${p.status == 'REJECTED' ? 'badge-rejected' : p.status == 'SOLD' ? 'badge-sold' : p.status == 'APPROVED' || p.status == 'AUCTIONING' ? 'badge-active' : 'badge-pending'}">
                            <c:choose>
                                <c:when test="${p.status == 'PENDING'}">Chờ duyệt</c:when>
                                <c:when test="${p.status == 'APPROVED'}">Đã duyệt</c:when>
                                <c:when test="${p.status == 'REJECTED'}">Từ chối</c:when>
                                <c:when test="${p.status == 'AUCTIONING'}">Đang đấu giá</c:when>
                                <c:when test="${p.status == 'SOLD'}">Đã bán</c:when>
                                <c:otherwise>${p.status}</c:otherwise>
                            </c:choose>
                        </span>
                    </td>
                    <td>
                        <form method="post" action="${pageContext.request.contextPath}/admin/products/approve" class="table-inline-form">
                            <input type="hidden" name="productId" value="${p.productId}">
                            <select name="status" class="admin-select">
                                <option value="APPROVED" ${p.status == 'APPROVED' ? 'selected' : ''}>Đã duyệt</option>
                                <option value="REJECTED" ${p.status == 'REJECTED' ? 'selected' : ''}>Từ chối</option>
                                <option value="AUCTIONING" ${p.status == 'AUCTIONING' ? 'selected' : ''}>Đang đấu giá</option>
                            </select>
                            <button class="btn-sm btn-sm-gold" type="submit"><i class="fa-solid fa-check"></i> Lưu</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty products}">
                <tr><td colspan="6" style="text-align:center;color:#999;padding:28px">Không có sản phẩm</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
