package uef.edu.vn.service;

import java.util.Date;

import uef.edu.vn.dao.AuctionDAO;
import uef.edu.vn.dao.AuctionDepositDAO;
import uef.edu.vn.dao.BidDAO;
import uef.edu.vn.dao.PaymentDAO;
import uef.edu.vn.dao.ProductDAO;
import uef.edu.vn.model.Auction;
import uef.edu.vn.model.AuctionDeposit;
import uef.edu.vn.model.Bid;
import uef.edu.vn.model.Payment;

import uef.edu.vn.utils.CurrencyUtils;

public class AuctionService {

    private final AuctionDAO auctionDAO = new AuctionDAO();
    private final BidDAO bidDAO = new BidDAO();
    private final ProductDAO productDAO = new ProductDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final AuctionDepositDAO depositDAO = new AuctionDepositDAO();
    private final WalletService walletService = new WalletService();

    public String placeBid(int auctionId, int bidderId, double bidAmount) {
        Auction auction = auctionDAO.findById(auctionId);
        if (auction == null) {
            return "Không tìm thấy phiên đấu giá";
        }
        if (!"ACTIVE".equals(auction.getStatus())) {
            return "Phiên đấu giá không còn hoạt động";
        }
        String timeErr = validateAuctionTime(auction);
        if (timeErr != null) {
            return timeErr;
        }
        if (auction.getSellerId() == bidderId) {
            return "Bạn không thể đặt giá sản phẩm của chính mình";
        }
        double minBid = Math.max(auction.getCurrentPrice(), auction.getStartingPrice()) + 1000;
        if (bidAmount < minBid) {
            return "Giá tối thiểu: " + CurrencyUtils.formatVnd(minBid);
        }
        String depositErr = walletService.lockDeposit(bidderId, auction);
        if (depositErr != null) {
            return depositErr;
        }
        Bid bid = new Bid();
        bid.setAuctionId(auctionId);
        bid.setBidderId(bidderId);
        bid.setBidAmount(bidAmount);
        if (bidDAO.insert(bid)) {
            auctionDAO.updateCurrentPrice(auctionId, bidAmount);
            return null;
        }
        return "Đặt giá thất bại";
    }

    public void endAuction(int auctionId) {
        Auction auction = auctionDAO.findById(auctionId);
        if (auction == null || "ENDED".equals(auction.getStatus())) {
            return;
        }
        Bid highest = bidDAO.findHighestBid(auctionId);
        if (highest == null) {
            auctionDAO.updateStatus(auctionId, "ENDED");
            refundAllDeposits(auctionId, -1);
            productDAO.updateStatus(auction.getProductId(), "APPROVED");
            return;
        }
        auctionDAO.setWinner(auctionId, highest.getBidderId());
        refundAllDeposits(auctionId, highest.getBidderId());

        Payment payment = new Payment();
        payment.setAuctionId(auctionId);
        payment.setBuyerId(highest.getBidderId());
        payment.setSellerId(auction.getSellerId());
        payment.setAmount(highest.getBidAmount());
        AuctionDeposit winnerDep = depositDAO.findByAuctionAndUser(auctionId, highest.getBidderId());
        payment.setDepositUsed(winnerDep != null ? winnerDep.getDepositAmount() : 0);
        payment.setPlatformFee(WalletService.platformFee(highest.getBidAmount()));
        payment.setSellerReceive(WalletService.sellerReceive(highest.getBidAmount()));
        payment.setStatus("PENDING");
        paymentDAO.insert(payment);
    }

    private void refundAllDeposits(int auctionId, int winnerId) {
        for (AuctionDeposit d : depositDAO.findByAuction(auctionId)) {
            if ("LOCKED".equals(d.getStatus()) && d.getUserId() != winnerId) {
                walletService.refundDeposit(d);
            }
        }
    }

    public String payPending(int paymentId, int buyerId) {
        Payment p = paymentDAO.findById(paymentId);
        if (p == null || p.getBuyerId() != buyerId || !"PENDING".equals(p.getStatus())) {
            return "Thanh toán không hợp lệ";
        }
        String err = walletService.processWinnerPayment(buyerId, p.getSellerId(),
                p.getAuctionId(), p.getAmount(), p.getDepositUsed());
        if (err != null) {
            walletService.forfeitDeposit(depositDAO.findByAuctionAndUser(p.getAuctionId(), buyerId));
            paymentDAO.updateStatus(paymentId, "FAILED");
            return err;
        }
        if (!paymentDAO.markPaidIfPending(paymentId)) {
            return "Thanh toán đã được xử lý bởi yêu cầu khác";
        }
        Auction auction = auctionDAO.findById(p.getAuctionId());
        if (auction != null) {
            productDAO.updateStatus(auction.getProductId(), "SOLD");
        }
        return null;
    }

    private String validateAuctionTime(Auction auction) {
        Date now = new Date();
        if (auction.getStartTime() != null && now.before(auction.getStartTime())) {
            return "Phiên đấu giá chưa bắt đầu";
        }
        if (auction.getEndTime() != null && now.after(auction.getEndTime())) {
            return "Phiên đấu giá đã kết thúc";
        }
        return null;
    }
}
