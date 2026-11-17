/* =====================================================================
   LaptopShop - 01_create_database.sql
   Tạo database CuaHangLaptop, toàn bộ bảng, ràng buộc và chỉ mục.
   - Tương thích: SQL Server 2012 trở lên (dùng OFFSET/FETCH, THROW).
   - Chạy bằng SSMS (F5) hoặc: sqlcmd -S <server> -E -i 01_create_database.sql
   - File lưu UTF-8 có BOM để giữ đúng tiếng Việt.
   - Nếu database đã tồn tại, script dừng lại. Muốn tạo lại từ đầu:
     chạy 00_drop_database.sql trước.
   ===================================================================== */

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;   -- bắt buộc cho filtered index và cột tính toán có index
GO

USE master;
GO

IF DB_ID(N'CuaHangLaptop') IS NOT NULL
BEGIN
    RAISERROR(N'Database CuaHangLaptop đã tồn tại. Chạy 00_drop_database.sql nếu muốn tạo lại.', 16, 1);
    SET NOEXEC ON;   -- Bỏ qua toàn bộ các batch phía sau
END
GO

-- Collation tiếng Việt, không phân biệt hoa/thường, phân biệt dấu
CREATE DATABASE CuaHangLaptop COLLATE Vietnamese_CI_AS;
GO

USE CuaHangLaptop;
GO

/* =====================================================================
   1. NHÓM TÀI KHOẢN
   ===================================================================== */

