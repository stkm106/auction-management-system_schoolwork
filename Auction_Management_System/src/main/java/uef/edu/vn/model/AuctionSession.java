/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.model;

import java.math.BigDecimal;
import java.util.Date;

public class AuctionSession {

    private int auctionID;
    private int productID;
    private Date startTime;
    private Date endTime;
    private BigDecimal currentPrice;
    private Integer winnerID;
    private String status;

    // getter setter

    public int getAuctionID() {
        return auctionID;
    }

    public void setAuctionID(int auctionID) {
        this.auctionID = auctionID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public BigDecimal getCurrentPrice() {
        return currentPrice;
    }

    public void setCurrentPrice(BigDecimal currentPrice) {
        this.currentPrice = currentPrice;
    }

    public Integer getWinnerID() {
        return winnerID;
    }

    public void setWinnerID(Integer winnerID) {
        this.winnerID = winnerID;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getEffectiveStatus() {
        if ("Closed".equalsIgnoreCase(status) || "Cancelled".equalsIgnoreCase(status)) {
            return status;
        }
        Date now = new Date();
        if (endTime != null && !now.before(endTime)) {
            return "Closed";
        }
        if (startTime != null && endTime != null && !now.before(startTime) && now.before(endTime)) {
            return "Open";
        }
        if (startTime != null && now.before(startTime)) {
            return "Upcoming";
        }
        return status != null ? status : "Upcoming";
    }
}