<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Thêm sản phẩm"/>
<%@ include file="../shared/header.jsp" %>

<section class="page-section">
    <div class="form-page" style="min-height:auto;padding:0;background:none">
        <div class="form-box form-box-wide" style="margin:0 auto">
            <h2><i class="fa-solid fa-box-open text-gold"></i> Đăng bán sản phẩm</h2>
            <p class="form-box-subtitle">Điền thông tin sản phẩm — admin sẽ duyệt trước khi mở đấu giá</p>

            <form method="post" action="${pageContext.request.contextPath}/seller/product/save">
                <div class="form-group">
                    <label class="form-label" for="name"><i class="fa-solid fa-tag"></i> Tên sản phẩm</label>
                    <input class="form-control" id="name" name="name" placeholder="VD: MacBook Pro M3 14 inch" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="description"><i class="fa-solid fa-align-left"></i> Mô tả</label>
                    <textarea class="form-control" id="description" name="description" placeholder="Mô tả chi tiết tình trạng, phụ kiện kèm theo..." rows="4"></textarea>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="startingPrice"><i class="fa-solid fa-coins"></i> Giá khởi điểm (VND)</label>
                        <input class="form-control" id="startingPrice" type="number" step="1000" min="1000" name="startingPrice" placeholder="35000000" required>
                        <p class="form-hint">Bước giá tối thiểu: 1.000 ₫</p>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="categoryId"><i class="fa-solid fa-folder"></i> Danh mục</label>
                        <select class="form-control" id="categoryId" name="categoryId" required>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.categoryId}">${c.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="conditionStatus"><i class="fa-solid fa-star"></i> Tình trạng</label>
                        <select class="form-control" id="conditionStatus" name="conditionStatus">
                            <option value="NEW">Mới</option>
                            <option value="LIKE_NEW">Như mới</option>
                            <option value="GOOD" selected>Tốt</option>
                            <option value="FAIR">Khá</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="imageUrl"><i class="fa-solid fa-image"></i> URL ảnh</label>
                        <input class="form-control" id="imageUrl" name="imageUrl" placeholder="https://...">
                    </div>
                </div>
                <div class="form-actions">
                    <button class="btn-navy" type="submit"><i class="fa-solid fa-paper-plane"></i> Gửi duyệt</button>
                    <a href="${pageContext.request.contextPath}/seller/products" class="btn-outline-navy" style="text-align:center;display:block">Hủy</a>
                </div>
            </form>
        </div>
    </div>
</section>

<%@ include file="../shared/footer.jsp" %>
