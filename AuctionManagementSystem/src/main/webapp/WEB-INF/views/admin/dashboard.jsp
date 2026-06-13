<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <link href="${pageContext.request.contextPath}/css/auctionpro.css" rel="stylesheet"/>
</head>
<body>
<div class="admin-wrap">
    <%@ include file="../shared/admin-sidebar.jsp" %>
    <div class="admin-main">
        <h1 style="color:var(--navy);margin-bottom:30px">Dashboard</h1>
        <div class="dashboard-grid" style="grid-template-columns:repeat(4,1fr)">
            <div class="dashboard-card" style="background:#fff;color:var(--navy)"><i class="fa-solid fa-users" style="color:var(--gold)"></i><h2>${totalUsers}</h2><p>Users</p></div>
            <div class="dashboard-card" style="background:#fff;color:var(--navy)"><i class="fa-solid fa-gavel" style="color:var(--gold)"></i><h2>${totalAuctions}</h2><p>Auctions</p></div>
            <div class="dashboard-card" style="background:#fff;color:var(--navy)"><i class="fa-solid fa-clock" style="color:var(--gold)"></i><h2>${activeAuctions}</h2><p>Active</p></div>
            <div class="dashboard-card" style="background:#fff;color:var(--navy)"><i class="fa-solid fa-coins" style="color:var(--gold)"></i><h2><tags:formatVnd value="${revenue}"/></h2><p>Phí sàn</p></div>
        </div>
        <table class="data-table" style="margin-top:30px">
            <thead><tr><th>ID</th><th>Sản phẩm</th><th>Giá hiện tại</th><th>Trạng thái</th></tr></thead>
            <tbody>
            <c:forEach var="a" items="${recentAuctions}">
                <tr><td>${a.auctionId}</td><td>${a.productName}</td><td><tags:formatVnd value="${a.currentPrice}"/></td><td>${a.status}</td></tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
