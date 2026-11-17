package vn.edu.stu.laptopshop.entities;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Entity ánh xạ bảng {@code dbo.ThuongHieu} (database CuaHangLaptop).
 *
 * <p>Cấu trúc đã đối chiếu với DB thật (ảnh SSMS 14/11/2026):</p>
 * <pre>
 * Cột           Kiểu SQL          NULL  Ràng buộc
 * MaThuongHieu  INT IDENTITY      Không PK_ThuongHieu
 * TenThuongHieu NVARCHAR(100)     Không UQ_ThuongHieu_Ten
 * DuongDanUrl   VARCHAR(120)      Không UQ_ThuongHieu_DuongDanUrl, CK_ThuongHieu_DuongDanUrl (a-z, 0-9, -)
 * QuocGia       NVARCHAR(50)      Có
 * DuongDanLogo  NVARCHAR(500)     Có    (D30: không nhập trên form; sửa thì giữ nguyên, thêm mới = NULL)
 * DangHoatDong  BIT               Không DF_ThuongHieu_DangHoatDong = 1
 * NgayTao       DATETIME2(0)      Không DF_ThuongHieu_NgayTao = SYSDATETIME()
 * </pre>
 * <p>Khóa ngoại: {@code SanPham.MaThuongHieu -> ThuongHieu} (FK_SanPham_ThuongHieu, NO ACTION).</p>
 */
public class ThuongHieu {

    public static final int TEN_TOI_DA = 100;
    public static final int DUONG_DAN_TOI_DA = 120;
    public static final int QUOC_GIA_TOI_DA = 50;

    private static final DateTimeFormatter DINH_DANG_NGAY = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    private int maThuongHieu;
    private String tenThuongHieu;
    private String duongDanUrl;
    private String quocGia;
    private String duongDanLogo;
    private boolean dangHoatDong = true;
    private LocalDateTime ngayTao;

    /** KHÔNG phải cột của bảng: số sản phẩm thuộc thương hiệu, đếm từ bảng SanPham. */
    private int soSanPham;

    public int getMaThuongHieu() {
        return maThuongHieu;
    }

    public void setMaThuongHieu(int maThuongHieu) {
        this.maThuongHieu = maThuongHieu;
    }

    public String getTenThuongHieu() {
        return tenThuongHieu;
    }

    public void setTenThuongHieu(String tenThuongHieu) {
        this.tenThuongHieu = tenThuongHieu;
    }

    public String getDuongDanUrl() {
        return duongDanUrl;
    }

    public void setDuongDanUrl(String duongDanUrl) {
        this.duongDanUrl = duongDanUrl;
    }

    public String getQuocGia() {
        return quocGia;
    }

    public void setQuocGia(String quocGia) {
        this.quocGia = quocGia;
    }

    public String getDuongDanLogo() {
        return duongDanLogo;
    }

    public void setDuongDanLogo(String duongDanLogo) {
        this.duongDanLogo = duongDanLogo;
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
