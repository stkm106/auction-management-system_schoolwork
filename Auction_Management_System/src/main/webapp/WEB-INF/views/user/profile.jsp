<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="page-header">
    <div>
        <h1>Hồ sơ cá nhân</h1>
        <div class="breadcrumb-custom">Trang chủ &gt; Hồ sơ cá nhân</div>
    </div>
</div>

<c:if test="${not empty success}">
    <div class="alert alert-success">${success}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<div class="row g-4">
    <div class="col-lg-5">
        <div class="profile-card mb-4">
            <div class="profile-card-header">
                <strong>Thông tin cá nhân</strong>
            </div>
            <div class="profile-card-body text-center">
                <div class="profile-avatar mx-auto mb-3">
                    <c:out value="${user.fullName != null && user.fullName.length() > 0 ? user.fullName.substring(0,1) : 'A'}"/>
                </div>
                <h5 class="mb-1">${user.fullName}</h5>
                <p class="text-muted small mb-3">Quản trị viên</p>
                <div class="profile-info-list text-start">
                    <div class="profile-info-item">
                        <span class="label">Email</span>
                        <span class="value">${user.email}</span>
                    </div>
                    <div class="profile-info-item">
                        <span class="label">Số điện thoại</span>
                        <span class="value">${user.phone != null ? user.phone : 'Chưa cập nhật'}</span>
                    </div>
                    <div class="profile-info-item">
                        <span class="label">Ngày tham gia</span>
                        <span class="value"><fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy"/></span>
                    </div>
                </div>
            </div>
        </div>

        <div class="profile-card">
            <div class="profile-card-header">
                <strong>Thống kê tài khoản</strong>
            </div>
            <div class="profile-card-body">
                <div class="profile-stat">
                    <span class="label">Tổng số lần đăng nhập</span>
                    <span class="value">128</span>
                </div>
                <div class="profile-stat">
                    <span class="label">Lần đăng nhập cuối</span>
                    <span class="value">Hôm nay</span>
                </div>
                <div class="profile-stat">
                    <span class="label">Trạng thái tài khoản</span>
                    <span class="badge-status badge-active">Hoạt động</span>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-7">
        <div class="profile-card mb-4">
            <div class="profile-card-header">
                <strong>Đổi mật khẩu</strong>
            </div>
            <div class="profile-card-body">
                <form method="post" action="${ctx}/users/change-password">
                    <div class="mb-3">
                        <label class="form-label">Mật khẩu hiện tại</label>
                        <input type="password" name="currentPassword" class="form-control" placeholder="Nhập mật khẩu hiện tại" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mật khẩu mới</label>
                        <input type="password" name="newPassword" class="form-control" placeholder="Nhập mật khẩu mới" required>
                    </div>
                    <div class="mb-4">
                        <label class="form-label">Xác nhận mật khẩu mới</label>
                        <input type="password" name="confirmPassword" class="form-control" placeholder="Nhập lại mật khẩu mới" required>
                    </div>
                    <button type="submit" class="btn btn-gold w-100">Cập nhật mật khẩu</button>
                </form>
            </div>
        </div>

        <div class="profile-card">
            <div class="profile-card-header">
                <strong>Cài đặt</strong>
            </div>
            <div class="profile-card-body">
                <div class="setting-item">
                    <div>
                        <strong>Nhận thông báo qua email</strong>
                        <p class="text-muted small mb-0">Gửi email khi có hoạt động quan trọng</p>
                    </div>
                    <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox" checked>
                    </div>
                </div>
                <div class="setting-item">
                    <div>
                        <strong>Thông báo phiên đấu giá mới</strong>
                        <p class="text-muted small mb-0">Nhận thông báo khi có phiên đấu giá mới</p>
                    </div>
                    <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox" checked>
                    </div>
                </div>
                <div class="setting-item mb-0">
                    <div>
                        <strong>Báo cáo hàng tuần</strong>
                        <p class="text-muted small mb-0">Nhận báo cáo tổng hợp mỗi tuần</p>
                    </div>
                    <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox">
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
