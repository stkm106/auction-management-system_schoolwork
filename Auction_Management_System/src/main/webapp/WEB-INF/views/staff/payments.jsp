<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="panelTitle" value="Thanh toán chờ"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<%@ include file="../shared/staff-head.jsp" %>
</head>
<body>
<div class="admin-wrap">
    <%@ include file="../shared/staff-sidebar.jsp" %>
    <div class="admin-main">
        <h1 class="admin-page-title"><i class="fa-solid fa-credit-card"></i> Thanh toán chờ xử lý</h1>
        <p class="panel-intro">Theo dõi hóa đơn sau khi phiên kết thúc — khách hàng tự thanh toán qua ví điện tử.</p>

        <div class="panel-summary">
            <div class="panel-summary-item">
                <strong>${pendingCount}</strong>
                <span>Hóa đơn chờ thanh toán</span>
            </div>
        </div>

        <div class="admin-form-card" style="margin-bottom:24px">
            <h3><i class="fa-solid fa-circle-info"></i> Hướng dẫn</h3>
            <p style="margin:0;color:#64748b;font-size:14px;line-height:1.7">
                Nhân viên <strong>không thu tiền trực tiếp</strong>. Khi người thắng vào mục Thanh toán và trả từ ví,
                trạng thái sẽ tự đổi thành <span class="badge badge-active">Đã thanh toán</span>.
                Nếu không đủ tiền, hệ thống tịch thu tiền cọc.
            </p>
        </div>

        <div class="admin-table-wrap">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Mã HĐ</th>
                        <th>Sản phẩm</th>
                        <th>Người mua</th>
                        <th>Tổng tiền</th>
                        <th>Cọc đã dùng</th>
                        <th>Phí sàn</th>
                        <th>Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="p" items="${payments}">
                    <tr>
                        <td><strong>#${p.paymentId}</strong></td>
                        <td>${p.productName}</td>
                        <td>${p.buyerName}</td>
                        <td><tags:formatVnd value="${p.amount}"/></td>
                        <td><tags:formatVnd value="${p.depositUsed}"/></td>
                        <td><tags:formatVnd value="${p.platformFee}"/></td>
                        <td><span class="badge badge-pending">Chờ thanh toán</span></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty payments}">
                    <tr><td colspan="7" class="table-empty">Không có thanh toán chờ</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
