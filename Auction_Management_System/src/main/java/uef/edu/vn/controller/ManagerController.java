package uef.edu.vn.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import uef.edu.vn.dao.AuctionDAO;
import uef.edu.vn.dao.PaymentDAO;
import uef.edu.vn.dao.ReportDAO;
import uef.edu.vn.service.AuctionService;

@Controller
@RequestMapping("/manager")
public class ManagerController {

    private final AuctionDAO auctionDAO = new AuctionDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final ReportDAO reportDAO = new ReportDAO();
    private final AuctionService auctionService = new AuctionService();

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("revenue", paymentDAO.totalRevenue());
        model.addAttribute("totalAuctions", auctionDAO.countAll());
        model.addAttribute("activeAuctions", auctionDAO.countByStatus("ACTIVE"));
        model.addAttribute("pendingPayments", paymentDAO.findAll("PENDING").size());
        model.addAttribute("revenueStats", reportDAO.revenueByProduct());
        model.addAttribute("popularProducts", reportDAO.popularProducts());
        return "manager/dashboard";
    }

    @GetMapping("/auctions")
    public String auctions(@RequestParam(required = false) String status,
            @RequestParam(required = false) String keyword, Model model) {
        model.addAttribute("auctions", auctionDAO.findAll(status, keyword, null));
        model.addAttribute("status", status);
        model.addAttribute("keyword", keyword);
        return "manager/auctions";
    }

    @GetMapping("/reports")
    public String reports(Model model) {
        model.addAttribute("revenueStats", reportDAO.revenueByProduct());
        model.addAttribute("popularProducts", reportDAO.popularProducts());
        model.addAttribute("bidStats", reportDAO.bidsByMonth());
        return "manager/reports";
    }

    @PostMapping("/auctions/end")
    public String endAuction(@RequestParam int auctionId) {
        auctionService.endAuction(auctionId);
        return "redirect:/manager/auctions";
    }
}
