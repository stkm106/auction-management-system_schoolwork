package uef.edu.vn.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import uef.edu.vn.model.Product;
import uef.edu.vn.utils.DBConnection;

public class ProductDAO {

    private static final String BASE = "SELECT p.*, u.full_name AS seller_name, c.name AS category_name, "
            + "(SELECT image_url FROM product_images pi WHERE pi.product_id=p.product_id LIMIT 1) AS primary_image "
            + "FROM products p "
            + "JOIN users u ON p.seller_id = u.user_id "
            + "LEFT JOIN categories c ON p.category_id = c.category_id ";

    public List<Product> findAll(String keyword, Integer categoryId, String status) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE + "WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND p.name LIKE ?");
            params.add("%" + keyword.trim() + "%");
        }
        if (categoryId != null && categoryId > 0) {
            sql.append(" AND p.category_id=?");
            params.add(categoryId);
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND p.status=?");
            params.add(status);
        }
        sql.append(" ORDER BY p.product_id DESC");
        queryList(sql.toString(), params, list);
        return list;
    }

    public List<Product> findBySeller(int sellerId) {
        List<Product> list = new ArrayList<>();
        queryList(BASE + "WHERE p.seller_id=? ORDER BY p.product_id DESC", List.of(sellerId), list);
        return list;
    }

    public Product findById(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(BASE + "WHERE p.product_id=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int insert(Product p, String imageUrl) {
        String sql = "INSERT INTO products(seller_id,category_id,name,description,starting_price,condition_status,status) VALUES(?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, p.getSellerId());
            ps.setInt(2, p.getCategoryId());
            ps.setString(3, p.getName());
            ps.setString(4, p.getDescription());
            ps.setDouble(5, p.getStartingPrice());
            ps.setString(6, p.getConditionStatus());
            ps.setString(7, p.getStatus());
            if (ps.executeUpdate() > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        int id = keys.getInt(1);
                        if (imageUrl != null && !imageUrl.isEmpty()) {
                            try (PreparedStatement img = conn.prepareStatement(
                                    "INSERT INTO product_images(product_id,image_url) VALUES(?,?)")) {
                                img.setInt(1, id);
                                img.setString(2, imageUrl);
                                img.executeUpdate();
                            }
                        }
                        return id;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean updateStatus(int productId, String status) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE products SET status=? WHERE product_id=?")) {
            ps.setString(1, status);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private void queryList(String sql, List<Object> params, List<Product> list) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Product mapRow(ResultSet rs) throws Exception {
        Product p = new Product();
        p.setProductId(rs.getInt("product_id"));
        p.setSellerId(rs.getInt("seller_id"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setStartingPrice(rs.getDouble("starting_price"));
        p.setConditionStatus(rs.getString("condition_status"));
        p.setStatus(rs.getString("status"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setSellerName(rs.getString("seller_name"));
        p.setCategoryName(rs.getString("category_name"));
        p.setPrimaryImage(rs.getString("primary_image"));
        return p;
    }
}
