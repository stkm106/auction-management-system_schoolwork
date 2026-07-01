package uef.edu.vn.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.User;
import uef.edu.vn.service.AuctionService;
import uef.edu.vn.service.ProductService;
import uef.edu.vn.service.UserService;
import uef.edu.vn.util.RoleUtils;
import uef.edu.vn.util.ValidationUtils;

@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private ProductService productService;

    @Autowired
    private AuctionService auctionService;

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("products", productService.findAll());
        model.addAttribute("auctions", auctionService.findAll());
        model.addAttribute("layout", "public");
        model.addAttribute("body", "/WEB-INF/views/home.jsp");
        return "shared/main";
    }

    @GetMapping("/login")
    public String loginPage() {
        return "auth/login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String username, @RequestParam String password, HttpSession session, Model model) {
        try {
            ValidationUtils.validateLogin(username, password);
            User user = userService.login(username, password);
            if (user == null) {
                model.addAttribute("error", "Sai tên đăng nhập hoặc mật khẩu");
                return "auth/login";
            }
            session.setAttribute("user", user);
            if (RoleUtils.canViewDashboard(user)) {
                return "redirect:/dashboard";
            }
            if (RoleUtils.canAccessAdminPanel(user)) {
                if (RoleUtils.canManageProducts(user)) {
                    return "redirect:/products/manage";
                }
                if (RoleUtils.canTrackAuctions(user)) {
                    return "redirect:/auctions/manage";
                }
            }
            if (RoleUtils.isCustomer(user)) {
                return "redirect:/account";
            }
            return "redirect:/";
        } catch (ValidationException ex) {
            model.addAttribute("error", ex.getMessage());
            return "auth/login";
        } catch (Exception ex) {
            model.addAttribute("error", "Không thể đăng nhập. Vui lòng thử lại.");
            return "auth/login";
        }
    }

    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("user", new User());
        return "auth/register";
    }

    @PostMapping("/register")
    public String register(@ModelAttribute User user, Model model) {
        try {
            ValidationUtils.validateRegistration(user);
            String error = userService.register(user);
            if (error != null) {
                model.addAttribute("error", error);
                return "auth/register";
            }
            return "redirect:/login";
        } catch (ValidationException ex) {
            model.addAttribute("error", ex.getMessage());
            return "auth/register";
        } catch (Exception ex) {
            model.addAttribute("error", "Không thể đăng ký. Vui lòng thử lại.");
            return "auth/register";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
