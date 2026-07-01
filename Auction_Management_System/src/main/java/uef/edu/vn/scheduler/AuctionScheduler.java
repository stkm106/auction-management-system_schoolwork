package uef.edu.vn.scheduler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import uef.edu.vn.service.AuctionService;
import uef.edu.vn.service.PaymentService;

@Component
public class AuctionScheduler {

    @Autowired
    private AuctionService auctionService;

    @Autowired
    private PaymentService paymentService;

    @Scheduled(fixedRate = 30000)
    public void processAuctionLifecycle() {
        auctionService.processScheduledAuctions();
        paymentService.processOverduePayments();
    }
}
