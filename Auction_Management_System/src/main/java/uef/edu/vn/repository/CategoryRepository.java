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
import uef.edu.vn.model.Category;

@Repository
public class CategoryRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Category> findAll() {
        String sql = "SELECT * " + "FROM Categories " + "ORDER BY CategoryID";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Category.class));
    }

    public Category findById(int categoryID) {
        String sql = "SELECT * " + "FROM Categories " + "WHERE CategoryID = ?";
        List<Category> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Category.class), categoryID);
        return list.isEmpty() ? null : list.get(0);
    }

    public int save(Category category) {
        String sql = "INSERT INTO Categories " + "(CategoryName, Status) " + "VALUES (?, ?)";
        return jdbcTemplate.update(sql, category.getCategoryName(), category.getStatus());
    }

    public int update(Category category) {
        String sql = "UPDATE Categories SET " + "CategoryName = ?, Status = ? " + "WHERE CategoryID = ?";
        return jdbcTemplate.update(sql, category.getCategoryName(), category.getStatus(), category.getCategoryID());
    }

    public int delete(int categoryID) {
        String sql = "DELETE FROM Categories " + "WHERE CategoryID = ?";
        return jdbcTemplate.update(sql, categoryID);
    }
}
