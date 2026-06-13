<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="pageTitle" value="Hóa đơn"/>
<%@ include file="../shared/header.jsp" %>
<div class="container mt-4">
    <div class="card p-4" style="max-width:600px;margin:auto">
        <h3>Hóa đơn thanh toán</h3>
        <c:if test="${not empty payment}">
            <hr>
            <p><strong>Mã thanh toán:</strong> #${payment.paymentId}</p>
            <p><strong>Người mua:</strong> ${payment.buyerName}</p>
            <p><strong>Người bán:</strong> ${payment.sellerName}</p>
            <p><strong>Sản phẩm:</strong> ${payment.productName}</p>
            <p><strong>Tổng tiền:</strong> <tags:formatVnd value="${payment.amount}"/></p>
            <p><strong>Tiền cọc đã dùng:</strong> <tags:formatVnd value="${payment.depositUsed}"/></p>
            <p><strong>Phí sàn (5%):</strong> <tags:formatVnd value="${payment.platformFee}"/></p>
            <p><strong>Người bán nhận:</strong> <tags:formatVnd value="${payment.sellerReceive}"/></p>
            <p><strong>Trạng thái:</strong> ${payment.status}</p>
            <p><strong>Ngày:</strong> <fmt:formatDate value="${payment.paymentDate}" pattern="dd/MM/yyyy HH:mm"/></p>
            <button onclick="window.print()" class="btn btn-primary">In hóa đơn</button>
        </c:if>
        <c:if test="${empty payment}"><p class="text-danger">Không tìm thấy thanh toán.</p></c:if>
    </div>
</div>
<%@ include file="../shared/footer.jsp" %>
