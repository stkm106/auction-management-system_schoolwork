/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.AuctionSession;
import uef.edu.vn.model.Bid;
import uef.edu.vn.model.Product;
import uef.edu.vn.repository.AuctionSessionRepository;
import uef.edu.vn.repository.BidRepository;
import uef.edu.vn.util.ValidationUtils;

@Service
public class BidService {

    @Autowired
    private BidRepository bidRepository;

    @Autowired
    private AuctionSessionRepository auctionRepository;

    @Autowired
    private AuctionDepositService auctionDepositService;

    @Autowired
    private ProductService productService;

    public List<Bid> findByAuctionId(int auctionID) {
        return bidRepository.findByAuctionId(auctionID);
    }

    public List<Bid> findByUserId(int userID) {
        return bidRepository.findByUserId(userID);
    }

    public void placeBid(Bid bid) {
        try {
            if (bid.getAuctionID() <= 0) {
                throw new ValidationException("Phiên đấu giá không hợp lệ.");
            }
            ValidationUtils.validatePositiveMoney(bid.getBidAmount(), "Giá trả");

            AuctionSession auction = auctionRepository.findById(bid.getAuctionID());
            if (auction == null) {
                throw new ValidationException("Phiên đấu giá không tồn tại.");
            }
            if (!"Open".equalsIgnoreCase(auction.getStatus()) && !"Open".equalsIgnoreCase(auction.getEffectiveStatus())) {
                throw new ValidationException("Phiên đấu giá chưa mở hoặc đã kết thúc.");
            }
            Product product = productService.findById(auction.getProductID());
            if (product != null && product.getOwnerID() == bid.getUserID()) {
                throw new ValidationException("Người bán không thể trả giá sản phẩm của chính mình.");
            }
            if (!auctionDepositService.hasJoined(bid.getAuctionID(), bid.getUserID())) {
                throw new ValidationException("Bạn cần đặt cọc và tham gia phiên đấu giá trước khi trả giá.");
            }
            auctionDepositService.validateBidderWalletBalance(bid.getUserID(), product);
            java.util.Date now = new java.util.Date();
            if (auction.getStartTime() != null && now.before(auction.getStartTime())) {
                throw new ValidationException("Phiên đấu giá chưa bắt đầu.");
            }
            if (auction.getEndTime() != null && !now.before(auction.getEndTime())) {
                throw new ValidationException("Phiên đấu giá đã kết thúc.");
            }
            if (bid.getBidAmount().compareTo(auction.getCurrentPrice()) <= 0) {
                throw new ValidationException("Giá trả phải cao hơn giá hiện tại.");
            }

            bidRepository.save(bid);
            auctionRepository.updateCurrentPrice(auction.getAuctionID(), bid.getBidAmount());
        } catch (ValidationException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new ValidationException("Không thể đặt giá. Vui lòng thử lại.");
        }
    }

    public Bid findHighestBid(int auctionID) {
        return bidRepository.findHighestBid(auctionID);
    }
}
