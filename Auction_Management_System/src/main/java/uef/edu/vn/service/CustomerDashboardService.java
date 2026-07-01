package uef.edu.vn.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import uef.edu.vn.model.AuctionSession;
import uef.edu.vn.model.Bid;
import uef.edu.vn.model.Notification;
import uef.edu.vn.model.Payment;
import uef.edu.vn.model.Product;
import uef.edu.vn.model.User;
import uef.edu.vn.model.Wallet;
import uef.edu.vn.model.WalletTransaction;
import uef.edu.vn.repository.NotificationRepository;

@Service
public class CustomerDashboardService {

    @Autowired
    private BidService bidService;

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private ProductService productService;

    @Autowired
    private AuctionService auctionService;

    @Autowired
    private WalletService walletService;

    @Autowired
    private UserService userService;

    @Autowired
    private NotificationRepository notificationRepository;

    public User getUserProfile(int userId) {
        return userService.findById(userId);
    }

    public int countBids(int userId) {
        return bidService.findByUserId(userId).size();
    }

    public int countOrders(int userId) {
        return paymentService.findByBuyerId(userId).size();
    }

    public int countMyProducts(int userId) {
        return productService.findByOwnerId(userId).size();
    }

    public BigDecimal getWalletBalance(int userId) {
        Wallet wallet = walletService.findByUserId(userId);
        return wallet != null && wallet.getBalance() != null ? wallet.getBalance() : BigDecimal.ZERO;
    }

    public List<AuctionSession> getActiveAuctions(int limit) {
        return auctionService.findAll().stream()
                .filter(a -> {
                    String effective = a.getEffectiveStatus();
                    return "Open".equalsIgnoreCase(effective) || "Upcoming".equalsIgnoreCase(effective);
                })
                .limit(limit)
                .collect(Collectors.toList());
    }

    public Map<Integer, Product> buildProductMap() {
        Map<Integer, Product> map = new HashMap<>();
        for (Product product : productService.findAll()) {
            map.put(product.getProductID(), product);
        }
        return map;
    }

    public List<Product> getMyProductsPreview(int userId, int limit) {
        return productService.findByOwnerId(userId).stream()
                .limit(limit)
                .collect(Collectors.toList());
    }

    public List<Notification> getNotifications(int userId, int limit) {
        return notificationRepository.findByUserId(userId).stream()
                .limit(limit)
                .collect(Collectors.toList());
    }

    public List<Map<String, Object>> getRecentActivities(int userId, int limit) {
        Map<Integer, String> productNames = buildProductNameByAuctionMap();
        List<Map<String, Object>> activities = new ArrayList<>();

        for (Bid bid : bidService.findByUserId(userId)) {
            Map<String, Object> row = new HashMap<>();
            row.put("time", bid.getBidTime());
            row.put("content", "Đặt giá mới");
            row.put("product", productNames.getOrDefault(bid.getAuctionID(), "Phiên #" + bid.getAuctionID()));
            row.put("amount", bid.getBidAmount());
            row.put("status", "Thành công");
            activities.add(row);
        }

        for (Payment payment : paymentService.findByBuyerId(userId)) {
            Map<String, Object> row = new HashMap<>();
            row.put("time", payment.getPaymentDate());
            row.put("content", "Thanh toán đơn hàng");
            row.put("product", productNames.getOrDefault(payment.getAuctionID(), "Phiên #" + payment.getAuctionID()));
            row.put("amount", payment.getAmount());
            row.put("status", "Paid".equalsIgnoreCase(payment.getStatus()) ? "Thành công" : payment.getStatus());
            activities.add(row);
        }

        Wallet wallet = walletService.findByUserId(userId);
        if (wallet != null) {
            for (WalletTransaction tx : walletService.findTransactionsByWalletId(wallet.getWalletID())) {
                Map<String, Object> row = new HashMap<>();
                row.put("time", tx.getTransactionDate());
                row.put("content", "Deposit".equalsIgnoreCase(tx.getTransactionType()) ? "Nạp tiền vào ví"
                        : "Sale".equalsIgnoreCase(tx.getTransactionType()) ? "Nhận tiền bán hàng"
                        : tx.getTransactionType());
                row.put("product", "Ví điện tử");
                row.put("amount", tx.getAmount());
                row.put("status", "Thành công");
                activities.add(row);
            }
        }

        return activities.stream()
                .filter(row -> row.get("time") != null)
                .sorted(Comparator.comparing(row -> (Date) row.get("time"), Comparator.reverseOrder()))
                .limit(limit)
                .collect(Collectors.toList());
    }

    private Map<Integer, String> buildProductNameByAuctionMap() {
        Map<Integer, String> map = new HashMap<>();
        Map<Integer, Product> products = buildProductMap();
        for (AuctionSession auction : auctionService.findAll()) {
            Product product = products.get(auction.getProductID());
            map.put(auction.getAuctionID(), product != null ? product.getProductName() : "Phiên #" + auction.getAuctionID());
        }
        return map;
    }
}
