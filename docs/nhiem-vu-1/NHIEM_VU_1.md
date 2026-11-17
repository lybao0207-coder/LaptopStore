# NHIỆM VỤ 1 – Thiết kế CSDL, ERD, mô hình quan hệ, Class Diagram, Activity Diagram

Đồ án **LaptopShop** (Java JSP/Servlet/JDBC – MVC, SQL Server). Cập nhật: 15/11/2026.

> **Nguồn dữ liệu duy nhất** cho mọi bảng, cột, khóa và ràng buộc trong tài liệu này là script `database/01_create_database.sql` (database `CuaHangLaptop` đang chạy trên máy). Các bảng, từ điển dữ liệu và sơ đồ CSDL được **sinh tự động từ script**, không chép tay, nên khớp script 100%.
>
> **Mức kiểm chứng:** cấu trúc 4 bảng `DanhMuc`, `ThuongHieu`, `BoXuLy`, `CardDoHoa` đã đối chiếu với DB thật bằng truy vấn `sys.columns` (ảnh SSMS 13–15/11/2026); 11 bảng còn lại khớp script nhưng **chưa đối chiếu từng cột với DB thật**. Class Diagram phần đã cài đặt lấy từ mã nguồn đã biên dịch (`javap`); phần chưa cài đặt là **thiết kế đề xuất**.

## Mục lục

