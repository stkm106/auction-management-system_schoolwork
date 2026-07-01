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
import uef.edu.vn.model.Role;

@Repository
public class RoleRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Role> findAll() {
        String sql = "SELECT * " + "FROM Roles " + "ORDER BY RoleID";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Role.class));
    }

    public Role findById(int roleID) {
        String sql = "SELECT * " + "FROM Roles " + "WHERE RoleID = ?";
        List<Role> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Role.class), roleID);
        return list.isEmpty() ? null : list.get(0);
    }

    public List<Role> findRolesByUserId(int userID) {
        String sql = "SELECT r.* " + "FROM Roles r " + "JOIN UserRoles ur " + "ON r.RoleID = ur.RoleID " + "WHERE ur.UserID = ?";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Role.class), userID);
    }

    public Role findByName(String roleName) {
        String sql = "SELECT * FROM Roles WHERE RoleName = ?";
        List<Role> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Role.class), roleName);
        return list.isEmpty() ? null : list.get(0);
    }

    public int addRoleToUser(int userID, int roleID) {
        String sql = "INSERT INTO UserRoles " + "(UserID, RoleID) " + "VALUES (?, ?)";
        return jdbcTemplate.update(sql, userID, roleID);
    }

    public int removeRolesByUserId(int userID) {
        String sql = "DELETE FROM UserRoles " + "WHERE UserID = ?";
        return jdbcTemplate.update(sql, userID);
    }
}