CREATE TABLE dbo.NguoiDung (
    MaNguoiDung            INT IDENTITY(1,1)  NOT NULL,
    Email                  VARCHAR(100)       NOT NULL,
    MatKhauBam             VARCHAR(200)       NOT NULL,   -- pbkdf2_sha256$<vòng lặp>$<salt Base64>$<hash Base64>
    HoTen                  NVARCHAR(100)      NOT NULL,
    SoDienThoai            VARCHAR(10)        NOT NULL,
    DiaChi                 NVARCHAR(255)      NULL,       -- địa chỉ giao hàng mặc định
    VaiTro                 VARCHAR(20)        NOT NULL CONSTRAINT DF_NguoiDung_VaiTro DEFAULT ('KHACH_HANG'),
    BiKhoa                 BIT                NOT NULL CONSTRAINT DF_NguoiDung_BiKhoa DEFAULT (0),
    NgayTao                DATETIME2(0)       NOT NULL CONSTRAINT DF_NguoiDung_NgayTao DEFAULT (SYSDATETIME()),
    NgayCapNhat            DATETIME2(0)       NULL,
    CONSTRAINT PK_NguoiDung PRIMARY KEY (MaNguoiDung),
    CONSTRAINT UQ_NguoiDung_Email UNIQUE (Email),
    CONSTRAINT CK_NguoiDung_VaiTro CHECK (VaiTro IN ('KHACH_HANG', 'QUAN_TRI')),                               -- D19
    CONSTRAINT CK_NguoiDung_Email CHECK (Email LIKE '%_@_%._%' AND Email NOT LIKE '% %'),
    CONSTRAINT CK_NguoiDung_SoDienThoai CHECK (SoDienThoai LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'), -- BR01: 10 số, bắt đầu bằng 0
    CONSTRAINT CK_NguoiDung_MatKhauBam CHECK (MatKhauBam LIKE 'pbkdf2_sha256$%$%$%'),
    CONSTRAINT CK_NguoiDung_HoTen CHECK (LEN(HoTen) >= 2)
);
GO

/* =====================================================================
   2. NHÓM DANH MỤC SẢN PHẨM
   ===================================================================== */

CREATE TABLE dbo.DanhMuc (
    MaDanhMuc              INT IDENTITY(1,1)  NOT NULL,
    TenDanhMuc             NVARCHAR(100)      NOT NULL,
    DuongDanUrl            VARCHAR(120)       NOT NULL,
    MoTa                   NVARCHAR(500)      NULL,
    DangHoatDong           BIT                NOT NULL CONSTRAINT DF_DanhMuc_DangHoatDong DEFAULT (1),
    NgayTao                DATETIME2(0)       NOT NULL CONSTRAINT DF_DanhMuc_NgayTao DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_DanhMuc PRIMARY KEY (MaDanhMuc),
    CONSTRAINT UQ_DanhMuc_Ten UNIQUE (TenDanhMuc),
    CONSTRAINT UQ_DanhMuc_DuongDanUrl UNIQUE (DuongDanUrl),
    CONSTRAINT CK_DanhMuc_DuongDanUrl CHECK (DuongDanUrl NOT LIKE '%[^a-z0-9-]%')
);
GO

CREATE TABLE dbo.ThuongHieu (
    MaThuongHieu           INT IDENTITY(1,1)  NOT NULL,
    TenThuongHieu          NVARCHAR(100)      NOT NULL,
    DuongDanUrl            VARCHAR(120)       NOT NULL,
    QuocGia                NVARCHAR(50)       NULL,
    DuongDanLogo           NVARCHAR(500)      NULL,       -- đường dẫn tương đối trong thư mục upload (D20)
    DangHoatDong           BIT                NOT NULL CONSTRAINT DF_ThuongHieu_DangHoatDong DEFAULT (1),
    NgayTao                DATETIME2(0)       NOT NULL CONSTRAINT DF_ThuongHieu_NgayTao DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_ThuongHieu PRIMARY KEY (MaThuongHieu),
    CONSTRAINT UQ_ThuongHieu_Ten UNIQUE (TenThuongHieu),
    CONSTRAINT UQ_ThuongHieu_DuongDanUrl UNIQUE (DuongDanUrl),
    CONSTRAINT CK_ThuongHieu_DuongDanUrl CHECK (DuongDanUrl NOT LIKE '%[^a-z0-9-]%')
);
GO

-- Bảng tra cứu CPU: thông số phụ thuộc vào model CPU, không phụ thuộc laptop (chuẩn 3NF)
CREATE TABLE dbo.BoXuLy (
    MaBoXuLy               INT IDENTITY(1,1)  NOT NULL,
    HangSanXuat            VARCHAR(20)        NOT NULL,   -- Intel / AMD / Apple
    DongChip               VARCHAR(30)        NOT NULL,   -- Core i5, Ryzen 7, Apple M3... (dùng để lọc)
    TenModel               VARCHAR(50)        NOT NULL,   -- i5-1335U, Ryzen 7 7840HS...
    SoNhan                 TINYINT            NOT NULL,
    SoLuongLuong           TINYINT            NOT NULL,
    XungNhipToiDaGHz       DECIMAL(3,2)       NULL,
    CONSTRAINT PK_BoXuLy PRIMARY KEY (MaBoXuLy),
    CONSTRAINT UQ_BoXuLy_TenModel UNIQUE (TenModel),
    CONSTRAINT CK_BoXuLy_HangSanXuat CHECK (HangSanXuat IN ('Intel', 'AMD', 'Apple')),
    CONSTRAINT CK_BoXuLy_SoNhan CHECK (SoNhan BETWEEN 1 AND 64),
    CONSTRAINT CK_BoXuLy_SoLuongLuong CHECK (SoLuongLuong >= SoNhan AND SoLuongLuong <= 128),
    CONSTRAINT CK_BoXuLy_XungNhip CHECK (XungNhipToiDaGHz IS NULL OR XungNhipToiDaGHz BETWEEN 1 AND 7)
);
GO

-- Bảng tra cứu GPU
CREATE TABLE dbo.CardDoHoa (
    MaCardDoHoa            INT IDENTITY(1,1)  NOT NULL,
    HangSanXuat            VARCHAR(20)        NOT NULL,   -- Intel / AMD / NVIDIA / Apple
    TenModel               VARCHAR(60)        NOT NULL,
    LoaiCard               VARCHAR(10)        NOT NULL,   -- TICH_HOP (tích hợp) / ROI (rời)
    BoNhoVramGB            TINYINT            NULL,       -- NULL với card tích hợp (dùng chung RAM)
    CONSTRAINT PK_CardDoHoa PRIMARY KEY (MaCardDoHoa),
    CONSTRAINT UQ_CardDoHoa_TenModel UNIQUE (TenModel),
    CONSTRAINT CK_CardDoHoa_HangSanXuat CHECK (HangSanXuat IN ('Intel', 'AMD', 'NVIDIA', 'Apple')),
    CONSTRAINT CK_CardDoHoa_Loai CHECK (LoaiCard IN ('TICH_HOP', 'ROI')),
    -- Card rời bắt buộc có VRAM, card tích hợp không có VRAM riêng
    CONSTRAINT CK_CardDoHoa_Vram CHECK ((LoaiCard = 'ROI' AND BoNhoVramGB BETWEEN 1 AND 48)
                                OR (LoaiCard = 'TICH_HOP' AND BoNhoVramGB IS NULL))
);
GO

/* =====================================================================
   3. SẢN PHẨM (D08: mỗi cấu hình laptop là một sản phẩm)
   ===================================================================== */

CREATE TABLE dbo.SanPham (
    MaSanPham              INT IDENTITY(1,1)  NOT NULL,
    MaSku                  VARCHAR(50)        NOT NULL,
    TenSanPham             NVARCHAR(200)      NOT NULL,
    DuongDanUrl            VARCHAR(220)       NOT NULL,
    MaDanhMuc              INT                NOT NULL,
    MaThuongHieu           INT                NOT NULL,
    DongMay                NVARCHAR(100)      NULL,     -- dòng máy: Inspiron, ThinkPad, ROG...
    MoTaNgan               NVARCHAR(500)      NULL,
    MoTa                   NVARCHAR(MAX)      NULL,
    GiaBan                 DECIMAL(18,0)      NOT NULL, -- giá bán gốc VND (D23)
    SoLuongTon             INT                NOT NULL CONSTRAINT DF_SanPham_SoLuongTon DEFAULT (0),
    BaoHanhThang           TINYINT            NOT NULL CONSTRAINT DF_SanPham_BaoHanh DEFAULT (12),
    -- CPU / GPU
    MaBoXuLy               INT                NOT NULL,
    MaCardDoHoa            INT                NOT NULL,
    -- RAM
    DungLuongRamGB         SMALLINT           NOT NULL,
    LoaiRam                VARCHAR(20)        NOT NULL,
    BusRamMHz              SMALLINT           NULL,
    SoKheRam               TINYINT            NULL,     -- 0 = RAM hàn chết trên bo mạch
    RamToiDaGB             SMALLINT           NULL,
    -- Lưu trữ
    DungLuongOCungGB       SMALLINT           NOT NULL,
    LoaiOCung              VARCHAR(10)        NOT NULL,
    -- Màn hình
    KichThuocManHinhInch   DECIMAL(3,1)       NOT NULL,
    DoPhanGiaiNgang        SMALLINT           NOT NULL,
    DoPhanGiaiDoc          SMALLINT           NOT NULL,
    TamNen                 VARCHAR(10)        NOT NULL,
    TanSoQuetHz            SMALLINT           NOT NULL CONSTRAINT DF_SanPham_TanSoQuet DEFAULT (60),
    CamUng                 BIT                NOT NULL CONSTRAINT DF_SanPham_CamUng DEFAULT (0),
    -- Pin, vật lý
    DungLuongPinWh         DECIMAL(4,1)       NOT NULL,
    TrongLuongKg           DECIMAL(3,2)       NOT NULL,
    KichThuoc              NVARCHAR(50)       NULL,     -- "359 x 235 x 18.9 mm"
    ChatLieu               NVARCHAR(50)       NULL,
    MauSac                 NVARCHAR(50)       NULL,
    -- Kết nối, phần mềm
    CongKetNoi             NVARCHAR(500)      NULL,
    KetNoiKhongDay         NVARCHAR(100)      NULL,
    Webcam                 NVARCHAR(50)       NULL,
    DenBanPhim             BIT                NOT NULL CONSTRAINT DF_SanPham_DenBanPhim DEFAULT (0),
    HeDieuHanh             NVARCHAR(50)       NOT NULL,
    NamRaMat               SMALLINT           NULL,
    -- Trạng thái
    TrangThai              VARCHAR(20)        NOT NULL CONSTRAINT DF_SanPham_TrangThai DEFAULT ('DANG_BAN'),
    NgayTao                DATETIME2(0)       NOT NULL CONSTRAINT DF_SanPham_NgayTao DEFAULT (SYSDATETIME()),
    NgayCapNhat            DATETIME2(0)       NULL,
    CONSTRAINT PK_SanPham PRIMARY KEY (MaSanPham),
    CONSTRAINT UQ_SanPham_MaSku UNIQUE (MaSku),                     -- BR12
    CONSTRAINT UQ_SanPham_Ten UNIQUE (TenSanPham),                   -- BR12
    CONSTRAINT UQ_SanPham_DuongDanUrl UNIQUE (DuongDanUrl),
    -- NO ACTION: không xóa được danh mục / thương hiệu / CPU / GPU đang có sản phẩm (BR11)
    CONSTRAINT FK_SanPham_DanhMuc FOREIGN KEY (MaDanhMuc) REFERENCES dbo.DanhMuc(MaDanhMuc),
    CONSTRAINT FK_SanPham_ThuongHieu FOREIGN KEY (MaThuongHieu) REFERENCES dbo.ThuongHieu(MaThuongHieu),
    CONSTRAINT FK_SanPham_BoXuLy FOREIGN KEY (MaBoXuLy) REFERENCES dbo.BoXuLy(MaBoXuLy),
    CONSTRAINT FK_SanPham_CardDoHoa FOREIGN KEY (MaCardDoHoa) REFERENCES dbo.CardDoHoa(MaCardDoHoa),
    CONSTRAINT CK_SanPham_DuongDanUrl CHECK (DuongDanUrl NOT LIKE '%[^a-z0-9-]%'),
    CONSTRAINT CK_SanPham_GiaBan CHECK (GiaBan > 0),                                   -- BR07
    CONSTRAINT CK_SanPham_SoLuongTon CHECK (SoLuongTon >= 0),                                  -- BR08
    CONSTRAINT CK_SanPham_BaoHanh CHECK (BaoHanhThang BETWEEN 0 AND 60),
    CONSTRAINT CK_SanPham_Ram CHECK (DungLuongRamGB BETWEEN 2 AND 256),
    CONSTRAINT CK_SanPham_LoaiRam CHECK (LoaiRam IN ('DDR4', 'DDR5', 'LPDDR4X', 'LPDDR5', 'LPDDR5X', 'HOP_NHAT')),
    CONSTRAINT CK_SanPham_BusRam CHECK (BusRamMHz IS NULL OR BusRamMHz BETWEEN 1000 AND 12000),
    CONSTRAINT CK_SanPham_SoKheRam CHECK (SoKheRam IS NULL OR SoKheRam BETWEEN 0 AND 4),
    CONSTRAINT CK_SanPham_RamToiDa CHECK (RamToiDaGB IS NULL OR RamToiDaGB >= DungLuongRamGB),
    CONSTRAINT CK_SanPham_OCung CHECK (DungLuongOCungGB BETWEEN 64 AND 16384),
    CONSTRAINT CK_SanPham_LoaiOCung CHECK (LoaiOCung IN ('SSD_NVME', 'SSD_SATA', 'HDD')),
    CONSTRAINT CK_SanPham_ManHinh CHECK (KichThuocManHinhInch BETWEEN 10.0 AND 20.0),
    CONSTRAINT CK_SanPham_DoPhanGiai CHECK (DoPhanGiaiNgang BETWEEN 800 AND 7680 AND DoPhanGiaiDoc BETWEEN 600 AND 4320),
    CONSTRAINT CK_SanPham_TamNen CHECK (TamNen IN ('IPS', 'OLED', 'TN', 'VA', 'MINI_LED')),
    CONSTRAINT CK_SanPham_TanSoQuet CHECK (TanSoQuetHz BETWEEN 30 AND 500),
    CONSTRAINT CK_SanPham_Pin CHECK (DungLuongPinWh BETWEEN 10 AND 120),
    CONSTRAINT CK_SanPham_TrongLuong CHECK (TrongLuongKg BETWEEN 0.50 AND 6.00),
    CONSTRAINT CK_SanPham_NamRaMat CHECK (NamRaMat IS NULL OR NamRaMat BETWEEN 2010 AND 2100),
    CONSTRAINT CK_SanPham_TrangThai CHECK (TrangThai IN ('DANG_BAN', 'NGUNG_BAN'))         -- BR09, BR10
);
GO

-- Ảnh sản phẩm (1 sản phẩm - N ảnh)
CREATE TABLE dbo.HinhAnhSanPham (
    MaHinhAnh              INT IDENTITY(1,1)  NOT NULL,
    MaSanPham              INT                NOT NULL,
    DuongDanAnh            NVARCHAR(500)      NOT NULL,   -- đường dẫn tương đối, VD: products/abc.jpg (D20)
    LaAnhDaiDien           BIT                NOT NULL CONSTRAINT DF_HinhAnhSanPham_LaAnhDaiDien DEFAULT (0),
    ThuTu                  INT                NOT NULL CONSTRAINT DF_HinhAnhSanPham_ThuTu DEFAULT (0),
    NgayTao                DATETIME2(0)       NOT NULL CONSTRAINT DF_HinhAnhSanPham_NgayTao DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_HinhAnhSanPham PRIMARY KEY (MaHinhAnh),
    CONSTRAINT FK_HinhAnhSanPham_SanPham FOREIGN KEY (MaSanPham) REFERENCES dbo.SanPham(MaSanPham) ON DELETE CASCADE,
    CONSTRAINT UQ_HinhAnhSanPham_DuongDan UNIQUE (DuongDanAnh),
    CONSTRAINT CK_HinhAnhSanPham_DuongDan CHECK (DuongDanAnh NOT LIKE '%..%' AND DuongDanAnh NOT LIKE '/%' AND DuongDanAnh NOT LIKE '%:%'),
    CONSTRAINT CK_HinhAnhSanPham_ThuTu CHECK (ThuTu >= 0)
);
GO

/* =====================================================================
   4. KHUYẾN MÃI (N-N với sản phẩm)
   ===================================================================== */

CREATE TABLE dbo.KhuyenMai (
    MaKhuyenMai            INT IDENTITY(1,1)  NOT NULL,
    TenKhuyenMai           NVARCHAR(150)      NOT NULL,
    MoTa                   NVARCHAR(500)      NULL,
    LoaiGiam               VARCHAR(10)        NOT NULL,   -- PHAN_TRAM / SO_TIEN
    GiaTriGiam             DECIMAL(18,0)      NOT NULL,   -- % (1-90) hoặc số tiền VND
    NgayBatDau             DATETIME2(0)       NOT NULL,
    NgayKetThuc            DATETIME2(0)       NOT NULL,
    DangHoatDong           BIT                NOT NULL CONSTRAINT DF_KhuyenMai_DangHoatDong DEFAULT (1),
    NgayTao                DATETIME2(0)       NOT NULL CONSTRAINT DF_KhuyenMai_NgayTao DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_KhuyenMai PRIMARY KEY (MaKhuyenMai),
    CONSTRAINT UQ_KhuyenMai_Ten UNIQUE (TenKhuyenMai),
    CONSTRAINT CK_KhuyenMai_Loai CHECK (LoaiGiam IN ('PHAN_TRAM', 'SO_TIEN')),           -- BR13
    CONSTRAINT CK_KhuyenMai_GiaTri CHECK ((LoaiGiam = 'PHAN_TRAM' AND GiaTriGiam BETWEEN 1 AND 90)
                                       OR (LoaiGiam = 'SO_TIEN'  AND GiaTriGiam > 0)),  -- BR14
    CONSTRAINT CK_KhuyenMai_ThoiGian CHECK (NgayKetThuc > NgayBatDau)                                -- BR14
);
GO

CREATE TABLE dbo.SanPhamKhuyenMai (
    MaSanPham              INT                NOT NULL,
    MaKhuyenMai            INT                NOT NULL,
    CONSTRAINT PK_SanPhamKhuyenMai PRIMARY KEY (MaSanPham, MaKhuyenMai),
    CONSTRAINT FK_SanPhamKhuyenMai_SanPham FOREIGN KEY (MaSanPham) REFERENCES dbo.SanPham(MaSanPham)     ON DELETE CASCADE,
    CONSTRAINT FK_SanPhamKhuyenMai_KhuyenMai FOREIGN KEY (MaKhuyenMai) REFERENCES dbo.KhuyenMai(MaKhuyenMai) ON DELETE CASCADE
);
GO

/* =====================================================================
   5. GIỎ HÀNG (D09: lưu trong DB, gắn với tài khoản)
   ===================================================================== */

CREATE TABLE dbo.GioHang (
    MaGioHang              INT IDENTITY(1,1)  NOT NULL,
    MaNguoiDung            INT                NOT NULL,
    MaSanPham              INT                NOT NULL,
    SoLuong                TINYINT            NOT NULL,
    NgayThem               DATETIME2(0)       NOT NULL CONSTRAINT DF_GioHang_NgayThem DEFAULT (SYSDATETIME()),
    NgayCapNhat            DATETIME2(0)       NULL,
    CONSTRAINT PK_GioHang PRIMARY KEY (MaGioHang),
    CONSTRAINT UQ_GioHang_NguoiDung_SanPham UNIQUE (MaNguoiDung, MaSanPham),                     -- BR20
    CONSTRAINT FK_GioHang_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES dbo.NguoiDung(MaNguoiDung)       ON DELETE CASCADE,
    CONSTRAINT FK_GioHang_SanPham FOREIGN KEY (MaSanPham) REFERENCES dbo.SanPham(MaSanPham) ON DELETE CASCADE,
    CONSTRAINT CK_GioHang_SoLuong CHECK (SoLuong BETWEEN 1 AND 5)                    -- D21
);
GO

/* =====================================================================
   6. ĐƠN HÀNG
   ===================================================================== */

CREATE TABLE dbo.DonHang (
    MaDonHang              INT IDENTITY(1,1)  NOT NULL,
    -- Mã đơn hiển thị / nội dung chuyển khoản, sinh tự động từ MaDonHang: LS000001
    MaDonHienThi           AS (CAST('LS' + RIGHT('000000' + CAST(MaDonHang AS VARCHAR(10)), 6) AS VARCHAR(12))) PERSISTED,
    MaNguoiDung            INT                NOT NULL,
    TenNguoiNhan           NVARCHAR(100)      NOT NULL,   -- BR24: thông tin người nhận lưu riêng trong đơn
    SdtNguoiNhan           VARCHAR(10)        NOT NULL,
    DiaChiGiaoHang         NVARCHAR(255)      NOT NULL,
    GhiChu                 NVARCHAR(500)      NULL,
    PhuongThucThanhToan    VARCHAR(20)        NOT NULL,
    TrangThaiThanhToan     VARCHAR(20)        NOT NULL CONSTRAINT DF_DonHang_TrangThaiThanhToan DEFAULT ('CHUA_THANH_TOAN'),
    TrangThai              VARCHAR(20)        NOT NULL CONSTRAINT DF_DonHang_TrangThai DEFAULT ('CHO_XAC_NHAN'),
    TongTien               DECIMAL(18,0)      NOT NULL,   -- = SUM(ChiTietDonHang.ThanhTien); miễn phí vận chuyển (D11)
    NgayTao                DATETIME2(0)       NOT NULL CONSTRAINT DF_DonHang_NgayTao DEFAULT (SYSDATETIME()),
    NgayThanhToan          DATETIME2(0)       NULL,
    NgayXacNhan            DATETIME2(0)       NULL,
    NgayBanGiao            DATETIME2(0)       NULL,
    NgayGiaoThanhCong      DATETIME2(0)       NULL,       -- mốc tính doanh thu (D13, P10)
    NgayHuy                DATETIME2(0)       NULL,
    NgayCapNhat            DATETIME2(0)       NULL,
    CONSTRAINT PK_DonHang PRIMARY KEY (MaDonHang),
    CONSTRAINT UQ_DonHang_MaDonHienThi UNIQUE (MaDonHienThi),
    CONSTRAINT FK_DonHang_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES dbo.NguoiDung(MaNguoiDung),
    CONSTRAINT CK_DonHang_SdtNguoiNhan CHECK (SdtNguoiNhan LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT CK_DonHang_PhuongThucThanhToan CHECK (PhuongThucThanhToan IN ('THANH_TOAN_KHI_NHAN', 'CHUYEN_KHOAN')),            -- D10
    CONSTRAINT CK_DonHang_TrangThaiThanhToan CHECK (TrangThaiThanhToan IN ('CHUA_THANH_TOAN', 'DA_THANH_TOAN', 'DA_HOAN_TIEN')),
    CONSTRAINT CK_DonHang_TrangThai CHECK (TrangThai IN ('CHO_XAC_NHAN', 'DA_XAC_NHAN', 'DANG_GIAO', 'DA_GIAO', 'DA_HUY')), -- D16
    CONSTRAINT CK_DonHang_TongTien CHECK (TongTien > 0),
    -- Mốc thời gian phải khớp với trạng thái
    CONSTRAINT CK_DonHang_NgayThanhToan CHECK ((TrangThaiThanhToan = 'CHUA_THANH_TOAN' AND NgayThanhToan IS NULL)
                                    OR (TrangThaiThanhToan IN ('DA_THANH_TOAN', 'DA_HOAN_TIEN') AND NgayThanhToan IS NOT NULL)),
    CONSTRAINT CK_DonHang_NgayXacNhan CHECK ((TrangThai = 'CHO_XAC_NHAN' AND NgayXacNhan IS NULL)
                                         OR (TrangThai IN ('DA_XAC_NHAN', 'DANG_GIAO', 'DA_GIAO') AND NgayXacNhan IS NOT NULL)
                                         OR  TrangThai = 'DA_HUY'),
    CONSTRAINT CK_DonHang_NgayBanGiao CHECK ((TrangThai IN ('DANG_GIAO', 'DA_GIAO') AND NgayBanGiao IS NOT NULL)
                                       OR (TrangThai IN ('CHO_XAC_NHAN', 'DA_XAC_NHAN', 'DA_HUY') AND NgayBanGiao IS NULL)),
    CONSTRAINT CK_DonHang_NgayGiaoThanhCong CHECK ((TrangThai = 'DA_GIAO' AND NgayGiaoThanhCong IS NOT NULL)
                                         OR (TrangThai <> 'DA_GIAO' AND NgayGiaoThanhCong IS NULL)),
    CONSTRAINT CK_DonHang_NgayHuy CHECK ((TrangThai = 'DA_HUY' AND NgayHuy IS NOT NULL)
                                         OR (TrangThai <> 'DA_HUY' AND NgayHuy IS NULL)),
    CONSTRAINT CK_DonHang_ThuTuThoiGian CHECK ((NgayThanhToan      IS NULL OR NgayThanhToan      >= NgayTao)
                                      AND (NgayXacNhan IS NULL OR NgayXacNhan >= NgayTao)
                                      AND (NgayBanGiao   IS NULL OR NgayBanGiao   >= NgayXacNhan)
                                      AND (NgayGiaoThanhCong IS NULL OR NgayGiaoThanhCong >= NgayBanGiao)
                                      AND (NgayHuy IS NULL OR NgayHuy >= NgayTao)),
    -- Nghiệp vụ thanh toán (BR29, D22)
    CONSTRAINT CK_DonHang_DaGiaoDaThanhToan CHECK (TrangThai <> 'DA_GIAO' OR TrangThaiThanhToan = 'DA_THANH_TOAN'),
    CONSTRAINT CK_DonHang_ChuyenKhoanTraTruocXacNhan CHECK (NOT (PhuongThucThanhToan = 'CHUYEN_KHOAN'
                                                     AND TrangThai IN ('DA_XAC_NHAN', 'DANG_GIAO', 'DA_GIAO')
                                                     AND TrangThaiThanhToan <> 'DA_THANH_TOAN')),
    CONSTRAINT CK_DonHang_KhiNhanKhongTraSom CHECK (NOT (PhuongThucThanhToan = 'THANH_TOAN_KHI_NHAN' AND TrangThaiThanhToan = 'DA_THANH_TOAN' AND TrangThai <> 'DA_GIAO')),
    CONSTRAINT CK_DonHang_KhiNhanKhongHoanTien CHECK (NOT (PhuongThucThanhToan = 'THANH_TOAN_KHI_NHAN' AND TrangThaiThanhToan = 'DA_HOAN_TIEN')),
    CONSTRAINT CK_DonHang_HoanTienChiKhiHuy CHECK (TrangThaiThanhToan <> 'DA_HOAN_TIEN' OR TrangThai = 'DA_HUY'),
    CONSTRAINT CK_DonHang_DaHuyKhongDaThanhToan CHECK (NOT (TrangThai = 'DA_HUY' AND TrangThaiThanhToan = 'DA_THANH_TOAN'))
);
GO

-- Chi tiết đơn: snapshot tên, SKU, giá tại thời điểm đặt (BR23)
CREATE TABLE dbo.ChiTietDonHang (
    MaDonHang              INT                NOT NULL,
    MaSanPham              INT                NOT NULL,
    TenSanPham             NVARCHAR(200)      NOT NULL,
    MaSku                  VARCHAR(50)        NOT NULL,
    DonGiaGoc              DECIMAL(18,0)      NOT NULL,   -- giá bán gốc lúc đặt
    DonGiaBan              DECIMAL(18,0)      NOT NULL,   -- giá sau khuyến mãi lúc đặt
    MaKhuyenMai            INT                NULL,       -- khuyến mãi đã áp dụng (NULL nếu không có)
    SoLuong                TINYINT            NOT NULL,
    TienGiam               AS (DonGiaGoc - DonGiaBan) PERSISTED,
    ThanhTien              AS (DonGiaBan * SoLuong) PERSISTED,
    CONSTRAINT PK_ChiTietDonHang PRIMARY KEY (MaDonHang, MaSanPham),
    CONSTRAINT FK_ChiTietDonHang_DonHang FOREIGN KEY (MaDonHang) REFERENCES dbo.DonHang(MaDonHang),
    -- NO ACTION: sản phẩm đã có trong đơn không xóa cứng được (BR09)
    CONSTRAINT FK_ChiTietDonHang_SanPham FOREIGN KEY (MaSanPham) REFERENCES dbo.SanPham(MaSanPham),
    -- NO ACTION: khuyến mãi đã áp dụng vào đơn không xóa được, chỉ ngừng hoạt động
    CONSTRAINT FK_ChiTietDonHang_KhuyenMai FOREIGN KEY (MaKhuyenMai) REFERENCES dbo.KhuyenMai(MaKhuyenMai),
    CONSTRAINT CK_ChiTietDonHang_SoLuong CHECK (SoLuong BETWEEN 1 AND 5),                 -- D21
    CONSTRAINT CK_ChiTietDonHang_DonGia CHECK (DonGiaGoc > 0 AND DonGiaBan > 0 AND DonGiaBan <= DonGiaGoc),
    CONSTRAINT CK_ChiTietDonHang_KhuyenMai CHECK ((MaKhuyenMai IS NULL AND DonGiaBan = DonGiaGoc)
                                             OR (MaKhuyenMai IS NOT NULL AND DonGiaBan < DonGiaGoc))
);
GO

-- Lịch sử thay đổi trạng thái đơn (P12)
CREATE TABLE dbo.LichSuTrangThaiDon (
    MaLichSu               INT IDENTITY(1,1)  NOT NULL,
    MaDonHang              INT                NOT NULL,
    TuTrangThai            VARCHAR(20)        NULL,       -- NULL khi tạo đơn
    SangTrangThai          VARCHAR(20)        NOT NULL,
    NguoiThucHien          INT                NOT NULL,   -- khách (đặt / hủy) hoặc admin
    GhiChu                 NVARCHAR(255)      NULL,
    ThoiDiem               DATETIME2(0)       NOT NULL CONSTRAINT DF_LichSuTrangThaiDon_ThoiDiem DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_LichSuTrangThaiDon PRIMARY KEY (MaLichSu),
    CONSTRAINT FK_LichSuTrangThaiDon_DonHang FOREIGN KEY (MaDonHang) REFERENCES dbo.DonHang(MaDonHang),
    CONSTRAINT FK_LichSuTrangThaiDon_NguoiDung FOREIGN KEY (NguoiThucHien) REFERENCES dbo.NguoiDung(MaNguoiDung),
    CONSTRAINT CK_LichSuTrangThaiDon_TuTrangThai CHECK (TuTrangThai IS NULL OR TuTrangThai IN ('CHO_XAC_NHAN', 'DA_XAC_NHAN', 'DANG_GIAO', 'DA_GIAO', 'DA_HUY')),
    CONSTRAINT CK_LichSuTrangThaiDon_SangTrangThai CHECK (SangTrangThai IN ('CHO_XAC_NHAN', 'DA_XAC_NHAN', 'DANG_GIAO', 'DA_GIAO', 'DA_HUY')),
    -- Chỉ các bước chuyển hợp lệ theo BR26 / BR27
    CONSTRAINT CK_LichSuTrangThaiDon_ChuyenTrangThai CHECK (
           (TuTrangThai IS NULL        AND SangTrangThai = 'CHO_XAC_NHAN')
        OR (TuTrangThai = 'CHO_XAC_NHAN'    AND SangTrangThai IN ('DA_XAC_NHAN', 'DA_HUY'))
        OR (TuTrangThai = 'DA_XAC_NHAN'  AND SangTrangThai IN ('DANG_GIAO', 'DA_HUY'))
        OR (TuTrangThai = 'DANG_GIAO'   AND SangTrangThai = 'DA_GIAO'))
);
GO

/* =====================================================================
   7. ĐÁNH GIÁ
   ===================================================================== */

CREATE TABLE dbo.DanhGia (
    MaDanhGia              INT IDENTITY(1,1)  NOT NULL,
    MaNguoiDung            INT                NOT NULL,
    MaSanPham              INT                NOT NULL,
    SoSao                  TINYINT            NOT NULL,
    NoiDung                NVARCHAR(1000)     NOT NULL,
    BiAn                   BIT                NOT NULL CONSTRAINT DF_DanhGia_BiAn DEFAULT (0),  -- D18: Admin ẩn
    NgayTao                DATETIME2(0)       NOT NULL CONSTRAINT DF_DanhGia_NgayTao DEFAULT (SYSDATETIME()),
    NgayCapNhat            DATETIME2(0)       NULL,
    CONSTRAINT PK_DanhGia PRIMARY KEY (MaDanhGia),
    CONSTRAINT UQ_DanhGia_NguoiDung_SanPham UNIQUE (MaNguoiDung, MaSanPham),                         -- BR31
    CONSTRAINT FK_DanhGia_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES dbo.NguoiDung(MaNguoiDung),
    CONSTRAINT FK_DanhGia_SanPham FOREIGN KEY (MaSanPham) REFERENCES dbo.SanPham(MaSanPham),
    CONSTRAINT CK_DanhGia_SoSao CHECK (SoSao BETWEEN 1 AND 5),                          -- BR32
    CONSTRAINT CK_DanhGia_NoiDung CHECK (LEN(NoiDung) BETWEEN 10 AND 1000)                 -- BR32
);
GO

/* =====================================================================
   8. BANNER TRANG CHỦ
   ===================================================================== */

CREATE TABLE dbo.QuangCao (
    MaQuangCao             INT IDENTITY(1,1)  NOT NULL,
    TieuDe                 NVARCHAR(150)      NOT NULL,
    DuongDanAnh            NVARCHAR(500)      NOT NULL,
    DuongDanLienKet        NVARCHAR(500)      NULL,       -- chỉ cho phép đường dẫn nội bộ, bắt đầu bằng /
    ThuTu                  INT                NOT NULL CONSTRAINT DF_QuangCao_ThuTu DEFAULT (0),
    DangHoatDong           BIT                NOT NULL CONSTRAINT DF_QuangCao_DangHoatDong DEFAULT (1),
    NgayTao                DATETIME2(0)       NOT NULL CONSTRAINT DF_QuangCao_NgayTao DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_QuangCao PRIMARY KEY (MaQuangCao),
    CONSTRAINT CK_QuangCao_DuongDan CHECK (DuongDanAnh NOT LIKE '%..%' AND DuongDanAnh NOT LIKE '/%' AND DuongDanAnh NOT LIKE '%:%'),
    CONSTRAINT CK_QuangCao_LienKet CHECK (DuongDanLienKet IS NULL OR (DuongDanLienKet LIKE '/%' AND DuongDanLienKet NOT LIKE '//%')),
    CONSTRAINT CK_QuangCao_ThuTu CHECK (ThuTu >= 0)
);
GO

/* =====================================================================
   9. CHỈ MỤC (INDEX) - phục vụ lọc, phân trang, thống kê (NF06)
   ===================================================================== */

-- Mỗi sản phẩm chỉ có tối đa 1 ảnh đại diện
CREATE UNIQUE INDEX UX_HinhAnhSanPham_AnhDaiDien ON dbo.HinhAnhSanPham(MaSanPham) WHERE LaAnhDaiDien = 1;
CREATE INDEX IX_HinhAnhSanPham_SanPham ON dbo.HinhAnhSanPham(MaSanPham, ThuTu);

-- Lọc / sắp xếp sản phẩm
CREATE INDEX IX_SanPham_TrangThai_GiaBan ON dbo.SanPham(TrangThai, GiaBan);
CREATE INDEX IX_SanPham_TrangThai_NgayTao ON dbo.SanPham(TrangThai, NgayTao DESC);
CREATE INDEX IX_SanPham_DanhMuc ON dbo.SanPham(MaDanhMuc);
CREATE INDEX IX_SanPham_ThuongHieu ON dbo.SanPham(MaThuongHieu);
CREATE INDEX IX_SanPham_BoXuLy ON dbo.SanPham(MaBoXuLy);
CREATE INDEX IX_SanPham_CardDoHoa ON dbo.SanPham(MaCardDoHoa);
CREATE INDEX IX_SanPham_Ram ON dbo.SanPham(DungLuongRamGB);
CREATE INDEX IX_SanPham_OCung ON dbo.SanPham(DungLuongOCungGB);
CREATE INDEX IX_SanPham_ManHinh ON dbo.SanPham(KichThuocManHinhInch);
CREATE INDEX IX_SanPham_SoLuongTon ON dbo.SanPham(SoLuongTon);
CREATE INDEX IX_BoXuLy_Dong ON dbo.BoXuLy(DongChip);

-- Khuyến mãi đang hiệu lực
CREATE INDEX IX_KhuyenMai_DangHoatDong_ThoiGian ON dbo.KhuyenMai(DangHoatDong, NgayBatDau, NgayKetThuc);
CREATE INDEX IX_SanPhamKhuyenMai_KhuyenMai ON dbo.SanPhamKhuyenMai(MaKhuyenMai);

-- Đơn hàng
CREATE INDEX IX_DonHang_NguoiDung_NgayTao ON dbo.DonHang(MaNguoiDung, NgayTao DESC);
CREATE INDEX IX_DonHang_TrangThai_NgayTao ON dbo.DonHang(TrangThai, NgayTao DESC);
CREATE INDEX IX_DonHang_DaGiao ON dbo.DonHang(NgayGiaoThanhCong) WHERE TrangThai = 'DA_GIAO';
CREATE INDEX IX_ChiTietDonHang_SanPham ON dbo.ChiTietDonHang(MaSanPham);
CREATE INDEX IX_ChiTietDonHang_KhuyenMai ON dbo.ChiTietDonHang(MaKhuyenMai) WHERE MaKhuyenMai IS NOT NULL;
CREATE INDEX IX_LichSuTrangThaiDon_DonHang ON dbo.LichSuTrangThaiDon(MaDonHang, ThoiDiem);

-- Đánh giá
CREATE INDEX IX_DanhGia_SanPham ON dbo.DanhGia(MaSanPham, BiAn);

-- Giỏ hàng (tìm giỏ chứa 1 sản phẩm khi xóa / kiểm tra)
CREATE INDEX IX_GioHang_SanPham ON dbo.GioHang(MaSanPham);

-- Thành viên
CREATE INDEX IX_NguoiDung_VaiTro ON dbo.NguoiDung(VaiTro, BiKhoa);
GO

PRINT N'Tạo database CuaHangLaptop thành công.';
GO

SET NOEXEC OFF;
GO