1. [Thiết kế cơ sở dữ liệu](#1-thiết-kế-cơ-sở-dữ-liệu)
2. [ERD](#2-erd)
3. [Mô hình quan hệ](#3-mô-hình-quan-hệ)
4. [Từ điển dữ liệu](#4-từ-điển-dữ-liệu)
5. [Class Diagram](#5-class-diagram)
6. [Activity Diagram](#6-activity-diagram)
7. [Danh sách file và cách mở](#7-danh-sách-file-và-cách-mở)

## 1. Thiết kế cơ sở dữ liệu

### 1.1. Tổng quan

| Hạng mục | Giá trị |
|---|---|
| Hệ quản trị | Microsoft SQL Server 2022 (16.0.1220.3), tương thích từ 2012 |
| Database | `CuaHangLaptop`, collation `Vietnamese_CI_AS` (không phân biệt hoa thường, phân biệt dấu) |
| Quy ước tên | Tiếng Việt không dấu, PascalCase (`SanPham`, `MaSanPham`); mã trạng thái tiếng Việt không dấu viết hoa (`CHO_XAC_NHAN`) |
| Số bảng | 15 |
| Số cột | 149 (trong đó 3 cột tính toán `PERSISTED`) |
| Khóa chính | 15 (2 khóa ghép: `SanPhamKhuyenMai`, `ChiTietDonHang`) |
| Khóa ngoại | 17 (5 `ON DELETE CASCADE`, còn lại `NO ACTION`) |
| UNIQUE | 15 ràng buộc + 1 filtered unique index |
| CHECK | 67 |
| DEFAULT | 29 |
| Index (ngoài PK/UQ) | 24 (gồm 1 unique, 3 filtered) |

### 1.2. Các thực thể và nhóm bảng

| Nhóm | Bảng | Ý nghĩa | Số cột |
|---|---|---|---|
| Tài khoản | `NguoiDung` | Tài khoản khách hàng và quản trị (cột VaiTro) | 10 |
| Danh mục (bảng bên 1) | `DanhMuc` | Danh mục laptop: Gaming, Văn phòng… | 6 |
| Danh mục (bảng bên 1) | `ThuongHieu` | Thương hiệu: Dell, HP… | 7 |
| Danh mục (bảng bên 1) | `BoXuLy` | Model CPU – bảng tra cứu (3NF) | 7 |
| Danh mục (bảng bên 1) | `CardDoHoa` | Model GPU – bảng tra cứu (3NF) | 5 |
| Sản phẩm | `SanPham` | Laptop, mỗi cấu hình 1 dòng, gồm thông số kỹ thuật | 41 |
| Sản phẩm | `HinhAnhSanPham` | Ảnh sản phẩm (đường dẫn tương đối) | 6 |
| Khuyến mãi | `KhuyenMai` | Chương trình khuyến mãi | 9 |
| Khuyến mãi | `SanPhamKhuyenMai` | Bảng trung gian N–N sản phẩm – khuyến mãi | 2 |
| Mua hàng | `GioHang` | Dòng giỏ hàng (lưu trong DB, gắn tài khoản) | 6 |
| Mua hàng | `DonHang` | Đơn hàng + trạng thái đơn + trạng thái thanh toán | 18 |
| Mua hàng | `ChiTietDonHang` | Chi tiết đơn – lưu snapshot tên, SKU, giá lúc đặt | 10 |
| Mua hàng | `LichSuTrangThaiDon` | Lịch sử chuyển trạng thái đơn | 7 |
| Tương tác | `DanhGia` | Đánh giá 1–5 sao, admin ẩn / hiện | 8 |
| Nội dung | `QuangCao` | Banner trang chủ | 7 |

Dữ liệu **không** lưu trong DB: thông tin kết nối và đường dẫn thư mục ảnh (file cấu hình), tài khoản ngân hàng nhận chuyển khoản (cấu hình), ngưỡng tồn kho thấp (cấu hình, mặc định 5), file ảnh (thư mục ngoài WebApp). Không có phí vận chuyển (miễn phí – D11) và không có mã giảm giá (D15).

### 1.3. Chuẩn hóa

| Dạng chuẩn | Vấn đề có thể gặp | Cách thiết kế |
|---|---|---|
| 1NF | Nhiều ảnh trong 1 cột; danh sách SP khuyến mãi trong 1 cột; độ phân giải `1920x1080`; RAM `16GB DDR5 4800MHz` | Tách bảng `HinhAnhSanPham`, `SanPhamKhuyenMai`; tách `DoPhanGiaiNgang`/`DoPhanGiaiDoc`, `DungLuongRamGB`/`LoaiRam`/`BusRamMHz` (kiểu số, lọc được) |
| 2NF | Bảng khóa ghép `ChiTietDonHang (MaDonHang, MaSanPham)` có `TenSanPham`, `MaSku`, `DonGiaGoc` tưởng chỉ phụ thuộc `MaSanPham` | Đây là giá trị **tại thời điểm đặt của đơn đó** (snapshot – BR23), phụ thuộc cả khóa ghép → đạt 2NF |
| 3NF | `SanPham → model CPU → số nhân, luồng, xung`; `SanPham → model GPU → loại, VRAM`; `SanPham → MaThuongHieu → tên hãng` | Tách `BoXuLy`, `CardDoHoa`, `ThuongHieu`, `DanhMuc`; `SanPham` chỉ giữ khóa ngoại |
| 3NF | `DonHang → MaNguoiDung → họ tên, SĐT` | Không bắc cầu: `TenNguoiNhan`, `SdtNguoiNhan`, `DiaChiGiaoHang` là thông tin **người nhận của đơn**, có thể khác hồ sơ (BR24) |

Ngoại lệ 1NF có chủ đích: `CongKetNoi`, `KetNoiKhongDay`, `KichThuoc` lưu chuỗi mô tả vì chỉ hiển thị, không lọc, không tính toán.

**Phi chuẩn hóa có chủ đích** (đều có cơ chế giữ nhất quán):

| Cột | Suy ra từ | Lý do | Đảm bảo nhất quán |
|---|---|---|---|
| `DonHang.TongTien` | `SUM(ChiTietDonHang.ThanhTien)` | Danh sách đơn, Dashboard không phải cộng lại | Ghi trong cùng transaction đặt hàng |
| `ChiTietDonHang.TienGiam`, `ThanhTien` | `DonGiaGoc`, `DonGiaBan`, `SoLuong` | Thống kê đơn giản | Cột tính toán `PERSISTED` – DB tự tính |
| `DonHang.MaDonHienThi` | `MaDonHang` | Mã hiển thị / nội dung chuyển khoản `LS000001` | Cột tính toán `PERSISTED` + UNIQUE |
| `DonHang.NgayThanhToan`, `NgayXacNhan`, `NgayBanGiao`, `NgayGiaoThanhCong`, `NgayHuy` | `LichSuTrangThaiDon` | Thống kê doanh thu theo ngày giao không cần JOIN | CHECK ràng buộc mốc thời gian theo trạng thái |
| `ChiTietDonHang.TenSanPham`, `MaSku`, `DonGiaGoc`, `DonGiaBan` | `SanPham` | Snapshot đơn hàng (BR23) | Không cập nhật sau khi đặt |

### 1.4. Ràng buộc toàn vẹn

| Loại | Thực hiện bằng | Số lượng / ví dụ |
|---|---|---|
| Toàn vẹn thực thể | PRIMARY KEY | 15 |
| Toàn vẹn tham chiếu | FOREIGN KEY + hành vi khi xóa | 17 (xem 3.3) |
| Duy nhất | UNIQUE + filtered unique index | 15 + `UX_HinhAnhSanPham_AnhDaiDien` (mỗi SP tối đa 1 ảnh đại diện) |
| Miền giá trị, nghiệp vụ trên 1 dòng | CHECK | 67 (liệt kê đầy đủ ở mục 4) |
| Nghiệp vụ trên nhiều bảng | Backend + transaction | Trừ kho không bán vượt (BR22), chỉ đánh giá khi đã có đơn `DA_GIAO` (BR30), luôn còn ≥ 1 `QUAN_TRI` hoạt động (BR05), chọn KM giảm nhiều nhất (BR16) |

Các quy tắc nghiệp vụ quan trọng được DB chặn trực tiếp:

- **Email duy nhất, SĐT 10 số bắt đầu bằng 0 (BR01):** `UQ_NguoiDung_Email`, `CK_NguoiDung_SoDienThoai`, `CK_DonHang_SdtNguoiNhan`
- **Không lưu mật khẩu thô (BR02):** `CK_NguoiDung_MatKhauBam` – phải có dạng `pbkdf2_sha256$...`
- **Giá > 0, tồn kho ≥ 0 (BR07, BR08):** `CK_SanPham_GiaBan`, `CK_SanPham_SoLuongTon`
- **Danh mục / thương hiệu / CPU / GPU còn sản phẩm không xóa được (BR11):** 4 khóa ngoại `FK_SanPham_*` (NO ACTION)
- **Sản phẩm đã bán không xóa cứng (BR09):** `FK_ChiTietDonHang_SanPham` (NO ACTION)
- **Card rời phải có VRAM 1–48 GB, card tích hợp không có VRAM:** `CK_CardDoHoa_Vram`
- **Số luồng ≥ số nhân:** `CK_BoXuLy_SoLuongLuong`
- **Tối đa 5 máy / sản phẩm trong giỏ và đơn (D21):** `CK_GioHang_SoLuong`, `CK_ChiTietDonHang_SoLuong`
- **Chỉ chuyển trạng thái đơn theo đúng luồng (BR26, BR27):** `CK_LichSuTrangThaiDon_ChuyenTrangThai`
- **Đơn chuyển khoản phải `DA_THANH_TOAN` trước khi `DA_XAC_NHAN` (D22):** `CK_DonHang_ChuyenKhoanTraTruocXacNhan`
- **Mốc thời gian khớp trạng thái đơn:** `CK_DonHang_NgayXacNhan`, `_NgayBanGiao`, `_NgayGiaoThanhCong`, `_NgayHuy`, `_ThuTuThoiGian`
- **Mỗi khách 1 đánh giá / sản phẩm, 1–5 sao, 10–1000 ký tự (BR31, BR32):** `UQ_DanhGia_NguoiDung_SanPham`, `CK_DanhGia_SoSao`, `CK_DanhGia_NoiDung`
- **Chống path traversal đường dẫn ảnh (NF05):** `CK_HinhAnhSanPham_DuongDan`, `CK_QuangCao_DuongDan`

### 1.5. Chỉ mục (index)

| Index | Bảng (cột) | Loại |
|---|---|---|
| `UX_HinhAnhSanPham_AnhDaiDien` | `HinhAnhSanPham(MaSanPham)` | UNIQUE filtered `WHERE LaAnhDaiDien = 1` |
| `IX_HinhAnhSanPham_SanPham` | `HinhAnhSanPham(MaSanPham, ThuTu)` | thường |
| `IX_SanPham_TrangThai_GiaBan` | `SanPham(TrangThai, GiaBan)` | thường |
| `IX_SanPham_TrangThai_NgayTao` | `SanPham(TrangThai, NgayTao DESC)` | thường |
| `IX_SanPham_DanhMuc` | `SanPham(MaDanhMuc)` | thường |
| `IX_SanPham_ThuongHieu` | `SanPham(MaThuongHieu)` | thường |
| `IX_SanPham_BoXuLy` | `SanPham(MaBoXuLy)` | thường |
| `IX_SanPham_CardDoHoa` | `SanPham(MaCardDoHoa)` | thường |
| `IX_SanPham_Ram` | `SanPham(DungLuongRamGB)` | thường |
| `IX_SanPham_OCung` | `SanPham(DungLuongOCungGB)` | thường |
| `IX_SanPham_ManHinh` | `SanPham(KichThuocManHinhInch)` | thường |
| `IX_SanPham_SoLuongTon` | `SanPham(SoLuongTon)` | thường |
| `IX_BoXuLy_Dong` | `BoXuLy(DongChip)` | thường |
| `IX_KhuyenMai_DangHoatDong_ThoiGian` | `KhuyenMai(DangHoatDong, NgayBatDau, NgayKetThuc)` | thường |
| `IX_SanPhamKhuyenMai_KhuyenMai` | `SanPhamKhuyenMai(MaKhuyenMai)` | thường |
| `IX_DonHang_NguoiDung_NgayTao` | `DonHang(MaNguoiDung, NgayTao DESC)` | thường |
| `IX_DonHang_TrangThai_NgayTao` | `DonHang(TrangThai, NgayTao DESC)` | thường |
| `IX_DonHang_DaGiao` | `DonHang(NgayGiaoThanhCong)` | filtered `WHERE TrangThai = 'DA_GIAO'` |
| `IX_ChiTietDonHang_SanPham` | `ChiTietDonHang(MaSanPham)` | thường |
| `IX_ChiTietDonHang_KhuyenMai` | `ChiTietDonHang(MaKhuyenMai)` | filtered `WHERE MaKhuyenMai IS NOT NULL` |
| `IX_LichSuTrangThaiDon_DonHang` | `LichSuTrangThaiDon(MaDonHang, ThoiDiem)` | thường |
| `IX_DanhGia_SanPham` | `DanhGia(MaSanPham, BiAn)` | thường |
| `IX_GioHang_SanPham` | `GioHang(MaSanPham)` | thường |
| `IX_NguoiDung_VaiTro` | `NguoiDung(VaiTro, BiKhoa)` | thường |

Tìm theo tên bằng `LIKE N'%từ khóa%'` không dùng được index; với khoảng 50 sản phẩm điều này không ảnh hưởng hiệu năng.

## 2. ERD

### 2.1. ERD mức khái niệm (ký hiệu Chen)

![ERD khái niệm](png/erd_01_khai_niem.png)

Hình chữ nhật = thực thể (viền đôi = thực thể yếu, chỉ tồn tại khi có thực thể chủ); hình thoi = mối kết hợp; elip = thuộc tính của mối kết hợp. Bản số `(min,max)` đặt cạnh thực thể: số lần một thể hiện tham gia mối kết hợp.

| Mối kết hợp | Thực thể A (bản số) | Thực thể B (bản số) | Loại | Cài đặt trong mô hình quan hệ |
|---|---|---|---|---|
| Thuộc | SẢN PHẨM (1,1) | DANH MỤC (0,n) | 1 – N | `SanPham.MaDanhMuc` FK |
| Do hãng sản xuất | SẢN PHẨM (1,1) | THƯƠNG HIỆU (0,n) | 1 – N | `SanPham.MaThuongHieu` FK |
| Dùng CPU | SẢN PHẨM (1,1) | BỘ XỬ LÝ (0,n) | 1 – N | `SanPham.MaBoXuLy` FK |
| Dùng GPU | SẢN PHẨM (1,1) | CARD ĐỒ HỌA (0,n) | 1 – N | `SanPham.MaCardDoHoa` FK |
| Có ảnh | HÌNH ẢNH SP (1,1) | SẢN PHẨM (0,n) | 1 – N, thực thể yếu | `HinhAnhSanPham.MaSanPham` FK, CASCADE |
| Được áp dụng | SẢN PHẨM (0,n) | KHUYẾN MÃI (0,n) | N – N | Bảng `SanPhamKhuyenMai` |
| Thêm vào giỏ | NGƯỜI DÙNG (0,n) | SẢN PHẨM (0,n) | N – N có thuộc tính | Bảng `GioHang`, UNIQUE (MaNguoiDung, MaSanPham) |
| Đánh giá | NGƯỜI DÙNG (0,n) | SẢN PHẨM (0,n) | N – N có thuộc tính | Bảng `DanhGia`, UNIQUE (MaNguoiDung, MaSanPham) |
| Đặt | ĐƠN HÀNG (1,1) | NGƯỜI DÙNG (0,n) | 1 – N | `DonHang.MaNguoiDung` FK |
| Gồm (chi tiết đơn) | ĐƠN HÀNG (1,n), SẢN PHẨM (0,n) | KHUYẾN MÃI (0,n) – tùy chọn | 3 ngôi có thuộc tính | Bảng `ChiTietDonHang`, `MaKhuyenMai` NULL được |
| Có lịch sử | LỊCH SỬ TRẠNG THÁI (1,1) | ĐƠN HÀNG (1,n) | 1 – N, thực thể yếu | `LichSuTrangThaiDon.MaDonHang` FK |
| Thực hiện | LỊCH SỬ TRẠNG THÁI (1,1) | NGƯỜI DÙNG (0,n) | 1 – N | `LichSuTrangThaiDon.NguoiThucHien` FK |

`QUẢNG CÁO` là thực thể độc lập, không có mối kết hợp. Bản số `(1,n)` của ĐƠN HÀNG trong "Gồm" và "Có lịch sử" là quy tắc nghiệp vụ (đơn luôn có ≥ 1 dòng và ≥ 1 dòng lịch sử, ghi trong cùng transaction); DB không tự chặn được điều này.

### 2.2. ERD mức logic (crow's foot, đầy đủ thuộc tính)

![ERD logic](png/erd_02_logic.png)

Ký hiệu đầu đường nối: `||` = đúng 1, `o|` = 0 hoặc 1 (FK cho phép NULL: `ChiTietDonHang.MaKhuyenMai`), `o<` = 0..nhiều, `|<` = 1..nhiều. **PK** đậm, *FK* nghiêng, **UQ** = thuộc ràng buộc UNIQUE. Màu: xanh lá = bảng danh mục bên 1 (dùng cho combo box), vàng = bảng kết hợp / trung gian, xanh dương = thực thể chính.

## 3. Mô hình quan hệ

### 3.1. Lược đồ quan hệ

Ký hiệu: <u>gạch chân</u> = khóa chính, `#` = khóa ngoại (→ bảng được tham chiếu).

- **NguoiDung** (<u>MaNguoiDung</u>, Email, MatKhauBam, HoTen, SoDienThoai, DiaChi, VaiTro, BiKhoa, NgayTao, NgayCapNhat)
- **DanhMuc** (<u>MaDanhMuc</u>, TenDanhMuc, DuongDanUrl, MoTa, DangHoatDong, NgayTao)
- **ThuongHieu** (<u>MaThuongHieu</u>, TenThuongHieu, DuongDanUrl, QuocGia, DuongDanLogo, DangHoatDong, NgayTao)
- **BoXuLy** (<u>MaBoXuLy</u>, HangSanXuat, DongChip, TenModel, SoNhan, SoLuongLuong, XungNhipToiDaGHz)
- **CardDoHoa** (<u>MaCardDoHoa</u>, HangSanXuat, TenModel, LoaiCard, BoNhoVramGB)
- **SanPham** (<u>MaSanPham</u>, MaSku, TenSanPham, DuongDanUrl, #MaDanhMuc, #MaThuongHieu, DongMay, MoTaNgan, MoTa, GiaBan, SoLuongTon, BaoHanhThang, #MaBoXuLy, #MaCardDoHoa, DungLuongRamGB, LoaiRam, BusRamMHz, SoKheRam, RamToiDaGB, DungLuongOCungGB, LoaiOCung, KichThuocManHinhInch, DoPhanGiaiNgang, DoPhanGiaiDoc, TamNen, TanSoQuetHz, CamUng, DungLuongPinWh, TrongLuongKg, KichThuoc, ChatLieu, MauSac, CongKetNoi, KetNoiKhongDay, Webcam, DenBanPhim, HeDieuHanh, NamRaMat, TrangThai, NgayTao, NgayCapNhat)
- **HinhAnhSanPham** (<u>MaHinhAnh</u>, #MaSanPham, DuongDanAnh, LaAnhDaiDien, ThuTu, NgayTao)
- **KhuyenMai** (<u>MaKhuyenMai</u>, TenKhuyenMai, MoTa, LoaiGiam, GiaTriGiam, NgayBatDau, NgayKetThuc, DangHoatDong, NgayTao)
- **SanPhamKhuyenMai** (<u>#MaSanPham</u>, <u>#MaKhuyenMai</u>)
- **GioHang** (<u>MaGioHang</u>, #MaNguoiDung, #MaSanPham, SoLuong, NgayThem, NgayCapNhat)
- **DonHang** (<u>MaDonHang</u>, MaDonHienThi, #MaNguoiDung, TenNguoiNhan, SdtNguoiNhan, DiaChiGiaoHang, GhiChu, PhuongThucThanhToan, TrangThaiThanhToan, TrangThai, TongTien, NgayTao, NgayThanhToan, NgayXacNhan, NgayBanGiao, NgayGiaoThanhCong, NgayHuy, NgayCapNhat)
- **ChiTietDonHang** (<u>#MaDonHang</u>, <u>#MaSanPham</u>, TenSanPham, MaSku, DonGiaGoc, DonGiaBan, #MaKhuyenMai, SoLuong, TienGiam, ThanhTien)
- **LichSuTrangThaiDon** (<u>MaLichSu</u>, #MaDonHang, TuTrangThai, SangTrangThai, #NguoiThucHien, GhiChu, ThoiDiem)
- **DanhGia** (<u>MaDanhGia</u>, #MaNguoiDung, #MaSanPham, SoSao, NoiDung, BiAn, NgayTao, NgayCapNhat)
- **QuangCao** (<u>MaQuangCao</u>, TieuDe, DuongDanAnh, DuongDanLienKet, ThuTu, DangHoatDong, NgayTao)

### 3.2. Sơ đồ quan hệ (lược đồ vật lý SQL Server)

![Sơ đồ mô hình quan hệ](png/mqh_01_so_do_quan_he.png)

Mỗi mũi tên đi từ cột khóa ngoại tới cột khóa chính được tham chiếu, ghi tên ràng buộc; nét đậm = `ON DELETE CASCADE`.

### 3.3. Khóa ngoại

| # | Ràng buộc | Bảng con (cột) | Bảng cha (cột) | Khi xóa dòng cha | Ý nghĩa nghiệp vụ |
|---|---|---|---|---|---|
| 1 | `FK_SanPham_DanhMuc` | `SanPham(MaDanhMuc)` | `DanhMuc(MaDanhMuc)` | NO ACTION | Còn SP thì không xóa được danh mục (BR11) |
| 2 | `FK_SanPham_ThuongHieu` | `SanPham(MaThuongHieu)` | `ThuongHieu(MaThuongHieu)` | NO ACTION | Còn SP thì không xóa được thương hiệu (BR11) |
| 3 | `FK_SanPham_BoXuLy` | `SanPham(MaBoXuLy)` | `BoXuLy(MaBoXuLy)` | NO ACTION | Còn SP thì không xóa được CPU |
| 4 | `FK_SanPham_CardDoHoa` | `SanPham(MaCardDoHoa)` | `CardDoHoa(MaCardDoHoa)` | NO ACTION | Còn SP thì không xóa được card đồ họa |
| 5 | `FK_HinhAnhSanPham_SanPham` | `HinhAnhSanPham(MaSanPham)` | `SanPham(MaSanPham)` | CASCADE | Xóa SP thì xóa luôn ảnh |
| 6 | `FK_SanPhamKhuyenMai_SanPham` | `SanPhamKhuyenMai(MaSanPham)` | `SanPham(MaSanPham)` | CASCADE | Xóa SP thì bỏ gắn KM |
| 7 | `FK_SanPhamKhuyenMai_KhuyenMai` | `SanPhamKhuyenMai(MaKhuyenMai)` | `KhuyenMai(MaKhuyenMai)` | CASCADE | Xóa KM thì bỏ gắn SP |
| 8 | `FK_GioHang_NguoiDung` | `GioHang(MaNguoiDung)` | `NguoiDung(MaNguoiDung)` | CASCADE | Tài khoản không xóa (chỉ khóa – DB07); có để an toàn |
| 9 | `FK_GioHang_SanPham` | `GioHang(MaSanPham)` | `SanPham(MaSanPham)` | CASCADE | Xóa SP thì xóa khỏi các giỏ |
| 10 | `FK_DonHang_NguoiDung` | `DonHang(MaNguoiDung)` | `NguoiDung(MaNguoiDung)` | NO ACTION | Không xóa tài khoản đã có đơn |
| 11 | `FK_ChiTietDonHang_DonHang` | `ChiTietDonHang(MaDonHang)` | `DonHang(MaDonHang)` | NO ACTION | Không xóa đơn có chi tiết |
| 12 | `FK_ChiTietDonHang_SanPham` | `ChiTietDonHang(MaSanPham)` | `SanPham(MaSanPham)` | NO ACTION | SP đã bán không xóa cứng, chỉ ngừng bán (BR09) |
| 13 | `FK_ChiTietDonHang_KhuyenMai` | `ChiTietDonHang(MaKhuyenMai)` | `KhuyenMai(MaKhuyenMai)` | NO ACTION | KM đã áp vào đơn không xóa, chỉ ngừng hoạt động |
| 14 | `FK_LichSuTrangThaiDon_DonHang` | `LichSuTrangThaiDon(MaDonHang)` | `DonHang(MaDonHang)` | NO ACTION | Giữ lịch sử đơn |
| 15 | `FK_LichSuTrangThaiDon_NguoiDung` | `LichSuTrangThaiDon(NguoiThucHien)` | `NguoiDung(MaNguoiDung)` | NO ACTION | Giữ người thực hiện |
| 16 | `FK_DanhGia_NguoiDung` | `DanhGia(MaNguoiDung)` | `NguoiDung(MaNguoiDung)` | NO ACTION | Giữ đánh giá |
| 17 | `FK_DanhGia_SanPham` | `DanhGia(MaSanPham)` | `SanPham(MaSanPham)` | NO ACTION | Giữ đánh giá |

## 4. Từ điển dữ liệu

Sinh tự động từ `01_create_database.sql`. Cột "Mô tả" lấy từ `DATABASE_DESIGN.md`. NULL: "Có" = cho phép NULL.
Kiểu tiền `DECIMAL(18,0)` (VND). Thời gian `DATETIME2(0)` theo giờ máy chủ.

### 4.1. `NguoiDung`

| # | Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|---|
| 1 | `MaNguoiDung` | INT IDENTITY(1,1) | Không | PK |  | Mã tài khoản |
| 2 | `Email` | VARCHAR(100) | Không | UQ |  | Email đăng nhập, duy nhất (không phân biệt hoa thường) |
| 3 | `MatKhauBam` | VARCHAR(200) | Không |  |  | Mật khẩu đã băm PBKDF2: `pbkdf2_sha256$vòng$salt$hash` |
| 4 | `HoTen` | NVARCHAR(100) | Không |  |  | Họ tên |
| 5 | `SoDienThoai` | VARCHAR(10) | Không |  |  | Số điện thoại 10 số, bắt đầu bằng 0 |
| 6 | `DiaChi` | NVARCHAR(255) | Có |  |  | Địa chỉ giao hàng mặc định |
| 7 | `VaiTro` | VARCHAR(20) | Không |  | 'KHACH_HANG' | KHACH_HANG / QUAN_TRI |
| 8 | `BiKhoa` | BIT | Không |  | 0 | 1 = bị khóa |
| 9 | `NgayTao` | DATETIME2(0) | Không |  | SYSDATETIME() | Thời điểm tạo |
| 10 | `NgayCapNhat` | DATETIME2(0) | Có |  |  | Thời điểm cập nhật gần nhất |

UNIQUE: `UQ_NguoiDung_Email` (Email)

CHECK:

- `CK_NguoiDung_VaiTro`: `VaiTro IN ('KHACH_HANG', 'QUAN_TRI')`
- `CK_NguoiDung_Email`: `Email LIKE '%_@_%._%' AND Email NOT LIKE '% %'`
- `CK_NguoiDung_SoDienThoai`: `SoDienThoai LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'`
- `CK_NguoiDung_MatKhauBam`: `MatKhauBam LIKE 'pbkdf2_sha256$%$%$%'`
- `CK_NguoiDung_HoTen`: `LEN(HoTen) >= 2`

### 4.2. `DanhMuc`

| # | Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|---|
| 1 | `MaDanhMuc` | INT IDENTITY(1,1) | Không | PK |  | Mã danh mục |
| 2 | `TenDanhMuc` | NVARCHAR(100) | Không | UQ |  | Tên danh mục, duy nhất |
| 3 | `DuongDanUrl` | VARCHAR(120) | Không | UQ |  | Chuỗi URL (a-z, 0-9, -) |
| 4 | `MoTa` | NVARCHAR(500) | Có |  |  | Mô tả |
| 5 | `DangHoatDong` | BIT | Không |  | 1 | 1 = đang hoạt động / hiển thị |
| 6 | `NgayTao` | DATETIME2(0) | Không |  | SYSDATETIME() | Thời điểm tạo |

UNIQUE: `UQ_DanhMuc_Ten` (TenDanhMuc); `UQ_DanhMuc_DuongDanUrl` (DuongDanUrl)

CHECK:

- `CK_DanhMuc_DuongDanUrl`: `DuongDanUrl NOT LIKE '%[^a-z0-9-]%'`

### 4.3. `ThuongHieu`

| # | Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|---|
| 1 | `MaThuongHieu` | INT IDENTITY(1,1) | Không | PK |  | Mã thương hiệu |
| 2 | `TenThuongHieu` | NVARCHAR(100) | Không | UQ |  | Tên thương hiệu, duy nhất |
| 3 | `DuongDanUrl` | VARCHAR(120) | Không | UQ |  | Chuỗi URL (a-z, 0-9, -) |
| 4 | `QuocGia` | NVARCHAR(50) | Có |  |  | Quốc gia |
| 5 | `DuongDanLogo` | NVARCHAR(500) | Có |  |  | Đường dẫn tương đối logo |
| 6 | `DangHoatDong` | BIT | Không |  | 1 | 1 = đang hoạt động / hiển thị |
| 7 | `NgayTao` | DATETIME2(0) | Không |  | SYSDATETIME() | Thời điểm tạo |

UNIQUE: `UQ_ThuongHieu_Ten` (TenThuongHieu); `UQ_ThuongHieu_DuongDanUrl` (DuongDanUrl)

CHECK:

- `CK_ThuongHieu_DuongDanUrl`: `DuongDanUrl NOT LIKE '%[^a-z0-9-]%'`

### 4.4. `BoXuLy`

| # | Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|---|
| 1 | `MaBoXuLy` | INT IDENTITY(1,1) | Không | PK |  | Mã CPU |
| 2 | `HangSanXuat` | VARCHAR(20) | Không |  |  | Hãng sản xuất |
| 3 | `DongChip` | VARCHAR(30) | Không |  |  | Dòng chip (dùng để lọc): Core i5, Ryzen 7... |
| 4 | `TenModel` | VARCHAR(50) | Không | UQ |  | Tên model, duy nhất |
| 5 | `SoNhan` | TINYINT | Không |  |  | Số nhân |
| 6 | `SoLuongLuong` | TINYINT | Không |  |  | Số luồng |
| 7 | `XungNhipToiDaGHz` | DECIMAL(3,2) | Có |  |  | Xung nhịp tối đa (GHz) |

UNIQUE: `UQ_BoXuLy_TenModel` (TenModel)

CHECK:

- `CK_BoXuLy_HangSanXuat`: `HangSanXuat IN ('Intel', 'AMD', 'Apple')`
- `CK_BoXuLy_SoNhan`: `SoNhan BETWEEN 1 AND 64`
- `CK_BoXuLy_SoLuongLuong`: `SoLuongLuong >= SoNhan AND SoLuongLuong <= 128`
- `CK_BoXuLy_XungNhip`: `XungNhipToiDaGHz IS NULL OR XungNhipToiDaGHz BETWEEN 1 AND 7`

### 4.5. `CardDoHoa`

| # | Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|---|
| 1 | `MaCardDoHoa` | INT IDENTITY(1,1) | Không | PK |  | Mã GPU |
| 2 | `HangSanXuat` | VARCHAR(20) | Không |  |  | Hãng sản xuất |
| 3 | `TenModel` | VARCHAR(60) | Không | UQ |  | Tên model, duy nhất |
| 4 | `LoaiCard` | VARCHAR(10) | Không |  |  | TICH_HOP / ROI |
| 5 | `BoNhoVramGB` | TINYINT | Có |  |  | VRAM (GB), NULL nếu tích hợp |

UNIQUE: `UQ_CardDoHoa_TenModel` (TenModel)

CHECK:

- `CK_CardDoHoa_HangSanXuat`: `HangSanXuat IN ('Intel', 'AMD', 'NVIDIA', 'Apple')`
- `CK_CardDoHoa_Loai`: `LoaiCard IN ('TICH_HOP', 'ROI')`
- `CK_CardDoHoa_Vram`: `(LoaiCard = 'ROI' AND BoNhoVramGB BETWEEN 1 AND 48) OR (LoaiCard = 'TICH_HOP' AND BoNhoVramGB IS NULL)`

### 4.6. `SanPham`

| # | Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|---|
| 1 | `MaSanPham` | INT IDENTITY(1,1) | Không | PK |  | Mã sản phẩm |
| 2 | `MaSku` | VARCHAR(50) | Không | UQ |  | Mã SKU, duy nhất |
| 3 | `TenSanPham` | NVARCHAR(200) | Không | UQ |  | Tên sản phẩm, duy nhất |
| 4 | `DuongDanUrl` | VARCHAR(220) | Không | UQ |  | Chuỗi URL (a-z, 0-9, -) |
| 5 | `MaDanhMuc` | INT | Không | FK→DanhMuc |  | Mã danh mục |
| 6 | `MaThuongHieu` | INT | Không | FK→ThuongHieu |  | Mã thương hiệu |
| 7 | `DongMay` | NVARCHAR(100) | Có |  |  | Dòng máy: Inspiron, ThinkPad, ROG... |
| 8 | `MoTaNgan` | NVARCHAR(500) | Có |  |  | Mô tả ngắn |
| 9 | `MoTa` | NVARCHAR(MAX) | Có |  |  | Mô tả |
| 10 | `GiaBan` | DECIMAL(18,0) | Không |  |  | Giá bán gốc (VND) |
| 11 | `SoLuongTon` | INT | Không |  | 0 | Tồn kho |
| 12 | `BaoHanhThang` | TINYINT | Không |  | 12 | Bảo hành (tháng) |
| 13 | `MaBoXuLy` | INT | Không | FK→BoXuLy |  | Mã CPU |
| 14 | `MaCardDoHoa` | INT | Không | FK→CardDoHoa |  | Mã GPU |
| 15 | `DungLuongRamGB` | SMALLINT | Không |  |  | Dung lượng RAM (GB) |
| 16 | `LoaiRam` | VARCHAR(20) | Không |  |  | Loại RAM |
| 17 | `BusRamMHz` | SMALLINT | Có |  |  | Bus RAM (MHz) |
| 18 | `SoKheRam` | TINYINT | Có |  |  | Số khe RAM (0 = hàn chết) |
| 19 | `RamToiDaGB` | SMALLINT | Có |  |  | RAM tối đa hỗ trợ |
| 20 | `DungLuongOCungGB` | SMALLINT | Không |  |  | Dung lượng ổ cứng (GB) |
| 21 | `LoaiOCung` | VARCHAR(10) | Không |  |  | SSD_NVME / SSD_SATA / HDD |
| 22 | `KichThuocManHinhInch` | DECIMAL(3,1) | Không |  |  | Kích thước màn hình (inch) |
| 23 | `DoPhanGiaiNgang` | SMALLINT | Không |  |  | Độ phân giải ngang |
| 24 | `DoPhanGiaiDoc` | SMALLINT | Không |  |  | Độ phân giải dọc |
| 25 | `TamNen` | VARCHAR(10) | Không |  |  | Tấm nền |
| 26 | `TanSoQuetHz` | SMALLINT | Không |  | 60 | Tần số quét (Hz) |
| 27 | `CamUng` | BIT | Không |  | 0 | Màn hình cảm ứng |
| 28 | `DungLuongPinWh` | DECIMAL(4,1) | Không |  |  | Dung lượng pin (Wh) |
| 29 | `TrongLuongKg` | DECIMAL(3,2) | Không |  |  | Trọng lượng (kg) |
| 30 | `KichThuoc` | NVARCHAR(50) | Có |  |  | Kích thước máy |
| 31 | `ChatLieu` | NVARCHAR(50) | Có |  |  | Chất liệu vỏ |
| 32 | `MauSac` | NVARCHAR(50) | Có |  |  | Màu sắc |
| 33 | `CongKetNoi` | NVARCHAR(500) | Có |  |  | Cổng kết nối |
| 34 | `KetNoiKhongDay` | NVARCHAR(100) | Có |  |  | Wi-Fi, Bluetooth |
| 35 | `Webcam` | NVARCHAR(50) | Có |  |  | Webcam |
| 36 | `DenBanPhim` | BIT | Không |  | 0 | Đèn nền bàn phím |
| 37 | `HeDieuHanh` | NVARCHAR(50) | Không |  |  | Hệ điều hành |
| 38 | `NamRaMat` | SMALLINT | Có |  |  | Năm ra mắt |
| 39 | `TrangThai` | VARCHAR(20) | Không |  | 'DANG_BAN' | DANG_BAN / NGUNG_BAN (ngừng kinh doanh) |
| 40 | `NgayTao` | DATETIME2(0) | Không |  | SYSDATETIME() | Thời điểm tạo |
| 41 | `NgayCapNhat` | DATETIME2(0) | Có |  |  | Thời điểm cập nhật gần nhất |

UNIQUE: `UQ_SanPham_MaSku` (MaSku); `UQ_SanPham_Ten` (TenSanPham); `UQ_SanPham_DuongDanUrl` (DuongDanUrl)

CHECK:

- `CK_SanPham_DuongDanUrl`: `DuongDanUrl NOT LIKE '%[^a-z0-9-]%'`
- `CK_SanPham_GiaBan`: `GiaBan > 0`
- `CK_SanPham_SoLuongTon`: `SoLuongTon >= 0`
- `CK_SanPham_BaoHanh`: `BaoHanhThang BETWEEN 0 AND 60`
- `CK_SanPham_Ram`: `DungLuongRamGB BETWEEN 2 AND 256`
- `CK_SanPham_LoaiRam`: `LoaiRam IN ('DDR4', 'DDR5', 'LPDDR4X', 'LPDDR5', 'LPDDR5X', 'HOP_NHAT')`
- `CK_SanPham_BusRam`: `BusRamMHz IS NULL OR BusRamMHz BETWEEN 1000 AND 12000`
- `CK_SanPham_SoKheRam`: `SoKheRam IS NULL OR SoKheRam BETWEEN 0 AND 4`
- `CK_SanPham_RamToiDa`: `RamToiDaGB IS NULL OR RamToiDaGB >= DungLuongRamGB`
- `CK_SanPham_OCung`: `DungLuongOCungGB BETWEEN 64 AND 16384`
- `CK_SanPham_LoaiOCung`: `LoaiOCung IN ('SSD_NVME', 'SSD_SATA', 'HDD')`
- `CK_SanPham_ManHinh`: `KichThuocManHinhInch BETWEEN 10.0 AND 20.0`
- `CK_SanPham_DoPhanGiai`: `DoPhanGiaiNgang BETWEEN 800 AND 7680 AND DoPhanGiaiDoc BETWEEN 600 AND 4320`
- `CK_SanPham_TamNen`: `TamNen IN ('IPS', 'OLED', 'TN', 'VA', 'MINI_LED')`
- `CK_SanPham_TanSoQuet`: `TanSoQuetHz BETWEEN 30 AND 500`
- `CK_SanPham_Pin`: `DungLuongPinWh BETWEEN 10 AND 120`
- `CK_SanPham_TrongLuong`: `TrongLuongKg BETWEEN 0.50 AND 6.00`
- `CK_SanPham_NamRaMat`: `NamRaMat IS NULL OR NamRaMat BETWEEN 2010 AND 2100`
- `CK_SanPham_TrangThai`: `TrangThai IN ('DANG_BAN', 'NGUNG_BAN')`

### 4.7. `HinhAnhSanPham`

| # | Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|---|
| 1 | `MaHinhAnh` | INT IDENTITY(1,1) | Không | PK |  | Mã ảnh |
| 2 | `MaSanPham` | INT | Không | FK→SanPham |  | Mã sản phẩm |
| 3 | `DuongDanAnh` | NVARCHAR(500) | Không | UQ |  | Đường dẫn tương đối của file ảnh |
| 4 | `LaAnhDaiDien` | BIT | Không |  | 0 | 1 = ảnh đại diện |
| 5 | `ThuTu` | INT | Không |  | 0 | Thứ tự hiển thị |
| 6 | `NgayTao` | DATETIME2(0) | Không |  | SYSDATETIME() | Thời điểm tạo |

UNIQUE: `UQ_HinhAnhSanPham_DuongDan` (DuongDanAnh)

CHECK:

- `CK_HinhAnhSanPham_DuongDan`: `DuongDanAnh NOT LIKE '%..%' AND DuongDanAnh NOT LIKE '/%' AND DuongDanAnh NOT LIKE '%:%'`
- `CK_HinhAnhSanPham_ThuTu`: `ThuTu >= 0`

### 4.8. `KhuyenMai`

| # | Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|---|
| 1 | `MaKhuyenMai` | INT IDENTITY(1,1) | Không | PK |  | Mã khuyến mãi |
| 2 | `TenKhuyenMai` | NVARCHAR(150) | Không | UQ |  | Tên chương trình khuyến mãi, duy nhất |
| 3 | `MoTa` | NVARCHAR(500) | Có |  |  | Mô tả |
| 4 | `LoaiGiam` | VARCHAR(10) | Không |  |  | PHAN_TRAM / SO_TIEN |
| 5 | `GiaTriGiam` | DECIMAL(18,0) | Không |  |  | % (1-90) hoặc số tiền VND |
| 6 | `NgayBatDau` | DATETIME2(0) | Không |  |  | Bắt đầu |
| 7 | `NgayKetThuc` | DATETIME2(0) | Không |  |  | Kết thúc |
| 8 | `DangHoatDong` | BIT | Không |  | 1 | 1 = đang hoạt động / hiển thị |
| 9 | `NgayTao` | DATETIME2(0) | Không |  | SYSDATETIME() | Thời điểm tạo |

UNIQUE: `UQ_KhuyenMai_Ten` (TenKhuyenMai)

CHECK:

- `CK_KhuyenMai_Loai`: `LoaiGiam IN ('PHAN_TRAM', 'SO_TIEN')`
- `CK_KhuyenMai_GiaTri`: `(LoaiGiam = 'PHAN_TRAM' AND GiaTriGiam BETWEEN 1 AND 90) OR (LoaiGiam = 'SO_TIEN' AND GiaTriGiam > 0)`
- `CK_KhuyenMai_ThoiGian`: `NgayKetThuc > NgayBatDau`

### 4.9. `SanPhamKhuyenMai`

| # | Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|---|
| 1 | `MaSanPham` | INT | Không | PK, FK→SanPham |  | Mã sản phẩm |
| 2 | `MaKhuyenMai` | INT | Không | PK, FK→KhuyenMai |  | Mã khuyến mãi |

### 4.10. `GioHang`

| # | Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|---|
| 1 | `MaGioHang` | INT IDENTITY(1,1) | Không | PK |  | Mã dòng giỏ hàng |
| 2 | `MaNguoiDung` | INT | Không | FK→NguoiDung, UQ |  | Mã tài khoản |
| 3 | `MaSanPham` | INT | Không | FK→SanPham, UQ |  | Mã sản phẩm |
| 4 | `SoLuong` | TINYINT | Không |  |  | Số lượng (1-5) |
| 5 | `NgayThem` | DATETIME2(0) | Không |  | SYSDATETIME() | Thời điểm thêm |
| 6 | `NgayCapNhat` | DATETIME2(0) | Có |  |  | Thời điểm cập nhật gần nhất |

UNIQUE: `UQ_GioHang_NguoiDung_SanPham` (MaNguoiDung, MaSanPham)

CHECK:

- `CK_GioHang_SoLuong`: `SoLuong BETWEEN 1 AND 5`

### 4.11. `DonHang`

| # | Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|---|
| 1 | `MaDonHang` | INT IDENTITY(1,1) | Không | PK |  | Mã đơn |
| 2 | `MaDonHienThi` | `AS (CAST('LS' + RIGHT('000000' + CAST(MaDonHang AS VARCHAR(10)), 6) AS VARCHAR(12))) PERSISTED` | Không | UQ |  | Mã đơn hiển thị LS000001 (cột tính toán) |
| 3 | `MaNguoiDung` | INT | Không | FK→NguoiDung |  | Mã tài khoản |
| 4 | `TenNguoiNhan` | NVARCHAR(100) | Không |  |  | Tên người nhận |
| 5 | `SdtNguoiNhan` | VARCHAR(10) | Không |  |  | SĐT người nhận |
| 6 | `DiaChiGiaoHang` | NVARCHAR(255) | Không |  |  | Địa chỉ giao hàng |
| 7 | `GhiChu` | NVARCHAR(500) | Có |  |  | Ghi chú |
| 8 | `PhuongThucThanhToan` | VARCHAR(20) | Không |  |  | THANH_TOAN_KHI_NHAN / CHUYEN_KHOAN |
| 9 | `TrangThaiThanhToan` | VARCHAR(20) | Không |  | 'CHUA_THANH_TOAN' | CHUA_THANH_TOAN / DA_THANH_TOAN / DA_HOAN_TIEN |
| 10 | `TrangThai` | VARCHAR(20) | Không |  | 'CHO_XAC_NHAN' | CHO_XAC_NHAN / DA_XAC_NHAN / DANG_GIAO / DA_GIAO / DA_HUY |
| 11 | `TongTien` | DECIMAL(18,0) | Không |  |  | Tổng thanh toán (VND) |
| 12 | `NgayTao` | DATETIME2(0) | Không |  | SYSDATETIME() | Thời điểm tạo |
| 13 | `NgayThanhToan` | DATETIME2(0) | Có |  |  | Thời điểm ghi nhận thanh toán |
| 14 | `NgayXacNhan` | DATETIME2(0) | Có |  |  | Thời điểm xác nhận |
| 15 | `NgayBanGiao` | DATETIME2(0) | Có |  |  | Thời điểm bàn giao vận chuyển |
| 16 | `NgayGiaoThanhCong` | DATETIME2(0) | Có |  |  | Thời điểm giao thành công (mốc doanh thu) |
| 17 | `NgayHuy` | DATETIME2(0) | Có |  |  | Thời điểm hủy |
| 18 | `NgayCapNhat` | DATETIME2(0) | Có |  |  | Thời điểm cập nhật gần nhất |

UNIQUE: `UQ_DonHang_MaDonHienThi` (MaDonHienThi)

CHECK:

- `CK_DonHang_SdtNguoiNhan`: `SdtNguoiNhan LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'`
- `CK_DonHang_PhuongThucThanhToan`: `PhuongThucThanhToan IN ('THANH_TOAN_KHI_NHAN', 'CHUYEN_KHOAN')`
- `CK_DonHang_TrangThaiThanhToan`: `TrangThaiThanhToan IN ('CHUA_THANH_TOAN', 'DA_THANH_TOAN', 'DA_HOAN_TIEN')`
- `CK_DonHang_TrangThai`: `TrangThai IN ('CHO_XAC_NHAN', 'DA_XAC_NHAN', 'DANG_GIAO', 'DA_GIAO', 'DA_HUY')`
- `CK_DonHang_TongTien`: `TongTien > 0`
- `CK_DonHang_NgayThanhToan`: `(TrangThaiThanhToan = 'CHUA_THANH_TOAN' AND NgayThanhToan IS NULL) OR (TrangThaiThanhToan IN ('DA_THANH_TOAN', 'DA_HOAN_TIEN') AND NgayThanhToan IS NOT NULL)`
- `CK_DonHang_NgayXacNhan`: `(TrangThai = 'CHO_XAC_NHAN' AND NgayXacNhan IS NULL) OR (TrangThai IN ('DA_XAC_NHAN', 'DANG_GIAO', 'DA_GIAO') AND NgayXacNhan IS NOT NULL) OR TrangThai = 'DA_HUY'`
- `CK_DonHang_NgayBanGiao`: `(TrangThai IN ('DANG_GIAO', 'DA_GIAO') AND NgayBanGiao IS NOT NULL) OR (TrangThai IN ('CHO_XAC_NHAN', 'DA_XAC_NHAN', 'DA_HUY') AND NgayBanGiao IS NULL)`
- `CK_DonHang_NgayGiaoThanhCong`: `(TrangThai = 'DA_GIAO' AND NgayGiaoThanhCong IS NOT NULL) OR (TrangThai <> 'DA_GIAO' AND NgayGiaoThanhCong IS NULL)`
- `CK_DonHang_NgayHuy`: `(TrangThai = 'DA_HUY' AND NgayHuy IS NOT NULL) OR (TrangThai <> 'DA_HUY' AND NgayHuy IS NULL)`
- `CK_DonHang_ThuTuThoiGian`: `(NgayThanhToan IS NULL OR NgayThanhToan >= NgayTao) AND (NgayXacNhan IS NULL OR NgayXacNhan >= NgayTao) AND (NgayBanGiao IS NULL OR NgayBanGiao >= NgayXacNhan) AND (NgayGiaoThanhCong IS NULL OR NgayGiaoThanhCong >= NgayBanGiao) AND (NgayHuy IS NULL OR NgayHuy >= NgayTao)`
- `CK_DonHang_DaGiaoDaThanhToan`: `TrangThai <> 'DA_GIAO' OR TrangThaiThanhToan = 'DA_THANH_TOAN'`
- `CK_DonHang_ChuyenKhoanTraTruocXacNhan`: `NOT (PhuongThucThanhToan = 'CHUYEN_KHOAN' AND TrangThai IN ('DA_XAC_NHAN', 'DANG_GIAO', 'DA_GIAO') AND TrangThaiThanhToan <> 'DA_THANH_TOAN')`
- `CK_DonHang_KhiNhanKhongTraSom`: `NOT (PhuongThucThanhToan = 'THANH_TOAN_KHI_NHAN' AND TrangThaiThanhToan = 'DA_THANH_TOAN' AND TrangThai <> 'DA_GIAO')`
- `CK_DonHang_KhiNhanKhongHoanTien`: `NOT (PhuongThucThanhToan = 'THANH_TOAN_KHI_NHAN' AND TrangThaiThanhToan = 'DA_HOAN_TIEN')`
- `CK_DonHang_HoanTienChiKhiHuy`: `TrangThaiThanhToan <> 'DA_HOAN_TIEN' OR TrangThai = 'DA_HUY'`
- `CK_DonHang_DaHuyKhongDaThanhToan`: `NOT (TrangThai = 'DA_HUY' AND TrangThaiThanhToan = 'DA_THANH_TOAN')`

### 4.12. `ChiTietDonHang`

| # | Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|---|
| 1 | `MaDonHang` | INT | Không | PK, FK→DonHang |  | Mã đơn |
| 2 | `MaSanPham` | INT | Không | PK, FK→SanPham |  | Mã sản phẩm |
| 3 | `TenSanPham` | NVARCHAR(200) | Không |  |  | Tên SP lúc đặt (snapshot) |
| 4 | `MaSku` | VARCHAR(50) | Không |  |  | SKU lúc đặt (snapshot) |
| 5 | `DonGiaGoc` | DECIMAL(18,0) | Không |  |  | Giá gốc lúc đặt |
| 6 | `DonGiaBan` | DECIMAL(18,0) | Không |  |  | Giá sau KM lúc đặt |
| 7 | `MaKhuyenMai` | INT | Có | FK→KhuyenMai |  | Mã khuyến mãi |
| 8 | `SoLuong` | TINYINT | Không |  |  | Số lượng (1-5) |
| 9 | `TienGiam` | `AS (DonGiaGoc - DonGiaBan) PERSISTED` | Không |  |  | Số tiền giảm / 1 SP (cột tính toán) |
| 10 | `ThanhTien` | `AS (DonGiaBan * SoLuong) PERSISTED` | Không |  |  | Thành tiền (cột tính toán) |

CHECK:

- `CK_ChiTietDonHang_SoLuong`: `SoLuong BETWEEN 1 AND 5`
- `CK_ChiTietDonHang_DonGia`: `DonGiaGoc > 0 AND DonGiaBan > 0 AND DonGiaBan <= DonGiaGoc`
- `CK_ChiTietDonHang_KhuyenMai`: `(MaKhuyenMai IS NULL AND DonGiaBan = DonGiaGoc) OR (MaKhuyenMai IS NOT NULL AND DonGiaBan < DonGiaGoc)`

### 4.13. `LichSuTrangThaiDon`

| # | Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|---|
| 1 | `MaLichSu` | INT IDENTITY(1,1) | Không | PK |  | Mã lịch sử |
| 2 | `MaDonHang` | INT | Không | FK→DonHang |  | Mã đơn |
| 3 | `TuTrangThai` | VARCHAR(20) | Có |  |  | Trạng thái cũ (NULL khi tạo đơn) |
| 4 | `SangTrangThai` | VARCHAR(20) | Không |  |  | Trạng thái mới |
| 5 | `NguoiThucHien` | INT | Không | FK→NguoiDung |  | Người thao tác |
| 6 | `GhiChu` | NVARCHAR(255) | Có |  |  | Ghi chú |
| 7 | `ThoiDiem` | DATETIME2(0) | Không |  | SYSDATETIME() | Thời điểm |

CHECK:

- `CK_LichSuTrangThaiDon_TuTrangThai`: `TuTrangThai IS NULL OR TuTrangThai IN ('CHO_XAC_NHAN', 'DA_XAC_NHAN', 'DANG_GIAO', 'DA_GIAO', 'DA_HUY')`
- `CK_LichSuTrangThaiDon_SangTrangThai`: `SangTrangThai IN ('CHO_XAC_NHAN', 'DA_XAC_NHAN', 'DANG_GIAO', 'DA_GIAO', 'DA_HUY')`
- `CK_LichSuTrangThaiDon_ChuyenTrangThai`: `(TuTrangThai IS NULL AND SangTrangThai = 'CHO_XAC_NHAN') OR (TuTrangThai = 'CHO_XAC_NHAN' AND SangTrangThai IN ('DA_XAC_NHAN', 'DA_HUY')) OR (TuTrangThai = 'DA_XAC_NHAN' AND SangTrangThai IN ('DANG_GIAO', 'DA_HUY')) OR (TuTrangThai = 'DANG_GIAO' AND SangTrangThai = 'DA_GIAO')`

### 4.14. `DanhGia`

| # | Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|---|
| 1 | `MaDanhGia` | INT IDENTITY(1,1) | Không | PK |  | Mã đánh giá |
| 2 | `MaNguoiDung` | INT | Không | FK→NguoiDung, UQ |  | Mã tài khoản |
| 3 | `MaSanPham` | INT | Không | FK→SanPham, UQ |  | Mã sản phẩm |
| 4 | `SoSao` | TINYINT | Không |  |  | Số sao 1-5 |
| 5 | `NoiDung` | NVARCHAR(1000) | Không |  |  | Nội dung 10-1000 ký tự |
| 6 | `BiAn` | BIT | Không |  | 0 | 1 = Admin đã ẩn |
| 7 | `NgayTao` | DATETIME2(0) | Không |  | SYSDATETIME() | Thời điểm tạo |
| 8 | `NgayCapNhat` | DATETIME2(0) | Có |  |  | Thời điểm cập nhật gần nhất |

UNIQUE: `UQ_DanhGia_NguoiDung_SanPham` (MaNguoiDung, MaSanPham)

CHECK:

- `CK_DanhGia_SoSao`: `SoSao BETWEEN 1 AND 5`
- `CK_DanhGia_NoiDung`: `LEN(NoiDung) BETWEEN 10 AND 1000`

### 4.15. `QuangCao`

| # | Cột | Kiểu | NULL | Khóa | Mặc định | Mô tả |
|---|---|---|---|---|---|---|
| 1 | `MaQuangCao` | INT IDENTITY(1,1) | Không | PK |  | Mã banner |
| 2 | `TieuDe` | NVARCHAR(150) | Không |  |  | Tiêu đề |
| 3 | `DuongDanAnh` | NVARCHAR(500) | Không |  |  | Đường dẫn tương đối của file ảnh |
| 4 | `DuongDanLienKet` | NVARCHAR(500) | Có |  |  | Đường dẫn nội bộ khi bấm banner |
| 5 | `ThuTu` | INT | Không |  | 0 | Thứ tự hiển thị |
| 6 | `DangHoatDong` | BIT | Không |  | 1 | 1 = đang hoạt động / hiển thị |
| 7 | `NgayTao` | DATETIME2(0) | Không |  | SYSDATETIME() | Thời điểm tạo |

CHECK:

- `CK_QuangCao_DuongDan`: `DuongDanAnh NOT LIKE '%..%' AND DuongDanAnh NOT LIKE '/%' AND DuongDanAnh NOT LIKE '%:%'`
- `CK_QuangCao_LienKet`: `DuongDanLienKet IS NULL OR (DuongDanLienKet LIKE '/%' AND DuongDanLienKet NOT LIKE '//%')`
- `CK_QuangCao_ThuTu`: `ThuTu >= 0`

## 5. Class Diagram

Package gốc: `vn.edu.stu.laptopshop`. Kiến trúc MVC: **Model** = `entities` + `dao` (+ `services` cho nghiệp vụ nhiều bảng), **View** = JSP trong `/WEB-INF/views/`, **Controller** = Servlet trong `controllers.user` / `controllers.admin`. Màu xanh = **đã cài đặt** (lấy từ mã nguồn bằng `javap`); màu xám / hồng = **thiết kế, chưa cài đặt**.

### 5.1. Lớp miền (Entity)

![Class lớp miền](png/class_01_lop_mien.png)

- Mỗi bảng ánh xạ 1 lớp Entity; thuộc tính ánh xạ 1–1 với cột (`INT` → `int`/`Integer` khi cho phép NULL, `DECIMAL` → `BigDecimal`, `DATETIME2` → `LocalDateTime`, `BIT` → `boolean`, chuỗi → `String`).
- Quan hệ giữa các lớp lấy từ 17 khóa ngoại, bản số ghi ở hai đầu. Hình thoi đặc (`SanPham` ◆— `HinhAnhSanPham`) là quan hệ hợp thành.
- 4 lớp đã cài đặt có thêm thuộc tính `soSanPham` (đếm bằng truy vấn để hiển thị và kiểm tra trước khi xóa) và hàm hiển thị (`getNgayTaoHienThi`, `getNhanComboBox`, `getLoaiCardHienThi`).
- Phương thức nghiệp vụ của lớp chưa cài đặt (`dangHieuLuc`, `tinhSoTienGiam`, `khachDuocHuy`…) là **đề xuất thiết kế**.

### 5.2. Tập giá trị hợp lệ (enumeration)

![Tập giá trị](png/class_02_tap_gia_tri.png)

Giá trị lấy đúng từ CHECK trong script (script sinh sơ đồ tự kiểm tra từng giá trị). Bảng đối chiếu với mã tiếng Anh còn dùng trong `PROJECT_REQUIREMENTS.md` (trước khi đổi tên – DB10):

| Tài liệu yêu cầu | CSDL | | Tài liệu yêu cầu | CSDL |
|---|---|---|---|---|
| `PENDING` | `CHO_XAC_NHAN` | | `CUSTOMER` | `KHACH_HANG` |
| `CONFIRMED` | `DA_XAC_NHAN` | | `ADMIN` | `QUAN_TRI` |
| `SHIPPING` | `DANG_GIAO` | | `UNPAID` | `CHUA_THANH_TOAN` |
| `DELIVERED` | `DA_GIAO` | | `PAID` | `DA_THANH_TOAN` |
| `CANCELLED` | `DA_HUY` | | `REFUNDED` | `DA_HOAN_TIEN` |
| `COD` | `THANH_TOAN_KHI_NHAN` | | `BANK_TRANSFER` | `CHUYEN_KHOAN` |
| `PERCENT` | `PHAN_TRAM` | | `AMOUNT` | `SO_TIEN` |

### 5.3. Kiến trúc MVC phần Admin đã cài đặt (Nhiệm vụ 2)

Tổng quan (chỉ tên lớp và quan hệ):

![Tổng quan kiến trúc](png/class_03b_kien_truc_tong_quan.png)

Chi tiết đầy đủ thuộc tính và phương thức (ảnh rộng, nên mở file PNG / drawio để phóng to):

![Kiến trúc chi tiết](png/class_03_kien_truc_admin.png)

- Mỗi Servlet quản lý 1 bảng giữ 1 đối tượng DAO (`private final`), xử lý GET (danh sách, form) và POST (thêm, sửa, xóa).
- DAO dùng `DBContext.getConnection()` và `PreparedStatement`; `SqlUtil` thoát ký tự đặc biệt của `LIKE`.
- `WebUtil` gom các hàm web dùng chung (đọc tham số, thông báo một lần, mã lỗi SQL 2627/2601/547); `SlugUtil` tạo đường dẫn không dấu.
- `KiemTraKetNoiServlet` là trang kiểm tra tạm cho môi trường phát triển (D29), phải xóa hoặc bảo vệ trước khi triển khai.

### 5.4. Sơ đồ gói toàn hệ thống

![Sơ đồ gói](png/class_04_so_do_goi.png)

Tên các lớp chưa cài đặt là **đề xuất**; phần User do thành viên còn lại phụ trách và quyết định tên lớp cụ thể.

## 6. Activity Diagram

Mỗi sơ đồ chia làn (swimlane): **tác nhân** | **Hệ thống** (Filter / Servlet) | **CSDL** (SQL Server). Ký hiệu: chấm đen = bắt đầu, chấm có viền = kết thúc, hình chữ nhật bo góc = hoạt động (xanh lá = thao tác CSDL, hồng = xử lý lỗi), hình thoi = quyết định / gộp nhánh, nhãn `[...]` = điều kiện rẽ nhánh. Mã trạng thái dùng đúng giá trị trong CSDL.

| # | Sơ đồ | Use Case / chức năng | Trạng thái |
|---|---|---|---|
| AD01 | [Đăng ký tài khoản](#ad01) | UC04 | Thiết kế |
| AD02 | [Đăng nhập](#ad02) | UC05 | Thiết kế |
| AD03 | [Đăng xuất](#ad03) | UC06 | Thiết kế |
| AD04 | [Kiểm tra đăng nhập và quyền ở mỗi request](#ad04) | S01, S02 | Thiết kế |
| AD05 | [Cập nhật hồ sơ](#ad05) | UC07 | Thiết kế |
| AD06 | [Đổi mật khẩu](#ad06) | UC08 | Thiết kế |
| AD07 | [Xem trang chủ](#ad07) | UC01 | Thiết kế |
| AD08 | [Tìm kiếm, lọc, sắp xếp, phân trang bằng AJAX](#ad08) | UC02 | Thiết kế |
| AD09 | [Xem chi tiết sản phẩm](#ad09) | UC03 | Thiết kế |
| AD10 | [Thêm sản phẩm vào giỏ hàng](#ad10) | UC09 | Thiết kế |
| AD11 | [Xem, sửa số lượng, xóa sản phẩm trong giỏ](#ad11) | UC09 | Thiết kế |
| AD12 | [Đặt hàng](#ad12) | UC10 | Thiết kế |
| AD13 | [Xem lịch sử và chi tiết đơn hàng](#ad13) | UC11 | Thiết kế |
| AD14 | [Khách hủy đơn hàng](#ad14) | UC12 | Thiết kế |
| AD15 | [Đánh giá sản phẩm](#ad15) | UC13 | Thiết kế |
| AD16 | [Xem Dashboard](#ad16) | UC14 | Thiết kế |
| AD17 | [Quản lý bảng danh mục: xem, tìm, thêm, sửa](#ad17) | UC15, UC16 + CPU, Card đồ họa | Đã cài đặt |
| AD18 | [Xóa bản ghi bảng danh mục](#ad18) | UC15, UC16 + CPU, Card đồ họa | Đã cài đặt |
| AD19 | [Admin thêm / sửa sản phẩm](#ad19) | UC17 | Thiết kế |
| AD20 | [Admin xóa / ngừng kinh doanh sản phẩm](#ad20) | UC17 | Thiết kế |
| AD21 | [Admin xem danh sách và chi tiết đơn hàng](#ad21) | UC18 | Thiết kế |
| AD22 | [Admin cập nhật trạng thái đơn hàng](#ad22) | UC19 | Thiết kế |
| AD23 | [Admin xác nhận đã nhận chuyển khoản](#ad23) | UC20 | Thiết kế |
| AD24 | [Quản lý thành viên: khóa / mở, đổi vai trò](#ad24) | UC21 | Thiết kế |
| AD25 | [Quản lý khuyến mãi và gắn sản phẩm](#ad25) | UC22 | Thiết kế |
| AD26 | [Admin ẩn / hiện đánh giá](#ad26) | UC23 | Thiết kế |
| AD27 | [Quản lý banner trang chủ](#ad27) | UC24 | Thiết kế |
| AD28 | [Xem thống kê](#ad28) | UC25 | Thiết kế |
| AD29 | [Tính giá hiện hành của sản phẩm](#ad29) | S03, dùng chung | Thiết kế |

### AD01

**Đăng ký tài khoản (UC04)**

![AD01](png/ad01_dang_ky.png)

Kiểm tra trùng email 2 lớp: SELECT trước, và bắt lỗi UNIQUE 2627 khi INSERT (trường hợp 2 người đăng ký cùng lúc).

### AD02

**Đăng nhập (UC05)**

![AD02](png/ad02_dang_nhap.png)

Sai email hay sai mật khẩu đều báo cùng một thông báo; tạo session mới để chống chiếm phiên.

### AD03

**Đăng xuất (UC06)**

![AD03](png/ad03_dang_xuat.png)

### AD04

**Kiểm tra đăng nhập và quyền ở mỗi request (S01, S02)**

![AD04](png/ad04_kiem_tra_quyen.png)

Hiện tại các trang Admin đã làm chưa có đăng nhập – chỉ dùng trong môi trường phát triển local (D29). AuthFilter / AdminFilter là thiết kế.

### AD05

**Cập nhật hồ sơ (UC07)**

![AD05](png/ad05_cap_nhat_ho_so.png)

### AD06

**Đổi mật khẩu (UC08)**

![AD06](png/ad06_doi_mat_khau.png)

### AD07

**Xem trang chủ (UC01)**

![AD07](png/ad07_trang_chu.png)

### AD08

**Tìm kiếm, lọc, sắp xếp, phân trang bằng AJAX (UC02)**

![AD08](png/ad08_tim_kiem_loc.png)

Cột sắp xếp lấy từ danh sách cho phép (không nối chuỗi từ tham số) để chống SQL Injection.

### AD09

**Xem chi tiết sản phẩm (UC03)**

![AD09](png/ad09_chi_tiet_san_pham.png)

### AD10

**Thêm sản phẩm vào giỏ hàng (UC09)**

![AD10](png/ad10_them_vao_gio.png)

UNIQUE (MaNguoiDung, MaSanPham) bảo đảm mỗi sản phẩm 1 dòng trong giỏ; CHECK SoLuong 1–5.

### AD11

**Xem, sửa số lượng, xóa sản phẩm trong giỏ (UC09)**

![AD11](png/ad11_cap_nhat_gio.png)

### AD12

**Đặt hàng (UC10)**

![AD12](png/ad12_dat_hang.png)

Toàn bộ trong 1 transaction; trừ kho có điều kiện `SoLuongTon >= ?` chống bán vượt khi nhiều người đặt cùng lúc.

### AD13

**Xem lịch sử và chi tiết đơn hàng (UC11)**

![AD13](png/ad13_lich_su_don.png)

### AD14

**Khách hủy đơn hàng (UC12)**

![AD14](png/ad14_khach_huy_don.png)

Điều kiện `AND TrangThai = CHO_XAC_NHAN` trong UPDATE xử lý trường hợp admin vừa xác nhận đơn.

### AD15

**Đánh giá sản phẩm (UC13)**

![AD15](png/ad15_danh_gia.png)

### AD16

**Xem Dashboard (UC14)**

![AD16](png/ad16_dashboard.png)

### AD17

**Quản lý bảng danh mục: xem, tìm, thêm, sửa (UC15, UC16 + CPU, Card đồ họa) – ĐÃ CÀI ĐẶT**

![AD17](png/ad17_quan_ly_danh_muc_luu.png)

Sơ đồ mô tả đúng luồng đã cài đặt và đã chạy thật trên Tomcat + SQL Server cho 4 bảng Danh mục, Thương hiệu, CPU, Card đồ họa.

### AD18

**Xóa bản ghi bảng danh mục (UC15, UC16 + CPU, Card đồ họa) – ĐÃ CÀI ĐẶT**

![AD18](png/ad18_quan_ly_danh_muc_xoa.png)

Đã cài đặt và chạy thật. Đếm sản phẩm trước khi xóa để báo lỗi dễ hiểu; lỗi 547 là lớp bảo vệ cuối từ khóa ngoại NO ACTION.

### AD19

**Admin thêm / sửa sản phẩm (UC17)**

![AD19](png/ad19_them_sua_san_pham.png)

### AD20

**Admin xóa / ngừng kinh doanh sản phẩm (UC17)**

![AD20](png/ad20_xoa_ngung_ban_san_pham.png)

### AD21

**Admin xem danh sách và chi tiết đơn hàng (UC18)**

![AD21](png/ad21_xem_don_hang_admin.png)

### AD22

**Admin cập nhật trạng thái đơn hàng (UC19)**

![AD22](png/ad22_cap_nhat_trang_thai_don.png)

Mỗi bước chuyển ghi 1 dòng LichSuTrangThaiDon; CHECK CK_LichSuTrangThaiDon_ChuyenTrangThai chặn bước chuyển sai ở mức DB.

### AD23

**Admin xác nhận đã nhận chuyển khoản (UC20)**

![AD23](png/ad23_xac_nhan_thanh_toan.png)

### AD24

**Quản lý thành viên: khóa / mở, đổi vai trò (UC21)**

![AD24](png/ad24_quan_ly_thanh_vien.png)

### AD25

**Quản lý khuyến mãi và gắn sản phẩm (UC22)**

![AD25](png/ad25_quan_ly_khuyen_mai.png)

### AD26

**Admin ẩn / hiện đánh giá (UC23)**

![AD26](png/ad26_quan_ly_danh_gia.png)

### AD27

**Quản lý banner trang chủ (UC24)**

![AD27](png/ad27_quan_ly_banner.png)

### AD28

**Xem thống kê (UC25)**

![AD28](png/ad28_thong_ke.png)

### AD29

**Tính giá hiện hành của sản phẩm (S03, dùng chung)**

![AD29](png/ad29_tinh_gia_hien_hanh.png)

Dùng chung cho trang chủ, danh sách, chi tiết, giỏ hàng và đặt hàng (BR15–BR17).

## 7. Danh sách file và cách mở

| Thư mục | Nội dung | Dùng để |
|---|---|---|
| `png/` | Ảnh sơ đồ, độ phân giải 150 dpi | Chèn vào báo cáo / slide |
| `svg/` | Ảnh vector | In ấn, phóng to không vỡ nét |
| `drawio/` | File draw.io, mỗi sơ đồ 1 file, vị trí hình giống bản PNG | Chỉnh sửa tay |

Mở file `.drawio`: ứng dụng draw.io Desktop, hoặc trang app.diagrams.net → File → Open from → Device. Mọi hình (bảng, lớp, hoạt động, làn) là đối tượng riêng, sửa chữ và kéo thả được. Đường nối giữ theo hình dạng của Graphviz; khi kéo hình, có thể chọn đường nối → Format → Waypoints để draw.io vẽ lại.

Tổng cộng: 3 sơ đồ CSDL (ERD khái niệm, ERD logic, sơ đồ quan hệ), 5 Class Diagram, 29 Activity Diagram.
