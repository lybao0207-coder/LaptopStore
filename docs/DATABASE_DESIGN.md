# DATABASE_DESIGN – LaptopShop

> Giai đoạn 2 – Thiết kế cơ sở dữ liệu
> Phiên bản: 1.1 (**chờ chạy kiểm tra trên SQL Server thật và chờ xác nhận**)
> Ngày: 13/11/2026
>
> | Phiên bản | Nội dung |
> |---|---|
> | 1.0 | Bản thiết kế đầu tiên (tên tiếng Anh) |
> | 1.1 | Đổi toàn bộ tên database, bảng, cột, ràng buộc, index và mã trạng thái sang tiếng Việt không dấu (DB10) |
> Căn cứ: `PROJECT_REQUIREMENTS.md` v1.1 (D01–D26, P01–P13)

## 1. Đầu ra Giai đoạn 2

| File | Nội dung |
|---|---|
| `docs/DATABASE_DESIGN.md` | Tài liệu này: thực thể, chuẩn hóa, từ điển dữ liệu, ràng buộc, chỉ mục, dữ liệu mẫu, hướng dẫn chạy |
| `docs/ERD.md` | Sơ đồ ERD (Mermaid) và bảng quan hệ |
| `database/00_drop_database.sql` | Xóa database để tạo lại từ đầu |
| `database/01_create_database.sql` | Tạo database, 15 bảng, PK, FK, UNIQUE, CHECK, DEFAULT, INDEX |
| `database/02_seed_data.sql` | Dữ liệu mẫu (1 transaction) |
| `database/03_integrity_check.sql` | Kiểm tra toàn vẹn: 2 kiểm tra môi trường + 15 kiểm tra số dòng + 16 kiểm tra nghiệp vụ + 36 kiểm tra chặn dữ liệu sai + 5 kiểm tra truy vấn nghiệp vụ |

Tất cả file SQL lưu **UTF-8 có BOM**, mọi chuỗi tiếng Việt dùng tiền tố `N'...'`.
Tương thích **SQL Server 2012 trở lên** (không dùng `CREATE OR ALTER`, `DROP ... IF EXISTS`, `STRING_AGG`).

---

## 1b. Quy ước đặt tên (DB10 – đã xác nhận 13/11/2026)

- Mọi tên trong database dùng **tiếng Việt không dấu**: tên database, bảng, cột, ràng buộc, index đều viết dạng **PascalCase** (`MaSanPham`, `NgayGiaoThanhCong`); mã trạng thái viết dạng **CHU_HOA_GACH_DUOI** (`CHO_XAC_NHAN`).
- Khóa chính: `Ma<TenBang>` (VD `MaDonHang`). Khóa ngoại cùng tên với khóa chính được tham chiếu.
- Tên ràng buộc: `PK_<Bang>`, `FK_<BangCon>_<BangCha>`, `UQ_<Bang>_<Cot>`, `CK_<Bang>_<NoiDung>`, `DF_<Bang>_<Cot>`, `IX_<Bang>_<Cot>`, `UX_` (unique index).
- Giữ nguyên: `Email`, `Webcam` (từ mượn thông dụng); tên hãng (`Intel`, `NVIDIA`…), chuẩn kỹ thuật (`DDR5`, `SSD_NVME`, `IPS`, `OLED`, `MINI_LED`); tiền tố mã đơn `LS`.
- Database: `CuaHangLaptop`.

**Bảng:**

| Bảng | Ý nghĩa |
|---|---|
| `NguoiDung` | Tài khoản |
| `DanhMuc` | Danh mục |
| `ThuongHieu` | Thương hiệu |
| `BoXuLy` | Bộ xử lý (CPU) |
| `CardDoHoa` | Card đồ họa (GPU) |
| `SanPham` | Sản phẩm laptop |
| `HinhAnhSanPham` | Hình ảnh sản phẩm |
| `KhuyenMai` | Khuyến mãi |
| `SanPhamKhuyenMai` | Liên kết sản phẩm – khuyến mãi |
| `GioHang` | Giỏ hàng (mỗi dòng 1 sản phẩm) |
| `DonHang` | Đơn hàng |
| `ChiTietDonHang` | Chi tiết đơn hàng |
| `LichSuTrangThaiDon` | Lịch sử trạng thái đơn |
| `DanhGia` | Đánh giá |
| `QuangCao` | Banner quảng cáo trang chủ |

**Mã trạng thái / mã phân loại:**

| Nhóm | Mã lưu trong DB | Ý nghĩa |
|---|---|---|
| Vai trò (`NguoiDung.VaiTro`) | `KHACH_HANG` | Khách hàng |
| Vai trò (`NguoiDung.VaiTro`) | `QUAN_TRI` | Quản trị viên |
| Trạng thái đơn (`DonHang.TrangThai`) | `CHO_XAC_NHAN` | Chờ xác nhận |
| Trạng thái đơn (`DonHang.TrangThai`) | `DA_XAC_NHAN` | Đã xác nhận |
| Trạng thái đơn (`DonHang.TrangThai`) | `DANG_GIAO` | Đang giao |
| Trạng thái đơn (`DonHang.TrangThai`) | `DA_GIAO` | Đã giao |
| Trạng thái đơn (`DonHang.TrangThai`) | `DA_HUY` | Đã hủy |
| Trạng thái thanh toán (`DonHang.TrangThaiThanhToan`) | `CHUA_THANH_TOAN` | Chưa thanh toán |
| Trạng thái thanh toán (`DonHang.TrangThaiThanhToan`) | `DA_THANH_TOAN` | Đã thanh toán |
| Trạng thái thanh toán (`DonHang.TrangThaiThanhToan`) | `DA_HOAN_TIEN` | Đã hoàn tiền |
| Phương thức thanh toán (`DonHang.PhuongThucThanhToan`) | `THANH_TOAN_KHI_NHAN` | Thanh toán khi nhận hàng (COD) |
| Phương thức thanh toán (`DonHang.PhuongThucThanhToan`) | `CHUYEN_KHOAN` | Chuyển khoản ngân hàng |
| Loại giảm (`KhuyenMai.LoaiGiam`) | `PHAN_TRAM` | Giảm theo % |
| Loại giảm (`KhuyenMai.LoaiGiam`) | `SO_TIEN` | Giảm số tiền cố định |
| Trạng thái sản phẩm (`SanPham.TrangThai`) | `DANG_BAN` | Đang bán |
| Trạng thái sản phẩm (`SanPham.TrangThai`) | `NGUNG_BAN` | Ngừng kinh doanh |
| Loại card (`CardDoHoa.LoaiCard`) | `TICH_HOP` | Card tích hợp |
| Loại card (`CardDoHoa.LoaiCard`) | `ROI` | Card rời |
| Loại RAM Apple (`SanPham.LoaiRam`) | `HOP_NHAT` | Bộ nhớ hợp nhất (Apple) |

