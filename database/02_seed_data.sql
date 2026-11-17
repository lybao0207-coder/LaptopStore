/* =====================================================================
   LaptopShop - 02_seed_data.sql
   Dữ liệu mẫu (demo). Sinh tự động bởi gen_seed.py và đã tự kiểm tra
   các quy tắc nghiệp vụ trước khi xuất.
   - Chạy SAU 01_create_database.sql, trên database rỗng.
   - Toàn bộ chạy trong 1 transaction: lỗi bất kỳ -> rollback toàn bộ.
   - Thông số kỹ thuật và giá chỉ mang tính minh họa cho đồ án.
   - Tài khoản demo (chỉ dùng khi demo, đổi mật khẩu nếu triển khai thật):
       QUAN_TRI    : admin@laptopshop.local      / Admin@123
       KHACH_HANG : customer01..12@laptopshop.local / Customer@123  (customer12 bị khóa)
   - Mật khẩu lưu dạng PBKDF2-HMAC-SHA256, 600000 vòng lặp, salt 16 byte, hash 32 byte.
   ===================================================================== */
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
USE CuaHangLaptop;
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;

IF EXISTS (SELECT 1 FROM dbo.NguoiDung) OR EXISTS (SELECT 1 FROM dbo.SanPham)
    THROW 50001, N'Database đã có dữ liệu. Chạy 00_drop_database.sql và 01_create_database.sql trước khi seed lại.', 1;

BEGIN TRANSACTION;


-- NguoiDung (13 dòng)
SET IDENTITY_INSERT dbo.NguoiDung ON;
INSERT INTO dbo.NguoiDung (MaNguoiDung, Email, MatKhauBam, HoTen, SoDienThoai, DiaChi, VaiTro, BiKhoa, NgayTao) VALUES
    (1, N'admin@laptopshop.local', N'pbkdf2_sha256$600000$ZvhNiKHXNez5w52UwCUIgQ==$xMIzPWCs2QcmXcxBvSdnbKMNnPUyidD690RdC3LP4ys=', N'Quản trị viên', N'0900000001', N'Trường ĐH Công nghệ Sài Gòn, 180 Cao Lỗ, Phường 4, Quận 8, TP.HCM', N'QUAN_TRI', 0, '2025-11-01T08:00:00'),
    (2, N'customer01@laptopshop.local', N'pbkdf2_sha256$600000$6NBek4B4U6uwulFYV61tVw==$8FU/PlVZzQiRiCi1jhDN046w4sc3BawXeaAn1WCdxBk=', N'Nguyễn Văn An', N'0912345600', N'10 Đường số 1, Quận 1, TP.HCM', N'KHACH_HANG', 0, '2025-11-05T09:00:00'),
    (3, N'customer02@laptopshop.local', N'pbkdf2_sha256$600000$hDWXXVbR2tuqhtP4vJTfNQ==$Ftv70MfRa5H9CaBKUQeD7B+4D33AowkviQo2fA+Wn84=', N'Trần Thị Bình', N'0912345607', N'13 Đường số 2, Quận 3, TP.HCM', N'KHACH_HANG', 0, '2025-11-08T10:00:00'),
    (4, N'customer03@laptopshop.local', N'pbkdf2_sha256$600000$tjeCohYP2efCIR6iCBGQ6w==$NprZZCzlj2B4PfVvizNJTv2xm2kanaHcqPGJMgl85Jc=', N'Lê Hoàng Cường', N'0912345614', N'16 Đường số 3, Quận 7, TP.HCM', N'KHACH_HANG', 0, '2025-11-11T11:00:00'),
    (5, N'customer04@laptopshop.local', N'pbkdf2_sha256$600000$TZINzxyzw2ppc7ncYQXd+w==$MbnndX8/wFiN7sXrV3lSYt6D1FYHvj5f7qgLgg9IPPk=', N'Phạm Ngọc Dung', N'0912345621', N'19 Đường số 4, TP. Thủ Đức, TP.HCM', N'KHACH_HANG', 0, '2025-11-14T12:00:00'),
    (6, N'customer05@laptopshop.local', N'pbkdf2_sha256$600000$e550K0NWJEZTqs/GQpMxMg==$sWGAlRIlL0ILwUqee4+liJ5tMuq2VPZ17afwN9NnwRc=', N'Hoàng Minh Đức', N'0912345628', N'22 Đường số 5, Quận Bình Thạnh, TP.HCM', N'KHACH_HANG', 0, '2025-11-17T13:00:00'),
    (7, N'customer06@laptopshop.local', N'pbkdf2_sha256$600000$hGBr0C+AiLlVHRzXs5aXNg==$QxXjJvcYiI8GgoP8dewDeOLJJCef7SFiCfUWaWwLwvU=', N'Vũ Thu Hà', N'0912345635', N'25 Đường số 6, Quận Tân Bình, TP.HCM', N'KHACH_HANG', 0, '2025-11-20T14:00:00'),
    (8, N'customer07@laptopshop.local', N'pbkdf2_sha256$600000$rX9+RjxdxU2qU7bh4uxySg==$clGls0xVFT+zwdGxU04ttIZFbQgfepNQL0XkkTdU140=', N'Đặng Quốc Huy', N'0912345642', N'28 Đường số 7, Quận Gò Vấp, TP.HCM', N'KHACH_HANG', 0, '2025-11-23T15:00:00'),
    (9, N'customer08@laptopshop.local', N'pbkdf2_sha256$600000$wlpnyAjkpG5FsTffha+Zxg==$qa5xcxQwnsDfhUOrHZg7nrt4xfOZdV9CXi1C9mC/+wA=', N'Bùi Thanh Lan', N'0912345649', N'31 Đường số 8, TP. Biên Hòa, Đồng Nai', N'KHACH_HANG', 0, '2025-11-26T16:00:00'),
    (10, N'customer09@laptopshop.local', N'pbkdf2_sha256$600000$X0OA2OiuPn7HtuDjwFIryQ==$o86nb7gmMdhHqrrLxU6ceTKlgMf9QkwcOJJ5Q1BUCHM=', N'Đỗ Văn Long', N'0912345656', N'34 Đường số 9, TP. Thủ Dầu Một, Bình Dương', N'KHACH_HANG', 0, '2025-11-29T17:00:00'),
    (11, N'customer10@laptopshop.local', N'pbkdf2_sha256$600000$61jpOygCxwzAbY6CY1MHdA==$1FwJM9/GdeFfEizbq8Q49H1v4l70FUzjyE9+y3+XdVU=', N'Ngô Thị Mai', N'0912345663', N'37 Đường số 10, Quận 10, TP.HCM', N'KHACH_HANG', 0, '2025-12-02T18:00:00'),
    (12, N'customer11@laptopshop.local', N'pbkdf2_sha256$600000$SIDjux26tbsnWsaPtFQaRA==$lIqhtHYvCvNawj3eD0szYXSvCeU47BZOnlpVTdPhK5g=', N'Dương Tuấn Nam', N'0912345670', N'40 Đường số 11, Quận 5, TP.HCM', N'KHACH_HANG', 0, '2025-12-05T19:00:00'),
    (13, N'customer12@laptopshop.local', N'pbkdf2_sha256$600000$DxXI9C3mevDGqlzi/WbtxQ==$m0nuYRRgpGWMhInf5vUkgQmFG0+KfOuLPoKhf8eBGJs=', N'Lý Bảo Ngọc', N'0912345677', N'43 Đường số 12, Quận Phú Nhuận, TP.HCM', N'KHACH_HANG', 1, '2025-12-08T20:00:00');
SET IDENTITY_INSERT dbo.NguoiDung OFF;

-- DanhMuc (5 dòng)
SET IDENTITY_INSERT dbo.DanhMuc ON;
INSERT INTO dbo.DanhMuc (MaDanhMuc, TenDanhMuc, DuongDanUrl, MoTa, DangHoatDong, NgayTao) VALUES
    (1, N'Văn phòng - Học tập', N'van-phong-hoc-tap', N'Laptop phổ thông cho học sinh, sinh viên và công việc văn phòng.', 1, '2025-11-01T08:00:00'),
    (2, N'Gaming', N'gaming', N'Laptop chơi game với card đồ họa rời, màn hình tần số quét cao.', 1, '2025-11-01T08:00:00'),
    (3, N'Đồ họa - Kỹ thuật', N'do-hoa-ky-thuat', N'Laptop cho thiết kế, dựng phim, kỹ thuật với cấu hình mạnh.', 1, '2025-11-01T08:00:00'),
    (4, N'Mỏng nhẹ - Cao cấp', N'mong-nhe-cao-cap', N'Laptop mỏng nhẹ, pin lâu, thiết kế cao cấp.', 1, '2025-11-01T08:00:00'),
    (5, N'Doanh nhân', N'doanh-nhan', N'Laptop bền bỉ, bảo mật cao cho doanh nghiệp.', 1, '2025-11-01T08:00:00');
SET IDENTITY_INSERT dbo.DanhMuc OFF;

-- ThuongHieu (7 dòng)
SET IDENTITY_INSERT dbo.ThuongHieu ON;
INSERT INTO dbo.ThuongHieu (MaThuongHieu, TenThuongHieu, DuongDanUrl, QuocGia, DuongDanLogo, DangHoatDong, NgayTao) VALUES
    (1, N'Dell', N'dell', N'Mỹ', N'brands/dell.png', 1, '2025-11-01T08:00:00'),
    (2, N'HP', N'hp', N'Mỹ', N'brands/hp.png', 1, '2025-11-01T08:00:00'),
    (3, N'Lenovo', N'lenovo', N'Trung Quốc', N'brands/lenovo.png', 1, '2025-11-01T08:00:00'),
    (4, N'ASUS', N'asus', N'Đài Loan', N'brands/asus.png', 1, '2025-11-01T08:00:00'),
    (5, N'Acer', N'acer', N'Đài Loan', N'brands/acer.png', 1, '2025-11-01T08:00:00'),
    (6, N'MSI', N'msi', N'Đài Loan', N'brands/msi.png', 1, '2025-11-01T08:00:00'),
    (7, N'Apple', N'apple', N'Mỹ', N'brands/apple.png', 1, '2025-11-01T08:00:00');
SET IDENTITY_INSERT dbo.ThuongHieu OFF;

-- BoXuLy (16 dòng)
SET IDENTITY_INSERT dbo.BoXuLy ON;
INSERT INTO dbo.BoXuLy (MaBoXuLy, HangSanXuat, DongChip, TenModel, SoNhan, SoLuongLuong, XungNhipToiDaGHz) VALUES
    (1, N'Intel', N'Core i3', N'Core i3-1315U', 6, 8, 4.50),
    (2, N'Intel', N'Core i5', N'Core i5-1335U', 10, 12, 4.60),
    (3, N'Intel', N'Core i5', N'Core i5-13420H', 8, 12, 4.60),
    (4, N'Intel', N'Core i7', N'Core i7-1355U', 10, 12, 5.00),
    (5, N'Intel', N'Core i7', N'Core i7-13620H', 10, 16, 4.90),
    (6, N'Intel', N'Core i7', N'Core i7-13650HX', 14, 20, 4.90),
    (7, N'Intel', N'Core i7', N'Core i7-13700H', 14, 20, 5.00),
    (8, N'Intel', N'Core i9', N'Core i9-13900HX', 24, 32, 5.40),
    (9, N'Intel', N'Core Ultra 5', N'Core Ultra 5 125H', 14, 18, 4.50),
    (10, N'Intel', N'Core Ultra 7', N'Core Ultra 7 155H', 16, 22, 4.80),
    (11, N'AMD', N'Ryzen 5', N'Ryzen 5 7530U', 6, 12, 4.50),
    (12, N'AMD', N'Ryzen 7', N'Ryzen 7 7735HS', 8, 16, 4.75),
    (13, N'AMD', N'Ryzen 7', N'Ryzen 7 7840HS', 8, 16, 5.10),
    (14, N'AMD', N'Ryzen 9', N'Ryzen 9 7940HS', 8, 16, 5.20),
    (15, N'Apple', N'Apple M3', N'Apple M3 8-core', 8, 8, 4.05),
    (16, N'Apple', N'Apple M3 Pro', N'Apple M3 Pro 11-core', 11, 11, 4.05);
SET IDENTITY_INSERT dbo.BoXuLy OFF;

-- CardDoHoa (15 dòng)
SET IDENTITY_INSERT dbo.CardDoHoa ON;
INSERT INTO dbo.CardDoHoa (MaCardDoHoa, HangSanXuat, TenModel, LoaiCard, BoNhoVramGB) VALUES
    (1, N'Intel', N'Intel UHD Graphics', N'TICH_HOP', NULL),
    (2, N'Intel', N'Intel Iris Xe Graphics', N'TICH_HOP', NULL),
    (3, N'Intel', N'Intel Arc Graphics', N'TICH_HOP', NULL),
    (4, N'AMD', N'AMD Radeon Graphics', N'TICH_HOP', NULL),
    (5, N'AMD', N'AMD Radeon 680M', N'TICH_HOP', NULL),
    (6, N'AMD', N'AMD Radeon 780M', N'TICH_HOP', NULL),
    (7, N'Apple', N'Apple M3 GPU 8-core', N'TICH_HOP', NULL),
    (8, N'Apple', N'Apple M3 GPU 10-core', N'TICH_HOP', NULL),
    (9, N'Apple', N'Apple M3 Pro GPU 14-core', N'TICH_HOP', NULL),
    (10, N'NVIDIA', N'NVIDIA GeForce RTX 2050 4GB', N'ROI', 4),
    (11, N'NVIDIA', N'NVIDIA GeForce RTX 3050 6GB', N'ROI', 6),
    (12, N'NVIDIA', N'NVIDIA GeForce RTX 4050 6GB', N'ROI', 6),
    (13, N'NVIDIA', N'NVIDIA GeForce RTX 4060 8GB', N'ROI', 8),
    (14, N'NVIDIA', N'NVIDIA GeForce RTX 4080 12GB', N'ROI', 12),
    (15, N'NVIDIA', N'NVIDIA RTX A1000 6GB', N'ROI', 6);
SET IDENTITY_INSERT dbo.CardDoHoa OFF;

