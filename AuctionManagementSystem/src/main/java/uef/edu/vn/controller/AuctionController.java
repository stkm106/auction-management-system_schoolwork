package uef.edu.vn.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import uef.edu.vn.dao.AuctionDAO;
import uef.edu.vn.dao.AuctionDepositDAO;
import uef.edu.vn.dao.BidDAO;
import uef.edu.vn.dao.CategoryDAO;
import uef.edu.vn.dao.WalletDAO;
import uef.edu.vn.model.Auction;
import uef.edu.vn.model.AuctionDeposit;
import uef.edu.vn.model.User;

import jakarta.servlet.http.HttpSession;

@Controller
public class AuctionController {

    private final AuctionDAO auctionDAO = new AuctionDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final BidDAO bidDAO = new BidDAO();
    private final AuctionDepositDAO depositDAO = new AuctionDepositDAO();
    private final WalletDAO walletDAO = new WalletDAO();

    @GetMapping("/auctions")
    public String list(@RequestParam(required = false) String status,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer categoryId, Model model) {
        model.addAttribute("auctions", auctionDAO.findAll(status, keyword, categoryId));
        model.addAttribute("categories", categoryDAO.findAll());
        model.addAttribute("status", status);
        model.addAttribute("keyword", keyword);
        model.addAttribute("categoryId", categoryId);
        return "auction/auction-list";
    }

    @GetMapping("/auction-detail")
    public String detail(@RequestParam int id, HttpSession session, Model model) {
        Auction auction = auctionDAO.findById(id);
        if (auction == null) {
            return "redirect:/auctions";
        }
        model.addAttribute("auction", auction);
        model.addAttribute("bids", bidDAO.findByAuction(id));
        User user = (User) session.getAttribute("user");
        if (user != null) {
            AuctionDeposit deposit = depositDAO.findByAuctionAndUser(id, user.getUserId());
            model.addAttribute("hasDeposit", deposit != null && "LOCKED".equals(deposit.getStatus()));
            model.addAttribute("wallet", walletDAO.findByUserId(user.getUserId()));
            double minBid = Math.max(auction.getCurrentPrice(), auction.getStartingPrice()) + 1000;
            model.addAttribute("minBid", minBid);
        }
        return "auction/auction-detail";
    }

    @GetMapping("/categories")
    public String categories(Model model) {
        model.addAttribute("categories", categoryDAO.findAll());
        return "auction/categories";
    }
}
