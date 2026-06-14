package uef.edu.vn.model;

import java.util.Date;

public class Payment {

    private int paymentId;
    private int auctionId;
    private int buyerId;
    private int sellerId;
    private double amount;
    private double depositUsed;
    private double platformFee;
    private double sellerReceive;
    private Date paymentDate;
    private String status;
    private String productName;
    private String buyerName;
    private String sellerName;

    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }
    public int getAuctionId() { return auctionId; }
    public void setAuctionId(int auctionId) { this.auctionId = auctionId; }
    public int getBuyerId() { return buyerId; }
    public void setBuyerId(int buyerId) { this.buyerId = buyerId; }
    public int getSellerId() { return sellerId; }
    public void setSellerId(int sellerId) { this.sellerId = sellerId; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public double getDepositUsed() { return depositUsed; }
    public void setDepositUsed(double depositUsed) { this.depositUsed = depositUsed; }
    public double getPlatformFee() { return platformFee; }
    public void setPlatformFee(double platformFee) { this.platformFee = platformFee; }
    public double getSellerReceive() { return sellerReceive; }
    public void setSellerReceive(double sellerReceive) { this.sellerReceive = sellerReceive; }
    public Date getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Date paymentDate) { this.paymentDate = paymentDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getBuyerName() { return buyerName; }
    public void setBuyerName(String buyerName) { this.buyerName = buyerName; }
    public String getSellerName() { return sellerName; }
    public void setSellerName(String sellerName) { this.sellerName = sellerName; }
}