---

## 2. Phân tích dữ liệu – Thực thể

| # | Bảng | Thực thể | Nguồn yêu cầu | Ghi chú |
|---|---|---|---|---|
| 1 | `NguoiDung` | Tài khoản (khách hàng + quản trị) | U04–U08, A06, D19 | Vai trò là cột `VaiTro` + CHECK (chỉ 2 giá trị cố định) |
| 2 | `DanhMuc` | Danh mục laptop (Gaming, Văn phòng…) | A02, U02 | |
| 3 | `ThuongHieu` | Thương hiệu | A03 (P02), U02 | |
| 4 | `BoXuLy` | Model CPU | U02 (lọc CPU), U03 | Bảng tra cứu – xem 4.3 |
| 5 | `CardDoHoa` | Model GPU | U02 (lọc card đồ họa), U03 | Bảng tra cứu |
| 6 | `SanPham` | Laptop (mỗi cấu hình 1 dòng) | A04, U02, U03, D08, D23 | ~40 cột, gồm thông số kỹ thuật |
| 7 | `HinhAnhSanPham` | Ảnh sản phẩm | A04, D20 | Lưu đường dẫn tương đối |
| 8 | `KhuyenMai` | Chương trình khuyến mãi | A07, BR13–BR17 | |
| 9 | `SanPhamKhuyenMai` | Liên kết KM – SP (N–N) | A07 | Bảng trung gian |
| 10 | `GioHang` | Dòng giỏ hàng | U09, D09, D21 | Mỗi dòng là 1 SP trong giỏ; không cần bảng đầu giỏ riêng vì mỗi khách có đúng 1 giỏ |
| 11 | `DonHang` | Đơn hàng | U10–U12, A05, D10, D16, D22 | |
| 12 | `ChiTietDonHang` | Chi tiết đơn (snapshot giá) | U10, BR23 | Bảng trung gian DonHang – SanPham có thuộc tính riêng |
| 13 | `LichSuTrangThaiDon` | Lịch sử chuyển trạng thái | A05b, P12 | |
| 14 | `DanhGia` | Đánh giá | U13, A09, D18 | |
| 15 | `QuangCao` | Banner trang chủ | U01, A10 (P02) | |

Các dữ liệu **không** lưu trong DB (theo quyết định đã thống nhất):

| Dữ liệu | Lưu ở đâu | Lý do |
|---|---|---|
| Thông tin kết nối DB, đường dẫn thư mục ảnh | `db.properties` / `app.properties` (GĐ3) | NF02, D20 |
| Tài khoản ngân hàng nhận chuyển khoản | file cấu hình (GĐ3) | BR29: không ghi cứng trong code |
| Ngưỡng tồn kho thấp (= 5) | file cấu hình (GĐ3) | BR35, P11 |
| File ảnh | thư mục upload ngoài WebApp | D20 |
| Phí vận chuyển | không có | D11 |
| Coupon | không có | D15 |

---

## 3. Quan hệ

Sơ đồ đầy đủ và bảng 16 quan hệ (R01–R16) kèm hành vi khi xóa: xem **`ERD.md`**.

Tóm tắt:

- **1 – N:** NguoiDung → DonHang / GioHang / DanhGia / LichSuTrangThaiDon; DanhMuc / ThuongHieu / BoXuLy / CardDoHoa → SanPham; SanPham → HinhAnhSanPham / GioHang / ChiTietDonHang / DanhGia; DonHang → ChiTietDonHang / LichSuTrangThaiDon; KhuyenMai → ChiTietDonHang (tùy chọn).
- **N – N:** SanPham ↔ KhuyenMai (qua `SanPhamKhuyenMai`); DonHang ↔ SanPham (qua `ChiTietDonHang`); NguoiDung ↔ SanPham (qua `GioHang` và qua `DanhGia`).

---

## 4. Chuẩn hóa

### 4.1. Dạng chuẩn 1 (1NF) – giá trị nguyên tố, không nhóm lặp

| Vấn đề có thể gặp | Cách thiết kế |
|---|---|
| Lưu nhiều ảnh trong 1 cột `HinhAnh = 'a.jpg;b.jpg'` | Tách bảng `HinhAnhSanPham` (1 dòng / 1 ảnh) |
| Lưu danh sách SP được KM trong 1 cột | Tách bảng `SanPhamKhuyenMai` |
| Độ phân giải dạng chuỗi `'1920x1080'` | Tách `DoPhanGiaiNgang`, `DoPhanGiaiDoc` (kiểu số, so sánh được) |
| Thông số RAM `'16GB DDR5 4800MHz'` | Tách `DungLuongRamGB`, `LoaiRam`, `BusRamMHz` để lọc theo dung lượng |

Ngoại lệ có chủ đích: `CongKetNoi`, `KetNoiKhongDay`, `KichThuoc` lưu dạng chuỗi mô tả vì chỉ để hiển thị, không lọc, không tính toán.

### 4.2. Dạng chuẩn 2 (2NF) – không phụ thuộc một phần vào khóa ghép

Các bảng có khóa ghép: `SanPhamKhuyenMai (MaSanPham, MaKhuyenMai)` (không có cột không khóa) và `ChiTietDonHang (MaDonHang, MaSanPham)`.
Trong `ChiTietDonHang`, các cột `TenSanPham`, `MaSku`, `DonGiaGoc` **có vẻ** chỉ phụ thuộc `MaSanPham`. Thực tế đây là **giá trị tại thời điểm đặt của đơn đó** (BR23), nên phụ thuộc vào cả `(MaDonHang, MaSanPham)`. Ví dụ: sản phẩm 1 đổi giá vào tháng 9 thì đơn tháng 8 và đơn tháng 10 có `DonGiaGoc` khác nhau → đạt 2NF.

### 4.3. Dạng chuẩn 3 (3NF) – không phụ thuộc bắc cầu

| Phụ thuộc bắc cầu | Cách xử lý |
|---|---|
| `SanPham → CPU model → số nhân, số luồng, xung nhịp, hãng, dòng` | Tách bảng `BoXuLy`; `SanPham` chỉ giữ `MaBoXuLy` |
| `SanPham → GPU model → hãng, loại, VRAM` | Tách bảng `CardDoHoa`; `SanPham` chỉ giữ `MaCardDoHoa` |
| `SanPham → MaThuongHieu → tên hãng, quốc gia` | Bảng `ThuongHieu` |
| `SanPham → MaDanhMuc → tên danh mục` | Bảng `DanhMuc` |
| `DonHang → MaNguoiDung → họ tên, SĐT` | Không bắc cầu: `TenNguoiNhan`, `SdtNguoiNhan`, `DiaChiGiaoHang` là **thông tin người nhận của đơn** (BR24), có thể khác hồ sơ tài khoản |

### 4.4. Phi chuẩn hóa có chủ đích

