package vn.edu.stu.laptopshop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import vn.edu.stu.laptopshop.entities.CardDoHoa;
import vn.edu.stu.laptopshop.utils.DBContext;
import vn.edu.stu.laptopshop.utils.SqlUtil;

/**
 * Truy cập bảng {@code dbo.CardDoHoa} (GPU). Cùng cách tổ chức với DanhMucDAO.
 * Tìm kiếm theo tên model hoặc hãng.
 */
public class CardDoHoaDAO {

    private static final String COT_DANH_SACH =
            "g.MaCardDoHoa, g.HangSanXuat, g.TenModel, g.LoaiCard, g.BoNhoVramGB, "
            + "(SELECT COUNT(*) FROM dbo.SanPham s WHERE s.MaCardDoHoa = g.MaCardDoHoa) AS SoSanPham";

    private static final String DIEU_KIEN_TIM =
            " WHERE (? = N'' OR g.TenModel LIKE ? ESCAPE '!' OR g.HangSanXuat LIKE ? ESCAPE '!')";

    // ================================================================ ĐỌC

    public List<CardDoHoa> timKiem(String tuKhoa, int trang, int kichThuoc) throws SQLException {
        String sql = "SELECT " + COT_DANH_SACH + " FROM dbo.CardDoHoa g" + DIEU_KIEN_TIM
                + " ORDER BY g.MaCardDoHoa OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        List<CardDoHoa> ds = new ArrayList<>();
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
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM dbo.CardDoHoa g" + DIEU_KIEN_TIM)) {
            ganThamSoTim(ps, tuKhoa);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    public CardDoHoa timTheoMa(int maCardDoHoa) throws SQLException {
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT " + COT_DANH_SACH + " FROM dbo.CardDoHoa g WHERE g.MaCardDoHoa = ?")) {
            ps.setInt(1, maCardDoHoa);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? docDong(rs) : null;
            }
        }
    }

    /**
     * Dữ liệu cho COMBO BOX chọn card đồ họa (D34). Bảng không có cột trạng thái nên lấy TẤT CẢ,
     * sắp theo hãng rồi tên model. Nhãn hiển thị gợi ý: {@link CardDoHoa#getNhanComboBox()}.
     */
    public List<CardDoHoa> layDanhSachChoComboBox() throws SQLException {
        String sql = "SELECT " + COT_DANH_SACH + " FROM dbo.CardDoHoa g ORDER BY g.HangSanXuat, g.TenModel";
        List<CardDoHoa> ds = new ArrayList<>();
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ds.add(docDong(rs));
            }
        }
        return ds;
    }

    public boolean tonTaiTenModel(String tenModel, Integer boQuaMa) throws SQLException {
        String sql = "SELECT COUNT(*) FROM dbo.CardDoHoa WHERE TenModel = ?" + (boQuaMa != null ? " AND MaCardDoHoa <> ?" : "");
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

    public int demSanPham(int maCardDoHoa) throws SQLException {
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM dbo.SanPham WHERE MaCardDoHoa = ?")) {
            ps.setInt(1, maCardDoHoa);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    // ================================================================ GHI

    public int them(CardDoHoa gpu) throws SQLException {
        String sql = "INSERT INTO dbo.CardDoHoa (HangSanXuat, TenModel, LoaiCard, BoNhoVramGB) VALUES (?, ?, ?, ?)";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ganThamSoGhi(ps, gpu);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
            throw new SQLException("Không lấy được mã card đồ họa vừa thêm.");
        }
    }

    public boolean capNhat(CardDoHoa gpu) throws SQLException {
        String sql = "UPDATE dbo.CardDoHoa SET HangSanXuat = ?, TenModel = ?, LoaiCard = ?, BoNhoVramGB = ? "
                + "WHERE MaCardDoHoa = ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ganThamSoGhi(ps, gpu);
            ps.setInt(5, gpu.getMaCardDoHoa());
            return ps.executeUpdate() == 1;
        }
    }

    public boolean xoa(int maCardDoHoa) throws SQLException {
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM dbo.CardDoHoa WHERE MaCardDoHoa = ?")) {
            ps.setInt(1, maCardDoHoa);
            return ps.executeUpdate() == 1;
        }
    }

    // ================================================================ HỖ TRỢ

    private static int ganThamSoTim(PreparedStatement ps, String tuKhoa) throws SQLException {
        String tk = SqlUtil.chuanHoaTuKhoa(tuKhoa);
        String mau = SqlUtil.taoMauLike(tk);
        ps.setString(1, tk);
        ps.setString(2, mau);
        ps.setString(3, mau);
        return 4;
    }

    private static void ganThamSoGhi(PreparedStatement ps, CardDoHoa gpu) throws SQLException {
        ps.setString(1, gpu.getHangSanXuat());
        ps.setString(2, gpu.getTenModel());
        ps.setString(3, gpu.getLoaiCard());
        if (gpu.getBoNhoVramGB() == null) {
            ps.setNull(4, Types.TINYINT);
        } else {
            ps.setInt(4, gpu.getBoNhoVramGB());
        }
    }

    private static CardDoHoa docDong(ResultSet rs) throws SQLException {
        CardDoHoa gpu = new CardDoHoa();
        gpu.setMaCardDoHoa(rs.getInt("MaCardDoHoa"));
        gpu.setHangSanXuat(rs.getString("HangSanXuat"));
        gpu.setTenModel(rs.getString("TenModel"));
        gpu.setLoaiCard(rs.getString("LoaiCard"));
        int vram = rs.getInt("BoNhoVramGB");
        gpu.setBoNhoVramGB(rs.wasNull() ? null : vram);    // TINYINT NULL -> null (getInt trả 0 nên phải kiểm tra wasNull)
        gpu.setSoSanPham(rs.getInt("SoSanPham"));
        return gpu;
    }
}
