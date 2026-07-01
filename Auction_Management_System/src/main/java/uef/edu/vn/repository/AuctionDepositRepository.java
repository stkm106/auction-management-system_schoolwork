package uef.edu.vn.repository;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import uef.edu.vn.model.AuctionDeposit;

@Repository
public class AuctionDepositRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public AuctionDeposit findByAuctionAndUser(int auctionID, int userID) {
        String sql = "SELECT * FROM AuctionDeposits WHERE AuctionID = ? AND UserID = ?";
        List<AuctionDeposit> list = jdbcTemplate.query(sql,
                new BeanPropertyRowMapper<>(AuctionDeposit.class), auctionID, userID);
        return list.isEmpty() ? null : list.get(0);
    }

    public List<AuctionDeposit> findByAuctionId(int auctionID) {
        String sql = "SELECT * FROM AuctionDeposits WHERE AuctionID = ? ORDER BY DepositID";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(AuctionDeposit.class), auctionID);
    }

    public int save(AuctionDeposit deposit) {
        String sql = "INSERT INTO AuctionDeposits (AuctionID, UserID, Amount, Status) VALUES (?, ?, ?, ?)";
        return jdbcTemplate.update(sql, deposit.getAuctionID(), deposit.getUserID(),
                deposit.getAmount(), deposit.getStatus());
    }

    public int updateStatus(int depositID, String status) {
        String sql = "UPDATE AuctionDeposits SET Status = ? WHERE DepositID = ?";
        return jdbcTemplate.update(sql, status, depositID);
    }
}
