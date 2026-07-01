package uef.edu.vn.config;

import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
import uef.edu.vn.model.User;
import uef.edu.vn.util.PermissionModel;

@ControllerAdvice
public class PermissionAdvice {

    @ModelAttribute("perm")
    public PermissionModel permissions(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return new PermissionModel(user);
    }
}
