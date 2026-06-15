package uef.edu.vn.service;

import java.io.ByteArrayOutputStream;
import java.util.List;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.lowagie.text.Document;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.Paragraph;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

import uef.edu.vn.model.Payment;
import uef.edu.vn.model.ReportStat;

import uef.edu.vn.utils.CurrencyUtils;

public class ExportService {

    public byte[] exportRevenueExcel(List<ReportStat> stats) throws Exception {
        try (Workbook wb = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = wb.createSheet("Revenue");
            Row header = sheet.createRow(0);
            header.createCell(0).setCellValue("Auction Item");
            header.createCell(1).setCellValue("Doanh thu (VND)");
            int rowNum = 1;
            for (ReportStat s : stats) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(s.getLabel());
                row.createCell(1).setCellValue(s.getValue());
            }
            sheet.autoSizeColumn(0);
            sheet.autoSizeColumn(1);
            wb.write(out);
            return out.toByteArray();
        }
    }

    public byte[] exportRevenuePdf(List<ReportStat> stats) throws Exception {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        Document doc = new Document();
        PdfWriter.getInstance(doc, out);
        doc.open();
        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16);
        doc.add(new Paragraph("Bao cao doanh thu (VND)", titleFont));
        doc.add(new Paragraph(" "));
        PdfPTable table = new PdfPTable(2);
        table.addCell("Auction Item");
        table.addCell("Doanh thu (VND)");
        for (ReportStat s : stats) {
            table.addCell(s.getLabel());
            table.addCell(CurrencyUtils.formatVnd(s.getValue()));
        }
        doc.add(table);
        doc.close();
        return out.toByteArray();
    }

    public byte[] exportPaymentsExcel(List<Payment> payments) throws Exception {
        try (Workbook wb = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = wb.createSheet("Payments");
            Row header = sheet.createRow(0);
            String[] cols = {"ID", "San pham", "Nguoi mua", "So tien (VND)", "Coc", "Phi san", "Trang thai", "Ngay"};
            for (int i = 0; i < cols.length; i++) {
                header.createCell(i).setCellValue(cols[i]);
            }
            int rowNum = 1;
            for (Payment p : payments) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(p.getPaymentId());
                row.createCell(1).setCellValue(p.getProductName());
                row.createCell(2).setCellValue(p.getBuyerName());
                row.createCell(3).setCellValue(p.getAmount());
                row.createCell(4).setCellValue(p.getDepositUsed());
                row.createCell(5).setCellValue(p.getPlatformFee());
                row.createCell(6).setCellValue(p.getStatus());
                row.createCell(7).setCellValue(p.getPaymentDate() != null ? p.getPaymentDate().toString() : "");
            }
            wb.write(out);
            return out.toByteArray();
        }
    }
}
