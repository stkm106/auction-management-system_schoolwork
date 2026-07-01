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
import uef.edu.vn.model.Notification;

@Repository
public class NotificationRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Notification> findByUserId(int userID) {
        String sql = "SELECT * " + "FROM Notifications " + "WHERE UserID = ? " + "ORDER BY CreatedAt DESC";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Notification.class), userID);
    }

    public int save(Notification notification) {
        String sql = "INSERT INTO Notifications " + "(UserID, Content, Status) " + "VALUES (?, ?, ?)";
        return jdbcTemplate.update(sql, notification.getUserID(), notification.getContent(), notification.getStatus());
    }

    public int markAsRead(int notificationID) {
        String sql = "UPDATE Notifications SET " + "Status = 'Read' " + "WHERE NotificationID = ?";
        return jdbcTemplate.update(sql, notificationID);
    }

    public int delete(int notificationID) {
        String sql = "DELETE FROM Notifications " + "WHERE NotificationID = ?";
        return jdbcTemplate.update(sql, notificationID);
    }
}
