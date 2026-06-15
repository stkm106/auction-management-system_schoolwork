<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="adminTitle" value="Báo cáo thống kê"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<%@ include file="../shared/admin-head.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<div class="admin-wrap">
    <%@ include file="../shared/admin-sidebar.jsp" %>
    <div class="admin-main">
        <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:16px;margin-bottom:28px">
            <h1 class="admin-page-title" style="margin:0"><i class="fa-solid fa-chart-pie"></i> Báo cáo thống kê</h1>
            <div class="table-inline-form">
                <a href="${pageContext.request.contextPath}/admin/reports/export/revenue?format=excel" class="btn-sm btn-sm-gold" style="text-decoration:none">Xuất Excel</a>
                <a href="${pageContext.request.contextPath}/admin/reports/export/revenue?format=pdf" class="btn-sm btn-sm-navy" style="text-decoration:none">Xuất PDF</a>
                <a href="${pageContext.request.contextPath}/admin/reports/export/payments" class="btn-sm btn-sm-gold" style="text-decoration:none">Xuất thanh toán</a>
            </div>
        </div>
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:24px">
            <div class="admin-form-card">
                <h3><i class="fa-solid fa-chart-column"></i> Doanh thu theo phiên</h3>
                <canvas id="revenueChart"></canvas>
            </div>
            <div class="admin-form-card">
                <h3><i class="fa-solid fa-star"></i> Sản phẩm phổ biến</h3>
                <canvas id="popularChart"></canvas>
            </div>
            <div class="admin-form-card" style="grid-column:1/-1">
                <h3><i class="fa-solid fa-chart-line"></i> Đặt giá theo tháng</h3>
                <canvas id="bidChart"></canvas>
            </div>
        </div>
    </div>
</div>
<script>
const revenueLabels = [<c:forEach var="s" items="${revenueStats}" varStatus="st">'${s.label}'${!st.last ? ',' : ''}</c:forEach>];
const revenueData = [<c:forEach var="s" items="${revenueStats}" varStatus="st">${s.value}${!st.last ? ',' : ''}</c:forEach>];
const popularLabels = [<c:forEach var="s" items="${popularProducts}" varStatus="st">'${s.label}'${!st.last ? ',' : ''}</c:forEach>];
const popularData = [<c:forEach var="s" items="${popularProducts}" varStatus="st">${s.count}${!st.last ? ',' : ''}</c:forEach>];
const bidLabels = [<c:forEach var="s" items="${bidStats}" varStatus="st">'${s.label}'${!st.last ? ',' : ''}</c:forEach>];
const bidData = [<c:forEach var="s" items="${bidStats}" varStatus="st">${s.count}${!st.last ? ',' : ''}</c:forEach>];

new Chart(document.getElementById('revenueChart'), { type: 'bar', data: { labels: revenueLabels, datasets: [{ label: 'Doanh thu (VND)', data: revenueData, backgroundColor: '#d4a44b' }] } });
new Chart(document.getElementById('popularChart'), { type: 'doughnut', data: { labels: popularLabels, datasets: [{ data: popularData, backgroundColor: ['#071739','#0f2b63','#d4a44b','#94a3b8','#64748b'] }] } });
new Chart(document.getElementById('bidChart'), { type: 'line', data: { labels: bidLabels, datasets: [{ label: 'Lượt đặt giá', data: bidData, borderColor: '#071739', fill: false }] } });
</script>
</body>
</html>
