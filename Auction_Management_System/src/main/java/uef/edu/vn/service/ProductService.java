/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.Product;
import uef.edu.vn.repository.ProductRepository;
import uef.edu.vn.util.ValidationUtils;

@Service
public class ProductService {

    @Autowired
    private ProductRepository productRepository;

    public List<Product> findAll() {
        return productRepository.findAll();
    }

    public Product findById(int productID) {
        return productRepository.findById(productID);
    }

    public boolean isOwner(int productID, int userID) {
        Product product = findById(productID);
        return product != null && product.getOwnerID() == userID;
    }

    public List<Product> findByOwnerId(int ownerID) {
        return productRepository.findByOwnerId(ownerID);
    }

    public List<Product> findApprovedWithoutAuction() {
        return productRepository.findApprovedWithoutAuction();
    }

    public List<Product> findApprovedWithoutAuction(String keyword) {
        List<Product> products = findApprovedWithoutAuction();
        if (keyword == null || keyword.isBlank()) {
            return products;
        }
        String key = keyword.trim().toLowerCase();
        return products.stream()
                .filter(p -> (p.getProductName() != null && p.getProductName().toLowerCase().contains(key))
                        || String.valueOf(p.getProductID()).contains(key.trim())
                        || (p.getDescription() != null && p.getDescription().toLowerCase().contains(key)))
                .collect(Collectors.toList());
    }

    public boolean save(Product product) {
        ValidationUtils.validateProduct(product, null, false);
        product.setStatus("Pending");
        return productRepository.save(product) > 0;
    }

    public boolean update(Product product) {
        ValidationUtils.validateProduct(product, null, false);
        return productRepository.update(product) > 0;
    }

    public boolean approve(int productID) {
        return productRepository.updateStatus(productID, "Approved") > 0;
    }

    public boolean updateStatus(int productID, String status) {
        return productRepository.updateStatus(productID, status) > 0;
    }

    public boolean reject(int productID) {
        return productRepository.updateStatus(productID, "Rejected") > 0;
    }

    public boolean delete(int productID) {
        return productRepository.delete(productID) > 0;
    }

    public List<Product> search(String keyword) {
        return productRepository.search(keyword);
    }
}