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
import uef.edu.vn.model.Wallet;

@Repository
public class WalletRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public Wallet findById(int walletID) {
        String sql = "SELECT * " + "FROM Wallets " + "WHERE WalletID = ?";
        List<Wallet> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Wallet.class), walletID);
        return list.isEmpty() ? null : list.get(0);
    }

    public Wallet findByUserId(int userID) {
        String sql = "SELECT * " + "FROM Wallets " + "WHERE UserID = ?";
        List<Wallet> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Wallet.class), userID);
        return list.isEmpty() ? null : list.get(0);
    }

    public int save(Wallet wallet) {
        String sql = "INSERT INTO Wallets " + "(UserID, Balance) " + "VALUES (?, ?)";
        return jdbcTemplate.update(sql, wallet.getUserID(), wallet.getBalance());
    }

    public int updateBalance(int walletID, BigDecimal balance) {
        String sql = "UPDATE Wallets SET " + "Balance = ? " + "WHERE WalletID = ?";
        return jdbcTemplate.update(sql, balance, walletID);
    }

    public int delete(int walletID) {
        String sql = "DELETE FROM Wallets " + "WHERE WalletID = ?";
        return jdbcTemplate.update(sql, walletID);
    }
}
