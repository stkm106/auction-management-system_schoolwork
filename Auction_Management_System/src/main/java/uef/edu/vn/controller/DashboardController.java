package uef.edu.vn.controller;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import uef.edu.vn.service.DashboardService;

@Controller
@RequestMapping("/dashboard")
public class DashboardController {

    @Autowired
    private DashboardService dashboardService;

    @GetMapping
    public String index(Model model) {
        model.addAttribute("totalUsers", dashboardService.countUsers());
        model.addAttribute("totalProducts", dashboardService.countProducts());
        model.addAttribute("openAuctions", dashboardService.countOpenAuctions());
        model.addAttribute("monthlyRevenue", dashboardService.monthlyRevenue());
        model.addAttribute("revenueChart", dashboardService.revenueLast7Days());
        model.addAttribute("topProducts", dashboardService.topProducts());
        model.addAttribute("categoryStats", dashboardService.categoryStats());
        model.addAttribute("recentActivity", dashboardService.recentActivity());
        model.addAttribute("layout", "admin");
        model.addAttribute("activeMenu", "dashboard");
        model.addAttribute("body", "/WEB-INF/views/dashboard/index.jsp");
        return "shared/main";
    }
}
