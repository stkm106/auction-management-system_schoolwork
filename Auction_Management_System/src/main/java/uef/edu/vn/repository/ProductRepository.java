/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.repository;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import uef.edu.vn.model.Product;

@Repository
public class ProductRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Product> findAll() {
        String sql = "SELECT * " + "FROM Products " + "ORDER BY ProductID";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Product.class));
    }

    public Product findById(int productID) {
        String sql = "SELECT * " + "FROM Products " + "WHERE ProductID = ?";
        List<Product> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Product.class), productID);
        return list.isEmpty() ? null : list.get(0);
    }

    public List<Product> findByOwnerId(int ownerID) {
        String sql = "SELECT * " + "FROM Products " + "WHERE OwnerID = ? " + "ORDER BY ProductID";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Product.class), ownerID);
    }

    public List<Product> findApprovedWithoutAuction() {
        String sql = "SELECT p.* FROM Products p "
                + "WHERE p.Status = 'Approved' "
                + "AND NOT EXISTS (SELECT 1 FROM AuctionSessions a WHERE a.ProductID = p.ProductID) "
                + "ORDER BY p.ProductID";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Product.class));
    }

    public int save(Product product) {
        String sql = "INSERT INTO Products "
                + "(ProductName, Description, StartingPrice, ImageURL, Status, OwnerID, CategoryID) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql, product.getProductName(), product.getDescription(),
                product.getStartingPrice(), product.getImageURL(), product.getStatus(),
                product.getOwnerID(), product.getCategoryID());
    }

    public int update(Product product) {
        String sql = "UPDATE Products SET " + "ProductName = ?, Description = ?, StartingPrice = ?, ImageURL = ?, Status = ?, CategoryID = ? " + "WHERE ProductID = ?";
        return jdbcTemplate.update(sql, product.getProductName(), product.getDescription(), product.getStartingPrice(), product.getImageURL(), product.getStatus(), product.getCategoryID(), product.getProductID());
    }

    public int updateStatus(int productID, String status) {
        String sql = "UPDATE Products SET " + "Status = ? " + "WHERE ProductID = ?";
        return jdbcTemplate.update(sql, status, productID);
    }

    public int delete(int productID) {
        String sql = "DELETE FROM Products " + "WHERE ProductID = ?";
        return jdbcTemplate.update(sql, productID);
    }

    public List<Product> search(String keyword) {
        String sql = "SELECT * FROM Products "
                + "WHERE CAST(ProductID AS CHAR) LIKE ? OR ProductName LIKE ? "
                + "ORDER BY ProductID";
        String key = "%" + keyword + "%";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Product.class), key, key);
    }
}
