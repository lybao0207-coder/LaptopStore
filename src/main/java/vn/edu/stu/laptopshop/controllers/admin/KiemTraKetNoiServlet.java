package vn.edu.stu.laptopshop.controllers.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import vn.edu.stu.laptopshop.dao.BoXuLyDAO;
import vn.edu.stu.laptopshop.dao.CardDoHoaDAO;
import vn.edu.stu.laptopshop.dao.DanhMucDAO;
import vn.edu.stu.laptopshop.dao.ThuongHieuDAO;
import vn.edu.stu.laptopshop.entities.BoXuLy;
import vn.edu.stu.laptopshop.entities.CardDoHoa;
import vn.edu.stu.laptopshop.entities.DanhMuc;
import vn.edu.stu.laptopshop.entities.ThuongHieu;
import vn.edu.stu.laptopshop.utils.DBContext;

/**
 * Trang TẠM THỜI kiểm tra kết nối CSDL (bước T2).
 *
 * <p>URL: {@code /admin/kiem-tra-ket-noi}. Chỉ chạy câu SELECT, không ghi dữ liệu.</p>
 * <p>T3: chuyển phần hiển thị sang JSP dùng layout Admin
 * ({@code /WEB-INF/views/admin/kiem-tra-ket-noi.jsp}); logic kiểm tra giữ nguyên.</p>
 * <p>Trang hiển thị thông tin kỹ thuật nên chỉ dùng trong môi trường phát triển local (D29).
 * Sẽ xóa hoặc bảo vệ bằng đăng nhập trước khi triển khai thật.</p>
 */
@WebServlet("/admin/kiem-tra-ket-noi")
public class KiemTraKetNoiServlet extends HttpServlet {

    private static final String VIEW = "/WEB-INF/views/admin/kiem-tra-ket-noi.jsp";

