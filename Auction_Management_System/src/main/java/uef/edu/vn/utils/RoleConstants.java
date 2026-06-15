package uef.edu.vn.utils;

public final class RoleConstants {

    public static final String ADMIN = "ADMIN";
    public static final String MANAGER = "AUCTION_MANAGER";
    public static final String STAFF = "STAFF";
    public static final String CUSTOMER = "CUSTOMER";

    private RoleConstants() {
    }

    public static boolean isAdmin(String role) {
        return ADMIN.equals(role);
    }

    public static boolean isManager(String role) {
        return MANAGER.equals(role);
    }

    public static boolean isStaff(String role) {
        return STAFF.equals(role);
    }
}
