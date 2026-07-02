<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="page-header">
    <div>
        <h1>Quản lý người dùng</h1>
        <div class="breadcrumb-custom">Trang chủ &gt; Quản lý người dùng</div>
    </div>
    <div class="d-flex gap-2">
        <button class="btn btn-outline-secondary btn-sm">Xuất Excel</button>
        <a href="${ctx}/users/create" class="btn btn-gold btn-sm">+ Thêm người dùng</a>
    </div>
</div>

<div class="filter-bar">
    <form class="row g-2 align-items-end" method="get" action="${ctx}/users">
        <div class="col-md-5">
            <input type="text" name="keyword" class="form-control" placeholder="Tìm kiếm theo tên, email, SĐT..." value="${param.keyword}">
        </div>
        <div class="col-md-2">
            <select name="roleID" class="form-select">
                <option value="">Tất cả vai trò</option>
                <c:forEach var="role" items="${roles}">
                    <option value="${role.roleID}" ${param.roleID == role.roleID ? 'selected' : ''}>
                            <c:choose>
                                <c:when test="${role.roleName == 'ADMIN'}">Quản trị viên</c:when>
                                <c:when test="${role.roleName == 'MANAGER'}">Auction Manager</c:when>
                                <c:when test="${role.roleName == 'STAFF'}">Staff</c:when>
                                <c:when test="${role.roleName == 'CUSTOMER'}">Customer</c:when>
                                <c:otherwise>${role.roleName}</c:otherwise>
                            </c:choose>
                    </option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-2">
            <select name="status" class="form-select">
                <option value="">Tất cả trạng thái</option>
                <option value="Active" ${param.status == 'Active' ? 'selected' : ''}>Hoạt động</option>
                <option value="Inactive" ${param.status == 'Inactive' ? 'selected' : ''}>Không hoạt động</option>
                <option value="Locked" ${param.status == 'Locked' ? 'selected' : ''}>Bị khóa</option>
            </select>
        </div>
        <div class="col-md-3 d-flex gap-2">
            <button type="submit" class="btn btn-dark">Lọc</button>
            <a href="${ctx}/users" class="btn btn-outline-secondary">Đặt lại</a>
        </div>
    </form>
</div>

<div class="data-table-wrap">
    <table class="table data-table mb-0">
        <thead>
        <tr>
            <th>ID</th>
            <th>Họ tên</th>
            <th>Email</th>
            <th>Số điện thoại</th>
            <th>Trạng thái</th>
            <th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="u" items="${users}">
            <tr>
                <td>${u.userID}</td>
                <td>
                    <div class="d-flex align-items-center gap-2">
                        <span class="avatar-sm"><c:out value="${u.fullName != null && u.fullName.length() > 0 ? u.fullName.substring(0,1) : u.username.substring(0,1)}"/></span>
                        <div>
                            <strong>${u.fullName}</strong><br>
                            <small class="text-muted">
                                <c:choose>
                                    <c:when test="${not empty u.roles}">
                                        <c:forEach var="role" items="${u.roles}">
                            <c:choose>
                                <c:when test="${role.roleName == 'ADMIN'}">Quản trị viên</c:when>
                                <c:when test="${role.roleName == 'MANAGER'}">Auction Manager</c:when>
                                <c:when test="${role.roleName == 'STAFF'}">Staff</c:when>
                                <c:when test="${role.roleName == 'CUSTOMER'}">Customer</c:when>
                                <c:otherwise>${role.roleName}</c:otherwise>
                            </c:choose>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>Chưa phân vai trò</c:otherwise>
                                </c:choose>
                            </small>
                        </div>
                    </div>
                </td>
                <td>${u.email}</td>
                <td>${u.phone}</td>
                <td>
                    <c:choose>
                        <c:when test="${u.status == 'Active'}">
                            <span class="badge-status badge-active">Hoạt động</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge-status badge-locked">Bị khóa</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <a href="${ctx}/users/edit/${u.userID}" class="btn btn-sm btn-outline-primary">&#9998;</a>
                    <a href="${ctx}/users/delete/${u.userID}" class="btn btn-sm btn-outline-danger"
                       onclick="return confirm('Xóa người dùng này?')">&#128465;</a>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty users}">
            <tr>
                <td colspan="6" class="text-center text-muted py-4">Không tìm thấy người dùng phù hợp.</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>

<div class="d-flex justify-content-between align-items-center mt-3 small text-muted">
    <span>Hiển thị ${users.size()} người dùng</span>
</div>
