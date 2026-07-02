<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="page-header">
    <div>
        <h1>Quản lý sản phẩm</h1>
        <div class="breadcrumb-custom">Trang chủ &gt; Quản lý sản phẩm</div>
    </div>
    <div class="d-flex gap-2">
        <button type="button" class="btn btn-outline-secondary btn-sm btn-header-action">
            <i class="bi bi-upload"></i> Xuất Excel
        </button>
        <a href="${ctx}/products/create" class="btn btn-gold btn-sm btn-header-action">
            <i class="bi bi-plus-lg"></i> Thêm sản phẩm
        </a>
    </div>
</div>

<div class="filter-bar">
    <form class="row g-2 align-items-end" method="get" action="${ctx}/products/manage">
        <div class="col-md-4">
            <input type="text" name="keyword" class="form-control" placeholder="Tìm kiếm theo tên sản phẩm..." value="${param.keyword}">
        </div>
        <div class="col-md-2">
            <select name="categoryId" class="form-select">
                <option value="">Tất cả danh mục</option>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat.categoryID}" ${param.categoryId == cat.categoryID ? 'selected' : ''}>${cat.categoryName}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-2">
            <select name="status" class="form-select">
                <option value="">Tất cả trạng thái</option>
                <option value="Approved" ${param.status == 'Approved' ? 'selected' : ''}>Duyệt</option>
                <option value="Pending" ${param.status == 'Pending' ? 'selected' : ''}>Chờ duyệt</option>
                <option value="Rejected" ${param.status == 'Rejected' ? 'selected' : ''}>Từ chối</option>
                <option value="Auctioning" ${param.status == 'Auctioning' ? 'selected' : ''}>Đang đấu giá</option>
                <option value="Sold" ${param.status == 'Sold' ? 'selected' : ''}>Đã bán</option>
            </select>
        </div>
        <div class="col-md-4 d-flex gap-2">
            <button type="submit" class="btn btn-dark px-4">Lọc</button>
            <a href="${ctx}/products/manage" class="btn btn-outline-secondary px-4">Đặt lại</a>
        </div>
    </form>
</div>

<div class="data-table-wrap">
    <table class="table data-table mb-0">
        <thead>
        <tr>
            <th>ID</th>
            <th>Hình ảnh</th>
            <th>Tên sản phẩm</th>
            <th>Danh mục</th>
            <th>Giá khởi điểm</th>
            <th>Người đăng</th>
            <th>Trạng thái</th>
            <th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="p" items="${products}">
            <tr>
                <td>${p.productID}</td>
                <td>
                    <div class="table-thumb">
                        <c:choose>
                            <c:when test="${not empty p.imageURL and (fn:startsWith(p.imageURL, 'http://') or fn:startsWith(p.imageURL, 'https://'))}">
                                <img src="${p.imageURL}" alt="${p.productName}">
                            </c:when>
                            <c:when test="${not empty p.imageURL}">
                                <img src="${ctx}/resources/images/products/${p.imageURL}" alt="${p.productName}">
                            </c:when>
                            <c:otherwise>
                                <img src="https://images.unsplash.com/photo-1592899677974-9a10ca588f5f?w=80&h=80&fit=crop" alt="${p.productName}">
                            </c:otherwise>
                        </c:choose>
                    </div>
                </td>
                <td><strong>${p.productName}</strong></td>
                <td>${categoryMap[p.categoryID] != null ? categoryMap[p.categoryID] : 'N/A'}</td>
                <td><fmt:formatNumber value="${p.startingPrice}" groupingUsed="true"/> &#8363;</td>
                <td>${userMap[p.ownerID] != null ? userMap[p.ownerID] : 'User #'}${p.ownerID}</td>
                <td>
                    <c:choose>
                        <c:when test="${p.status == 'Approved'}">
                            <span class="badge-status badge-active">Duyệt</span>
                        </c:when>
                        <c:when test="${p.status == 'Pending'}">
                            <span class="badge-status badge-pending">Chờ duyệt</span>
                        </c:when>
                        <c:when test="${p.status == 'Rejected'}">
                            <span class="badge-status badge-locked">Từ chối</span>
                        </c:when>
                        <c:when test="${p.status == 'Auctioning'}">
                            <span class="badge-status badge-pending">Đang đấu giá</span>
                        </c:when>
                        <c:when test="${p.status == 'Sold'}">
                            <span class="badge-status badge-active">Đã bán</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge-status">${p.status}</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <div class="d-flex gap-2 flex-wrap">
                        <c:if test="${perm.reviewProducts && p.status == 'Pending'}">
                            <a href="${ctx}/products/approve/${p.productID}" class="btn btn-sm btn-success"
                               onclick="return confirm('Duyệt sản phẩm này?')" title="Duyệt">
                                <i class="bi bi-check-lg"></i> Duyệt
                            </a>
                            <a href="${ctx}/products/decline/${p.productID}" class="btn btn-sm btn-outline-danger"
                               onclick="return confirm('Từ chối sản phẩm này?')" title="Từ chối">
                                <i class="bi bi-x-lg"></i> Từ chối
                            </a>
                        </c:if>
                        <a href="${ctx}/products/edit/${p.productID}" class="btn-action btn-action-edit" title="Sửa">
                            <i class="bi bi-pencil"></i>
                        </a>
                        <a href="${ctx}/products/delete/${p.productID}" class="btn-action btn-action-delete"
                           onclick="return confirm('Xóa sản phẩm này?')" title="Xóa">
                            <i class="bi bi-trash"></i>
                        </a>
                    </div>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty products}">
            <tr>
                <td colspan="8" class="text-center text-muted py-5">Chưa có sản phẩm nào</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>

<div class="table-footer">
    <span>Hiển thị ${products.size()} sản phẩm</span>
</div>
