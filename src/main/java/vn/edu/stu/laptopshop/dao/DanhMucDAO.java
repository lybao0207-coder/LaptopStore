package vn.edu.stu.laptopshop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import vn.edu.stu.laptopshop.entities.DanhMuc;
import vn.edu.stu.laptopshop.utils.DBContext;
import vn.edu.stu.laptopshop.utils.SqlUtil;

/**
 * Truy cập bảng {@code dbo.DanhMuc}.
 *
 * <p>Mọi câu lệnh dùng PreparedStatement (NF01), không nối chuỗi dữ liệu người dùng vào SQL.
 * Lỗi CSDL được ném ra dạng SQLException để Servlet quyết định thông báo cho người dùng.</p>
 * <p>So sánh chuỗi theo collation của DB ({@code Vietnamese_CI_AS}): không phân biệt hoa/thường,
 * có phân biệt dấu - giống cách ràng buộc UNIQUE của DB so sánh.</p>
 */
public class DanhMucDAO {

    /** Cột trả về cho danh sách: các cột của bảng + số sản phẩm đếm từ SanPham. */
    private static final String COT_DANH_SACH =
            "d.MaDanhMuc, d.TenDanhMuc, d.DuongDanUrl, d.MoTa, d.DangHoatDong, d.NgayTao, "
            + "(SELECT COUNT(*) FROM dbo.SanPham s WHERE s.MaDanhMuc = d.MaDanhMuc) AS SoSanPham";

    /** Điều kiện tìm theo tên; ESCAPE '!' để ký tự %, _, [ người dùng nhập được hiểu là ký tự thường. */
    private static final String DIEU_KIEN_TIM = " WHERE (? = N'' OR d.TenDanhMuc LIKE ? ESCAPE '!')";

    // ================================================================ ĐỌC

