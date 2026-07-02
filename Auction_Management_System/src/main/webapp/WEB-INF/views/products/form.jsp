<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="isEdit" value="${product.productID > 0}"/>

<div class="page-header">
    <div>
        <h1>${isEdit ? 'Sửa sản phẩm' : 'Thêm sản phẩm'}</h1>
        <div class="breadcrumb-custom">Trang chủ &gt; Quản lý sản phẩm &gt; ${isEdit ? 'Sửa' : 'Thêm mới'}</div>
    </div>
</div>

<div class="profile-card">
    <div class="profile-card-body">
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <form method="post"
              action="${ctx}${isEdit ? '/products/update' : '/products/save'}"
              enctype="multipart/form-data">
            <input type="hidden" name="productID" value="${product.productID}">

            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Mã sản phẩm (ID)</label>
                    <c:choose>
                        <c:when test="${isEdit}">
                            <input type="text" class="form-control" value="${product.productID}" readonly>
                        </c:when>
                        <c:otherwise>
                            <input type="text" class="form-control" value="Tự động theo ID" readonly>
                            <div class="form-text">Mã sản phẩm chính là ID, hệ thống tự tạo khi lưu.</div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Tên sản phẩm</label>
                    <input type="text" name="productName" value="${product.productName}" class="form-control" required>
                </div>
                <div class="col-12">
                    <label class="form-label">Mô tả</label>
                    <textarea name="description" class="form-control" rows="3">${product.description}</textarea>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Giá khởi điểm</label>
                    <input type="number" name="startingPrice" value="${product.startingPrice}" class="form-control" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Danh mục</label>
                    <select name="categoryID" class="form-select" required>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.categoryID}" ${product.categoryID == cat.categoryID ? 'selected' : ''}>${cat.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Hình ảnh sản phẩm</label>
                    <input type="file" name="imageFile" class="form-control" accept="image/jpeg,image/png,image/gif,image/webp" ${isEdit ? '' : 'required'}>
                    <div class="form-text">Chọn ảnh từ máy</div>
                    <c:if test="${isEdit and not empty product.imageURL}">
                        <div class="mt-2">
                            <small class="text-muted d-block mb-1">Ảnh hiện tại:</small>
                            <c:choose>
                                <c:when test="${fn:startsWith(product.imageURL, 'http://') or fn:startsWith(product.imageURL, 'https://')}">
                                    <img src="${product.imageURL}" alt="${product.productName}" class="img-thumbnail" style="max-height:100px">
                                </c:when>
                                <c:otherwise>
                                    <img src="${ctx}/resources/images/products/${product.imageURL}" alt="${product.productName}" class="img-thumbnail" style="max-height:100px">
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="d-flex gap-2 mt-4">
                <button type="submit" class="btn btn-gold">Lưu sản phẩm</button>
                <a href="${ctx}/products/manage" class="btn btn-outline-secondary">Hủy</a>
            </div>
        </form>
    </div>
</div>