| Cột | Lặp lại / suy ra từ | Lý do giữ lại | Cách đảm bảo nhất quán |
|---|---|---|---|
| `DonHang.TongTien` | `SUM(ChiTietDonHang.ThanhTien)` | Danh sách đơn, Dashboard không phải cộng lại mỗi lần | Ghi cùng transaction đặt hàng; `03_integrity_check.sql` B01 |
| `ChiTietDonHang.TienGiam`, `ThanhTien` | `DonGiaGoc`, `DonGiaBan`, `SoLuong` | Truy vấn thống kê đơn giản | **Cột tính toán `PERSISTED`** – DB tự tính, không thể sai |
| `DonHang.MaDonHienThi` | `MaDonHang` | Mã hiển thị / nội dung chuyển khoản | Cột tính toán `PERSISTED` + UNIQUE |
| `DonHang.NgayThanhToan`, `NgayXacNhan`, `NgayBanGiao`, `NgayGiaoThanhCong`, `NgayHuy` | `LichSuTrangThaiDon` | Thống kê doanh thu theo `NgayGiaoThanhCong` (D13, P10) không cần JOIN lịch sử | CHECK ràng buộc mốc thời gian theo trạng thái; B06 kiểm tra lịch sử khớp trạng thái |
| `ChiTietDonHang.TenSanPham`, `MaSku`, `DonGiaGoc`, `DonGiaBan` | `SanPham` | Snapshot đơn hàng (BR23) | Không cập nhật sau khi đặt |
| Thông số kỹ thuật nằm trong `SanPham` (không tách bảng `ThongSoSanPham` 1–1) | – | Lọc nhiều tiêu chí không cần JOIN thêm | Không phải phi chuẩn hóa (quan hệ 1–1 vẫn đạt 3NF) |

---

## 5. Từ điển dữ liệu

> Sinh tự động từ `01_create_database.sql` (đảm bảo khớp script). Ký hiệu: PK = khóa chính, FK = khóa ngoại (kèm hành vi khi xóa cha), UQ = duy nhất.
> Kiểu tiền: `DECIMAL(18,0)` (VND, không có phần lẻ). Thời gian: `DATETIME2(0)` theo giờ máy chủ (Asia/Bangkok).

### NguoiDung

| Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|
| MaNguoiDung | INT IDENTITY | Không | PK |  | Mã tài khoản |
| Email | VARCHAR(100) | Không | UQ |  | Email đăng nhập, duy nhất (không phân biệt hoa thường) |
| MatKhauBam | VARCHAR(200) | Không |  |  | Mật khẩu đã băm PBKDF2: `pbkdf2_sha256$vòng$salt$hash` |
| HoTen | NVARCHAR(100) | Không |  |  | Họ tên |
| SoDienThoai | VARCHAR(10) | Không |  |  | Số điện thoại 10 số, bắt đầu bằng 0 |
| DiaChi | NVARCHAR(255) | Có |  |  | Địa chỉ giao hàng mặc định |
| VaiTro | VARCHAR(20) | Không |  | KHACH_HANG | KHACH_HANG / QUAN_TRI |
| BiKhoa | BIT | Không |  | 0 | 1 = bị khóa |
| NgayTao | DATETIME2(0) | Không |  | SYSDATETIME() | Thời điểm tạo |
| NgayCapNhat | DATETIME2(0) | Có |  |  | Thời điểm cập nhật gần nhất |

CHECK: `CK_NguoiDung_VaiTro`, `CK_NguoiDung_Email`, `CK_NguoiDung_SoDienThoai`, `CK_NguoiDung_MatKhauBam`, `CK_NguoiDung_HoTen`

### DanhMuc

| Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|
| MaDanhMuc | INT IDENTITY | Không | PK |  | Mã danh mục |
| TenDanhMuc | NVARCHAR(100) | Không | UQ |  | Tên danh mục, duy nhất |
| DuongDanUrl | VARCHAR(120) | Không | UQ |  | Chuỗi URL (a-z, 0-9, -) |
| MoTa | NVARCHAR(500) | Có |  |  | Mô tả |
| DangHoatDong | BIT | Không |  | 1 | 1 = đang hoạt động / hiển thị |
| NgayTao | DATETIME2(0) | Không |  | SYSDATETIME() | Thời điểm tạo |

CHECK: `CK_DanhMuc_DuongDanUrl`

### ThuongHieu

| Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|
| MaThuongHieu | INT IDENTITY | Không | PK |  | Mã thương hiệu |
| TenThuongHieu | NVARCHAR(100) | Không | UQ |  | Tên thương hiệu, duy nhất |
| DuongDanUrl | VARCHAR(120) | Không | UQ |  | Chuỗi URL (a-z, 0-9, -) |
| QuocGia | NVARCHAR(50) | Có |  |  | Quốc gia |
| DuongDanLogo | NVARCHAR(500) | Có |  |  | Đường dẫn tương đối logo |
| DangHoatDong | BIT | Không |  | 1 | 1 = đang hoạt động / hiển thị |
| NgayTao | DATETIME2(0) | Không |  | SYSDATETIME() | Thời điểm tạo |

CHECK: `CK_ThuongHieu_DuongDanUrl`

### BoXuLy

| Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|
| MaBoXuLy | INT IDENTITY | Không | PK |  | Mã CPU |
| HangSanXuat | VARCHAR(20) | Không |  |  | Hãng sản xuất |
| DongChip | VARCHAR(30) | Không |  |  | Dòng chip (dùng để lọc): Core i5, Ryzen 7... |
| TenModel | VARCHAR(50) | Không | UQ |  | Tên model, duy nhất |
| SoNhan | TINYINT | Không |  |  | Số nhân |
| SoLuongLuong | TINYINT | Không |  |  | Số luồng |
| XungNhipToiDaGHz | DECIMAL(3,2) | Có |  |  | Xung nhịp tối đa (GHz) |

CHECK: `CK_BoXuLy_HangSanXuat`, `CK_BoXuLy_SoNhan`, `CK_BoXuLy_SoLuongLuong`, `CK_BoXuLy_XungNhip`

### CardDoHoa

| Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|
| MaCardDoHoa | INT IDENTITY | Không | PK |  | Mã GPU |
| HangSanXuat | VARCHAR(20) | Không |  |  | Hãng sản xuất |
| TenModel | VARCHAR(60) | Không | UQ |  | Tên model, duy nhất |
| LoaiCard | VARCHAR(10) | Không |  |  | TICH_HOP / ROI |
| BoNhoVramGB | TINYINT | Có |  |  | VRAM (GB), NULL nếu tích hợp |

CHECK: `CK_CardDoHoa_HangSanXuat`, `CK_CardDoHoa_Loai`, `CK_CardDoHoa_Vram`

### SanPham

| Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|
| MaSanPham | INT IDENTITY | Không | PK |  | Mã sản phẩm |
| MaSku | VARCHAR(50) | Không | UQ |  | Mã SKU, duy nhất |
| TenSanPham | NVARCHAR(200) | Không | UQ |  | Tên sản phẩm, duy nhất |
| DuongDanUrl | VARCHAR(220) | Không | UQ |  | Chuỗi URL (a-z, 0-9, -) |
| MaDanhMuc | INT | Không | FK → DanhMuc (NO ACTION) |  | Mã danh mục |
| MaThuongHieu | INT | Không | FK → ThuongHieu (NO ACTION) |  | Mã thương hiệu |
| DongMay | NVARCHAR(100) | Có |  |  | Dòng máy: Inspiron, ThinkPad, ROG... |
| MoTaNgan | NVARCHAR(500) | Có |  |  | Mô tả ngắn |
| MoTa | NVARCHAR(MAX) | Có |  |  | Mô tả |
| GiaBan | DECIMAL(18,0) | Không |  |  | Giá bán gốc (VND) |
| SoLuongTon | INT | Không |  | 0 | Tồn kho |
| BaoHanhThang | TINYINT | Không |  | 12 | Bảo hành (tháng) |
| MaBoXuLy | INT | Không | FK → BoXuLy (NO ACTION) |  | Mã CPU |
| MaCardDoHoa | INT | Không | FK → CardDoHoa (NO ACTION) |  | Mã GPU |
| DungLuongRamGB | SMALLINT | Không |  |  | Dung lượng RAM (GB) |
| LoaiRam | VARCHAR(20) | Không |  |  | Loại RAM |
| BusRamMHz | SMALLINT | Có |  |  | Bus RAM (MHz) |
| SoKheRam | TINYINT | Có |  |  | Số khe RAM (0 = hàn chết) |
| RamToiDaGB | SMALLINT | Có |  |  | RAM tối đa hỗ trợ |
| DungLuongOCungGB | SMALLINT | Không |  |  | Dung lượng ổ cứng (GB) |
| LoaiOCung | VARCHAR(10) | Không |  |  | SSD_NVME / SSD_SATA / HDD |
| KichThuocManHinhInch | DECIMAL(3,1) | Không |  |  | Kích thước màn hình (inch) |
| DoPhanGiaiNgang | SMALLINT | Không |  |  | Độ phân giải ngang |
| DoPhanGiaiDoc | SMALLINT | Không |  |  | Độ phân giải dọc |
| TamNen | VARCHAR(10) | Không |  |  | Tấm nền |
| TanSoQuetHz | SMALLINT | Không |  | 60 | Tần số quét (Hz) |
| CamUng | BIT | Không |  | 0 | Màn hình cảm ứng |
| DungLuongPinWh | DECIMAL(4,1) | Không |  |  | Dung lượng pin (Wh) |
| TrongLuongKg | DECIMAL(3,2) | Không |  |  | Trọng lượng (kg) |
| KichThuoc | NVARCHAR(50) | Có |  |  | Kích thước máy |
| ChatLieu | NVARCHAR(50) | Có |  |  | Chất liệu vỏ |
| MauSac | NVARCHAR(50) | Có |  |  | Màu sắc |
| CongKetNoi | NVARCHAR(500) | Có |  |  | Cổng kết nối |
| KetNoiKhongDay | NVARCHAR(100) | Có |  |  | Wi-Fi, Bluetooth |
| Webcam | NVARCHAR(50) | Có |  |  | Webcam |
| DenBanPhim | BIT | Không |  | 0 | Đèn nền bàn phím |
| HeDieuHanh | NVARCHAR(50) | Không |  |  | Hệ điều hành |
| NamRaMat | SMALLINT | Có |  |  | Năm ra mắt |
| TrangThai | VARCHAR(20) | Không |  | DANG_BAN | DANG_BAN / NGUNG_BAN (ngừng kinh doanh) |
| NgayTao | DATETIME2(0) | Không |  | SYSDATETIME() | Thời điểm tạo |
| NgayCapNhat | DATETIME2(0) | Có |  |  | Thời điểm cập nhật gần nhất |

CHECK: `CK_SanPham_DuongDanUrl`, `CK_SanPham_GiaBan`, `CK_SanPham_SoLuongTon`, `CK_SanPham_BaoHanh`, `CK_SanPham_Ram`, `CK_SanPham_LoaiRam`, `CK_SanPham_BusRam`, `CK_SanPham_SoKheRam`, `CK_SanPham_RamToiDa`, `CK_SanPham_OCung`, `CK_SanPham_LoaiOCung`, `CK_SanPham_ManHinh`, `CK_SanPham_DoPhanGiai`, `CK_SanPham_TamNen`, `CK_SanPham_TanSoQuet`, `CK_SanPham_Pin`, `CK_SanPham_TrongLuong`, `CK_SanPham_NamRaMat`, `CK_SanPham_TrangThai`

### HinhAnhSanPham

| Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|
| MaHinhAnh | INT IDENTITY | Không | PK |  | Mã ảnh |
| MaSanPham | INT | Không | FK → SanPham (CASCADE) |  | Mã sản phẩm |
| DuongDanAnh | NVARCHAR(500) | Không | UQ |  | Đường dẫn tương đối của file ảnh |
| LaAnhDaiDien | BIT | Không |  | 0 | 1 = ảnh đại diện |
| ThuTu | INT | Không |  | 0 | Thứ tự hiển thị |
| NgayTao | DATETIME2(0) | Không |  | SYSDATETIME() | Thời điểm tạo |

CHECK: `CK_HinhAnhSanPham_DuongDan`, `CK_HinhAnhSanPham_ThuTu`

### KhuyenMai

| Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|
| MaKhuyenMai | INT IDENTITY | Không | PK |  | Mã khuyến mãi |
| TenKhuyenMai | NVARCHAR(150) | Không | UQ |  | Tên chương trình khuyến mãi, duy nhất |
| MoTa | NVARCHAR(500) | Có |  |  | Mô tả |
| LoaiGiam | VARCHAR(10) | Không |  |  | PHAN_TRAM / SO_TIEN |
| GiaTriGiam | DECIMAL(18,0) | Không |  |  | % (1-90) hoặc số tiền VND |
| NgayBatDau | DATETIME2(0) | Không |  |  | Bắt đầu |
| NgayKetThuc | DATETIME2(0) | Không |  |  | Kết thúc |
| DangHoatDong | BIT | Không |  | 1 | 1 = đang hoạt động / hiển thị |
| NgayTao | DATETIME2(0) | Không |  | SYSDATETIME() | Thời điểm tạo |

CHECK: `CK_KhuyenMai_Loai`, `CK_KhuyenMai_GiaTri`, `CK_KhuyenMai_ThoiGian`

### SanPhamKhuyenMai

| Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|
| MaSanPham | INT | Không | PK, FK → SanPham (CASCADE) |  | Mã sản phẩm |
| MaKhuyenMai | INT | Không | PK, FK → KhuyenMai (CASCADE) |  | Mã khuyến mãi |

