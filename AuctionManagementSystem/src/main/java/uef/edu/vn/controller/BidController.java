package uef.edu.vn.controller;

import jakarta.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import uef.edu.vn.dao.AuctionDepositDAO;
import uef.edu.vn.dao.BidDAO;
import uef.edu.vn.dao.AuctionDAO;
import uef.edu.vn.model.Auction;
import uef.edu.vn.model.User;
import uef.edu.vn.service.AuctionService;
import uef.edu.vn.service.WalletService;

@Controller
public class BidController {

    private final AuctionService auctionService = new AuctionService();
    private final WalletService walletService = new WalletService();
    private final BidDAO bidDAO = new BidDAO();
    private final AuctionDepositDAO depositDAO = new AuctionDepositDAO();
    private final AuctionDAO auctionDAO = new AuctionDAO();

    @PostMapping("/placeBid")
    public String placeBid(@RequestParam int auctionId, @RequestParam double bidAmount, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        String err = auctionService.placeBid(auctionId, user.getUserId(), bidAmount);
        if (err != null) {
            return "redirect:/auction-detail?id=" + auctionId + "&error=" + encode(err);
        }
        return "redirect:/auction-detail?id=" + auctionId + "&success=1";
    }

    @PostMapping("/lock-deposit")
    public String lockDeposit(@RequestParam int auctionId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        Auction auction = auctionDAO.findById(auctionId);
        if (auction == null) {
            return "redirect:/auctions?error=" + encode("Không tìm thấy phiên đấu giá");
        }
        String err = walletService.lockDeposit(user.getUserId(), auction);
        if (err != null) {
            return "redirect:/auction-detail?id=" + auctionId + "&error=" + encode(err);
        }
        return "redirect:/auction-detail?id=" + auctionId + "&deposit=1";
    }

    @GetMapping("/my-bids")
    public String myBids(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        model.addAttribute("bids", bidDAO.findByBidder(user.getUserId()));
        model.addAttribute("deposits", depositDAO.findByUser(user.getUserId()));
        return "bidder/my-bids";
    }

    private String encode(String s) {
        try {
            return java.net.URLEncoder.encode(s, "UTF-8");
        } catch (Exception e) {
            return "1";
        }
    }
}
