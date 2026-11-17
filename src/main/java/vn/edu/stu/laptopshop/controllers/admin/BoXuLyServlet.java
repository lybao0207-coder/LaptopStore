package vn.edu.stu.laptopshop.controllers.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;
import vn.edu.stu.laptopshop.dao.BoXuLyDAO;
import vn.edu.stu.laptopshop.entities.BoXuLy;
import vn.edu.stu.laptopshop.utils.WebUtil;

/**
 * Controller quản lý CPU (bảng BoXuLy) - khu vực Admin (Nhiệm vụ 2, T11). Cùng luồng xử lý với DanhMucServlet.
 *
 * <pre>
 * GET  /admin/cpu?tuKhoa=...&amp;trang=...   Danh sách + tìm theo model / dòng chip / hãng + phân trang
 * GET  /admin/cpu/them, POST /admin/cpu/them  Thêm
 * GET  /admin/cpu/sua?ma=..., POST /admin/cpu/sua  Sửa
 * POST /admin/cpu/xoa                         Xóa nếu không còn sản phẩm dùng CPU (FK_SanPham_BoXuLy)
 * </pre>
 */
@WebServlet("/admin/cpu/*")
public class BoXuLyServlet extends HttpServlet {

    private static final String VIEW_DANH_SACH = "/WEB-INF/views/admin/cpu/list.jsp";
    private static final String VIEW_FORM = "/WEB-INF/views/admin/cpu/form.jsp";
    private static final String URL_DANH_SACH = "/admin/cpu";
    private static final String CHE_DO_THEM = "them";
    private static final String CHE_DO_SUA = "sua";
    private static final int KICH_THUOC_TRANG = 10;
    private static final int TU_KHOA_TOI_DA = 50;

