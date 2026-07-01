/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.Wallet;
import uef.edu.vn.model.WalletTransaction;
import uef.edu.vn.repository.WalletRepository;
import uef.edu.vn.repository.WalletTransactionRepository;

@Service
public class WalletService {

    @Autowired
    private WalletRepository walletRepository;

    @Autowired
    private WalletTransactionRepository transactionRepository;

    public Wallet findByUserId(int userID) {
        return walletRepository.findByUserId(userID);
    }

    public Wallet ensureWallet(int userID) {
        Wallet wallet = walletRepository.findByUserId(userID);
        if (wallet != null) {
            return wallet;
        }
        Wallet newWallet = new Wallet();
        newWallet.setUserID(userID);
        newWallet.setBalance(BigDecimal.ZERO);
        walletRepository.save(newWallet);
        return walletRepository.findByUserId(userID);
    }

    private BigDecimal currentBalance(Wallet wallet) {
        return wallet.getBalance() != null ? wallet.getBalance() : BigDecimal.ZERO;
    }

    public List<WalletTransaction> findTransactionsByWalletId(int walletID) {
        return transactionRepository.findByWalletId(walletID);
    }

    public List<WalletTransaction> findPersonalTransactionsByWalletId(int walletID) {
        return findTransactionsByWalletId(walletID).stream()
                .filter(tx -> tx.getTransactionType() == null
                        || !"Commission".equalsIgnoreCase(tx.getTransactionType()))
                .collect(Collectors.toList());
    }

    public int countMonthlyTransactions(int userID) {
        Wallet wallet = walletRepository.findByUserId(userID);
        if (wallet == null) {
            return 0;
        }
        return transactionRepository.countCurrentMonthAuctionActivityByWalletId(wallet.getWalletID());
    }

    public boolean hasSufficientBalance(int userID, BigDecimal amount) {
        Wallet wallet = walletRepository.findByUserId(userID);
        return wallet != null && wallet.getBalance() != null
                && wallet.getBalance().compareTo(amount) >= 0;
    }

    public boolean hasBalanceAbove(int userID, BigDecimal amount) {
        Wallet wallet = walletRepository.findByUserId(userID);
        return wallet != null && wallet.getBalance() != null
                && wallet.getBalance().compareTo(amount) > 0;
    }

    public boolean deposit(int userID, BigDecimal amount) {
        Wallet wallet = ensureWallet(userID);
        if (wallet == null) {
            throw new ValidationException("Không tìm thấy ví của người dùng.");
        }

        BigDecimal newBalance = currentBalance(wallet).add(amount);
        walletRepository.updateBalance(wallet.getWalletID(), newBalance);
        saveTransaction(wallet.getWalletID(), amount, "Deposit");
        return true;
    }

    public void deduct(int userID, BigDecimal amount, String transactionType) {
        Wallet wallet = requireWallet(userID);
        BigDecimal balance = currentBalance(wallet);
        if (balance.compareTo(amount) < 0) {
            throw new ValidationException("Số dư ví không đủ.");
        }
        walletRepository.updateBalance(wallet.getWalletID(), balance.subtract(amount));
        saveTransaction(wallet.getWalletID(), amount, transactionType);
    }

    public void credit(int userID, BigDecimal amount, String transactionType) {
        Wallet wallet = ensureWallet(userID);
        if (wallet == null) {
            throw new ValidationException("Không thể cộng tiền vào ví người dùng.");
        }
        walletRepository.updateBalance(wallet.getWalletID(), currentBalance(wallet).add(amount));
        saveTransaction(wallet.getWalletID(), amount, transactionType);
    }

    private Wallet requireWallet(int userID) {
        Wallet wallet = ensureWallet(userID);
        if (wallet == null) {
            throw new ValidationException("Không tìm thấy ví của người dùng.");
        }
        return wallet;
    }

    private void saveTransaction(int walletID, BigDecimal amount, String transactionType) {
        WalletTransaction transaction = new WalletTransaction();
        transaction.setWalletID(walletID);
        transaction.setAmount(amount);
        transaction.setTransactionType(transactionType);
        transactionRepository.save(transaction);
    }
}
