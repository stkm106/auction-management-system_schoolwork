package uef.edu.vn.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import uef.edu.vn.dao.AuctionDAO;
import uef.edu.vn.dao.PaymentDAO;
import uef.edu.vn.dao.ReportDAO;

@Controller
@RequestMapping("/manager")
public class ManagerController {

    private final AuctionDAO auctionDAO = new AuctionDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final ReportDAO reportDAO = new ReportDAO();

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("auctions", auctionDAO.findAll(null, null, null));
        model.addAttribute("revenue", paymentDAO.totalRevenue());
        model.addAttribute("revenueStats", reportDAO.revenueByProduct());
        model.addAttribute("popularProducts", reportDAO.popularProducts());
        return "manager/dashboard";
    }

    @GetMapping("/reports")
    public String reports(Model model) {
        model.addAttribute("revenueStats", reportDAO.revenueByProduct());
        model.addAttribute("popularProducts", reportDAO.popularProducts());
        model.addAttribute("bidStats", reportDAO.bidsByMonth());
        return "manager/reports";
    }
}
