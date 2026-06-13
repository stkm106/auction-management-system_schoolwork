<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Users</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/dashboard.css" rel="stylesheet">
    </head>
    <body>
        <div class="wrapper">
            <%@ include file="../shared/admin-sidebar.jsp" %>
            <div class="main-content">
                <h2>User Management</h2>
                <form class="row g-2 mb-3" method="get">
                    <div class="col-md-4"><input name="keyword" class="form-control" placeholder="Search" value="${keyword}"></div>
                    <div class="col-md-3">
                        <select name="roleId" class="form-select">
                            <option value="">All roles</option>
                            <option value="1" ${roleId == 1 ? 'selected' : ''}>ADMIN</option>
                            <option value="2" ${roleId == 2 ? 'selected' : ''}>AUCTION_MANAGER</option>
                            <option value="3" ${roleId == 3 ? 'selected' : ''}>STAFF</option>
                            <option value="4" ${roleId == 4 ? 'selected' : ''}>CUSTOMER</option>
                        </select>
                    </div>
                    <div class="col-md-2"><button class="btn btn-primary">Filter</button></div>
                </form>
                <table class="table table-bordered bg-white">
                    <thead><tr><th>ID</th><th>Username</th><th>Name</th><th>Email</th><th>Role</th><th>Change Role</th></tr></thead>
                    <tbody>
                        <c:forEach var="u" items="${users}">
                            <tr>
                                <td>${u.userId}</td>
                                <td>${u.username}</td>
                                <td>${u.fullName}</td>
                                <td>${u.email}</td>
                                <td>${u.role}</td>
                                <td>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/users/update" class="d-flex gap-1">
                                        <input type="hidden" name="userId" value="${u.userId}">
                                        <input type="hidden" name="fullName" value="${u.fullName}">
                                        <input type="hidden" name="email" value="${u.email}">
                                        <input type="hidden" name="phone" value="${u.phone}">

                                        <select name="role" class="form-select form-select-sm">
                                            <option value="ADMIN" ${u.role == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                                            <option value="STAFF" ${u.role == 'STAFF' ? 'selected' : ''}>STAFF</option>
                                            <option value="USER" ${u.role == 'USER' ? 'selected' : ''}>USER</option>
                                        </select>

                                        <button class="btn btn-sm btn-warning">Save</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
