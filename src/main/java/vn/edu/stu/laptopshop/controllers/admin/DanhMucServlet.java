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
import vn.edu.stu.laptopshop.dao.DanhMucDAO;
import vn.edu.stu.laptopshop.entities.DanhMuc;
import vn.edu.stu.laptopshop.utils.SlugUtil;
import vn.edu.stu.laptopshop.utils.WebUtil;

/**
 * Controller quản lý danh mục - khu vực Admin (Nhiệm vụ 2).
 *
 * <pre>
 * GET  /admin/danh-muc?tuKhoa=...&amp;trang=...   Danh sách + tìm theo tên + phân trang      (T5)
 * GET  /admin/danh-muc/them                       Hiện form thêm                           (T6)
 * POST /admin/danh-muc/them                       Kiểm tra dữ liệu, lưu, quay về danh sách (T6)
 * GET  /admin/danh-muc/sua?ma=...                 Hiện form sửa với dữ liệu hiện tại       (T7)
 * POST /admin/danh-muc/sua                        Kiểm tra dữ liệu, cập nhật, quay về DS   (T7)
 * POST /admin/danh-muc/xoa                        Xóa nếu không còn sản phẩm (BR11)        (T8)
 * </pre>
 * <p>Xóa chỉ nhận POST (không xóa qua đường link GET) để tránh xóa nhầm khi trình duyệt tải trước / bấm link.</p>
 */
@WebServlet("/admin/danh-muc/*")
public class DanhMucServlet extends HttpServlet {

    private static final String VIEW_DANH_SACH = "/WEB-INF/views/admin/danhmuc/list.jsp";
    private static final String VIEW_FORM = "/WEB-INF/views/admin/danhmuc/form.jsp";
    private static final String CHE_DO_THEM = "them";
    private static final String CHE_DO_SUA = "sua";
    private static final int KICH_THUOC_TRANG = 10;
    private static final int TEN_TOI_THIEU = 2;

    private static final String URL_DANH_SACH = "/admin/danh-muc";

