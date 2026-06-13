package uef.edu.vn.controller;

import jakarta.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import uef.edu.vn.dao.UserDAO;
import uef.edu.vn.model.User;
import uef.edu.vn.service.EmailService;
import uef.edu.vn.utils.RoleConstants;

@Controller
public class AuthController {

    private final UserDAO userDAO = new UserDAO();
    private final EmailService emailService = new EmailService();

    @GetMapping("/login")
    public String loginPage(@RequestParam(required = false) String error, Model model) {
        if (error != null) {
            model.addAttribute("error", "Invalid username or password");
        }
        return "auth/login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String username, @RequestParam String password, HttpSession session) {
        User user = userDAO.login(username, password);
        if (user == null) {
            return "redirect:/login?error=1";
        }
        session.setAttribute("user", user);
        return redirectByRole(user.getRole());
    }

    @GetMapping("/register")
    public String registerPage() {
        return "auth/register";
    }

    @PostMapping("/register")
    public String register(@RequestParam String username, @RequestParam String email,
            @RequestParam String password, @RequestParam String confirmPassword,
            @RequestParam(required = false) String fullName, @RequestParam(required = false) String phone,
            Model model) {
        if (!password.equals(confirmPassword)) {
            model.addAttribute("error", "Passwords do not match");
            return "auth/register";
        }
        if (userDAO.existsByUsername(username)) {
            model.addAttribute("error", "Username already exists");
            return "auth/register";
        }
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password);
        user.setFullName(fullName != null ? fullName : username);
        user.setPhone(phone);
        user.setRole(RoleConstants.CUSTOMER);
        if (userDAO.register(user)) {
            emailService.send(email, "Welcome to AuctionPro", "Account created. You can buy and sell on our platform.");
            return "redirect:/login";
        }
        model.addAttribute("error", "Registration failed");
        return "auth/register";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    private String redirectByRole(String role) {
        if (RoleConstants.ADMIN.equals(role)) {
            return "redirect:/admin/dashboard";
        }
        if (RoleConstants.MANAGER.equals(role)) {
            return "redirect:/manager/dashboard";
        }
        if (RoleConstants.STAFF.equals(role)) {
            return "redirect:/staff/dashboard";
        }
        return "redirect:/home";
    }
}
