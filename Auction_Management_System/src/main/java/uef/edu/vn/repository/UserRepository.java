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
import uef.edu.vn.model.User;

@Repository
public class UserRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<User> findAll() {
        String sql = "SELECT * " + "FROM Users " + "ORDER BY UserID";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(User.class));
    }

    public User findById(int userID) {
        String sql = "SELECT * " + "FROM Users " + "WHERE UserID = ?";
        List<User> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(User.class), userID);
        return list.isEmpty() ? null : list.get(0);
    }

    public User findByUsername(String username) {
        String sql = "SELECT * " + "FROM Users " + "WHERE Username = ?";
        List<User> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(User.class), username);
        return list.isEmpty() ? null : list.get(0);
    }

    public User findByEmail(String email) {
        String sql = "SELECT * FROM Users WHERE LOWER(TRIM(Email)) = LOWER(TRIM(?))";
        List<User> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(User.class), email);
        return list.isEmpty() ? null : list.get(0);
    }

    public User findByPhone(String phone) {
        String sql = "SELECT * FROM Users WHERE Phone = ?";
        List<User> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(User.class), phone);
        return list.isEmpty() ? null : list.get(0);
    }

    public int save(User user) {
        String sql = "INSERT INTO Users " + "(Username, Password, FullName, Email, Phone, Address, Status) " + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql, user.getUsername(), user.getPassword(), user.getFullName(), user.getEmail(), user.getPhone(), user.getAddress(), user.getStatus());
    }

    public int update(User user) {
        String sql = "UPDATE Users SET " + "FullName = ?, Email = ?, Phone = ?, Address = ?, Status = ? " + "WHERE UserID = ?";
        return jdbcTemplate.update(sql, user.getFullName(), user.getEmail(), user.getPhone(), user.getAddress(), user.getStatus(), user.getUserID());
    }

    public int updatePassword(int userID, String password) {
        String sql = "UPDATE Users SET Password = ? WHERE UserID = ?";
        return jdbcTemplate.update(sql, password, userID);
    }

    public int delete(int userID) {
        String sql = "DELETE FROM Users " + "WHERE UserID = ?";
        return jdbcTemplate.update(sql, userID);
    }

    public List<User> search(String keyword) {
        String sql = "SELECT * " + "FROM Users " + "WHERE Username LIKE ? " + "OR FullName LIKE ? " + "OR Email LIKE ? " + "ORDER BY UserID";
        String key = "%" + keyword + "%";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(User.class), key, key, key);
    }
}
