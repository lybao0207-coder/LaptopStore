package vn.edu.stu.laptopshop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import vn.edu.stu.laptopshop.entities.BoXuLy;
import vn.edu.stu.laptopshop.utils.DBContext;
import vn.edu.stu.laptopshop.utils.SqlUtil;

/**
 * Truy cập bảng {@code dbo.BoXuLy} (CPU). Cùng cách tổ chức với DanhMucDAO.
 * Tìm kiếm theo tên model, dòng chip hoặc hãng.
 */
public class BoXuLyDAO {

    private static final String COT_DANH_SACH =
            "b.MaBoXuLy, b.HangSanXuat, b.DongChip, b.TenModel, b.SoNhan, b.SoLuongLuong, b.XungNhipToiDaGHz, "
            + "(SELECT COUNT(*) FROM dbo.SanPham s WHERE s.MaBoXuLy = b.MaBoXuLy) AS SoSanPham";

    private static final String DIEU_KIEN_TIM = " WHERE (? = N'' OR b.TenModel LIKE ? ESCAPE '!' "
            + "OR b.DongChip LIKE ? ESCAPE '!' OR b.HangSanXuat LIKE ? ESCAPE '!')";

    // ================================================================ ĐỌC

    /** Tìm theo model / dòng chip / hãng, phân trang OFFSET/FETCH. */
    public List<BoXuLy> timKiem(String tuKhoa, int trang, int kichThuoc) throws SQLException {
        String sql = "SELECT " + COT_DANH_SACH + " FROM dbo.BoXuLy b" + DIEU_KIEN_TIM
                + " ORDER BY b.MaBoXuLy OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        List<BoXuLy> ds = new ArrayList<>();
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            int i = ganThamSoTim(ps, tuKhoa);
            ps.setInt(i++, (Math.max(trang, 1) - 1) * kichThuoc);
            ps.setInt(i, kichThuoc);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ds.add(docDong(rs));
                }
            }
        }
        return ds;
    }

    public int demTimKiem(String tuKhoa) throws SQLException {
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM dbo.BoXuLy b" + DIEU_KIEN_TIM)) {
            ganThamSoTim(ps, tuKhoa);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    public BoXuLy timTheoMa(int maBoXuLy) throws SQLException {
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT " + COT_DANH_SACH + " FROM dbo.BoXuLy b WHERE b.MaBoXuLy = ?")) {
            ps.setInt(1, maBoXuLy);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? docDong(rs) : null;
            }
        }
    }

    /**
     * Dữ liệu cho COMBO BOX chọn CPU (D34). Bảng không có cột trạng thái nên lấy TẤT CẢ,
     * sắp theo hãng, dòng chip, tên model. Nhãn hiển thị gợi ý: {@link BoXuLy#getNhanComboBox()}.
     */
    public List<BoXuLy> layDanhSachChoComboBox() throws SQLException {
        String sql = "SELECT " + COT_DANH_SACH + " FROM dbo.BoXuLy b ORDER BY b.HangSanXuat, b.DongChip, b.TenModel";
        List<BoXuLy> ds = new ArrayList<>();
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ds.add(docDong(rs));
            }
        }
        return ds;
    }

    /** Tên model đã tồn tại chưa (UQ_BoXuLy_TenModel, không phân biệt hoa thường). */
    public boolean tonTaiTenModel(String tenModel, Integer boQuaMa) throws SQLException {
        String sql = "SELECT COUNT(*) FROM dbo.BoXuLy WHERE TenModel = ?" + (boQuaMa != null ? " AND MaBoXuLy <> ?" : "");
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, tenModel);
            if (boQuaMa != null) {
                ps.setInt(2, boQuaMa);
            }
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1) > 0;
            }
        }
    }

    public int demSanPham(int maBoXuLy) throws SQLException {
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM dbo.SanPham WHERE MaBoXuLy = ?")) {
            ps.setInt(1, maBoXuLy);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    // ================================================================ GHI

    public int them(BoXuLy cpu) throws SQLException {
        String sql = "INSERT INTO dbo.BoXuLy (HangSanXuat, DongChip, TenModel, SoNhan, SoLuongLuong, XungNhipToiDaGHz) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ganThamSoGhi(ps, cpu);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
            throw new SQLException("Không lấy được mã CPU vừa thêm.");
        }
    }

    public boolean capNhat(BoXuLy cpu) throws SQLException {
        String sql = "UPDATE dbo.BoXuLy SET HangSanXuat = ?, DongChip = ?, TenModel = ?, SoNhan = ?, SoLuongLuong = ?, "
                + "XungNhipToiDaGHz = ? WHERE MaBoXuLy = ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ganThamSoGhi(ps, cpu);
            ps.setInt(7, cpu.getMaBoXuLy());
            return ps.executeUpdate() == 1;
        }
    }

    public boolean xoa(int maBoXuLy) throws SQLException {
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM dbo.BoXuLy WHERE MaBoXuLy = ?")) {
            ps.setInt(1, maBoXuLy);
            return ps.executeUpdate() == 1;
        }
    }

    // ================================================================ HỖ TRỢ

    /** Gán 4 tham số tìm kiếm; trả về vị trí tham số tiếp theo. */
    private static int ganThamSoTim(PreparedStatement ps, String tuKhoa) throws SQLException {
        String tk = SqlUtil.chuanHoaTuKhoa(tuKhoa);
        String mau = SqlUtil.taoMauLike(tk);
        ps.setString(1, tk);
        ps.setString(2, mau);
        ps.setString(3, mau);
        ps.setString(4, mau);
        return 5;
    }

    /** Gán 6 tham số cột dữ liệu theo thứ tự HangSanXuat, DongChip, TenModel, SoNhan, SoLuongLuong, XungNhip. */
    private static void ganThamSoGhi(PreparedStatement ps, BoXuLy cpu) throws SQLException {
        ps.setString(1, cpu.getHangSanXuat());
        ps.setString(2, cpu.getDongChip());
        ps.setString(3, cpu.getTenModel());
        ps.setInt(4, cpu.getSoNhan());
        ps.setInt(5, cpu.getSoLuongLuong());
        if (cpu.getXungNhipToiDaGHz() == null) {
            ps.setNull(6, Types.DECIMAL);
        } else {
            ps.setBigDecimal(6, cpu.getXungNhipToiDaGHz());
        }
    }

    private static BoXuLy docDong(ResultSet rs) throws SQLException {
        BoXuLy cpu = new BoXuLy();
        cpu.setMaBoXuLy(rs.getInt("MaBoXuLy"));
        cpu.setHangSanXuat(rs.getString("HangSanXuat"));
        cpu.setDongChip(rs.getString("DongChip"));
        cpu.setTenModel(rs.getString("TenModel"));
        cpu.setSoNhan(rs.getInt("SoNhan"));
        cpu.setSoLuongLuong(rs.getInt("SoLuongLuong"));
        cpu.setXungNhipToiDaGHz(rs.getBigDecimal("XungNhipToiDaGHz"));   // NULL -> null
        cpu.setSoSanPham(rs.getInt("SoSanPham"));
        return cpu;
    }
}
