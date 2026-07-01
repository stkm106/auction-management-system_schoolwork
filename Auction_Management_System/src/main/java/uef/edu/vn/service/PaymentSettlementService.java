package uef.edu.vn.service;

import java.math.BigDecimal;
import java.math.RoundingMode;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.AuctionSession;
import uef.edu.vn.model.Notification;
import uef.edu.vn.model.Payment;
import uef.edu.vn.model.Product;
import uef.edu.vn.repository.AuctionSessionRepository;
import uef.edu.vn.repository.NotificationRepository;
import uef.edu.vn.repository.PaymentRepository;

@Service
public class PaymentSettlementService {

    public static final BigDecimal PLATFORM_FEE_RATE = new BigDecimal("0.10");

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private AuctionSessionRepository auctionRepository;

    @Autowired
    private ProductService productService;

    @Autowired
    private WalletService walletService;

    @Autowired
    private NotificationRepository notificationRepository;

    @Transactional
    public void settle(int paymentID) {
        Payment payment = paymentRepository.findById(paymentID);
        if (payment == null || !"Paid".equalsIgnoreCase(payment.getStatus())) {
            return;
        }
        if (payment.isFundsReleased()) {
            return;
        }

        BigDecimal totalAmount = payment.getTotalAmount();
        if (totalAmount == null || totalAmount.compareTo(BigDecimal.ZERO) <= 0) {
            return;
        }

        AuctionSession auction = auctionRepository.findById(payment.getAuctionID());
        if (auction == null) {
            throw new ValidationException("Không tìm thấy phiên đấu giá để phân chia doanh thu.");
        }

        Product product = productService.findById(auction.getProductID());
        if (product == null) {
            throw new ValidationException("Không tìm thấy sản phẩm để phân chia doanh thu.");
        }

        BigDecimal commissionAmount = totalAmount.multiply(PLATFORM_FEE_RATE)
                .setScale(2, RoundingMode.HALF_UP);
        BigDecimal sellerAmount = totalAmount.subtract(commissionAmount);

        int sellerId = product.getOwnerID();
        walletService.credit(sellerId, sellerAmount, "Sale");

        int updated = paymentRepository.updateSettlement(paymentID, sellerAmount, commissionAmount);
        if (updated <= 0) {
            throw new ValidationException("Không thể ghi nhận phân chia doanh thu cho giao dịch #" + paymentID);
        }

        notifySeller(sellerId, product.getProductName(), sellerAmount, commissionAmount);
    }

    private void notifySeller(int sellerID, String productName, BigDecimal sellerAmount, BigDecimal commissionAmount) {
        Notification notification = new Notification();
        notification.setUserID(sellerID);
        notification.setContent("Sản phẩm \"" + productName + "\" đã được thanh toán. "
                + sellerAmount.toPlainString()
                + " VND đã được cộng vào ví của bạn (phí hệ thống 10%: "
                + commissionAmount.toPlainString() + " VND).");
        notification.setStatus("Unread");
        notificationRepository.save(notification);
    }
}
