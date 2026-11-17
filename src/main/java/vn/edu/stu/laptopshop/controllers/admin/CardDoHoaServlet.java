package vn.edu.stu.laptopshop.controllers.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;
import vn.edu.stu.laptopshop.dao.CardDoHoaDAO;
import vn.edu.stu.laptopshop.entities.CardDoHoa;
import vn.edu.stu.laptopshop.utils.WebUtil;

/**
 * Controller quản lý card đồ họa (bảng CardDoHoa) - khu vực Admin (Nhiệm vụ 2, T12). Cùng luồng xử lý với DanhMucServlet.
 *
 * <pre>
 * GET  /admin/card-do-hoa?tuKhoa=...&amp;trang=...   Danh sách + tìm theo model / hãng + phân trang
 * GET  /admin/card-do-hoa/them, POST /admin/card-do-hoa/them  Thêm
 * GET  /admin/card-do-hoa/sua?ma=..., POST /admin/card-do-hoa/sua  Sửa
 * POST /admin/card-do-hoa/xoa                         Xóa nếu không còn sản phẩm dùng card đồ họa (FK_SanPham_CardDoHoa)
 * </pre>
 */
@WebServlet("/admin/card-do-hoa/*")
public class CardDoHoaServlet extends HttpServlet {

    private static final String VIEW_DANH_SACH = "/WEB-INF/views/admin/carddohoa/list.jsp";
    private static final String VIEW_FORM = "/WEB-INF/views/admin/carddohoa/form.jsp";
    private static final String URL_DANH_SACH = "/admin/card-do-hoa";
    private static final String CHE_DO_THEM = "them";
    private static final String CHE_DO_SUA = "sua";
    private static final int KICH_THUOC_TRANG = 10;
    private static final int TU_KHOA_TOI_DA = 60;