### GioHang

| Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|
| MaGioHang | INT IDENTITY | Không | PK |  | Mã dòng giỏ hàng |
| MaNguoiDung | INT | Không | FK → NguoiDung (CASCADE), UQ(MaNguoiDung+MaSanPham) |  | Mã tài khoản |
| MaSanPham | INT | Không | FK → SanPham (CASCADE), UQ(MaNguoiDung+MaSanPham) |  | Mã sản phẩm |
| SoLuong | TINYINT | Không |  |  | Số lượng (1-5) |
| NgayThem | DATETIME2(0) | Không |  | SYSDATETIME() | Thời điểm thêm |
| NgayCapNhat | DATETIME2(0) | Có |  |  | Thời điểm cập nhật gần nhất |

CHECK: `CK_GioHang_SoLuong`

### DonHang

| Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|
| MaDonHang | INT IDENTITY | Không | PK |  | Mã đơn |
| MaDonHienThi | Tính toán (PERSISTED) | – | UQ | – | Mã đơn hiển thị LS000001 (cột tính toán) |
| MaNguoiDung | INT | Không | FK → NguoiDung (NO ACTION) |  | Mã tài khoản |
| TenNguoiNhan | NVARCHAR(100) | Không |  |  | Tên người nhận |
| SdtNguoiNhan | VARCHAR(10) | Không |  |  | SĐT người nhận |
| DiaChiGiaoHang | NVARCHAR(255) | Không |  |  | Địa chỉ giao hàng |
| GhiChu | NVARCHAR(500) | Có |  |  | Ghi chú |
| PhuongThucThanhToan | VARCHAR(20) | Không |  |  | THANH_TOAN_KHI_NHAN / CHUYEN_KHOAN |
| TrangThaiThanhToan | VARCHAR(20) | Không |  | CHUA_THANH_TOAN | CHUA_THANH_TOAN / DA_THANH_TOAN / DA_HOAN_TIEN |
| TrangThai | VARCHAR(20) | Không |  | CHO_XAC_NHAN | CHO_XAC_NHAN / DA_XAC_NHAN / DANG_GIAO / DA_GIAO / DA_HUY |
| TongTien | DECIMAL(18,0) | Không |  |  | Tổng thanh toán (VND) |
| NgayTao | DATETIME2(0) | Không |  | SYSDATETIME() | Thời điểm tạo |
| NgayThanhToan | DATETIME2(0) | Có |  |  | Thời điểm ghi nhận thanh toán |
| NgayXacNhan | DATETIME2(0) | Có |  |  | Thời điểm xác nhận |
| NgayBanGiao | DATETIME2(0) | Có |  |  | Thời điểm bàn giao vận chuyển |
| NgayGiaoThanhCong | DATETIME2(0) | Có |  |  | Thời điểm giao thành công (mốc doanh thu) |
| NgayHuy | DATETIME2(0) | Có |  |  | Thời điểm hủy |
| NgayCapNhat | DATETIME2(0) | Có |  |  | Thời điểm cập nhật gần nhất |

CHECK: `CK_DonHang_SdtNguoiNhan`, `CK_DonHang_PhuongThucThanhToan`, `CK_DonHang_TrangThaiThanhToan`, `CK_DonHang_TrangThai`, `CK_DonHang_TongTien`, `CK_DonHang_NgayThanhToan`, `CK_DonHang_NgayXacNhan`, `CK_DonHang_NgayBanGiao`, `CK_DonHang_NgayGiaoThanhCong`, `CK_DonHang_NgayHuy`, `CK_DonHang_ThuTuThoiGian`, `CK_DonHang_DaGiaoDaThanhToan`, `CK_DonHang_ChuyenKhoanTraTruocXacNhan`, `CK_DonHang_KhiNhanKhongTraSom`, `CK_DonHang_KhiNhanKhongHoanTien`, `CK_DonHang_HoanTienChiKhiHuy`, `CK_DonHang_DaHuyKhongDaThanhToan`

### ChiTietDonHang

| Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|
| MaDonHang | INT | Không | PK, FK → DonHang (NO ACTION) |  | Mã đơn |
| MaSanPham | INT | Không | PK, FK → SanPham (NO ACTION) |  | Mã sản phẩm |
| TenSanPham | NVARCHAR(200) | Không |  |  | Tên SP lúc đặt (snapshot) |
| MaSku | VARCHAR(50) | Không |  |  | SKU lúc đặt (snapshot) |
| DonGiaGoc | DECIMAL(18,0) | Không |  |  | Giá gốc lúc đặt |
| DonGiaBan | DECIMAL(18,0) | Không |  |  | Giá sau KM lúc đặt |
| MaKhuyenMai | INT | Có | FK → KhuyenMai (NO ACTION) |  | Mã khuyến mãi |
| SoLuong | TINYINT | Không |  |  | Số lượng (1-5) |
| TienGiam | Tính toán (PERSISTED) | – |  | – | Số tiền giảm / 1 SP (cột tính toán) |
| ThanhTien | Tính toán (PERSISTED) | – |  | – | Thành tiền (cột tính toán) |

CHECK: `CK_ChiTietDonHang_SoLuong`, `CK_ChiTietDonHang_DonGia`, `CK_ChiTietDonHang_KhuyenMai`

### LichSuTrangThaiDon

| Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|
| MaLichSu | INT IDENTITY | Không | PK |  | Mã lịch sử |
| MaDonHang | INT | Không | FK → DonHang (NO ACTION) |  | Mã đơn |
| TuTrangThai | VARCHAR(20) | Có |  |  | Trạng thái cũ (NULL khi tạo đơn) |
| SangTrangThai | VARCHAR(20) | Không |  |  | Trạng thái mới |
| NguoiThucHien | INT | Không | FK → NguoiDung (NO ACTION) |  | Người thao tác |
| GhiChu | NVARCHAR(255) | Có |  |  | Ghi chú |
| ThoiDiem | DATETIME2(0) | Không |  | SYSDATETIME() | Thời điểm |

CHECK: `CK_LichSuTrangThaiDon_TuTrangThai`, `CK_LichSuTrangThaiDon_SangTrangThai`, `CK_LichSuTrangThaiDon_ChuyenTrangThai`

### DanhGia

| Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|
| MaDanhGia | INT IDENTITY | Không | PK |  | Mã đánh giá |
| MaNguoiDung | INT | Không | FK → NguoiDung (NO ACTION), UQ(MaNguoiDung+MaSanPham) |  | Mã tài khoản |
| MaSanPham | INT | Không | FK → SanPham (NO ACTION), UQ(MaNguoiDung+MaSanPham) |  | Mã sản phẩm |
| SoSao | TINYINT | Không |  |  | Số sao 1-5 |
| NoiDung | NVARCHAR(1000) | Không |  |  | Nội dung 10-1000 ký tự |
| BiAn | BIT | Không |  | 0 | 1 = Admin đã ẩn |
| NgayTao | DATETIME2(0) | Không |  | SYSDATETIME() | Thời điểm tạo |
| NgayCapNhat | DATETIME2(0) | Có |  |  | Thời điểm cập nhật gần nhất |

