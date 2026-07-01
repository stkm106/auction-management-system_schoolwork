/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.repository;

import java.math.BigDecimal;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import uef.edu.vn.model.AuctionSession;

@Repository
public class AuctionSessionRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public AuctionSession findByProductId(int productID) {
        String sql = "SELECT * FROM AuctionSessions WHERE ProductID = ?";
        List<AuctionSession> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(AuctionSession.class), productID);
        return list.isEmpty() ? null : list.get(0);
    }

    public List<AuctionSession> findAll() {
        String sql = "SELECT * " + "FROM AuctionSessions " + "ORDER BY AuctionID";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(AuctionSession.class));
    }

    public AuctionSession findById(int auctionID) {
        String sql = "SELECT * " + "FROM AuctionSessions " + "WHERE AuctionID = ?";
        List<AuctionSession> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(AuctionSession.class), auctionID);
        return list.isEmpty() ? null : list.get(0);
    }

    public List<AuctionSession> findByStatus(String status) {
        String sql = "SELECT * " + "FROM AuctionSessions " + "WHERE Status = ? " + "ORDER BY AuctionID";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(AuctionSession.class), status);
    }

    public List<AuctionSession> findUpcomingReadyToStart() {
        String sql = "SELECT * FROM AuctionSessions "
                + "WHERE Status = 'Upcoming' AND StartTime <= NOW() AND EndTime > NOW() "
                + "ORDER BY AuctionID";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(AuctionSession.class));
    }

    public List<AuctionSession> findUpcomingPastEndTime() {
        String sql = "SELECT * FROM AuctionSessions "
                + "WHERE Status = 'Upcoming' AND EndTime <= NOW() "
                + "ORDER BY AuctionID";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(AuctionSession.class));
    }

    public List<AuctionSession> findOpenPastEndTime() {
        String sql = "SELECT * FROM AuctionSessions "
                + "WHERE Status = 'Open' AND EndTime <= NOW() "
                + "ORDER BY AuctionID";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(AuctionSession.class));
    }

    public int save(AuctionSession auction) {
        String sql = "INSERT INTO AuctionSessions " + "(ProductID, StartTime, EndTime, CurrentPrice, WinnerID, Status) " + "VALUES (?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql, auction.getProductID(), auction.getStartTime(), auction.getEndTime(), auction.getCurrentPrice(), auction.getWinnerID(), auction.getStatus());
    }

    public int update(AuctionSession auction) {
        String sql = "UPDATE AuctionSessions SET " + "StartTime = ?, EndTime = ?, CurrentPrice = ?, WinnerID = ?, Status = ? " + "WHERE AuctionID = ?";
        return jdbcTemplate.update(sql, auction.getStartTime(), auction.getEndTime(), auction.getCurrentPrice(), auction.getWinnerID(), auction.getStatus(), auction.getAuctionID());
    }

    public int updateCurrentPrice(int auctionID, BigDecimal currentPrice) {
        String sql = "UPDATE AuctionSessions SET " + "CurrentPrice = ? " + "WHERE AuctionID = ?";
        return jdbcTemplate.update(sql, currentPrice, auctionID);
    }

    public int updateWinner(int auctionID, int winnerID) {
        String sql = "UPDATE AuctionSessions SET " + "WinnerID = ?, Status = 'Closed' " + "WHERE AuctionID = ?";
        return jdbcTemplate.update(sql, winnerID, auctionID);
    }
    
    public int updateStatus(int auctionID, String status) {

    String sql = "UPDATE AuctionSessions SET "
            + "Status = ? "
            + "WHERE AuctionID = ?";

    return jdbcTemplate.update(sql, status, auctionID);
}

    public int delete(int auctionID) {
        String sql = "DELETE FROM AuctionSessions " + "WHERE AuctionID = ?";
        return jdbcTemplate.update(sql, auctionID);
    }
}
