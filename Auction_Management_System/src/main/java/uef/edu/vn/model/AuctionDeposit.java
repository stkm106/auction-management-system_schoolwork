package uef.edu.vn.model;

import java.math.BigDecimal;
import java.util.Date;

public class AuctionDeposit {

    private int depositID;
    private int auctionID;
    private int userID;
    private BigDecimal amount;
    private String status;
    private Date createdAt;

    public int getDepositID() {
        return depositID;
    }

    public void setDepositID(int depositID) {
        this.depositID = depositID;
    }

    public int getAuctionID() {
        return auctionID;
    }

    public void setAuctionID(int auctionID) {
        this.auctionID = auctionID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}
