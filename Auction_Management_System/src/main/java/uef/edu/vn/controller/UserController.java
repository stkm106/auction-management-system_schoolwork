/*

 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license

 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template

 */

package uef.edu.vn.controller;



import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Controller;

import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.*;
import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.User;
import uef.edu.vn.service.UserService;
import uef.edu.vn.util.ValidationUtils;



@Controller

@RequestMapping("/users")

public class UserController {



    @Autowired

    private UserService userService;



    @GetMapping

    public String list(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String roleID,
            @RequestParam(required = false) String status,
            Model model) {

        populateListModel(model, userService.filterUsers(keyword, parseOptionalInt(roleID), status));

        return "shared/main";

    }



    @GetMapping("/profile")

    public String profile(HttpSession session, Model model) {

        User user = (User) session.getAttribute("user");

        model.addAttribute("user", userService.findById(user.getUserID()));

        model.addAttribute("layout", "admin");

        model.addAttribute("activeMenu", "profile");

        model.addAttribute("body", "/WEB-INF/views/user/profile.jsp");

        return "shared/main";

    }



    @PostMapping("/change-password")

    public String changePassword(

            @RequestParam String currentPassword,

            @RequestParam String newPassword,

            @RequestParam String confirmPassword,

            HttpSession session,

            Model model) {

        User sessionUser = (User) session.getAttribute("user");

        User user = userService.findById(sessionUser.getUserID());

        try {
            ValidationUtils.validateChangePassword(currentPassword, newPassword, confirmPassword);

            if (!user.getPassword().equals(currentPassword)) {
                throw new ValidationException("Mật khẩu hiện tại không đúng");
            }

            userService.updatePassword(user.getUserID(), newPassword);
            model.addAttribute("success", "Đã cập nhật mật khẩu thành công");
            user = userService.findById(user.getUserID());
        } catch (ValidationException ex) {
            model.addAttribute("error", ex.getMessage());
        } catch (Exception ex) {
            model.addAttribute("error", "Không thể đổi mật khẩu. Vui lòng thử lại.");
        }



        model.addAttribute("user", user);

        model.addAttribute("layout", "admin");

        model.addAttribute("activeMenu", "profile");

        model.addAttribute("body", "/WEB-INF/views/user/profile.jsp");

        return "shared/main";

    }



    @GetMapping("/create")

    public String create(Model model) {

        populateFormModel(model, new User(), 4);

        return "shared/main";

    }



    @PostMapping("/save")

    public String save(

            @ModelAttribute User user,

            @RequestParam int roleID,

            @RequestParam String confirmPassword,

            Model model) {

        try {
            ValidationUtils.validateRegistration(user);
            if (!user.getPassword().equals(confirmPassword)) {
                throw new ValidationException("Mật khẩu xác nhận không khớp");
            }

            String error = userService.createByAdmin(user, roleID, confirmPassword);
            if (error != null) {
                model.addAttribute("error", error);
                populateFormModel(model, user, roleID);
                return "shared/main";
            }
            return "redirect:/users";
        } catch (ValidationException ex) {
            model.addAttribute("error", ex.getMessage());
            populateFormModel(model, user, roleID);
            return "shared/main";
        } catch (Exception ex) {
            model.addAttribute("error", "Không thể tạo người dùng. Vui lòng thử lại.");
            populateFormModel(model, user, roleID);
            return "shared/main";
        }

    }



    @GetMapping("/edit/{id}")

    public String edit(@PathVariable int id, Model model) {

        User user = userService.findById(id);

        int roleID = 2;

        if (user.getRoles() != null && !user.getRoles().isEmpty()) {

            roleID = user.getRoles().get(0).getRoleID();

        }

        populateFormModel(model, user, roleID);

        return "shared/main";

    }



    @PostMapping("/update")

    public String update(

            @ModelAttribute User user,

            @RequestParam int roleID,

            @RequestParam(required = false) String newPassword,

            @RequestParam(required = false) String confirmPassword,

            Model model) {

        String error = userService.updateByAdmin(user, roleID, newPassword, confirmPassword);

        if (error != null) {

            model.addAttribute("error", error);

            populateFormModel(model, user, roleID);

            return "shared/main";

        }

        return "redirect:/users";

    }



    @GetMapping("/delete/{id}")

    public String delete(@PathVariable int id) {

        userService.delete(id);

        return "redirect:/users";

    }



    @GetMapping("/search")

    public String search(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String roleID,
            @RequestParam(required = false) String status,
            Model model) {

        return list(keyword, roleID, status, model);

    }



    private Integer parseOptionalInt(String value) {

        if (value == null || value.isBlank()) {

            return null;

        }

        return Integer.valueOf(value.trim());

    }



    private void populateListModel(Model model, java.util.List<User> users) {

        model.addAttribute("users", users);

        model.addAttribute("roles", userService.findAllRoles());

        model.addAttribute("layout", "admin");

        model.addAttribute("activeMenu", "users");

        model.addAttribute("body", "/WEB-INF/views/user/list.jsp");

    }



    private void populateFormModel(Model model, User user, int selectedRoleId) {

        model.addAttribute("user", user);

        model.addAttribute("roles", userService.findAllRoles());

        model.addAttribute("selectedRoleId", selectedRoleId);

        model.addAttribute("layout", "admin");

        model.addAttribute("activeMenu", "users");

        model.addAttribute("body", "/WEB-INF/views/user/form.jsp");

    }

}

