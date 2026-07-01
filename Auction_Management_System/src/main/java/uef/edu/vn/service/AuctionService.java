/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.service;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.AuctionSession;
import uef.edu.vn.model.Bid;
import uef.edu.vn.model.Notification;
import uef.edu.vn.model.Payment;
import uef.edu.vn.model.Product;
import uef.edu.vn.repository.AuctionSessionRepository;
import uef.edu.vn.repository.BidRepository;
import uef.edu.vn.repository.NotificationRepository;
import uef.edu.vn.repository.PaymentRepository;
import uef.edu.vn.util.ValidationUtils;

@Service
public class AuctionService {

    @Autowired
    private AuctionSessionRepository auctionRepository;

    @Autowired
    private ProductService productService;

    @Autowired
    private BidRepository bidRepository;

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private NotificationRepository notificationRepository;

    @Autowired
    private AuctionDepositService auctionDepositService;

    @Autowired
    private PaymentSettlementService paymentSettlementService;

    public AuctionSession findByProductId(int productID) {
        return auctionRepository.findByProductId(productID);
    }

    public List<AuctionSession> findAll() {
        return auctionRepository.findAll();
    }

    public AuctionSession findById(int auctionID) {
        return auctionRepository.findById(auctionID);
    }

    public List<AuctionSession> findByStatus(String status) {
        return auctionRepository.findByStatus(status);
    }

    public boolean createAuction(AuctionSession auction) {
        try {
            ValidationUtils.validateAuction(auction);

            Product product = productService.findById(auction.getProductID());
            if (product == null || !"Approved".equalsIgnoreCase(product.getStatus())) {
                throw new ValidationException("Sản phẩm chưa được duyệt hoặc không tồn tại.");
            }
            if (findByProductId(auction.getProductID()) != null) {
                throw new ValidationException("Sản phẩm đã có phiên đấu giá.");
            }

            auction.setStatus("Upcoming");
            if (auctionRepository.save(auction) <= 0) {
                return false;
            }
            productService.updateStatus(auction.getProductID(), "Auctioning");
            return true;
        } catch (ValidationException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new ValidationException("Không thể tạo phiên đấu giá. Vui lòng thử lại.");
        }
    }

    public boolean startAuction(int auctionID) {
        AuctionSession auction = auctionRepository.findById(auctionID);
        if (auction == null || !"Upcoming".equalsIgnoreCase(auction.getStatus())) {
            return false;
        }
        Date now = new Date();
        if (auction.getStartTime() != null && now.before(auction.getStartTime())) {
            return false;
        }
        if (auction.getEndTime() != null && !now.before(auction.getEndTime())) {
            return false;
        }
        return auctionRepository.updateStatus(auctionID, "Open") > 0;
    }

    public boolean closeAuction(int auctionID) {
        AuctionSession auction = auctionRepository.findById(auctionID);
        if (auction == null) {
            return false;
        }
        if ("Closed".equalsIgnoreCase(auction.getStatus())) {
            return true;
        }
        finalizeAuction(auction);
        return true;
    }

    public void processScheduledAuctions() {
        Date now = new Date();
        for (AuctionSession auction : auctionRepository.findAll()) {
            syncAuctionStatus(auction, now);
        }
    }

    private void syncAuctionStatus(AuctionSession auction, Date now) {
        if (auction == null || auction.getStatus() == null || auction.getEndTime() == null) {
            return;
        }
        String status = auction.getStatus();
        if ("Closed".equalsIgnoreCase(status) || "Cancelled".equalsIgnoreCase(status)) {
            return;
        }

        Date start = auction.getStartTime();
        Date end = auction.getEndTime();

        if ("Upcoming".equalsIgnoreCase(status)) {
            if (!now.before(end)) {
                expireMissedUpcoming(auction);
            } else if (start != null && !now.before(start)) {
                auctionRepository.updateStatus(auction.getAuctionID(), "Open");
            }
            return;
        }

        if ("Open".equalsIgnoreCase(status)) {
            if (start != null && now.before(start)) {
                auctionRepository.updateStatus(auction.getAuctionID(), "Upcoming");
                return;
            }
            if (!now.before(end)) {
                finalizeAuction(auction);
            }
        }
    }

