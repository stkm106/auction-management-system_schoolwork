<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng nhập - AuctionPro</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${ctx}/resources/css/style.css">
</head>
<body class="auth-page">

<jsp:include page="/WEB-INF/views/shared/header.jsp"/>

<div class="auth-split">
    <div class="auth-form-side">
        <div class="auth-box">
            <h1>Chào mừng trở lại</h1>
            <h2>Đăng nhập tài khoản</h2>
            <p class="text-white-50 mb-4">Đăng nhập để tham gia đấu giá, theo dõi sản phẩm yêu thích và quản lý ví của bạn.</p>

            <c:if test="${not empty error}">
                <div class="alert alert-danger py-2">${error}</div>
            </c:if>

            <form method="post" action="${ctx}/login">
                <div class="mb-3">
                    <label class="text-white-50 small mb-1">Tên đăng nhập</label>
                    <input type="text" name="username" class="form-control auth-input" placeholder="Nhập email hoặc tên đăng nhập" required>
                </div>
                <div class="mb-3">
                    <label class="text-white-50 small mb-1">Mật khẩu</label>
                    <input type="password" name="password" class="form-control auth-input" placeholder="Nhập mật khẩu" required>
                </div>
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="remember">
                        <label class="form-check-label text-white-50 small" for="remember">Ghi nhớ đăng nhập</label>
                    </div>
                    <a href="#" class="small" style="color:var(--gold)">Quên mật khẩu?</a>
                </div>
                <button type="submit" class="btn btn-gold w-100 py-2 mb-3">Đăng nhập</button>
            </form>

            <p class="text-center text-white-50 small mb-0">
                Chưa có tài khoản?
                <a href="${ctx}/register" style="color:var(--gold)">Đăng ký ngay</a>
            </p>
        </div>
    </div>

    <div class="auth-visual">
        <div class="auth-visual-inner">
            <img class="hero-art" src="https://images.unsplash.com/photo-1568667256549-094345857637?w=600&h=500&fit=crop"
                 alt="Đấu giá">
            <p class="text-white-50 mt-3 small">Nền tảng đấu giá trực tuyến uy tín hàng đầu Việt Nam</p>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/shared/footer.jsp"/>
