/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.AuctionDeposit;
import uef.edu.vn.model.AuctionSession;
import uef.edu.vn.model.Notification;
import uef.edu.vn.model.Product;
import uef.edu.vn.repository.AuctionDepositRepository;
import uef.edu.vn.repository.NotificationRepository;

@Service
public class AuctionDepositService {

    public static final BigDecimal DEPOSIT_RATE = new BigDecimal("0.10");
    public static final int PAYMENT_DUE_DAYS = 3;

    @Autowired
    private AuctionDepositRepository depositRepository;

    @Autowired
    private WalletService walletService;

    @Autowired
    private ProductService productService;

    @Autowired
    private NotificationRepository notificationRepository;

    public BigDecimal calculateDeposit(Product product) {
        if (product == null || product.getStartingPrice() == null) {
            return BigDecimal.ZERO;
        }
        return product.getStartingPrice()
                .multiply(DEPOSIT_RATE)
                .setScale(0, RoundingMode.HALF_UP);
    }

    public BigDecimal calculateDeposit(AuctionSession auction) {
        if (auction == null) {
            return BigDecimal.ZERO;
        }
        return calculateDeposit(productService.findById(auction.getProductID()));
    }

    public boolean hasJoined(int auctionID, int userID) {
        AuctionDeposit deposit = depositRepository.findByAuctionAndUser(auctionID, userID);
        return deposit != null && ("Held".equals(deposit.getStatus()) || "Applied".equals(deposit.getStatus()));
    }

    public AuctionDeposit findByAuctionAndUser(int auctionID, int userID) {
        return depositRepository.findByAuctionAndUser(auctionID, userID);
    }

    public void joinAuction(int auctionID, int userID, AuctionSession auction) {
        if (auction == null || (!"Open".equalsIgnoreCase(auction.getStatus())
                && !"Open".equalsIgnoreCase(auction.getEffectiveStatus()))) {
            throw new ValidationException("Phiên đấu giá chưa mở hoặc đã kết thúc.");
        }
        Date now = new Date();
        if (auction.getStartTime() != null && now.before(auction.getStartTime())) {
            throw new ValidationException("Phiên đấu giá chưa bắt đầu.");
        }
        if (auction.getEndTime() != null && !now.before(auction.getEndTime())) {
            throw new ValidationException("Phiên đấu giá đã kết thúc.");
        }
        if (hasJoined(auctionID, userID)) {
            throw new ValidationException("Bạn đã tham gia phiên đấu giá này.");
        }

        Product product = productService.findById(auction.getProductID());
        if (product != null && product.getOwnerID() == userID) {
            throw new ValidationException("Người bán không thể tham gia đấu giá sản phẩm của chính mình.");
        }
        validateBidderWalletBalance(userID, product);
        BigDecimal depositAmount = calculateDeposit(product);
        if (depositAmount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new ValidationException("Không xác định được số tiền cọc.");
        }
        if (!walletService.hasSufficientBalance(userID, depositAmount)) {
            throw new ValidationException("Số dư ví không đủ để đặt cọc "
                    + depositAmount + " VND. Vui lòng nạp thêm tiền.");
        }

        walletService.deduct(userID, depositAmount, "Payment");

        AuctionDeposit deposit = new AuctionDeposit();
        deposit.setAuctionID(auctionID);
        deposit.setUserID(userID);
        deposit.setAmount(depositAmount);
        deposit.setStatus("Held");
        depositRepository.save(deposit);
    }

    public void validateBidderWalletBalance(int userID, Product product) {
        if (product == null || product.getStartingPrice() == null) {
            return;
        }
        if (!walletService.hasBalanceAbove(userID, product.getStartingPrice())) {
            throw new ValidationException("Số dư ví phải lớn hơn giá khởi điểm ("
                    + product.getStartingPrice() + " VND) mới được tham gia đấu giá.");
        }
    }

    public void settleDepositsOnClose(int auctionID, int winnerID) {
        for (AuctionDeposit deposit : depositRepository.findByAuctionId(auctionID)) {
            if ("Held".equals(deposit.getStatus())) {
                if (deposit.getUserID() == winnerID) {
                    depositRepository.updateStatus(deposit.getDepositID(), "Applied");
                } else {
                    walletService.credit(deposit.getUserID(), deposit.getAmount(), "Refund");
                    depositRepository.updateStatus(deposit.getDepositID(), "Refunded");
                }
            }
        }
    }

    public void refundAllDeposits(int auctionID) {
        for (AuctionDeposit deposit : depositRepository.findByAuctionId(auctionID)) {
            if ("Held".equals(deposit.getStatus())) {
                walletService.credit(deposit.getUserID(), deposit.getAmount(), "Refund");
                depositRepository.updateStatus(deposit.getDepositID(), "Refunded");
            }
        }
    }

    public BigDecimal getWinnerDepositAmount(int auctionID, int winnerID) {
        AuctionDeposit deposit = depositRepository.findByAuctionAndUser(auctionID, winnerID);
        return deposit != null ? deposit.getAmount() : BigDecimal.ZERO;
    }

    public void forfeitWinnerDeposit(int auctionID, int winnerID, Product product) {
        AuctionDeposit deposit = depositRepository.findByAuctionAndUser(auctionID, winnerID);
        if (deposit != null && "Applied".equals(deposit.getStatus())) {
            depositRepository.updateStatus(deposit.getDepositID(), "Forfeited");
        }

        String productName = product != null ? product.getProductName() : ("#" + auctionID);
        Notification notification = new Notification();
        notification.setUserID(winnerID);
        notification.setContent("Bạn đã quá hạn thanh toán phiên đấu giá " + productName
                + ". Tiền cọc đã bị mất theo quy định.");
        notification.setStatus("Unread");
        notificationRepository.save(notification);
    }

    public static Date addDays(Date date, int days) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.DAY_OF_MONTH, days);
        return calendar.getTime();
    }
}
