package uef.edu.vn.model;

public class Wallet {

    private int walletId;
    private int userId;
    private double balance;
    private double lockedBalance;

    public int getWalletId() { return walletId; }
    public void setWalletId(int walletId) { this.walletId = walletId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public double getBalance() { return balance; }
    public void setBalance(double balance) { this.balance = balance; }
    public double getLockedBalance() { return lockedBalance; }
    public void setLockedBalance(double lockedBalance) { this.lockedBalance = lockedBalance; }
    public double getAvailableBalance() { return balance; }
}
