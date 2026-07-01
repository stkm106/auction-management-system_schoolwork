/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import uef.edu.vn.model.Payment;
import uef.edu.vn.repository.PaymentRepository;

@Service
public class ReportService {

    @Autowired
    private PaymentRepository paymentRepository;

    public List<Payment> revenueReport() {
        return paymentRepository.findAll();
    }

}