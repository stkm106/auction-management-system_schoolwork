/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.controller;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.AuctionSession;
import uef.edu.vn.model.Product;
import uef.edu.vn.model.User;
import uef.edu.vn.model.Wallet;
import uef.edu.vn.service.AuctionDepositService;
import uef.edu.vn.service.AuctionService;
import uef.edu.vn.service.BidService;
import uef.edu.vn.service.DashboardService;
import uef.edu.vn.service.PaymentService;
import uef.edu.vn.service.ProductService;
import uef.edu.vn.service.WalletService;
import uef.edu.vn.util.RoleUtils;
import uef.edu.vn.util.ValidationUtils;

@Controller
@RequestMapping("/auctions")
public class AuctionController {

    @Autowired
    private AuctionService auctionService;

    @Autowired
    private ProductService productService;

    @Autowired
    private BidService bidService;

    @Autowired
    private DashboardService dashboardService;

    @Autowired
    private AuctionDepositService auctionDepositService;

    @Autowired
    private WalletService walletService;

    @Autowired
    private PaymentService paymentService;

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(Date.class, new org.springframework.beans.propertyeditors.CustomDateEditor(
                new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss"), true) {
            @Override
            public void setAsText(String text) {
                if (text == null || text.isBlank()) {
                    setValue(null);
                    return;
                }
                try {
                    setValue(ValidationUtils.parseDateTimeLocal(text, "Thời gian"));
                } catch (ValidationException ex) {
                    throw new IllegalArgumentException(ex.getMessage(), ex);
                }
            }
        });
    }

    @GetMapping
    public String list(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status,
            Model model) {
        auctionService.processScheduledAuctions();
        populatePublicListModel(model, filterAuctions(keyword, status));
        return "shared/main";
    }

    private void populatePublicListModel(Model model, List<AuctionSession> auctions) {
        Map<Integer, String> productImageMap = new HashMap<>();
        Map<Integer, String> productMap = new HashMap<>();
        for (Product p : productService.findAll()) {
            productImageMap.put(p.getProductID(), p.getImageURL());
            productMap.put(p.getProductID(), p.getProductName());
        }

        model.addAttribute("auctions", auctions);
        model.addAttribute("productImageMap", productImageMap);
        model.addAttribute("productMap", productMap);
        model.addAttribute("layout", "public");
        model.addAttribute("body", "/WEB-INF/views/auctions/list.jsp");
    }

    @GetMapping("/manage")
    public String manage(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status,
            Model model) {
        auctionService.processScheduledAuctions();
        populateAdminModel(model, filterAuctions(keyword, status));
        return "shared/main";
    }

    @GetMapping("/detail/{id}")
    public String detail(@PathVariable int id, HttpSession session, Model model) {
        auctionService.processScheduledAuctions();
        paymentService.processOverduePayments();
        AuctionSession auction = auctionService.findById(id);
        Product product = auction != null ? productService.findById(auction.getProductID()) : null;
        User user = (User) session.getAttribute("user");
        Wallet wallet = user != null ? walletService.findByUserId(user.getUserID()) : null;

        model.addAttribute("auction", auction);
        model.addAttribute("product", product);
        model.addAttribute("bids", bidService.findByAuctionId(id));
        model.addAttribute("usernameMap", dashboardService.buildUsernameMap());
        model.addAttribute("sessionUser", user);
        boolean isOwner = user != null && product != null && product.getOwnerID() == user.getUserID();
        model.addAttribute("isOwner", isOwner);
        model.addAttribute("canBid", RoleUtils.canBid(user) && !isOwner);
        model.addAttribute("hasJoined", user != null && auctionDepositService.hasJoined(id, user.getUserID()));
        model.addAttribute("depositAmount", auctionDepositService.calculateDeposit(product));
        model.addAttribute("startingPrice", product != null ? product.getStartingPrice() : null);
        model.addAttribute("walletBalance", wallet != null ? wallet.getBalance() : null);
        model.addAttribute("paymentDueDays", AuctionDepositService.PAYMENT_DUE_DAYS);
        model.addAttribute("layout", "light");
        model.addAttribute("body", "/WEB-INF/views/auctions/detail.jsp");
        return "shared/main";
    }

    @PostMapping("/join/{id}")
    public String join(@PathVariable int id, HttpSession session, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (!RoleUtils.canBid(user)) {
            redirectAttributes.addFlashAttribute("bidError", "Bạn không có quyền tham gia đấu giá.");
            return "redirect:/auctions/detail/" + id;
        }
        try {
            auctionService.processScheduledAuctions();
            AuctionSession auction = auctionService.findById(id);
            auctionDepositService.joinAuction(id, user.getUserID(), auction);
            redirectAttributes.addFlashAttribute("bidSuccess",
                    "Đã đặt cọc thành công. Bạn có thể bắt đầu trả giá.");
        } catch (ValidationException ex) {
            redirectAttributes.addFlashAttribute("bidError", ex.getMessage());
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("bidError", "Không thể tham gia phiên đấu giá. Vui lòng thử lại.");
        }
        return "redirect:/auctions/detail/" + id;
    }

    @GetMapping("/create")
    public String create(Model model) {
        model.addAttribute("auction", new AuctionSession());
        model.addAttribute("products", productService.findApprovedWithoutAuction());
        model.addAttribute("layout", "admin");
        model.addAttribute("activeMenu", "auctions");
        model.addAttribute("body", "/WEB-INF/views/auctions/form.jsp");
        return "shared/main";
    }

    @PostMapping({"/create", "/save"})
    public String save(
            @RequestParam int productID,
            @RequestParam BigDecimal currentPrice,
            @RequestParam String startTime,
            @RequestParam String endTime,
            Model model) {
        AuctionSession auction = new AuctionSession();
        auction.setProductID(productID);
        auction.setCurrentPrice(currentPrice);
        try {
            auction.setStartTime(ValidationUtils.parseDateTimeLocal(startTime, "Thời gian bắt đầu"));
            auction.setEndTime(ValidationUtils.parseDateTimeLocal(endTime, "Thời gian kết thúc"));
            if (!auctionService.createAuction(auction)) {
                throw new ValidationException("Không thể tạo phiên đấu giá. Vui lòng thử lại.");
            }
            AuctionSession created = auctionService.findByProductId(auction.getProductID());
            if (created == null) {
                throw new ValidationException("Không thể tạo phiên đấu giá. Vui lòng thử lại.");
            }
            return "redirect:/auctions/manage";
        } catch (ValidationException ex) {
            return showCreateFormError(model, auction, ex.getMessage(), startTime, endTime);
        } catch (Exception ex) {
            return showCreateFormError(model, auction, "Không thể tạo phiên đấu giá. Vui lòng thử lại.", startTime, endTime);
        }
    }

    private String showCreateFormError(Model model, AuctionSession auction, String error,
            String startTimeRaw, String endTimeRaw) {
        model.addAttribute("auction", auction);
        model.addAttribute("startTimeRaw", startTimeRaw);
        model.addAttribute("endTimeRaw", endTimeRaw);
        model.addAttribute("products", productService.findApprovedWithoutAuction());
        model.addAttribute("error", error);
        model.addAttribute("layout", "admin");
        model.addAttribute("activeMenu", "auctions");
        model.addAttribute("body", "/WEB-INF/views/auctions/form.jsp");
        return "shared/main";
    }

    @PostMapping("/update")
    public String update(@ModelAttribute AuctionSession auction, RedirectAttributes redirectAttributes) {
        try {
            ValidationUtils.validateAuction(auction);
            auctionService.update(auction);
            redirectAttributes.addFlashAttribute("success", "Đã cập nhật phiên đấu giá.");
        } catch (ValidationException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Không thể cập nhật phiên đấu giá.");
        }
        return "redirect:/auctions/manage";
    }

    @GetMapping("/start/{id}")
    public String start(@PathVariable int id) {
        auctionService.startAuction(id);
        return "redirect:/auctions/manage";
    }

    @GetMapping("/close/{id}")
    public String close(@PathVariable int id) {
        auctionService.closeAuction(id);
        return "redirect:/auctions/manage";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable int id) {
        auctionService.delete(id);
        return "redirect:/auctions/manage";
    }

    private List<AuctionSession> filterAuctions(String keyword, String status) {
        List<AuctionSession> auctions = auctionService.findAll();
        Map<Integer, String> productMap = dashboardService.buildProductNameMap();

        if (keyword != null && !keyword.isBlank()) {
            String key = keyword.toLowerCase();
            auctions = auctions.stream()
                    .filter(a -> {
                        String name = productMap.get(a.getProductID());
                        return (name != null && name.toLowerCase().contains(key))
                                || String.valueOf(a.getAuctionID()).contains(key);
                    })
                    .collect(Collectors.toList());
        }
        if (status != null && !status.isBlank()) {
            auctions = auctions.stream()
                    .filter(a -> status.equalsIgnoreCase(a.getEffectiveStatus()))
                    .collect(Collectors.toList());
        }
        return auctions;
    }

    private void populateAdminModel(Model model, List<AuctionSession> auctions) {
        Map<Integer, String> productMap = dashboardService.buildProductNameMap();
        Map<Integer, BigDecimal> productPriceMap = new HashMap<>();
        for (Product p : productService.findAll()) {
            productPriceMap.put(p.getProductID(), p.getStartingPrice());
        }

        model.addAttribute("auctions", auctions);
        model.addAttribute("productMap", productMap);
        model.addAttribute("productPriceMap", productPriceMap);
        model.addAttribute("layout", "admin");
        model.addAttribute("activeMenu", "auctions");
        model.addAttribute("body", "/WEB-INF/views/auctions/admin-list.jsp");
    }
}
