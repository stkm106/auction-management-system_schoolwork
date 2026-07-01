/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.repository;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import uef.edu.vn.model.Bid;

@Repository
public class BidRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Bid> findAll() {
        String sql = "SELECT * " + "FROM Bids " + "ORDER BY BidTime DESC";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Bid.class));
    }

    public Bid findById(int bidID) {
        String sql = "SELECT * " + "FROM Bids " + "WHERE BidID = ?";
        List<Bid> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Bid.class), bidID);
        return list.isEmpty() ? null : list.get(0);
    }

    public List<Bid> findByAuctionId(int auctionID) {
        String sql = "SELECT * " + "FROM Bids " + "WHERE AuctionID = ? " + "ORDER BY BidAmount DESC, BidTime ASC";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Bid.class), auctionID);
    }

    public List<Bid> findByUserId(int userID) {
        String sql = "SELECT * " + "FROM Bids " + "WHERE UserID = ? " + "ORDER BY BidTime DESC";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Bid.class), userID);
    }

    public Bid findHighestBid(int auctionID) {
        String sql = "SELECT * " + "FROM Bids " + "WHERE AuctionID = ? " + "ORDER BY BidAmount DESC, BidTime ASC " + "LIMIT 1";
        List<Bid> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Bid.class), auctionID);
        return list.isEmpty() ? null : list.get(0);
    }

    public Bid findHighestBidExcludingUser(int auctionID, int excludeUserID) {
        String sql = "SELECT * FROM Bids WHERE AuctionID = ? AND UserID != ? "
                + "ORDER BY BidAmount DESC, BidTime ASC LIMIT 1";
        List<Bid> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Bid.class), auctionID, excludeUserID);
        return list.isEmpty() ? null : list.get(0);
    }

    public int save(Bid bid) {
        String sql = "INSERT INTO Bids " + "(AuctionID, UserID, BidAmount) " + "VALUES (?, ?, ?)";
        return jdbcTemplate.update(sql, bid.getAuctionID(), bid.getUserID(), bid.getBidAmount());
    }

    public int delete(int bidID) {
        String sql = "DELETE FROM Bids " + "WHERE BidID = ?";
        return jdbcTemplate.update(sql, bidID);
    }
}
