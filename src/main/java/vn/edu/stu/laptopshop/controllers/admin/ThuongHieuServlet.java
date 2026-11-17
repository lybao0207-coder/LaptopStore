package vn.edu.stu.laptopshop.controllers.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import vn.edu.stu.laptopshop.dao.ThuongHieuDAO;
import vn.edu.stu.laptopshop.entities.ThuongHieu;
import vn.edu.stu.laptopshop.utils.SlugUtil;
import vn.edu.stu.laptopshop.utils.WebUtil;

/**
 * Controller quản lý thương hiệu - khu vực Admin (Nhiệm vụ 2, T10). Cùng cấu trúc với DanhMucServlet.
 * Cột DuongDanLogo không có trên form (D30): thêm mới = NULL, sửa = giữ nguyên.
 *
 * <pre>
 * GET  /admin/thuong-hieu?tuKhoa=...&amp;trang=...   Danh sách + tìm theo tên + phân trang
 * GET  /admin/thuong-hieu/them                       Hiện form thêm
 * POST /admin/thuong-hieu/them                       Kiểm tra dữ liệu, lưu, quay về danh sách
 * GET  /admin/thuong-hieu/sua?ma=...                 Hiện form sửa với dữ liệu hiện tại
 * POST /admin/thuong-hieu/sua                        Kiểm tra dữ liệu, cập nhật, quay về DS
 * POST /admin/thuong-hieu/xoa                        Xóa nếu không còn sản phẩm (FK_SanPham_ThuongHieu)
 * </pre>
 * <p>Xóa chỉ nhận POST (không xóa qua đường link GET) để tránh xóa nhầm khi trình duyệt tải trước / bấm link.</p>
 */
@WebServlet("/admin/thuong-hieu/*")
public class ThuongHieuServlet extends HttpServlet {

    private static final String VIEW_DANH_SACH = "/WEB-INF/views/admin/thuonghieu/list.jsp";
    private static final String VIEW_FORM = "/WEB-INF/views/admin/thuonghieu/form.jsp";
    private static final String CHE_DO_THEM = "them";
    private static final String CHE_DO_SUA = "sua";
    private static final int KICH_THUOC_TRANG = 10;
    private static final int TEN_TOI_THIEU = 2;

    private static final String URL_DANH_SACH = "/admin/thuong-hieu";