CHECK: `CK_DanhGia_SoSao`, `CK_DanhGia_NoiDung`

### QuangCao

| Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|
| MaQuangCao | INT IDENTITY | Không | PK |  | Mã banner |
| TieuDe | NVARCHAR(150) | Không |  |  | Tiêu đề |
| DuongDanAnh | NVARCHAR(500) | Không |  |  | Đường dẫn tương đối của file ảnh |
| DuongDanLienKet | NVARCHAR(500) | Có |  |  | Đường dẫn nội bộ khi bấm banner |
| ThuTu | INT | Không |  | 0 | Thứ tự hiển thị |
| DangHoatDong | BIT | Không |  | 1 | 1 = đang hoạt động / hiển thị |
| NgayTao | DATETIME2(0) | Không |  | SYSDATETIME() | Thời điểm tạo |

CHECK: `CK_QuangCao_DuongDan`, `CK_QuangCao_LienKet`, `CK_QuangCao_ThuTu`


---

## 6. Ràng buộc toàn vẹn

### 6.1. Phân loại

| Loại | Thực hiện bằng | Ví dụ |
|---|---|---|
| Toàn vẹn thực thể | `PRIMARY KEY` (15 bảng) | `PK_SanPham` |
| Toàn vẹn tham chiếu | `FOREIGN KEY` (17 khóa ngoại) + hành vi xóa | `FK_ChiTietDonHang_SanPham` (NO ACTION) |
| Duy nhất | `UNIQUE` (15 ràng buộc) + 1 filtered unique index | Email, SKU, (MaNguoiDung, MaSanPham) trong giỏ và đánh giá, 1 ảnh đại diện / SP |
| Miền giá trị | `CHECK` (67) | Giá > 0, tồn kho ≥ 0, 1–5 sao, số lượng 1–5, SĐT 10 số |
| Nghiệp vụ nhiều cột | `CHECK` cấp bảng | Đơn chuyển khoản phải `DA_THANH_TOAN` trước `DA_XAC_NHAN` (D22), mốc thời gian khớp trạng thái |
| Nghiệp vụ nhiều bảng | Backend (GĐ4) + kiểm tra ở `03_integrity_check.sql` | Chỉ đánh giá khi đã có đơn `DA_GIAO` |

### 6.2. Quy tắc nghiệp vụ được DB chặn trực tiếp

| Quy tắc | Ràng buộc |
|---|---|
| BR01 Email duy nhất, SĐT 10 số | `UQ_NguoiDung_Email`, `CK_NguoiDung_SoDienThoai`, `CK_DonHang_SdtNguoiNhan` |
| BR02 Không lưu mật khẩu thô | `CK_NguoiDung_MatKhauBam` (phải có dạng `pbkdf2_sha256$...`) |
| D19 Chỉ KHACH_HANG / QUAN_TRI | `CK_NguoiDung_VaiTro` |
| BR07, BR08 Giá > 0, tồn kho ≥ 0 | `CK_SanPham_GiaBan`, `CK_SanPham_SoLuongTon` |
| BR09 SP đã bán không xóa cứng | `FK_ChiTietDonHang_SanPham` (NO ACTION) |
| BR11 Danh mục / thương hiệu còn SP không xóa được | `FK_SanPham_DanhMuc`, `FK_SanPham_ThuongHieu` |
| BR12 SKU, tên SP duy nhất | `UQ_SanPham_MaSku`, `UQ_SanPham_Ten` |
| BR13, BR14 Loại và mức giảm KM, ngày hợp lệ | `CK_KhuyenMai_Loai`, `CK_KhuyenMai_GiaTri`, `CK_KhuyenMai_ThoiGian` |
| KM đã dùng trong đơn không xóa được | `FK_ChiTietDonHang_KhuyenMai` (NO ACTION) |
| BR20 Mỗi SP 1 dòng trong giỏ | `UQ_GioHang_NguoiDung_SanPham` |
| D21 Tối đa 5 máy / SP | `CK_GioHang_SoLuong`, `CK_ChiTietDonHang_SoLuong` |
| BR23 Giá snapshot hợp lệ | `CK_ChiTietDonHang_DonGia`, `CK_ChiTietDonHang_KhuyenMai` |
| D16 Trạng thái đơn hợp lệ | `CK_DonHang_TrangThai` |
| BR26, BR27 Chỉ chuyển trạng thái theo đúng luồng | `CK_LichSuTrangThaiDon_ChuyenTrangThai` |
| BR29, D22 Thanh toán | `CK_DonHang_ChuyenKhoanTraTruocXacNhan`, `CK_DonHang_DaGiaoDaThanhToan`, `CK_DonHang_KhiNhanKhongTraSom`, `CK_DonHang_KhiNhanKhongHoanTien`, `CK_DonHang_HoanTienChiKhiHuy`, `CK_DonHang_DaHuyKhongDaThanhToan` |
| D13 Có mốc tính doanh thu | `CK_DonHang_NgayGiaoThanhCong` |
| BR31 Mỗi khách 1 đánh giá / SP | `UQ_DanhGia_NguoiDung_SanPham` |
| BR32 1–5 sao, 10–1000 ký tự | `CK_DanhGia_SoSao`, `CK_DanhGia_NoiDung` |
| NF05 Chống path traversal đường dẫn ảnh | `CK_HinhAnhSanPham_DuongDan`, `CK_QuangCao_DuongDan` |
| Banner chỉ trỏ đường dẫn nội bộ | `CK_QuangCao_LienKet` |
| Mỗi SP tối đa 1 ảnh đại diện | `UX_HinhAnhSanPham_AnhDaiDien` (filtered unique index) |

### 6.3. Quy tắc phải kiểm tra ở Backend (DB không tự chặn được)

| Quy tắc | Lý do DB không chặn | Xử lý ở GĐ4 | Kiểm tra dữ liệu |
|---|---|---|---|
| BR22 Trừ kho không bán vượt | Cần kiểm tra trong transaction đặt hàng | `UPDATE ... SET SoLuongTon = SoLuongTon - ? WHERE MaSanPham = ? AND SoLuongTon >= ?`, kiểm tra số dòng | 03 – C35 |
| BR18 Số lượng ≤ tồn kho | Tồn kho thay đổi liên tục | Kiểm tra khi thêm giỏ, checkout | – |
| BR30 Chỉ đánh giá khi đã có đơn DA_GIAO | Điều kiện trên nhiều bảng | `ReviewDAO` kiểm tra trước khi lưu | 03 – B04 |
| BR16 Chọn KM giảm nhiều nhất | Phép tính theo thời điểm | Một hàm tính giá dùng chung (S03) | 03 – D01 |
| BR14 KM không làm giá ≤ 0 khi gắn SP | Điều kiện trên 2 bảng | Kiểm tra khi gắn SP | 03 – B11 |
| BR05 Luôn còn ≥ 1 QUAN_TRI hoạt động | Điều kiện trên toàn bảng | Kiểm tra khi khóa / đổi vai trò | 03 – B14 |
| BR26 Trạng thái trên `DonHang` đổi đúng thứ tự | CHECK chỉ thấy 1 dòng | Cập nhật `DonHang` + ghi `LichSuTrangThaiDon` trong cùng transaction | 03 – B06, B07 |
| BR10 SP ngừng KD không thêm vào giỏ | Phụ thuộc trạng thái SP | `CartServlet` kiểm tra | – |

