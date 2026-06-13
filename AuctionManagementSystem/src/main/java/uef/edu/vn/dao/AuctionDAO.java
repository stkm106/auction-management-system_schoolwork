package uef.edu.vn.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import uef.edu.vn.model.Auction;
import uef.edu.vn.utils.DBConnection;

public class AuctionDAO {

    private static final String BASE = "SELECT a.*, p.name AS product_name, p.description, p.starting_price, "
            + "p.seller_id, u.full_name AS seller_name, c.name AS category_name, "
            + "(SELECT image_url FROM product_images pi WHERE pi.product_id=p.product_id LIMIT 1) AS primary_image, "
            + "(SELECT COUNT(*) FROM bids b WHERE b.auction_id=a.auction_id) AS bid_count "
            + "FROM auctions a "
            + "JOIN products p ON a.product_id = p.product_id "
            + "JOIN users u ON p.seller_id = u.user_id "
            + "LEFT JOIN categories c ON p.category_id = c.category_id ";

    public List<Auction> findAll(String status, String keyword, Integer categoryId) {
        List<Auction> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE + "WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (status != null && !status.isEmpty()) {
            sql.append(" AND a.status=?");
            params.add(status);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND p.name LIKE ?");
            params.add("%" + keyword.trim() + "%");
        }
        if (categoryId != null && categoryId > 0) {
            sql.append(" AND p.category_id=?");
            params.add(categoryId);
        }
        sql.append(" ORDER BY a.end_time DESC");
        queryList(sql.toString(), params, list);
        return list;
    }

    public List<Auction> findActiveFeatured(int limit) {
        List<Auction> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(BASE + "WHERE a.status='ACTIVE' ORDER BY a.end_time ASC LIMIT ?")) {
            ps.setInt(1, limit);
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

    public Auction findById(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(BASE + "WHERE a.auction_id=?")) {
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

    public boolean insert(Auction a) {
        String sql = "INSERT INTO auctions(product_id,start_time,end_time,current_price,deposit_percent,deposit_amount,status) VALUES(?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, a.getProductId());
            ps.setTimestamp(2, new Timestamp(a.getStartTime().getTime()));
            ps.setTimestamp(3, new Timestamp(a.getEndTime().getTime()));
            ps.setDouble(4, a.getCurrentPrice());
            ps.setDouble(5, a.getDepositPercent());
            ps.setDouble(6, a.getDepositAmount());
            ps.setString(7, a.getStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateCurrentPrice(int auctionId, double price) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE auctions SET current_price=? WHERE auction_id=?")) {
            ps.setDouble(1, price);
            ps.setInt(2, auctionId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int auctionId, String status) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE auctions SET status=? WHERE auction_id=?")) {
            ps.setString(1, status);
            ps.setInt(2, auctionId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean setWinner(int auctionId, int winnerId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE auctions SET winner_id=?, status='ENDED' WHERE auction_id=?")) {
            ps.setInt(1, winnerId);
            ps.setInt(2, auctionId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countByStatus(String status) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM auctions WHERE status=?")) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countAll() {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM auctions");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private void queryList(String sql, List<Object> params, List<Auction> list) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Auction mapRow(ResultSet rs) throws Exception {
        Auction a = new Auction();
        a.setAuctionId(rs.getInt("auction_id"));
        a.setProductId(rs.getInt("product_id"));
        a.setStartTime(rs.getTimestamp("start_time"));
        a.setEndTime(rs.getTimestamp("end_time"));
        a.setCurrentPrice(rs.getDouble("current_price"));
        a.setDepositPercent(rs.getDouble("deposit_percent"));
        a.setDepositAmount(rs.getDouble("deposit_amount"));
        int w = rs.getInt("winner_id");
        if (!rs.wasNull()) {
            a.setWinnerId(w);
        }
        a.setStatus(rs.getString("status"));
        a.setProductName(rs.getString("product_name"));
        a.setDescription(rs.getString("description"));
        a.setStartingPrice(rs.getDouble("starting_price"));
        a.setSellerId(rs.getInt("seller_id"));
        a.setSellerName(rs.getString("seller_name"));
        a.setCategoryName(rs.getString("category_name"));
        a.setPrimaryImage(rs.getString("primary_image"));
        a.setBidCount(rs.getInt("bid_count"));
        return a;
    }
}
