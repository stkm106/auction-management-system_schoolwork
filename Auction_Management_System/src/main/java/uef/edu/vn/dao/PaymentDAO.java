package uef.edu.vn.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import uef.edu.vn.model.Payment;
import uef.edu.vn.utils.DBConnection;

public class PaymentDAO {

    private static final String BASE = "SELECT pay.*, p.name AS product_name, "
            + "bu.full_name AS buyer_name, se.full_name AS seller_name "
            + "FROM payments pay "
            + "JOIN auctions a ON pay.auction_id=a.auction_id "
            + "JOIN products p ON a.product_id=p.product_id "
            + "JOIN users bu ON pay.buyer_id=bu.user_id "
            + "JOIN users se ON pay.seller_id=se.user_id ";

    public List<Payment> findAll(String status) {
        List<Payment> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE + "WHERE 1=1");
        if (status != null && !status.isEmpty()) {
            sql.append(" AND pay.status=?");
        }
        sql.append(" ORDER BY pay.payment_date DESC");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (status != null && !status.isEmpty()) {
                ps.setString(1, status);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Payment findById(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(BASE + "WHERE pay.payment_id=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Payment findByAuction(int auctionId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(BASE + "WHERE pay.auction_id=?")) {
            ps.setInt(1, auctionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Payment> findByBuyer(int buyerId) {
        List<Payment> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(BASE + "WHERE pay.buyer_id=? ORDER BY pay.payment_date DESC")) {
            ps.setInt(1, buyerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insert(Payment p) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "INSERT INTO payments(auction_id,buyer_id,seller_id,amount,deposit_used,platform_fee,seller_receive,status) VALUES(?,?,?,?,?,?,?,?)")) {
            ps.setInt(1, p.getAuctionId());
            ps.setInt(2, p.getBuyerId());
            ps.setInt(3, p.getSellerId());
            ps.setDouble(4, p.getAmount());
            ps.setDouble(5, p.getDepositUsed());
            ps.setDouble(6, p.getPlatformFee());
            ps.setDouble(7, p.getSellerReceive());
            ps.setString(8, p.getStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int paymentId, String status) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE payments SET status=? WHERE payment_id=?")) {
            ps.setString(1, status);
            ps.setInt(2, paymentId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean markPaidIfPending(int paymentId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "UPDATE payments SET status='PAID', payment_date=NOW() WHERE payment_id=? AND status='PENDING'")) {
            ps.setInt(1, paymentId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public double totalRevenue() {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT COALESCE(SUM(platform_fee),0) FROM payments WHERE status='PAID'");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Payment mapRow(ResultSet rs) throws Exception {
        Payment p = new Payment();
        p.setPaymentId(rs.getInt("payment_id"));
        p.setAuctionId(rs.getInt("auction_id"));
        p.setBuyerId(rs.getInt("buyer_id"));
        p.setSellerId(rs.getInt("seller_id"));
        p.setAmount(rs.getDouble("amount"));
        p.setDepositUsed(rs.getDouble("deposit_used"));
        p.setPlatformFee(rs.getDouble("platform_fee"));
        p.setSellerReceive(rs.getDouble("seller_receive"));
        p.setPaymentDate(rs.getTimestamp("payment_date"));
        p.setStatus(rs.getString("status"));
        p.setProductName(rs.getString("product_name"));
        p.setBuyerName(rs.getString("buyer_name"));
        p.setSellerName(rs.getString("seller_name"));
        return p;
    }
}
