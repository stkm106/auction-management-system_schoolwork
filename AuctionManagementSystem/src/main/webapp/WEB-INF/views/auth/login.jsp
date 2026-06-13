<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Đăng nhập"/>
<%@ include file="../shared/header.jsp" %>

<div class="form-page">
    <div class="form-box">
        <h2><i class="fa-solid fa-right-to-bracket text-gold"></i> Đăng nhập</h2>
        <p class="form-box-subtitle">Chào mừng trở lại AuctionPro — đấu giá an toàn với ví điện tử</p>

        <c:if test="${not empty error}"><div class="alert-danger">${error}</div></c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label class="form-label" for="username"><i class="fa-solid fa-user"></i> Tên đăng nhập</label>
                <input class="form-control" id="username" name="username" placeholder="Nhập username" required autofocus>
            </div>
            <div class="form-group">
                <label class="form-label" for="password"><i class="fa-solid fa-lock"></i> Mật khẩu</label>
                <input class="form-control" id="password" type="password" name="password" placeholder="Nhập mật khẩu" required>
            </div>
            <div class="form-actions">
                <button class="btn-navy" type="submit"><i class="fa-solid fa-arrow-right-to-bracket"></i> Đăng nhập</button>
            </div>
        </form>

        <p class="form-footer">Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a></p>
        <div class="demo-hint">
            <strong>Tài khoản demo</strong> (mật khẩu: <strong>123456</strong>):<br>
            Admin: <strong>admin</strong> · Staff: <strong>staff1</strong> · Manager: <strong>manager</strong><br>
            Người bán: <strong>seller1</strong>, <strong>seller2</strong> · Người mua: <strong>buyer1</strong>, <strong>buyer2</strong>
        </div>
    </div>
</div>

<%@ include file="../shared/footer.jsp" %>
