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
import uef.edu.vn.model.WalletTransaction;

@Repository
public class WalletTransactionRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<WalletTransaction> findByWalletId(int walletID) {
        String sql = "SELECT * " + "FROM WalletTransactions " + "WHERE WalletID = ? " + "ORDER BY TransactionDate DESC";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(WalletTransaction.class), walletID);
    }

    public int countCurrentMonthByWalletId(int walletID) {
        String sql = "SELECT COUNT(*) FROM WalletTransactions "
                + "WHERE WalletID = ? "
                + "AND MONTH(TransactionDate) = MONTH(CURRENT_DATE()) "
                + "AND YEAR(TransactionDate) = YEAR(CURRENT_DATE())";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, walletID);
        return count != null ? count : 0;
    }

    public int countCurrentMonthAuctionActivityByWalletId(int walletID) {
        String sql = "SELECT COUNT(*) FROM WalletTransactions "
                + "WHERE WalletID = ? "
                + "AND TransactionType <> 'Deposit' "
                + "AND MONTH(TransactionDate) = MONTH(CURRENT_DATE()) "
                + "AND YEAR(TransactionDate) = YEAR(CURRENT_DATE())";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, walletID);
        return count != null ? count : 0;
    }

    public int save(WalletTransaction transaction) {
        String sql = "INSERT INTO WalletTransactions "
                + "(WalletID, Amount, TransactionType, TransactionDate) "
                + "VALUES (?, ?, ?, NOW())";
        return jdbcTemplate.update(sql, transaction.getWalletID(), transaction.getAmount(),
                transaction.getTransactionType());
    }

    public int delete(int transactionID) {
        String sql = "DELETE FROM WalletTransactions " + "WHERE TransactionID = ?";
        return jdbcTemplate.update(sql, transactionID);
    }
}
