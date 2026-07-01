/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.controller;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.AuctionSession;
import uef.edu.vn.model.Payment;
import uef.edu.vn.model.Product;
import uef.edu.vn.model.User;
import uef.edu.vn.service.AuctionService;
import uef.edu.vn.service.DashboardService;
import uef.edu.vn.service.PaymentService;
import uef.edu.vn.service.ProductService;
import uef.edu.vn.service.UserService;
import uef.edu.vn.util.RoleUtils;

@Controller
@RequestMapping("/payments")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private DashboardService dashboardService;

    @Autowired
    private AuctionService auctionService;

    @Autowired
    private ProductService productService;

    @Autowired
    private UserService userService;

    @GetMapping
    public String list(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status,
            Model model) {
        List<Payment> payments = paymentService.findAll();

        if (keyword != null && !keyword.isBlank()) {
            String key = keyword.toLowerCase();
            payments = payments.stream()
                    .filter(p -> String.valueOf(p.getPaymentID()).contains(key)
                            || ("txn-" + p.getPaymentID()).contains(key.replace("#", "")))
                    .collect(Collectors.toList());
        }
        if (status != null && !status.isBlank()) {
            payments = payments.stream()
                    .filter(p -> status.equalsIgnoreCase(p.getStatus()))
                    .collect(Collectors.toList());
        }

        Map<Integer, String> userMap = dashboardService.buildUserNameMap();
        model.addAttribute("payments", payments);
        model.addAttribute("userMap", userMap);
        model.addAttribute("layout", "admin");
        model.addAttribute("activeMenu", "payments");
        model.addAttribute("body", "/WEB-INF/views/payments/list.jsp");
        return "shared/main";
    }

    @GetMapping("/my-payments")
    public String myPayments(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        paymentService.processOverduePayments();
        model.addAttribute("payments", paymentService.findByBuyerId(user.getUserID()));
        model.addAttribute("layout", "admin");
        model.addAttribute("activeMenu", "my-payments");
        model.addAttribute("body", "/WEB-INF/views/payments/my-payments.jsp");
        return "shared/main";
    }

    @GetMapping("/my-payments/detail/{id}")
    public String myPaymentDetail(@PathVariable int id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        Payment payment = paymentService.findById(id);
        if (payment == null || payment.getBuyerID() != user.getUserID()) {
            return "redirect:/payments/my-payments";
        }
        populatePaymentDetailModel(model, payment);
        model.addAttribute("layout", "admin");
        model.addAttribute("activeMenu", "my-payments");
        model.addAttribute("body", "/WEB-INF/views/payments/my-payment-detail.jsp");
        return "shared/main";
    }

    @GetMapping("/monitor/{id}")
    public String monitor(@PathVariable int id, Model model) {
        Payment payment = paymentService.findById(id);
        if (payment == null) {
            return "redirect:/payments";
        }
        populatePaymentDetailModel(model, payment);
        model.addAttribute("layout", "admin");
        model.addAttribute("activeMenu", "payments");
        model.addAttribute("body", "/WEB-INF/views/payments/monitor.jsp");
        return "shared/main";
    }

    @GetMapping("/detail/{id}")
    public String detailRedirect(@PathVariable int id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (RoleUtils.canMonitorPayments(user) && !RoleUtils.isCustomer(user)) {
            return "redirect:/payments/monitor/" + id;
        }
        if (RoleUtils.isCustomer(user)) {
            return "redirect:/payments/my-payments/detail/" + id;
        }
        return "redirect:/payments";
    }

    private void populatePaymentDetailModel(Model model, Payment payment) {
        AuctionSession auction = auctionService.findById(payment.getAuctionID());
        Product product = auction != null ? productService.findById(auction.getProductID()) : null;
        User buyer = userService.findById(payment.getBuyerID());
        User seller = product != null ? userService.findById(product.getOwnerID()) : null;
        Map<Integer, String> categoryMap = dashboardService.buildCategoryNameMap();

        model.addAttribute("payment", payment);
        model.addAttribute("auction", auction);
        model.addAttribute("product", product);
        model.addAttribute("buyer", buyer);
        model.addAttribute("seller", seller);
        model.addAttribute("categoryName", product != null ? categoryMap.get(product.getCategoryID()) : null);
    }

    @PostMapping("/save")
    public String save(@ModelAttribute Payment payment) {
        paymentService.save(payment);
        return "redirect:/payments";
    }

    @GetMapping("/paid/{id}")
    public String paid(@PathVariable int id) {
        paymentService.markPaid(id);
        return "redirect:/payments/monitor/" + id;
    }

    @GetMapping("/cancel/{id}")
    public String cancel(@PathVariable int id) {
        paymentService.cancel(id);
        return "redirect:/payments";
    }

    @PostMapping("/pay/{id}")
    public String pay(@PathVariable int id, HttpSession session, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        try {
            paymentService.payRemaining(id, user.getUserID());
            redirectAttributes.addFlashAttribute("success", "Thanh toán phần còn lại thành công!");
        } catch (ValidationException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Không thể thanh toán. Vui lòng thử lại.");
        }
        return "redirect:/payments/my-payments";
    }
}
