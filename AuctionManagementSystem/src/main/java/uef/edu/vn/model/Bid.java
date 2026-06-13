package uef.edu.vn.model;

import java.util.Date;

public class Bid {

    private int bidId;
    private int auctionId;
    private int bidderId;
    private double bidAmount;
    private Date bidTime;
    private String bidderName;
    private String productName;

    public int getBidId() { return bidId; }
    public void setBidId(int bidId) { this.bidId = bidId; }
    public int getAuctionId() { return auctionId; }
    public void setAuctionId(int auctionId) { this.auctionId = auctionId; }
    public int getBidderId() { return bidderId; }
    public void setBidderId(int bidderId) { this.bidderId = bidderId; }
    public double getBidAmount() { return bidAmount; }
    public void setBidAmount(double bidAmount) { this.bidAmount = bidAmount; }
    public Date getBidTime() { return bidTime; }
    public void setBidTime(Date bidTime) { this.bidTime = bidTime; }
    public String getBidderName() { return bidderName; }
    public void setBidderName(String bidderName) { this.bidderName = bidderName; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
}
