package uef.edu.vn.model;

import java.util.Date;

public class AuctionDeposit {

    private int depositId;
    private int auctionId;
    private int userId;
    private double depositAmount;
    private String status;
    private Date createdAt;
    private String productName;

    public int getDepositId() { return depositId; }
    public void setDepositId(int depositId) { this.depositId = depositId; }
    public int getAuctionId() { return auctionId; }
    public void setAuctionId(int auctionId) { this.auctionId = auctionId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public double getDepositAmount() { return depositAmount; }
    public void setDepositAmount(double depositAmount) { this.depositAmount = depositAmount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
}
