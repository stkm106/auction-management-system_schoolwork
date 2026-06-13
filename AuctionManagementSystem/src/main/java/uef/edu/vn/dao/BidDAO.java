package uef.edu.vn.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import uef.edu.vn.model.Bid;
import uef.edu.vn.utils.DBConnection;

public class BidDAO {

    public boolean insert(Bid bid) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "INSERT INTO bids(auction_id,bidder_id,bid_amount) VALUES(?,?,?)")) {
            ps.setInt(1, bid.getAuctionId());
            ps.setInt(2, bid.getBidderId());
            ps.setDouble(3, bid.getBidAmount());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Bid findHighestBid(int auctionId) {
        String sql = "SELECT b.*, u.full_name AS bidder_name FROM bids b "
                + "JOIN users u ON b.bidder_id=u.user_id WHERE b.auction_id=? "
                + "ORDER BY b.bid_amount DESC, b.bid_time ASC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
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

    public List<Bid> findByAuction(int auctionId) {
        List<Bid> list = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name AS bidder_name FROM bids b "
                + "JOIN users u ON b.bidder_id=u.user_id WHERE b.auction_id=? ORDER BY b.bid_time DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
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

    public List<Bid> findByBidder(int bidderId) {
        List<Bid> list = new ArrayList<>();
        String sql = "SELECT b.*, p.name AS product_name FROM bids b "
                + "JOIN auctions a ON b.auction_id=a.auction_id "
                + "JOIN products p ON a.product_id=p.product_id "
                + "WHERE b.bidder_id=? ORDER BY b.bid_time DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bidderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Bid b = mapRow(rs);
                    b.setProductName(rs.getString("product_name"));
                    list.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countAll() {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM bids");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Bid> findAllRecent(int limit) {
        List<Bid> list = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name AS bidder_name, p.name AS product_name FROM bids b "
                + "JOIN users u ON b.bidder_id=u.user_id "
                + "JOIN auctions a ON b.auction_id=a.auction_id "
                + "JOIN products p ON a.product_id=p.product_id "
                + "ORDER BY b.bid_time DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Bid b = mapRow(rs);
                    b.setProductName(rs.getString("product_name"));
                    list.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private Bid mapRow(ResultSet rs) throws Exception {
        Bid b = new Bid();
        b.setBidId(rs.getInt("bid_id"));
        b.setAuctionId(rs.getInt("auction_id"));
        b.setBidderId(rs.getInt("bidder_id"));
        b.setBidAmount(rs.getDouble("bid_amount"));
        b.setBidTime(rs.getTimestamp("bid_time"));
        try {
            b.setBidderName(rs.getString("bidder_name"));
        } catch (Exception ignored) {
        }
        return b;
    }
}
