package vn.edu.stu.laptopshop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import vn.edu.stu.laptopshop.entities.ThuongHieu;
import vn.edu.stu.laptopshop.utils.DBContext;
import vn.edu.stu.laptopshop.utils.SqlUtil;

/**
 * Truy cập bảng {@code dbo.ThuongHieu}. Cùng cách tổ chức với DanhMucDAO.
 * Cột DuongDanLogo: chỉ đọc để hiển thị; INSERT không ghi (NULL), UPDATE không đụng tới (giữ nguyên) - D30.
 */
public class ThuongHieuDAO {

    private static final String COT_DANH_SACH =
            "t.MaThuongHieu, t.TenThuongHieu, t.DuongDanUrl, t.QuocGia, t.DuongDanLogo, t.DangHoatDong, t.NgayTao, "
            + "(SELECT COUNT(*) FROM dbo.SanPham s WHERE s.MaThuongHieu = t.MaThuongHieu) AS SoSanPham";

    private static final String DIEU_KIEN_TIM = " WHERE (? = N'' OR t.TenThuongHieu LIKE ? ESCAPE '!')";

    // ================================================================ ĐỌC

    /** Tìm theo tên (chứa từ khóa), phân trang OFFSET/FETCH tại SQL Server. */
    public List<ThuongHieu> timKiem(String tuKhoa, int trang, int kichThuoc) throws SQLException {
        String tk = SqlUtil.chuanHoaTuKhoa(tuKhoa);
        String sql = "SELECT " + COT_DANH_SACH + " FROM dbo.ThuongHieu t" + DIEU_KIEN_TIM
                + " ORDER BY t.MaThuongHieu OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        List<ThuongHieu> ds = new ArrayList<>();
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, tk);
            ps.setString(2, SqlUtil.taoMauLike(tk));
            ps.setInt(3, (Math.max(trang, 1) - 1) * kichThuoc);
            ps.setInt(4, kichThuoc);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ds.add(docDong(rs));
                }
            }
        }
        return ds;
    }

    public int demTimKiem(String tuKhoa) throws SQLException {
        String tk = SqlUtil.chuanHoaTuKhoa(tuKhoa);
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM dbo.ThuongHieu t" + DIEU_KIEN_TIM)) {
            ps.setString(1, tk);
            ps.setString(2, SqlUtil.taoMauLike(tk));
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    /** Lấy 1 thương hiệu theo mã; null nếu không tồn tại. */
    public ThuongHieu timTheoMa(int maThuongHieu) throws SQLException {
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT " + COT_DANH_SACH + " FROM dbo.ThuongHieu t WHERE t.MaThuongHieu = ?")) {
            ps.setInt(1, maThuongHieu);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? docDong(rs) : null;
            }
        }
    }

    /**
     * Dữ liệu cho COMBO BOX chọn thương hiệu (D34): thương hiệu đang hoạt động, sắp theo tên.
     *
     * @param maLuonKem mã luôn được đưa vào kết quả dù đang ngừng hoạt động (form sửa sản phẩm); null nếu không cần
     */
    public List<ThuongHieu> layDanhSachChoComboBox(Integer maLuonKem) throws SQLException {
        String sql = "SELECT " + COT_DANH_SACH + " FROM dbo.ThuongHieu t "
                + "WHERE t.DangHoatDong = 1 OR t.MaThuongHieu = ? ORDER BY t.TenThuongHieu";
        List<ThuongHieu> ds = new ArrayList<>();
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maLuonKem == null ? -1 : maLuonKem);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ds.add(docDong(rs));
                }
            }
        }
        return ds;
    }

    /** Tên đã tồn tại chưa (không phân biệt hoa thường). boQuaMa = mã đang sửa, null khi thêm. */
    public boolean tonTaiTen(String ten, Integer boQuaMa) throws SQLException {
        return tonTai("TenThuongHieu", ten, boQuaMa);
    }

    public boolean tonTaiDuongDan(String duongDanUrl, Integer boQuaMa) throws SQLException {
        return tonTai("DuongDanUrl", duongDanUrl, boQuaMa);
    }

    /** Số sản phẩm thuộc thương hiệu (khác 0 thì không xóa được - FK_SanPham_ThuongHieu). */
    public int demSanPham(int maThuongHieu) throws SQLException {
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM dbo.SanPham WHERE MaThuongHieu = ?")) {
            ps.setInt(1, maThuongHieu);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    // ================================================================ GHI

    /** Thêm mới; DuongDanLogo không ghi (NULL), MaThuongHieu và NgayTao do DB sinh. Trả về mã mới. */
    public int them(ThuongHieu th) throws SQLException {
        String sql = "INSERT INTO dbo.ThuongHieu (TenThuongHieu, DuongDanUrl, QuocGia, DangHoatDong) VALUES (?, ?, ?, ?)";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setNString(1, th.getTenThuongHieu());
            ps.setString(2, th.getDuongDanUrl());
            ps.setNString(3, th.getQuocGia());
            ps.setBoolean(4, th.isDangHoatDong());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
            throw new SQLException("Không lấy được mã thương hiệu vừa thêm.");
        }
    }

    /** Cập nhật tên, đường dẫn, quốc gia, trạng thái. KHÔNG sửa MaThuongHieu, NgayTao, DuongDanLogo. */
    public boolean capNhat(ThuongHieu th) throws SQLException {
        String sql = "UPDATE dbo.ThuongHieu SET TenThuongHieu = ?, DuongDanUrl = ?, QuocGia = ?, DangHoatDong = ? "
                + "WHERE MaThuongHieu = ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setNString(1, th.getTenThuongHieu());
            ps.setString(2, th.getDuongDanUrl());
            ps.setNString(3, th.getQuocGia());
            ps.setBoolean(4, th.isDangHoatDong());
            ps.setInt(5, th.getMaThuongHieu());
            return ps.executeUpdate() == 1;
        }
    }

    /** Xóa; Servlet kiểm tra demSanPham trước, DB chặn thêm bằng FK (lỗi 547). */
    public boolean xoa(int maThuongHieu) throws SQLException {
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM dbo.ThuongHieu WHERE MaThuongHieu = ?")) {
            ps.setInt(1, maThuongHieu);
            return ps.executeUpdate() == 1;
        }
    }

    // ================================================================ HỖ TRỢ

    /** Tên cột là hằng số trong lớp này (không đến từ người dùng) nên ghép chuỗi an toàn. */
    private boolean tonTai(String cot, String giaTri, Integer boQuaMa) throws SQLException {
        String sql = "SELECT COUNT(*) FROM dbo.ThuongHieu WHERE " + cot + " = ?"
                + (boQuaMa != null ? " AND MaThuongHieu <> ?" : "");
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setNString(1, giaTri);
            if (boQuaMa != null) {
                ps.setInt(2, boQuaMa);
            }
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1) > 0;
            }
        }
    }

    private static ThuongHieu docDong(ResultSet rs) throws SQLException {
        ThuongHieu th = new ThuongHieu();
        th.setMaThuongHieu(rs.getInt("MaThuongHieu"));
        th.setTenThuongHieu(rs.getNString("TenThuongHieu"));
        th.setDuongDanUrl(rs.getString("DuongDanUrl"));
        th.setQuocGia(rs.getNString("QuocGia"));
        th.setDuongDanLogo(rs.getNString("DuongDanLogo"));
        th.setDangHoatDong(rs.getBoolean("DangHoatDong"));
        th.setNgayTao(rs.getObject("NgayTao", LocalDateTime.class));
        th.setSoSanPham(rs.getInt("SoSanPham"));
        return th;
    }
}
