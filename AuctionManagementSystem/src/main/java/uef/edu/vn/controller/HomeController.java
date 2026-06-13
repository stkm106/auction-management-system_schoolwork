package uef.edu.vn.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import uef.edu.vn.dao.AuctionDAO;
import uef.edu.vn.dao.BidDAO;
import uef.edu.vn.dao.PaymentDAO;
import uef.edu.vn.dao.UserDAO;
import uef.edu.vn.model.Auction;

@Controller
public class HomeController {

    private final AuctionDAO auctionDAO = new AuctionDAO();
    private final UserDAO userDAO = new UserDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final BidDAO bidDAO = new BidDAO();

    @GetMapping({"/", "/home"})
    public String home(Model model) {
        List<Auction> featured = auctionDAO.findActiveFeatured(6);
        model.addAttribute("featured", featured);
        model.addAttribute("totalUsers", userDAO.countAll());
        model.addAttribute("totalAuctions", auctionDAO.countAll());
        model.addAttribute("totalRevenue", paymentDAO.totalRevenue());
        model.addAttribute("totalBids", bidDAO.countAll());
        return "auction/home";
    }

    @GetMapping("/access-denied")
    public String accessDenied() {
        return "shared/access-denied";
    }
}
