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
        model.addAttribute("pendingPaymentCount", paymentDAO.findAll("PENDING").size());
        model.addAttribute("pendingProductCount", productDAO.findAll(null, null, "PENDING").size());
        model.addAttribute("activeAuctionCount", auctionDAO.findAll("ACTIVE", null, null).size());
        return "staff/dashboard";
    }

    @GetMapping("/products")
    public String products(@RequestParam(required = false) String keyword, Model model) {
        model.addAttribute("products", productDAO.findAll(keyword, null, "PENDING"));
        model.addAttribute("keyword", keyword);
        return "staff/products";
    }

    @GetMapping("/auctions")
    public String auctions(@RequestParam(required = false) String keyword, Model model) {
        model.addAttribute("auctions", auctionDAO.findAll("ACTIVE", keyword, null));
        model.addAttribute("keyword", keyword);
        return "staff/auctions";
    }

    @GetMapping("/payments")
    public String payments(Model model) {
        model.addAttribute("payments", paymentDAO.findAll("PENDING"));
        model.addAttribute("pendingCount", paymentDAO.findAll("PENDING").size());
        return "staff/payments";
    }

    @PostMapping("/products/approve")
    public String approveProduct(@RequestParam int productId) {
        productDAO.updateStatus(productId, "APPROVED");
        return "redirect:/staff/products";
    }

    @PostMapping("/products/reject")
    public String rejectProduct(@RequestParam int productId) {
        productDAO.updateStatus(productId, "REJECTED");
        return "redirect:/staff/products";
    }

    @PostMapping("/auctions/end")
    public String endAuction(@RequestParam int auctionId) {
        auctionService.endAuction(auctionId);
        return "redirect:/staff/auctions";
    }
}
