<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="adminTitle" value="Quản lý người dùng"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<%@ include file="../shared/admin-head.jsp" %>
</head>
<body>
<div class="admin-wrap">
    <%@ include file="../shared/admin-sidebar.jsp" %>
    <div class="admin-main">
        <h1 class="admin-page-title"><i class="fa-solid fa-user-group"></i> Quản lý người dùng</h1>

        <form class="admin-filter admin-filter-compact" method="get">
            <div class="form-group filter-search">
                <label class="form-label" for="keyword"><i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm</label>
                <input class="form-control" id="keyword" name="keyword" placeholder="Tên, email, username..." value="${keyword}">
            </div>
            <div class="form-group filter-role">
                <label class="form-label" for="role">Vai trò</label>
                <select class="form-control admin-select" id="role" name="role">
                    <option value="">Tất cả vai trò</option>
                    <option value="ADMIN" ${role == 'ADMIN' ? 'selected' : ''}>Quản trị viên</option>
                    <option value="AUCTION_MANAGER" ${role == 'AUCTION_MANAGER' ? 'selected' : ''}>Quản lý đấu giá</option>
                    <option value="STAFF" ${role == 'STAFF' ? 'selected' : ''}>Nhân viên</option>
                    <option value="CUSTOMER" ${role == 'CUSTOMER' ? 'selected' : ''}>Khách hàng</option>
                </select>
            </div>
            <button class="btn-gold btn-filter" type="submit"><i class="fa-solid fa-filter"></i> Lọc</button>
        </form>

        <div class="admin-table-wrap">
            <table class="data-table table-users">
                <thead>
                    <tr>
                        <th class="col-id">ID</th>
                        <th class="col-user">Tên đăng nhập</th>
                        <th class="col-name">Họ tên</th>
                        <th class="col-email">Email</th>
                        <th class="col-action">Cập nhật</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${users}">
                        <tr>
                            <td>${u.userId}</td>
                            <td><strong>${u.username}</strong></td>
                            <td>${u.fullName}</td>
                            <td class="cell-email" title="${u.email}">${u.email}</td>
                            <td>
                                <form method="post" action="${pageContext.request.contextPath}/admin/users/update" class="table-update-form">
                                    <input type="hidden" name="userId" value="${u.userId}">
                                    <div class="table-update-row">
                                        <label class="sr-only">Vai trò</label>
                                        <select name="role" class="admin-select admin-select-sm" title="Vai trò">
                                            <option value="ADMIN" ${u.role == 'ADMIN' ? 'selected' : ''}>Quản trị viên</option>
                                            <option value="AUCTION_MANAGER" ${u.role == 'AUCTION_MANAGER' ? 'selected' : ''}>Quản lý</option>
                                            <option value="STAFF" ${u.role == 'STAFF' ? 'selected' : ''}>Nhân viên</option>
                                            <option value="CUSTOMER" ${u.role == 'CUSTOMER' ? 'selected' : ''}>Khách hàng</option>
                                        </select>
                                        <label class="sr-only">Trạng thái</label>
                                        <select name="status" class="admin-select admin-select-sm" title="Trạng thái">
                                            <option value="ACTIVE" ${u.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                                            <option value="INACTIVE" ${u.status == 'INACTIVE' ? 'selected' : ''}>Ngưng HĐ</option>
                                        </select>
                                    </div>
                                    <button class="btn-sm btn-sm-gold btn-save-row" type="submit"><i class="fa-solid fa-check"></i> Lưu</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty users}">
                        <tr><td colspan="5" class="table-empty">Không tìm thấy người dùng</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
