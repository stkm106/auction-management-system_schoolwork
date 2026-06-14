<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="adminTitle" value="Quản lý danh mục"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<%@ include file="../shared/admin-head.jsp" %>
</head>
<body>
<div class="admin-wrap">
    <%@ include file="../shared/admin-sidebar.jsp" %>
    <div class="admin-main">
        <h1 class="admin-page-title"><i class="fa-solid fa-folder-tree"></i> Quản lý danh mục</h1>

        <div class="admin-form-card">
            <h3><i class="fa-solid fa-folder-plus"></i> Thêm / Sửa danh mục</h3>
            <form method="post" action="${pageContext.request.contextPath}/admin/categories/save" class="admin-form-stacked">
                <input type="hidden" name="categoryId" id="categoryId">
                <div class="admin-form-fields admin-form-fields--with-btn">
                    <div class="form-group">
                        <label class="form-label" for="name">Tên danh mục</label>
                        <input type="text" name="name" id="name" class="form-control" placeholder="VD: Điện tử" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="description">Mô tả</label>
                        <input type="text" name="description" id="description" class="form-control" placeholder="Mô tả ngắn">
                    </div>
                    <div class="admin-form-btn-col">
                        <button type="submit" class="btn-form-save"><i class="fa-solid fa-check"></i> Lưu</button>
                    </div>
                </div>
            </form>
        </div>

        <div class="admin-table-wrap">
        <table class="data-table">
            <thead><tr><th>ID</th><th>Tên</th><th>Mô tả</th><th></th></tr></thead>
            <tbody>
            <c:forEach var="c" items="${categories}">
                <tr>
                    <td>${c.categoryId}</td>
                    <td><strong>${c.name}</strong></td>
                    <td>${c.description}</td>
                    <td>
                        <div class="table-inline-form">
                            <button type="button" class="btn-sm btn-sm-gold"
                                    onclick="editCat('${c.categoryId}', '${c.name}', '${c.description}')">
                                <i class="fa-solid fa-pen"></i> Sửa
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/categories/delete/${c.categoryId}"
                               class="btn-sm btn-sm-navy" style="text-decoration:none"
                               onclick="return confirm('Xóa danh mục này?')">
                                <i class="fa-solid fa-trash"></i> Xóa
                            </a>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        </div>
    </div>
</div>
<script>
function editCat(id, name, description) {
    document.getElementById("categoryId").value = id;
    document.getElementById("name").value = name;
    document.getElementById("description").value = description;
    document.getElementById("name").focus();
}
</script>
</body>
</html>
