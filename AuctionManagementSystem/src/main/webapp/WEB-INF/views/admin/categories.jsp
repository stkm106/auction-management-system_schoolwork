<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh mục — Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <link href="${pageContext.request.contextPath}/css/auctionpro.css" rel="stylesheet"/>
</head>
<body>
<div class="admin-wrap">
    <%@ include file="../shared/admin-sidebar.jsp" %>
    <div class="admin-main">
        <h1 style="color:var(--navy);margin-bottom:24px">Quản lý danh mục</h1>

        <div class="admin-form-card">
            <div class="form-card-header" style="border:none;padding:0;margin-bottom:20px">
                <h3 style="text-align:left"><i class="fa-solid fa-folder-plus"></i> Thêm / Sửa danh mục</h3>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/admin/categories/save" class="admin-form-inline">
                <input type="hidden" name="categoryId" id="categoryId">
                <div class="form-group">
                    <label class="form-label" for="name">Tên danh mục</label>
                    <input type="text" name="name" id="name" class="form-control" placeholder="Electronics" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="description">Mô tả</label>
                    <input type="text" name="description" id="description" class="form-control" placeholder="Mô tả ngắn">
                </div>
                <button type="submit" class="btn-navy" style="width:auto;padding:14px 28px"><i class="fa-solid fa-save"></i> Lưu</button>
            </form>
        </div>

        <table class="data-table">
            <thead><tr><th>ID</th><th>Tên</th><th>Mô tả</th><th>Thao tác</th></tr></thead>
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
                               class="btn-sm btn-sm-navy" style="text-decoration:none;display:inline-block"
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
