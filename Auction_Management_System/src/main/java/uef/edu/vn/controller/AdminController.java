package uef.edu.vn.controller;

import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import uef.edu.vn.dao.AuctionDAO;
import uef.edu.vn.dao.BidDAO;
import uef.edu.vn.dao.CategoryDAO;
import uef.edu.vn.dao.PaymentDAO;
import uef.edu.vn.dao.ProductDAO;
import uef.edu.vn.dao.UserDAO;
import uef.edu.vn.dao.WalletTransactionDAO;
import uef.edu.vn.model.Auction;
import uef.edu.vn.model.Category;
import uef.edu.vn.model.User;
import uef.edu.vn.service.AuctionService;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final UserDAO userDAO = new UserDAO();
    private final AuctionDAO auctionDAO = new AuctionDAO();
    private final BidDAO bidDAO = new BidDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ProductDAO productDAO = new ProductDAO();
    private final WalletTransactionDAO txDAO = new WalletTransactionDAO();
    private final AuctionService auctionService = new AuctionService();

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("totalUsers", userDAO.countAll());
        model.addAttribute("totalAuctions", auctionDAO.countAll());
        model.addAttribute("activeAuctions", auctionDAO.countByStatus("ACTIVE"));
        model.addAttribute("revenue", paymentDAO.totalRevenue());
        List<Auction> all = auctionDAO.findAll(null, null, null);
        model.addAttribute("recentAuctions", all.isEmpty() ? all : all.subList(0, Math.min(5, all.size())));
        return "admin/dashboard";
    }

    @GetMapping("/users")
    public String users(@RequestParam(required = false) String keyword,
            @RequestParam(required = false) String role, Model model) {
        model.addAttribute("users", userDAO.findAll(keyword, role));
        return "admin/users";
    }

    @PostMapping("/users/update")
    public String updateUser(@RequestParam int userId, @RequestParam String role, @RequestParam String status) {
        User u = userDAO.findById(userId);
        if (u != null) {
            u.setRole(role);
            u.setStatus(status);
            userDAO.update(u);
        }
        return "redirect:/admin/users";
    }

    @GetMapping("/categories")
    public String categories(Model model) {
        model.addAttribute("categories", categoryDAO.findAll());
        return "admin/categories";
    }

    @PostMapping("/categories/save")
    public String saveCategory(@RequestParam(required = false) Integer categoryId,
            @RequestParam String name, @RequestParam String description) {
        Category c = new Category();
        c.setName(name);
        c.setDescription(description);
        if (categoryId != null && categoryId > 0) {
            c.setCategoryId(categoryId);
            categoryDAO.update(c);
        } else {
            categoryDAO.insert(c);
        }
        return "redirect:/admin/categories";
    }

    @GetMapping("/categories/delete/{id}")
    public String deleteCategory(@PathVariable int id) {
        categoryDAO.delete(id);
        return "redirect:/admin/categories";
    }

    @GetMapping("/products")
    public String products(@RequestParam(required = false) String status, Model model) {
        model.addAttribute("products", productDAO.findAll(null, null, status));
        return "admin/products";
    }

    @PostMapping("/products/approve")
    public String approve(@RequestParam int productId, @RequestParam String status) {
        productDAO.updateStatus(productId, status);
        return "redirect:/admin/products";
    }

    @GetMapping("/auctions")
    public String auctions(Model model) {
        model.addAttribute("auctions", auctionDAO.findAll(null, null, null));
        return "admin/auctions";
    }

    @PostMapping("/auctions/end")
    public String endAuction(@RequestParam int auctionId) {
        auctionService.endAuction(auctionId);
        return "redirect:/admin/auctions";
    }

    @GetMapping("/bids")
    public String bids(Model model) {
        model.addAttribute("bids", bidDAO.findAllRecent(100));
        return "admin/bids";
    }

    @GetMapping("/payments")
    public String payments(@RequestParam(required = false) String status, Model model) {
        model.addAttribute("payments", paymentDAO.findAll(status));
        return "admin/payments";
    }

    @GetMapping("/wallet-transactions")
    public String walletTx(Model model) {
        model.addAttribute("transactions", txDAO.findAllRecent(200));
        return "admin/wallet-transactions";
    }
}
