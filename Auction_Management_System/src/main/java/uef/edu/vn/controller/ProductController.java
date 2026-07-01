/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import uef.edu.vn.model.AuctionSession;
import uef.edu.vn.model.Product;
import uef.edu.vn.model.User;
import uef.edu.vn.service.AuctionService;
import uef.edu.vn.service.CategoryService;
import uef.edu.vn.service.DashboardService;
import uef.edu.vn.service.ProductImageService;
import uef.edu.vn.service.ProductService;
import uef.edu.vn.service.UserService;
import uef.edu.vn.util.AdminUtils;
import uef.edu.vn.util.RoleUtils;
import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.util.ValidationUtils;

@Controller
@RequestMapping("/products")
public class ProductController {

    @Autowired
    private ProductService productService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private DashboardService dashboardService;

    @Autowired
    private ProductImageService productImageService;

    @Autowired
    private AuctionService auctionService;

    @Autowired
    private UserService userService;

    @GetMapping
    public String list(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (AdminUtils.isAdmin(user)) {
            return "redirect:/products/manage";
        }
        return "redirect:/products/browse";
    }

    @GetMapping("/browse")
    public String browse(Model model) {
        model.addAttribute("products", productService.findApprovedWithoutAuction());
        model.addAttribute("layout", "public");
        model.addAttribute("body", "/WEB-INF/views/products/list.jsp");
        return "shared/main";
    }

    @GetMapping("/manage")
    public String manage(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer categoryId,
            @RequestParam(required = false) String status,
            HttpSession session,
            Model model) {
        User user = (User) session.getAttribute("user");
        populateAdminModel(model, filterProducts(keyword, categoryId, status, user));
        return "shared/main";
    }

    @GetMapping("/manage/search")
    public String manageSearch(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer categoryId,
            @RequestParam(required = false) String status,
            HttpSession session,
            Model model) {
        User user = (User) session.getAttribute("user");
        populateAdminModel(model, filterProducts(keyword, categoryId, status, user));
        return "shared/main";
    }

    @GetMapping("/my")
    public String myProducts(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        List<Product> products = productService.findByOwnerId(user.getUserID());
        Map<Integer, AuctionSession> auctionMap = new HashMap<>();
        for (Product product : products) {
            AuctionSession auction = auctionService.findByProductId(product.getProductID());
            if (auction != null) {
                auctionMap.put(product.getProductID(), auction);
            }
        }
        model.addAttribute("products", products);
        model.addAttribute("auctionMap", auctionMap);
        model.addAttribute("layout", "admin");
        model.addAttribute("activeMenu", "my-products");
        model.addAttribute("body", "/WEB-INF/views/products/my-list.jsp");
        return "shared/main";
    }

    @GetMapping("/my/detail/{id}")
    public String myDetail(@PathVariable int id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        Product product = productService.findById(id);
        if (product == null || product.getOwnerID() != user.getUserID()) {
            return "redirect:/products/my";
        }
        AuctionSession auction = auctionService.findByProductId(id);
        model.addAttribute("product", product);
        model.addAttribute("auction", auction);
        model.addAttribute("category", categoryService.findById(product.getCategoryID()));
        model.addAttribute("pageTitle", "Chi tiết sản phẩm");
        model.addAttribute("layout", "admin");
        model.addAttribute("activeMenu", "my-products");
        model.addAttribute("body", "/WEB-INF/views/products/my-detail.jsp");
        return "shared/main";
    }

    @GetMapping("/my/create")
    public String myCreate(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (!RoleUtils.canViewOwnProducts(user)) {
            return "redirect:/login";
        }
        populateMyFormModel(model, new Product(), null);
        return "shared/main";
    }

    @PostMapping("/my/save")
    public String mySave(
            @ModelAttribute Product product,
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
            HttpSession session,
            HttpServletRequest request,
            Model model) {
        User user = (User) session.getAttribute("user");
        if (!RoleUtils.canViewOwnProducts(user)) {
            return "redirect:/login";
        }
        try {
            ValidationUtils.validateProduct(product, imageFile, true);
            product.setOwnerID(user.getUserID());
            if (imageFile != null && !imageFile.isEmpty()) {
                product.setImageURL(productImageService.saveImage(imageFile, request.getServletContext()));
            }
            productService.save(product);
            return "redirect:/products/my";
        } catch (ValidationException ex) {
            populateMyFormModel(model, product, ex.getMessage());
            return "shared/main";
        } catch (Exception ex) {
            populateMyFormModel(model, product, "Không thể lưu sản phẩm. Vui lòng thử lại.");
            return "shared/main";
        }
    }

    @GetMapping("/detail/{id}")
    public String detail(@PathVariable int id, Model model) {
        model.addAttribute("product", productService.findById(id));
        model.addAttribute("layout", "light");
        model.addAttribute("body", "/WEB-INF/views/products/detail.jsp");
        return "shared/main";
    }

    @GetMapping("/create")
    public String create(Model model) {
        model.addAttribute("product", new Product());
        model.addAttribute("categories", categoryService.findAll());
        model.addAttribute("layout", "admin");
        model.addAttribute("activeMenu", "products");
        model.addAttribute("body", "/WEB-INF/views/products/form.jsp");
        return "shared/main";
    }

