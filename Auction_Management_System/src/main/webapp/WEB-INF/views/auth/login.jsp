<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Đăng nhập"/>
<c:set var="extraCss" value="auth"/>
<%@ include file="../shared/header.jsp" %>

<div class="auth-page">
    <div class="auth-card">
        <div class="auth-brand">
            <div class="auth-brand-content">
                <div class="brand-icon"><i class="fa-solid fa-gavel"></i></div>
                <h2>Chào mừng đến <span>AuctionPro</span></h2>
                <p>Nền tảng đấu giá trực tuyến an toàn với ví điện tử tích hợp.</p>
                <ul class="auth-features">
                    <li><i class="fa-solid fa-shield-halved"></i> Đấu giá minh bạch, bảo mật</li>
                    <li><i class="fa-solid fa-wallet"></i> Ví điện tử &amp; tiền cọc tự động</li>
                    <li><i class="fa-solid fa-chart-line"></i> Theo dõi lịch sử đặt giá</li>
                </ul>
            </div>
        </div>

        <div class="auth-form-side">
            <h2><i class="fa-solid fa-right-to-bracket"></i> Đăng nhập</h2>
            <p class="auth-subtitle">Nhập thông tin tài khoản để tiếp tục</p>

            <c:if test="${not empty error}">
                <div class="auth-alert auth-alert-danger">
                    <i class="fa-solid fa-circle-exclamation"></i> ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="input-wrap">
                    <label class="form-label" for="username">Tên đăng nhập</label>
                    <div class="input-field">
                        <input class="form-control" id="username" name="username" placeholder="Nhập tên đăng nhập" required autofocus>
                        <i class="fa-solid fa-user input-icon"></i>
                    </div>
                </div>
                <div class="input-wrap">
                    <label class="form-label" for="password">Mật khẩu</label>
                    <div class="input-field">
                        <input class="form-control" id="password" type="password" name="password" placeholder="Nhập mật khẩu" required>
                        <i class="fa-solid fa-lock input-icon"></i>
                        <button type="button" class="toggle-pw" onclick="togglePw('password', this)" aria-label="Hiện mật khẩu">
                            <i class="fa-solid fa-eye"></i>
                        </button>
                    </div>
                </div>
                <button class="auth-submit" type="submit">
                    <i class="fa-solid fa-arrow-right-to-bracket"></i> Đăng nhập
                </button>
            </form>

            <p class="auth-footer">Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a></p>
        </div>
    </div>
</div>

<script>
function togglePw(id, btn) {
    var input = document.getElementById(id);
    var icon = btn.querySelector('i');
    if (input.type === 'password') {
        input.type = 'text';
        icon.className = 'fa-solid fa-eye-slash';
    } else {
        input.type = 'password';
        icon.className = 'fa-solid fa-eye';
    }
}
</script>

<%@ include file="../shared/footer.jsp" %>
