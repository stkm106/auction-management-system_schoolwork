package uef.edu.vn.service;

import uef.edu.vn.dao.AuctionDepositDAO;
import uef.edu.vn.dao.WalletDAO;
import uef.edu.vn.model.Auction;
import uef.edu.vn.model.AuctionDeposit;
import uef.edu.vn.model.Wallet;

import uef.edu.vn.utils.CurrencyUtils;

public class WalletService {

    private static final double PLATFORM_FEE_RATE = 0.05;
    /** Admin user (platform wallet) from schema seed data */
    private static final int PLATFORM_USER_ID = 1;

    private final WalletDAO walletDAO = new WalletDAO();
    private final AuctionDepositDAO depositDAO = new AuctionDepositDAO();

    public String topUp(int userId, double amount) {
        if (amount <= 0) {
            return "Số tiền không hợp lệ";
        }
        Wallet w = walletDAO.findByUserId(userId);
        if (w == null) {
            return "Không tìm thấy ví";
        }
        if (!walletDAO.creditBalance(w.getWalletId(), amount)) {
            return "Nạp tiền thất bại";
        }
        walletDAO.addTransaction(w.getWalletId(), amount, "TOP_UP", null, "Nạp tiền vào ví");
        return null;
    }

    public String lockDeposit(int userId, Auction auction) {
        if (auction == null) {
            return "Phiên đấu giá không hợp lệ";
        }
        if (!"ACTIVE".equals(auction.getStatus())) {
            return "Phiên đấu giá không còn hoạt động";
        }
        AuctionDeposit existing = depositDAO.findByAuctionAndUser(auction.getAuctionId(), userId);
        if (existing != null) {
            if ("LOCKED".equals(existing.getStatus())) {
                return null;
            }
            if ("REFUNDED".equals(existing.getStatus())) {
                return relockDeposit(userId, auction, existing);
            }
            return "Không thể tham gia lại phiên đấu giá này";
        }
        return createNewDeposit(userId, auction);
    }

    private String createNewDeposit(int userId, Auction auction) {
        double deposit = resolveDepositAmount(auction);
        Wallet w = walletDAO.findByUserId(userId);
        if (w == null || w.getBalance() < deposit) {
            return "Số dư không đủ. Cần " + CurrencyUtils.formatVnd(deposit)
                    + " tiền cọc (" + (int) auction.getDepositPercent() + "%)";
        }
        double newBalance = w.getBalance() - deposit;
        double newLocked = w.getLockedBalance() + deposit;
        if (!walletDAO.updateBalances(w.getWalletId(), newBalance, newLocked)) {
            return "Không thể khóa tiền cọc";
        }
        AuctionDeposit d = new AuctionDeposit();
        d.setAuctionId(auction.getAuctionId());
        d.setUserId(userId);
        d.setDepositAmount(deposit);
        d.setStatus("LOCKED");
        if (!depositDAO.insert(d)) {
            walletDAO.updateBalances(w.getWalletId(), w.getBalance(), w.getLockedBalance());
            return "Không thể ghi nhận tiền cọc";
        }
        walletDAO.addTransaction(w.getWalletId(), -deposit, "DEPOSIT_LOCK", auction.getAuctionId(),
                "Khóa cọc phiên đấu giá #" + auction.getAuctionId());
        return null;
    }

    private String relockDeposit(int userId, Auction auction, AuctionDeposit existing) {
        double deposit = existing.getDepositAmount();
        Wallet w = walletDAO.findByUserId(userId);
        if (w == null || w.getBalance() < deposit) {
            return "Số dư không đủ. Cần " + CurrencyUtils.formatVnd(deposit)
                    + " tiền cọc (" + (int) auction.getDepositPercent() + "%)";
        }
        double newBalance = w.getBalance() - deposit;
        double newLocked = w.getLockedBalance() + deposit;
        if (!walletDAO.updateBalances(w.getWalletId(), newBalance, newLocked)) {
            return "Không thể khóa tiền cọc";
        }
        if (!depositDAO.updateStatus(existing.getDepositId(), "LOCKED")) {
            walletDAO.updateBalances(w.getWalletId(), w.getBalance(), w.getLockedBalance());
            return "Không thể khóa lại tiền cọc";
        }
        walletDAO.addTransaction(w.getWalletId(), -deposit, "DEPOSIT_LOCK", auction.getAuctionId(),
                "Khóa lại cọc phiên đấu giá #" + auction.getAuctionId());
        return null;
    }

