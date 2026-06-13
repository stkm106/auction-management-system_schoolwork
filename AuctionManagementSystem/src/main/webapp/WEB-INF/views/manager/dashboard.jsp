<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="pageTitle" value="Manager Dashboard"/>
<%@ include file="../shared/header.jsp" %>
<div class="container mt-4">
    <h2>Bảng điều khiển quản lý</h2>
    <p>Tổng doanh thu phí sàn: <strong><tags:formatVnd value="${revenue}"/></strong></p>
    <a href="${pageContext.request.contextPath}/manager/reports" class="btn btn-primary mb-3">Xem báo cáo</a>
    <div class="row">
        <div class="col-md-6">
            <div class="card p-3">
                <h5>Doanh thu theo sản phẩm</h5>
                <ul>
                    <c:forEach var="s" items="${revenueStats}">
                        <li>${s.label}: <tags:formatVnd value="${s.value}"/></li>
                    </c:forEach>
                </ul>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card p-3">
                <h5>Sản phẩm phổ biến</h5>
                <ul>
                    <c:forEach var="s" items="${popularProducts}">
                        <li>${s.label}: ${s.count} lượt bid</li>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </div>
    <div class="card p-3 mt-3">
        <h5>Tất cả phiên đấu giá</h5>
        <table class="table">
            <thead><tr><th>Sản phẩm</th><th>Trạng thái</th><th>Giá hiện tại</th></tr></thead>
            <tbody>
            <c:forEach var="a" items="${auctions}">
                <tr><td>${a.productName}</td><td>${a.status}</td><td><tags:formatVnd value="${a.currentPrice}"/></td></tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<%@ include file="../shared/footer.jsp" %>
