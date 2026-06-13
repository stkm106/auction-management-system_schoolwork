package uef.edu.vn.controller;

import jakarta.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import uef.edu.vn.dao.AuctionDAO;
import uef.edu.vn.dao.AuctionDepositDAO;
import uef.edu.vn.dao.BidDAO;
import uef.edu.vn.dao.PaymentDAO;
import uef.edu.vn.dao.WalletDAO;
import uef.edu.vn.dao.WalletTransactionDAO;
import uef.edu.vn.model.Payment;
import uef.edu.vn.model.User;
import uef.edu.vn.service.AuctionService;
import uef.edu.vn.service.WalletService;
import uef.edu.vn.utils.RoleConstants;

@Controller
public class WalletController {

    private final WalletDAO walletDAO = new WalletDAO();
    private final WalletTransactionDAO txDAO = new WalletTransactionDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final WalletService walletService = new WalletService();
    private final AuctionService auctionService = new AuctionService();

    @GetMapping("/wallet")
    public String wallet(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        model.addAttribute("wallet", walletDAO.findByUserId(user.getUserId()));
        model.addAttribute("transactions", txDAO.findByUserId(user.getUserId()));
        return "bidder/wallet";
    }

    @PostMapping("/wallet/topup")
    public String topUp(@RequestParam double amount, HttpSession session) {
        User user = (User) session.getAttribute("user");
        String err = walletService.topUp(user.getUserId(), amount);
        if (err != null) {
            return "redirect:/wallet?error=" + encode(err);
        }
        return "redirect:/wallet?success=1";
    }

    @GetMapping("/my-payments")
    public String myPayments(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        model.addAttribute("payments", paymentDAO.findByBuyer(user.getUserId()));
        return "bidder/my-payments";
    }

    @PostMapping("/payment/pay")
    public String pay(@RequestParam int paymentId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        String err = auctionService.payPending(paymentId, user.getUserId());
        if (err != null) {
            return "redirect:/my-payments?error=" + encode(err);
        }
        return "redirect:/my-payments?success=1";
    }

    @GetMapping("/invoice")
    public String invoice(@RequestParam int id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        Payment payment = paymentDAO.findById(id);
        if (payment == null) {
            return "redirect:/my-payments";
        }
        if (user == null) {
            return "redirect:/login";
        }
        if (payment.getBuyerId() != user.getUserId() && !RoleConstants.isAdmin(user.getRole())) {
            return "redirect:/access-denied";
        }
        model.addAttribute("payment", payment);
        return "bidder/invoice";
    }

    private String encode(String s) {
        try {
            return java.net.URLEncoder.encode(s, "UTF-8");
        } catch (Exception e) {
            return "error";
        }
    }
}
