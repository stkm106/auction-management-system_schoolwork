package uef.edu.vn.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import uef.edu.vn.model.Wallet;
import uef.edu.vn.utils.DBConnection;

public class WalletDAO {

    public Wallet findByUserId(int userId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM wallets WHERE user_id=?")) {
            ps.setInt(1, userId);
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

    public boolean updateBalances(int walletId, double balance, double lockedBalance) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "UPDATE wallets SET balance=?, locked_balance=? WHERE wallet_id=?")) {
            ps.setDouble(1, balance);
            ps.setDouble(2, lockedBalance);
            ps.setInt(3, walletId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean creditBalance(int walletId, double amount) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "UPDATE wallets SET balance = balance + ? WHERE wallet_id = ?")) {
            ps.setDouble(1, amount);
            ps.setInt(2, walletId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addTransaction(int walletId, double amount, String type, Integer refId, String desc) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "INSERT INTO wallet_transactions(wallet_id,amount,transaction_type,reference_id,description) VALUES(?,?,?,?,?)")) {
            ps.setInt(1, walletId);
            ps.setDouble(2, amount);
            ps.setString(3, type);
            if (refId != null) {
                ps.setInt(4, refId);
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            ps.setString(5, desc);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Wallet mapRow(ResultSet rs) throws Exception {
        Wallet w = new Wallet();
        w.setWalletId(rs.getInt("wallet_id"));
        w.setUserId(rs.getInt("user_id"));
        w.setBalance(rs.getDouble("balance"));
        w.setLockedBalance(rs.getDouble("locked_balance"));
        return w;
    }
}
