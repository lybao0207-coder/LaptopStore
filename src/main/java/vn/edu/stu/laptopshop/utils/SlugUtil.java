package vn.edu.stu.laptopshop.utils;

import java.text.Normalizer;
import java.util.regex.Pattern;

/**
 * Tạo "đường dẫn URL" (slug) từ chuỗi tiếng Việt, ví dụ:
 * {@code "Đồ họa - Kỹ thuật"} -> {@code "do-hoa-ky-thuat"}.
 *
 * <p>Kết quả chỉ gồm a-z, 0-9 và dấu '-', khớp ràng buộc CHECK của cột DuongDanUrl
 * ({@code NOT LIKE '%[^a-z0-9-]%'}) trong bảng DanhMuc và ThuongHieu. Dùng chung cho cả nhóm.</p>
 */
public final class SlugUtil {

    /** Định dạng hợp lệ: các cụm chữ/số nối bằng một dấu '-', không có '-' ở đầu/cuối. */
    private static final Pattern DINH_DANG_HOP_LE = Pattern.compile("^[a-z0-9]+(-[a-z0-9]+)*$");
    private static final Pattern DAU_KET_HOP = Pattern.compile("\\p{M}+");

    private SlugUtil() {
    }

    /**
     * Chuyển chuỗi bất kỳ thành slug.
     *
     * @param chuoi  chuỗi gốc (có thể có dấu tiếng Việt)
     * @param toiDa  độ dài tối đa của kết quả
     * @return slug; chuỗi rỗng nếu không còn ký tự chữ/số nào (VD: chuỗi toàn ký hiệu)
     */
    public static String taoDuongDan(String chuoi, int toiDa) {
        if (chuoi == null) {
            return "";
        }
        // Tách dấu khỏi chữ (ộ -> o + dấu) rồi bỏ dấu; chữ đ/Đ không tách được nên thay riêng
        String s = Normalizer.normalize(chuoi, Normalizer.Form.NFD);
        s = DAU_KET_HOP.matcher(s).replaceAll("");
        s = s.replace('đ', 'd').replace('Đ', 'D').toLowerCase();
        // Mọi chuỗi ký tự không phải a-z, 0-9 -> một dấu '-'; bỏ '-' ở hai đầu
        s = s.replaceAll("[^a-z0-9]+", "-").replaceAll("^-+|-+$", "");
        if (s.length() > toiDa) {
            s = s.substring(0, toiDa).replaceAll("-+$", "");
        }
        return s;
    }

    /** Kiểm tra slug người dùng tự nhập có đúng định dạng không. */
    public static boolean hopLe(String duongDan) {
        return duongDan != null && DINH_DANG_HOP_LE.matcher(duongDan).matches();
    }
}