    private final ThuongHieuDAO thuongHieuDAO = new ThuongHieuDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String duongDanCon = req.getPathInfo();   // null hoặc "/" = trang danh sách
        if (duongDanCon == null || "/".equals(duongDanCon)) {
            hienThiDanhSach(req, resp);
        } else if ("/them".equals(duongDanCon)) {
            hienThiForm(req, resp, new ThuongHieu(), new LinkedHashMap<>(), CHE_DO_THEM);
        } else if ("/sua".equals(duongDanCon)) {
            hienThiFormSua(req, resp);
        } else if ("/xoa".equals(duongDanCon)) {
            // Xóa bắt buộc dùng POST
            resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String duongDanCon = req.getPathInfo();
        if ("/them".equals(duongDanCon)) {
            xuLyThem(req, resp);
        } else if ("/sua".equals(duongDanCon)) {
            xuLySua(req, resp);
        } else if ("/xoa".equals(duongDanCon)) {
            xuLyXoa(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ================================================================ DANH SÁCH

    /** Hiển thị danh sách thương hiệu, có tìm kiếm theo tên và phân trang tại SQL Server. */
    private void hienThiDanhSach(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // --- Kiểm tra và chuẩn hóa tham số ---
        String tuKhoa = req.getParameter("tuKhoa");
        tuKhoa = (tuKhoa == null) ? "" : tuKhoa.trim();
        if (tuKhoa.length() > ThuongHieu.TEN_TOI_DA) {
            // Tên thương hiệu tối đa 100 ký tự nên từ khóa dài hơn không thể khớp; cắt bớt để tránh truy vấn vô ích
            tuKhoa = tuKhoa.substring(0, ThuongHieu.TEN_TOI_DA);
        }
        int trang = WebUtil.docSoNguyenDuong(req.getParameter("trang"), 1);

        try {
            int tongSo = thuongHieuDAO.demTimKiem(tuKhoa);
            int tongTrang = Math.max(1, (tongSo + KICH_THUOC_TRANG - 1) / KICH_THUOC_TRANG);
            if (trang > tongTrang) {
                trang = tongTrang;   // trang vượt quá số trang thực tế -> về trang cuối
            }
            List<ThuongHieu> danhSach = thuongHieuDAO.timKiem(tuKhoa, trang, KICH_THUOC_TRANG);

            req.setAttribute("danhSach", danhSach);
            req.setAttribute("tongSo", tongSo);
            req.setAttribute("tongTrang", tongTrang);
            req.setAttribute("trang", trang);
            req.setAttribute("sttBatDau", (trang - 1) * KICH_THUOC_TRANG);

        } catch (SQLException e) {
            getServletContext().log("Lỗi tải danh sách thương hiệu", e);
            req.setAttribute("loiTaiDuLieu", "Không tải được danh sách thương hiệu do lỗi kết nối cơ sở dữ liệu. "
                    + "Vui lòng thử lại hoặc kiểm tra log của Tomcat.");
        }

        req.setAttribute("tuKhoa", tuKhoa);
        req.setAttribute("tieuDe", "Quản lý thương hiệu");
        req.setAttribute("menuHienTai", "thuong-hieu");
        req.getRequestDispatcher(VIEW_DANH_SACH).forward(req, resp);
    }

    // ================================================================ FORM DÙNG CHUNG

    /** Hiện form thêm hoặc sửa. cheDo = "them" | "sua". */
    private void hienThiForm(HttpServletRequest req, HttpServletResponse resp, ThuongHieu th,
                             Map<String, String> loi, String cheDo) throws ServletException, IOException {
        req.setAttribute("th", th);
        req.setAttribute("loi", loi);
        req.setAttribute("cheDo", cheDo);
        req.setAttribute("tieuDe", CHE_DO_SUA.equals(cheDo) ? "Sửa thương hiệu" : "Thêm thương hiệu");
        req.setAttribute("menuHienTai", "thuong-hieu");
        req.getRequestDispatcher(VIEW_FORM).forward(req, resp);
    }

    // ================================================================ THÊM

    /**
     * Xử lý form thêm thương hiệu.
     * Hợp lệ: lưu DB, đặt thông báo vào session, chuyển hướng về danh sách (Post/Redirect/Get - F5 không gửi lại form).
     * Không hợp lệ: hiện lại form kèm dữ liệu đã nhập và thông báo lỗi từng ô.
     */
    private void xuLyThem(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        ThuongHieu th = docForm(req);
        Map<String, String> loi = kiemTraDuLieu(th);

        try {
            kiemTraTrung(th, null, loi);
            if (!loi.isEmpty()) {
                hienThiForm(req, resp, th, loi, CHE_DO_THEM);
                return;
            }

            int maMoi = thuongHieuDAO.them(th);
            req.getSession().setAttribute(WebUtil.THONG_BAO_THANH_CONG,
                    "Đã thêm thương hiệu \"" + th.getTenThuongHieu() + "\" (mã " + maMoi + ").");
            resp.sendRedirect(req.getContextPath() + URL_DANH_SACH);

        } catch (SQLException e) {
            ghiLoiSql(e, loi, "thêm");
            hienThiForm(req, resp, th, loi, CHE_DO_THEM);
        }
    }

    // ================================================================ SỬA

    /** GET /sua?ma=...: nạp thương hiệu hiện tại vào form. Mã sai hoặc không tồn tại -> về danh sách kèm thông báo lỗi. */
    private void hienThiFormSua(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int ma = WebUtil.docSoNguyenDuong(req.getParameter("ma"), -1);
        if (ma < 1) {
            veDanhSachKemLoi(req, resp, "Mã thương hiệu không hợp lệ.");
            return;
        }
        try {
            ThuongHieu th = thuongHieuDAO.timTheoMa(ma);
            if (th == null) {
                veDanhSachKemLoi(req, resp, "Không tìm thấy thương hiệu mã " + ma + " (có thể đã bị xóa).");
                return;
            }
            hienThiForm(req, resp, th, new LinkedHashMap<>(), CHE_DO_SUA);
        } catch (SQLException e) {
            getServletContext().log("Lỗi tải thương hiệu để sửa, mã " + ma, e);
            veDanhSachKemLoi(req, resp, "Không tải được thương hiệu do lỗi cơ sở dữ liệu.");
        }
    }

    /**
     * POST /sua: cập nhật tên, đường dẫn, quốc gia, trạng thái. Không sửa MaThuongHieu, NgayTao, DuongDanLogo.
     * Kiểm tra trùng bỏ qua chính thương hiệu đang sửa.
     */
    private void xuLySua(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int ma = WebUtil.docSoNguyenDuong(req.getParameter("maThuongHieu"), -1);
        if (ma < 1) {
            veDanhSachKemLoi(req, resp, "Mã thương hiệu không hợp lệ.");
            return;
        }

        ThuongHieu th = docForm(req);
        th.setMaThuongHieu(ma);
        Map<String, String> loi = kiemTraDuLieu(th);

        try {
            ThuongHieu hienTai = thuongHieuDAO.timTheoMa(ma);
            if (hienTai == null) {
                veDanhSachKemLoi(req, resp, "Không tìm thấy thương hiệu mã " + ma + " (có thể đã bị xóa).");
                return;
            }
            // Giữ thông tin chỉ-đọc để hiển thị lại trên form khi có lỗi
            th.setNgayTao(hienTai.getNgayTao());
            th.setDuongDanLogo(hienTai.getDuongDanLogo());   // D30: chỉ hiển thị, không cập nhật
            th.setSoSanPham(hienTai.getSoSanPham());

            kiemTraTrung(th, ma, loi);
            if (!loi.isEmpty()) {
                hienThiForm(req, resp, th, loi, CHE_DO_SUA);
                return;
            }

            if (!thuongHieuDAO.capNhat(th)) {
                veDanhSachKemLoi(req, resp, "Không cập nhật được: thương hiệu mã " + ma + " không còn tồn tại.");
                return;
            }
            req.getSession().setAttribute(WebUtil.THONG_BAO_THANH_CONG,
                    "Đã cập nhật thương hiệu \"" + th.getTenThuongHieu() + "\" (mã " + ma + ").");
            resp.sendRedirect(req.getContextPath() + URL_DANH_SACH);

        } catch (SQLException e) {
            ghiLoiSql(e, loi, "cập nhật");
            hienThiForm(req, resp, th, loi, CHE_DO_SUA);
        }
    }

    // ================================================================ XÓA

    /**
     * POST /xoa: chỉ xóa khi thương hiệu không còn sản phẩm (BR11, FK_SanPham_ThuongHieu NO ACTION).
     * Còn sản phẩm -> từ chối và gợi ý chuyển "Ngừng hoạt động". Luôn quay lại đúng trang danh sách đang xem.
     */
    private void xuLyXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String urlQuayLai = WebUtil.taoUrlDanhSach(req, URL_DANH_SACH);
        int ma = WebUtil.docSoNguyenDuong(req.getParameter("maThuongHieu"), -1);
        if (ma < 1) {
            WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI, "Mã thương hiệu không hợp lệ.", urlQuayLai);
            return;
        }
        try {
            ThuongHieu th = thuongHieuDAO.timTheoMa(ma);
            if (th == null) {
                WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI,
                        "Không tìm thấy thương hiệu mã " + ma + " (có thể đã bị xóa trước đó).", urlQuayLai);
                return;
            }
            // Lớp kiểm tra 1: đếm sản phẩm trước khi xóa để báo lỗi rõ ràng
            int soSanPham = thuongHieuDAO.demSanPham(ma);
            if (soSanPham > 0) {
                WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI, thongBaoConSanPham(th.getTenThuongHieu(), soSanPham), urlQuayLai);
                return;
            }
            if (!thuongHieuDAO.xoa(ma)) {
                WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI,
                        "Không tìm thấy thương hiệu mã " + ma + " (có thể đã bị xóa trước đó).", urlQuayLai);
                return;
            }
            WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_THANH_CONG,
                    "Đã xóa thương hiệu \"" + th.getTenThuongHieu() + "\" (mã " + ma + ").", urlQuayLai);

        } catch (SQLException e) {
            getServletContext().log("Lỗi xóa thương hiệu mã " + ma + " (mã lỗi SQL " + e.getErrorCode() + ")", e);
            // Lớp kiểm tra 2: khóa ngoại trong DB chặn (VD: có sản phẩm vừa được thêm vào thương hiệu ngay trước khi xóa)
            String thongBao = WebUtil.laLoiRangBuoc(e)
                    ? "Không thể xóa thương hiệu mã " + ma + " vì đang có sản phẩm thuộc thương hiệu này."
                    : "Không xóa được thương hiệu do lỗi cơ sở dữ liệu. Vui lòng thử lại hoặc kiểm tra log của Tomcat.";
            WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI, thongBao, urlQuayLai);
        }
    }

    private static String thongBaoConSanPham(String tenThuongHieu, int soSanPham) {
        return "Không thể xóa thương hiệu \"" + tenThuongHieu + "\" vì đang có " + soSanPham + " sản phẩm. "
                + "Nếu không muốn dùng thương hiệu này nữa, hãy bấm Sửa và bỏ chọn \"Đang hoạt động\".";
    }

    // ================================================================ HỖ TRỢ DÙNG CHUNG

    /** Kiểm tra trùng tên / đường dẫn trên DB (chỉ khi ô đó đã đúng định dạng). boQuaMa = mã đang sửa, null khi thêm. */
    private void kiemTraTrung(ThuongHieu th, Integer boQuaMa, Map<String, String> loi) throws SQLException {
        if (!loi.containsKey("tenThuongHieu") && thuongHieuDAO.tonTaiTen(th.getTenThuongHieu(), boQuaMa)) {
            loi.put("tenThuongHieu", "Tên thương hiệu \"" + th.getTenThuongHieu() + "\" đã tồn tại.");
        }
        if (!loi.containsKey("duongDanUrl") && thuongHieuDAO.tonTaiDuongDan(th.getDuongDanUrl(), boQuaMa)) {
            loi.put("duongDanUrl", "Đường dẫn URL \"" + th.getDuongDanUrl() + "\" đã được thương hiệu khác sử dụng.");
        }
    }

    /** Lớp bảo vệ thứ hai: chuyển lỗi SQL Server thành thông báo dễ hiểu; chi tiết ghi vào log. */
    private void ghiLoiSql(SQLException e, Map<String, String> loi, String hanhDong) {
        int ma = e.getErrorCode();
        if (WebUtil.laLoiTrung(e)) {
            loi.put("chung", "Tên hoặc đường dẫn URL vừa bị trùng với thương hiệu khác. Vui lòng kiểm tra lại.");
        } else if (WebUtil.laLoiRangBuoc(e)) {
            loi.put("chung", "Dữ liệu không thỏa ràng buộc của cơ sở dữ liệu.");
        } else {
            loi.put("chung", "Không " + hanhDong + " được thương hiệu do lỗi cơ sở dữ liệu. "
                    + "Vui lòng thử lại hoặc kiểm tra log của Tomcat.");
        }
        getServletContext().log("Lỗi " + hanhDong + " thương hiệu (mã lỗi SQL " + ma + ")", e);
    }

    /** Đặt thông báo lỗi (flash) rồi chuyển hướng về trang danh sách. */
    private static void veDanhSachKemLoi(HttpServletRequest req, HttpServletResponse resp, String thongBao)
            throws IOException {
        WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI, thongBao, req.getContextPath() + URL_DANH_SACH);
    }

    // ================================================================ ĐỌC VÀ KIỂM TRA FORM

    /** Đọc dữ liệu từ form, chuẩn hóa khoảng trắng; đường dẫn để trống thì tự tạo từ tên. */
    private static ThuongHieu docForm(HttpServletRequest req) {
        ThuongHieu th = new ThuongHieu();
        // NFC: gom chữ và dấu thành 1 ký tự (một số bộ gõ gửi dấu tách rời), để so sánh trùng và đếm độ dài đúng
        String ten = WebUtil.chuanHoa(req.getParameter("tenThuongHieu")).replaceAll("\\s+", " ");
        th.setTenThuongHieu(ten);

        String duongDan = WebUtil.chuanHoa(req.getParameter("duongDanUrl")).toLowerCase();
        th.setDuongDanUrl(duongDan.isEmpty() ? SlugUtil.taoDuongDan(ten, ThuongHieu.DUONG_DAN_TOI_DA) : duongDan);

        String quocGia = WebUtil.chuanHoa(req.getParameter("quocGia")).replaceAll("\\s+", " ");
        th.setQuocGia(quocGia.isEmpty() ? null : quocGia);

        // Checkbox: có tham số khi được đánh dấu, không có khi bỏ dấu
        th.setDangHoatDong(req.getParameter("dangHoatDong") != null);
        return th;
    }

    /** Kiểm tra định dạng / độ dài. Trả về map: tên ô -> thông báo lỗi (rỗng = hợp lệ). */
    private static Map<String, String> kiemTraDuLieu(ThuongHieu th) {
        Map<String, String> loi = new LinkedHashMap<>();

        String ten = th.getTenThuongHieu();
        if (ten.isEmpty()) {
            loi.put("tenThuongHieu", "Vui lòng nhập tên thương hiệu.");
        } else if (ten.length() < TEN_TOI_THIEU || ten.length() > ThuongHieu.TEN_TOI_DA) {
            loi.put("tenThuongHieu", "Tên thương hiệu phải từ " + TEN_TOI_THIEU + " đến " + ThuongHieu.TEN_TOI_DA + " ký tự.");
        }

        String duongDan = th.getDuongDanUrl();
        if (duongDan.isEmpty()) {
            if (!loi.containsKey("tenThuongHieu")) {
                loi.put("duongDanUrl", "Không tạo được đường dẫn từ tên này. Vui lòng tự nhập đường dẫn (chỉ a-z, 0-9, dấu -).");
            }
        } else if (duongDan.length() > ThuongHieu.DUONG_DAN_TOI_DA) {
            loi.put("duongDanUrl", "Đường dẫn URL tối đa " + ThuongHieu.DUONG_DAN_TOI_DA + " ký tự.");
        } else if (!SlugUtil.hopLe(duongDan)) {
            loi.put("duongDanUrl", "Đường dẫn URL chỉ gồm chữ thường không dấu a-z, số 0-9 và dấu - giữa các từ "
                    + "(VD: dell, hp, lenovo).");
        }

        if (th.getQuocGia() != null && th.getQuocGia().length() > ThuongHieu.QUOC_GIA_TOI_DA) {
            loi.put("quocGia", "Quốc gia tối đa " + ThuongHieu.QUOC_GIA_TOI_DA + " ký tự.");
        }
        return loi;
    }
}
