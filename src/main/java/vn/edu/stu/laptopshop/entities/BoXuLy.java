package vn.edu.stu.laptopshop.entities;

import java.math.BigDecimal;
import java.util.List;

/**
 * Entity ánh xạ bảng {@code dbo.BoXuLy} (CPU) - bảng bên 1 cho combo box "CPU" của SanPham (D33).
 *
 * <p>Cấu trúc theo database/01_create_database.sql (script đã tạo DB thật). CHƯA đối chiếu bằng ảnh SSMS -
 * sẽ đối chiếu ở bước đầu của lượt kiểm thử.</p>
 * <pre>
 * Cột               Kiểu SQL        NULL  Ràng buộc
 * MaBoXuLy          INT IDENTITY    Không PK_BoXuLy
 * HangSanXuat       VARCHAR(20)     Không CK_BoXuLy_HangSanXuat IN ('Intel','AMD','Apple')
 * DongChip          VARCHAR(30)     Không (dùng để lọc: Core i5, Ryzen 7, Apple M3...)
 * TenModel          VARCHAR(50)     Không UQ_BoXuLy_TenModel
 * SoNhan            TINYINT         Không CK_BoXuLy_SoNhan BETWEEN 1 AND 64
 * SoLuongLuong      TINYINT         Không CK_BoXuLy_SoLuongLuong >= SoNhan AND <= 128
 * XungNhipToiDaGHz  DECIMAL(3,2)    Có    CK_BoXuLy_XungNhip NULL hoặc BETWEEN 1 AND 7
 * </pre>
 * <p>Lưu ý: các cột chữ là VARCHAR (không phải NVARCHAR) nên chỉ nhận ký tự ASCII (không dấu tiếng Việt).
 * Không có cột trạng thái / ngày tạo. Khóa ngoại: SanPham.MaBoXuLy -> BoXuLy (FK_SanPham_BoXuLy, NO ACTION).</p>
 */
public class BoXuLy {

    /** Giá trị hợp lệ theo CK_BoXuLy_HangSanXuat - dùng làm combo box cố định trên form. */
    public static final List<String> HANG_HOP_LE = List.of("Intel", "AMD", "Apple");
    public static final int DONG_CHIP_TOI_DA = 30;
    public static final int TEN_MODEL_TOI_DA = 50;
    public static final int SO_NHAN_TOI_THIEU = 1;
    public static final int SO_NHAN_TOI_DA = 64;
    public static final int SO_LUONG_TOI_DA = 128;
    public static final BigDecimal XUNG_TOI_THIEU = new BigDecimal("1");
    public static final BigDecimal XUNG_TOI_DA = new BigDecimal("7");

    private int maBoXuLy;
    private String hangSanXuat;
    private String dongChip;
    private String tenModel;
    private Integer soNhan;            // Integer để form thêm mới có thể để trống
    private Integer soLuongLuong;
    private BigDecimal xungNhipToiDaGHz;

    /** KHÔNG phải cột của bảng: số sản phẩm dùng CPU này, đếm từ bảng SanPham. */
    private int soSanPham;

    public int getMaBoXuLy() {
        return maBoXuLy;
    }

    public void setMaBoXuLy(int maBoXuLy) {
        this.maBoXuLy = maBoXuLy;
    }

    public String getHangSanXuat() {
        return hangSanXuat;
    }

    public void setHangSanXuat(String hangSanXuat) {
        this.hangSanXuat = hangSanXuat;
    }

    public String getDongChip() {
        return dongChip;
    }

    public void setDongChip(String dongChip) {
        this.dongChip = dongChip;
    }

    public String getTenModel() {
        return tenModel;
    }

    public void setTenModel(String tenModel) {
        this.tenModel = tenModel;
    }

    public Integer getSoNhan() {
        return soNhan;
    }

    public void setSoNhan(Integer soNhan) {
        this.soNhan = soNhan;
    }

    public Integer getSoLuongLuong() {
        return soLuongLuong;
    }

    public void setSoLuongLuong(Integer soLuongLuong) {
        this.soLuongLuong = soLuongLuong;
    }

    public BigDecimal getXungNhipToiDaGHz() {
        return xungNhipToiDaGHz;
    }

    public void setXungNhipToiDaGHz(BigDecimal xungNhipToiDaGHz) {
        this.xungNhipToiDaGHz = xungNhipToiDaGHz;
    }

    /** Nhãn hiển thị trong combo box, VD: "Intel Core i5-1335U (10 nhân / 12 luồng)". */
    public String getNhanComboBox() {
        return hangSanXuat + " " + tenModel + " (" + soNhan + " nhân / " + soLuongLuong + " luồng)";
    }

    public int getSoSanPham() {
        return soSanPham;
    }

    public void setSoSanPham(int soSanPham) {
        this.soSanPham = soSanPham;
    }
}