    @PostMapping("/save")
    public String save(
            @ModelAttribute Product product,
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
            HttpSession session,
            HttpServletRequest request,
            Model model) {
        try {
            User user = (User) session.getAttribute("user");
            ValidationUtils.validateProduct(product, imageFile, false);
            product.setOwnerID(user.getUserID());

            if (imageFile != null && !imageFile.isEmpty()) {
                product.setImageURL(productImageService.saveImage(imageFile, request.getServletContext()));
            }

            productService.save(product);
            return "redirect:/products/manage";
        } catch (ValidationException ex) {
            return showFormError(model, product, ex.getMessage(), false);
        } catch (Exception ex) {
            return showFormError(model, product, "Không thể lưu sản phẩm. Vui lòng thử lại.", false);
        }
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable int id, Model model) {
        model.addAttribute("product", productService.findById(id));
        model.addAttribute("categories", categoryService.findAll());
        model.addAttribute("layout", "admin");
        model.addAttribute("activeMenu", "products");
        model.addAttribute("body", "/WEB-INF/views/products/form.jsp");
        return "shared/main";
    }

    @PostMapping("/update")
    public String update(
            @ModelAttribute Product product,
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
            HttpServletRequest request,
            Model model) {
        try {
            Product existing = productService.findById(product.getProductID());
            if (existing == null) {
                throw new ValidationException("Sản phẩm không tồn tại.");
            }
            ValidationUtils.validateProduct(product, imageFile, false);
            product.setStatus(existing.getStatus());

            if (imageFile != null && !imageFile.isEmpty()) {
                product.setImageURL(productImageService.saveImage(imageFile, request.getServletContext()));
            } else {
                product.setImageURL(existing.getImageURL());
            }

            productService.update(product);
            return "redirect:/products/manage";
        } catch (ValidationException ex) {
            return showFormError(model, product, ex.getMessage(), true);
        } catch (Exception ex) {
            return showFormError(model, product, "Không thể cập nhật sản phẩm. Vui lòng thử lại.", true);
        }
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable int id) {
        productService.delete(id);
        return "redirect:/products/manage";
    }

    @GetMapping("/approve/{id}")
    public String approve(@PathVariable int id, HttpSession session) {
        User user = refreshSessionUser(session);
        if (!RoleUtils.canReviewProducts(user)) {
            return "redirect:/products/manage";
        }
        productService.approve(id);
        return "redirect:/products/manage";
    }

    @GetMapping("/decline/{id}")
    public String decline(@PathVariable int id, HttpSession session) {
        User user = refreshSessionUser(session);
        if (!RoleUtils.canReviewProducts(user)) {
            return "redirect:/products/manage";
        }
        productService.reject(id);
        return "redirect:/products/manage";
    }

    @GetMapping("/reject/{id}")
    public String reject(@PathVariable int id, HttpSession session) {
        return decline(id, session);
    }

    @GetMapping("/search")
    public String search(@RequestParam(required = false) String keyword, HttpSession session, Model model) {
        if (AdminUtils.isAdmin((User) session.getAttribute("user"))) {
            return "redirect:/products/manage?keyword=" + URLEncoder.encode(keyword != null ? keyword : "", StandardCharsets.UTF_8);
        }
        model.addAttribute("products", productService.findApprovedWithoutAuction(keyword));
        model.addAttribute("layout", "public");
        model.addAttribute("body", "/WEB-INF/views/products/list.jsp");
        return "shared/main";
    }

    private String showFormError(Model model, Product product, String error, boolean editing) {
        model.addAttribute("product", product);
        model.addAttribute("categories", categoryService.findAll());
        model.addAttribute("error", error);
        model.addAttribute("layout", "admin");
        model.addAttribute("activeMenu", "products");
        model.addAttribute("body", "/WEB-INF/views/products/form.jsp");
        return "shared/main";
    }

    private List<Product> filterProducts(String keyword, Integer categoryId, String status, User user) {
        List<Product> products = productService.findAll();

        if (RoleUtils.isManager(user)) {
            products = products.stream()
                    .filter(p -> "Approved".equalsIgnoreCase(p.getStatus()))
                    .collect(Collectors.toList());
        }

        if (keyword != null && !keyword.isBlank()) {
            String key = keyword.toLowerCase();
            products = products.stream()
                    .filter(p -> p.getProductName() != null && p.getProductName().toLowerCase().contains(key))
                    .collect(Collectors.toList());
        }
        if (categoryId != null && categoryId > 0) {
            products = products.stream()
                    .filter(p -> p.getCategoryID() == categoryId)
                    .collect(Collectors.toList());
        }
        if (status != null && !status.isBlank()) {
            products = products.stream()
                    .filter(p -> status.equalsIgnoreCase(p.getStatus()))
                    .collect(Collectors.toList());
        }
        return products;
    }

    private void populateMyFormModel(Model model, Product product, String error) {
        model.addAttribute("product", product);
        model.addAttribute("categories", categoryService.findAll());
        if (error != null) {
            model.addAttribute("error", error);
        }
        model.addAttribute("layout", "admin");
        model.addAttribute("activeMenu", "my-products");
        model.addAttribute("body", "/WEB-INF/views/products/my-form.jsp");
    }

    private void populateAdminModel(Model model, List<Product> products) {
        model.addAttribute("products", products);
        model.addAttribute("categories", categoryService.findAll());
        model.addAttribute("categoryMap", dashboardService.buildCategoryNameMap());
        model.addAttribute("userMap", dashboardService.buildUserNameMap());
        model.addAttribute("layout", "admin");
        model.addAttribute("activeMenu", "products");
        model.addAttribute("body", "/WEB-INF/views/products/admin-list.jsp");
    }

    private User refreshSessionUser(HttpSession session) {
        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser == null) {
            return null;
        }
        User user = userService.findById(sessionUser.getUserID());
        if (user != null) {
            session.setAttribute("user", user);
        }
        return user != null ? user : sessionUser;
    }
}
