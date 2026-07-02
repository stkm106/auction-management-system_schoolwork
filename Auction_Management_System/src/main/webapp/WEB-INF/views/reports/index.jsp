<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="page-header">
    <div>
        <h1>Báo cáo thống kê</h1>
        <div class="breadcrumb-custom">Trang chủ &gt; Báo cáo thống kê</div>
    </div>
    <div class="d-flex gap-2">
        <button class="btn btn-outline-secondary btn-sm">Lọc nâng cao</button>
        <button class="btn btn-gold btn-sm">Xuất báo cáo</button>
    </div>
</div>

<div class="row g-3 mb-4">
    <div class="col-lg-2 col-md-4 col-6">
        <div class="kpi-card">
            <div class="kpi-label">Tổng doanh thu</div>
            <div class="kpi-value">${totalRevenue} &#8363;</div>
            <div class="kpi-trend">+12.5%</div>
        </div>
    </div>
    <div class="col-lg-2 col-md-4 col-6">
        <div class="kpi-card">
            <div class="kpi-label">Tổng giao dịch</div>
            <div class="kpi-value">${revenues.size()}</div>
            <div class="kpi-trend">+10.3%</div>
        </div>
    </div>
    <div class="col-lg-2 col-md-4 col-6">
        <div class="kpi-card">
            <div class="kpi-label">Đã thanh toán</div>
            <div class="kpi-value">${paidCount}</div>
        </div>
    </div>
    <div class="col-lg-2 col-md-4 col-6">
        <div class="kpi-card">
            <div class="kpi-label">Đang chờ</div>
            <div class="kpi-value">${pendingCount}</div>
        </div>
    </div>
    <div class="col-lg-2 col-md-4 col-6">
        <div class="kpi-card">
            <div class="kpi-label">Phiên đấu giá</div>
            <div class="kpi-value">--</div>
        </div>
    </div>
    <div class="col-lg-2 col-md-4 col-6">
        <div class="kpi-card">
            <div class="kpi-label">Thành viên</div>
            <div class="kpi-value">--</div>
        </div>
    </div>
</div>

<div class="data-table-wrap">
    <div class="p-3 border-bottom">
        <strong>Doanh thu theo giao dịch</strong>
    </div>
    <table class="table data-table mb-0">
        <thead>
        <tr>
            <th>Mã GD</th>
            <th>Phiên đấu giá</th>
            <th>Người mua</th>
            <th>Số tiền</th>
            <th>Trạng thái</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="r" items="${revenues}">
            <tr>
                <td>#${r.paymentID}</td>
                <td>AUC-${r.auctionID}</td>
                <td>User #${r.buyerID}</td>
                <td class="price-gold">${r.amount} &#8363;</td>
                <td>
                    <c:choose>
                        <c:when test="${r.status == 'Paid'}">
                            <span class="badge-status badge-active">Đã thanh toán</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge-status badge-pending">${r.status}</span>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