    /**
     * Tìm danh mục theo tên (chứa từ khóa) và phân trang tại SQL Server bằng OFFSET/FETCH.
     *
     * @param tuKhoa    từ khóa tìm theo tên; null hoặc rỗng = lấy tất cả
     * @param trang     số trang, bắt đầu từ 1
     * @param kichThuoc số dòng mỗi trang
     */
    public List<DanhMuc> timKiem(String tuKhoa, int trang, int kichThuoc) throws SQLException {
        String tk = SqlUtil.chuanHoaTuKhoa(tuKhoa);
        int trangHopLe = Math.max(trang, 1);
        String sql = "SELECT " + COT_DANH_SACH + " FROM dbo.DanhMuc d" + DIEU_KIEN_TIM
                + " ORDER BY d.MaDanhMuc OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        List<DanhMuc> ds = new ArrayList<>();
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, tk);
            ps.setString(2, SqlUtil.taoMauLike(tk));
            ps.setInt(3, (trangHopLe - 1) * kichThuoc);
            ps.setInt(4, kichThuoc);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ds.add(docDong(rs));
                }
            }
        }
        return ds;
    }

    /** Đếm tổng số danh mục khớp từ khóa (dùng để tính số trang). */
    public int demTimKiem(String tuKhoa) throws SQLException {
        String tk = SqlUtil.chuanHoaTuKhoa(tuKhoa);
        String sql = "SELECT COUNT(*) FROM dbo.DanhMuc d" + DIEU_KIEN_TIM;
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, tk);
            ps.setString(2, SqlUtil.taoMauLike(tk));
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    /** Lấy 1 danh mục theo mã; trả về null nếu không tồn tại. */
    public DanhMuc timTheoMa(int maDanhMuc) throws SQLException {
        String sql = "SELECT " + COT_DANH_SACH + " FROM dbo.DanhMuc d WHERE d.MaDanhMuc = ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maDanhMuc);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? docDong(rs) : null;
            }
        }
    }

    /**
     * Lấy dữ liệu cho COMBO BOX chọn danh mục (D34) - dùng chung cho bộ lọc phía User và form sản phẩm sau này.
     *
     * <p>Chỉ lấy danh mục đang hoạt động, sắp xếp theo tên (collation tiếng Việt của DB).
     * Giá trị option nên dùng {@code maDanhMuc}; nhãn hiển thị dùng {@code tenDanhMuc}.</p>
     *
     * @param maLuonKem mã danh mục luôn được đưa vào kết quả dù đang ngừng hoạt động
     *                  (VD: form sửa sản phẩm đang thuộc danh mục đã ngừng - vẫn phải hiện được giá trị cũ);
     *                  null nếu không cần
     */
    public List<DanhMuc> layDanhSachChoComboBox(Integer maLuonKem) throws SQLException {
        String sql = "SELECT " + COT_DANH_SACH + " FROM dbo.DanhMuc d "
                + "WHERE d.DangHoatDong = 1 OR d.MaDanhMuc = ? ORDER BY d.TenDanhMuc";
        List<DanhMuc> ds = new ArrayList<>();
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            // -1 không khớp mã nào (mã IDENTITY luôn >= 1) -> chỉ lấy danh mục đang hoạt động
            ps.setInt(1, maLuonKem == null ? -1 : maLuonKem);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ds.add(docDong(rs));
                }
            }
        }
        return ds;
    }

    /**
     * Kiểm tra tên đã có chưa (không phân biệt hoa/thường theo collation DB).
     *
     * @param boQuaMa mã danh mục đang sửa (để không tự báo trùng với chính nó); null khi thêm mới
     */
    public boolean tonTaiTen(String tenDanhMuc, Integer boQuaMa) throws SQLException {
        return tonTai("TenDanhMuc", tenDanhMuc, boQuaMa);
    }

    /** Kiểm tra đường dẫn URL đã có chưa. */
    public boolean tonTaiDuongDan(String duongDanUrl, Integer boQuaMa) throws SQLException {
        return tonTai("DuongDanUrl", duongDanUrl, boQuaMa);
    }

    /** Đếm số sản phẩm đang thuộc danh mục (khác 0 thì không được xóa - FK_SanPham_DanhMuc). */
    public int demSanPham(int maDanhMuc) throws SQLException {
        String sql = "SELECT COUNT(*) FROM dbo.SanPham WHERE MaDanhMuc = ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maDanhMuc);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    // ================================================================ GHI

    /**
     * Thêm danh mục mới. MaDanhMuc (IDENTITY) và NgayTao (mặc định SYSDATETIME) do DB tự sinh.
     *
     * @return mã danh mục vừa tạo
     */
    public int them(DanhMuc dm) throws SQLException {
        String sql = "INSERT INTO dbo.DanhMuc (TenDanhMuc, DuongDanUrl, MoTa, DangHoatDong) VALUES (?, ?, ?, ?)";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setNString(1, dm.getTenDanhMuc());
            ps.setString(2, dm.getDuongDanUrl());
            ps.setNString(3, dm.getMoTa());          // null -> NULL
            ps.setBoolean(4, dm.isDangHoatDong());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
            throw new SQLException("Không lấy được mã danh mục vừa thêm.");
        }
    }

    /**
     * Cập nhật tên, đường dẫn, mô tả, trạng thái. Không sửa MaDanhMuc và NgayTao.
     *
     * @return true nếu có đúng 1 dòng được cập nhật (false = danh mục không còn tồn tại)
     */
    public boolean capNhat(DanhMuc dm) throws SQLException {
        String sql = "UPDATE dbo.DanhMuc SET TenDanhMuc = ?, DuongDanUrl = ?, MoTa = ?, DangHoatDong = ? "
                + "WHERE MaDanhMuc = ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setNString(1, dm.getTenDanhMuc());
            ps.setString(2, dm.getDuongDanUrl());
            ps.setNString(3, dm.getMoTa());
            ps.setBoolean(4, dm.isDangHoatDong());
            ps.setInt(5, dm.getMaDanhMuc());
            return ps.executeUpdate() == 1;
        }
    }

    /**
     * Xóa danh mục. Servlet phải kiểm tra {@link #demSanPham(int)} trước;
     * nếu vẫn còn sản phẩm, DB sẽ chặn bằng FK_SanPham_DanhMuc (SQLException mã 547).
     *
     * @return true nếu xóa được đúng 1 dòng
     */
    public boolean xoa(int maDanhMuc) throws SQLException {
        String sql = "DELETE FROM dbo.DanhMuc WHERE MaDanhMuc = ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maDanhMuc);
            return ps.executeUpdate() == 1;
        }
    }

    // ================================================================ HỖ TRỢ

    /** Tên cột được truyền vào là hằng số trong lớp này (không đến từ người dùng) nên an toàn khi ghép chuỗi. */
    private boolean tonTai(String cot, String giaTri, Integer boQuaMa) throws SQLException {
        String sql = "SELECT COUNT(*) FROM dbo.DanhMuc WHERE " + cot + " = ?"
                + (boQuaMa != null ? " AND MaDanhMuc <> ?" : "");
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

    private static DanhMuc docDong(ResultSet rs) throws SQLException {
        DanhMuc dm = new DanhMuc();
        dm.setMaDanhMuc(rs.getInt("MaDanhMuc"));
        dm.setTenDanhMuc(rs.getNString("TenDanhMuc"));
        dm.setDuongDanUrl(rs.getString("DuongDanUrl"));
        dm.setMoTa(rs.getNString("MoTa"));
        dm.setDangHoatDong(rs.getBoolean("DangHoatDong"));
        dm.setNgayTao(rs.getObject("NgayTao", LocalDateTime.class));
        dm.setSoSanPham(rs.getInt("SoSanPham"));
        return dm;
    }
}