    private double resolveDepositAmount(Auction auction) {
        double deposit = auction.getDepositAmount();
        if (deposit <= 0) {
            deposit = auction.getStartingPrice() * auction.getDepositPercent() / 100.0;
        }
        return deposit;
    }

    public void refundDeposit(AuctionDeposit deposit) {
        if (!"LOCKED".equals(deposit.getStatus())) {
            return;
        }
        Wallet w = walletDAO.findByUserId(deposit.getUserId());
        if (w == null) {
            return;
        }
        walletDAO.updateBalances(w.getWalletId(),
                w.getBalance() + deposit.getDepositAmount(),
                w.getLockedBalance() - deposit.getDepositAmount());
        walletDAO.addTransaction(w.getWalletId(), deposit.getDepositAmount(), "DEPOSIT_REFUND",
                deposit.getAuctionId(), "Hoàn cọc - thua đấu giá");
        depositDAO.updateStatus(deposit.getDepositId(), "REFUNDED");
    }

    public void forfeitDeposit(AuctionDeposit deposit) {
        if (deposit == null || !"LOCKED".equals(deposit.getStatus())) {
            return;
        }
        Wallet w = walletDAO.findByUserId(deposit.getUserId());
        if (w == null) {
            return;
        }
        walletDAO.updateBalances(w.getWalletId(), w.getBalance(),
                w.getLockedBalance() - deposit.getDepositAmount());
        walletDAO.addTransaction(w.getWalletId(), -deposit.getDepositAmount(), "DEPOSIT_FORFEIT",
                deposit.getAuctionId(), "Mất cọc - không thanh toán");
        depositDAO.updateStatus(deposit.getDepositId(), "FORFEITED");
    }

    public String processWinnerPayment(int buyerId, int sellerId, int auctionId, double amount, double depositUsed) {
        Wallet buyerWallet = walletDAO.findByUserId(buyerId);
        Wallet sellerWallet = walletDAO.findByUserId(sellerId);
        Wallet platformWallet = walletDAO.findByUserId(PLATFORM_USER_ID);
        if (buyerWallet == null || sellerWallet == null || platformWallet == null) {
            return "Lỗi ví điện tử";
        }
        AuctionDeposit dep = depositDAO.findByAuctionAndUser(auctionId, buyerId);
        if (dep == null || !"LOCKED".equals(dep.getStatus())) {
            return "Tiền cọc không hợp lệ";
        }
        double remaining = amount - depositUsed;
        if (buyerWallet.getBalance() < remaining) {
            return "Số dư không đủ để hoàn tất thanh toán";
        }
        double platformFee = platformFee(amount);
        double sellerReceive = amount - platformFee;

        walletDAO.updateBalances(buyerWallet.getWalletId(),
                buyerWallet.getBalance() - remaining,
                buyerWallet.getLockedBalance() - depositUsed);
        walletDAO.updateBalances(sellerWallet.getWalletId(),
                sellerWallet.getBalance() + sellerReceive,
                sellerWallet.getLockedBalance());
        walletDAO.creditBalance(platformWallet.getWalletId(), platformFee);

        walletDAO.addTransaction(buyerWallet.getWalletId(), -remaining, "PAYMENT",
                auctionId, "Thanh toán phiên đấu giá #" + auctionId);
        walletDAO.addTransaction(sellerWallet.getWalletId(), sellerReceive, "SALE_INCOME",
                auctionId, "Thu nhập bán hàng #" + auctionId);
        walletDAO.addTransaction(platformWallet.getWalletId(), platformFee, "PLATFORM_FEE",
                auctionId, "Phí sàn phiên đấu giá #" + auctionId);

        depositDAO.updateStatus(dep.getDepositId(), "USED_FOR_PAYMENT");
        return null;
    }

    public static double platformFee(double amount) {
        return Math.round(amount * PLATFORM_FEE_RATE * 100) / 100.0;
    }

    public static double sellerReceive(double amount) {
        return amount - platformFee(amount);
    }
}
