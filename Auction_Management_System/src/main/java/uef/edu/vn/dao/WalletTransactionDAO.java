package uef.edu.vn.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import uef.edu.vn.model.WalletTransaction;
import uef.edu.vn.utils.DBConnection;

public class WalletTransactionDAO {

    public List<WalletTransaction> findByWallet(int walletId) {
        List<WalletTransaction> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT * FROM wallet_transactions WHERE wallet_id=? ORDER BY created_at DESC")) {
            ps.setInt(1, walletId);
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

    public List<WalletTransaction> findByUserId(int userId) {
        List<WalletTransaction> list = new ArrayList<>();
        String sql = "SELECT wt.* FROM wallet_transactions wt "
                + "JOIN wallets w ON wt.wallet_id=w.wallet_id WHERE w.user_id=? ORDER BY wt.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
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

    public List<WalletTransaction> findAllRecent(int limit) {
        List<WalletTransaction> list = new ArrayList<>();
        String sql = "SELECT wt.*, u.full_name AS user_name FROM wallet_transactions wt "
                + "JOIN wallets w ON wt.wallet_id=w.wallet_id "
                + "JOIN users u ON w.user_id=u.user_id "
                + "ORDER BY wt.created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    WalletTransaction t = mapRow(rs);
                    t.setDescription(t.getDescription() + " [" + rs.getString("user_name") + "]");
                    list.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private WalletTransaction mapRow(ResultSet rs) throws Exception {
        WalletTransaction t = new WalletTransaction();
        t.setTransactionId(rs.getInt("transaction_id"));
        t.setWalletId(rs.getInt("wallet_id"));
        t.setAmount(rs.getDouble("amount"));
        t.setTransactionType(rs.getString("transaction_type"));
        int ref = rs.getInt("reference_id");
        if (!rs.wasNull()) {
            t.setReferenceId(ref);
        }
        t.setDescription(rs.getString("description"));
        t.setCreatedAt(rs.getTimestamp("created_at"));
        return t;
    }
}
