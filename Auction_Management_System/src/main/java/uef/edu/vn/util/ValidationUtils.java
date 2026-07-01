package uef.edu.vn.util;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;
import java.util.regex.Pattern;
import org.springframework.web.multipart.MultipartFile;
import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.AuctionSession;
import uef.edu.vn.model.Product;
import uef.edu.vn.model.User;

public final class ValidationUtils {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[a-zA-Z0-9._-]{3,50}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^(0|\\+84)[0-9]{8,14}$");
    public static final TimeZone APP_TIME_ZONE = TimeZone.getTimeZone("Asia/Ho_Chi_Minh");
    public static final long MIN_AUCTION_DURATION_MS = 5 * 60 * 1000L;

    private ValidationUtils() {
    }

    public static void requireNonBlank(String value, String fieldLabel) {
        if (value == null || value.isBlank()) {
            throw new ValidationException(fieldLabel + " không được để trống.");
        }
    }

    public static void validateLogin(String username, String password) {
        requireNonBlank(username, "Tên đăng nhập");
        requireNonBlank(password, "Mật khẩu");
    }

    public static void validateRegistration(User user) {
        requireNonBlank(user.getUsername(), "Tên đăng nhập");
        requireNonBlank(user.getPassword(), "Mật khẩu");
        requireNonBlank(user.getFullName(), "Họ và tên");
        requireNonBlank(user.getEmail(), "Email");
        requireNonBlank(user.getPhone(), "Số điện thoại");

        if (!USERNAME_PATTERN.matcher(user.getUsername().trim()).matches()) {
            throw new ValidationException("Tên đăng nhập chỉ gồm chữ, số, dấu chấm, gạch ngang (3–50 ký tự).");
        }
        validatePassword(user.getPassword());
        validateEmail(user.getEmail());
        validatePhone(user.getPhone());
    }

    public static void validatePassword(String password) {
        requireNonBlank(password, "Mật khẩu");
        if (password.length() < 6) {
            throw new ValidationException("Mật khẩu phải có ít nhất 6 ký tự.");
        }
    }

    public static void validateEmail(String email) {
        requireNonBlank(email, "Email");
        if (!EMAIL_PATTERN.matcher(email.trim()).matches()) {
            throw new ValidationException("Email không hợp lệ.");
        }
    }

    public static void validatePhone(String phone) {
        String normalized = phone.trim().replaceAll("\\s+", "");
        if (!PHONE_PATTERN.matcher(normalized).matches()) {
            throw new ValidationException("Số điện thoại không hợp lệ.");
        }
    }

    public static void validatePositiveMoney(BigDecimal amount, String fieldLabel) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new ValidationException(fieldLabel + " phải lớn hơn 0.");
        }
    }

    public static void validateProduct(Product product, MultipartFile imageFile, boolean requireImage) {
        requireNonBlank(product.getProductName(), "Tên sản phẩm");
        validatePositiveMoney(product.getStartingPrice(), "Giá khởi điểm");

        if (product.getCategoryID() <= 0) {
            throw new ValidationException("Vui lòng chọn danh mục sản phẩm.");
        }

        if (requireImage && (imageFile == null || imageFile.isEmpty())) {
            throw new ValidationException("Vui lòng chọn hình ảnh sản phẩm.");
        }
    }

    public static Date parseDateTimeLocal(String value, String fieldLabel) {
        if (value == null || value.isBlank()) {
            throw new ValidationException(fieldLabel + " không được để trống.");
        }
        String text = value.trim();
        for (String pattern : new String[]{"yyyy-MM-dd'T'HH:mm:ss", "yyyy-MM-dd'T'HH:mm"}) {
            try {
                SimpleDateFormat fmt = new SimpleDateFormat(pattern);
                fmt.setTimeZone(APP_TIME_ZONE);
                fmt.setLenient(false);
                return fmt.parse(text);
            } catch (ParseException ignored) {
            }
        }
        throw new ValidationException(fieldLabel + " không hợp lệ.");
    }

    public static void validateAuction(AuctionSession auction) {
        if (auction.getProductID() <= 0) {
            throw new ValidationException("Vui lòng chọn sản phẩm.");
        }
        validatePositiveMoney(auction.getCurrentPrice(), "Giá hiện tại");

        Date start = auction.getStartTime();
        Date end = auction.getEndTime();
        if (start == null || end == null) {
            throw new ValidationException("Thời gian bắt đầu và kết thúc không được để trống.");
        }
        if (!end.after(start)) {
            throw new ValidationException("Thời gian kết thúc phải sau thời gian bắt đầu.");
        }
        if (end.getTime() - start.getTime() < MIN_AUCTION_DURATION_MS) {
            throw new ValidationException("Phiên đấu giá phải kéo dài ít nhất 5 phút.");
        }
        Date now = new Date();
        if (!start.after(now)) {
            throw new ValidationException("Thời gian bắt đầu phải ở tương lai, không được chọn ngày trong quá khứ.");
        }
        if (!end.after(now)) {
            throw new ValidationException("Thời gian kết thúc phải ở tương lai, không được chọn ngày trong quá khứ.");
        }
    }

    public static void validateChangePassword(String currentPassword, String newPassword, String confirmPassword) {
        requireNonBlank(currentPassword, "Mật khẩu hiện tại");
        requireNonBlank(newPassword, "Mật khẩu mới");
        requireNonBlank(confirmPassword, "Xác nhận mật khẩu");
        validatePassword(newPassword);
        if (!newPassword.equals(confirmPassword)) {
            throw new ValidationException("Mật khẩu xác nhận không khớp.");
        }
    }
}