-- SanPham (46 dòng)
SET IDENTITY_INSERT dbo.SanPham ON;
INSERT INTO dbo.SanPham (MaSanPham, MaSku, TenSanPham, DuongDanUrl, MaDanhMuc, MaThuongHieu, DongMay, MoTaNgan, MoTa, GiaBan, SoLuongTon, BaoHanhThang, MaBoXuLy, MaCardDoHoa, DungLuongRamGB, LoaiRam, BusRamMHz, SoKheRam, RamToiDaGB, DungLuongOCungGB, LoaiOCung, KichThuocManHinhInch, DoPhanGiaiNgang, DoPhanGiaiDoc, TamNen, TanSoQuetHz, CamUng, DungLuongPinWh, TrongLuongKg, KichThuoc, ChatLieu, MauSac, CongKetNoi, KetNoiKhongDay, Webcam, DenBanPhim, HeDieuHanh, NamRaMat, TrangThai, NgayTao) VALUES
    (1, N'DEL-001', N'Dell Inspiron 15 3530 i5-1335U/8GB/512GB', N'dell-inspiron-15-3530-i5-1335u-8gb-512gb', 1, 1, N'Inspiron', N'Core i5-1335U, RAM 8GB, SSD 512GB, màn hình 15.6 inch 120Hz.', N'Dell Inspiron 15 3530 i5-1335U/8GB/512GB thuộc dòng Inspiron, phù hợp nhóm Văn phòng - Học tập. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 15990000, 16, 12, 2, 2, 8, N'DDR4', 2666, 2, 16, 512, N'SSD_NVME', 15.6, 1920, 1080, N'IPS', 120, 0, 41.0, 1.65, NULL, N'Nhựa', N'Bạc', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 0, N'Windows 11 Home', 2023, N'DANG_BAN', '2025-11-10T09:00:00'),
    (2, N'DEL-002', N'Dell Inspiron 15 3530 i7-1355U/16GB/512GB', N'dell-inspiron-15-3530-i7-1355u-16gb-512gb', 1, 1, N'Inspiron', N'Core i7-1355U, RAM 16GB, SSD 512GB, màn hình 15.6 inch 120Hz.', N'Dell Inspiron 15 3530 i7-1355U/16GB/512GB thuộc dòng Inspiron, phù hợp nhóm Văn phòng - Học tập. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 19990000, 14, 12, 4, 2, 16, N'DDR4', 2666, 2, 16, 512, N'SSD_NVME', 15.6, 1920, 1080, N'IPS', 120, 0, 41.0, 1.65, NULL, N'Nhựa', N'Bạc', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 0, N'Windows 11 Home', 2023, N'DANG_BAN', '2025-11-17T10:00:00'),
    (3, N'DEL-003', N'Dell Vostro 14 3430 i3-1315U/8GB/256GB', N'dell-vostro-14-3430-i3-1315u-8gb-256gb', 1, 1, N'Vostro', N'Core i3-1315U, RAM 8GB, SSD 256GB, màn hình 14.0 inch 60Hz.', N'Dell Vostro 14 3430 i3-1315U/8GB/256GB thuộc dòng Vostro, phù hợp nhóm Văn phòng - Học tập. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 11490000, 0, 12, 1, 1, 8, N'DDR4', 2666, 2, 16, 256, N'SSD_NVME', 14.0, 1920, 1080, N'IPS', 60, 0, 41.0, 1.50, NULL, N'Nhựa', N'Đen', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 0, N'Windows 11 Home', 2023, N'NGUNG_BAN', '2025-11-24T11:00:00'),
    (4, N'DEL-004', N'Dell Latitude 14 7440 i7-1355U/16GB/512GB', N'dell-latitude-14-7440-i7-1355u-16gb-512gb', 5, 1, N'Latitude', N'Core i7-1355U, RAM 16GB, SSD 512GB, màn hình 14.0 inch 60Hz.', N'Dell Latitude 14 7440 i7-1355U/16GB/512GB thuộc dòng Latitude, phù hợp nhóm Doanh nhân. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 32990000, 15, 36, 4, 2, 16, N'LPDDR5', 4800, 0, 16, 512, N'SSD_NVME', 14.0, 1920, 1200, N'IPS', 60, 0, 57.0, 1.38, NULL, N'Nhôm', N'Xám', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'1080p FHD', 1, N'Windows 11 Pro', 2023, N'DANG_BAN', '2025-12-01T12:00:00'),
    (5, N'DEL-005', N'Dell XPS 13 9340 Ultra 7 155H/16GB/512GB', N'dell-xps-13-9340-ultra-7-155h-16gb-512gb', 4, 1, N'XPS', N'Core Ultra 7 155H, RAM 16GB, SSD 512GB, màn hình 13.4 inch 120Hz.', N'Dell XPS 13 9340 Ultra 7 155H/16GB/512GB thuộc dòng XPS, phù hợp nhóm Mỏng nhẹ - Cao cấp. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 44990000, 26, 12, 10, 3, 16, N'LPDDR5X', 7467, 0, 16, 512, N'SSD_NVME', 13.4, 1920, 1200, N'IPS', 120, 0, 55.0, 1.19, NULL, N'Nhôm', N'Bạch kim', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6E, Bluetooth 5.3', N'1080p FHD', 1, N'Windows 11 Home', 2024, N'DANG_BAN', '2025-12-08T13:00:00'),
    (6, N'DEL-006', N'Dell G15 5530 i7-13650HX/16GB/512GB RTX 4060', N'dell-g15-5530-i7-13650hx-16gb-512gb-rtx-4060', 2, 1, N'G-Series', N'Core i7-13650HX, RAM 16GB, SSD 512GB, màn hình 15.6 inch 165Hz.', N'Dell G15 5530 i7-13650HX/16GB/512GB RTX 4060 thuộc dòng G-Series, phù hợp nhóm Gaming. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 35990000, 17, 12, 6, 13, 16, N'DDR5', 4800, 2, 32, 512, N'SSD_NVME', 15.6, 1920, 1080, N'IPS', 165, 0, 86.0, 2.81, NULL, N'Nhựa', N'Xám đậm', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 1, N'Windows 11 Home', 2023, N'DANG_BAN', '2025-12-15T14:00:00'),
    (7, N'DEL-007', N'Dell Precision 15 3581 i7-13700H/32GB/1TB RTX A1000', N'dell-precision-15-3581-i7-13700h-32gb-1tb-rtx-a1000', 3, 1, N'Precision', N'Core i7-13700H, RAM 32GB, SSD 1024GB, màn hình 15.6 inch 60Hz.', N'Dell Precision 15 3581 i7-13700H/32GB/1TB RTX A1000 thuộc dòng Precision, phù hợp nhóm Đồ họa - Kỹ thuật. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 42990000, 11, 36, 7, 15, 32, N'DDR5', 5200, 2, 64, 1024, N'SSD_NVME', 15.6, 1920, 1080, N'IPS', 60, 0, 64.0, 1.79, NULL, N'Nhôm', N'Xám', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'1080p FHD', 1, N'Windows 11 Pro', 2023, N'DANG_BAN', '2025-12-22T15:00:00'),
    (8, N'HPX-001', N'HP 15 i3-1315U/8GB/256GB', N'hp-15-i3-1315u-8gb-256gb', 1, 2, N'HP 15', N'Core i3-1315U, RAM 8GB, SSD 256GB, màn hình 15.6 inch 60Hz.', N'HP 15 i3-1315U/8GB/256GB thuộc dòng HP 15, phù hợp nhóm Văn phòng - Học tập. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 10990000, 20, 12, 1, 1, 8, N'DDR4', 3200, 2, 16, 256, N'SSD_NVME', 15.6, 1920, 1080, N'IPS', 60, 0, 41.0, 1.59, NULL, N'Nhựa', N'Bạc', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 0, N'Windows 11 Home', 2023, N'DANG_BAN', '2025-12-29T16:00:00'),
    (9, N'HPX-002', N'HP 15 i5-1335U/8GB/512GB', N'hp-15-i5-1335u-8gb-512gb', 1, 2, N'HP 15', N'Core i5-1335U, RAM 8GB, SSD 512GB, màn hình 15.6 inch 60Hz.', N'HP 15 i5-1335U/8GB/512GB thuộc dòng HP 15, phù hợp nhóm Văn phòng - Học tập. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 13490000, 19, 12, 2, 2, 8, N'DDR4', 3200, 2, 16, 512, N'SSD_NVME', 15.6, 1920, 1080, N'IPS', 60, 0, 41.0, 1.59, NULL, N'Nhựa', N'Bạc', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 0, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-01-05T17:00:00'),
    (10, N'HPX-003', N'HP Pavilion 14 i5-1335U/16GB/512GB', N'hp-pavilion-14-i5-1335u-16gb-512gb', 1, 2, N'Pavilion', N'Core i5-1335U, RAM 16GB, SSD 512GB, màn hình 14.0 inch 60Hz.', N'HP Pavilion 14 i5-1335U/16GB/512GB thuộc dòng Pavilion, phù hợp nhóm Văn phòng - Học tập. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 17490000, 12, 12, 2, 2, 16, N'DDR4', 3200, 2, 16, 512, N'SSD_NVME', 14.0, 1920, 1080, N'IPS', 60, 0, 43.0, 1.41, NULL, N'Nhựa', N'Vàng', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 0, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-01-12T09:00:00'),
    (11, N'HPX-004', N'HP Envy x360 14 Ultra 5 125H/16GB/512GB OLED', N'hp-envy-x360-14-ultra-5-125h-16gb-512gb-oled', 4, 2, N'Envy', N'Core Ultra 5 125H, RAM 16GB, SSD 512GB, màn hình 14.0 inch 120Hz.', N'HP Envy x360 14 Ultra 5 125H/16GB/512GB OLED thuộc dòng Envy, phù hợp nhóm Mỏng nhẹ - Cao cấp. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 26990000, 30, 12, 9, 3, 16, N'LPDDR5X', 6400, 0, 16, 512, N'SSD_NVME', 14.0, 2880, 1800, N'OLED', 120, 1, 59.0, 1.39, NULL, N'Nhôm', N'Xanh đen', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6E, Bluetooth 5.3', N'1080p FHD', 1, N'Windows 11 Home', 2024, N'DANG_BAN', '2026-01-19T10:00:00'),
    (12, N'HPX-005', N'HP Victus 16 i5-13420H/16GB/512GB RTX 3050', N'hp-victus-16-i5-13420h-16gb-512gb-rtx-3050', 2, 2, N'Victus', N'Core i5-13420H, RAM 16GB, SSD 512GB, màn hình 16.1 inch 144Hz.', N'HP Victus 16 i5-13420H/16GB/512GB RTX 3050 thuộc dòng Victus, phù hợp nhóm Gaming. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 22990000, 8, 12, 3, 11, 16, N'DDR4', 3200, 2, 32, 512, N'SSD_NVME', 16.1, 1920, 1080, N'IPS', 144, 0, 70.0, 2.29, NULL, N'Nhựa', N'Đen', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 1, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-01-26T11:00:00'),
    (13, N'HPX-006', N'HP Omen 16 i7-13700H/16GB/1TB RTX 4060', N'hp-omen-16-i7-13700h-16gb-1tb-rtx-4060', 2, 2, N'Omen', N'Core i7-13700H, RAM 16GB, SSD 1024GB, màn hình 16.1 inch 165Hz.', N'HP Omen 16 i7-13700H/16GB/1TB RTX 4060 thuộc dòng Omen, phù hợp nhóm Gaming. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 37990000, 5, 12, 7, 13, 16, N'DDR5', 5200, 2, 32, 1024, N'SSD_NVME', 16.1, 2560, 1440, N'IPS', 165, 0, 83.0, 2.35, NULL, N'Nhựa', N'Đen', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 1, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-02-02T12:00:00'),
    (14, N'HPX-007', N'HP EliteBook 840 G10 i7-1355U/16GB/512GB', N'hp-elitebook-840-g10-i7-1355u-16gb-512gb', 5, 2, N'EliteBook', N'Core i7-1355U, RAM 16GB, SSD 512GB, màn hình 14.0 inch 60Hz.', N'HP EliteBook 840 G10 i7-1355U/16GB/512GB thuộc dòng EliteBook, phù hợp nhóm Doanh nhân. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 31990000, 19, 36, 4, 2, 16, N'DDR5', 5200, 2, 64, 512, N'SSD_NVME', 14.0, 1920, 1200, N'IPS', 60, 0, 51.0, 1.36, NULL, N'Nhôm', N'Bạc', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'1080p FHD', 1, N'Windows 11 Pro', 2023, N'DANG_BAN', '2026-02-09T13:00:00'),
    (15, N'LEN-001', N'Lenovo IdeaPad Slim 3 15 i3-1315U/8GB/512GB', N'lenovo-ideapad-slim-3-15-i3-1315u-8gb-512gb', 1, 3, N'IdeaPad', N'Core i3-1315U, RAM 8GB, SSD 512GB, màn hình 15.6 inch 60Hz.', N'Lenovo IdeaPad Slim 3 15 i3-1315U/8GB/512GB thuộc dòng IdeaPad, phù hợp nhóm Văn phòng - Học tập. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 10490000, 30, 24, 1, 1, 8, N'LPDDR5', 4800, 0, 8, 512, N'SSD_NVME', 15.6, 1920, 1080, N'IPS', 60, 0, 47.0, 1.62, NULL, N'Nhựa', N'Xám', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 0, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-02-16T14:00:00'),
    (16, N'LEN-002', N'Lenovo IdeaPad Slim 3 15 Ryzen 5 7530U/16GB/512GB', N'lenovo-ideapad-slim-3-15-ryzen-5-7530u-16gb-512gb', 1, 3, N'IdeaPad', N'Ryzen 5 7530U, RAM 16GB, SSD 512GB, màn hình 15.6 inch 60Hz.', N'Lenovo IdeaPad Slim 3 15 Ryzen 5 7530U/16GB/512GB thuộc dòng IdeaPad, phù hợp nhóm Văn phòng - Học tập. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 12990000, 14, 24, 11, 4, 16, N'DDR4', 3200, 1, 16, 512, N'SSD_NVME', 15.6, 1920, 1080, N'IPS', 60, 0, 47.0, 1.62, NULL, N'Nhựa', N'Xám', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 0, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-02-23T15:00:00'),
    (17, N'LEN-003', N'Lenovo IdeaPad Slim 5 14 Ultra 5 125H/16GB/512GB OLED', N'lenovo-ideapad-slim-5-14-ultra-5-125h-16gb-512gb-oled', 4, 3, N'IdeaPad', N'Core Ultra 5 125H, RAM 16GB, SSD 512GB, màn hình 14.0 inch 60Hz.', N'Lenovo IdeaPad Slim 5 14 Ultra 5 125H/16GB/512GB OLED thuộc dòng IdeaPad, phù hợp nhóm Mỏng nhẹ - Cao cấp. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 19990000, 8, 24, 9, 3, 16, N'LPDDR5X', 7467, 0, 16, 512, N'SSD_NVME', 14.0, 1920, 1200, N'OLED', 60, 0, 57.0, 1.39, NULL, N'Nhôm', N'Xanh', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6E, Bluetooth 5.3', N'1080p FHD', 1, N'Windows 11 Home', 2024, N'DANG_BAN', '2026-03-02T16:00:00'),
    (18, N'LEN-004', N'Lenovo ThinkPad E14 Gen 5 i5-1335U/16GB/512GB', N'lenovo-thinkpad-e14-gen-5-i5-1335u-16gb-512gb', 5, 3, N'ThinkPad', N'Core i5-1335U, RAM 16GB, SSD 512GB, màn hình 14.0 inch 60Hz.', N'Lenovo ThinkPad E14 Gen 5 i5-1335U/16GB/512GB thuộc dòng ThinkPad, phù hợp nhóm Doanh nhân. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 20490000, 29, 24, 2, 2, 16, N'DDR4', 3200, 1, 40, 512, N'SSD_NVME', 14.0, 1920, 1200, N'IPS', 60, 0, 57.0, 1.41, NULL, N'Nhôm', N'Đen', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'1080p FHD', 1, N'Windows 11 Pro', 2023, N'DANG_BAN', '2026-03-09T17:00:00'),
    (19, N'LEN-005', N'Lenovo ThinkPad X1 Carbon Gen 11 i7-1355U/16GB/1TB', N'lenovo-thinkpad-x1-carbon-gen-11-i7-1355u-16gb-1tb', 5, 3, N'ThinkPad', N'Core i7-1355U, RAM 16GB, SSD 1024GB, màn hình 14.0 inch 60Hz.', N'Lenovo ThinkPad X1 Carbon Gen 11 i7-1355U/16GB/1TB thuộc dòng ThinkPad, phù hợp nhóm Doanh nhân. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 45990000, 17, 36, 4, 2, 16, N'LPDDR5', 6000, 0, 16, 1024, N'SSD_NVME', 14.0, 1920, 1200, N'IPS', 60, 0, 57.0, 1.12, NULL, N'Nhôm', N'Đen', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'1080p FHD', 1, N'Windows 11 Pro', 2023, N'DANG_BAN', '2026-03-16T09:00:00'),
    (20, N'LEN-006', N'Lenovo LOQ 15 i5-13420H/16GB/512GB RTX 3050', N'lenovo-loq-15-i5-13420h-16gb-512gb-rtx-3050', 2, 3, N'LOQ', N'Core i5-13420H, RAM 16GB, SSD 512GB, màn hình 15.6 inch 144Hz.', N'Lenovo LOQ 15 i5-13420H/16GB/512GB RTX 3050 thuộc dòng LOQ, phù hợp nhóm Gaming. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 21990000, 13, 24, 3, 11, 16, N'DDR5', 4800, 2, 32, 512, N'SSD_NVME', 15.6, 1920, 1080, N'IPS', 144, 0, 60.0, 2.40, NULL, N'Nhựa', N'Xám', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 1, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-03-23T10:00:00'),
    (21, N'LEN-007', N'Lenovo Legion 5 16 Ryzen 7 7840HS/16GB/1TB RTX 4060', N'lenovo-legion-5-16-ryzen-7-7840hs-16gb-1tb-rtx-4060', 2, 3, N'Legion', N'Ryzen 7 7840HS, RAM 16GB, SSD 1024GB, màn hình 16.0 inch 165Hz.', N'Lenovo Legion 5 16 Ryzen 7 7840HS/16GB/1TB RTX 4060 thuộc dòng Legion, phù hợp nhóm Gaming. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 35990000, 12, 24, 13, 13, 16, N'DDR5', 5600, 2, 32, 1024, N'SSD_NVME', 16.0, 2560, 1600, N'IPS', 165, 0, 80.0, 2.40, NULL, N'Nhựa', N'Xám', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 1, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-03-30T11:00:00'),
    (22, N'LEN-008', N'Lenovo Yoga Slim 7 14 Ultra 7 155H/32GB/1TB OLED', N'lenovo-yoga-slim-7-14-ultra-7-155h-32gb-1tb-oled', 4, 3, N'Yoga', N'Core Ultra 7 155H, RAM 32GB, SSD 1024GB, màn hình 14.0 inch 120Hz.', N'Lenovo Yoga Slim 7 14 Ultra 7 155H/32GB/1TB OLED thuộc dòng Yoga, phù hợp nhóm Mỏng nhẹ - Cao cấp. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 30990000, 1, 24, 10, 3, 32, N'LPDDR5X', 7467, 0, 32, 1024, N'SSD_NVME', 14.0, 2880, 1800, N'OLED', 120, 0, 65.0, 1.39, NULL, N'Nhôm', N'Xám', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6E, Bluetooth 5.3', N'1080p FHD', 1, N'Windows 11 Home', 2024, N'DANG_BAN', '2026-04-06T12:00:00'),
    (23, N'LEN-009', N'Lenovo Legion Pro 7 16 i9-13900HX/32GB/1TB RTX 4080', N'lenovo-legion-pro-7-16-i9-13900hx-32gb-1tb-rtx-4080', 2, 3, N'Legion', N'Core i9-13900HX, RAM 32GB, SSD 1024GB, màn hình 16.0 inch 240Hz.', N'Lenovo Legion Pro 7 16 i9-13900HX/32GB/1TB RTX 4080 thuộc dòng Legion, phù hợp nhóm Gaming. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 74990000, 18, 24, 8, 14, 32, N'DDR5', 5600, 2, 32, 1024, N'SSD_NVME', 16.0, 2560, 1600, N'IPS', 240, 0, 99.9, 2.80, NULL, N'Nhựa', N'Đen', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 1, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-04-13T13:00:00'),
    (24, N'ASU-001', N'ASUS Vivobook 15 i3-1315U/8GB/512GB', N'asus-vivobook-15-i3-1315u-8gb-512gb', 1, 4, N'Vivobook', N'Core i3-1315U, RAM 8GB, SSD 512GB, màn hình 15.6 inch 60Hz.', N'ASUS Vivobook 15 i3-1315U/8GB/512GB thuộc dòng Vivobook, phù hợp nhóm Văn phòng - Học tập. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 10790000, 24, 24, 1, 1, 8, N'DDR4', 3200, 1, 16, 512, N'SSD_NVME', 15.6, 1920, 1080, N'IPS', 60, 0, 42.0, 1.70, NULL, N'Nhựa', N'Bạc', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 0, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-04-20T14:00:00'),
    (25, N'ASU-002', N'ASUS Vivobook 15 OLED i5-13420H/16GB/512GB', N'asus-vivobook-15-oled-i5-13420h-16gb-512gb', 1, 4, N'Vivobook', N'Core i5-13420H, RAM 16GB, SSD 512GB, màn hình 15.6 inch 60Hz.', N'ASUS Vivobook 15 OLED i5-13420H/16GB/512GB thuộc dòng Vivobook, phù hợp nhóm Văn phòng - Học tập. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 15990000, 29, 24, 3, 1, 16, N'DDR4', 3200, 1, 16, 512, N'SSD_NVME', 15.6, 1920, 1080, N'OLED', 60, 0, 50.0, 1.70, NULL, N'Nhựa', N'Xanh', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 0, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-04-27T15:00:00'),
    (26, N'ASU-003', N'ASUS Zenbook 14 OLED Ultra 7 155H/16GB/1TB', N'asus-zenbook-14-oled-ultra-7-155h-16gb-1tb', 4, 4, N'Zenbook', N'Core Ultra 7 155H, RAM 16GB, SSD 1024GB, màn hình 14.0 inch 120Hz.', N'ASUS Zenbook 14 OLED Ultra 7 155H/16GB/1TB thuộc dòng Zenbook, phù hợp nhóm Mỏng nhẹ - Cao cấp. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 28990000, 2, 24, 10, 3, 16, N'LPDDR5X', 7467, 0, 16, 1024, N'SSD_NVME', 14.0, 2880, 1800, N'OLED', 120, 1, 75.0, 1.20, NULL, N'Nhôm', N'Xanh đen', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6E, Bluetooth 5.3', N'1080p FHD', 1, N'Windows 11 Home', 2024, N'DANG_BAN', '2026-05-04T16:00:00'),
    (27, N'ASU-004', N'ASUS TUF Gaming F15 i7-13620H/16GB/512GB RTX 4050', N'asus-tuf-gaming-f15-i7-13620h-16gb-512gb-rtx-4050', 2, 4, N'TUF Gaming', N'Core i7-13620H, RAM 16GB, SSD 512GB, màn hình 15.6 inch 144Hz.', N'ASUS TUF Gaming F15 i7-13620H/16GB/512GB RTX 4050 thuộc dòng TUF Gaming, phù hợp nhóm Gaming. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 24990000, 27, 24, 5, 12, 16, N'DDR5', 4800, 2, 32, 512, N'SSD_NVME', 15.6, 1920, 1080, N'IPS', 144, 0, 90.0, 2.20, NULL, N'Nhựa', N'Xám', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 1, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-05-11T17:00:00'),
    (28, N'ASU-005', N'ASUS TUF Gaming A15 Ryzen 7 7735HS/16GB/512GB RTX 4050', N'asus-tuf-gaming-a15-ryzen-7-7735hs-16gb-512gb-rtx-4050', 2, 4, N'TUF Gaming', N'Ryzen 7 7735HS, RAM 16GB, SSD 512GB, màn hình 15.6 inch 144Hz.', N'ASUS TUF Gaming A15 Ryzen 7 7735HS/16GB/512GB RTX 4050 thuộc dòng TUF Gaming, phù hợp nhóm Gaming. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 23490000, 25, 24, 12, 12, 16, N'DDR5', 4800, 2, 32, 512, N'SSD_NVME', 15.6, 1920, 1080, N'IPS', 144, 0, 90.0, 2.20, NULL, N'Nhựa', N'Xám', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 1, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-05-18T09:00:00'),
    (29, N'ASU-006', N'ASUS ROG Strix G16 i7-13650HX/16GB/512GB RTX 4060', N'asus-rog-strix-g16-i7-13650hx-16gb-512gb-rtx-4060', 2, 4, N'ROG', N'Core i7-13650HX, RAM 16GB, SSD 512GB, màn hình 16.0 inch 165Hz.', N'ASUS ROG Strix G16 i7-13650HX/16GB/512GB RTX 4060 thuộc dòng ROG, phù hợp nhóm Gaming. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 36990000, 15, 24, 6, 13, 16, N'DDR5', 4800, 2, 32, 512, N'SSD_NVME', 16.0, 1920, 1200, N'IPS', 165, 0, 90.0, 2.50, NULL, N'Nhựa', N'Xám', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 1, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-05-25T10:00:00'),
    (30, N'ASU-007', N'ASUS ROG Zephyrus G14 Ryzen 9 7940HS/16GB/1TB RTX 4060', N'asus-rog-zephyrus-g14-ryzen-9-7940hs-16gb-1tb-rtx-4060', 2, 4, N'ROG', N'Ryzen 9 7940HS, RAM 16GB, SSD 1024GB, màn hình 14.0 inch 165Hz.', N'ASUS ROG Zephyrus G14 Ryzen 9 7940HS/16GB/1TB RTX 4060 thuộc dòng ROG, phù hợp nhóm Gaming. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 46990000, 0, 24, 14, 13, 16, N'DDR5', 4800, 1, 24, 1024, N'SSD_NVME', 14.0, 2560, 1600, N'MINI_LED', 165, 0, 76.0, 1.72, NULL, N'Nhựa', N'Trắng', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 1, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-06-01T11:00:00'),
    (31, N'ASU-008', N'ASUS Vivobook Pro 15 OLED Ryzen 7 7840HS/16GB/512GB RTX 3050', N'asus-vivobook-pro-15-oled-ryzen-7-7840hs-16gb-512gb-rtx-3050', 3, 4, N'Vivobook Pro', N'Ryzen 7 7840HS, RAM 16GB, SSD 512GB, màn hình 15.6 inch 120Hz.', N'ASUS Vivobook Pro 15 OLED Ryzen 7 7840HS/16GB/512GB RTX 3050 thuộc dòng Vivobook Pro, phù hợp nhóm Đồ họa - Kỹ thuật. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 27990000, 25, 24, 13, 11, 16, N'DDR5', 5600, 0, 16, 512, N'SSD_NVME', 15.6, 2880, 1620, N'OLED', 120, 0, 70.0, 1.80, NULL, N'Nhôm', N'Xanh đen', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'1080p FHD', 1, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-06-08T12:00:00'),
    (32, N'ACE-001', N'Acer Aspire 3 i3-1315U/8GB/256GB', N'acer-aspire-3-i3-1315u-8gb-256gb', 1, 5, N'Aspire', N'Core i3-1315U, RAM 8GB, SSD 256GB, màn hình 15.6 inch 60Hz.', N'Acer Aspire 3 i3-1315U/8GB/256GB thuộc dòng Aspire, phù hợp nhóm Văn phòng - Học tập. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 9490000, 11, 12, 1, 1, 8, N'LPDDR5', 4800, 0, 8, 256, N'SSD_NVME', 15.6, 1920, 1080, N'IPS', 60, 0, 50.0, 1.78, NULL, N'Nhựa', N'Bạc', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 0, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-06-15T13:00:00'),
    (33, N'ACE-002', N'Acer Aspire 5 i5-1335U/16GB/512GB', N'acer-aspire-5-i5-1335u-16gb-512gb', 1, 5, N'Aspire', N'Core i5-1335U, RAM 16GB, SSD 512GB, màn hình 14.0 inch 60Hz.', N'Acer Aspire 5 i5-1335U/16GB/512GB thuộc dòng Aspire, phù hợp nhóm Văn phòng - Học tập. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 14490000, 23, 12, 2, 2, 16, N'DDR4', 3200, 2, 32, 512, N'SSD_NVME', 14.0, 1920, 1200, N'IPS', 60, 0, 50.0, 1.57, NULL, N'Nhựa', N'Xám', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 0, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-06-22T14:00:00'),
    (34, N'ACE-003', N'Acer Swift Go 14 Ultra 5 125H/16GB/512GB OLED', N'acer-swift-go-14-ultra-5-125h-16gb-512gb-oled', 4, 5, N'Swift', N'Core Ultra 5 125H, RAM 16GB, SSD 512GB, màn hình 14.0 inch 90Hz.', N'Acer Swift Go 14 Ultra 5 125H/16GB/512GB OLED thuộc dòng Swift, phù hợp nhóm Mỏng nhẹ - Cao cấp. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 21990000, 24, 12, 9, 3, 16, N'LPDDR5X', 6400, 0, 16, 512, N'SSD_NVME', 14.0, 2880, 1800, N'OLED', 90, 0, 65.0, 1.32, NULL, N'Nhôm', N'Bạc', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6E, Bluetooth 5.3', N'1080p FHD', 1, N'Windows 11 Home', 2024, N'DANG_BAN', '2026-06-29T15:00:00'),
    (35, N'ACE-004', N'Acer Nitro V 15 i5-13420H/16GB/512GB RTX 4050', N'acer-nitro-v-15-i5-13420h-16gb-512gb-rtx-4050', 2, 5, N'Nitro', N'Core i5-13420H, RAM 16GB, SSD 512GB, màn hình 15.6 inch 144Hz.', N'Acer Nitro V 15 i5-13420H/16GB/512GB RTX 4050 thuộc dòng Nitro, phù hợp nhóm Gaming. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 21490000, 23, 12, 3, 12, 16, N'DDR5', 5200, 2, 32, 512, N'SSD_NVME', 15.6, 1920, 1080, N'IPS', 144, 0, 57.0, 2.10, NULL, N'Nhựa', N'Đen', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 1, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-07-06T16:00:00'),
    (36, N'ACE-005', N'Acer Predator Helios Neo 16 i7-13650HX/16GB/512GB RTX 4060', N'acer-predator-helios-neo-16-i7-13650hx-16gb-512gb-rtx-4060', 2, 5, N'Predator', N'Core i7-13650HX, RAM 16GB, SSD 512GB, màn hình 16.0 inch 165Hz.', N'Acer Predator Helios Neo 16 i7-13650HX/16GB/512GB RTX 4060 thuộc dòng Predator, phù hợp nhóm Gaming. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 34990000, 3, 12, 6, 13, 16, N'DDR5', 4800, 2, 32, 512, N'SSD_NVME', 16.0, 2560, 1600, N'IPS', 165, 0, 90.0, 2.60, NULL, N'Nhựa', N'Đen', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 1, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-07-13T17:00:00'),
    (37, N'MSI-001', N'MSI Modern 14 i3-1315U/8GB/512GB', N'msi-modern-14-i3-1315u-8gb-512gb', 1, 6, N'Modern', N'Core i3-1315U, RAM 8GB, SSD 512GB, màn hình 14.0 inch 60Hz.', N'MSI Modern 14 i3-1315U/8GB/512GB thuộc dòng Modern, phù hợp nhóm Văn phòng - Học tập. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 10990000, 12, 24, 1, 1, 8, N'DDR4', 3200, 1, 64, 512, N'SSD_NVME', 14.0, 1920, 1080, N'IPS', 60, 0, 39.3, 1.40, NULL, N'Nhựa', N'Đen', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 0, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-07-20T09:00:00'),
    (38, N'MSI-002', N'MSI Modern 15 i5-1335U/16GB/512GB', N'msi-modern-15-i5-1335u-16gb-512gb', 1, 6, N'Modern', N'Core i5-1335U, RAM 16GB, SSD 512GB, màn hình 15.6 inch 60Hz.', N'MSI Modern 15 i5-1335U/16GB/512GB thuộc dòng Modern, phù hợp nhóm Văn phòng - Học tập. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 13990000, 14, 24, 2, 2, 16, N'DDR4', 3200, 1, 64, 512, N'SSD_NVME', 15.6, 1920, 1080, N'IPS', 60, 0, 39.3, 1.70, NULL, N'Nhựa', N'Xám', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 0, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-07-27T10:00:00'),
    (39, N'MSI-003', N'MSI Thin GF63 i5-13420H/8GB/512GB RTX 2050', N'msi-thin-gf63-i5-13420h-8gb-512gb-rtx-2050', 2, 6, N'Thin', N'Core i5-13420H, RAM 8GB, SSD 512GB, màn hình 15.6 inch 144Hz.', N'MSI Thin GF63 i5-13420H/8GB/512GB RTX 2050 thuộc dòng Thin, phù hợp nhóm Gaming. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 16990000, 0, 24, 3, 10, 8, N'DDR4', 3200, 2, 64, 512, N'SSD_NVME', 15.6, 1920, 1080, N'IPS', 144, 0, 52.4, 1.86, NULL, N'Nhựa', N'Đen', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 1, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-08-03T11:00:00'),
    (40, N'MSI-004', N'MSI Katana 15 i7-13620H/16GB/1TB RTX 4060', N'msi-katana-15-i7-13620h-16gb-1tb-rtx-4060', 2, 6, N'Katana', N'Core i7-13620H, RAM 16GB, SSD 1024GB, màn hình 15.6 inch 144Hz.', N'MSI Katana 15 i7-13620H/16GB/1TB RTX 4060 thuộc dòng Katana, phù hợp nhóm Gaming. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 28990000, 17, 24, 5, 13, 16, N'DDR5', 5200, 2, 64, 1024, N'SSD_NVME', 15.6, 1920, 1080, N'IPS', 144, 0, 53.5, 2.25, NULL, N'Nhựa', N'Đen', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'720p HD', 1, N'Windows 11 Home', 2023, N'DANG_BAN', '2026-08-10T12:00:00'),
    (41, N'MSI-005', N'MSI Creator M16 i7-13700H/16GB/1TB RTX 4050', N'msi-creator-m16-i7-13700h-16gb-1tb-rtx-4050', 3, 6, N'Creator', N'Core i7-13700H, RAM 16GB, SSD 1024GB, màn hình 16.0 inch 120Hz.', N'MSI Creator M16 i7-13700H/16GB/1TB RTX 4050 thuộc dòng Creator, phù hợp nhóm Đồ họa - Kỹ thuật. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 31990000, 0, 24, 7, 12, 16, N'DDR5', 5200, 2, 64, 1024, N'SSD_NVME', 16.0, 2560, 1600, N'IPS', 120, 0, 90.0, 2.26, NULL, N'Nhôm', N'Đen', N'USB-C (Thunderbolt), USB-A, HDMI, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'1080p FHD', 1, N'Windows 11 Home', 2023, N'NGUNG_BAN', '2026-08-17T13:00:00'),
    (42, N'APL-001', N'Apple MacBook Air 13 M3 8GB/256GB', N'apple-macbook-air-13-m3-8gb-256gb', 4, 7, N'MacBook Air', N'Apple M3 8-core, RAM 8GB, SSD 256GB, màn hình 13.6 inch 60Hz.', N'Apple MacBook Air 13 M3 8GB/256GB thuộc dòng MacBook Air, phù hợp nhóm Mỏng nhẹ - Cao cấp. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 26990000, 25, 12, 15, 7, 8, N'HOP_NHAT', NULL, 0, NULL, 256, N'SSD_NVME', 13.6, 2560, 1664, N'IPS', 60, 0, 52.6, 1.24, NULL, N'Nhôm', N'Xám không gian', N'2 x Thunderbolt / USB 4, MagSafe 3, jack 3.5mm', N'Wi-Fi 6E, Bluetooth 5.3', N'1080p FHD', 1, N'macOS', 2024, N'DANG_BAN', '2026-08-24T14:00:00'),
    (43, N'APL-002', N'Apple MacBook Air 13 M3 16GB/512GB', N'apple-macbook-air-13-m3-16gb-512gb', 4, 7, N'MacBook Air', N'Apple M3 8-core, RAM 16GB, SSD 512GB, màn hình 13.6 inch 60Hz.', N'Apple MacBook Air 13 M3 16GB/512GB thuộc dòng MacBook Air, phù hợp nhóm Mỏng nhẹ - Cao cấp. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 32990000, 9, 12, 15, 8, 16, N'HOP_NHAT', NULL, 0, NULL, 512, N'SSD_NVME', 13.6, 2560, 1664, N'IPS', 60, 0, 52.6, 1.24, NULL, N'Nhôm', N'Đêm xanh thẳm', N'2 x Thunderbolt / USB 4, MagSafe 3, jack 3.5mm', N'Wi-Fi 6E, Bluetooth 5.3', N'1080p FHD', 1, N'macOS', 2024, N'DANG_BAN', '2026-08-31T15:00:00'),
    (44, N'APL-003', N'Apple MacBook Air 15 M3 16GB/512GB', N'apple-macbook-air-15-m3-16gb-512gb', 4, 7, N'MacBook Air', N'Apple M3 8-core, RAM 16GB, SSD 512GB, màn hình 15.3 inch 60Hz.', N'Apple MacBook Air 15 M3 16GB/512GB thuộc dòng MacBook Air, phù hợp nhóm Mỏng nhẹ - Cao cấp. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 37990000, 4, 12, 15, 8, 16, N'HOP_NHAT', NULL, 0, NULL, 512, N'SSD_NVME', 15.3, 2880, 1864, N'IPS', 60, 0, 66.5, 1.51, NULL, N'Nhôm', N'Ánh sao', N'2 x Thunderbolt / USB 4, MagSafe 3, jack 3.5mm', N'Wi-Fi 6E, Bluetooth 5.3', N'1080p FHD', 1, N'macOS', 2024, N'DANG_BAN', '2026-09-07T16:00:00'),
    (45, N'APL-004', N'Apple MacBook Pro 14 M3 8GB/512GB', N'apple-macbook-pro-14-m3-8gb-512gb', 3, 7, N'MacBook Pro', N'Apple M3 8-core, RAM 8GB, SSD 512GB, màn hình 14.2 inch 120Hz.', N'Apple MacBook Pro 14 M3 8GB/512GB thuộc dòng MacBook Pro, phù hợp nhóm Đồ họa - Kỹ thuật. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 39990000, 24, 12, 15, 8, 8, N'HOP_NHAT', NULL, 0, NULL, 512, N'SSD_NVME', 14.2, 3024, 1964, N'MINI_LED', 120, 0, 70.0, 1.55, NULL, N'Nhôm', N'Xám không gian', N'2 x Thunderbolt / USB 4, MagSafe 3, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'1080p FHD', 1, N'macOS', 2023, N'DANG_BAN', '2026-09-14T17:00:00'),
    (46, N'APL-005', N'Apple MacBook Pro 14 M3 Pro 18GB/512GB', N'apple-macbook-pro-14-m3-pro-18gb-512gb', 3, 7, N'MacBook Pro', N'Apple M3 Pro 11-core, RAM 18GB, SSD 512GB, màn hình 14.2 inch 120Hz.', N'Apple MacBook Pro 14 M3 Pro 18GB/512GB thuộc dòng MacBook Pro, phù hợp nhóm Đồ họa - Kỹ thuật. Dữ liệu demo dùng cho đồ án, thông số và giá mang tính minh họa.', 49990000, 27, 12, 16, 9, 18, N'HOP_NHAT', NULL, 0, NULL, 512, N'SSD_NVME', 14.2, 3024, 1964, N'MINI_LED', 120, 0, 72.4, 1.61, NULL, N'Nhôm', N'Đen không gian', N'2 x Thunderbolt / USB 4, MagSafe 3, jack 3.5mm', N'Wi-Fi 6, Bluetooth 5.2', N'1080p FHD', 1, N'macOS', 2023, N'DANG_BAN', '2026-09-21T09:00:00');
SET IDENTITY_INSERT dbo.SanPham OFF;

-- HinhAnhSanPham (92 dòng)
SET IDENTITY_INSERT dbo.HinhAnhSanPham ON;
INSERT INTO dbo.HinhAnhSanPham (MaHinhAnh, MaSanPham, DuongDanAnh, LaAnhDaiDien, ThuTu, NgayTao) VALUES
    (1, 1, N'products/dell-inspiron-15-3530-i5-1335u-8gb-512gb-1.jpg', 1, 0, '2025-11-10T09:00:00'),
    (2, 1, N'products/dell-inspiron-15-3530-i5-1335u-8gb-512gb-2.jpg', 0, 1, '2025-11-10T09:00:00'),
    (3, 2, N'products/dell-inspiron-15-3530-i7-1355u-16gb-512gb-1.jpg', 1, 0, '2025-11-17T10:00:00'),
    (4, 2, N'products/dell-inspiron-15-3530-i7-1355u-16gb-512gb-2.jpg', 0, 1, '2025-11-17T10:00:00'),
    (5, 3, N'products/dell-vostro-14-3430-i3-1315u-8gb-256gb-1.jpg', 1, 0, '2025-11-24T11:00:00'),
    (6, 3, N'products/dell-vostro-14-3430-i3-1315u-8gb-256gb-2.jpg', 0, 1, '2025-11-24T11:00:00'),
    (7, 4, N'products/dell-latitude-14-7440-i7-1355u-16gb-512gb-1.jpg', 1, 0, '2025-12-01T12:00:00'),
    (8, 4, N'products/dell-latitude-14-7440-i7-1355u-16gb-512gb-2.jpg', 0, 1, '2025-12-01T12:00:00'),
    (9, 5, N'products/dell-xps-13-9340-ultra-7-155h-16gb-512gb-1.jpg', 1, 0, '2025-12-08T13:00:00'),
    (10, 5, N'products/dell-xps-13-9340-ultra-7-155h-16gb-512gb-2.jpg', 0, 1, '2025-12-08T13:00:00'),
    (11, 6, N'products/dell-g15-5530-i7-13650hx-16gb-512gb-rtx-4060-1.jpg', 1, 0, '2025-12-15T14:00:00'),
    (12, 6, N'products/dell-g15-5530-i7-13650hx-16gb-512gb-rtx-4060-2.jpg', 0, 1, '2025-12-15T14:00:00'),
    (13, 7, N'products/dell-precision-15-3581-i7-13700h-32gb-1tb-rtx-a1000-1.jpg', 1, 0, '2025-12-22T15:00:00'),
    (14, 7, N'products/dell-precision-15-3581-i7-13700h-32gb-1tb-rtx-a1000-2.jpg', 0, 1, '2025-12-22T15:00:00'),
    (15, 8, N'products/hp-15-i3-1315u-8gb-256gb-1.jpg', 1, 0, '2025-12-29T16:00:00'),
    (16, 8, N'products/hp-15-i3-1315u-8gb-256gb-2.jpg', 0, 1, '2025-12-29T16:00:00'),
    (17, 9, N'products/hp-15-i5-1335u-8gb-512gb-1.jpg', 1, 0, '2026-01-05T17:00:00'),
    (18, 9, N'products/hp-15-i5-1335u-8gb-512gb-2.jpg', 0, 1, '2026-01-05T17:00:00'),
    (19, 10, N'products/hp-pavilion-14-i5-1335u-16gb-512gb-1.jpg', 1, 0, '2026-01-12T09:00:00'),
    (20, 10, N'products/hp-pavilion-14-i5-1335u-16gb-512gb-2.jpg', 0, 1, '2026-01-12T09:00:00'),
    (21, 11, N'products/hp-envy-x360-14-ultra-5-125h-16gb-512gb-oled-1.jpg', 1, 0, '2026-01-19T10:00:00'),
    (22, 11, N'products/hp-envy-x360-14-ultra-5-125h-16gb-512gb-oled-2.jpg', 0, 1, '2026-01-19T10:00:00'),
    (23, 12, N'products/hp-victus-16-i5-13420h-16gb-512gb-rtx-3050-1.jpg', 1, 0, '2026-01-26T11:00:00'),
    (24, 12, N'products/hp-victus-16-i5-13420h-16gb-512gb-rtx-3050-2.jpg', 0, 1, '2026-01-26T11:00:00'),
    (25, 13, N'products/hp-omen-16-i7-13700h-16gb-1tb-rtx-4060-1.jpg', 1, 0, '2026-02-02T12:00:00'),
    (26, 13, N'products/hp-omen-16-i7-13700h-16gb-1tb-rtx-4060-2.jpg', 0, 1, '2026-02-02T12:00:00'),
    (27, 14, N'products/hp-elitebook-840-g10-i7-1355u-16gb-512gb-1.jpg', 1, 0, '2026-02-09T13:00:00'),
    (28, 14, N'products/hp-elitebook-840-g10-i7-1355u-16gb-512gb-2.jpg', 0, 1, '2026-02-09T13:00:00'),
    (29, 15, N'products/lenovo-ideapad-slim-3-15-i3-1315u-8gb-512gb-1.jpg', 1, 0, '2026-02-16T14:00:00'),
    (30, 15, N'products/lenovo-ideapad-slim-3-15-i3-1315u-8gb-512gb-2.jpg', 0, 1, '2026-02-16T14:00:00'),
    (31, 16, N'products/lenovo-ideapad-slim-3-15-ryzen-5-7530u-16gb-512gb-1.jpg', 1, 0, '2026-02-23T15:00:00'),
    (32, 16, N'products/lenovo-ideapad-slim-3-15-ryzen-5-7530u-16gb-512gb-2.jpg', 0, 1, '2026-02-23T15:00:00'),
    (33, 17, N'products/lenovo-ideapad-slim-5-14-ultra-5-125h-16gb-512gb-oled-1.jpg', 1, 0, '2026-03-02T16:00:00'),
    (34, 17, N'products/lenovo-ideapad-slim-5-14-ultra-5-125h-16gb-512gb-oled-2.jpg', 0, 1, '2026-03-02T16:00:00'),
    (35, 18, N'products/lenovo-thinkpad-e14-gen-5-i5-1335u-16gb-512gb-1.jpg', 1, 0, '2026-03-09T17:00:00'),
    (36, 18, N'products/lenovo-thinkpad-e14-gen-5-i5-1335u-16gb-512gb-2.jpg', 0, 1, '2026-03-09T17:00:00'),
    (37, 19, N'products/lenovo-thinkpad-x1-carbon-gen-11-i7-1355u-16gb-1tb-1.jpg', 1, 0, '2026-03-16T09:00:00'),
    (38, 19, N'products/lenovo-thinkpad-x1-carbon-gen-11-i7-1355u-16gb-1tb-2.jpg', 0, 1, '2026-03-16T09:00:00'),
    (39, 20, N'products/lenovo-loq-15-i5-13420h-16gb-512gb-rtx-3050-1.jpg', 1, 0, '2026-03-23T10:00:00'),
    (40, 20, N'products/lenovo-loq-15-i5-13420h-16gb-512gb-rtx-3050-2.jpg', 0, 1, '2026-03-23T10:00:00'),
    (41, 21, N'products/lenovo-legion-5-16-ryzen-7-7840hs-16gb-1tb-rtx-4060-1.jpg', 1, 0, '2026-03-30T11:00:00'),
    (42, 21, N'products/lenovo-legion-5-16-ryzen-7-7840hs-16gb-1tb-rtx-4060-2.jpg', 0, 1, '2026-03-30T11:00:00'),
    (43, 22, N'products/lenovo-yoga-slim-7-14-ultra-7-155h-32gb-1tb-oled-1.jpg', 1, 0, '2026-04-06T12:00:00'),
    (44, 22, N'products/lenovo-yoga-slim-7-14-ultra-7-155h-32gb-1tb-oled-2.jpg', 0, 1, '2026-04-06T12:00:00'),
    (45, 23, N'products/lenovo-legion-pro-7-16-i9-13900hx-32gb-1tb-rtx-4080-1.jpg', 1, 0, '2026-04-13T13:00:00'),
    (46, 23, N'products/lenovo-legion-pro-7-16-i9-13900hx-32gb-1tb-rtx-4080-2.jpg', 0, 1, '2026-04-13T13:00:00'),
    (47, 24, N'products/asus-vivobook-15-i3-1315u-8gb-512gb-1.jpg', 1, 0, '2026-04-20T14:00:00'),
    (48, 24, N'products/asus-vivobook-15-i3-1315u-8gb-512gb-2.jpg', 0, 1, '2026-04-20T14:00:00'),
    (49, 25, N'products/asus-vivobook-15-oled-i5-13420h-16gb-512gb-1.jpg', 1, 0, '2026-04-27T15:00:00'),
    (50, 25, N'products/asus-vivobook-15-oled-i5-13420h-16gb-512gb-2.jpg', 0, 1, '2026-04-27T15:00:00'),
    (51, 26, N'products/asus-zenbook-14-oled-ultra-7-155h-16gb-1tb-1.jpg', 1, 0, '2026-05-04T16:00:00'),
    (52, 26, N'products/asus-zenbook-14-oled-ultra-7-155h-16gb-1tb-2.jpg', 0, 1, '2026-05-04T16:00:00'),
    (53, 27, N'products/asus-tuf-gaming-f15-i7-13620h-16gb-512gb-rtx-4050-1.jpg', 1, 0, '2026-05-11T17:00:00'),
    (54, 27, N'products/asus-tuf-gaming-f15-i7-13620h-16gb-512gb-rtx-4050-2.jpg', 0, 1, '2026-05-11T17:00:00'),
    (55, 28, N'products/asus-tuf-gaming-a15-ryzen-7-7735hs-16gb-512gb-rtx-4050-1.jpg', 1, 0, '2026-05-18T09:00:00'),
    (56, 28, N'products/asus-tuf-gaming-a15-ryzen-7-7735hs-16gb-512gb-rtx-4050-2.jpg', 0, 1, '2026-05-18T09:00:00'),
    (57, 29, N'products/asus-rog-strix-g16-i7-13650hx-16gb-512gb-rtx-4060-1.jpg', 1, 0, '2026-05-25T10:00:00'),
    (58, 29, N'products/asus-rog-strix-g16-i7-13650hx-16gb-512gb-rtx-4060-2.jpg', 0, 1, '2026-05-25T10:00:00'),
    (59, 30, N'products/asus-rog-zephyrus-g14-ryzen-9-7940hs-16gb-1tb-rtx-4060-1.jpg', 1, 0, '2026-06-01T11:00:00'),
    (60, 30, N'products/asus-rog-zephyrus-g14-ryzen-9-7940hs-16gb-1tb-rtx-4060-2.jpg', 0, 1, '2026-06-01T11:00:00'),
    (61, 31, N'products/asus-vivobook-pro-15-oled-ryzen-7-7840hs-16gb-512gb-rtx-3050-1.jpg', 1, 0, '2026-06-08T12:00:00'),
    (62, 31, N'products/asus-vivobook-pro-15-oled-ryzen-7-7840hs-16gb-512gb-rtx-3050-2.jpg', 0, 1, '2026-06-08T12:00:00'),
    (63, 32, N'products/acer-aspire-3-i3-1315u-8gb-256gb-1.jpg', 1, 0, '2026-06-15T13:00:00'),
    (64, 32, N'products/acer-aspire-3-i3-1315u-8gb-256gb-2.jpg', 0, 1, '2026-06-15T13:00:00'),
    (65, 33, N'products/acer-aspire-5-i5-1335u-16gb-512gb-1.jpg', 1, 0, '2026-06-22T14:00:00'),
    (66, 33, N'products/acer-aspire-5-i5-1335u-16gb-512gb-2.jpg', 0, 1, '2026-06-22T14:00:00'),
    (67, 34, N'products/acer-swift-go-14-ultra-5-125h-16gb-512gb-oled-1.jpg', 1, 0, '2026-06-29T15:00:00'),
    (68, 34, N'products/acer-swift-go-14-ultra-5-125h-16gb-512gb-oled-2.jpg', 0, 1, '2026-06-29T15:00:00'),
    (69, 35, N'products/acer-nitro-v-15-i5-13420h-16gb-512gb-rtx-4050-1.jpg', 1, 0, '2026-07-06T16:00:00'),
    (70, 35, N'products/acer-nitro-v-15-i5-13420h-16gb-512gb-rtx-4050-2.jpg', 0, 1, '2026-07-06T16:00:00'),
    (71, 36, N'products/acer-predator-helios-neo-16-i7-13650hx-16gb-512gb-rtx-4060-1.jpg', 1, 0, '2026-07-13T17:00:00'),
    (72, 36, N'products/acer-predator-helios-neo-16-i7-13650hx-16gb-512gb-rtx-4060-2.jpg', 0, 1, '2026-07-13T17:00:00'),
    (73, 37, N'products/msi-modern-14-i3-1315u-8gb-512gb-1.jpg', 1, 0, '2026-07-20T09:00:00'),
    (74, 37, N'products/msi-modern-14-i3-1315u-8gb-512gb-2.jpg', 0, 1, '2026-07-20T09:00:00'),
    (75, 38, N'products/msi-modern-15-i5-1335u-16gb-512gb-1.jpg', 1, 0, '2026-07-27T10:00:00'),
    (76, 38, N'products/msi-modern-15-i5-1335u-16gb-512gb-2.jpg', 0, 1, '2026-07-27T10:00:00'),
    (77, 39, N'products/msi-thin-gf63-i5-13420h-8gb-512gb-rtx-2050-1.jpg', 1, 0, '2026-08-03T11:00:00'),
    (78, 39, N'products/msi-thin-gf63-i5-13420h-8gb-512gb-rtx-2050-2.jpg', 0, 1, '2026-08-03T11:00:00'),
    (79, 40, N'products/msi-katana-15-i7-13620h-16gb-1tb-rtx-4060-1.jpg', 1, 0, '2026-08-10T12:00:00'),
    (80, 40, N'products/msi-katana-15-i7-13620h-16gb-1tb-rtx-4060-2.jpg', 0, 1, '2026-08-10T12:00:00'),
    (81, 41, N'products/msi-creator-m16-i7-13700h-16gb-1tb-rtx-4050-1.jpg', 1, 0, '2026-08-17T13:00:00'),
    (82, 41, N'products/msi-creator-m16-i7-13700h-16gb-1tb-rtx-4050-2.jpg', 0, 1, '2026-08-17T13:00:00'),
    (83, 42, N'products/apple-macbook-air-13-m3-8gb-256gb-1.jpg', 1, 0, '2026-08-24T14:00:00'),
    (84, 42, N'products/apple-macbook-air-13-m3-8gb-256gb-2.jpg', 0, 1, '2026-08-24T14:00:00'),
    (85, 43, N'products/apple-macbook-air-13-m3-16gb-512gb-1.jpg', 1, 0, '2026-08-31T15:00:00'),
    (86, 43, N'products/apple-macbook-air-13-m3-16gb-512gb-2.jpg', 0, 1, '2026-08-31T15:00:00'),
    (87, 44, N'products/apple-macbook-air-15-m3-16gb-512gb-1.jpg', 1, 0, '2026-09-07T16:00:00'),
    (88, 44, N'products/apple-macbook-air-15-m3-16gb-512gb-2.jpg', 0, 1, '2026-09-07T16:00:00'),
    (89, 45, N'products/apple-macbook-pro-14-m3-8gb-512gb-1.jpg', 1, 0, '2026-09-14T17:00:00'),
    (90, 45, N'products/apple-macbook-pro-14-m3-8gb-512gb-2.jpg', 0, 1, '2026-09-14T17:00:00'),
    (91, 46, N'products/apple-macbook-pro-14-m3-pro-18gb-512gb-1.jpg', 1, 0, '2026-09-21T09:00:00'),
    (92, 46, N'products/apple-macbook-pro-14-m3-pro-18gb-512gb-2.jpg', 0, 1, '2026-09-21T09:00:00');
SET IDENTITY_INSERT dbo.HinhAnhSanPham OFF;

-- KhuyenMai (6 dòng)
SET IDENTITY_INSERT dbo.KhuyenMai ON;
INSERT INTO dbo.KhuyenMai (MaKhuyenMai, TenKhuyenMai, MoTa, LoaiGiam, GiaTriGiam, NgayBatDau, NgayKetThuc, DangHoatDong, NgayTao) VALUES
    (1, N'Mừng năm mới 2026', N'Giảm 5% một số mẫu laptop văn phòng dịp năm mới.', N'PHAN_TRAM', 5, '2025-12-25T00:00:00', '2026-01-05T23:59:59', 1, '2025-12-18T00:00:00'),
    (2, N'Back to School 2026', N'Giảm ngay 1.000.000đ cho laptop học tập.', N'SO_TIEN', 1000000, '2026-08-01T00:00:00', '2026-09-30T23:59:59', 1, '2026-07-25T00:00:00'),
    (3, N'Black Friday 2026', N'Giảm 10% cho nhiều mẫu laptop trong tháng 11.', N'PHAN_TRAM', 10, '2026-11-01T00:00:00', '2026-11-30T23:59:59', 1, '2026-10-25T00:00:00'),
    (4, N'Tuần lễ Gaming', N'Giảm ngay 3.000.000đ cho laptop gaming.', N'SO_TIEN', 3000000, '2026-11-10T00:00:00', '2026-11-20T23:59:59', 1, '2026-11-03T00:00:00'),
    (5, N'Chào Tết 2027', N'Ưu đãi 7% dịp Tết Nguyên đán (sắp diễn ra).', N'PHAN_TRAM', 7, '2027-01-15T00:00:00', '2027-02-15T23:59:59', 1, '2027-01-08T00:00:00'),
    (6, N'Flash Sale MacBook', N'Đã ngừng sớm do hết ngân sách (test DangHoatDong = 0).', N'PHAN_TRAM', 5, '2026-11-01T00:00:00', '2026-11-30T23:59:59', 0, '2026-10-25T00:00:00');
SET IDENTITY_INSERT dbo.KhuyenMai OFF;

-- SanPhamKhuyenMai (47 dòng)
INSERT INTO dbo.SanPhamKhuyenMai (MaSanPham, MaKhuyenMai) VALUES
    (1, 1),
    (1, 2),
    (2, 2),
    (2, 3),
    (5, 5),
    (6, 3),
    (6, 4),
    (8, 2),
    (9, 1),
    (9, 2),
    (10, 2),
    (11, 3),
    (12, 4),
    (13, 3),
    (15, 2),
    (16, 1),
    (16, 2),
    (17, 3),
    (19, 5),
    (20, 4),
    (21, 3),
    (21, 4),
    (22, 5),
    (24, 1),
    (24, 2),
    (25, 2),
    (26, 3),
    (26, 5),
    (27, 4),
    (28, 4),
    (29, 3),
    (29, 4),
    (32, 2),
    (33, 1),
    (33, 2),
    (35, 4),
    (36, 3),
    (36, 4),
    (37, 2),
    (38, 2),
    (40, 3),
    (40, 4),
    (42, 5),
    (42, 6),
    (43, 3),
    (43, 6),
    (44, 6);

-- GioHang (5 dòng)
SET IDENTITY_INSERT dbo.GioHang ON;
INSERT INTO dbo.GioHang (MaGioHang, MaNguoiDung, MaSanPham, SoLuong, NgayThem) VALUES
    (1, 2, 29, 1, '2026-11-11T21:00:00'),
    (2, 2, 16, 2, '2026-11-10T21:00:00'),
    (3, 3, 42, 1, '2026-11-09T21:00:00'),
    (4, 4, 30, 1, '2026-11-08T21:00:00'),
    (5, 5, 6, 5, '2026-11-07T21:00:00');
SET IDENTITY_INSERT dbo.GioHang OFF;

-- DonHang (44 dòng)
SET IDENTITY_INSERT dbo.DonHang ON;
INSERT INTO dbo.DonHang (MaDonHang, MaNguoiDung, TenNguoiNhan, SdtNguoiNhan, DiaChiGiaoHang, GhiChu, PhuongThucThanhToan, TrangThaiThanhToan, TrangThai, TongTien, NgayTao, NgayThanhToan, NgayXacNhan, NgayBanGiao, NgayGiaoThanhCong, NgayHuy) VALUES
    (1, 2, N'Nguyễn Văn An', N'0912345600', N'100 Lê Lợi, Quận 1, TP.HCM', N'Giao giờ hành chính, gọi trước khi giao.', N'CHUYEN_KHOAN', N'DA_THANH_TOAN', N'DA_GIAO', 15990000, '2025-12-03T08:53:00', '2025-12-03T10:23:00', '2025-12-03T18:23:00', '2025-12-04T15:23:00', '2025-12-06T09:23:00', NULL),
    (2, 13, N'Lý Bảo Ngọc', N'0912345677', N'43 Đường số 12, Quận Phú Nhuận, TP.HCM', NULL, N'THANH_TOAN_KHI_NHAN', N'DA_THANH_TOAN', N'DA_GIAO', 122970000, '2025-12-09T13:58:00', '2025-12-12T05:58:00', '2025-12-09T17:58:00', '2025-12-10T11:58:00', '2025-12-12T05:58:00', NULL),
    (3, 4, N'Lê Hoàng Cường', N'0912345614', N'16 Đường số 3, Quận 7, TP.HCM', NULL, N'THANH_TOAN_KHI_NHAN', N'DA_THANH_TOAN', N'DA_GIAO', 89980000, '2025-12-14T15:04:00', '2025-12-17T12:04:00', '2025-12-14T20:04:00', '2025-12-15T20:04:00', '2025-12-17T12:04:00', NULL),
    (4, 5, N'Phạm Ngọc Dung', N'0912345621', N'19 Đường số 4, TP. Thủ Đức, TP.HCM', NULL, N'CHUYEN_KHOAN', N'DA_THANH_TOAN', N'DA_GIAO', 13490000, '2026-01-06T10:06:00', '2026-01-06T11:36:00', '2026-01-06T20:36:00', '2026-01-07T16:36:00', '2026-01-09T11:36:00', NULL),
    (5, 6, N'Hoàng Minh Đức', N'0912345628', N'104 Võ Văn Tần, Quận Bình Thạnh, TP.HCM', NULL, N'THANH_TOAN_KHI_NHAN', N'DA_THANH_TOAN', N'DA_GIAO', 15990000, '2026-01-08T14:03:00', '2026-01-11T12:03:00', '2026-01-08T17:03:00', '2026-01-09T16:03:00', '2026-01-11T12:03:00', NULL),
    (6, 7, N'Vũ Thu Hà', N'0912345635', N'25 Đường số 6, Quận Tân Bình, TP.HCM', N'Giao giờ hành chính, gọi trước khi giao.', N'CHUYEN_KHOAN', N'DA_HOAN_TIEN', N'DA_HUY', 17490000, '2026-01-18T09:38:00', '2026-01-18T11:38:00', NULL, NULL, NULL, '2026-01-18T14:38:00'),
    (7, 8, N'Đặng Quốc Huy', N'0912345642', N'28 Đường số 7, Quận Gò Vấp, TP.HCM', NULL, N'CHUYEN_KHOAN', N'DA_THANH_TOAN', N'DA_GIAO', 13490000, '2026-02-04T08:19:00', '2026-02-04T09:49:00', '2026-02-04T17:49:00', '2026-02-05T15:49:00', '2026-02-07T12:49:00', NULL),
    (8, 9, N'Bùi Thanh Lan', N'0912345649', N'31 Đường số 8, TP. Biên Hòa, Đồng Nai', NULL, N'THANH_TOAN_KHI_NHAN', N'DA_THANH_TOAN', N'DA_GIAO', 22990000, '2026-02-11T08:41:00', '2026-02-14T05:41:00', '2026-02-11T16:41:00', '2026-02-12T13:41:00', '2026-02-14T05:41:00', NULL),
    (9, 10, N'Đỗ Văn Long', N'0912345656', N'108 Nguyễn Trãi, TP. Thủ Dầu Một, Bình Dương', NULL, N'THANH_TOAN_KHI_NHAN', N'DA_THANH_TOAN', N'DA_GIAO', 22990000, '2026-03-04T16:44:00', '2026-03-07T09:44:00', '2026-03-04T23:44:00', '2026-03-05T17:44:00', '2026-03-07T09:44:00', NULL),
    (10, 11, N'Ngô Thị Mai', N'0912345663', N'37 Đường số 10, Quận 10, TP.HCM', NULL, N'CHUYEN_KHOAN', N'DA_THANH_TOAN', N'DA_GIAO', 30980000, '2026-03-11T12:51:00', '2026-03-11T14:21:00', '2026-03-11T18:21:00', '2026-03-12T16:21:00', '2026-03-14T09:21:00', NULL),
    (11, 12, N'Dương Tuấn Nam', N'0912345670', N'40 Đường số 11, Quận 5, TP.HCM', N'Giao giờ hành chính, gọi trước khi giao.', N'THANH_TOAN_KHI_NHAN', N'DA_THANH_TOAN', N'DA_GIAO', 46480000, '2026-03-14T15:54:00', '2026-03-17T12:54:00', '2026-03-14T21:54:00', '2026-03-15T15:54:00', '2026-03-17T12:54:00', NULL),
    (12, 2, N'Nguyễn Văn An', N'0912345600', N'10 Đường số 1, Quận 1, TP.HCM', NULL, N'THANH_TOAN_KHI_NHAN', N'DA_THANH_TOAN', N'DA_GIAO', 22990000, '2026-04-05T13:43:00', '2026-04-08T12:43:00', '2026-04-05T19:43:00', '2026-04-06T17:43:00', '2026-04-08T12:43:00', NULL),
    (13, 3, N'Trần Thị Bình', N'0912345607', N'112 Phan Xích Long, Quận 3, TP.HCM', NULL, N'CHUYEN_KHOAN', N'DA_THANH_TOAN', N'DA_GIAO', 33480000, '2026-04-10T10:51:00', '2026-04-10T12:21:00', '2026-04-10T15:21:00', '2026-04-11T13:21:00', '2026-04-13T05:21:00', NULL),
    (14, 4, N'Lê Hoàng Cường', N'0912345614', N'16 Đường số 3, Quận 7, TP.HCM', NULL, N'THANH_TOAN_KHI_NHAN', N'DA_THANH_TOAN', N'DA_GIAO', 12990000, '2026-05-03T21:56:00', '2026-05-06T18:56:00', '2026-05-04T00:56:00', '2026-05-04T23:56:00', '2026-05-06T18:56:00', NULL),
    (15, 5, N'Phạm Ngọc Dung', N'0912345621', N'19 Đường số 4, TP. Thủ Đức, TP.HCM', NULL, N'THANH_TOAN_KHI_NHAN', N'DA_THANH_TOAN', N'DA_GIAO', 43470000, '2026-05-08T13:30:00', '2026-05-11T16:30:00', '2026-05-08T20:30:00', '2026-05-09T20:30:00', '2026-05-11T16:30:00', NULL),
    (16, 6, N'Hoàng Minh Đức', N'0912345628', N'22 Đường số 5, Quận Bình Thạnh, TP.HCM', N'Giao giờ hành chính, gọi trước khi giao.', N'CHUYEN_KHOAN', N'DA_THANH_TOAN', N'DA_GIAO', 12990000, '2026-05-17T12:50:00', '2026-05-17T14:20:00', '2026-05-17T19:20:00', '2026-05-18T14:20:00', '2026-05-20T12:20:00', NULL),
    (17, 7, N'Vũ Thu Hà', N'0912345635', N'116 Lý Thường Kiệt, Quận Tân Bình, TP.HCM', NULL, N'THANH_TOAN_KHI_NHAN', N'DA_THANH_TOAN', N'DA_GIAO', 15990000, '2026-06-05T13:33:00', '2026-06-08T12:33:00', '2026-06-05T20:33:00', '2026-06-06T16:33:00', '2026-06-08T12:33:00', NULL),
    (18, 8, N'Đặng Quốc Huy', N'0912345642', N'28 Đường số 7, Quận Gò Vấp, TP.HCM', NULL, N'THANH_TOAN_KHI_NHAN', N'CHUA_THANH_TOAN', N'DA_HUY', 35980000, '2026-06-08T16:28:00', NULL, '2026-06-08T20:28:00', NULL, NULL, '2026-06-09T16:28:00'),
    (19, 9, N'Bùi Thanh Lan', N'0912345649', N'31 Đường số 8, TP. Biên Hòa, Đồng Nai', NULL, N'CHUYEN_KHOAN', N'DA_THANH_TOAN', N'DA_GIAO', 28980000, '2026-07-05T13:34:00', '2026-07-05T15:04:00', '2026-07-05T19:04:00', '2026-07-06T19:04:00', '2026-07-08T13:04:00', NULL),
    (20, 10, N'Đỗ Văn Long', N'0912345656', N'34 Đường số 9, TP. Thủ Dầu Một, Bình Dương', NULL, N'THANH_TOAN_KHI_NHAN', N'DA_THANH_TOAN', N'DA_GIAO', 37990000, '2026-07-11T09:18:00', '2026-07-14T05:18:00', '2026-07-11T14:18:00', '2026-07-12T08:18:00', '2026-07-14T05:18:00', NULL),
    (21, 11, N'Ngô Thị Mai', N'0912345663', N'120 Lý Thường Kiệt, Quận 10, TP.HCM', N'Giao giờ hành chính, gọi trước khi giao.', N'THANH_TOAN_KHI_NHAN', N'DA_THANH_TOAN', N'DA_GIAO', 26990000, '2026-07-16T08:00:00', '2026-07-19T11:00:00', '2026-07-16T17:00:00', '2026-07-17T13:00:00', '2026-07-19T11:00:00', NULL),
    (22, 12, N'Dương Tuấn Nam', N'0912345670', N'40 Đường số 11, Quận 5, TP.HCM', NULL, N'CHUYEN_KHOAN', N'DA_THANH_TOAN', N'DA_GIAO', 16990000, '2026-08-03T19:10:00', '2026-08-03T20:40:00', '2026-08-03T23:40:00', '2026-08-04T18:40:00', '2026-08-06T10:40:00', NULL),
    (23, 2, N'Nguyễn Văn An', N'0912345600', N'10 Đường số 1, Quận 1, TP.HCM', NULL, N'THANH_TOAN_KHI_NHAN', N'DA_THANH_TOAN', N'DA_GIAO', 103470000, '2026-08-09T09:30:00', '2026-08-12T12:30:00', '2026-08-09T17:30:00', '2026-08-10T15:30:00', '2026-08-12T12:30:00', NULL),
    (24, 3, N'Trần Thị Bình', N'0912345607', N'13 Đường số 2, Quận 3, TP.HCM', NULL, N'THANH_TOAN_KHI_NHAN', N'DA_THANH_TOAN', N'DA_GIAO', 48980000, '2026-08-16T10:32:00', '2026-08-19T12:32:00', '2026-08-16T18:32:00', '2026-08-17T16:32:00', '2026-08-19T12:32:00', NULL),
    (25, 4, N'Lê Hoàng Cường', N'0912345614', N'124 Lý Thường Kiệt, Quận 7, TP.HCM', NULL, N'CHUYEN_KHOAN', N'DA_THANH_TOAN', N'DA_GIAO', 16490000, '2026-08-21T14:20:00', '2026-08-21T15:50:00', '2026-08-21T22:50:00', '2026-08-22T17:50:00', '2026-08-24T11:50:00', NULL),
    (26, 5, N'Phạm Ngọc Dung', N'0912345621', N'19 Đường số 4, TP. Thủ Đức, TP.HCM', N'Giao giờ hành chính, gọi trước khi giao.', N'THANH_TOAN_KHI_NHAN', N'DA_THANH_TOAN', N'DA_GIAO', 40980000, '2026-09-03T11:26:00', '2026-09-06T07:26:00', '2026-09-03T18:26:00', '2026-09-04T15:26:00', '2026-09-06T07:26:00', NULL),
    (27, 6, N'Hoàng Minh Đức', N'0912345628', N'22 Đường số 5, Quận Bình Thạnh, TP.HCM', NULL, N'THANH_TOAN_KHI_NHAN', N'DA_THANH_TOAN', N'DA_GIAO', 39480000, '2026-09-10T09:55:00', '2026-09-13T06:55:00', '2026-09-10T16:55:00', '2026-09-11T10:55:00', '2026-09-13T06:55:00', NULL),
    (28, 7, N'Vũ Thu Hà', N'0912345635', N'25 Đường số 6, Quận Tân Bình, TP.HCM', NULL, N'CHUYEN_KHOAN', N'DA_THANH_TOAN', N'DA_GIAO', 71470000, '2026-09-18T20:55:00', '2026-09-18T22:25:00', '2026-09-19T01:25:00', '2026-09-19T23:25:00', '2026-09-21T19:25:00', NULL),
    (29, 8, N'Đặng Quốc Huy', N'0912345642', N'128 Phan Xích Long, Quận Gò Vấp, TP.HCM', NULL, N'THANH_TOAN_KHI_NHAN', N'DA_THANH_TOAN', N'DA_GIAO', 16990000, '2026-09-20T16:10:00', '2026-09-23T17:10:00', '2026-09-21T00:10:00', '2026-09-21T20:10:00', '2026-09-23T17:10:00', NULL),
    (30, 9, N'Bùi Thanh Lan', N'0912345649', N'31 Đường số 8, TP. Biên Hòa, Đồng Nai', NULL, N'THANH_TOAN_KHI_NHAN', N'DA_THANH_TOAN', N'DA_GIAO', 55480000, '2026-10-06T11:45:00', '2026-10-09T05:45:00', '2026-10-06T16:45:00', '2026-10-07T12:45:00', '2026-10-09T05:45:00', NULL),
    (31, 10, N'Đỗ Văn Long', N'0912345656', N'34 Đường số 9, TP. Thủ Dầu Một, Bình Dương', N'Giao giờ hành chính, gọi trước khi giao.', N'CHUYEN_KHOAN', N'DA_THANH_TOAN', N'DA_GIAO', 10990000, '2026-10-12T14:52:00', '2026-10-12T16:22:00', '2026-10-12T19:22:00', '2026-10-13T13:22:00', '2026-10-15T07:22:00', NULL),
    (32, 11, N'Ngô Thị Mai', N'0912345663', N'37 Đường số 10, Quận 10, TP.HCM', NULL, N'THANH_TOAN_KHI_NHAN', N'DA_THANH_TOAN', N'DA_GIAO', 34990000, '2026-10-18T19:04:00', '2026-10-21T20:04:00', '2026-10-19T01:04:00', '2026-10-19T23:04:00', '2026-10-21T20:04:00', NULL),
    (33, 12, N'Dương Tuấn Nam', N'0912345670', N'132 Võ Văn Tần, Quận 5, TP.HCM', NULL, N'THANH_TOAN_KHI_NHAN', N'DA_THANH_TOAN', N'DA_GIAO', 75970000, '2026-10-21T21:01:00', '2026-10-24T17:01:00', '2026-10-22T05:01:00', '2026-10-23T01:01:00', '2026-10-24T17:01:00', NULL),
    (34, 2, N'Nguyễn Văn An', N'0912345600', N'10 Đường số 1, Quận 1, TP.HCM', NULL, N'CHUYEN_KHOAN', N'DA_THANH_TOAN', N'DA_GIAO', 33291000, '2026-11-01T20:45:00', '2026-11-01T22:15:00', '2026-11-02T06:15:00', '2026-11-03T04:15:00', '2026-11-05T01:15:00', NULL),
    (35, 3, N'Trần Thị Bình', N'0912345607', N'13 Đường số 2, Quận 3, TP.HCM', NULL, N'THANH_TOAN_KHI_NHAN', N'DA_THANH_TOAN', N'DA_GIAO', 37990000, '2026-11-02T17:35:00', '2026-11-05T16:35:00', '2026-11-02T22:35:00', '2026-11-03T22:35:00', '2026-11-05T16:35:00', NULL),
    (36, 4, N'Lê Hoàng Cường', N'0912345614', N'16 Đường số 3, Quận 7, TP.HCM', N'Giao giờ hành chính, gọi trước khi giao.', N'THANH_TOAN_KHI_NHAN', N'DA_THANH_TOAN', N'DA_GIAO', 26091000, '2026-11-03T18:38:00', '2026-11-06T16:38:00', '2026-11-03T23:38:00', '2026-11-04T19:38:00', '2026-11-06T16:38:00', NULL),
    (37, 5, N'Phạm Ngọc Dung', N'0912345621', N'136 Điện Biên Phủ, TP. Thủ Đức, TP.HCM', NULL, N'CHUYEN_KHOAN', N'DA_THANH_TOAN', N'DANG_GIAO', 46980000, '2026-11-04T08:53:00', '2026-11-04T10:23:00', '2026-11-04T17:23:00', '2026-11-05T15:23:00', NULL, NULL),
    (38, 6, N'Hoàng Minh Đức', N'0912345628', N'22 Đường số 5, Quận Bình Thạnh, TP.HCM', NULL, N'THANH_TOAN_KHI_NHAN', N'CHUA_THANH_TOAN', N'DANG_GIAO', 31990000, '2026-11-05T20:11:00', NULL, '2026-11-05T23:11:00', '2026-11-06T18:11:00', NULL, NULL),
    (39, 7, N'Vũ Thu Hà', N'0912345635', N'25 Đường số 6, Quận Tân Bình, TP.HCM', NULL, N'THANH_TOAN_KHI_NHAN', N'CHUA_THANH_TOAN', N'DA_XAC_NHAN', 22990000, '2026-11-06T14:54:00', NULL, '2026-11-06T18:54:00', NULL, NULL, NULL),
    (40, 8, N'Đặng Quốc Huy', N'0912345642', N'28 Đường số 7, Quận Gò Vấp, TP.HCM', NULL, N'CHUYEN_KHOAN', N'DA_THANH_TOAN', N'DA_XAC_NHAN', 45480000, '2026-11-07T17:42:00', '2026-11-07T19:12:00', '2026-11-08T01:12:00', NULL, NULL, NULL),
    (41, 9, N'Bùi Thanh Lan', N'0912345649', N'140 Điện Biên Phủ, TP. Biên Hòa, Đồng Nai', N'Giao giờ hành chính, gọi trước khi giao.', N'THANH_TOAN_KHI_NHAN', N'CHUA_THANH_TOAN', N'CHO_XAC_NHAN', 20490000, '2026-11-08T10:48:00', NULL, NULL, NULL, NULL, NULL),
    (42, 10, N'Đỗ Văn Long', N'0912345656', N'34 Đường số 9, TP. Thủ Dầu Một, Bình Dương', NULL, N'THANH_TOAN_KHI_NHAN', N'CHUA_THANH_TOAN', N'CHO_XAC_NHAN', 39981000, '2026-11-09T16:13:00', NULL, NULL, NULL, NULL, NULL),
    (43, 11, N'Ngô Thị Mai', N'0912345663', N'37 Đường số 10, Quận 10, TP.HCM', NULL, N'CHUYEN_KHOAN', N'DA_THANH_TOAN', N'CHO_XAC_NHAN', 10990000, '2026-11-10T15:19:00', '2026-11-10T16:49:00', NULL, NULL, NULL, NULL),
    (44, 12, N'Dương Tuấn Nam', N'0912345670', N'40 Đường số 11, Quận 5, TP.HCM', NULL, N'THANH_TOAN_KHI_NHAN', N'CHUA_THANH_TOAN', N'DA_HUY', 52182000, '2026-11-11T18:57:00', NULL, '2026-11-11T22:57:00', NULL, NULL, '2026-11-12T18:57:00');
SET IDENTITY_INSERT dbo.DonHang OFF;

-- ChiTietDonHang (58 dòng)
INSERT INTO dbo.ChiTietDonHang (MaDonHang, MaSanPham, TenSanPham, MaSku, DonGiaGoc, DonGiaBan, MaKhuyenMai, SoLuong) VALUES
    (1, 1, N'Dell Inspiron 15 3530 i5-1335U/8GB/512GB', N'DEL-001', 15990000, 15990000, NULL, 1),
    (2, 4, N'Dell Latitude 14 7440 i7-1355U/16GB/512GB', N'DEL-004', 32990000, 32990000, NULL, 1),
    (2, 5, N'Dell XPS 13 9340 Ultra 7 155H/16GB/512GB', N'DEL-005', 44990000, 44990000, NULL, 2),
    (3, 5, N'Dell XPS 13 9340 Ultra 7 155H/16GB/512GB', N'DEL-005', 44990000, 44990000, NULL, 2),
    (4, 9, N'HP 15 i5-1335U/8GB/512GB', N'HPX-002', 13490000, 13490000, NULL, 1),
    (5, 1, N'Dell Inspiron 15 3530 i5-1335U/8GB/512GB', N'DEL-001', 15990000, 15990000, NULL, 1),
    (6, 10, N'HP Pavilion 14 i5-1335U/16GB/512GB', N'HPX-003', 17490000, 17490000, NULL, 1),
    (7, 9, N'HP 15 i5-1335U/8GB/512GB', N'HPX-002', 13490000, 13490000, NULL, 1),
    (8, 12, N'HP Victus 16 i5-13420H/16GB/512GB RTX 3050', N'HPX-005', 22990000, 22990000, NULL, 1),
    (9, 12, N'HP Victus 16 i5-13420H/16GB/512GB RTX 3050', N'HPX-005', 22990000, 22990000, NULL, 1),
    (10, 9, N'HP 15 i5-1335U/8GB/512GB', N'HPX-002', 13490000, 13490000, NULL, 1),
    (10, 10, N'HP Pavilion 14 i5-1335U/16GB/512GB', N'HPX-003', 17490000, 17490000, NULL, 1),
    (11, 15, N'Lenovo IdeaPad Slim 3 15 i3-1315U/8GB/512GB', N'LEN-001', 10490000, 10490000, NULL, 1),
    (11, 6, N'Dell G15 5530 i7-13650HX/16GB/512GB RTX 4060', N'DEL-006', 35990000, 35990000, NULL, 1),
    (12, 12, N'HP Victus 16 i5-13420H/16GB/512GB RTX 3050', N'HPX-005', 22990000, 22990000, NULL, 1),
    (13, 9, N'HP 15 i5-1335U/8GB/512GB', N'HPX-002', 13490000, 13490000, NULL, 1),
    (13, 2, N'Dell Inspiron 15 3530 i7-1355U/16GB/512GB', N'DEL-002', 19990000, 19990000, NULL, 1),
    (14, 16, N'Lenovo IdeaPad Slim 3 15 Ryzen 5 7530U/16GB/512GB', N'LEN-002', 12990000, 12990000, NULL, 1),
    (15, 3, N'Dell Vostro 14 3430 i3-1315U/8GB/256GB', N'DEL-003', 11490000, 11490000, NULL, 1),
    (15, 25, N'ASUS Vivobook 15 OLED i5-13420H/16GB/512GB', N'ASU-002', 15990000, 15990000, NULL, 2),
    (16, 16, N'Lenovo IdeaPad Slim 3 15 Ryzen 5 7530U/16GB/512GB', N'LEN-002', 12990000, 12990000, NULL, 1),
    (17, 1, N'Dell Inspiron 15 3530 i5-1335U/8GB/512GB', N'DEL-001', 15990000, 15990000, NULL, 1),
    (18, 16, N'Lenovo IdeaPad Slim 3 15 Ryzen 5 7530U/16GB/512GB', N'LEN-002', 12990000, 12990000, NULL, 1),
    (18, 12, N'HP Victus 16 i5-13420H/16GB/512GB RTX 3050', N'HPX-005', 22990000, 22990000, NULL, 1),
    (19, 33, N'Acer Aspire 5 i5-1335U/16GB/512GB', N'ACE-002', 14490000, 14490000, NULL, 2),
    (20, 13, N'HP Omen 16 i7-13700H/16GB/1TB RTX 4060', N'HPX-006', 37990000, 37990000, NULL, 1),
    (21, 11, N'HP Envy x360 14 Ultra 5 125H/16GB/512GB OLED', N'HPX-004', 26990000, 26990000, NULL, 1),
    (22, 39, N'MSI Thin GF63 i5-13420H/8GB/512GB RTX 2050', N'MSI-003', 16990000, 16990000, NULL, 1),
    (23, 33, N'Acer Aspire 5 i5-1335U/16GB/512GB', N'ACE-002', 14490000, 13490000, 2, 1),
    (23, 5, N'Dell XPS 13 9340 Ultra 7 155H/16GB/512GB', N'DEL-005', 44990000, 44990000, NULL, 2),
    (24, 39, N'MSI Thin GF63 i5-13420H/8GB/512GB RTX 2050', N'MSI-003', 16990000, 16990000, NULL, 1),
    (24, 14, N'HP EliteBook 840 G10 i7-1355U/16GB/512GB', N'HPX-007', 31990000, 31990000, NULL, 1),
    (25, 10, N'HP Pavilion 14 i5-1335U/16GB/512GB', N'HPX-003', 17490000, 16490000, 2, 1),
    (26, 18, N'Lenovo ThinkPad E14 Gen 5 i5-1335U/16GB/512GB', N'LEN-004', 20490000, 20490000, NULL, 2),
    (27, 42, N'Apple MacBook Air 13 M3 8GB/256GB', N'APL-001', 26990000, 26990000, NULL, 1),
    (27, 9, N'HP 15 i5-1335U/8GB/512GB', N'HPX-002', 13490000, 12490000, 2, 1),
    (28, 35, N'Acer Nitro V 15 i5-13420H/16GB/512GB RTX 4050', N'ACE-004', 21490000, 21490000, NULL, 1),
    (28, 27, N'ASUS TUF Gaming F15 i7-13620H/16GB/512GB RTX 4050', N'ASU-004', 24990000, 24990000, NULL, 2),
    (29, 39, N'MSI Thin GF63 i5-13420H/8GB/512GB RTX 2050', N'MSI-003', 16990000, 16990000, NULL, 1),
    (30, 14, N'HP EliteBook 840 G10 i7-1355U/16GB/512GB', N'HPX-007', 31990000, 31990000, NULL, 1),
    (30, 28, N'ASUS TUF Gaming A15 Ryzen 7 7735HS/16GB/512GB RTX 4050', N'ASU-005', 23490000, 23490000, NULL, 1),
    (31, 37, N'MSI Modern 14 i3-1315U/8GB/512GB', N'MSI-001', 10990000, 10990000, NULL, 1),
    (32, 36, N'Acer Predator Helios Neo 16 i7-13650HX/16GB/512GB RTX 4060', N'ACE-005', 34990000, 34990000, NULL, 1),
    (33, 20, N'Lenovo LOQ 15 i5-13420H/16GB/512GB RTX 3050', N'LEN-006', 21990000, 21990000, NULL, 1),
    (33, 42, N'Apple MacBook Air 13 M3 8GB/256GB', N'APL-001', 26990000, 26990000, NULL, 2),
    (34, 29, N'ASUS ROG Strix G16 i7-13650HX/16GB/512GB RTX 4060', N'ASU-006', 36990000, 33291000, 3, 1),
    (35, 44, N'Apple MacBook Air 15 M3 16GB/512GB', N'APL-003', 37990000, 37990000, NULL, 1),
    (36, 26, N'ASUS Zenbook 14 OLED Ultra 7 155H/16GB/1TB', N'ASU-003', 28990000, 26091000, 3, 1),
    (37, 28, N'ASUS TUF Gaming A15 Ryzen 7 7735HS/16GB/512GB RTX 4050', N'ASU-005', 23490000, 23490000, NULL, 2),
    (38, 14, N'HP EliteBook 840 G10 i7-1355U/16GB/512GB', N'HPX-007', 31990000, 31990000, NULL, 1),
    (39, 12, N'HP Victus 16 i5-13420H/16GB/512GB RTX 3050', N'HPX-005', 22990000, 22990000, NULL, 1),
    (40, 34, N'Acer Swift Go 14 Ultra 5 125H/16GB/512GB OLED', N'ACE-003', 21990000, 21990000, NULL, 1),
    (40, 28, N'ASUS TUF Gaming A15 Ryzen 7 7735HS/16GB/512GB RTX 4050', N'ASU-005', 23490000, 23490000, NULL, 1),
    (41, 18, N'Lenovo ThinkPad E14 Gen 5 i5-1335U/16GB/512GB', N'LEN-004', 20490000, 20490000, NULL, 1),
    (42, 2, N'Dell Inspiron 15 3530 i7-1355U/16GB/512GB', N'DEL-002', 19990000, 17991000, 3, 1),
    (42, 34, N'Acer Swift Go 14 Ultra 5 125H/16GB/512GB OLED', N'ACE-003', 21990000, 21990000, NULL, 1),
    (43, 8, N'HP 15 i3-1315U/8GB/256GB', N'HPX-001', 10990000, 10990000, NULL, 1),
    (44, 26, N'ASUS Zenbook 14 OLED Ultra 7 155H/16GB/1TB', N'ASU-003', 28990000, 26091000, 3, 2);

-- LichSuTrangThaiDon (157 dòng)
SET IDENTITY_INSERT dbo.LichSuTrangThaiDon ON;
INSERT INTO dbo.LichSuTrangThaiDon (MaLichSu, MaDonHang, TuTrangThai, SangTrangThai, NguoiThucHien, GhiChu, ThoiDiem) VALUES
    (1, 1, NULL, N'CHO_XAC_NHAN', 2, N'Khách đặt hàng', '2025-12-03T08:53:00'),
    (2, 1, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2025-12-03T18:23:00'),
    (3, 1, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2025-12-04T15:23:00'),
    (4, 1, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2025-12-06T09:23:00'),
    (5, 2, NULL, N'CHO_XAC_NHAN', 13, N'Khách đặt hàng', '2025-12-09T13:58:00'),
    (6, 2, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2025-12-09T17:58:00'),
    (7, 2, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2025-12-10T11:58:00'),
    (8, 2, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2025-12-12T05:58:00'),
    (9, 3, NULL, N'CHO_XAC_NHAN', 4, N'Khách đặt hàng', '2025-12-14T15:04:00'),
    (10, 3, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2025-12-14T20:04:00'),
    (11, 3, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2025-12-15T20:04:00'),
    (12, 3, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2025-12-17T12:04:00'),
    (13, 4, NULL, N'CHO_XAC_NHAN', 5, N'Khách đặt hàng', '2026-01-06T10:06:00'),
    (14, 4, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-01-06T20:36:00'),
    (15, 4, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-01-07T16:36:00'),
    (16, 5, NULL, N'CHO_XAC_NHAN', 6, N'Khách đặt hàng', '2026-01-08T14:03:00'),
    (17, 5, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-01-08T17:03:00'),
    (18, 4, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-01-09T11:36:00'),
    (19, 5, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-01-09T16:03:00'),
    (20, 5, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-01-11T12:03:00'),
    (21, 6, NULL, N'CHO_XAC_NHAN', 7, N'Khách đặt hàng', '2026-01-18T09:38:00'),
    (22, 6, N'CHO_XAC_NHAN', N'DA_HUY', 7, N'Khách hủy đơn, đã ghi nhận hoàn tiền', '2026-01-18T14:38:00'),
    (23, 7, NULL, N'CHO_XAC_NHAN', 8, N'Khách đặt hàng', '2026-02-04T08:19:00'),
    (24, 7, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-02-04T17:49:00'),
    (25, 7, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-02-05T15:49:00'),
    (26, 7, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-02-07T12:49:00'),
    (27, 8, NULL, N'CHO_XAC_NHAN', 9, N'Khách đặt hàng', '2026-02-11T08:41:00'),
    (28, 8, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-02-11T16:41:00'),
    (29, 8, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-02-12T13:41:00'),
    (30, 8, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-02-14T05:41:00'),
    (31, 9, NULL, N'CHO_XAC_NHAN', 10, N'Khách đặt hàng', '2026-03-04T16:44:00'),
    (32, 9, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-03-04T23:44:00'),
    (33, 9, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-03-05T17:44:00'),
    (34, 9, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-03-07T09:44:00'),
    (35, 10, NULL, N'CHO_XAC_NHAN', 11, N'Khách đặt hàng', '2026-03-11T12:51:00'),
    (36, 10, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-03-11T18:21:00'),
    (37, 10, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-03-12T16:21:00'),
    (38, 10, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-03-14T09:21:00'),
    (39, 11, NULL, N'CHO_XAC_NHAN', 12, N'Khách đặt hàng', '2026-03-14T15:54:00'),
    (40, 11, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-03-14T21:54:00'),
    (41, 11, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-03-15T15:54:00'),
    (42, 11, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-03-17T12:54:00'),
    (43, 12, NULL, N'CHO_XAC_NHAN', 2, N'Khách đặt hàng', '2026-04-05T13:43:00'),
    (44, 12, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-04-05T19:43:00'),
    (45, 12, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-04-06T17:43:00'),
    (46, 12, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-04-08T12:43:00'),
    (47, 13, NULL, N'CHO_XAC_NHAN', 3, N'Khách đặt hàng', '2026-04-10T10:51:00'),
    (48, 13, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-04-10T15:21:00'),
    (49, 13, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-04-11T13:21:00'),
    (50, 13, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-04-13T05:21:00'),
    (51, 14, NULL, N'CHO_XAC_NHAN', 4, N'Khách đặt hàng', '2026-05-03T21:56:00'),
    (52, 14, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-05-04T00:56:00'),
    (53, 14, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-05-04T23:56:00'),
    (54, 14, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-05-06T18:56:00'),
    (55, 15, NULL, N'CHO_XAC_NHAN', 5, N'Khách đặt hàng', '2026-05-08T13:30:00'),
    (56, 15, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-05-08T20:30:00'),
    (57, 15, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-05-09T20:30:00'),
    (58, 15, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-05-11T16:30:00'),
    (59, 16, NULL, N'CHO_XAC_NHAN', 6, N'Khách đặt hàng', '2026-05-17T12:50:00'),
    (60, 16, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-05-17T19:20:00'),
    (61, 16, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-05-18T14:20:00'),
    (62, 16, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-05-20T12:20:00'),
    (63, 17, NULL, N'CHO_XAC_NHAN', 7, N'Khách đặt hàng', '2026-06-05T13:33:00'),
    (64, 17, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-06-05T20:33:00'),
    (65, 17, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-06-06T16:33:00'),
    (66, 17, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-06-08T12:33:00'),
    (67, 18, NULL, N'CHO_XAC_NHAN', 8, N'Khách đặt hàng', '2026-06-08T16:28:00'),
    (68, 18, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-06-08T20:28:00'),
    (69, 18, N'DA_XAC_NHAN', N'DA_HUY', 1, N'Khách đổi ý, liên hệ hủy đơn', '2026-06-09T16:28:00'),
    (70, 19, NULL, N'CHO_XAC_NHAN', 9, N'Khách đặt hàng', '2026-07-05T13:34:00'),
    (71, 19, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-07-05T19:04:00'),
    (72, 19, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-07-06T19:04:00'),
    (73, 19, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-07-08T13:04:00'),
    (74, 20, NULL, N'CHO_XAC_NHAN', 10, N'Khách đặt hàng', '2026-07-11T09:18:00'),
    (75, 20, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-07-11T14:18:00'),
    (76, 20, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-07-12T08:18:00'),
    (77, 20, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-07-14T05:18:00'),
    (78, 21, NULL, N'CHO_XAC_NHAN', 11, N'Khách đặt hàng', '2026-07-16T08:00:00'),
    (79, 21, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-07-16T17:00:00'),
    (80, 21, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-07-17T13:00:00'),
    (81, 21, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-07-19T11:00:00'),
    (82, 22, NULL, N'CHO_XAC_NHAN', 12, N'Khách đặt hàng', '2026-08-03T19:10:00'),
    (83, 22, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-08-03T23:40:00'),
    (84, 22, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-08-04T18:40:00'),
    (85, 22, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-08-06T10:40:00'),
    (86, 23, NULL, N'CHO_XAC_NHAN', 2, N'Khách đặt hàng', '2026-08-09T09:30:00'),
    (87, 23, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-08-09T17:30:00'),
    (88, 23, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-08-10T15:30:00'),
    (89, 23, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-08-12T12:30:00'),
    (90, 24, NULL, N'CHO_XAC_NHAN', 3, N'Khách đặt hàng', '2026-08-16T10:32:00'),
    (91, 24, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-08-16T18:32:00'),
    (92, 24, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-08-17T16:32:00'),
    (93, 24, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-08-19T12:32:00'),
    (94, 25, NULL, N'CHO_XAC_NHAN', 4, N'Khách đặt hàng', '2026-08-21T14:20:00'),
    (95, 25, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-08-21T22:50:00'),
    (96, 25, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-08-22T17:50:00'),
    (97, 25, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-08-24T11:50:00'),
    (98, 26, NULL, N'CHO_XAC_NHAN', 5, N'Khách đặt hàng', '2026-09-03T11:26:00'),
    (99, 26, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-09-03T18:26:00'),
    (100, 26, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-09-04T15:26:00'),
    (101, 26, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-09-06T07:26:00'),
    (102, 27, NULL, N'CHO_XAC_NHAN', 6, N'Khách đặt hàng', '2026-09-10T09:55:00'),
    (103, 27, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-09-10T16:55:00'),
    (104, 27, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-09-11T10:55:00'),
    (105, 27, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-09-13T06:55:00'),
    (106, 28, NULL, N'CHO_XAC_NHAN', 7, N'Khách đặt hàng', '2026-09-18T20:55:00'),
    (107, 28, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-09-19T01:25:00'),
    (108, 28, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-09-19T23:25:00'),
    (109, 29, NULL, N'CHO_XAC_NHAN', 8, N'Khách đặt hàng', '2026-09-20T16:10:00'),
    (110, 29, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-09-21T00:10:00'),
    (111, 28, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-09-21T19:25:00'),
    (112, 29, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-09-21T20:10:00'),
    (113, 29, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-09-23T17:10:00'),
    (114, 30, NULL, N'CHO_XAC_NHAN', 9, N'Khách đặt hàng', '2026-10-06T11:45:00'),
    (115, 30, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-10-06T16:45:00'),
    (116, 30, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-10-07T12:45:00'),
    (117, 30, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-10-09T05:45:00'),
    (118, 31, NULL, N'CHO_XAC_NHAN', 10, N'Khách đặt hàng', '2026-10-12T14:52:00'),
    (119, 31, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-10-12T19:22:00'),
    (120, 31, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-10-13T13:22:00'),
    (121, 31, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-10-15T07:22:00'),
    (122, 32, NULL, N'CHO_XAC_NHAN', 11, N'Khách đặt hàng', '2026-10-18T19:04:00'),
    (123, 32, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-10-19T01:04:00'),
    (124, 32, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-10-19T23:04:00'),
    (125, 32, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-10-21T20:04:00'),
    (126, 33, NULL, N'CHO_XAC_NHAN', 12, N'Khách đặt hàng', '2026-10-21T21:01:00'),
    (127, 33, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-10-22T05:01:00'),
    (128, 33, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-10-23T01:01:00'),
    (129, 33, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-10-24T17:01:00'),
    (130, 34, NULL, N'CHO_XAC_NHAN', 2, N'Khách đặt hàng', '2026-11-01T20:45:00'),
    (131, 34, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-11-02T06:15:00'),
    (132, 35, NULL, N'CHO_XAC_NHAN', 3, N'Khách đặt hàng', '2026-11-02T17:35:00'),
    (133, 35, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-11-02T22:35:00'),
    (134, 34, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-11-03T04:15:00'),
    (135, 36, NULL, N'CHO_XAC_NHAN', 4, N'Khách đặt hàng', '2026-11-03T18:38:00'),
    (136, 35, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-11-03T22:35:00'),
    (137, 36, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-11-03T23:38:00'),
    (138, 37, NULL, N'CHO_XAC_NHAN', 5, N'Khách đặt hàng', '2026-11-04T08:53:00'),
    (139, 37, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-11-04T17:23:00'),
    (140, 36, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-11-04T19:38:00'),
    (141, 34, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-11-05T01:15:00'),
    (142, 37, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-11-05T15:23:00'),
    (143, 35, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-11-05T16:35:00'),
    (144, 38, NULL, N'CHO_XAC_NHAN', 6, N'Khách đặt hàng', '2026-11-05T20:11:00'),
    (145, 38, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-11-05T23:11:00'),
    (146, 39, NULL, N'CHO_XAC_NHAN', 7, N'Khách đặt hàng', '2026-11-06T14:54:00'),
    (147, 36, N'DANG_GIAO', N'DA_GIAO', 1, N'Giao hàng thành công', '2026-11-06T16:38:00'),
    (148, 38, N'DA_XAC_NHAN', N'DANG_GIAO', 1, N'Bàn giao vận chuyển', '2026-11-06T18:11:00'),
    (149, 39, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-11-06T18:54:00'),
    (150, 40, NULL, N'CHO_XAC_NHAN', 8, N'Khách đặt hàng', '2026-11-07T17:42:00'),
    (151, 40, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-11-08T01:12:00'),
    (152, 41, NULL, N'CHO_XAC_NHAN', 9, N'Khách đặt hàng', '2026-11-08T10:48:00'),
    (153, 42, NULL, N'CHO_XAC_NHAN', 10, N'Khách đặt hàng', '2026-11-09T16:13:00'),
    (154, 43, NULL, N'CHO_XAC_NHAN', 11, N'Khách đặt hàng', '2026-11-10T15:19:00'),
    (155, 44, NULL, N'CHO_XAC_NHAN', 12, N'Khách đặt hàng', '2026-11-11T18:57:00'),
    (156, 44, N'CHO_XAC_NHAN', N'DA_XAC_NHAN', 1, N'Xác nhận đơn', '2026-11-11T22:57:00'),
    (157, 44, N'DA_XAC_NHAN', N'DA_HUY', 1, N'Khách đổi ý, liên hệ hủy đơn', '2026-11-12T18:57:00');
SET IDENTITY_INSERT dbo.LichSuTrangThaiDon OFF;

-- DanhGia (31 dòng)
SET IDENTITY_INSERT dbo.DanhGia ON;
INSERT INTO dbo.DanhGia (MaDanhGia, MaNguoiDung, MaSanPham, SoSao, NoiDung, BiAn, NgayTao, NgayCapNhat) VALUES
    (1, 2, 1, 5, N'Máy chạy rất mượt, giao hàng nhanh, đóng gói cẩn thận.', 0, '2025-12-11T10:23:00', NULL),
    (2, 13, 5, 4, N'Đáng tiền, bàn phím gõ êm, loa nghe tạm được.', 0, '2025-12-13T11:58:00', NULL),
    (3, 5, 9, 4, N'Nội dung quảng cáo trang web khác, vi phạm quy định (đã bị ẩn).', 1, '2026-01-13T20:36:00', NULL),
    (4, 6, 1, 5, N'Máy chạy rất mượt, giao hàng nhanh, đóng gói cẩn thận.', 0, '2026-01-17T21:03:00', NULL),
    (5, 8, 9, 5, N'Hiệu năng tốt trong tầm giá, rất hài lòng.', 0, '2026-02-12T12:49:00', '2026-02-14T12:49:00'),
    (6, 10, 12, 4, N'Đáng tiền, bàn phím gõ êm, loa nghe tạm được.', 0, '2026-03-10T15:44:00', NULL),
    (7, 11, 9, 3, N'Hiệu năng ổn nhưng màn hình hơi tối khi dùng ngoài trời.', 0, '2026-03-17T18:21:00', NULL),
    (8, 11, 10, 4, N'Cấu hình tốt, chỉ tiếc là hơi nặng khi mang đi học.', 0, '2026-03-17T14:21:00', NULL),
    (9, 12, 6, 3, N'Máy dùng tạm ổn nhưng pin không được lâu như quảng cáo.', 0, '2026-03-21T16:54:00', NULL),
    (10, 2, 12, 5, N'Máy chạy rất mượt, giao hàng nhanh, đóng gói cẩn thận.', 0, '2026-04-14T12:43:00', NULL),
    (11, 3, 2, 4, N'Cấu hình tốt, chỉ tiếc là hơi nặng khi mang đi học.', 0, '2026-04-19T08:21:00', NULL),
    (12, 5, 3, 5, N'Hiệu năng tốt trong tầm giá, rất hài lòng.', 0, '2026-05-15T02:30:00', NULL),
    (13, 5, 25, 5, N'Màn hình đẹp, pin dùng cả ngày học không lo hết.', 0, '2026-05-17T19:30:00', NULL),
    (14, 6, 16, 4, N'Máy ổn, chạy tốt các tác vụ văn phòng, quạt hơi ồn khi tải nặng.', 0, '2026-05-23T13:20:00', NULL),
    (15, 7, 1, 5, N'Máy chạy rất mượt, giao hàng nhanh, đóng gói cẩn thận.', 0, '2026-06-11T18:33:00', NULL),
    (16, 9, 33, 5, N'Máy chạy rất mượt, giao hàng nhanh, đóng gói cẩn thận.', 0, '2026-07-10T20:04:00', NULL),
    (17, 11, 11, 5, N'Máy chạy rất mượt, giao hàng nhanh, đóng gói cẩn thận.', 0, '2026-07-22T20:00:00', NULL),
    (18, 12, 39, 4, N'Máy ổn, chạy tốt các tác vụ văn phòng, quạt hơi ồn khi tải nặng.', 0, '2026-08-11T19:40:00', NULL),
    (19, 2, 33, 5, N'Màn hình đẹp, pin dùng cả ngày học không lo hết.', 0, '2026-08-16T15:30:00', NULL),
    (20, 2, 5, 4, N'Máy ổn, chạy tốt các tác vụ văn phòng, quạt hơi ồn khi tải nặng.', 0, '2026-08-14T15:30:00', NULL),
    (21, 3, 39, 5, N'Máy chạy rất mượt, giao hàng nhanh, đóng gói cẩn thận.', 0, '2026-08-25T17:32:00', NULL),
    (22, 3, 14, 4, N'Cấu hình tốt, chỉ tiếc là hơi nặng khi mang đi học.', 0, '2026-08-20T19:32:00', NULL),
    (23, 4, 10, 2, N'Máy nóng nhiều khi chơi game, cần cải thiện tản nhiệt.', 0, '2026-08-29T16:50:00', NULL),
    (24, 5, 18, 2, N'Máy nóng nhiều khi chơi game, cần cải thiện tản nhiệt.', 0, '2026-09-08T17:26:00', NULL),
    (25, 6, 9, 5, N'Màn hình đẹp, pin dùng cả ngày học không lo hết.', 0, '2026-09-18T12:55:00', NULL),
    (26, 7, 35, 4, N'Đáng tiền, bàn phím gõ êm, loa nghe tạm được.', 0, '2026-09-25T03:25:00', NULL),
    (27, 7, 27, 5, N'Hiệu năng tốt trong tầm giá, rất hài lòng.', 0, '2026-09-24T20:25:00', NULL),
    (28, 9, 28, 5, N'Máy chạy rất mượt, giao hàng nhanh, đóng gói cẩn thận.', 0, '2026-10-14T10:45:00', NULL),
    (29, 12, 20, 4, N'Cấu hình tốt, chỉ tiếc là hơi nặng khi mang đi học.', 0, '2026-10-27T03:01:00', NULL),
    (30, 3, 44, 5, N'Máy chạy rất mượt, giao hàng nhanh, đóng gói cẩn thận.', 0, '2026-11-07T02:35:00', NULL),
    (31, 4, 26, 4, N'Đáng tiền, bàn phím gõ êm, loa nghe tạm được.', 0, '2026-11-12T02:38:00', NULL);
SET IDENTITY_INSERT dbo.DanhGia OFF;

-- QuangCao (4 dòng)
SET IDENTITY_INSERT dbo.QuangCao ON;
INSERT INTO dbo.QuangCao (MaQuangCao, TieuDe, DuongDanAnh, DuongDanLienKet, ThuTu, DangHoatDong, NgayTao) VALUES
    (1, N'Black Friday 2026 - Giảm đến 10%', N'banners/black-friday-2026.jpg', N'/products?promotion=3', 0, 1, '2026-11-01T08:00:00'),
    (2, N'Tuần lễ Gaming - Giảm ngay 3 triệu', N'banners/tuan-le-gaming.jpg', N'/products?category=gaming', 1, 1, '2026-11-01T08:00:00'),
    (3, N'MacBook Air M3 - Mỏng nhẹ, pin cả ngày', N'banners/macbook-air-m3.jpg', N'/products?brand=apple', 2, 1, '2026-11-01T08:00:00'),
    (4, N'Back to School 2026 (đã kết thúc)', N'banners/back-to-school-2026.jpg', N'/products?category=van-phong-hoc-tap', 3, 0, '2026-11-01T08:00:00');
SET IDENTITY_INSERT dbo.QuangCao OFF;

COMMIT TRANSACTION;
GO

PRINT N'Đã nạp dữ liệu mẫu thành công.';
SELECT N'NguoiDung' AS TenBang, COUNT(*) AS SoDong FROM dbo.NguoiDung
UNION ALL SELECT N'DanhMuc', COUNT(*) FROM dbo.DanhMuc
UNION ALL SELECT N'ThuongHieu', COUNT(*) FROM dbo.ThuongHieu
UNION ALL SELECT N'BoXuLy', COUNT(*) FROM dbo.BoXuLy
UNION ALL SELECT N'CardDoHoa', COUNT(*) FROM dbo.CardDoHoa
UNION ALL SELECT N'SanPham', COUNT(*) FROM dbo.SanPham
UNION ALL SELECT N'HinhAnhSanPham', COUNT(*) FROM dbo.HinhAnhSanPham
UNION ALL SELECT N'KhuyenMai', COUNT(*) FROM dbo.KhuyenMai
UNION ALL SELECT N'SanPhamKhuyenMai', COUNT(*) FROM dbo.SanPhamKhuyenMai
UNION ALL SELECT N'GioHang', COUNT(*) FROM dbo.GioHang
UNION ALL SELECT N'DonHang', COUNT(*) FROM dbo.DonHang
UNION ALL SELECT N'ChiTietDonHang', COUNT(*) FROM dbo.ChiTietDonHang
UNION ALL SELECT N'LichSuTrangThaiDon', COUNT(*) FROM dbo.LichSuTrangThaiDon
UNION ALL SELECT N'DanhGia', COUNT(*) FROM dbo.DanhGia
UNION ALL SELECT N'QuangCao', COUNT(*) FROM dbo.QuangCao;
GO
