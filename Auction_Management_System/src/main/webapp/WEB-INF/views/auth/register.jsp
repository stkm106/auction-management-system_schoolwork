<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Đăng ký"/>
<c:set var="extraCss" value="auth"/>
<%@ include file="../shared/header.jsp" %>

<div class="auth-page">
    <div class="auth-card auth-card-wide">
        <div class="auth-brand">
            <div class="auth-brand-content">
                <div class="brand-icon"><i class="fa-solid fa-user-plus"></i></div>
                <h2>Tham gia <span>AuctionPro</span></h2>
                <p>Tạo tài khoản miễn phí và bắt đầu mua bán qua đấu giá ngay hôm nay.</p>
                <ul class="auth-features">
                    <li><i class="fa-solid fa-check"></i> Tự động tạo ví điện tử</li>
                    <li><i class="fa-solid fa-check"></i> Vừa mua vừa bán trên cùng tài khoản</li>
                    <li><i class="fa-solid fa-check"></i> Đăng sản phẩm &amp; tham gia đấu giá</li>
                </ul>
            </div>
        </div>

        <div class="auth-form-side">
            <h2><i class="fa-solid fa-user-plus"></i> Tạo tài khoản</h2>
            <p class="auth-subtitle">Điền thông tin bên dưới để đăng ký</p>

            <c:if test="${not empty error}">
                <div class="auth-alert auth-alert-danger">
                    <i class="fa-solid fa-circle-exclamation"></i> ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="form-row">
                    <div class="input-wrap">
                        <label class="form-label" for="username">Tên đăng nhập</label>
                        <div class="input-field">
                            <input class="form-control" id="username" name="username" placeholder="Nhập tên đăng nhập" required>
                            <i class="fa-solid fa-user input-icon"></i>
                        </div>
                    </div>
                    <div class="input-wrap">
                        <label class="form-label" for="fullName">Họ và tên</label>
                        <div class="input-field">
                            <input class="form-control" id="fullName" name="fullName" placeholder="Nguyễn Văn A">
                            <i class="fa-solid fa-id-card input-icon"></i>
                        </div>
                    </div>
                </div>
                <div class="form-row">
                    <div class="input-wrap">
                        <label class="form-label" for="phone">Số điện thoại</label>
                        <div class="input-field">
                            <input class="form-control" id="phone" name="phone" placeholder="0901234567">
                            <i class="fa-solid fa-phone input-icon"></i>
                        </div>
                    </div>
                    <div class="input-wrap">
                        <label class="form-label" for="email">Email</label>
                        <div class="input-field">
                            <input class="form-control" id="email" type="email" name="email" placeholder="email@example.com" required>
                            <i class="fa-solid fa-envelope input-icon"></i>
                        </div>
                    </div>
                </div>
                <div class="form-row">
                    <div class="input-wrap">
                        <label class="form-label" for="password">Mật khẩu</label>
                        <div class="input-field">
                            <input class="form-control" id="password" type="password" name="password" placeholder="Tối thiểu 6 ký tự" required>
                            <i class="fa-solid fa-lock input-icon"></i>
                            <button type="button" class="toggle-pw" onclick="togglePw('password', this)" aria-label="Hiện mật khẩu">
                                <i class="fa-solid fa-eye"></i>
                            </button>
                        </div>
                    </div>
                    <div class="input-wrap">
                        <label class="form-label" for="confirmPassword">Xác nhận mật khẩu</label>
                        <div class="input-field">
                            <input class="form-control" id="confirmPassword" type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
                            <i class="fa-solid fa-lock input-icon"></i>
                            <button type="button" class="toggle-pw" onclick="togglePw('confirmPassword', this)" aria-label="Hiện mật khẩu">
                                <i class="fa-solid fa-eye"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <button class="auth-submit" type="submit">
                    <i class="fa-solid fa-check"></i> Đăng ký
                </button>
            </form>

            <p class="auth-footer">Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a></p>
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
