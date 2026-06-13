<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Schedules</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/dashboard.css" rel="stylesheet">
</head>
<body>
<div class="wrapper">
    <%@ include file="../shared/admin-sidebar.jsp" %>
    <div class="main-content">
        <h2>Schedules & Assignments</h2>
        <form class="card p-3 mb-3" method="post" action="${pageContext.request.contextPath}/admin/schedules/save">
            <div class="row g-2">
                <div class="col-md-3">
                    <select name="auctionId" class="form-select" required>
                        <c:forEach var="a" items="${auctions}"><option value="${a.auctionId}">${a.itemName}</option></c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <select name="staffId" class="form-select" required>
                        <c:forEach var="s" items="${staffList}"><option value="${s.userId}">${s.fullName}</option></c:forEach>
                    </select>
                </div>
                <div class="col-md-3"><input type="datetime-local" name="scheduledDate" class="form-control" required></div>
                <div class="col-md-3"><input name="taskDescription" class="form-control" placeholder="Task" required></div>
                <div class="col-12"><button class="btn btn-primary">Add Schedule</button></div>
            </div>
        </form>
        <table class="table table-bordered bg-white">
            <thead><tr><th>Item</th><th>Staff</th><th>Task</th><th>Date</th><th>Status</th><th></th></tr></thead>
            <tbody>
            <c:forEach var="s" items="${schedules}">
                <tr>
                    <td>${s.itemName}</td>
                    <td>${s.staffName}</td>
                    <td>${s.taskDescription}</td>
                    <td><fmt:formatDate value="${s.scheduledDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                    <td>${s.status}</td>
                    <td>
                        <form method="post" action="${pageContext.request.contextPath}/admin/schedules/status">
                            <input type="hidden" name="scheduleId" value="${s.scheduleId}">
                            <select name="status" class="form-select form-select-sm">
                                <option value="PENDING">PENDING</option>
                                <option value="DONE">DONE</option>
                            </select>
                            <button class="btn btn-sm btn-success">Update</button>
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
