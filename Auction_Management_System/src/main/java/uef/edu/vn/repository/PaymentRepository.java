/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.repository;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import uef.edu.vn.model.Payment;

@Repository
public class PaymentRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Payment> findAll() {
        String sql = "SELECT * FROM Payments ORDER BY PaymentID DESC";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Payment.class));
    }

    public Payment findById(int paymentID) {
        String sql = "SELECT * FROM Payments WHERE PaymentID = ?";
        List<Payment> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Payment.class), paymentID);
        return list.isEmpty() ? null : list.get(0);
    }

    public List<Payment> findByBuyerId(int buyerID) {
        String sql = "SELECT * FROM Payments WHERE BuyerID = ? ORDER BY PaymentID DESC";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Payment.class), buyerID);
    }

    public Payment findByAuctionId(int auctionID) {
        String sql = "SELECT * FROM Payments WHERE AuctionID = ? LIMIT 1";
        List<Payment> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Payment.class), auctionID);
        return list.isEmpty() ? null : list.get(0);
    }

    public List<Payment> findPendingPastDue() {
        String sql = "SELECT * FROM Payments WHERE Status = 'Pending' AND DueDate IS NOT NULL AND DueDate < NOW()";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Payment.class));
    }

    public List<Payment> findPaidWithoutFundsReleased() {
        String sql = "SELECT * FROM Payments WHERE Status = 'Paid' "
                + "AND (FundsReleased IS NULL OR FundsReleased = 0) "
                + "ORDER BY PaymentID ASC";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Payment.class));
    }

    public int save(Payment payment) {
        String sql = "INSERT INTO Payments "
                + "(AuctionID, BuyerID, Amount, DepositAmount, TotalAmount, PaymentDate, DueDate, Status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql, payment.getAuctionID(), payment.getBuyerID(), payment.getAmount(),
                payment.getDepositAmount(), payment.getTotalAmount(), payment.getPaymentDate(),
                payment.getDueDate(), payment.getStatus());
    }

    public int updateStatus(int paymentID, String status) {
        String sql = "UPDATE Payments SET Status = ? WHERE PaymentID = ?";
        return jdbcTemplate.update(sql, status, paymentID);
    }

    public int markPaid(int paymentID, Date paymentDate) {
        String sql = "UPDATE Payments SET Status = 'Paid', PaymentDate = ? WHERE PaymentID = ?";
        return jdbcTemplate.update(sql, paymentDate, paymentID);
    }

    public int updateSettlement(int paymentID, BigDecimal sellerAmount, BigDecimal commissionAmount) {
        String sql = "UPDATE Payments SET SellerAmount = ?, CommissionAmount = ?, FundsReleased = 1 "
                + "WHERE PaymentID = ? AND (FundsReleased IS NULL OR FundsReleased = 0)";
        return jdbcTemplate.update(sql, sellerAmount, commissionAmount, paymentID);
    }

    public int delete(int paymentID) {
        String sql = "DELETE FROM Payments WHERE PaymentID = ?";
        return jdbcTemplate.update(sql, paymentID);
    }
}
