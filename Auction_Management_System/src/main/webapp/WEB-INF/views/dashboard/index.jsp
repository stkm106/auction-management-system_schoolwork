<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="page-header">
    <div>
        <h1>Dashboard</h1>
        <div class="breadcrumb-custom">Trang chủ &gt; Dashboard</div>
    </div>
</div>

<div class="row g-3 mb-4">
    <div class="col-lg-3 col-md-6">
        <div class="kpi-card">
            <div class="kpi-label">Tổng người dùng</div>
            <div class="kpi-value"><fmt:formatNumber value="${totalUsers}" groupingUsed="true"/></div>
            <div class="kpi-trend">+12.5% so với tháng trước</div>
        </div>
    </div>
    <div class="col-lg-3 col-md-6">
        <div class="kpi-card">
            <div class="kpi-label">Tổng sản phẩm</div>
            <div class="kpi-value"><fmt:formatNumber value="${totalProducts}" groupingUsed="true"/></div>
            <div class="kpi-trend">+8.2% so với tháng trước</div>
        </div>
    </div>
    <div class="col-lg-3 col-md-6">
        <div class="kpi-card">
            <div class="kpi-label">Phiên đấu giá đang diễn ra</div>
            <div class="kpi-value">${openAuctions}</div>
            <div class="kpi-trend text-muted">+2 so với hôm qua</div>
        </div>
    </div>
    <div class="col-lg-3 col-md-6">
        <div class="kpi-card">
            <div class="kpi-label">Doanh thu hệ thống tháng (10%)</div>
            <div class="kpi-value"><fmt:formatNumber value="${monthlyRevenue}" groupingUsed="true"/> &#8363;</div>
            <div class="kpi-trend">+15.7% so với tháng trước</div>
        </div>
    </div>
</div>

<div class="row g-3 mb-4">
    <div class="col-lg-8">
        <div class="chart-card">
            <div class="chart-card-header">
                <strong>Doanh thu 7 ngày qua</strong>
            </div>
            <div class="chart-card-body">
                <canvas id="revenueChart" height="120"></canvas>
            </div>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="chart-card h-100">
            <div class="chart-card-header">
                <strong>Top sản phẩm bán chạy</strong>
            </div>
            <div class="chart-card-body">
                <ul class="top-list">
                    <c:forEach var="item" items="${topProducts}" varStatus="st">
                        <li>
                            <span class="top-rank">${st.index + 1}</span>
                            <span class="top-name">${item.name}</span>
                            <span class="top-value">${item.sessions} phiên</span>
                        </li>
                    </c:forEach>
                    <c:if test="${empty topProducts}">
                        <li class="text-muted small">Chưa có dữ liệu</li>
                    </c:if>
                </ul>
            </div>
        </div>
    </div>
</div>

<div class="row g-3">
    <div class="col-lg-8">
        <div class="chart-card">
            <div class="chart-card-header">
                <strong>Hoạt động gần đây</strong>
            </div>
            <div class="chart-card-body">
                <ul class="activity-list">
                    <c:forEach var="act" items="${recentActivity}">
                        <li>
                            <span class="activity-dot"></span>
                            <div>
                                <div>${act.content}</div>
                                <small class="text-muted">${act.activityTime}</small>
                            </div>
                        </li>
                    </c:forEach>
                    <c:if test="${empty recentActivity}">
                        <li class="text-muted small">Chưa có hoạt động</li>
                    </c:if>
                </ul>
            </div>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="chart-card h-100">
            <div class="chart-card-header">
                <strong>Thống kê theo danh mục</strong>
            </div>
            <div class="chart-card-body">
                <canvas id="categoryChart" height="200"></canvas>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
<script>
(function () {
    var revenueData = [
        <c:forEach var="r" items="${revenueChart}" varStatus="st">
        { day: '${r.day}', total: ${r.total != null ? r.total : 0} }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];
    var revenueLabels = revenueData.map(function (d) { return d.day; });
    var revenueValues = revenueData.map(function (d) { return d.total; });

    if (revenueLabels.length === 0) {
        revenueLabels = ['T2','T3','T4','T5','T6','T7','CN'];
        revenueValues = [0, 0, 0, 0, 0, 0, 0];
    }

    new Chart(document.getElementById('revenueChart'), {
        type: 'line',
        data: {
            labels: revenueLabels,
            datasets: [{
                label: 'Doanh thu',
                data: revenueValues,
                borderColor: '#3a506b',
                backgroundColor: 'rgba(58, 80, 107, 0.1)',
                fill: true,
                tension: 0.4,
                pointBackgroundColor: '#d4af37'
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, grid: { color: '#f0f2f8' } },
                x: { grid: { display: false } }
            }
        }
    });

    var categoryLabels = [
        <c:forEach var="c" items="${categoryStats}" varStatus="st">
        '${c.name}'<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];
    var categoryValues = [
        <c:forEach var="c" items="${categoryStats}" varStatus="st">
        ${c.count != null ? c.count : 0}<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];

    if (categoryLabels.length > 0) {
        new Chart(document.getElementById('categoryChart'), {
            type: 'doughnut',
            data: {
                labels: categoryLabels,
                datasets: [{
                    data: categoryValues,
                    backgroundColor: ['#0b132b', '#1c2541', '#3a506b', '#d4af37', '#8b95a5']
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { position: 'bottom', labels: { boxWidth: 12, font: { size: 11 } } } }
            }
        });
    }
})();
</script>
