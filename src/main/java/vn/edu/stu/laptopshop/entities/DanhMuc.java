package vn.edu.stu.laptopshop.entities;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Entity ánh xạ bảng {@code dbo.DanhMuc} (database CuaHangLaptop).
 *
 * <p>Cấu trúc đã đối chiếu với DB thật (14/11/2026):</p>
 * <pre>
 * Cột           Kiểu SQL          NULL  Ràng buộc
 * MaDanhMuc     INT IDENTITY      Không PK_DanhMuc
 * TenDanhMuc    NVARCHAR(100)     Không UQ_DanhMuc_Ten
 * DuongDanUrl   VARCHAR(120)      Không UQ_DanhMuc_DuongDanUrl, CK_DanhMuc_DuongDanUrl (chỉ a-z, 0-9, -)
 * MoTa          NVARCHAR(500)     Có
 * DangHoatDong  BIT               Không DF_DanhMuc_DangHoatDong = 1
 * NgayTao       DATETIME2(0)      Không DF_DanhMuc_NgayTao = SYSDATETIME()
 * </pre>
 * <p>Khóa ngoại liên quan: {@code SanPham.MaDanhMuc -> DanhMuc.MaDanhMuc} (FK_SanPham_DanhMuc, NO ACTION):
 * danh mục còn sản phẩm thì không xóa được.</p>
 */
public class DanhMuc {

    /** Giới hạn độ dài theo kiểu cột trong DB, dùng khi kiểm tra dữ liệu đầu vào. */
    public static final int TEN_TOI_DA = 100;
    public static final int DUONG_DAN_TOI_DA = 120;
    public static final int MO_TA_TOI_DA = 500;

    private static final DateTimeFormatter DINH_DANG_NGAY = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    private int maDanhMuc;
    private String tenDanhMuc;
    private String duongDanUrl;
    private String moTa;
    private boolean dangHoatDong = true;   // giống giá trị mặc định trong DB
    private LocalDateTime ngayTao;

    /** KHÔNG phải cột của bảng: số sản phẩm thuộc danh mục, đếm từ bảng SanPham để hiển thị. */
    private int soSanPham;

    public DanhMuc() {
    }

    public int getMaDanhMuc() {
        return maDanhMuc;
    }

    public void setMaDanhMuc(int maDanhMuc) {
        this.maDanhMuc = maDanhMuc;
    }

    public String getTenDanhMuc() {
        return tenDanhMuc;
    }

    public void setTenDanhMuc(String tenDanhMuc) {
        this.tenDanhMuc = tenDanhMuc;
    }

    public String getDuongDanUrl() {
        return duongDanUrl;
    }

    public void setDuongDanUrl(String duongDanUrl) {
        this.duongDanUrl = duongDanUrl;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    public boolean isDangHoatDong() {
        return dangHoatDong;
    }

    public void setDangHoatDong(boolean dangHoatDong) {
        this.dangHoatDong = dangHoatDong;
    }

    public LocalDateTime getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(LocalDateTime ngayTao) {
        this.ngayTao = ngayTao;
    }

    /** Ngày tạo dạng dd/MM/yyyy HH:mm để hiển thị trên JSP (JSTL không định dạng được LocalDateTime). */
    public String getNgayTaoHienThi() {
        return ngayTao == null ? "" : ngayTao.format(DINH_DANG_NGAY);
    }

    public int getSoSanPham() {
        return soSanPham;
    }

    public void setSoSanPham(int soSanPham) {
        this.soSanPham = soSanPham;
    }
}
