<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Reports</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/dashboard.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<div class="wrapper">
    <%@ include file="../shared/admin-sidebar.jsp" %>
    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2>Statistical Reports</h2>
            <div>
                <a href="${pageContext.request.contextPath}/admin/reports/export/revenue?format=excel" class="btn btn-success btn-sm">Export Excel</a>
                <a href="${pageContext.request.contextPath}/admin/reports/export/revenue?format=pdf" class="btn btn-danger btn-sm">Export PDF</a>
                <a href="${pageContext.request.contextPath}/admin/reports/export/payments" class="btn btn-primary btn-sm">Export Payments</a>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6 mb-4">
                <div class="card p-3"><h5>Revenue by Auction</h5><canvas id="revenueChart"></canvas></div>
            </div>
            <div class="col-md-6 mb-4">
                <div class="card p-3"><h5>Most Popular Items (bid count)</h5><canvas id="popularChart"></canvas></div>
            </div>
            <div class="col-md-12 mb-4">
                <div class="card p-3"><h5>Bidding Activity by Month</h5><canvas id="bidChart"></canvas></div>
            </div>
        </div>
    </div>
</div>
<script>
const revenueLabels = [<c:forEach var="s" items="${revenueStats}" varStatus="st">'${s.label}'${!st.last ? ',' : ''}</c:forEach>];
const revenueData = [<c:forEach var="s" items="${revenueStats}" varStatus="st">${s.value}${!st.last ? ',' : ''}</c:forEach>];
const popularLabels = [<c:forEach var="s" items="${popularItems}" varStatus="st">'${s.label}'${!st.last ? ',' : ''}</c:forEach>];
const popularData = [<c:forEach var="s" items="${popularItems}" varStatus="st">${s.count}${!st.last ? ',' : ''}</c:forEach>];
const bidLabels = [<c:forEach var="s" items="${bidStats}" varStatus="st">'${s.label}'${!st.last ? ',' : ''}</c:forEach>];
const bidData = [<c:forEach var="s" items="${bidStats}" varStatus="st">${s.count}${!st.last ? ',' : ''}</c:forEach>];

new Chart(document.getElementById('revenueChart'), { type: 'bar', data: { labels: revenueLabels, datasets: [{ label: 'Doanh thu (VND)', data: revenueData, backgroundColor: '#f0b84c' }] } });
new Chart(document.getElementById('popularChart'), { type: 'doughnut', data: { labels: popularLabels, datasets: [{ data: popularData }] } });
new Chart(document.getElementById('bidChart'), { type: 'line', data: { labels: bidLabels, datasets: [{ label: 'Bids', data: bidData, borderColor: '#081c45', fill: false }] } });
</script>
</body>
</html>
