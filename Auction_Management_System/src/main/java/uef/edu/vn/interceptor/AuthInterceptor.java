package uef.edu.vn.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

import uef.edu.vn.model.User;
import uef.edu.vn.utils.RolePermissions;

public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        String path = normalizePath(request);

        if (isPublic(path)) {
            return true;
        }

        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        String ctx = request.getContextPath();

        if (user == null) {
            response.sendRedirect(ctx + "/login");
            return false;
        }

        String role = user.getRole();
        if (!RolePermissions.canAccessPath(role, path)) {
            response.sendRedirect(ctx + "/access-denied");
            return false;
        }

        return true;
    }

    private String normalizePath(HttpServletRequest request) {
        String path = request.getRequestURI();
        String ctx = request.getContextPath();
        if (ctx != null && !ctx.isEmpty() && path.startsWith(ctx)) {
            path = path.substring(ctx.length());
        }
        if (path.isEmpty()) {
            return "/";
        }
        return path;
    }

    private boolean isPublic(String path) {
        return path.equals("/") || path.equals("/home")
                || path.startsWith("/auctions") || path.startsWith("/auction-detail")
                || path.startsWith("/categories")
                || path.startsWith("/login") || path.startsWith("/register")
                || path.startsWith("/css/") || path.startsWith("/images/")
                || path.startsWith("/uploads/")
                || path.equals("/access-denied");
    }
}
