<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../shared/header.jsp" %>
<div class="container mt-4">
    <h2>Management Reports</h2>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <div class="row">
        <div class="col-md-6"><canvas id="revChart"></canvas></div>
        <div class="col-md-6"><canvas id="popChart"></canvas></div>
    </div>
</div>
<script>
new Chart(document.getElementById('revChart'), { type: 'bar', data: { labels: [<c:forEach var="s" items="${revenueStats}" varStatus="st">'${s.label}'${!st.last?',':''}</c:forEach>], datasets: [{ data: [<c:forEach var="s" items="${revenueStats}" varStatus="st">${s.value}${!st.last?',':''}</c:forEach>], backgroundColor: '#081c45' }] }, options: { plugins: { title: { display: true, text: 'Doanh thu (VND)' } } } });
new Chart(document.getElementById('popChart'), { type: 'pie', data: { labels: [<c:forEach var="s" items="${popularProducts}" varStatus="st">'${s.label}'${!st.last?',':''}</c:forEach>], datasets: [{ data: [<c:forEach var="s" items="${popularProducts}" varStatus="st">${s.count}${!st.last?',':''}</c:forEach>] }] }, options: { plugins: { title: { display: true, text: 'Sản phẩm phổ biến' } } } });
</script>
<%@ include file="../shared/footer.jsp" %>
