<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="panelTitle" value="Duyệt sản phẩm"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<%@ include file="../shared/staff-head.jsp" %>
</head>
<body>
<div class="admin-wrap">
    <%@ include file="../shared/staff-sidebar.jsp" %>
    <div class="admin-main">
        <h1 class="admin-page-title"><i class="fa-solid fa-box-open"></i> Duyệt sản phẩm</h1>
        <p class="panel-intro">Kiểm tra thông tin sản phẩm, phê duyệt để người bán có thể mở phiên đấu giá hoặc từ chối nếu không hợp lệ.</p>

        <form class="admin-filter admin-filter-compact" method="get">
            <div class="form-group filter-search">
                <label class="form-label" for="keyword"><i class="fa-solid fa-magnifying-glass"></i> Tìm sản phẩm</label>
                <input class="form-control" id="keyword" name="keyword" placeholder="Tên sản phẩm..." value="${keyword}">
            </div>
            <button class="btn-gold btn-filter" type="submit"><i class="fa-solid fa-filter"></i> Lọc</button>
        </form>

        <div class="panel-summary">
            <div class="panel-summary-item">
                <strong>${products.size()}</strong>
                <span>Sản phẩm chờ duyệt</span>
            </div>
        </div>

        <div class="admin-table-wrap">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Sản phẩm</th>
                        <th>Người bán</th>
                        <th>Danh mục</th>
                        <th>Giá khởi điểm</th>
                        <th>Tình trạng</th>
                        <th>Xử lý</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="p" items="${products}">
                    <tr>
                        <td>${p.productId}</td>
                        <td>
                            <div class="table-product-cell">
                                <img class="table-thumb" src="${p.primaryImage}" alt="${p.name}"
                                     onerror="this.src='https://via.placeholder.com/52?text=SP'">
                                <div class="table-product-meta">
                                    <strong>${p.name}</strong>
                                    <small title="${p.description}">${p.description}</small>
                                </div>
                            </div>
                        </td>
                        <td>${p.sellerName}</td>
                        <td>${p.categoryName}</td>
                        <td><tags:formatVnd value="${p.startingPrice}"/></td>
                        <td><span class="badge badge-pending">Chờ duyệt</span></td>
                        <td>
                            <div class="table-action-stack">
                                <form method="post" action="${pageContext.request.contextPath}/staff/products/approve">
                                    <input type="hidden" name="productId" value="${p.productId}">
                                    <button class="btn-sm btn-sm-gold" type="submit"><i class="fa-solid fa-check"></i> Duyệt</button>
                                </form>
                                <form method="post" action="${pageContext.request.contextPath}/staff/products/reject"
                                      onsubmit="return confirm('Từ chối sản phẩm này?')">
                                    <input type="hidden" name="productId" value="${p.productId}">
                                    <button class="btn-sm btn-sm-navy" type="submit"><i class="fa-solid fa-xmark"></i> Từ chối</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty products}">
                    <tr><td colspan="7" class="table-empty">Không có sản phẩm chờ duyệt</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
