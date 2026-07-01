package uef.edu.vn.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import uef.edu.vn.model.User;
import uef.edu.vn.service.AuctionService;
import uef.edu.vn.service.CustomerDashboardService;
import uef.edu.vn.util.RoleUtils;

@Controller
public class AccountController {

    @Autowired
    private CustomerDashboardService customerDashboardService;

    @Autowired
    private AuctionService auctionService;

    @GetMapping("/account")
    public String account(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        if (RoleUtils.canViewDashboard(user)) {
            return "redirect:/dashboard";
        }
        if (RoleUtils.canAccessPortal(user)) {
            auctionService.processScheduledAuctions();
            populateCustomerDashboard(model, user);
            return "shared/main";
        }
        return "redirect:/users/profile";
    }

    private void populateCustomerDashboard(Model model, User sessionUser) {
        int userId = sessionUser.getUserID();
        User user = customerDashboardService.getUserProfile(userId);

        model.addAttribute("user", user);
        model.addAttribute("bidCount", customerDashboardService.countBids(userId));
        model.addAttribute("orderCount", customerDashboardService.countOrders(userId));
        model.addAttribute("walletBalance", customerDashboardService.getWalletBalance(userId));
        model.addAttribute("myProductCount", customerDashboardService.countMyProducts(userId));
        model.addAttribute("activeAuctions", customerDashboardService.getActiveAuctions(4));
        model.addAttribute("productMap", customerDashboardService.buildProductMap());
        model.addAttribute("myProductsPreview", customerDashboardService.getMyProductsPreview(userId, 3));
        model.addAttribute("notifications", customerDashboardService.getNotifications(userId, 4));
        model.addAttribute("recentActivities", customerDashboardService.getRecentActivities(userId, 5));
        model.addAttribute("pageTitle", "Dashboard");
        model.addAttribute("layout", "admin");
        model.addAttribute("activeMenu", "customer-dashboard");
        model.addAttribute("body", "/WEB-INF/views/customer/dashboard.jsp");
    }
}
