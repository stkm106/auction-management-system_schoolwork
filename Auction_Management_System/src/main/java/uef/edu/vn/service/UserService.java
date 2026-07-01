package uef.edu.vn.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.Role;
import uef.edu.vn.model.User;
import uef.edu.vn.model.Wallet;
import uef.edu.vn.repository.UserRepository;
import uef.edu.vn.repository.RoleRepository;
import uef.edu.vn.repository.WalletRepository;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private WalletRepository walletRepository;

    public List<User> findAll() {
        List<User> users = userRepository.findAll();
        attachRoles(users);
        return users;
    }

    public List<User> filterUsers(String keyword, Integer roleID, String status) {
        List<User> users = userRepository.findAll();
        attachRoles(users);

        if (keyword != null && !keyword.isBlank()) {
            String key = keyword.trim().toLowerCase();
            users = users.stream()
                    .filter(u -> matchesKeyword(u, key))
                    .collect(Collectors.toList());
        }
        if (status != null && !status.isBlank()) {
            users = users.stream()
                    .filter(u -> status.equalsIgnoreCase(u.getStatus()))
                    .collect(Collectors.toList());
        }
        if (roleID != null) {
            users = users.stream()
                    .filter(u -> u.getRoles() != null && u.getRoles().stream()
                            .anyMatch(r -> r.getRoleID() == roleID))
                    .collect(Collectors.toList());
        }
        return users;
    }

    private void attachRoles(List<User> users) {
        for (User user : users) {
            user.setRoles(roleRepository.findRolesByUserId(user.getUserID()));
        }
    }

    private boolean matchesKeyword(User user, String key) {
        if (user.getUsername() != null && user.getUsername().toLowerCase().contains(key)) {
            return true;
        }
        if (user.getFullName() != null && user.getFullName().toLowerCase().contains(key)) {
            return true;
        }
        if (user.getEmail() != null && user.getEmail().toLowerCase().contains(key)) {
            return true;
        }
        if (user.getPhone() != null && user.getPhone().contains(key)) {
            return true;
        }
        if (String.valueOf(user.getUserID()).contains(key)) {
            return true;
        }
        if (user.getRoles() != null) {
            for (Role role : user.getRoles()) {
                if (roleMatchesKeyword(role, key)) {
                    return true;
                }
            }
        }
        return false;
    }

    private boolean roleMatchesKeyword(Role role, String key) {
        if (role.getRoleName() != null && role.getRoleName().toLowerCase().contains(key)) {
            return true;
        }
        if ("ADMIN".equalsIgnoreCase(role.getRoleName())) {
            return "quản trị viên".contains(key) || "quan tri vien".contains(key);
        }
        if ("CUSTOMER".equalsIgnoreCase(role.getRoleName())) {
            return "customer".contains(key) || "khách hàng".contains(key) || "khach hang".contains(key);
        }
        if ("MANAGER".equalsIgnoreCase(role.getRoleName())) {
            return "manager".contains(key) || "auction manager".contains(key);
        }
        if ("STAFF".equalsIgnoreCase(role.getRoleName())) {
            return "staff".contains(key);
        }
        return false;
    }

    public User findById(int userID) {
        User user = userRepository.findById(userID);

        if (user != null) {
            user.setRoles(
                    roleRepository.findRolesByUserId(user.getUserID())
            );
        }

        return user;
    }

    public User login(String username, String password) {

        User user = userRepository.findByUsername(username);

        if (user != null
                && user.getPassword().equals(password)
                && "Active".equals(user.getStatus())) {

            user.setRoles(
                    roleRepository.findRolesByUserId(user.getUserID())
            );

            return user;
        }

        return null;
    }

    public String register(User user) {
        validateUniqueUser(user, null);

        user.setStatus("Active");

        if (userRepository.save(user) <= 0) {
            return "Không thể đăng ký tài khoản";
        }

        User savedUser = userRepository.findByUsername(user.getUsername());
        if (savedUser == null) {
            return "Không thể đăng ký tài khoản";
        }

        Role customerRole = roleRepository.findByName("CUSTOMER");
        int roleId = customerRole != null ? customerRole.getRoleID() : 4;
        roleRepository.addRoleToUser(savedUser.getUserID(), roleId);

        Wallet wallet = new Wallet();
        wallet.setUserID(savedUser.getUserID());
        wallet.setBalance(BigDecimal.ZERO);
        walletRepository.save(wallet);

        return null;
    }

    public boolean update(User user) {
        return userRepository.update(user) > 0;
    }

    public boolean updatePassword(int userID, String password) {
        return userRepository.updatePassword(userID, password) > 0;
    }

    public boolean delete(int userID) {
        return userRepository.delete(userID) > 0;
    }

    public List<User> search(String keyword) {
        return filterUsers(keyword, null, null);
    }

    public List<uef.edu.vn.model.Role> findAllRoles() {
        return roleRepository.findAll();
    }

    public String createByAdmin(User user, int roleID, String confirmPassword) {
        if (user.getPassword() == null || !user.getPassword().equals(confirmPassword)) {
            return "Mật khẩu xác nhận không khớp";
        }
        try {
            validateUniqueUser(user, null);
        } catch (ValidationException ex) {
            return ex.getMessage();
        }
        if (user.getStatus() == null || user.getStatus().isBlank()) {
            user.setStatus("Active");
        }
        if (userRepository.save(user) <= 0) {
            return "Không thể lưu người dùng";
        }

        User savedUser = userRepository.findByUsername(user.getUsername());
        if (savedUser == null) {
            return "Không thể lưu người dùng";
        }

        roleRepository.addRoleToUser(savedUser.getUserID(), roleID);

        Wallet wallet = new Wallet();
        wallet.setUserID(savedUser.getUserID());
        wallet.setBalance(BigDecimal.ZERO);
        walletRepository.save(wallet);

        return null;
    }

    public String updateByAdmin(User user, int roleID, String newPassword, String confirmPassword) {
        if (newPassword != null && !newPassword.isBlank()) {
            if (!newPassword.equals(confirmPassword)) {
                return "Mật khẩu xác nhận không khớp";
            }
            userRepository.updatePassword(user.getUserID(), newPassword);
        }

        try {
            validateUniqueUser(user, user.getUserID());
        } catch (ValidationException ex) {
            return ex.getMessage();
        }

        if (userRepository.update(user) <= 0) {
            return "Không thể cập nhật người dùng";
        }

        roleRepository.removeRolesByUserId(user.getUserID());
        roleRepository.addRoleToUser(user.getUserID(), roleID);

        return null;
    }

    private void validateUniqueUser(User user, Integer excludeUserId) {
        String username = user.getUsername() != null ? user.getUsername().trim() : "";
        String email = user.getEmail() != null ? user.getEmail().trim() : "";
        String phone = normalizePhone(user.getPhone());

        user.setUsername(username);
        user.setEmail(email);
        if (phone != null) {
            user.setPhone(phone);
        }

        if (username.isEmpty() || email.isEmpty()) {
            throw new ValidationException("Tên đăng nhập và email không được để trống.");
        }

        validateDistinctCredentials(username, email, phone);

        User byUsername = userRepository.findByUsername(username);
        if (byUsername != null && !isSameUser(byUsername, excludeUserId)) {
            throw new ValidationException("Tên đăng nhập đã tồn tại.");
        }

        User byEmail = userRepository.findByEmail(email);
        if (byEmail != null && !isSameUser(byEmail, excludeUserId)) {
            throw new ValidationException("Email đã được sử dụng.");
        }

        if (phone != null && !phone.isBlank()) {
            User byPhone = userRepository.findByPhone(phone);
            if (byPhone != null && !isSameUser(byPhone, excludeUserId)) {
                throw new ValidationException("Số điện thoại đã được sử dụng.");
            }
        }
    }

    private void validateDistinctCredentials(String username, String email, String phone) {
        if (username.equalsIgnoreCase(email)) {
            throw new ValidationException("Tên đăng nhập và email không được trùng nhau.");
        }
        if (phone != null && !phone.isBlank()) {
            if (phone.equalsIgnoreCase(username) || phone.equalsIgnoreCase(email)) {
                throw new ValidationException("Số điện thoại không được trùng tên đăng nhập hoặc email.");
            }
        }
    }

    private boolean isSameUser(User existing, Integer excludeUserId) {
        return excludeUserId != null && existing.getUserID() == excludeUserId;
    }

    private String normalizePhone(String phone) {
        if (phone == null || phone.isBlank()) {
            return null;
        }
        return phone.trim().replaceAll("[\\s-]", "");
    }
}