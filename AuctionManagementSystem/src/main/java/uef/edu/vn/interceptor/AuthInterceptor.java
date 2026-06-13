package uef.edu.vn.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

import uef.edu.vn.model.User;
import uef.edu.vn.utils.RoleConstants;

public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        String path = request.getRequestURI();
        String ctx = request.getContextPath();
        if (ctx != null && path.startsWith(ctx)) {
            path = path.substring(ctx.length());
        }

        if (isPublic(path)) {
            return true;
        }

        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(ctx + "/login");
            return false;
        }

        String role = user.getRole();
        if (path.startsWith("/admin") && !RoleConstants.isAdmin(role)) {
            response.sendRedirect(ctx + "/access-denied");
            return false;
        }
        if (path.startsWith("/manager") && !RoleConstants.isAdmin(role) && !RoleConstants.isManager(role)) {
            response.sendRedirect(ctx + "/access-denied");
            return false;
        }
        if (path.startsWith("/staff") && !RoleConstants.isStaff(role) && !RoleConstants.isAdmin(role)) {
            response.sendRedirect(ctx + "/access-denied");
            return false;
        }
        return true;
    }

    private boolean isPublic(String path) {
        return path.equals("/") || path.equals("/home")
                || path.startsWith("/auctions") || path.startsWith("/auction-detail")
                || path.startsWith("/categories")
                || path.startsWith("/login") || path.startsWith("/register")
                || path.startsWith("/css/") || path.startsWith("/images/")
                || path.equals("/access-denied");
    }
}
