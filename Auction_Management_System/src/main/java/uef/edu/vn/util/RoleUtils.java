package uef.edu.vn.util;

import uef.edu.vn.model.Role;
import uef.edu.vn.model.User;

public final class RoleUtils {

    private RoleUtils() {
    }

    public static boolean hasRole(User user, String roleName) {
        if (user == null || user.getRoles() == null || roleName == null) {
            return false;
        }
        for (Role role : user.getRoles()) {
            if (roleName.equalsIgnoreCase(role.getRoleName())) {
                return true;
            }
        }
        return false;
    }

    public static boolean hasAnyRole(User user, String... roleNames) {
        if (roleNames == null) {
            return false;
        }
        for (String roleName : roleNames) {
            if (hasRole(user, roleName)) {
                return true;
            }
        }
        return false;
    }

    public static boolean isAdmin(User user) {
        return hasRole(user, "ADMIN");
    }

    public static boolean isManager(User user) {
        return hasRole(user, "MANAGER");
    }

    public static boolean isStaff(User user) {
        return hasRole(user, "STAFF");
    }

    public static boolean isCustomer(User user) {
        return hasRole(user, "CUSTOMER");
    }

    public static boolean canAccessAdminPanel(User user) {
        return hasAnyRole(user, "ADMIN", "MANAGER", "STAFF");
    }

    public static boolean canAccessPortal(User user) {
        return user != null && (canAccessAdminPanel(user) || isCustomer(user));
    }

    public static boolean canViewOwnProducts(User user) {
        return canAccessPortal(user);
    }

    public static boolean canViewOwnPayments(User user) {
        return canAccessPortal(user);
    }

    public static boolean canViewOwnWallet(User user) {
        return canAccessPortal(user);
    }

    public static boolean canViewMyBids(User user) {
        return canAccessPortal(user);
    }

    public static boolean canViewProfile(User user) {
        return user != null;
    }

    public static boolean canViewDashboard(User user) {
        return hasAnyRole(user, "ADMIN", "MANAGER");
    }

    public static boolean canManageUsers(User user) {
        return isAdmin(user);
    }

    public static boolean canManageProducts(User user) {
        return hasAnyRole(user, "ADMIN", "MANAGER", "STAFF");
    }

    public static boolean canReviewProducts(User user) {
        return hasAnyRole(user, "ADMIN", "STAFF");
    }

    public static boolean canCreateAuction(User user) {
        return hasAnyRole(user, "ADMIN", "MANAGER");
    }

    public static boolean canManageAuctions(User user) {
        return hasAnyRole(user, "ADMIN", "MANAGER");
    }

    public static boolean canTrackAuctions(User user) {
        return hasAnyRole(user, "ADMIN", "MANAGER", "STAFF");
    }

    public static boolean canBid(User user) {
        return canAccessPortal(user);
    }

    public static boolean canManagePayments(User user) {
        return isAdmin(user);
    }

    public static boolean canMonitorPayments(User user) {
        return hasAnyRole(user, "ADMIN", "MANAGER", "STAFF");
    }

    public static boolean canViewAllPayments(User user) {
        return canMonitorPayments(user);
    }

    public static boolean canManageAllWallets(User user) {
        return hasAnyRole(user, "ADMIN", "STAFF");
    }

    public static boolean canViewAllWallets(User user) {
        return hasAnyRole(user, "ADMIN", "MANAGER", "STAFF");
    }

    public static boolean canViewReports(User user) {
        return hasAnyRole(user, "ADMIN", "MANAGER");
    }

    public static String getRoleLabel(String roleName) {
        if (roleName == null) {
            return "";
        }
        return switch (roleName.toUpperCase()) {
            case "ADMIN" -> "Quản trị viên";
            case "MANAGER" -> "Auction Manager";
            case "STAFF" -> "Staff";
            case "CUSTOMER" -> "Customer";
            default -> roleName;
        };
    }
}
