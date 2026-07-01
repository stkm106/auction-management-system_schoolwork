package uef.edu.vn.controller;

import java.math.BigDecimal;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import uef.edu.vn.model.User;
import uef.edu.vn.model.Wallet;
import uef.edu.vn.service.PaymentService;
import uef.edu.vn.service.WalletService;

@Controller
@RequestMapping("/wallet")
public class WalletController {

    @Autowired
    private WalletService walletService;

    @Autowired
    private PaymentService paymentService;

    @GetMapping
    public String index(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        paymentService.settlePendingPayments();
        Wallet wallet = walletService.findByUserId(user.getUserID());
        model.addAttribute("wallet", wallet);
        model.addAttribute("monthlyTransactionCount", walletService.countMonthlyTransactions(user.getUserID()));
        if (wallet != null) {
            model.addAttribute("transactions",
                    walletService.findPersonalTransactionsByWalletId(wallet.getWalletID()));
        }
        model.addAttribute("layout", "admin");
        model.addAttribute("activeMenu", "wallet");
        model.addAttribute("body", "/WEB-INF/views/wallet/index.jsp");
        return "shared/main";
    }

    @GetMapping("/deposit")
    public String depositPage(Model model) {
        model.addAttribute("body", "/WEB-INF/views/wallet/deposit.jsp");
        return "shared/main";
    }

    @PostMapping("/deposit")
    public String deposit(@RequestParam BigDecimal amount, HttpSession session) {
        User user = (User) session.getAttribute("user");
        walletService.deposit(user.getUserID(), amount);
        return "redirect:/wallet";
    }
}
