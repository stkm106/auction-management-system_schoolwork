<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Đăng ký"/>
<%@ include file="../shared/header.jsp" %>

<div class="form-page">
    <div class="form-box form-box-wide">
        <h2><i class="fa-solid fa-user-plus text-gold"></i> Tạo tài khoản</h2>
        <p class="form-box-subtitle">Tham gia đấu giá — tự động tạo ví điện tử khi đăng ký</p>

        <c:if test="${not empty error}"><div class="alert-danger">${error}</div></c:if>

        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="username"><i class="fa-solid fa-user"></i> Tên đăng nhập</label>
                    <input class="form-control" id="username" name="username" placeholder="Username" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="fullName"><i class="fa-solid fa-id-card"></i> Họ và tên</label>
                    <input class="form-control" id="fullName" name="fullName" placeholder="Nguyễn Văn A">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="phone"><i class="fa-solid fa-phone"></i> Số điện thoại</label>
                    <input class="form-control" id="phone" name="phone" placeholder="0901234567">
                </div>
                <div class="form-group">
                    <label class="form-label" for="email"><i class="fa-solid fa-envelope"></i> Email</label>
                    <input class="form-control" id="email" type="email" name="email" placeholder="email@example.com" required>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="password"><i class="fa-solid fa-lock"></i> Mật khẩu</label>
                    <input class="form-control" id="password" type="password" name="password" placeholder="Tối thiểu 6 ký tự" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="confirmPassword"><i class="fa-solid fa-lock"></i> Xác nhận mật khẩu</label>
                    <input class="form-control" id="confirmPassword" type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
                </div>
            </div>
            <div class="form-actions">
                <button class="btn-navy" type="submit"><i class="fa-solid fa-check"></i> Đăng ký</button>
            </div>
        </form>

        <p class="form-footer">Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a></p>
    </div>
</div>

<%@ include file="../shared/footer.jsp" %>