    private final CardDoHoaDAO cardDoHoaDAO = new CardDoHoaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String duongDanCon = req.getPathInfo();
        if (duongDanCon == null || "/".equals(duongDanCon)) {
            hienThiDanhSach(req, resp);
        } else if ("/them".equals(duongDanCon)) {
            hienThiForm(req, resp, new CardDoHoa(), new LinkedHashMap<>(), CHE_DO_THEM);
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
            int tongSo = cardDoHoaDAO.demTimKiem(tuKhoa);
            int tongTrang = Math.max(1, (tongSo + KICH_THUOC_TRANG - 1) / KICH_THUOC_TRANG);
            trang = Math.min(trang, tongTrang);
            req.setAttribute("danhSach", cardDoHoaDAO.timKiem(tuKhoa, trang, KICH_THUOC_TRANG));
            req.setAttribute("tongSo", tongSo);
            req.setAttribute("tongTrang", tongTrang);
            req.setAttribute("trang", trang);
            req.setAttribute("sttBatDau", (trang - 1) * KICH_THUOC_TRANG);
        } catch (SQLException e) {
            getServletContext().log("Lỗi tải danh sách card đồ họa", e);
            req.setAttribute("loiTaiDuLieu", "Không tải được danh sách card đồ họa do lỗi cơ sở dữ liệu. Vui lòng kiểm tra log của Tomcat.");
        }
        req.setAttribute("tuKhoa", tuKhoa);
        req.setAttribute("tieuDe", "Quản lý card đồ họa");
        req.setAttribute("menuHienTai", "card-do-hoa");
        req.getRequestDispatcher(VIEW_DANH_SACH).forward(req, resp);
    }

    // ================================================================ THÊM / SỬA

    private void hienThiForm(HttpServletRequest req, HttpServletResponse resp, CardDoHoa gpu,
                             Map<String, String> loi, String cheDo) throws ServletException, IOException {
        req.setAttribute("gpu", gpu);
        req.setAttribute("loi", loi);
        req.setAttribute("cheDo", cheDo);
        req.setAttribute("danhSachHang", CardDoHoa.HANG_HOP_LE);
        req.setAttribute("danhSachLoai", CardDoHoa.LOAI_HOP_LE);
        req.setAttribute("tieuDe", CHE_DO_SUA.equals(cheDo) ? "Sửa card đồ họa" : "Thêm card đồ họa");
        req.setAttribute("menuHienTai", "card-do-hoa");
        req.getRequestDispatcher(VIEW_FORM).forward(req, resp);
    }

    private void hienThiFormSua(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int ma = WebUtil.docSoNguyenDuong(req.getParameter("ma"), -1);
        if (ma < 1) {
            veDanhSachKemLoi(req, resp, "Mã card đồ họa không hợp lệ.");
            return;
        }
        try {
            CardDoHoa gpu = cardDoHoaDAO.timTheoMa(ma);
            if (gpu == null) {
                veDanhSachKemLoi(req, resp, "Không tìm thấy card đồ họa mã " + ma + " (có thể đã bị xóa).");
                return;
            }
            hienThiForm(req, resp, gpu, new LinkedHashMap<>(), CHE_DO_SUA);
        } catch (SQLException e) {
            getServletContext().log("Lỗi tải card đồ họa để sửa, mã " + ma, e);
            veDanhSachKemLoi(req, resp, "Không tải được card đồ họa do lỗi cơ sở dữ liệu.");
        }
    }

    /** Xử lý chung cho thêm và sửa: đọc form -> kiểm tra -> kiểm tra trùng -> lưu -> về danh sách. */
    private void xuLyLuu(HttpServletRequest req, HttpServletResponse resp, String cheDo)
            throws ServletException, IOException {
        boolean laSua = CHE_DO_SUA.equals(cheDo);
        Integer ma = null;
        if (laSua) {
            ma = WebUtil.docSoNguyenDuong(req.getParameter("maCardDoHoa"), -1);
            if (ma < 1) {
                veDanhSachKemLoi(req, resp, "Mã card đồ họa không hợp lệ.");
                return;
            }
        }
        Map<String, String> loi = new LinkedHashMap<>();
        CardDoHoa gpu = docVaKiemTraForm(req, loi);
        try {
            if (laSua) {
                CardDoHoa hienTai = cardDoHoaDAO.timTheoMa(ma);
                if (hienTai == null) {
                    veDanhSachKemLoi(req, resp, "Không tìm thấy card đồ họa mã " + ma + " (có thể đã bị xóa).");
                    return;
                }
                gpu.setMaCardDoHoa(ma);
                gpu.setSoSanPham(hienTai.getSoSanPham());
            }
            if (!loi.containsKey("tenModel") && cardDoHoaDAO.tonTaiTenModel(gpu.getTenModel(), ma)) {
                loi.put("tenModel", "Model \"" + gpu.getTenModel() + "\" đã tồn tại.");
            }
            if (!loi.isEmpty()) {
                hienThiForm(req, resp, gpu, loi, cheDo);
                return;
            }
            String thongBao;
            if (laSua) {
                if (!cardDoHoaDAO.capNhat(gpu)) {
                    veDanhSachKemLoi(req, resp, "Không cập nhật được: card đồ họa mã " + ma + " không còn tồn tại.");
                    return;
                }
                thongBao = "Đã cập nhật card đồ họa \"" + gpu.getTenModel() + "\" (mã " + ma + ").";
            } else {
                thongBao = "Đã thêm card đồ họa \"" + gpu.getTenModel() + "\" (mã " + cardDoHoaDAO.them(gpu) + ").";
            }
            WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_THANH_CONG, thongBao, req.getContextPath() + URL_DANH_SACH);

        } catch (SQLException e) {
            if (WebUtil.laLoiTrung(e)) {
                loi.put("chung", "Model vừa bị trùng với card đồ họa khác. Vui lòng kiểm tra lại.");
            } else if (WebUtil.laLoiRangBuoc(e)) {
                loi.put("chung", "Dữ liệu không thỏa ràng buộc của cơ sở dữ liệu (hãng, loại card, VRAM).");
            } else {
                loi.put("chung", "Không lưu được card đồ họa do lỗi cơ sở dữ liệu. Vui lòng kiểm tra log của Tomcat.");
            }
            getServletContext().log("Lỗi lưu card đồ họa (mã lỗi SQL " + e.getErrorCode() + ")", e);
            hienThiForm(req, resp, gpu, loi, cheDo);
        }
    }

    // ================================================================ XÓA

    private void xuLyXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String urlQuayLai = WebUtil.taoUrlDanhSach(req, URL_DANH_SACH);
        int ma = WebUtil.docSoNguyenDuong(req.getParameter("maCardDoHoa"), -1);
        if (ma < 1) {
            WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI, "Mã card đồ họa không hợp lệ.", urlQuayLai);
            return;
        }
        try {
            CardDoHoa gpu = cardDoHoaDAO.timTheoMa(ma);
            if (gpu == null) {
                WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI,
                        "Không tìm thấy card đồ họa mã " + ma + " (có thể đã bị xóa trước đó).", urlQuayLai);
                return;
            }
            int soSanPham = cardDoHoaDAO.demSanPham(ma);
            if (soSanPham > 0) {
                WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI, "Không thể xóa card đồ họa \"" + gpu.getTenModel()
                        + "\" vì đang có " + soSanPham + " sản phẩm sử dụng.", urlQuayLai);
                return;
            }
            if (!cardDoHoaDAO.xoa(ma)) {
                WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI,
                        "Không tìm thấy card đồ họa mã " + ma + " (có thể đã bị xóa trước đó).", urlQuayLai);
                return;
            }
            WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_THANH_CONG,
                    "Đã xóa card đồ họa \"" + gpu.getTenModel() + "\" (mã " + ma + ").", urlQuayLai);
        } catch (SQLException e) {
            getServletContext().log("Lỗi xóa card đồ họa mã " + ma + " (mã lỗi SQL " + e.getErrorCode() + ")", e);
            WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI, WebUtil.laLoiRangBuoc(e)
                    ? "Không thể xóa card đồ họa mã " + ma + " vì đang có sản phẩm sử dụng."
                    : "Không xóa được card đồ họa do lỗi cơ sở dữ liệu. Vui lòng kiểm tra log của Tomcat.", urlQuayLai);
        }
    }

    // ================================================================ ĐỌC VÀ KIỂM TRA FORM

    /**
     * Đọc form vào đối tượng và ghi lỗi từng ô vào {@code loi} theo đúng các CHECK của bảng CardDoHoa:
     * hãng trong danh sách cho phép; loại TICH_HOP / ROI; card rời bắt buộc VRAM 1-48 GB, card tích hợp để trống VRAM.
     */
    private static CardDoHoa docVaKiemTraForm(HttpServletRequest req, Map<String, String> loi) {
        CardDoHoa gpu = new CardDoHoa();

        String hang = WebUtil.chuanHoa(req.getParameter("hangSanXuat"));
        gpu.setHangSanXuat(hang);
        if (!CardDoHoa.HANG_HOP_LE.contains(hang)) {
            loi.put("hangSanXuat", "Vui lòng chọn hãng: " + String.join(", ", CardDoHoa.HANG_HOP_LE) + ".");
        }

        gpu.setTenModel(WebUtil.docChuoiAscii(req, "tenModel", "Tên model", CardDoHoa.TEN_MODEL_TOI_DA, loi));

        String loai = WebUtil.chuanHoa(req.getParameter("loaiCard"));
        gpu.setLoaiCard(loai);
        if (!CardDoHoa.LOAI_HOP_LE.containsKey(loai)) {
            loi.put("loaiCard", "Vui lòng chọn loại card: Tích hợp hoặc Rời.");
        }

        // VRAM: không bắt buộc ở bước đọc; quy tắc theo loại card kiểm tra ngay sau đó (CK_CardDoHoa_Vram)
        Integer vram = WebUtil.docSoNguyenTrongKhoang(req, "boNhoVramGB", "VRAM",
                CardDoHoa.VRAM_TOI_THIEU, CardDoHoa.VRAM_TOI_DA, false, loi);
        gpu.setBoNhoVramGB(vram);
        if (!loi.containsKey("boNhoVramGB")) {
            if (CardDoHoa.LOAI_ROI.equals(loai) && vram == null) {
                loi.put("boNhoVramGB", "Card rời phải có VRAM từ " + CardDoHoa.VRAM_TOI_THIEU + " đến "
                        + CardDoHoa.VRAM_TOI_DA + " GB.");
            } else if (CardDoHoa.LOAI_TICH_HOP.equals(loai) && vram != null) {
                loi.put("boNhoVramGB", "Card tích hợp dùng chung RAM, không có VRAM riêng - vui lòng để trống ô này.");
            }
        }
        return gpu;
    }

    private static void veDanhSachKemLoi(HttpServletRequest req, HttpServletResponse resp, String thongBao) throws IOException {
        WebUtil.datThongBaoVaChuyen(req, resp, WebUtil.THONG_BAO_LOI, thongBao, req.getContextPath() + URL_DANH_SACH);
    }
}
