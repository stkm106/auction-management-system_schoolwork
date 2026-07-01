package uef.edu.vn.util;

import uef.edu.vn.model.User;

public class PermissionModel {

    private final User user;

    public PermissionModel(User user) {
        this.user = user;
    }

    public boolean isPortal() {
        return RoleUtils.canAccessPortal(user);
    }

    public boolean isProfile() {
        return RoleUtils.canViewProfile(user);
    }

    public boolean isMyProducts() {
        return RoleUtils.canViewOwnProducts(user);
    }

    public boolean isMyPayments() {
        return RoleUtils.canViewOwnPayments(user);
    }

    public boolean isMyWallet() {
        return RoleUtils.canViewOwnWallet(user);
    }

    public boolean isMyBids() {
        return RoleUtils.canViewMyBids(user);
    }

    public boolean isDashboard() {
        return RoleUtils.canViewDashboard(user);
    }

    public boolean isManageUsers() {
        return RoleUtils.canManageUsers(user);
    }

    public boolean isManageProducts() {
        return RoleUtils.canManageProducts(user);
    }

    public boolean isReviewProducts() {
        return RoleUtils.canReviewProducts(user);
    }

    public boolean isManageAuctions() {
        return RoleUtils.canManageAuctions(user);
    }

    public boolean isTrackAuctions() {
        return RoleUtils.canTrackAuctions(user);
    }

    public boolean isCreateAuction() {
        return RoleUtils.canCreateAuction(user);
    }

    public boolean isManagePayments() {
        return RoleUtils.canManagePayments(user);
    }

    public boolean isViewPayments() {
        return RoleUtils.canMonitorPayments(user);
    }

    public boolean isMonitorPayments() {
        return RoleUtils.canMonitorPayments(user);
    }

    public boolean isManageWallet() {
        return RoleUtils.canManageAllWallets(user);
    }

    public boolean isViewWallet() {
        return RoleUtils.canViewAllWallets(user);
    }

    public boolean isReports() {
        return RoleUtils.canViewReports(user);
    }

    public boolean isAdminPanel() {
        return RoleUtils.canAccessAdminPanel(user);
    }

    public boolean isBid() {
        return RoleUtils.canBid(user);
    }
}
