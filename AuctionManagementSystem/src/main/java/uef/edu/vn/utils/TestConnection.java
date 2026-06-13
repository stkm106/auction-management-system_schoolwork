/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.utils;

import java.sql.Connection;

/**
 *
 * @author San
 */
public class TestConnection {

    public static void main(String[] args) {

        Connection conn
                = DBConnection.getConnection();

        if (conn != null) {

            System.out.println("SUCCESS!");
        } else {

            System.out.println("FAILED!");
        }
    }
}
