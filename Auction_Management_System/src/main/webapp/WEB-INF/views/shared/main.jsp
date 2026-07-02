<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<c:choose>
    <c:when test="${layout == 'public'}">
        <!DOCTYPE html>
        <html lang="vi">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>AuctionPro - Đấu giá trực tuyến</title>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
            <link rel="stylesheet" href="${ctx}/resources/css/style.css">
        </head>
        <body class="public-body page-layout">
        <jsp:include page="/WEB-INF/views/shared/header.jsp"/>
        <main class="page-main">
            <jsp:include page="${body}"/>
        </main>
        <jsp:include page="/WEB-INF/views/shared/footer.jsp"/>
    </c:when>

    <c:when test="${layout == 'light'}">
        <!DOCTYPE html>
        <html lang="vi">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>AuctionPro</title>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
            <link rel="stylesheet" href="${ctx}/resources/css/style.css">
        </head>
        <body class="light-body page-layout">
        <jsp:include page="/WEB-INF/views/shared/header.jsp"/>
        <main class="page-main">
            <jsp:include page="${body}"/>
        </main>
        <jsp:include page="/WEB-INF/views/shared/footer.jsp"/>
    </c:when>

    <c:when test="${layout == 'admin'}">
        <!DOCTYPE html>
        <html lang="vi">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>${not empty pageTitle ? pageTitle : (perm.adminPanel ? 'Admin' : 'Tài khoản')} - AuctionPro</title>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
            <link rel="stylesheet" href="${ctx}/resources/css/style.css">
        </head>
        <body class="admin-body page-layout">
        <div class="admin-wrapper">
            <aside class="admin-sidebar">
                <a href="${ctx}/" class="brand brand-link">
                    <div class="brand-logo mb-1">
                        <span class="icon"><i class="bi bi-hammer"></i></span>
                        <span>AuctionPro</span>
                    </div>
                    <small>${perm.adminPanel ? 'Admin Panel' : 'Tài khoản'}</small>
                </a>

                <div class="admin-menu mt-2">
                    <c:if test="${perm.dashboard}">
                        <div class="admin-menu-label">Tổng quan</div>
                        <a href="${ctx}/dashboard" class="${activeMenu == 'dashboard' ? 'active' : ''}">
                            <i class="bi bi-grid-1x2"></i> Dashboard
                        </a>
                    </c:if>

                    <c:if test="${perm.manageUsers or perm.manageProducts or perm.trackAuctions or perm.viewPayments or perm.viewWallet}">
                        <div class="admin-menu-label">Quản lý</div>
                        <c:if test="${perm.manageUsers}">
                            <a href="${ctx}/users" class="${activeMenu == 'users' ? 'active' : ''}">
                                <i class="bi bi-people"></i> Quản lý người dùng
                            </a>
                        </c:if>
                        <c:if test="${perm.manageProducts}">
                            <a href="${ctx}/products/manage" class="${activeMenu == 'products' ? 'active' : ''}">
                                <i class="bi bi-box-seam"></i> Quản lý sản phẩm
                            </a>
                        </c:if>
                        <c:if test="${perm.trackAuctions}">
                            <a href="${ctx}/auctions/manage" class="${activeMenu == 'auctions' ? 'active' : ''}">
                                <i class="bi bi-hammer"></i> Quản lý phiên đấu giá
                            </a>
                        </c:if>
                        <c:if test="${perm.viewPayments}">
                            <a href="${ctx}/payments" class="${activeMenu == 'payments' ? 'active' : ''}">
                                <i class="bi bi-credit-card"></i>
                                <c:choose>
                                    <c:when test="${perm.managePayments}">Giao dịch &amp; Thanh toán</c:when>
                                    <c:otherwise>Giám sát giao dịch</c:otherwise>
                                </c:choose>
                            </a>
                        </c:if>
                        <c:if test="${perm.viewWallet and not perm.myWallet}">
                            <a href="${ctx}/wallet" class="${activeMenu == 'wallet' ? 'active' : ''}">
                                <i class="bi bi-wallet2"></i> Quản lý ví
                            </a>
                        </c:if>
                    </c:if>

                    <c:if test="${perm.myProducts or perm.myBids or perm.myPayments or perm.myWallet}">
                        <c:if test="${perm.myProducts and not perm.dashboard}">
                            <div class="admin-menu-label">Tổng quan</div>
                            <a href="${ctx}/account" class="${activeMenu == 'customer-dashboard' ? 'active' : ''}">
                                <i class="bi bi-grid-1x2"></i> Dashboard
                            </a>
                        </c:if>
                        <div class="admin-menu-label">Đấu giá</div>
                        <a href="${ctx}/auctions">
                            <i class="bi bi-hammer"></i> Phiên đấu giá
                        </a>
                        <c:if test="${perm.myProducts}">
                            <a href="${ctx}/products/my" class="${activeMenu == 'my-products' ? 'active' : ''}">
                                <i class="bi bi-box-seam"></i> Sản phẩm của tôi
                            </a>
                        </c:if>
                        <c:if test="${perm.myBids}">
                            <a href="${ctx}/bids/my-bids" class="${activeMenu == 'my-bids' ? 'active' : ''}">
                                <i class="bi bi-tag"></i> Giá đã đặt
                            </a>
                        </c:if>
                        <c:if test="${perm.myPayments or perm.myWallet}">
                            <div class="admin-menu-label">Giao dịch</div>
                        </c:if>
                        <c:if test="${perm.myPayments}">
                            <a href="${ctx}/payments/my-payments" class="${activeMenu == 'my-payments' ? 'active' : ''}">
                                <i class="bi bi-credit-card"></i> Thanh toán của tôi
                            </a>
                        </c:if>
                        <c:if test="${perm.myWallet}">
                            <a href="${ctx}/wallet" class="${activeMenu == 'wallet' ? 'active' : ''}">
                                <i class="bi bi-wallet2"></i> Ví của tôi
                            </a>
                        </c:if>
                    </c:if>

                    <c:if test="${perm.reports}">
                        <div class="admin-menu-label">Báo cáo</div>
                        <a href="${ctx}/reports" class="${activeMenu == 'reports' ? 'active' : ''}">
                            <i class="bi bi-bar-chart"></i> Báo cáo thống kê
                        </a>
                    </c:if>

                    <c:if test="${perm.profile}">
                        <div class="admin-menu-label">Hệ thống</div>
                        <a href="${ctx}/users/profile" class="${activeMenu == 'profile' ? 'active' : ''}">
                            <i class="bi bi-person"></i> Hồ sơ
                        </a>
                    </c:if>
                    <a href="${ctx}/logout">
                        <i class="bi bi-box-arrow-right"></i> Đăng xuất
                    </a>
                </div>
            </aside>

            <div class="admin-main">
                <jsp:include page="/WEB-INF/views/shared/header.jsp"/>
                <div class="admin-content">
                    <jsp:include page="${body}"/>
                </div>
            </div>
        </div>
        <c:set var="closeDocument" value="true" scope="request"/>
        <jsp:include page="/WEB-INF/views/shared/footer.jsp"/>
    </c:when>

    <c:otherwise>
        <!DOCTYPE html>
        <html lang="vi">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>AuctionPro</title>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
            <link rel="stylesheet" href="${ctx}/resources/css/style.css">
        </head>
        <body class="light-body page-layout">
        <jsp:include page="/WEB-INF/views/shared/header.jsp"/>
        <main class="page-main">
            <jsp:include page="${body}"/>
        </main>
        <jsp:include page="/WEB-INF/views/shared/footer.jsp"/>
    </c:otherwise>
</c:choose>
