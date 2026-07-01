package uef.edu.vn.service;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.AuctionSession;
import uef.edu.vn.model.Payment;
import uef.edu.vn.model.Product;
import uef.edu.vn.repository.PaymentRepository;

@Service
public class PaymentService {

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private WalletService walletService;

    @Autowired
    private AuctionService auctionService;

    @Autowired
    private ProductService productService;

    @Autowired
    private AuctionDepositService auctionDepositService;

    @Autowired
    private PaymentSettlementService paymentSettlementService;

    public void settlePendingPayments() {
        for (Payment payment : paymentRepository.findPaidWithoutFundsReleased()) {
            paymentSettlementService.settle(payment.getPaymentID());
        }
    }

    public List<Payment> findAll() {
        settlePendingPayments();
        return paymentRepository.findAll();
    }

    public Payment findById(int paymentID) {
        settlePendingPayments();
        return paymentRepository.findById(paymentID);
    }

    public List<Payment> findByBuyerId(int buyerID) {
        settlePendingPayments();
        return paymentRepository.findByBuyerId(buyerID);
    }

    public boolean save(Payment payment) {
        return paymentRepository.save(payment) > 0;
    }

    @Transactional
    public boolean markPaid(int paymentID) {
        Payment payment = paymentRepository.findById(paymentID);
        if (payment == null || !"Pending".equalsIgnoreCase(payment.getStatus())) {
            return false;
        }
        if (payment.getAmount() != null && payment.getAmount().compareTo(BigDecimal.ZERO) > 0) {
            walletService.deduct(payment.getBuyerID(), payment.getAmount(), "Payment");
        }
        paymentRepository.markPaid(paymentID, new Date());
        paymentSettlementService.settle(paymentID);
        return true;
    }

    public boolean cancel(int paymentID) {
        return paymentRepository.updateStatus(paymentID, "Cancelled") > 0;
    }

    @Transactional
    public void payRemaining(int paymentID, int userID) {
        Payment payment = paymentRepository.findById(paymentID);
        if (payment == null) {
            throw new ValidationException("Giao dịch thanh toán không tồn tại.");
        }
        if (payment.getBuyerID() != userID) {
            throw new ValidationException("Bạn không có quyền thanh toán giao dịch này.");
        }
        if (!"Pending".equalsIgnoreCase(payment.getStatus())) {
            throw new ValidationException("Giao dịch không ở trạng thái chờ thanh toán.");
        }
        if (payment.getDueDate() != null && new Date().after(payment.getDueDate())) {
            throw new ValidationException("Đã quá hạn thanh toán. Tiền cọc đã bị mất theo quy định.");
        }

        if (payment.getAmount() != null && payment.getAmount().compareTo(BigDecimal.ZERO) > 0) {
            walletService.deduct(userID, payment.getAmount(), "Payment");
        }
        paymentRepository.markPaid(paymentID, new Date());
        paymentSettlementService.settle(paymentID);
    }

    public void processOverduePayments() {
        settlePendingPayments();
        for (Payment payment : paymentRepository.findPendingPastDue()) {
            paymentRepository.updateStatus(payment.getPaymentID(), "Failed");

            AuctionSession auction = auctionService.findById(payment.getAuctionID());
            Product product = auction != null ? productService.findById(auction.getProductID()) : null;

            auctionDepositService.forfeitWinnerDeposit(
                    payment.getAuctionID(), payment.getBuyerID(), product);

            if (auction != null) {
                productService.updateStatus(auction.getProductID(), "Approved");
            }
        }
    }
}
