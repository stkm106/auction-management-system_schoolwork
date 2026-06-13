package uef.edu.vn.controller;

import java.util.List;

import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import uef.edu.vn.dao.PaymentDAO;
import uef.edu.vn.dao.ReportDAO;
import uef.edu.vn.model.Payment;
import uef.edu.vn.model.ReportStat;
import uef.edu.vn.service.ExportService;

@Controller
@RequestMapping("/admin/reports")
public class ReportController {

    private final ReportDAO reportDAO = new ReportDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final ExportService exportService = new ExportService();

    @GetMapping
    public String reports(Model model) {
        model.addAttribute("revenueStats", reportDAO.revenueByProduct());
        model.addAttribute("popularProducts", reportDAO.popularProducts());
        model.addAttribute("bidStats", reportDAO.bidsByMonth());
        return "admin/reports";
    }

    @GetMapping("/export/revenue")
    public ResponseEntity<byte[]> exportRevenue(@RequestParam(defaultValue = "excel") String format) throws Exception {
        List<ReportStat> stats = reportDAO.revenueByProduct();
        byte[] data;
        String filename;
        MediaType mediaType;
        if ("pdf".equalsIgnoreCase(format)) {
            data = exportService.exportRevenuePdf(stats);
            filename = "revenue-report.pdf";
            mediaType = MediaType.APPLICATION_PDF;
        } else {
            data = exportService.exportRevenueExcel(stats);
            filename = "revenue-report.xlsx";
            mediaType = MediaType.parseMediaType(
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        }
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + filename)
                .contentType(mediaType)
                .body(data);
    }

    @GetMapping("/export/payments")
    public ResponseEntity<byte[]> exportPayments() throws Exception {
        List<Payment> payments = paymentDAO.findAll(null);
        byte[] data = exportService.exportPaymentsExcel(payments);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=payments.xlsx")
                .contentType(MediaType.parseMediaType(
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
                .body(data);
    }
}
