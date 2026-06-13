package uef.edu.vn.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import uef.edu.vn.model.ReportStat;
import uef.edu.vn.utils.DBConnection;

public class ReportDAO {

    public List<ReportStat> revenueByProduct() {
        List<ReportStat> list = new ArrayList<>();
        String sql = "SELECT p.name AS label, COALESCE(SUM(pay.platform_fee),0) AS value "
                + "FROM payments pay JOIN auctions a ON pay.auction_id=a.auction_id "
                + "JOIN products p ON a.product_id=p.product_id WHERE pay.status='PAID' "
                + "GROUP BY p.product_id, p.name ORDER BY value DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new ReportStat(rs.getString("label"), rs.getDouble("value")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ReportStat> popularProducts() {
        List<ReportStat> list = new ArrayList<>();
        String sql = "SELECT p.name AS label, COUNT(b.bid_id) AS cnt FROM bids b "
                + "JOIN auctions a ON b.auction_id=a.auction_id "
                + "JOIN products p ON a.product_id=p.product_id "
                + "GROUP BY p.product_id, p.name ORDER BY cnt DESC LIMIT 10";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new ReportStat(rs.getString("label"), rs.getLong("cnt")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ReportStat> bidsByMonth() {
        List<ReportStat> list = new ArrayList<>();
        String sql = "SELECT DATE_FORMAT(bid_time,'%Y-%m') AS label, COUNT(*) AS cnt FROM bids "
                + "GROUP BY DATE_FORMAT(bid_time,'%Y-%m') ORDER BY label";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new ReportStat(rs.getString("label"), rs.getLong("cnt")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
