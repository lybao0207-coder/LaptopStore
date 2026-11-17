package vn.edu.stu.laptopshop.entities;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Entity ánh xạ bảng {@code dbo.CardDoHoa} (GPU) - bảng bên 1 cho combo box "Card đồ họa" của SanPham (D33).
 *
 * <p>Cấu trúc theo database/01_create_database.sql (script đã tạo DB thật). CHƯA đối chiếu bằng ảnh SSMS -
 * sẽ đối chiếu ở bước đầu của lượt kiểm thử.</p>
 * <pre>
 * Cột          Kiểu SQL       NULL  Ràng buộc
 * MaCardDoHoa  INT IDENTITY   Không PK_CardDoHoa
 * HangSanXuat  VARCHAR(20)    Không CK_CardDoHoa_HangSanXuat IN ('Intel','AMD','NVIDIA','Apple')
 * TenModel     VARCHAR(60)    Không UQ_CardDoHoa_TenModel
 * LoaiCard     VARCHAR(10)    Không CK_CardDoHoa_Loai IN ('TICH_HOP','ROI')
 * BoNhoVramGB  TINYINT        Có    CK_CardDoHoa_Vram: ROI -> 1..48 ; TICH_HOP -> NULL
 * </pre>
 * <p>Cột chữ là VARCHAR -> chỉ ký tự ASCII. Khóa ngoại: SanPham.MaCardDoHoa -> CardDoHoa (FK_SanPham_CardDoHoa, NO ACTION).</p>
 */
public class CardDoHoa {

    public static final List<String> HANG_HOP_LE = List.of("Intel", "AMD", "NVIDIA", "Apple");
    public static final String LOAI_TICH_HOP = "TICH_HOP";
    public static final String LOAI_ROI = "ROI";
    /** Mã loại lưu trong DB -> nhãn hiển thị (giữ thứ tự cho combo box). */
    public static final Map<String, String> LOAI_HOP_LE = taoDanhSachLoai();
    public static final int TEN_MODEL_TOI_DA = 60;
    public static final int VRAM_TOI_THIEU = 1;
    public static final int VRAM_TOI_DA = 48;

    private int maCardDoHoa;
    private String hangSanXuat;
    private String tenModel;
    private String loaiCard;
    private Integer boNhoVramGB;    // NULL với card tích hợp

    /** KHÔNG phải cột của bảng: số sản phẩm dùng card này, đếm từ bảng SanPham. */
    private int soSanPham;

    private static Map<String, String> taoDanhSachLoai() {
        Map<String, String> m = new LinkedHashMap<>();
        m.put(LOAI_TICH_HOP, "Tích hợp");
        m.put(LOAI_ROI, "Rời");
        return java.util.Collections.unmodifiableMap(m);
    }

    public int getMaCardDoHoa() {
        return maCardDoHoa;
    }

    public void setMaCardDoHoa(int maCardDoHoa) {
        this.maCardDoHoa = maCardDoHoa;
    }

    public String getHangSanXuat() {
        return hangSanXuat;
    }

    public void setHangSanXuat(String hangSanXuat) {
        this.hangSanXuat = hangSanXuat;
    }

    public String getTenModel() {
        return tenModel;
    }

    public void setTenModel(String tenModel) {
        this.tenModel = tenModel;
    }

    public String getLoaiCard() {
        return loaiCard;
    }

    public void setLoaiCard(String loaiCard) {
        this.loaiCard = loaiCard;
    }

    /** Nhãn tiếng Việt của loại card ("Tích hợp" / "Rời"). */
    public String getLoaiCardHienThi() {
        String nhan = loaiCard == null ? null : LOAI_HOP_LE.get(loaiCard);
        return nhan == null ? "" : nhan;
    }

    public Integer getBoNhoVramGB() {
        return boNhoVramGB;
    }

    public void setBoNhoVramGB(Integer boNhoVramGB) {
        this.boNhoVramGB = boNhoVramGB;
    }

    /** Nhãn hiển thị trong combo box, VD: "NVIDIA GeForce RTX 4060 8GB (Rời, 8 GB)". */
    public String getNhanComboBox() {
        return tenModel + " (" + getLoaiCardHienThi() + (boNhoVramGB != null ? ", " + boNhoVramGB + " GB" : "") + ")";
    }

    public int getSoSanPham() {
        return soSanPham;
    }

    public void setSoSanPham(int soSanPham) {
        this.soSanPham = soSanPham;
    }
}