---

## 7. Chỉ mục (INDEX)

Ngoài index tự tạo cho PK và UNIQUE, script tạo 23 index thường + 1 filtered unique index:

| Index | Phục vụ |
|---|---|
| `IX_SanPham_TrangThai_GiaBan`, `IX_SanPham_TrangThai_NgayTao` | Danh sách SP đang bán, sắp xếp theo giá / ngày đăng (U02.11), SP mới (U01.3) |
| `IX_SanPham_DanhMuc`, `_ThuongHieu`, `_BoXuLy`, `_CardDoHoa`, `_Ram`, `_OCung`, `_ManHinh`, `_SoLuongTon` | Lọc theo từng tiêu chí (U02), tồn kho thấp (A01) |
| `IX_BoXuLy_Dong` | Lọc theo dòng CPU (Core i5, Ryzen 7…) |
| `IX_KhuyenMai_DangHoatDong_ThoiGian`, `IX_SanPhamKhuyenMai_KhuyenMai` | Tìm KM đang hiệu lực, SP thuộc 1 KM |
| `IX_DonHang_NguoiDung_NgayTao` | Lịch sử đơn của khách (U11) |
| `IX_DonHang_TrangThai_NgayTao` | Admin lọc đơn theo trạng thái (A05), đơn mới (A01) |
| `IX_DonHang_DaGiao` (filtered) | Doanh thu, bán chạy theo tháng/năm (D13, D26) |
| `IX_ChiTietDonHang_SanPham` | Bán chạy, kiểm tra SP đã có đơn (BR09) |
| `IX_ChiTietDonHang_KhuyenMai` (filtered) | Kiểm tra KM đã được dùng |
| `IX_LichSuTrangThaiDon_DonHang` | Xem lịch sử 1 đơn |
| `IX_DanhGia_SanPham` | Đánh giá + điểm trung bình của SP |
| `IX_GioHang_SanPham` | Tìm giỏ chứa SP (khi SP ngừng KD) |
| `IX_HinhAnhSanPham_SanPham` | Lấy ảnh theo thứ tự |
| `IX_NguoiDung_VaiTro` | Admin lọc thành viên |

Tìm theo tên bằng `LIKE N'%từ khóa%'` không dùng được index. Với khoảng 50 sản phẩm thì điều này không ảnh hưởng hiệu năng. Full-Text Search không nằm trong phạm vi.

---

## 8. Quyết định thiết kế mới trong Giai đoạn 2 (DB01–DB09: đề xuất, cần xác nhận · DB10: đã xác nhận)

| Mã | Quyết định | Lý do |
|---|---|---|
| DB01 | Tên database `CuaHangLaptop`, collation `Vietnamese_CI_AS` | Sắp xếp / so sánh tiếng Việt đúng; không phân biệt hoa thường; phân biệt dấu |
| DB02 | Mật khẩu: PBKDF2-HMAC-SHA256, **600.000 vòng lặp**, salt 16 byte, hash 32 byte, lưu 1 chuỗi `pbkdf2_sha256$600000$<salt Base64>$<hash Base64>` | Theo khuyến nghị OWASP cho PBKDF2-SHA256 (theo hiểu biết của mình, chưa đối chiếu lại tài liệu OWASP mới nhất). Lưu số vòng lặp trong chuỗi để sau này đổi tham số không làm hỏng mật khẩu cũ. [Inference] Mỗi lần đăng nhập mất khoảng vài trăm ms. Giải quyết C9 |
| DB03 | Tách bảng tra cứu `BoXuLy`, `CardDoHoa` | Đạt 3NF; bộ lọc CPU/GPU lấy danh sách từ DB |
| DB04 | Trạng thái, vai trò, loại KM… dùng `VARCHAR` + `CHECK`, không tách bảng tra cứu | Tập giá trị cố định, gắn với logic code; tránh JOIN thừa |
| DB05 | Mã đơn `MaDonHienThi` = `LS` + 6 chữ số của `MaDonHang` (cột tính toán) | Không cần sinh mã trong code, không trùng |
| DB06 | Không có Admin quản lý CPU/GPU qua giao diện; danh sách CPU/GPU nạp bằng SQL. Form sản phẩm chọn từ danh sách có sẵn | Giữ phạm vi đồ án; có thể bổ sung màn hình sau |
| DB07 | Tài khoản không bao giờ xóa, chỉ khóa (FK `DonHang.MaNguoiDung` NO ACTION) | Giữ lịch sử đơn hàng |
| DB08 | Tên sản phẩm là duy nhất (đã có ở BR12) và slug sinh từ tên | URL thân thiện `/product/dell-inspiron-15-3530-...` |
| DB09 | Thời gian lưu theo giờ máy chủ (`SYSDATETIME()`), không lưu múi giờ | Hệ thống chỉ phục vụ Việt Nam |
| DB10 ✅ | Toàn bộ tên trong DB bằng tiếng Việt không dấu PascalCase; mã trạng thái tiếng Việt không dấu (mục 1b) | **Đã xác nhận** theo yêu cầu chủ dự án 13/11/2026 |

---

## 9. Dữ liệu mẫu

> Thông số kỹ thuật và giá của 46 laptop **chỉ mang tính minh họa cho đồ án**. Mình không đối chiếu với giá bán thực tế. Tên khách hàng, email (`@laptopshop.local`), số điện thoại đều là dữ liệu giả.

### 9.1. Số lượng

| Bảng | Số dòng | Yêu cầu NF12 |
|---|---|---|
| NguoiDung | 13 (1 QUAN_TRI + 12 KHACH_HANG, 1 bị khóa) | ≥ 10 khách ✅ |
| DanhMuc | 5 | ≥ 5 ✅ |
| ThuongHieu | 7 | ≥ 6 ✅ |
| BoXuLy / CardDoHoa | 16 / 15 | |
| SanPham | 46 (44 DANG_BAN, 2 NGUNG_BAN) | ≥ 40 ✅ |
| HinhAnhSanPham | 92 (2 ảnh / SP) | |
| KhuyenMai / SanPhamKhuyenMai | 6 / 47 | |
| GioHang | 5 | |
| DonHang | 44 (12/2025 → 11/2026) | ≥ 30, rải nhiều tháng ✅ |
| ChiTietDonHang | 58 (7 dòng có áp KM) | |
| LichSuTrangThaiDon | 157 | |
| DanhGia | 31 (1 bị ẩn) | |
| QuangCao | 4 (1 không hoạt động) | |

