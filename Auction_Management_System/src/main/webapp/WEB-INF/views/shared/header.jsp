<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="isAdmin" value="false"/>
<c:set var="canAdminPanel" value="false"/>
<c:if test="${not empty sessionScope.user and not empty sessionScope.user.roles}">
    <c:forEach var="role" items="${sessionScope.user.roles}">
        <c:if test="${role.roleName == 'ADMIN'}">
            <c:set var="isAdmin" value="true"/>
        </c:if>
        <c:if test="${role.roleName == 'ADMIN' or role.roleName == 'MANAGER' or role.roleName == 'STAFF'}">
            <c:set var="canAdminPanel" value="true"/>
        </c:if>
    </c:forEach>
</c:if>

<c:choose>
    <c:when test="${layout == 'admin'}">
        <header class="admin-topbar">
            <div class="search-box">
                <i class="bi bi-search search-icon"></i>
                <input type="text" placeholder="Tìm kiếm sản phẩm, người dùng, đơn hàng...">
            </div>
            <div class="ms-auto d-flex align-items-center gap-3">
                <button type="button" class="btn-notify">
                    <i class="bi bi-bell"></i>
                    <span class="notify-badge">3</span>
                </button>
                <div class="d-flex align-items-center gap-2">
                    <span class="avatar-sm">
                        <c:out value="${sessionScope.user.fullName != null && sessionScope.user.fullName.length() > 0 ? sessionScope.user.fullName.substring(0,1) : 'A'}"/>
                    </span>
                    <div class="small">
                        <strong>${sessionScope.user.fullName}</strong><br>
                        <span class="text-muted">
                            <c:forEach var="role" items="${sessionScope.user.roles}" varStatus="st">
                                <c:choose>
                                    <c:when test="${role.roleName == 'ADMIN'}">Admin</c:when>
                                    <c:when test="${role.roleName == 'MANAGER'}">Manager</c:when>
                                    <c:when test="${role.roleName == 'STAFF'}">Staff</c:when>
                                    <c:when test="${role.roleName == 'CUSTOMER'}">Customer</c:when>
                                    <c:otherwise>${role.roleName}</c:otherwise>
                                </c:choose>
                                <c:if test="${not st.last}">, </c:if>
                            </c:forEach>
                        </span>
                    </div>
                </div>
            </div>
        </header>
    </c:when>
    <c:otherwise>
        <nav class="navbar navbar-expand-lg public-nav">
            <div class="container">
                <a class="brand-logo" href="${ctx}/">
                    <span class="icon">&#9878;</span>
                    <span>
                        AuctionPro
                        <small class="brand-tagline">Đấu giá chuyên nghiệp</small>
                    </span>
                </a>

                <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#publicNav">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="publicNav">
                    <ul class="navbar-nav mx-auto">
                        <li class="nav-item"><a class="nav-link nav-link-custom" href="${ctx}/">Trang chủ</a></li>
                        <li class="nav-item"><a class="nav-link nav-link-custom" href="${ctx}/auctions">Đấu giá</a></li>
                        <li class="nav-item">
                            <a class="nav-link nav-link-custom" href="${ctx}/products/browse">Sản phẩm</a>
                        </li>
                        <c:if test="${not empty sessionScope.user}">
                            <li class="nav-item">
                                <a class="nav-link nav-link-custom" href="${ctx}/account">Quản trị</a>
                            </li>
                        </c:if>
                    </ul>

                    <div class="d-flex gap-2 align-items-center">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <span class="text-white-50 small d-none d-md-inline">${sessionScope.user.fullName}</span>
                                <a href="${ctx}/logout" class="btn btn-outline-gold btn-sm">Đăng xuất</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${ctx}/login" class="btn btn-outline-gold btn-sm">Đăng nhập</a>
                                <a href="${ctx}/register" class="btn btn-gold btn-sm">Đăng ký</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </nav>
    </c:otherwise>
</c:choose>