    private static final String SQL_KIEM_TRA =
            "SELECT DB_NAME() AS TenDatabase, "
            + "SUSER_SNAME() AS TaiKhoanDangNhap, "
            + "CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(50)) AS PhienBanSqlServer, "
            + "(SELECT COUNT(*) FROM dbo.DanhMuc) AS SoDanhMuc, "
            + "(SELECT COUNT(*) FROM dbo.ThuongHieu) AS SoThuongHieu";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // LinkedHashMap: giữ đúng thứ tự dòng khi hiển thị
        Map<String, String> thongTin = new LinkedHashMap<>();
        boolean thanhCong;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_KIEM_TRA);
             ResultSet rs = ps.executeQuery()) {

            thongTin.put("Chuỗi kết nối", DBContext.layUrl());
            thongTin.put("JDBC Driver", con.getMetaData().getDriverName() + " " + con.getMetaData().getDriverVersion());
            if (rs.next()) {
                thongTin.put("Database", rs.getString("TenDatabase"));
                thongTin.put("Tài khoản đăng nhập (Windows)", rs.getString("TaiKhoanDangNhap"));
                thongTin.put("Phiên bản SQL Server", rs.getString("PhienBanSqlServer"));
                thongTin.put("Số dòng bảng DanhMuc", String.valueOf(rs.getInt("SoDanhMuc")));
                thongTin.put("Số dòng bảng ThuongHieu", String.valueOf(rs.getInt("SoThuongHieu")));
            }
            thanhCong = true;

        } catch (SQLException e) {
            // Ghi log đầy đủ phía server để phân tích lỗi
            getServletContext().log("Kiểm tra kết nối CSDL thất bại", e);

            thongTin.put("Loại lỗi", e.getClass().getName());
            thongTin.put("Thông báo", e.getMessage());
            thongTin.put("SQLState / Mã lỗi", e.getSQLState() + " / " + e.getErrorCode());
            if (e.getCause() != null) {
                thongTin.put("Nguyên nhân gốc", e.getCause().getClass().getName() + ": " + e.getCause().getMessage());
            }
            thanhCong = false;
        }

        req.setAttribute("tieuDe", "Kiểm tra kết nối CSDL");
        req.setAttribute("menuHienTai", "");
        req.setAttribute("ketNoiThanhCong", thanhCong);
        req.setAttribute("thongTin", thongTin);
        if (thanhCong) {
            List<String[]> ketQua = kiemTraDanhMucDao();
            ketQua.addAll(kiemTraBangBenMotKhac());   // T10-T12
            req.setAttribute("ketQuaDao", ketQua);
        }
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    /**
     * T4: kiểm tra các hàm ĐỌC của DanhMucDAO trên dữ liệu thật (chỉ SELECT, không ghi DB).
     * Giá trị mong đợi dựa trên dữ liệu hiện có đã xác minh ở T0: 5 danh mục, MaDanhMuc 2 = "Gaming" có 14 sản phẩm.
     * Mỗi dòng: {nội dung kiểm tra, mong đợi, thực tế, "ĐẠT" / "KHÔNG ĐẠT"}.
     */
    private List<String[]> kiemTraDanhMucDao() {
        List<String[]> kq = new ArrayList<>();
        DanhMucDAO dao = new DanhMucDAO();
        try {
            ghi(kq, "demTimKiem(\"\") - tổng số danh mục", "5", String.valueOf(dao.demTimKiem("")));

            List<DanhMuc> trang1 = dao.timKiem("", 1, 10);
            StringBuilder ten = new StringBuilder();
            for (DanhMuc d : trang1) {
                ten.append(d.getMaDanhMuc()).append('-').append(d.getTenDanhMuc())
                   .append(" (").append(d.getSoSanPham()).append(" SP, ").append(d.getNgayTaoHienThi()).append("); ");
            }
            ghi(kq, "timKiem(\"\", trang 1, 10 dòng) - số dòng", "5", String.valueOf(trang1.size()));
            kq.add(new String[] {"Dữ liệu trang 1 (mã-tên, số SP, ngày tạo)", "5 danh mục, tổng 46 SP", ten.toString(), "XEM"});

            ghi(kq, "timKiem(\"\", trang 2, 3 dòng) - phân trang OFFSET/FETCH", "2",
                    String.valueOf(dao.timKiem("", 2, 3).size()));
            ghi(kq, "demTimKiem(\"gam\") - tìm không phân biệt hoa thường", "1", String.valueOf(dao.demTimKiem("gam")));
            ghi(kq, "demTimKiem(\"%\") - ký tự đặc biệt của LIKE được hiểu là ký tự thường", "0",
                    String.valueOf(dao.demTimKiem("%")));
            ghi(kq, "demTimKiem(\"' OR 1=1 --\") - chuỗi SQL Injection", "0",
                    String.valueOf(dao.demTimKiem("' OR 1=1 --")));

            DanhMuc dm2 = dao.timTheoMa(2);
            ghi(kq, "timTheoMa(2) - tên", "Gaming", dm2 == null ? "null" : dm2.getTenDanhMuc());
            ghi(kq, "timTheoMa(99999) - mã không tồn tại", "null", String.valueOf(dao.timTheoMa(99999)));
            ghi(kq, "tonTaiTen(\"GAMING\", null) - trùng tên khi thêm (khác hoa thường)", "true",
                    String.valueOf(dao.tonTaiTen("GAMING", null)));
            ghi(kq, "tonTaiTen(\"Gaming\", 2) - sửa chính nó, không tính là trùng", "false",
                    String.valueOf(dao.tonTaiTen("Gaming", 2)));
            ghi(kq, "tonTaiDuongDan(\"gaming\", null)", "true", String.valueOf(dao.tonTaiDuongDan("gaming", null)));
            ghi(kq, "demSanPham(2) - số SP của Gaming", "14", String.valueOf(dao.demSanPham(2)));

            // ---- T9.1: hàm combo box. So với chính dữ liệu trong DB nên đúng với mọi trạng thái dữ liệu ----
            List<DanhMuc> tatCa = dao.timKiem("", 1, 1000);
            List<Integer> maHoatDong = new ArrayList<>();
            Integer maNgung = null;
            for (DanhMuc d : tatCa) {
                if (d.isDangHoatDong()) {
                    maHoatDong.add(d.getMaDanhMuc());
                } else if (maNgung == null) {
                    maNgung = d.getMaDanhMuc();
                }
            }
            List<DanhMuc> combo = dao.layDanhSachChoComboBox(null);
            List<Integer> maCombo = new ArrayList<>();
            StringBuilder nhan = new StringBuilder();
            for (DanhMuc d : combo) {
                maCombo.add(d.getMaDanhMuc());
                nhan.append(d.getMaDanhMuc()).append('=').append(d.getTenDanhMuc()).append("; ");
            }
            ghi(kq, "layDanhSachChoComboBox(null) - số mục = số danh mục đang hoạt động",
                    String.valueOf(maHoatDong.size()), String.valueOf(combo.size()));
            ghi(kq, "layDanhSachChoComboBox(null) - chỉ chứa đúng các danh mục đang hoạt động", "true",
                    String.valueOf(maCombo.containsAll(maHoatDong) && maHoatDong.containsAll(maCombo)));
            kq.add(new String[] {"Combo box: thứ tự hiển thị (mã=tên)", "sắp theo tên tiếng Việt", nhan.toString(), "XEM"});
            if (maNgung != null) {
                final int maThu = maNgung;   // biến dùng trong lambda phải là final
                ghi(kq, "layDanhSachChoComboBox(null) - KHÔNG chứa danh mục ngừng hoạt động mã " + maThu, "false",
                        String.valueOf(maCombo.contains(maThu)));
                ghi(kq, "layDanhSachChoComboBox(" + maThu + ") - luôn kèm danh mục đang được chọn dù ngừng hoạt động", "true",
                        String.valueOf(dao.layDanhSachChoComboBox(maThu).stream().anyMatch(d -> d.getMaDanhMuc() == maThu)));
            } else {
                kq.add(new String[] {"Combo box với danh mục ngừng hoạt động", "cần 1 danh mục ngừng hoạt động",
                        "Hiện không có danh mục nào ngừng hoạt động nên chưa thử được ca này", "XEM"});
            }
        } catch (SQLException e) {
            getServletContext().log("Kiểm tra DanhMucDAO thất bại", e);
            kq.add(new String[] {"Lỗi khi chạy DanhMucDAO", "không có lỗi", e.getMessage(), "KHÔNG ĐẠT"});
        }
        return kq;
    }

    /**
     * T10-T12: kiểm tra các hàm ĐỌC (chỉ SELECT) của ThuongHieuDAO, BoXuLyDAO, CardDoHoaDAO,
     * tập trung vào hàm combo box. Giá trị mong đợi lấy từ CHÍNH dữ liệu trong DB (không ghi cứng số lượng),
     * riêng tổng số sản phẩm đếm trực tiếp bằng SELECT COUNT(*) FROM dbo.SanPham.
     */
    private List<String[]> kiemTraBangBenMotKhac() {
        List<String[]> kq = new ArrayList<>();
        try {
            String tongSanPham = String.valueOf(demTongSanPham());

            // ---- Thương hiệu: combo chỉ lấy thương hiệu đang hoạt động + luôn kèm mục đang chọn ----
            ThuongHieuDAO thDao = new ThuongHieuDAO();
            List<ThuongHieu> tatCaTh = thDao.timKiem("", 1, 1000);
            ghi(kq, "[Thương hiệu] timKiem(\"\") lấy đủ = demTimKiem(\"\")",
                    String.valueOf(thDao.demTimKiem("")), String.valueOf(tatCaTh.size()));
            ghi(kq, "[Thương hiệu] tổng soSanPham các dòng = tổng số sản phẩm", tongSanPham,
                    String.valueOf(tatCaTh.stream().mapToInt(ThuongHieu::getSoSanPham).sum()));
            List<Integer> thHoatDong = new ArrayList<>();
            Integer thNgung = null;
            for (ThuongHieu t : tatCaTh) {
                if (t.isDangHoatDong()) {
                    thHoatDong.add(t.getMaThuongHieu());
                } else if (thNgung == null) {
                    thNgung = t.getMaThuongHieu();
                }
            }
            List<Integer> thCombo = new ArrayList<>();
            StringBuilder nhanTh = new StringBuilder();
            for (ThuongHieu t : thDao.layDanhSachChoComboBox(null)) {
                thCombo.add(t.getMaThuongHieu());
                nhanTh.append(t.getMaThuongHieu()).append('=').append(t.getTenThuongHieu()).append("; ");
            }
            ghi(kq, "[Thương hiệu] combo(null) chỉ chứa đúng các thương hiệu đang hoạt động", "true",
                    String.valueOf(thCombo.containsAll(thHoatDong) && thHoatDong.containsAll(thCombo)));
            kq.add(new String[] {"[Thương hiệu] combo: thứ tự hiển thị (mã=tên)", "sắp theo tên", nhanTh.toString(), "XEM"});
            if (thNgung != null) {
                final int maThu = thNgung;
                ghi(kq, "[Thương hiệu] combo(" + maThu + ") luôn kèm thương hiệu đang chọn dù ngừng hoạt động", "true",
                        String.valueOf(thDao.layDanhSachChoComboBox(maThu).stream().anyMatch(t -> t.getMaThuongHieu() == maThu)));
            } else {
                kq.add(new String[] {"[Thương hiệu] combo với thương hiệu ngừng hoạt động", "cần 1 thương hiệu ngừng hoạt động",
                        "Hiện không có thương hiệu nào ngừng hoạt động nên chưa thử được ca này", "XEM"});
            }

            // ---- CPU: bảng không có cột trạng thái nên combo lấy tất cả ----
            BoXuLyDAO cpuDao = new BoXuLyDAO();
            List<BoXuLy> tatCaCpu = cpuDao.timKiem("", 1, 1000);
            List<BoXuLy> cpuCombo = cpuDao.layDanhSachChoComboBox();
            ghi(kq, "[CPU] combo lấy tất cả: số mục = demTimKiem(\"\")",
                    String.valueOf(cpuDao.demTimKiem("")), String.valueOf(cpuCombo.size()));
            ghi(kq, "[CPU] tổng soSanPham các dòng = tổng số sản phẩm", tongSanPham,
                    String.valueOf(tatCaCpu.stream().mapToInt(BoXuLy::getSoSanPham).sum()));
            kq.add(new String[] {"[CPU] combo: 5 nhãn đầu", "sắp theo hãng, dòng chip, model", nhanDau(cpuCombo.stream()
                    .map(BoXuLy::getNhanComboBox).toList()), "XEM"});

            // ---- Card đồ họa ----
            CardDoHoaDAO gpuDao = new CardDoHoaDAO();
            List<CardDoHoa> tatCaGpu = gpuDao.timKiem("", 1, 1000);
            List<CardDoHoa> gpuCombo = gpuDao.layDanhSachChoComboBox();
            ghi(kq, "[Card đồ họa] combo lấy tất cả: số mục = demTimKiem(\"\")",
                    String.valueOf(gpuDao.demTimKiem("")), String.valueOf(gpuCombo.size()));
            ghi(kq, "[Card đồ họa] tổng soSanPham các dòng = tổng số sản phẩm", tongSanPham,
                    String.valueOf(tatCaGpu.stream().mapToInt(CardDoHoa::getSoSanPham).sum()));
            long saiQuyTac = tatCaGpu.stream().filter(g -> CardDoHoa.LOAI_ROI.equals(g.getLoaiCard())
                    ? g.getBoNhoVramGB() == null : g.getBoNhoVramGB() != null).count();
            ghi(kq, "[Card đồ họa] dữ liệu hiện có theo quy tắc form (rời có VRAM, tích hợp không VRAM) - số dòng lệch",
                    "0", String.valueOf(saiQuyTac));
            kq.add(new String[] {"[Card đồ họa] combo: 5 nhãn đầu", "sắp theo hãng, model", nhanDau(gpuCombo.stream()
                    .map(CardDoHoa::getNhanComboBox).toList()), "XEM"});
        } catch (SQLException e) {
            getServletContext().log("Kiểm tra DAO thương hiệu / CPU / card đồ họa thất bại", e);
            kq.add(new String[] {"Lỗi khi chạy DAO thương hiệu / CPU / card đồ họa", "không có lỗi", e.getMessage(), "KHÔNG ĐẠT"});
        }
        return kq;
    }

    private static int demTongSanPham() throws SQLException {
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM dbo.SanPham");
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getInt(1);
        }
    }

    private static String nhanDau(List<String> nhan) {
        return String.join("; ", nhan.subList(0, Math.min(5, nhan.size())));
    }

    private static void ghi(List<String[]> kq, String noiDung, String mongDoi, String thucTe) {
        kq.add(new String[] {noiDung, mongDoi, thucTe, mongDoi.equals(thucTe) ? "ĐẠT" : "KHÔNG ĐẠT"});
    }
}
