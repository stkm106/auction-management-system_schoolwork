package uef.edu.vn.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import uef.edu.vn.model.AuctionDeposit;
import uef.edu.vn.utils.DBConnection;

public class AuctionDepositDAO {

    public AuctionDeposit findByAuctionAndUser(int auctionId, int userId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT * FROM auction_deposits WHERE auction_id=? AND user_id=?")) {
            ps.setInt(1, auctionId);
            ps.setInt(2, userId);
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

    public List<AuctionDeposit> findByAuction(int auctionId) {
        List<AuctionDeposit> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM auction_deposits WHERE auction_id=?")) {
            ps.setInt(1, auctionId);
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

    public List<AuctionDeposit> findByUser(int userId) {
        List<AuctionDeposit> list = new ArrayList<>();
        String sql = "SELECT d.*, p.name AS product_name FROM auction_deposits d "
                + "JOIN auctions a ON d.auction_id=a.auction_id "
                + "JOIN products p ON a.product_id=p.product_id WHERE d.user_id=? ORDER BY d.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AuctionDeposit d = mapRow(rs);
                    d.setProductName(rs.getString("product_name"));
                    list.add(d);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insert(AuctionDeposit d) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "INSERT INTO auction_deposits(auction_id,user_id,deposit_amount,status) VALUES(?,?,?,?)")) {
            ps.setInt(1, d.getAuctionId());
            ps.setInt(2, d.getUserId());
            ps.setDouble(3, d.getDepositAmount());
            ps.setString(4, d.getStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int depositId, String status) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "UPDATE auction_deposits SET status=? WHERE deposit_id=?")) {
            ps.setString(1, status);
            ps.setInt(2, depositId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private AuctionDeposit mapRow(ResultSet rs) throws Exception {
        AuctionDeposit d = new AuctionDeposit();
        d.setDepositId(rs.getInt("deposit_id"));
        d.setAuctionId(rs.getInt("auction_id"));
        d.setUserId(rs.getInt("user_id"));
        d.setDepositAmount(rs.getDouble("deposit_amount"));
        d.setStatus(rs.getString("status"));
        d.setCreatedAt(rs.getTimestamp("created_at"));
        return d;
    }
}
