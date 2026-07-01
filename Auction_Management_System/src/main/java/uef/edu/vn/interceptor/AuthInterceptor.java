package uef.edu.vn.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;
import uef.edu.vn.model.User;
import uef.edu.vn.util.RoleUtils;

public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request,
            HttpServletResponse response,
            Object handler) throws Exception {

        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        if (isPublicPath(path)) {
            return true;
        }

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(contextPath + "/login");
            return false;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(contextPath + "/login");
            return false;
        }

        if (!isAllowed(path, user)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return false;
        }

        return true;
    }

    private boolean isPublicPath(String path) {
        return path.equals("/")
                || path.equals("/login")
                || path.equals("/register")
                || path.startsWith("/resources/")
                || isPublicProductPath(path)
                || isPublicAuctionPath(path);
    }

    private boolean isPublicProductPath(String path) {
        return path.equals("/products")
                || path.startsWith("/products/browse")
                || path.startsWith("/products/detail/")
                || path.startsWith("/products/search");
    }

    private boolean isPublicAuctionPath(String path) {
        return path.equals("/auctions")
                || path.startsWith("/auctions/detail/");
    }

    private boolean isAllowed(String path, User user) {
        if (path.equals("/account")) {
            return RoleUtils.canAccessPortal(user);
        }
        if (path.startsWith("/users/profile") || path.equals("/users/change-password")) {
            return true;
        }
        if (path.startsWith("/users")) {
            return RoleUtils.canManageUsers(user);
        }
        if (path.startsWith("/dashboard")) {
            return RoleUtils.canViewDashboard(user);
        }
        if (path.startsWith("/reports")) {
            return RoleUtils.canViewReports(user);
        }
        if (isProductAdminPath(path)) {
            return RoleUtils.canManageProducts(user);
        }
        if (path.startsWith("/products/my")) {
            return RoleUtils.canViewOwnProducts(user);
        }
        if (isAuctionCreatePath(path)) {
            return RoleUtils.canCreateAuction(user);
        }
        if (isAuctionAdminPath(path)) {
            return RoleUtils.canTrackAuctions(user);
        }
        if (path.startsWith("/bids/place")) {
            return RoleUtils.canBid(user);
        }
        if (path.startsWith("/auctions/join/")) {
            return RoleUtils.canBid(user);
        }
        if (path.startsWith("/payments/pay/")) {
            return user != null;
        }
        if (path.startsWith("/bids/my-bids")) {
            return RoleUtils.canViewMyBids(user);
        }
        if (path.startsWith("/payments/my-payments/detail/")) {
            return RoleUtils.canViewOwnPayments(user);
        }
        if (path.startsWith("/payments/monitor/")) {
            return RoleUtils.canMonitorPayments(user);
        }
        if (path.startsWith("/payments/my-payments")) {
            return RoleUtils.canViewOwnPayments(user);
        }
        if (path.startsWith("/payments/paid/") || path.startsWith("/payments/cancel/") || path.equals("/payments/save")) {
            return RoleUtils.canManagePayments(user);
        }
        if (path.startsWith("/payments")) {
            return RoleUtils.canMonitorPayments(user);
        }
        if (path.startsWith("/wallet")) {
            return RoleUtils.canAccessPortal(user);
        }
        return true;
    }

    private boolean isProductAdminPath(String path) {
        return path.startsWith("/products/manage")
                || path.startsWith("/products/create")
                || path.startsWith("/products/edit/")
                || path.equals("/products/save")
                || path.equals("/products/update")
                || path.startsWith("/products/approve/")
                || path.startsWith("/products/decline/")
                || path.startsWith("/products/reject/")
                || path.startsWith("/products/delete/");
    }

    private boolean isAuctionCreatePath(String path) {
        return path.startsWith("/auctions/create") || path.equals("/auctions/save");
    }

    private boolean isAuctionAdminPath(String path) {
        return path.startsWith("/auctions/manage")
                || path.equals("/auctions/update")
                || path.startsWith("/auctions/start/")
                || path.startsWith("/auctions/close/")
                || path.startsWith("/auctions/delete/")
                || path.startsWith("/auctions/edit/");
    }
}