    private final BoXuLyDAO boXuLyDAO = new BoXuLyDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String duongDanCon = req.getPathInfo();
        if (duongDanCon == null || "/".equals(duongDanCon)) {
            hienThiDanhSach(req, resp);
        } else if ("/them".equals(duongDanCon)) {
            hienThiForm(req, resp, new BoXuLy(), new LinkedHashMap<>(), CHE_DO_THEM);
        } else if ("/sua".equals(duongDanCon)) {
            hienThiFormSua(req, resp);
        } else if ("/xoa".equals(duongDanCon)) {
            resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);   // xóa bắt buộc dùng POST
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String duongDanCon = req.getPathInfo();
        if ("/them".equals(duongDanCon)) {
            xuLyLuu(req, resp, CHE_DO_THEM);
        } else if ("/sua".equals(duongDanCon)) {
            xuLyLuu(req, resp, CHE_DO_SUA);
        } else if ("/xoa".equals(duongDanCon)) {
            xuLyXoa(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ================================================================ DANH SÁCH

    private void hienThiDanhSach(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String tuKhoa = WebUtil.chuanHoa(req.getParameter("tuKhoa"));
        if (tuKhoa.length() > TU_KHOA_TOI_DA) {
            tuKhoa = tuKhoa.substring(0, TU_KHOA_TOI_DA);
        }
        int trang = WebUtil.docSoNguyenDuong(req.getParameter("trang"), 1);
        try {
            int tongSo = boXuLyDAO.demTimKiem(tuKhoa);
            int tongTrang = Math.max(1, (tongSo + KICH_THUOC_TRANG - 1) / KICH_THUOC_TRANG);
            trang = Math.min(trang, tongTrang);
            req.setAttribute("danhSach", boXuLyDAO.timKiem(tuKhoa, trang, KICH_THUOC_TRANG));
            req.setAttribute("tongSo", tongSo);
            req.setAttribute("tongTrang", tongTrang);
            req.setAttribute("trang", trang);
            req.setAttribute("sttBatDau", (trang - 1) * KICH_THUOC_TRANG);
        } catch (SQLException e) {
            getServletContext().log("Lỗi tải danh sách CPU", e);
            req.setAttribute("loiTaiDuLieu", "Không tải được danh sách CPU do lỗi cơ sở dữ liệu. Vui lòng kiểm tra log của Tomcat.");
        }
        req.setAttribute("tuKhoa", tuKhoa);
        req.setAttribute("tieuDe", "Quản lý CPU");
        req.setAttribute("menuHienTai", "cpu");
        req.getRequestDispatcher(VIEW_DANH_SACH).forward(req, resp);
    }

    // ================================================================ THÊM / SỬA

    private void hienThiForm(HttpServletRequest req, HttpServletResponse resp, BoXuLy cpu,
                             Map<String, String> loi, String cheDo) throws ServletException, IOException {
        req.setAttribute("cpu", cpu);
        req.setAttribute("loi", loi);
        req.setAttribute("cheDo", cheDo);
        req.setAttribute("danhSachHang", BoXuLy.HANG_HOP_LE);
        req.setAttribute("tieuDe", CHE_DO_SUA.equals(cheDo) ? "Sửa CPU" : "Thêm CPU");
        req.setAttribute("menuHienTai", "cpu");
        req.getRequestDispatcher(VIEW_FORM).forward(req, resp);
    }

    private void hienThiFormSua(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int ma = WebUtil.docSoNguyenDuong(req.getParameter("ma"), -1);
        if (ma < 1) {
            veDanhSachKemLoi(req, resp, "Mã CPU không hợp lệ.");
            return;
        }
        try {
            BoXuLy cpu = boXuLyDAO.timTheoMa(ma);
            if (cpu == null) {
                veDanhSachKemLoi(req, resp, "Không tìm thấy CPU mã " + ma + " (có thể đã bị xóa).");
                return;
            }
            hienThiForm(req, resp, cpu, new LinkedHashMap<>(), CHE_DO_SUA);
        } catch (SQLException e) {
            getServletContext().log("Lỗi tải CPU để sửa, mã " + ma, e);
            veDanhSachKemLoi(req, resp, "Không tải được CPU do lỗi cơ sở dữ liệu.");
        }
    }

    /** Xử lý chung cho thêm và sửa: đọc form -> kiểm tra -> kiểm tra trùng -> lưu -> về danh sách. */
    private void xuLyLuu(HttpServletRequest req, HttpServletResponse resp, String cheDo)
            throws ServletException, IOException {
        boolean laSua = CHE_DO_SUA.equals(cheDo);
        Integer ma = null;
        if (laSua) {
            ma = WebUtil.docSoNguyenDuong(req.getParameter("maBoXuLy"), -1);
            if (ma < 1) {
                veDanhSachKemLoi(req, resp, "Mã CPU không hợp lệ.");
                return;
            }
        }
        Map<String, String> loi = new LinkedHashMap<>();
        BoXuLy cpu = docVaKiemTraForm(req, loi);
        try {
            if (laSua) {
                BoXuLy hienTai = boXuLyDAO.timTheoMa(ma);
                if (hienTai == null) {
                    veDanhSachKemLoi(req, resp, "Không tìm thấy CPU mã " + ma + " (có thể đã bị xóa).");
                    return;
                }
                cpu.setMaBoXuLy(ma);
                cpu.setSoSanPham(hienTai.getSoSanPham());
            }
            if (!loi.containsKey("tenModel") && boXuLyDAO.tonTaiTenModel(cpu.getTenModel(), ma)) {
                loi.put("tenModel", "Model \"" + cpu.getTenModel() + "\" đã tồn tại.");
            }
            if (!loi.isEmpty()) {
                hienThiForm(req, resp, cpu, loi, cheDo);
                return;
            }
            String thongBao;
            if (laSua) {
                if (!boXuLyDAO.capNhat(cpu)) {
                    veDanhSachKemLoi(req, resp, "Không cập nhật được: CPU mã " + ma + " không còn tồn tại.");
                    return;
                }
                thongBao = "Đã cập nhật CPU \"" + cpu.getTenModel() + "\" (mã " + ma + ").";
            } else {
                thongBao = "Đã thêm CPU \"" + cpu.getTenModel() + "\" (mã " + boXuLyDAO.them(cpu) + ").";
            }
            WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_THANH_CONG, thongBao, req.getContextPath() + URL_DANH_SACH);

        } catch (SQLException e) {
            if (WebUtil.laLoiTrung(e)) {
                loi.put("chung", "Model vừa bị trùng với CPU khác. Vui lòng kiểm tra lại.");
            } else if (WebUtil.laLoiRangBuoc(e)) {
                loi.put("chung", "Dữ liệu không thỏa ràng buộc của cơ sở dữ liệu (hãng, số nhân, số luồng, xung nhịp).");
            } else {
                loi.put("chung", "Không lưu được CPU do lỗi cơ sở dữ liệu. Vui lòng kiểm tra log của Tomcat.");
            }
            getServletContext().log("Lỗi lưu CPU (mã lỗi SQL " + e.getErrorCode() + ")", e);
            hienThiForm(req, resp, cpu, loi, cheDo);
        }
    }

    // ================================================================ XÓA

    private void xuLyXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String urlQuayLai = WebUtil.taoUrlDanhSach(req, URL_DANH_SACH);
        int ma = WebUtil.docSoNguyenDuong(req.getParameter("maBoXuLy"), -1);
        if (ma < 1) {
            WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI, "Mã CPU không hợp lệ.", urlQuayLai);
            return;
        }
        try {
            BoXuLy cpu = boXuLyDAO.timTheoMa(ma);
            if (cpu == null) {
                WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI,
                        "Không tìm thấy CPU mã " + ma + " (có thể đã bị xóa trước đó).", urlQuayLai);
                return;
            }
            int soSanPham = boXuLyDAO.demSanPham(ma);
            if (soSanPham > 0) {
                WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI, "Không thể xóa CPU \"" + cpu.getTenModel()
                        + "\" vì đang có " + soSanPham + " sản phẩm sử dụng.", urlQuayLai);
                return;
            }
            if (!boXuLyDAO.xoa(ma)) {
                WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI,
                        "Không tìm thấy CPU mã " + ma + " (có thể đã bị xóa trước đó).", urlQuayLai);
                return;
            }
            WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_THANH_CONG,
                    "Đã xóa CPU \"" + cpu.getTenModel() + "\" (mã " + ma + ").", urlQuayLai);
        } catch (SQLException e) {
            getServletContext().log("Lỗi xóa CPU mã " + ma + " (mã lỗi SQL " + e.getErrorCode() + ")", e);
            WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI, WebUtil.laLoiRangBuoc(e)
                    ? "Không thể xóa CPU mã " + ma + " vì đang có sản phẩm sử dụng."
                    : "Không xóa được CPU do lỗi cơ sở dữ liệu. Vui lòng kiểm tra log của Tomcat.", urlQuayLai);
        }
    }

    // ================================================================ ĐỌC VÀ KIỂM TRA FORM

    /** Đọc form vào đối tượng và ghi lỗi từng ô vào {@code loi} (theo đúng các CHECK của bảng BoXuLy). */
    private static BoXuLy docVaKiemTraForm(HttpServletRequest req, Map<String, String> loi) {
        BoXuLy cpu = new BoXuLy();

        String hang = WebUtil.chuanHoa(req.getParameter("hangSanXuat"));
        cpu.setHangSanXuat(hang);
        if (!BoXuLy.HANG_HOP_LE.contains(hang)) {
            loi.put("hangSanXuat", "Vui lòng chọn hãng: " + String.join(", ", BoXuLy.HANG_HOP_LE) + ".");
        }

        cpu.setDongChip(WebUtil.docChuoiAscii(req, "dongChip", "Dòng chip", BoXuLy.DONG_CHIP_TOI_DA, loi));
        cpu.setTenModel(WebUtil.docChuoiAscii(req, "tenModel", "Tên model", BoXuLy.TEN_MODEL_TOI_DA, loi));

        cpu.setSoNhan(WebUtil.docSoNguyenTrongKhoang(req, "soNhan", "Số nhân",
                BoXuLy.SO_NHAN_TOI_THIEU, BoXuLy.SO_NHAN_TOI_DA, true, loi));
        cpu.setSoLuongLuong(WebUtil.docSoNguyenTrongKhoang(req, "soLuongLuong", "Số luồng",
                1, BoXuLy.SO_LUONG_TOI_DA, true, loi));
        if (cpu.getSoNhan() != null && cpu.getSoLuongLuong() != null && cpu.getSoLuongLuong() < cpu.getSoNhan()) {
            loi.put("soLuongLuong", "Số luồng phải lớn hơn hoặc bằng số nhân (" + cpu.getSoNhan() + ").");
        }

        // Xung nhịp: không bắt buộc; chấp nhận dấu phẩy hoặc dấu chấm; DECIMAL(3,2) -> tối đa 2 chữ số thập phân
        String xung = WebUtil.chuanHoa(req.getParameter("xungNhipToiDaGHz")).replace(',', '.');
        if (!xung.isEmpty()) {
            if (!xung.matches("\\d(\\.\\d{1,2})?")) {
                loi.put("xungNhipToiDaGHz", "Xung nhịp là số từ 1 đến 7, tối đa 2 chữ số thập phân (VD: 4.5 hoặc 4,50).");
            } else {
                BigDecimal giaTri = new BigDecimal(xung);
                if (giaTri.compareTo(BoXuLy.XUNG_TOI_THIEU) < 0 || giaTri.compareTo(BoXuLy.XUNG_TOI_DA) > 0) {
                    loi.put("xungNhipToiDaGHz", "Xung nhịp phải từ 1 đến 7 GHz.");
                } else {
                    cpu.setXungNhipToiDaGHz(giaTri);
                }
            }
        }
        return cpu;
    }

    private static void veDanhSachKemLoi(HttpServletRequest req, HttpServletResponse resp, String thongBao) throws IOException {
        WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI, thongBao, req.getContextPath() + URL_DANH_SACH);
    }
}
