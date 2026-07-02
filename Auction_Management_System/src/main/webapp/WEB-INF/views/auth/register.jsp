<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng ký - AuctionPro</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${ctx}/resources/css/style.css">
</head>
<body class="auth-page">

<jsp:include page="/WEB-INF/views/shared/header.jsp"/>

<div class="auth-split">
    <div class="auth-form-side">
        <div class="auth-box auth-box-register">
            <p class="auth-eyebrow mb-2">Tạo tài khoản mới</p>
            <h2 class="auth-title mb-2">Đăng ký thành viên</h2>
            <p class="auth-subtitle mb-4">Tham gia cộng đồng đấu giá và khám phá hàng ngàn sản phẩm độc đáo.</p>

            <c:if test="${not empty error}">
                <div class="alert alert-danger py-2 mb-3">${error}</div>
            </c:if>

            <form method="post" action="${ctx}/register" class="auth-form">
                <div class="auth-field">
                    <label class="auth-label" for="username">Tên đăng nhập</label>
                    <div class="auth-input-wrap">
                        <i class="bi bi-person auth-input-icon"></i>
                        <input type="text" id="username" name="username" class="form-control auth-input"
                               placeholder="Nhập tên đăng nhập" autocomplete="username" required>
                    </div>
                </div>

                <div class="auth-field">
                    <label class="auth-label" for="email">Email</label>
                    <div class="auth-input-wrap">
                        <i class="bi bi-envelope auth-input-icon"></i>
                        <input type="email" id="email" name="email" class="form-control auth-input"
                               placeholder="Nhập địa chỉ email" autocomplete="email" required>
                    </div>
                </div>

                <div class="auth-field">
                    <label class="auth-label" for="password">Mật khẩu</label>
                    <div class="auth-input-wrap">
                        <i class="bi bi-lock auth-input-icon"></i>
                        <input type="password" id="password" name="password" class="form-control auth-input"
                               placeholder="Nhập mật khẩu" autocomplete="new-password" required>
                    </div>
                </div>

                <div class="auth-field">
                    <label class="auth-label" for="fullName">Họ và tên</label>
                    <div class="auth-input-wrap">
                        <i class="bi bi-card-text auth-input-icon"></i>
                        <input type="text" id="fullName" name="fullName" class="form-control auth-input"
                               placeholder="Nhập họ và tên" autocomplete="name" required>
                    </div>
                </div>

                <div class="auth-field">
                    <label class="auth-label" for="phone">Số điện thoại</label>
                    <div class="auth-input-wrap">
                        <i class="bi bi-telephone auth-input-icon"></i>
                        <input type="text" id="phone" name="phone" class="form-control auth-input"
                               placeholder="Nhập số điện thoại" autocomplete="tel" required>
                    </div>
                </div>

                <div class="auth-field">
                    <label class="auth-label" for="address">Địa chỉ</label>
                    <div class="auth-input-wrap">
                        <i class="bi bi-geo-alt auth-input-icon"></i>
                        <input type="text" id="address" name="address" class="form-control auth-input"
                               placeholder="Nhập địa chỉ liên hệ" autocomplete="street-address">
                    </div>
                </div>

                <button type="submit" class="btn btn-gold w-100 py-2 mt-2 mb-3">Đăng ký</button>
            </form>

            <p class="text-center auth-footer-text mb-0">
                Đã có tài khoản?
                <a href="${ctx}/login" class="auth-link">Đăng nhập</a>
            </p>
        </div>
    </div>

    <div class="auth-visual">
        <div class="auth-visual-inner">
            <img class="hero-art" src="https://images.unsplash.com/photo-1578301978693-895ea8a9a67f?w=600&h=500&fit=crop" alt="Đấu giá">
            <p class="text-white-50 mt-3 small">Đăng ký miễn phí — tham gia đấu giá ngay hôm nay</p>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/shared/footer.jsp"/>

