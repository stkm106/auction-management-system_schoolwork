/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.controller;

import java.math.BigDecimal;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import uef.edu.vn.model.Payment;
import uef.edu.vn.service.ReportService;

@Controller
@RequestMapping("/reports")
public class ReportController {

    @Autowired
    private ReportService reportService;

    @GetMapping
    public String index(Model model) {
        List<Payment> revenues = reportService.revenueReport();
        BigDecimal totalRevenue = BigDecimal.ZERO;
        int paidCount = 0;
        int pendingCount = 0;

        for (Payment payment : revenues) {
            if ("Paid".equalsIgnoreCase(payment.getStatus()) && payment.getCommissionAmount() != null) {
                totalRevenue = totalRevenue.add(payment.getCommissionAmount());
            }
            if ("Paid".equalsIgnoreCase(payment.getStatus())) {
                paidCount++;
            } else {
                pendingCount++;
            }
        }

        model.addAttribute("revenues", revenues);
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("paidCount", paidCount);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("layout", "admin");
        model.addAttribute("activeMenu", "reports");
        model.addAttribute("body", "/WEB-INF/views/reports/index.jsp");
        return "shared/main";
    }
}
