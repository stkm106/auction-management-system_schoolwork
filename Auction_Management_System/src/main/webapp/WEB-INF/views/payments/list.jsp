<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="page-header">
    <div>
        <h1>Giám sát giao dịch &amp; thanh toán</h1>
        <div class="breadcrumb-custom">Trang chủ &gt; Giám sát giao dịch</div>
    </div>
    <div class="d-flex gap-2">
        <button class="btn btn-outline-secondary btn-sm">Xuất Excel</button>
    </div>
</div>

<div class="filter-bar">
    <form class="row g-2 align-items-end" method="get" action="${ctx}/payments">
        <div class="col-md-4">
            <input type="text" name="keyword" class="form-control" placeholder="Tìm kiếm theo mã giao dịch..." value="${param.keyword}">
        </div>
        <div class="col-md-2">
            <select name="type" class="form-select">
                <option value="">Tất cả loại giao dịch</option>
                <option value="Payment" ${param.type == 'Payment' ? 'selected' : ''}>Thanh toán</option>
                <option value="Deposit" ${param.type == 'Deposit' ? 'selected' : ''}>Nạp tiền</option>
                <option value="Withdraw" ${param.type == 'Withdraw' ? 'selected' : ''}>Rút tiền</option>
            </select>
        </div>
        <div class="col-md-2">
            <select name="status" class="form-select">
                <option value="">Tất cả trạng thái</option>
                <option value="Paid" ${param.status == 'Paid' ? 'selected' : ''}>Thành công</option>
                <option value="Pending" ${param.status == 'Pending' ? 'selected' : ''}>Chờ xử lý</option>
                <option value="Cancelled" ${param.status == 'Cancelled' ? 'selected' : ''}>Thất bại</option>
            </select>
        </div>
        <div class="col-md-4 d-flex gap-2">
            <button type="submit" class="btn btn-dark">Lọc</button>
            <a href="${ctx}/payments" class="btn btn-outline-secondary">Đặt lại</a>
        </div>
    </form>
</div>

<div class="data-table-wrap">
    <table class="table data-table mb-0">
        <thead>
        <tr>
            <th>ID mã giao dịch</th>
            <th>Người dùng</th>
            <th>Loại giao dịch</th>
            <th>Số tiền</th>
            <th>Phương thức</th>
            <th>Trạng thái</th>
            <th>Thời gian</th>
            <th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="p" items="${payments}">
            <tr>
                <td><strong>#TXN-${p.paymentID}</strong></td>
                <td>
                    <div class="d-flex align-items-center gap-2">
                        <span class="avatar-sm"><c:out value="${userMap[p.buyerID] != null && userMap[p.buyerID].length() > 0 ? userMap[p.buyerID].substring(0,1) : 'U'}"/></span>
                        <span>${userMap[p.buyerID] != null ? userMap[p.buyerID] : 'User #'}${p.buyerID}</span>
                    </div>
                </td>
                <td>Thanh toán</td>
                <td class="price-gold"><fmt:formatNumber value="${p.amount}" groupingUsed="true"/> &#8363;</td>
                <td>Ví điện tử</td>
                <td>
                    <c:choose>
                        <c:when test="${p.status == 'Paid'}">
                            <span class="badge-status badge-active">Thành công</span>
                        </c:when>
                        <c:when test="${p.status == 'Pending'}">
                            <span class="badge-status badge-pending">Chờ xử lý</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge-status badge-locked">Thất bại</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td><fmt:formatDate value="${p.paymentDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                <td>
                    <a href="${ctx}/payments/monitor/${p.paymentID}" class="btn btn-sm btn-outline-primary" title="Giám sát">&#128065;</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<div class="d-flex justify-content-between align-items-center mt-3 small text-muted">
    <span>Hiển thị ${payments.size()} giao dịch</span>
</div>