    private final DanhMucDAO danhMucDAO = new DanhMucDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String duongDanCon = req.getPathInfo();   // null hoặc "/" = trang danh sách
        if (duongDanCon == null || "/".equals(duongDanCon)) {
            hienThiDanhSach(req, resp);
        } else if ("/them".equals(duongDanCon)) {
            hienThiForm(req, resp, new DanhMuc(), new LinkedHashMap<>(), CHE_DO_THEM);
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

    // ================================================================ DANH SÁCH (T5)

    /** Hiển thị danh sách danh mục, có tìm kiếm theo tên và phân trang tại SQL Server. */
    private void hienThiDanhSach(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // --- Kiểm tra và chuẩn hóa tham số ---
        String tuKhoa = req.getParameter("tuKhoa");
        tuKhoa = (tuKhoa == null) ? "" : tuKhoa.trim();
        if (tuKhoa.length() > DanhMuc.TEN_TOI_DA) {
            // Tên danh mục tối đa 100 ký tự nên từ khóa dài hơn không thể khớp; cắt bớt để tránh truy vấn vô ích
            tuKhoa = tuKhoa.substring(0, DanhMuc.TEN_TOI_DA);
        }
        int trang = WebUtil.docSoNguyenDuong(req.getParameter("trang"), 1);

        try {
            int tongSo = danhMucDAO.demTimKiem(tuKhoa);
            int tongTrang = Math.max(1, (tongSo + KICH_THUOC_TRANG - 1) / KICH_THUOC_TRANG);
            if (trang > tongTrang) {
                trang = tongTrang;   // trang vượt quá số trang thực tế -> về trang cuối
            }
            List<DanhMuc> danhSach = danhMucDAO.timKiem(tuKhoa, trang, KICH_THUOC_TRANG);

            req.setAttribute("danhSach", danhSach);
            req.setAttribute("tongSo", tongSo);
            req.setAttribute("tongTrang", tongTrang);
            req.setAttribute("trang", trang);
            req.setAttribute("sttBatDau", (trang - 1) * KICH_THUOC_TRANG);

        } catch (SQLException e) {
            getServletContext().log("Lỗi tải danh sách danh mục", e);
            req.setAttribute("loiTaiDuLieu", "Không tải được danh sách danh mục do lỗi kết nối cơ sở dữ liệu. "
                    + "Vui lòng thử lại hoặc kiểm tra log của Tomcat.");
        }

        req.setAttribute("tuKhoa", tuKhoa);
        req.setAttribute("tieuDe", "Quản lý danh mục");
        req.setAttribute("menuHienTai", "danh-muc");
        req.getRequestDispatcher(VIEW_DANH_SACH).forward(req, resp);
    }

    // ================================================================ FORM DÙNG CHUNG

    /** Hiện form thêm hoặc sửa. cheDo = "them" | "sua". */
    private void hienThiForm(HttpServletRequest req, HttpServletResponse resp, DanhMuc dm,
                             Map<String, String> loi, String cheDo) throws ServletException, IOException {
        req.setAttribute("dm", dm);
        req.setAttribute("loi", loi);
        req.setAttribute("cheDo", cheDo);
        req.setAttribute("tieuDe", CHE_DO_SUA.equals(cheDo) ? "Sửa danh mục" : "Thêm danh mục");
        req.setAttribute("menuHienTai", "danh-muc");
        req.getRequestDispatcher(VIEW_FORM).forward(req, resp);
    }

    // ================================================================ THÊM (T6)

    /**
     * Xử lý form thêm danh mục.
     * Hợp lệ: lưu DB, đặt thông báo vào session, chuyển hướng về danh sách (Post/Redirect/Get - F5 không gửi lại form).
     * Không hợp lệ: hiện lại form kèm dữ liệu đã nhập và thông báo lỗi từng ô.
     */
    private void xuLyThem(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        DanhMuc dm = docForm(req);
        Map<String, String> loi = kiemTraDuLieu(dm);

        try {
            kiemTraTrung(dm, null, loi);
            if (!loi.isEmpty()) {
                hienThiForm(req, resp, dm, loi, CHE_DO_THEM);
                return;
            }

            int maMoi = danhMucDAO.them(dm);
            req.getSession().setAttribute(WebUtil.THONG_BAO_THANH_CONG,
                    "Đã thêm danh mục \"" + dm.getTenDanhMuc() + "\" (mã " + maMoi + ").");
            resp.sendRedirect(req.getContextPath() + URL_DANH_SACH);

        } catch (SQLException e) {
            ghiLoiSql(e, loi, "thêm");
            hienThiForm(req, resp, dm, loi, CHE_DO_THEM);
        }
    }

    // ================================================================ SỬA (T7)

    /** GET /sua?ma=...: nạp danh mục hiện tại vào form. Mã sai hoặc không tồn tại -> về danh sách kèm thông báo lỗi. */
    private void hienThiFormSua(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int ma = WebUtil.docSoNguyenDuong(req.getParameter("ma"), -1);
        if (ma < 1) {
            veDanhSachKemLoi(req, resp, "Mã danh mục không hợp lệ.");
            return;
        }
        try {
            DanhMuc dm = danhMucDAO.timTheoMa(ma);
            if (dm == null) {
                veDanhSachKemLoi(req, resp, "Không tìm thấy danh mục mã " + ma + " (có thể đã bị xóa).");
                return;
            }
            hienThiForm(req, resp, dm, new LinkedHashMap<>(), CHE_DO_SUA);
        } catch (SQLException e) {
            getServletContext().log("Lỗi tải danh mục để sửa, mã " + ma, e);
            veDanhSachKemLoi(req, resp, "Không tải được danh mục do lỗi cơ sở dữ liệu.");
        }
    }

    /**
     * POST /sua: cập nhật tên, đường dẫn, mô tả, trạng thái. Không sửa MaDanhMuc và NgayTao.
     * Kiểm tra trùng bỏ qua chính danh mục đang sửa.
     */
    private void xuLySua(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int ma = WebUtil.docSoNguyenDuong(req.getParameter("maDanhMuc"), -1);
        if (ma < 1) {
            veDanhSachKemLoi(req, resp, "Mã danh mục không hợp lệ.");
            return;
        }

        DanhMuc dm = docForm(req);
        dm.setMaDanhMuc(ma);
        Map<String, String> loi = kiemTraDuLieu(dm);

        try {
            DanhMuc hienTai = danhMucDAO.timTheoMa(ma);
            if (hienTai == null) {
                veDanhSachKemLoi(req, resp, "Không tìm thấy danh mục mã " + ma + " (có thể đã bị xóa).");
                return;
            }
            // Giữ thông tin chỉ-đọc để hiển thị lại trên form khi có lỗi
            dm.setNgayTao(hienTai.getNgayTao());
            dm.setSoSanPham(hienTai.getSoSanPham());

            kiemTraTrung(dm, ma, loi);
            if (!loi.isEmpty()) {
                hienThiForm(req, resp, dm, loi, CHE_DO_SUA);
                return;
            }

            if (!danhMucDAO.capNhat(dm)) {
                veDanhSachKemLoi(req, resp, "Không cập nhật được: danh mục mã " + ma + " không còn tồn tại.");
                return;
            }
            req.getSession().setAttribute(WebUtil.THONG_BAO_THANH_CONG,
                    "Đã cập nhật danh mục \"" + dm.getTenDanhMuc() + "\" (mã " + ma + ").");
            resp.sendRedirect(req.getContextPath() + URL_DANH_SACH);

        } catch (SQLException e) {
            ghiLoiSql(e, loi, "cập nhật");
            hienThiForm(req, resp, dm, loi, CHE_DO_SUA);
        }
    }

    // ================================================================ XÓA (T8)

    /**
     * POST /xoa: chỉ xóa khi danh mục không còn sản phẩm (BR11, FK_SanPham_DanhMuc NO ACTION).
     * Còn sản phẩm -> từ chối và gợi ý chuyển "Ngừng hoạt động". Luôn quay lại đúng trang danh sách đang xem.
     */
    private void xuLyXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String urlQuayLai = WebUtil.taoUrlDanhSach(req, URL_DANH_SACH);
        int ma = WebUtil.docSoNguyenDuong(req.getParameter("maDanhMuc"), -1);
        if (ma < 1) {
            WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI, "Mã danh mục không hợp lệ.", urlQuayLai);
            return;
        }
        try {
            DanhMuc dm = danhMucDAO.timTheoMa(ma);
            if (dm == null) {
                WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI,
                        "Không tìm thấy danh mục mã " + ma + " (có thể đã bị xóa trước đó).", urlQuayLai);
                return;
            }
            // Lớp kiểm tra 1: đếm sản phẩm trước khi xóa để báo lỗi rõ ràng
            int soSanPham = danhMucDAO.demSanPham(ma);
            if (soSanPham > 0) {
                WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI, thongBaoConSanPham(dm.getTenDanhMuc(), soSanPham), urlQuayLai);
                return;
            }
            if (!danhMucDAO.xoa(ma)) {
                WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI,
                        "Không tìm thấy danh mục mã " + ma + " (có thể đã bị xóa trước đó).", urlQuayLai);
                return;
            }
            WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_THANH_CONG,
                    "Đã xóa danh mục \"" + dm.getTenDanhMuc() + "\" (mã " + ma + ").", urlQuayLai);

        } catch (SQLException e) {
            getServletContext().log("Lỗi xóa danh mục mã " + ma + " (mã lỗi SQL " + e.getErrorCode() + ")", e);
            // Lớp kiểm tra 2: khóa ngoại trong DB chặn (VD: có sản phẩm vừa được thêm vào danh mục ngay trước khi xóa)
            String thongBao = WebUtil.laLoiRangBuoc(e)
                    ? "Không thể xóa danh mục mã " + ma + " vì đang có sản phẩm thuộc danh mục này."
                    : "Không xóa được danh mục do lỗi cơ sở dữ liệu. Vui lòng thử lại hoặc kiểm tra log của Tomcat.";
            WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI, thongBao, urlQuayLai);
        }
    }

    private static String thongBaoConSanPham(String tenDanhMuc, int soSanPham) {
        return "Không thể xóa danh mục \"" + tenDanhMuc + "\" vì đang có " + soSanPham + " sản phẩm. "
                + "Nếu không muốn dùng danh mục này nữa, hãy bấm Sửa và bỏ chọn \"Đang hoạt động\".";
    }

    // ================================================================ HỖ TRỢ DÙNG CHUNG

    /** Kiểm tra trùng tên / đường dẫn trên DB (chỉ khi ô đó đã đúng định dạng). boQuaMa = mã đang sửa, null khi thêm. */
    private void kiemTraTrung(DanhMuc dm, Integer boQuaMa, Map<String, String> loi) throws SQLException {
        if (!loi.containsKey("tenDanhMuc") && danhMucDAO.tonTaiTen(dm.getTenDanhMuc(), boQuaMa)) {
            loi.put("tenDanhMuc", "Tên danh mục \"" + dm.getTenDanhMuc() + "\" đã tồn tại.");
        }
        if (!loi.containsKey("duongDanUrl") && danhMucDAO.tonTaiDuongDan(dm.getDuongDanUrl(), boQuaMa)) {
            loi.put("duongDanUrl", "Đường dẫn URL \"" + dm.getDuongDanUrl() + "\" đã được danh mục khác sử dụng.");
        }
    }

    /** Lớp bảo vệ thứ hai: chuyển lỗi SQL Server thành thông báo dễ hiểu; chi tiết ghi vào log. */
    private void ghiLoiSql(SQLException e, Map<String, String> loi, String hanhDong) {
        int ma = e.getErrorCode();
        if (WebUtil.laLoiTrung(e)) {
            loi.put("chung", "Tên hoặc đường dẫn URL vừa bị trùng với danh mục khác. Vui lòng kiểm tra lại.");
        } else if (WebUtil.laLoiRangBuoc(e)) {
            loi.put("chung", "Dữ liệu không thỏa ràng buộc của cơ sở dữ liệu.");
        } else {
            loi.put("chung", "Không " + hanhDong + " được danh mục do lỗi cơ sở dữ liệu. "
                    + "Vui lòng thử lại hoặc kiểm tra log của Tomcat.");
        }
        getServletContext().log("Lỗi " + hanhDong + " danh mục (mã lỗi SQL " + ma + ")", e);
    }

    /** Đặt thông báo lỗi (flash) rồi chuyển hướng về trang danh sách. */
    private static void veDanhSachKemLoi(HttpServletRequest req, HttpServletResponse resp, String thongBao)
            throws IOException {
        WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI, thongBao, req.getContextPath() + URL_DANH_SACH);
    }

    // ================================================================ ĐỌC VÀ KIỂM TRA FORM

    /** Đọc dữ liệu từ form, chuẩn hóa khoảng trắng; đường dẫn để trống thì tự tạo từ tên. */
    private static DanhMuc docForm(HttpServletRequest req) {
        DanhMuc dm = new DanhMuc();
        // NFC: gom chữ và dấu thành 1 ký tự (một số bộ gõ gửi dấu tách rời), để so sánh trùng và đếm độ dài đúng
        String ten = WebUtil.chuanHoa(req.getParameter("tenDanhMuc")).replaceAll("\\s+", " ");
        dm.setTenDanhMuc(ten);

        String duongDan = WebUtil.chuanHoa(req.getParameter("duongDanUrl")).toLowerCase();
        dm.setDuongDanUrl(duongDan.isEmpty() ? SlugUtil.taoDuongDan(ten, DanhMuc.DUONG_DAN_TOI_DA) : duongDan);

        String moTa = WebUtil.chuanHoa(req.getParameter("moTa"));
        dm.setMoTa(moTa.isEmpty() ? null : moTa);

        // Checkbox: có tham số khi được đánh dấu, không có khi bỏ dấu
        dm.setDangHoatDong(req.getParameter("dangHoatDong") != null);
        return dm;
    }

    /** Kiểm tra định dạng / độ dài. Trả về map: tên ô -> thông báo lỗi (rỗng = hợp lệ). */
    private static Map<String, String> kiemTraDuLieu(DanhMuc dm) {
        Map<String, String> loi = new LinkedHashMap<>();

        String ten = dm.getTenDanhMuc();
        if (ten.isEmpty()) {
            loi.put("tenDanhMuc", "Vui lòng nhập tên danh mục.");
        } else if (ten.length() < TEN_TOI_THIEU || ten.length() > DanhMuc.TEN_TOI_DA) {
            loi.put("tenDanhMuc", "Tên danh mục phải từ " + TEN_TOI_THIEU + " đến " + DanhMuc.TEN_TOI_DA + " ký tự.");
        }

        String duongDan = dm.getDuongDanUrl();
        if (duongDan.isEmpty()) {
            if (!loi.containsKey("tenDanhMuc")) {
                loi.put("duongDanUrl", "Không tạo được đường dẫn từ tên này. Vui lòng tự nhập đường dẫn (chỉ a-z, 0-9, dấu -).");
            }
        } else if (duongDan.length() > DanhMuc.DUONG_DAN_TOI_DA) {
            loi.put("duongDanUrl", "Đường dẫn URL tối đa " + DanhMuc.DUONG_DAN_TOI_DA + " ký tự.");
        } else if (!SlugUtil.hopLe(duongDan)) {
            loi.put("duongDanUrl", "Đường dẫn URL chỉ gồm chữ thường không dấu a-z, số 0-9 và dấu - giữa các từ "
                    + "(VD: do-hoa-ky-thuat).");
        }

        if (dm.getMoTa() != null && dm.getMoTa().length() > DanhMuc.MO_TA_TOI_DA) {
            loi.put("moTa", "Mô tả tối đa " + DanhMuc.MO_TA_TOI_DA + " ký tự.");
        }
        return loi;
    }
}
