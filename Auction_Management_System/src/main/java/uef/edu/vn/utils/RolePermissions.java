package uef.edu.vn.utils;

/**
 * Ma trận phân quyền theo 4 vai trò:
 * ADMIN, AUCTION_MANAGER, STAFF, CUSTOMER
 */
public final class RolePermissions {

    private RolePermissions() {
    }

    public static boolean isCustomer(String role) {
        return RoleConstants.CUSTOMER.equals(role);
    }

    /** Trang mặc định sau đăng nhập / khi bị từ chối quyền */
    public static String getHomePath(String role) {
        if (RoleConstants.isAdmin(role)) {
            return "/admin/dashboard";
        }
        if (RoleConstants.isManager(role)) {
            return "/manager/dashboard";
        }
        if (RoleConstants.isStaff(role)) {
            return "/staff/dashboard";
        }
        return "/home";
    }

    public static boolean canAccessAdmin(String role) {
        return RoleConstants.isAdmin(role);
    }

    public static boolean canAccessManager(String role) {
        return RoleConstants.isAdmin(role) || RoleConstants.isManager(role);
    }

    public static boolean canAccessStaff(String role) {
        return RoleConstants.isAdmin(role) || RoleConstants.isStaff(role);
    }

    /** Chức năng mua/bán: chỉ CUSTOMER */
    public static boolean canUseCustomerFeatures(String role) {
        return isCustomer(role);
    }

    /**
     * URL chỉ dành cho khách hàng (bidder/seller).
     */
    public static boolean isCustomerOnlyPath(String path) {
        return path.startsWith("/wallet")
                || path.startsWith("/my-bids")
                || path.startsWith("/my-payments")
                || path.startsWith("/seller")
                || path.equals("/placeBid")
                || path.equals("/lock-deposit")
                || path.equals("/payment/pay");
    }

    public static boolean canAccessPath(String role, String path) {
        if (path.startsWith("/admin")) {
            return canAccessAdmin(role);
        }
        if (path.startsWith("/manager")) {
            return canAccessManager(role);
        }
        if (path.startsWith("/staff")) {
            return canAccessStaff(role);
        }
        if (isCustomerOnlyPath(path)) {
            return canUseCustomerFeatures(role);
        }
        return true;
    }
}
