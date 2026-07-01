package uef.edu.vn.util;

import uef.edu.vn.model.User;

public final class AdminUtils {

    private AdminUtils() {
    }

    public static boolean isAdmin(User user) {
        return RoleUtils.isAdmin(user);
    }
}
