package uef.edu.vn.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import uef.edu.vn.dao.AuctionDAO;
import uef.edu.vn.dao.PaymentDAO;
import uef.edu.vn.dao.ProductDAO;
import uef.edu.vn.service.AuctionService;

@Controller
@RequestMapping("/staff")
public class StaffController {

    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final AuctionDAO auctionDAO = new AuctionDAO();
    private final ProductDAO productDAO = new ProductDAO();
    private final AuctionService auctionService = new AuctionService();

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("pendingPayments", paymentDAO.findAll("PENDING"));
        model.addAttribute("pendingProducts", productDAO.findAll(null, null, "PENDING"));
        model.addAttribute("activeAuctions", auctionDAO.findAll("ACTIVE", null, null));
        return "staff/dashboard";
    }

    @PostMapping("/products/approve")
    public String approveProduct(@RequestParam int productId) {
        productDAO.updateStatus(productId, "APPROVED");
        return "redirect:/staff/dashboard";
    }

    @PostMapping("/auctions/end")
    public String endAuction(@RequestParam int auctionId) {
        auctionService.endAuction(auctionId);
        return "redirect:/staff/dashboard";
    }
}
