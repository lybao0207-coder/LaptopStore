package vn.edu.stu.laptopshop.utils;

/**
 * Hàm hỗ trợ viết câu SQL dùng chung cho các DAO.
 */
public final class SqlUtil {

    /** Ký tự thoát dùng trong mệnh đề {@code LIKE ? ESCAPE '!'}. */
    public static final String KY_TU_THOAT = "!";

    private SqlUtil() {
    }

    /** null -> "", ngược lại bỏ khoảng trắng hai đầu. */
    public static String chuanHoaTuKhoa(String tuKhoa) {
        return tuKhoa == null ? "" : tuKhoa.trim();
    }

    /**
     * Tạo mẫu {@code '%từ khóa%'} cho LIKE và vô hiệu hóa ký tự đặc biệt của LIKE (%, _, [)
     * để chúng được hiểu là ký tự thường. Câu SQL phải dùng {@code LIKE ? ESCAPE '!'}.
     */
    public static String taoMauLike(String tuKhoa) {
        String daThoat = tuKhoa.replace("!", "!!").replace("%", "!%").replace("_", "!_").replace("[", "![");
        return "%" + daThoat + "%";
    }
}
