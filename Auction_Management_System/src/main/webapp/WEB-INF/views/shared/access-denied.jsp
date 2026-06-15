<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Truy cập bị từ chối"/>
<%@ include file="header.jsp" %>
<div class="auth-page">
    <div class="form-box" style="text-align:center">
        <h2 style="color:var(--navy);margin-bottom:12px"><i class="fa-solid fa-ban text-gold"></i> Truy cập bị từ chối</h2>
        <p style="color:#666;margin-bottom:12px">Bạn không có quyền truy cập trang này.</p>
        <p style="color:#888;font-size:14px;margin-bottom:24px">
            <c:choose>
                <c:when test="${sessionScope.user.role == 'ADMIN'}">Tài khoản Quản trị viên — dùng menu <strong>Quản trị</strong>.</c:when>
                <c:when test="${sessionScope.user.role == 'AUCTION_MANAGER'}">Tài khoản Quản lý đấu giá — dùng menu <strong>Vận hành</strong>.</c:when>
                <c:when test="${sessionScope.user.role == 'STAFF'}">Tài khoản Nhân viên — dùng menu <strong>Công việc</strong>.</c:when>
                <c:otherwise>Tài khoản Khách hàng — dùng Ví, Lịch sử, Thanh toán, Bán.</c:otherwise>
            </c:choose>
        </p>
        <c:choose>
            <c:when test="${sessionScope.user.role == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-navy" style="display:inline-block;width:auto;padding:14px 32px;text-decoration:none;border-radius:10px">Về Quản trị</a>
            </c:when>
            <c:when test="${sessionScope.user.role == 'AUCTION_MANAGER'}">
                <a href="${pageContext.request.contextPath}/manager/dashboard" class="btn-navy" style="display:inline-block;width:auto;padding:14px 32px;text-decoration:none;border-radius:10px">Về Vận hành</a>
            </c:when>
            <c:when test="${sessionScope.user.role == 'STAFF'}">
                <a href="${pageContext.request.contextPath}/staff/dashboard" class="btn-navy" style="display:inline-block;width:auto;padding:14px 32px;text-decoration:none;border-radius:10px">Về Công việc</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/home" class="btn-navy" style="display:inline-block;width:auto;padding:14px 32px;text-decoration:none;border-radius:10px">Về trang chủ</a>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<%@ include file="footer.jsp" %>
