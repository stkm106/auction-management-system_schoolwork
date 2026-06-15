package uef.edu.vn.controller;

import java.text.SimpleDateFormat;
import java.util.Date;

import jakarta.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import uef.edu.vn.dao.AuctionDAO;
import uef.edu.vn.dao.CategoryDAO;
import uef.edu.vn.dao.ProductDAO;
import uef.edu.vn.model.Auction;
import uef.edu.vn.model.Product;
import uef.edu.vn.model.User;

@Controller
public class ProductController {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final AuctionDAO auctionDAO = new AuctionDAO();

    @GetMapping("/seller/products")
    public String myProducts(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        model.addAttribute("products", productDAO.findBySeller(user.getUserId()));
        return "seller/products";
    }

    @GetMapping("/seller/product-form")
    public String form(HttpSession session, Model model) {
        model.addAttribute("categories", categoryDAO.findAll());
        return "seller/product-form";
    }

    @PostMapping("/seller/product/save")
    public String save(@RequestParam String name, @RequestParam String description,
            @RequestParam double startingPrice, @RequestParam int categoryId,
            @RequestParam(defaultValue = "GOOD") String conditionStatus,
            @RequestParam(required = false) String imageUrl, HttpSession session) {
        User user = (User) session.getAttribute("user");
        Product p = new Product();
        p.setSellerId(user.getUserId());
        p.setCategoryId(categoryId);
        p.setName(name);
        p.setDescription(description);
        p.setStartingPrice(startingPrice);
        p.setConditionStatus(conditionStatus);
        p.setStatus("PENDING");
        productDAO.insert(p, imageUrl);
        return "redirect:/seller/products";
    }

    @PostMapping("/seller/auction/create")
    public String createAuction(@RequestParam int productId,
            @RequestParam String startTime, @RequestParam String endTime, HttpSession session) throws Exception {
        User user = (User) session.getAttribute("user");
        Product p = productDAO.findById(productId);
        if (p == null || p.getSellerId() != user.getUserId()) {
            return "redirect:/seller/products";
        }
        if (!"APPROVED".equals(p.getStatus())) {
            return "redirect:/seller/products?error=not-approved";
        }
        SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
        Date start = fmt.parse(startTime);
        Date end = fmt.parse(endTime);
        if (!end.after(start)) {
            return "redirect:/seller/products?error=invalid-time";
        }
        Auction a = new Auction();
        a.setProductId(productId);
        a.setStartTime(start);
        a.setEndTime(end);
        a.setCurrentPrice(p.getStartingPrice());
        a.setDepositPercent(10);
        a.setDepositAmount(p.getStartingPrice() * 0.1);
        a.setStatus(start.after(new Date()) ? "UPCOMING" : "ACTIVE");
        auctionDAO.insert(a);
        productDAO.updateStatus(productId, "AUCTIONING");
        return "redirect:/seller/products";
    }
}
