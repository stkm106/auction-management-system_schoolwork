package uef.edu.vn.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class DashboardService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public int countUsers() {
        Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM Users", Integer.class);
        return count != null ? count : 0;
    }

    public int countProducts() {
        Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM Products", Integer.class);
        return count != null ? count : 0;
    }

    public int countOpenAuctions() {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM AuctionSessions WHERE Status = 'Open'", Integer.class);
        return count != null ? count : 0;
    }

    public BigDecimal monthlyRevenue() {
        BigDecimal total = jdbcTemplate.queryForObject(
                "SELECT COALESCE(SUM(CommissionAmount), 0) FROM Payments "
                        + "WHERE Status = 'Paid' AND FundsReleased = 1 "
                        + "AND MONTH(PaymentDate) = MONTH(CURRENT_DATE()) "
                        + "AND YEAR(PaymentDate) = YEAR(CURRENT_DATE())",
                BigDecimal.class);
        return total != null ? total : BigDecimal.ZERO;
    }

    public List<Map<String, Object>> revenueLast7Days() {
        return jdbcTemplate.queryForList(
                "SELECT DATE(PaymentDate) AS day, COALESCE(SUM(CommissionAmount), 0) AS total "
                        + "FROM Payments WHERE Status = 'Paid' AND FundsReleased = 1 "
                        + "AND PaymentDate >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 DAY) "
                        + "GROUP BY DATE(PaymentDate) ORDER BY day");
    }

    public List<Map<String, Object>> topProducts() {
        return jdbcTemplate.queryForList(
                "SELECT p.ProductName AS name, COUNT(a.AuctionID) AS sessions "
                        + "FROM Products p "
                        + "LEFT JOIN AuctionSessions a ON p.ProductID = a.ProductID "
                        + "GROUP BY p.ProductID, p.ProductName "
                        + "ORDER BY sessions DESC LIMIT 5");
    }

    public List<Map<String, Object>> categoryStats() {
        return jdbcTemplate.queryForList(
                "SELECT c.CategoryName AS name, COUNT(p.ProductID) AS count "
                        + "FROM Categories c "
                        + "LEFT JOIN Products p ON c.CategoryID = p.CategoryID "
                        + "GROUP BY c.CategoryID, c.CategoryName "
                        + "ORDER BY count DESC");
    }

    public List<Map<String, Object>> recentActivity() {
        List<Map<String, Object>> activities = new ArrayList<>();

        activities.addAll(jdbcTemplate.queryForList(
                "SELECT CONCAT(u.FullName, ' thắng phiên đấu giá #', a.AuctionID) AS content, "
                        + "a.EndTime AS activityTime "
                        + "FROM AuctionSessions a "
                        + "JOIN Users u ON a.WinnerID = u.UserID "
                        + "WHERE a.WinnerID IS NOT NULL "
                        + "ORDER BY a.EndTime DESC LIMIT 3"));

        activities.addAll(jdbcTemplate.queryForList(
                "SELECT CONCAT(u.FullName, ' nạp tiền ', FORMAT(wt.Amount, 0), ' VND') AS content, "
                        + "wt.TransactionDate AS activityTime "
                        + "FROM WalletTransactions wt "
                        + "JOIN Wallets w ON wt.WalletID = w.WalletID "
                        + "JOIN Users u ON w.UserID = u.UserID "
                        + "WHERE wt.TransactionType = 'Deposit' "
                        + "ORDER BY wt.TransactionDate DESC LIMIT 3"));

        activities.addAll(jdbcTemplate.queryForList(
                "SELECT CONCAT(u.FullName, ' đặt giá ', FORMAT(b.BidAmount, 0), ' VND') AS content, "
                        + "b.BidTime AS activityTime "
                        + "FROM Bids b "
                        + "JOIN Users u ON b.UserID = u.UserID "
                        + "ORDER BY b.BidTime DESC LIMIT 3"));

        activities.sort((a, b) -> {
            Object timeA = a.get("activityTime");
            Object timeB = b.get("activityTime");
            if (timeA == null || timeB == null) {
                return 0;
            }
            return ((Comparable) timeB).compareTo(timeA);
        });

        return activities.size() > 8 ? activities.subList(0, 8) : activities;
    }

    public Map<Integer, String> buildUserNameMap() {
        Map<Integer, String> map = new HashMap<>();
        jdbcTemplate.query("SELECT UserID, FullName FROM Users", rs -> {
            map.put(rs.getInt("UserID"), rs.getString("FullName"));
        });
        return map;
    }

    public Map<Integer, String> buildUsernameMap() {
        Map<Integer, String> map = new HashMap<>();
        jdbcTemplate.query("SELECT UserID, Username FROM Users", rs -> {
            map.put(rs.getInt("UserID"), rs.getString("Username"));
        });
        return map;
    }

    public Map<Integer, String> buildCategoryNameMap() {
        Map<Integer, String> map = new HashMap<>();
        jdbcTemplate.query("SELECT CategoryID, CategoryName FROM Categories", rs -> {
            map.put(rs.getInt("CategoryID"), rs.getString("CategoryName"));
        });
        return map;
    }

    public Map<Integer, String> buildProductNameMap() {
        Map<Integer, String> map = new HashMap<>();
        jdbcTemplate.query("SELECT ProductID, ProductName FROM Products", rs -> {
            map.put(rs.getInt("ProductID"), rs.getString("ProductName"));
        });
        return map;
    }
}