Đơn theo trạng thái: CHO_XAC_NHAN 3 · DA_XAC_NHAN 2 · DANG_GIAO 2 · DA_GIAO 34 · DA_HUY 3.
Thanh toán: CHUA_THANH_TOAN 6 · DA_THANH_TOAN 37 · DA_HOAN_TIEN 1. Tổng doanh thu đơn DA_GIAO: **1.260.872.000 đ**.

### 9.2. Tình huống kiểm thử có sẵn trong dữ liệu

| Tình huống | Dữ liệu |
|---|---|
| Đăng nhập Admin / khách / tài khoản bị khóa | `admin@laptopshop.local`, `customer01..11@laptopshop.local`, `customer12@laptopshop.local` (khóa) |
| SP hết hàng | #30 ROG Zephyrus G14, #39 MSI Thin GF63 |
| SP tồn kho thấp (≤ 5) | #13, #22, #26, #36, #44 (+ 2 SP hết hàng) |
| SP ngừng KD **đã có đơn** (không xóa được) | #3 Dell Vostro 14 |
| SP ngừng KD **chưa có đơn** (xóa được) | #41 MSI Creator M16 |
| SP chưa bán được | 15 SP DANG_BAN (VD: #7, #23, #45) |
| 2 KM chồng nhau → lấy mức giảm lớn nhất | #6, #21, #29, #36, #40 có cả "Black Friday 10%" và "Tuần lễ Gaming −3.000.000đ" (từ 10/11 đến 20/11/2026) |
| KM bị ngừng hoạt động | "Flash Sale MacBook" (`DangHoatDong = 0`) → MacBook #42 không được giảm |
| KM đã hết hạn / sắp diễn ra | "Back to School 2026" (đã hết) / "Chào Tết 2027" (sắp tới) |
| Đơn cũ có áp KM | 7 dòng chi tiết: đơn tháng 8–9/2026 (Back to School) và tháng 11/2026 (Black Friday) |
| Đơn chuyển khoản đã trả tiền, chờ xác nhận | Đơn CHO_XAC_NHAN + CHUYEN_KHOAN + DA_THANH_TOAN |
| Hủy đơn đã chuyển khoản → DA_HOAN_TIEN | 1 đơn |
| Giỏ hàng chứa SP hết hàng (BR19) | `customer03` – SP #30 |
| Giỏ hàng đạt tối đa 5 máy | `customer04` – SP #6 |
| Đánh giá bị Admin ẩn / đã được sửa | MaDanhGia 3 / MaDanhGia 5 |

### 9.3. Tài khoản demo

| Vai trò | Email | Mật khẩu |
|---|---|---|
| QUAN_TRI | `admin@laptopshop.local` | `Admin@123` |
| KHACH_HANG | `customer01@laptopshop.local` … `customer12@laptopshop.local` | `Customer@123` |

Đây là dữ liệu demo nằm trong script seed, không phải trong mã nguồn Java (NF02). Mỗi tài khoản có salt riêng.

### 9.4. Ảnh

DB chỉ lưu đường dẫn tương đối (`products/<slug>-1.jpg`, `banners/...`). File ảnh thật **chưa có**. Cách cung cấp ảnh demo (ảnh placeholder hoặc thư mục `sample-images/`) sẽ chốt ở GĐ3 (C15).

---

## 10. Hướng dẫn chạy

### Cách 1 – SSMS (khuyến nghị)

1. Mở **SQL Server Management Studio**, kết nối bằng **Windows Authentication** (Server name: `localhost`, hoặc `.\SQLEXPRESS` nếu dùng bản Express).
2. `File > Open > File...` → mở `database/01_create_database.sql` → bấm **Execute (F5)**. Kết quả mong đợi: `Tạo database CuaHangLaptop thành công.`
3. Mở `02_seed_data.sql` → **F5**. Kết quả mong đợi: `Đã nạp dữ liệu mẫu thành công.` và bảng số dòng khớp mục 9.1.
4. Mở `03_integrity_check.sql` → **F5**. Mong đợi: bảng tổng hợp **KhongDat = 0**, thông báo `KẾT QUẢ: TẤT CẢ KIỂM TRA ĐỀU ĐẠT.`

### Cách 2 – sqlcmd (Command Prompt)

```bat
cd /d F:\STUWeb\LaptopStore\database
sqlcmd -S localhost -E -f 65001 -b -i 01_create_database.sql
sqlcmd -S localhost -E -f 65001 -b -i 02_seed_data.sql
sqlcmd -S localhost -E -f 65001 -i 03_integrity_check.sql -o 03_result.txt
```

`-E` = Windows Authentication, `-f 65001` = đọc file UTF-8, `-b` = dừng khi có lỗi. Với SQL Server Express thay `localhost` bằng `.\SQLEXPRESS`.

### Tạo lại từ đầu

Chạy `00_drop_database.sql` (xóa toàn bộ dữ liệu) → `01` → `02` → `03`.

---

## 11. Kết quả kiểm tra

### 11.1. Đã kiểm tra trong môi trường phát triển (không có SQL Server)

| Kiểm tra | Cách làm | Kết quả |
|---|---|---|
| Dữ liệu mẫu thỏa toàn bộ quy tắc | Script sinh dữ liệu tự kiểm tra: tổng tiền, giá KM đúng theo ngày đặt, luồng trạng thái, mốc thời gian, điều kiện đánh giá, UNIQUE, giới hạn số lượng… | Đạt, 0 lỗi |
| Dữ liệu thỏa CHECK dạng `LIKE`, độ dài cột, miền giá trị số | Mô phỏng `LIKE` của SQL Server trên từng giá trị | Đạt, 0 vi phạm |
| Mật khẩu băm kiểm chứng lại được | Băm lại và so sánh với chuỗi đã lưu | Đạt 13/13 |
| Cú pháp T-SQL | Parser `sqlglot` (dialect T-SQL) trên cả 4 file | 0 lỗi. Parser chỉ đọc lướt các khối `TRY/CATCH`, `IF/PRINT`, `SET IDENTITY_INSERT`, không phân tích sâu |
| ERD | Mermaid CLI | Vẽ được, không lỗi |

### 11.2. Chưa kiểm tra – cần chạy trên SQL Server thật

Môi trường của mình không cài được SQL Server. Vì vậy **chưa có lần chạy thật nào** của `01`, `02`, `03`. Giai đoạn 2 chỉ được đánh dấu hoàn thành sau khi `03_integrity_check.sql` cho **KhongDat = 0** trên máy của bạn.
