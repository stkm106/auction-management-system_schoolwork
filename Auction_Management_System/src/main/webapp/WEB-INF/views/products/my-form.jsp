<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="page-header">
    <div>
        <h1>Thêm sản phẩm</h1>
        <div class="breadcrumb-custom">Tài khoản &gt; Sản phẩm của tôi &gt; Thêm mới</div>
    </div>
</div>

<div class="profile-card">
    <div class="profile-card-body">
        <div class="alert alert-info mb-4">
            Sản phẩm sau khi gửi sẽ ở trạng thái <strong>Chờ duyệt</strong>. Khi được duyệt, sản phẩm sẽ chờ quản trị viên tạo phiên đấu giá.
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <form method="post" action="${ctx}/products/my/save" enctype="multipart/form-data">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Mã sản phẩm (ID)</label>
                    <input type="text" class="form-control" value="Tự động theo ID" readonly>
                    <div class="form-text">Mã sản phẩm chính là ID, hệ thống tự tạo khi lưu.</div>
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
                    <input type="number" name="startingPrice" value="${product.startingPrice}" class="form-control" min="0" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Danh mục</label>
                    <select name="categoryID" class="form-select" required>
                        <option value="">-- Chọn danh mục --</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.categoryID}" ${product.categoryID == cat.categoryID ? 'selected' : ''}>${cat.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Hình ảnh sản phẩm</label>
                    <input type="file" name="imageFile" class="form-control" accept="image/jpeg,image/png,image/gif,image/webp" required>
                    <div class="form-text">Chọn ảnh từ máy tính</div>
                </div>
            </div>

            <div class="d-flex gap-2 mt-4">
                <button type="submit" class="btn btn-gold">Gửi duyệt</button>
                <a href="${ctx}/products/my" class="btn btn-outline-secondary">Hủy</a>
            </div>
        </form>
    </div>
</div>

