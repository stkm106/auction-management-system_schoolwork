<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="isEdit" value="${user.userID > 0}"/>

<div class="page-header">
    <div>
        <h1>${isEdit ? 'Sửa người dùng' : 'Thêm người dùng'}</h1>
        <div class="breadcrumb-custom">
            Trang chủ &gt; Quản lý người dùng &gt; ${isEdit ? 'Sửa' : 'Thêm người dùng'}
        </div>
    </div>
    <a href="${ctx}/users" class="btn btn-outline-secondary btn-sm">
        <i class="bi bi-arrow-left"></i> Quay lại danh sách
    </a>
</div>

<div class="profile-card">
    <div class="profile-card-header">
        <h5 class="mb-0 fw-semibold">Thông tin người dùng</h5>
    </div>
    <div class="profile-card-body">
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <form method="post" action="${ctx}${isEdit ? '/users/update' : '/users/save'}">
            <c:if test="${isEdit}">
                <input type="hidden" name="userID" value="${user.userID}">
            </c:if>

            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                    <input type="text" name="fullName" class="form-control"
                           placeholder="Nhập họ và tên" value="${user.fullName}" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                    <input type="text" name="username" class="form-control"
                           placeholder="Nhập tên đăng nhập" value="${user.username}"
                           ${isEdit ? 'readonly' : ''} required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Email <span class="text-danger">*</span></label>
                    <input type="email" name="email" class="form-control"
                           placeholder="Nhập email" value="${user.email}" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                    <input type="text" name="phone" class="form-control"
                           placeholder="Nhập số điện thoại" value="${user.phone}" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Vai trò <span class="text-danger">*</span></label>
                    <select name="roleID" class="form-select" required>
                        <option value="">Chọn vai trò</option>
                        <c:forEach var="role" items="${roles}">
                            <option value="${role.roleID}" ${selectedRoleId == role.roleID ? 'selected' : ''}>
                                <c:choose>
                                    <c:when test="${role.roleName == 'ADMIN'}">Quản trị viên</c:when>
                                    <c:when test="${role.roleName == 'MANAGER'}">Auction Manager</c:when>
                                    <c:when test="${role.roleName == 'STAFF'}">Staff</c:when>
                                    <c:when test="${role.roleName == 'CUSTOMER'}">Customer</c:when>
                                    <c:otherwise>${role.roleName}</c:otherwise>
                                </c:choose>
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Trạng thái <span class="text-danger">*</span></label>
                    <select name="status" class="form-select" required>
                        <option value="Active" ${user.status == 'Active' or empty user.status ? 'selected' : ''}>Hoạt động</option>
                        <option value="Inactive" ${user.status == 'Inactive' ? 'selected' : ''}>Không hoạt động</option>
                        <option value="Locked" ${user.status == 'Locked' ? 'selected' : ''}>Bị khóa</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">
                        Mật khẩu
                        <c:if test="${not isEdit}"><span class="text-danger">*</span></c:if>
                        <c:if test="${isEdit}"><span class="text-muted small">(để trống nếu không đổi)</span></c:if>
                    </label>
                    <div class="input-group">
                        <input type="password"
                               name="${isEdit ? 'newPassword' : 'password'}"
                               id="passwordField"
                               class="form-control"
                               placeholder="Nhập mật khẩu"
                               ${isEdit ? '' : 'required'}>
                        <button type="button" class="btn btn-outline-secondary toggle-password" data-target="passwordField">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label">
                        Xác nhận mật khẩu
                        <c:if test="${not isEdit}"><span class="text-danger">*</span></c:if>
                    </label>
                    <div class="input-group">
                        <input type="password"
                               name="confirmPassword"
                               id="confirmPasswordField"
                               class="form-control"
                               placeholder="Nhập lại mật khẩu"
                               ${isEdit ? '' : 'required'}>
                        <button type="button" class="btn btn-outline-secondary toggle-password" data-target="confirmPasswordField">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                </div>
                <div class="col-12">
                    <label class="form-label">Địa chỉ</label>
                    <textarea name="address" class="form-control" rows="3"
                              placeholder="Nhập ghi chú (nếu có)">${user.address}</textarea>
                </div>
            </div>

            <div class="d-flex gap-2 mt-4">
                <button type="submit" class="btn btn-gold">
                    <i class="bi bi-floppy"></i> Lưu người dùng
                </button>
                <a href="${ctx}/users" class="btn btn-outline-secondary">
                    <i class="bi bi-x-lg"></i> Hủy bỏ
                </a>
            </div>
        </form>
    </div>
</div>

<script>
document.querySelectorAll('.toggle-password').forEach(function (btn) {
    btn.addEventListener('click', function () {
        var field = document.getElementById(btn.getAttribute('data-target'));
        var icon = btn.querySelector('i');
        if (field.type === 'password') {
            field.type = 'text';
            icon.classList.replace('bi-eye', 'bi-eye-slash');
        } else {
            field.type = 'password';
            icon.classList.replace('bi-eye-slash', 'bi-eye');
        }
    });
});
</script>
