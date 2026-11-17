package vn.edu.stu.laptopshop.utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.text.Normalizer;

/**
 * Các hàm web dùng chung cho mọi Servlet (Admin và User) - quyết định D35.
 *
 * <p>Tách ra từ DanhMucServlet (T9.0) để các Servlet quản lý ThuongHieu, BoXuLy, CardDoHoa
 * dùng lại, không chép code.</p>
 */
public final class WebUtil {

    /** Tên thuộc tính session cho thông báo một lần (flash) - layout Admin đọc và tự xóa. */
    public static final String THONG_BAO_THANH_CONG = "thongBaoThanhCong";
    public static final String THONG_BAO_LOI = "thongBaoLoi";

    /** Mã lỗi SQL Server: vi phạm UNIQUE constraint / unique index. */
    public static final int LOI_TRUNG_UNIQUE = 2627;
    public static final int LOI_TRUNG_UNIQUE_INDEX = 2601;
    /** Mã lỗi SQL Server: vi phạm CHECK hoặc khóa ngoại (FOREIGN KEY). */
    public static final int LOI_RANG_BUOC = 547;

    private WebUtil() {
    }

    /** true nếu lỗi SQL là do trùng giá trị UNIQUE. */
    public static boolean laLoiTrung(SQLException e) {
        return e.getErrorCode() == LOI_TRUNG_UNIQUE || e.getErrorCode() == LOI_TRUNG_UNIQUE_INDEX;
    }

    /** true nếu lỗi SQL là do vi phạm CHECK hoặc khóa ngoại. */
    public static boolean laLoiRangBuoc(SQLException e) {
        return e.getErrorCode() == LOI_RANG_BUOC;
    }

    /** Đọc số nguyên dương từ tham số; sai định dạng hoặc nhỏ hơn 1 thì trả về giá trị mặc định. */
    public static int docSoNguyenDuong(String giaTri, int macDinh) {
        if (giaTri == null || !giaTri.trim().matches("\\d{1,9}")) {
            return macDinh;
        }
        int so = Integer.parseInt(giaTri.trim());
        return so >= 1 ? so : macDinh;
    }

    /**
     * Bỏ khoảng trắng hai đầu và chuẩn hóa Unicode NFC (gom chữ + dấu thành 1 ký tự,
     * vì một số bộ gõ gửi dấu tách rời). null -> chuỗi rỗng.
     */
    public static String chuanHoa(String s) {
        return s == null ? "" : Normalizer.normalize(s.trim(), Normalizer.Form.NFC);
    }

    /** Ký tự ASCII in được - dùng cho cột VARCHAR (chữ có dấu sẽ bị SQL Server đổi thành '?'). */
    private static final String MAU_ASCII = "[\\x20-\\x7E]+";

    /**
     * Đọc ô chuỗi BẮT BUỘC chỉ gồm ký tự ASCII (dùng cho cột VARCHAR), gộp khoảng trắng, giới hạn độ dài.
     * Sai thì ghi thông báo vào {@code loi} với khóa = tên ô.
     */
    public static String docChuoiAscii(HttpServletRequest req, String tenO, String nhan, int toiDa,
                                       java.util.Map<String, String> loi) {
        String giaTri = chuanHoa(req.getParameter(tenO)).replaceAll("\\s+", " ");
        if (giaTri.isEmpty()) {
            loi.put(tenO, "Vui lòng nhập " + nhan.toLowerCase() + ".");
        } else if (giaTri.length() > toiDa) {
            loi.put(tenO, nhan + " tối đa " + toiDa + " ký tự.");
        } else if (!giaTri.matches(MAU_ASCII)) {
            loi.put(tenO, nhan + " chỉ dùng chữ không dấu, số và ký hiệu thông thường (cột lưu dạng VARCHAR).");
        }
        return giaTri;
    }

    /**
     * Đọc ô số nguyên trong khoảng [min, max] (tối đa 3 chữ số - đủ cho cột TINYINT).
     *
     * @param batBuoc false: ô trống trả về null, không báo lỗi
     * @return giá trị hợp lệ, hoặc null (ô trống / sai - khi sai đã ghi lỗi vào {@code loi})
     */
    public static Integer docSoNguyenTrongKhoang(HttpServletRequest req, String tenO, String nhan, int min, int max,
                                                 boolean batBuoc, java.util.Map<String, String> loi) {
        String giaTri = chuanHoa(req.getParameter(tenO));
        if (giaTri.isEmpty()) {
            if (batBuoc) {
                loi.put(tenO, "Vui lòng nhập " + nhan.toLowerCase() + ".");
            }
            return null;
        }
        if (!giaTri.matches("\\d{1,3}")) {
            loi.put(tenO, nhan + " phải là số nguyên từ " + min + " đến " + max + ".");
            return null;
        }
        int so = Integer.parseInt(giaTri);
        if (so < min || so > max) {
            loi.put(tenO, nhan + " phải từ " + min + " đến " + max + ".");
            return null;
        }
        return so;
    }

    /** Đặt thông báo một lần vào session rồi chuyển hướng (Post/Redirect/Get). loai = THONG_BAO_THANH_CONG | THONG_BAO_LOI. */
    public static void datThongBaoVaChuyen(HttpServletRequest req, HttpServletResponse resp, String loai,
                                           String thongBao, String url) throws IOException {
        req.getSession().setAttribute(loai, thongBao);
        resp.sendRedirect(url);
    }

    /**
     * Tạo URL trang danh sách, giữ lại từ khóa và số trang người dùng đang xem (đọc từ tham số tuKhoa, trang),
     * đã mã hóa an toàn.
     *
     * @param duongDan đường dẫn trang danh sách, VD: "/admin/danh-muc"
     */
    public static String taoUrlDanhSach(HttpServletRequest req, String duongDan) {
        StringBuilder url = new StringBuilder(req.getContextPath()).append(duongDan);
        String tuKhoa = chuanHoa(req.getParameter("tuKhoa"));
        int trang = docSoNguyenDuong(req.getParameter("trang"), 1);
        String noi = "?";
        if (!tuKhoa.isEmpty()) {
            url.append(noi).append("tuKhoa=").append(URLEncoder.encode(tuKhoa, StandardCharsets.UTF_8));
            noi = "&";
        }
        if (trang > 1) {
            url.append(noi).append("trang=").append(trang);
        }
        return url.toString();
    }
}
