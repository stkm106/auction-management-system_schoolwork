/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.controller;

import java.math.BigDecimal;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.Bid;
import uef.edu.vn.model.User;
import uef.edu.vn.service.AuctionService;
import uef.edu.vn.service.BidService;
import uef.edu.vn.util.RoleUtils;

@Controller
@RequestMapping("/bids")
public class BidController {

    @Autowired
    private BidService bidService;

    @Autowired
    private AuctionService auctionService;

    @PostMapping("/place")
    public String placeBid(
            @RequestParam int auctionID,
            @RequestParam BigDecimal bidAmount,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (!RoleUtils.canBid(user)) {
            redirectAttributes.addFlashAttribute("bidError", "Bạn không có quyền đặt giá.");
            return "redirect:/auctions/detail/" + auctionID;
        }
        try {
            auctionService.processScheduledAuctions();
            Bid bid = new Bid();
            bid.setAuctionID(auctionID);
            bid.setUserID(user.getUserID());
            bid.setBidAmount(bidAmount);
            bidService.placeBid(bid);
            redirectAttributes.addFlashAttribute("bidSuccess", "Đặt giá thành công!");
        } catch (ValidationException ex) {
            redirectAttributes.addFlashAttribute("bidError", ex.getMessage());
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("bidError", "Không thể đặt giá. Vui lòng thử lại.");
        }
        return "redirect:/auctions/detail/" + auctionID;
    }

    @GetMapping("/my-bids")
    public String myBids(HttpSession session, org.springframework.ui.Model model) {
        User user = (User) session.getAttribute("user");
        model.addAttribute("bids", bidService.findByUserId(user.getUserID()));
        model.addAttribute("layout", "admin");
        model.addAttribute("activeMenu", "my-bids");
        model.addAttribute("body", "/WEB-INF/views/bids/my-bids.jsp");
        return "shared/main";
    }
}