    private void finalizeAuction(AuctionSession auction) {
        if (auction == null || "Closed".equalsIgnoreCase(auction.getStatus())) {
            return;
        }

        Product product = productService.findById(auction.getProductID());
        int ownerID = product != null ? product.getOwnerID() : -1;
        Bid highestBid = ownerID > 0
                ? bidRepository.findHighestBidExcludingUser(auction.getAuctionID(), ownerID)
                : bidRepository.findHighestBid(auction.getAuctionID());
        if (highestBid != null) {
            if (product != null && product.getOwnerID() == highestBid.getUserID()) {
                closeWithoutWinner(auction);
                return;
            }
            auctionRepository.updateWinner(auction.getAuctionID(), highestBid.getUserID());
            productService.updateStatus(auction.getProductID(), "Sold");
            auctionDepositService.settleDepositsOnClose(auction.getAuctionID(), highestBid.getUserID());
            createPendingPayment(auction, highestBid);
            notifyWinner(auction, highestBid);
            return;
        }

        closeWithoutWinner(auction);
    }

    private void closeWithoutWinner(AuctionSession auction) {
        auctionDepositService.refundAllDeposits(auction.getAuctionID());
        auctionRepository.updateStatus(auction.getAuctionID(), "Closed");
        productService.updateStatus(auction.getProductID(), "Approved");
    }

    private void expireMissedUpcoming(AuctionSession auction) {
        auctionDepositService.refundAllDeposits(auction.getAuctionID());
        auctionRepository.updateStatus(auction.getAuctionID(), "Cancelled");
        productService.updateStatus(auction.getProductID(), "Approved");
    }

    private void createPendingPayment(AuctionSession auction, Bid winningBid) {
        if (paymentRepository.findByAuctionId(auction.getAuctionID()) != null) {
            return;
        }
        BigDecimal totalAmount = winningBid.getBidAmount();
        BigDecimal depositAmount = auctionDepositService.getWinnerDepositAmount(
                auction.getAuctionID(), winningBid.getUserID());
        BigDecimal remaining = totalAmount.subtract(depositAmount);
        if (remaining.compareTo(BigDecimal.ZERO) < 0) {
            remaining = BigDecimal.ZERO;
        }

        Payment payment = new Payment();
        payment.setAuctionID(auction.getAuctionID());
        payment.setBuyerID(winningBid.getUserID());
        payment.setTotalAmount(totalAmount);
        payment.setDepositAmount(depositAmount);
        payment.setAmount(remaining);
        payment.setDueDate(AuctionDepositService.addDays(new Date(), AuctionDepositService.PAYMENT_DUE_DAYS));
        if (remaining.compareTo(BigDecimal.ZERO) <= 0) {
            payment.setStatus("Paid");
            payment.setPaymentDate(new Date());
        } else {
            payment.setStatus("Pending");
        }
        paymentRepository.save(payment);
        Payment created = paymentRepository.findByAuctionId(auction.getAuctionID());
        if (created != null && "Paid".equalsIgnoreCase(created.getStatus())) {
            paymentSettlementService.settle(created.getPaymentID());
        }
    }

    private void notifyWinner(AuctionSession auction, Bid winningBid) {
        Product product = productService.findById(auction.getProductID());
        String productName = product != null ? product.getProductName() : ("#" + auction.getProductID());
        BigDecimal depositAmount = auctionDepositService.getWinnerDepositAmount(
                auction.getAuctionID(), winningBid.getUserID());
        BigDecimal remaining = winningBid.getBidAmount().subtract(depositAmount);

        Notification notification = new Notification();
        notification.setUserID(winningBid.getUserID());
        notification.setContent("Bạn đã thắng phiên đấu giá " + productName
                + " với giá " + winningBid.getBidAmount() + " VND. Tiền cọc "
                + depositAmount + " VND đã được áp dụng. Vui lòng thanh toán phần còn lại "
                + remaining + " VND trong vòng " + AuctionDepositService.PAYMENT_DUE_DAYS + " ngày.");
        notification.setStatus("Unread");
        notificationRepository.save(notification);
    }

    public boolean updatePrice(int auctionID, BigDecimal currentPrice) {
        return auctionRepository.updateCurrentPrice(auctionID, currentPrice) > 0;
    }

    public boolean updateWinner(int auctionID, int winnerID) {
        return auctionRepository.updateWinner(auctionID, winnerID) > 0;
    }

    public boolean update(AuctionSession auction) {
        return auctionRepository.update(auction) > 0;
    }

    public boolean delete(int auctionID) {
        return auctionRepository.delete(auctionID) > 0;
    }
}
