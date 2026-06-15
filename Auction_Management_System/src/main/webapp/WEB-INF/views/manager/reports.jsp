<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="panelTitle" value="Báo cáo"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<%@ include file="../shared/manager-head.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<div class="admin-wrap">
    <%@ include file="../shared/manager-sidebar.jsp" %>
    <div class="admin-main">
        <h1 class="admin-page-title"><i class="fa-solid fa-chart-pie"></i> Báo cáo quản lý</h1>
        <p class="panel-intro">Xem báo cáo thống kê doanh thu, sản phẩm phổ biến và hoạt động đặt giá theo tháng.</p>

        <div style="display:grid;grid-template-columns:1fr 1fr;gap:24px">
            <div class="admin-form-card">
                <h3><i class="fa-solid fa-chart-column"></i> Doanh thu theo phiên</h3>
                <canvas id="revChart" height="220"></canvas>
            </div>
            <div class="admin-form-card">
                <h3><i class="fa-solid fa-star"></i> Sản phẩm phổ biến</h3>
                <canvas id="popChart" height="220"></canvas>
            </div>
            <div class="admin-form-card" style="grid-column:1/-1">
                <h3><i class="fa-solid fa-chart-line"></i> Lượt đặt giá theo tháng</h3>
                <canvas id="bidChart" height="120"></canvas>
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

new Chart(document.getElementById('revChart'), {
    type: 'bar',
    data: { labels: revenueLabels, datasets: [{ label: 'Doanh thu (VND)', data: revenueData, backgroundColor: '#d4a44b' }] },
    options: { plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true } } }
});
new Chart(document.getElementById('popChart'), {
    type: 'doughnut',
    data: { labels: popularLabels, datasets: [{ data: popularData, backgroundColor: ['#071739','#0f2b63','#d4a44b','#94a3b8','#64748b'] }] }
});
new Chart(document.getElementById('bidChart'), {
    type: 'line',
    data: { labels: bidLabels, datasets: [{ label: 'Lượt đặt giá', data: bidData, borderColor: '#071739', tension: 0.3, fill: false }] },
    options: { scales: { y: { beginAtZero: true } } }
});
</script>
</body>
</html>
