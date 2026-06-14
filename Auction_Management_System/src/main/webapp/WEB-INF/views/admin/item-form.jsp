<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sản phẩm — Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <link href="${pageContext.request.contextPath}/css/auctionpro.css" rel="stylesheet"/>
</head>
<body>
<div class="admin-wrap">
    <%@ include file="../shared/admin-sidebar.jsp" %>
    <div class="admin-main">
        <h1 style="color:var(--navy);margin-bottom:8px">Thêm / Sửa sản phẩm</h1>
        <p style="color:#888;margin-bottom:24px">Form quản lý sản phẩm (legacy)</p>

        <div class="form-box form-box-wide" style="margin:0;max-width:100%">
            <form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/admin/items/save">
                <c:if test="${not empty item}"><input type="hidden" name="itemId" value="${item.itemId}"></c:if>

                <div class="form-group">
                    <label class="form-label" for="itemName"><i class="fa-solid fa-tag"></i> Tên sản phẩm</label>
                    <input id="itemName" name="itemName" class="form-control" value="${item.itemName}" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="description"><i class="fa-solid fa-align-left"></i> Mô tả</label>
                    <textarea id="description" name="description" class="form-control" rows="3">${item.description}</textarea>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="startPrice"><i class="fa-solid fa-coins"></i> Giá khởi điểm (VND)</label>
                        <input id="startPrice" type="number" step="1000" min="1000" name="startPrice" class="form-control" value="${item.startPrice}" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="categoryId"><i class="fa-solid fa-folder"></i> Danh mục</label>
                        <select id="categoryId" name="categoryId" class="form-control" required>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.categoryId}" ${item.categoryId == cat.categoryId ? 'selected' : ''}>${cat.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="imageUrl"><i class="fa-solid fa-link"></i> URL ảnh</label>
                        <input id="imageUrl" name="imageUrl" class="form-control" value="${item.image}">
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="imageFile"><i class="fa-solid fa-upload"></i> Hoặc tải ảnh lên</label>
                        <input id="imageFile" type="file" name="imageFile" class="form-control" accept="image/*">
                    </div>
                </div>
                <div class="form-actions">
                    <button class="btn-navy" type="submit"><i class="fa-solid fa-save"></i> Lưu sản phẩm</button>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>
