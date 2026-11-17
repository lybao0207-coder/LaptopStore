/* =====================================================================
   LaptopShop - 03_integrity_check.sql
   Kiểm tra tính toàn vẹn sau khi chạy 01 + 02.
   - Phần A: số dòng từng bảng đúng như dữ liệu mẫu.
   - Phần B: dữ liệu thỏa quy tắc nghiệp vụ (mỗi kiểm tra phải có 0 vi phạm).
   - Phần C: ràng buộc DB phải CHẶN dữ liệu sai (mỗi lệnh sai phải bị lỗi).
     Mọi thay đổi ở phần C đều ROLLBACK, database không bị thay đổi.
   - Phần D: truy vấn nghiệp vụ mẫu (giá KM, doanh thu, phân trang).
   Kết quả cuối: bảng tổng hợp; mong đợi KHONG_DAT = 0.
   ===================================================================== */
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
USE CuaHangLaptop;
GO
SET NOCOUNT ON;
SET XACT_ABORT OFF;   -- để lỗi ràng buộc không hủy cả batch, TRY/CATCH bắt được

-- Biến bảng không bị ảnh hưởng bởi ROLLBACK -> giữ được kết quả kiểm tra
DECLARE @R TABLE (STT INT IDENTITY(1,1), Phan CHAR(1), MaKiemTra VARCHAR(10), MoTa NVARCHAR(300), KetQua VARCHAR(10), ChiTiet NVARCHAR(4000));
DECLARE @n INT, @err INT, @msg NVARCHAR(4000);

-- ===== Phiên bản SQL Server (D05: cần >= 2012, ProductMajorVersion >= 11)
SET @n = CAST(PARSENAME(CAST(SERVERPROPERTY('ProductVersion') AS VARCHAR(50)), 4) AS INT);
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
VALUES ('0', 'V01', N'Phiên bản SQL Server >= 2012', CASE WHEN @n >= 11 THEN 'DAT' ELSE 'KHONG_DAT' END,
        CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(50)) + N' - ' + CAST(SERVERPROPERTY('Edition') AS NVARCHAR(100)));
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
SELECT '0', 'V02', N'Collation database = Vietnamese_CI_AS',
       CASE WHEN CAST(DATABASEPROPERTYEX(DB_NAME(), 'Collation') AS NVARCHAR(128)) = N'Vietnamese_CI_AS' THEN 'DAT' ELSE 'KHONG_DAT' END,
       CAST(DATABASEPROPERTYEX(DB_NAME(), 'Collation') AS NVARCHAR(128));

-- ===== PHẦN A: số dòng
SELECT @n = COUNT(*) FROM dbo.NguoiDung;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('A', 'A01', N'Số dòng NguoiDung = 13', CASE WHEN @n = 13 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Thực tế: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM dbo.DanhMuc;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('A', 'A02', N'Số dòng DanhMuc = 5', CASE WHEN @n = 5 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Thực tế: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM dbo.ThuongHieu;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('A', 'A03', N'Số dòng ThuongHieu = 7', CASE WHEN @n = 7 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Thực tế: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM dbo.BoXuLy;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('A', 'A04', N'Số dòng BoXuLy = 16', CASE WHEN @n = 16 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Thực tế: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM dbo.CardDoHoa;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('A', 'A05', N'Số dòng CardDoHoa = 15', CASE WHEN @n = 15 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Thực tế: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM dbo.SanPham;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('A', 'A06', N'Số dòng SanPham = 46', CASE WHEN @n = 46 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Thực tế: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM dbo.HinhAnhSanPham;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('A', 'A07', N'Số dòng HinhAnhSanPham = 92', CASE WHEN @n = 92 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Thực tế: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM dbo.KhuyenMai;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('A', 'A08', N'Số dòng KhuyenMai = 6', CASE WHEN @n = 6 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Thực tế: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM dbo.SanPhamKhuyenMai;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('A', 'A09', N'Số dòng SanPhamKhuyenMai = 47', CASE WHEN @n = 47 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Thực tế: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM dbo.GioHang;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('A', 'A10', N'Số dòng GioHang = 5', CASE WHEN @n = 5 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Thực tế: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM dbo.DonHang;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('A', 'A11', N'Số dòng DonHang = 44', CASE WHEN @n = 44 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Thực tế: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM dbo.ChiTietDonHang;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('A', 'A12', N'Số dòng ChiTietDonHang = 58', CASE WHEN @n = 58 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Thực tế: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM dbo.LichSuTrangThaiDon;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('A', 'A13', N'Số dòng LichSuTrangThaiDon = 157', CASE WHEN @n = 157 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Thực tế: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM dbo.DanhGia;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('A', 'A14', N'Số dòng DanhGia = 31', CASE WHEN @n = 31 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Thực tế: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM dbo.QuangCao;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('A', 'A15', N'Số dòng QuangCao = 4', CASE WHEN @n = 4 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Thực tế: ' + CAST(@n AS NVARCHAR(20)));

-- ===== PHẦN B: quy tắc nghiệp vụ trên dữ liệu (mong đợi 0 vi phạm)
SELECT @n = COUNT(*) FROM (SELECT o.MaDonHang FROM dbo.DonHang o JOIN dbo.ChiTietDonHang d ON d.MaDonHang = o.MaDonHang GROUP BY o.MaDonHang, o.TongTien HAVING o.TongTien <> SUM(d.ThanhTien)) v;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('B', 'B01', N'Tổng tiền đơn = tổng thành tiền chi tiết', CASE WHEN @n = 0 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Số vi phạm: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM (SELECT o.MaDonHang FROM dbo.DonHang o WHERE NOT EXISTS (SELECT 1 FROM dbo.ChiTietDonHang d WHERE d.MaDonHang = o.MaDonHang)) v;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('B', 'B02', N'Đơn hàng nào cũng có ít nhất 1 dòng chi tiết', CASE WHEN @n = 0 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Số vi phạm: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM (SELECT o.MaDonHang FROM dbo.DonHang o JOIN dbo.NguoiDung u ON u.MaNguoiDung = o.MaNguoiDung WHERE u.VaiTro <> 'KHACH_HANG' OR u.NgayTao > o.NgayTao) v;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('B', 'B03', N'Người đặt hàng là KHACH_HANG và đã đăng ký trước khi đặt', CASE WHEN @n = 0 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Số vi phạm: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM (SELECT r.MaDanhGia FROM dbo.DanhGia r WHERE NOT EXISTS (SELECT 1 FROM dbo.DonHang o JOIN dbo.ChiTietDonHang d ON d.MaDonHang = o.MaDonHang WHERE o.MaNguoiDung = r.MaNguoiDung AND d.MaSanPham = r.MaSanPham AND o.TrangThai = 'DA_GIAO' AND o.NgayGiaoThanhCong <= r.NgayTao)) v;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('B', 'B04', N'Đánh giá chỉ có khi đã mua và đơn DA_GIAO trước thời điểm đánh giá (BR30)', CASE WHEN @n = 0 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Số vi phạm: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM (SELECT r.MaDanhGia FROM dbo.DanhGia r JOIN dbo.NguoiDung u ON u.MaNguoiDung = r.MaNguoiDung WHERE u.VaiTro <> 'KHACH_HANG') v;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('B', 'B05', N'Người đánh giá có vai trò KHACH_HANG', CASE WHEN @n = 0 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Số vi phạm: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM (SELECT o.MaDonHang FROM dbo.DonHang o CROSS APPLY (SELECT TOP 1 h.SangTrangThai FROM dbo.LichSuTrangThaiDon h WHERE h.MaDonHang = o.MaDonHang ORDER BY h.ThoiDiem DESC, h.MaLichSu DESC) lsCuoi WHERE lsCuoi.SangTrangThai <> o.TrangThai) v;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('B', 'B06', N'Trạng thái cuối trong lịch sử = trạng thái hiện tại của đơn', CASE WHEN @n = 0 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Số vi phạm: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM (SELECT x.MaLichSu FROM (SELECT h.MaLichSu, h.TuTrangThai, LAG(h.SangTrangThai) OVER (PARTITION BY h.MaDonHang ORDER BY h.ThoiDiem, h.MaLichSu) AS TrangThaiTruoc FROM dbo.LichSuTrangThaiDon h) x WHERE ISNULL(x.TuTrangThai, '') <> ISNULL(x.TrangThaiTruoc, '')) v;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('B', 'B07', N'Lịch sử trạng thái liên tục (TuTrangThai = SangTrangThai của bước trước)', CASE WHEN @n = 0 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Số vi phạm: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM (SELECT h.MaLichSu FROM dbo.LichSuTrangThaiDon h JOIN dbo.DonHang o ON o.MaDonHang = h.MaDonHang JOIN dbo.NguoiDung u ON u.MaNguoiDung = h.NguoiThucHien WHERE NOT ((h.TuTrangThai IS NULL AND h.SangTrangThai = 'CHO_XAC_NHAN' AND h.NguoiThucHien = o.MaNguoiDung) OR (h.TuTrangThai = 'CHO_XAC_NHAN' AND h.SangTrangThai = 'DA_HUY' AND (h.NguoiThucHien = o.MaNguoiDung OR u.VaiTro = 'QUAN_TRI')) OR (h.TuTrangThai IS NOT NULL AND u.VaiTro = 'QUAN_TRI'))) v;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('B', 'B08', N'Đơn tạo bởi chính khách hàng; khách chỉ được hủy khi CHO_XAC_NHAN; bước còn lại do QUAN_TRI (BR27)', CASE WHEN @n = 0 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Số vi phạm: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM (SELECT d.MaDonHang FROM dbo.ChiTietDonHang d JOIN dbo.DonHang o ON o.MaDonHang = d.MaDonHang JOIN dbo.KhuyenMai p ON p.MaKhuyenMai = d.MaKhuyenMai WHERE o.NgayTao NOT BETWEEN p.NgayBatDau AND p.NgayKetThuc OR NOT EXISTS (SELECT 1 FROM dbo.SanPhamKhuyenMai pp WHERE pp.MaSanPham = d.MaSanPham AND pp.MaKhuyenMai = d.MaKhuyenMai)) v;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('B', 'B09', N'Khuyến mãi ghi trong chi tiết đơn: có gắn với SP và còn hiệu lực lúc đặt', CASE WHEN @n = 0 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Số vi phạm: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM (SELECT d.MaDonHang FROM dbo.ChiTietDonHang d JOIN dbo.KhuyenMai p ON p.MaKhuyenMai = d.MaKhuyenMai WHERE d.TienGiam <> CASE WHEN p.LoaiGiam = 'PHAN_TRAM' THEN ROUND(d.DonGiaGoc * p.GiaTriGiam / 100, 0) ELSE p.GiaTriGiam END) v;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('B', 'B10', N'Số tiền giảm trong chi tiết đơn khớp loại / giá trị khuyến mãi', CASE WHEN @n = 0 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Số vi phạm: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM (SELECT pp.MaSanPham FROM dbo.SanPhamKhuyenMai pp JOIN dbo.SanPham pr ON pr.MaSanPham = pp.MaSanPham JOIN dbo.KhuyenMai p ON p.MaKhuyenMai = pp.MaKhuyenMai WHERE pr.GiaBan - CASE WHEN p.LoaiGiam = 'PHAN_TRAM' THEN ROUND(pr.GiaBan * p.GiaTriGiam / 100, 0) ELSE p.GiaTriGiam END <= 0) v;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('B', 'B11', N'Khuyến mãi không làm giá sản phẩm được gắn <= 0 (BR14)', CASE WHEN @n = 0 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Số vi phạm: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM (SELECT p.MaSanPham FROM dbo.SanPham p WHERE p.TrangThai = 'DANG_BAN' AND (SELECT COUNT(*) FROM dbo.HinhAnhSanPham i WHERE i.MaSanPham = p.MaSanPham AND i.LaAnhDaiDien = 1) <> 1) v;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('B', 'B12', N'Sản phẩm DANG_BAN có đúng 1 ảnh đại diện', CASE WHEN @n = 0 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Số vi phạm: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM (SELECT c.MaGioHang FROM dbo.GioHang c JOIN dbo.NguoiDung u ON u.MaNguoiDung = c.MaNguoiDung WHERE u.VaiTro <> 'KHACH_HANG') v;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('B', 'B13', N'Giỏ hàng chỉ thuộc tài khoản KHACH_HANG', CASE WHEN @n = 0 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Số vi phạm: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM (SELECT 1 AS x WHERE NOT EXISTS (SELECT 1 FROM dbo.NguoiDung WHERE VaiTro = 'QUAN_TRI' AND BiKhoa = 0)) v;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('B', 'B14', N'Luôn còn ít nhất 1 QUAN_TRI đang hoạt động (BR05)', CASE WHEN @n = 0 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Số vi phạm: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM (SELECT p.MaSanPham FROM dbo.SanPham p JOIN dbo.DanhMuc c ON c.MaDanhMuc = p.MaDanhMuc JOIN dbo.ThuongHieu b ON b.MaThuongHieu = p.MaThuongHieu WHERE p.TrangThai = 'DANG_BAN' AND (c.DangHoatDong = 0 OR b.DangHoatDong = 0)) v;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('B', 'B15', N'Sản phẩm DANG_BAN có danh mục và thương hiệu đang hoạt động', CASE WHEN @n = 0 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Số vi phạm: ' + CAST(@n AS NVARCHAR(20)));
SELECT @n = COUNT(*) FROM (SELECT MaDonHang FROM dbo.DonHang WHERE MaDonHienThi NOT LIKE 'LS[0-9][0-9][0-9][0-9][0-9][0-9]') v;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('B', 'B16', N'Mã đơn (MaDonHienThi) sinh đúng định dạng LS + 6 số', CASE WHEN @n = 0 THEN 'DAT' ELSE 'KHONG_DAT' END, N'Số vi phạm: ' + CAST(@n AS NVARCHAR(20)));

-- ===== PHẦN C: ràng buộc phải chặn dữ liệu sai (mọi thay đổi đều ROLLBACK)
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT dbo.NguoiDung (Email, MatKhauBam, HoTen, SoDienThoai, VaiTro) VALUES ('Admin@LaptopShop.Local', 'pbkdf2_sha256$600000$c2FsdA==$aGFzaA==', N'Test', '0911111111', 'KHACH_HANG');
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C01', N'Trùng email (UQ_NguoiDung_Email)', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C01', N'Trùng email (UQ_NguoiDung_Email)', CASE WHEN @err IN (2627, 2601) AND (@msg LIKE '%UQ_NguoiDung_Email%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT dbo.NguoiDung (Email, MatKhauBam, HoTen, SoDienThoai, VaiTro) VALUES ('staff@laptopshop.local', 'pbkdf2_sha256$600000$c2FsdA==$aGFzaA==', N'Test', '0911111111', 'STAFF');
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C02', N'Vai trò không hợp lệ STAFF (D19)', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C02', N'Vai trò không hợp lệ STAFF (D19)', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_NguoiDung_VaiTro%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT dbo.NguoiDung (Email, MatKhauBam, HoTen, SoDienThoai) VALUES ('x1@laptopshop.local', 'pbkdf2_sha256$600000$c2FsdA==$aGFzaA==', N'Test', '12345abc');
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C03', N'Số điện thoại sai định dạng', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C03', N'Số điện thoại sai định dạng', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_NguoiDung_SoDienThoai%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT dbo.NguoiDung (Email, MatKhauBam, HoTen, SoDienThoai) VALUES ('x2@laptopshop.local', '123456', N'Test', '0911111111');
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C04', N'Mật khẩu lưu dạng plain text', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C04', N'Mật khẩu lưu dạng plain text', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_NguoiDung_MatKhauBam%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE dbo.SanPham SET GiaBan = 0 WHERE MaSanPham = 1;
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C05', N'Giá sản phẩm = 0 (BR07)', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C05', N'Giá sản phẩm = 0 (BR07)', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_SanPham_GiaBan%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE dbo.SanPham SET SoLuongTon = -1 WHERE MaSanPham = 1;
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C06', N'Tồn kho âm (BR08)', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C06', N'Tồn kho âm (BR08)', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_SanPham_SoLuongTon%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE dbo.SanPham SET MaSku = (SELECT MaSku FROM dbo.SanPham WHERE MaSanPham = 2) WHERE MaSanPham = 1;
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C07', N'Trùng SKU sản phẩm (BR12)', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C07', N'Trùng SKU sản phẩm (BR12)', CASE WHEN @err IN (2627, 2601) AND (@msg LIKE '%UQ_SanPham_MaSku%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE dbo.SanPham SET MaDanhMuc = 9999 WHERE MaSanPham = 1;
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C08', N'Sản phẩm thuộc danh mục không tồn tại (FK)', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C08', N'Sản phẩm thuộc danh mục không tồn tại (FK)', CASE WHEN @err IN (547) AND (@msg LIKE '%FK_SanPham_DanhMuc%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    DELETE FROM dbo.DanhMuc WHERE MaDanhMuc = 1;
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C09', N'Xóa danh mục đang có sản phẩm (BR11)', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C09', N'Xóa danh mục đang có sản phẩm (BR11)', CASE WHEN @err IN (547) AND (@msg LIKE '%FK_SanPham_DanhMuc%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    DELETE FROM dbo.ThuongHieu WHERE MaThuongHieu = 1;
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C10', N'Xóa thương hiệu đang có sản phẩm (BR11)', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C10', N'Xóa thương hiệu đang có sản phẩm (BR11)', CASE WHEN @err IN (547) AND (@msg LIKE '%FK_SanPham_ThuongHieu%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    DELETE FROM dbo.SanPham WHERE MaSanPham = (SELECT TOP 1 MaSanPham FROM dbo.ChiTietDonHang ORDER BY MaSanPham);
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C11', N'Xóa cứng sản phẩm đã có trong đơn hàng (BR09)', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C11', N'Xóa cứng sản phẩm đã có trong đơn hàng (BR09)', CASE WHEN @err IN (547) AND (@msg LIKE '%FK_ChiTietDonHang_SanPham%' OR @msg LIKE '%FK_DanhGia_SanPham%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE dbo.SanPham SET RamToiDaGB = 4 WHERE MaSanPham = 2;
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C12', N'RAM tối đa nhỏ hơn RAM hiện có', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C12', N'RAM tối đa nhỏ hơn RAM hiện có', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_SanPham_RamToiDa%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT dbo.CardDoHoa (HangSanXuat, TenModel, LoaiCard, BoNhoVramGB) VALUES ('NVIDIA', 'Test GPU', 'ROI', NULL);
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C13', N'Card rời không có VRAM', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C13', N'Card rời không có VRAM', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_CardDoHoa_Vram%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT dbo.HinhAnhSanPham (MaSanPham, DuongDanAnh, LaAnhDaiDien) VALUES (1, N'products/test-thumb.jpg', 1);
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C14', N'Ảnh đại diện thứ 2 cho cùng sản phẩm', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C14', N'Ảnh đại diện thứ 2 cho cùng sản phẩm', CASE WHEN @err IN (2601, 2627) AND (@msg LIKE '%UX_HinhAnhSanPham_AnhDaiDien%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT dbo.HinhAnhSanPham (MaSanPham, DuongDanAnh) VALUES (1, N'../../windows/win.ini');
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C15', N'Đường dẫn ảnh chứa .. (path traversal)', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C15', N'Đường dẫn ảnh chứa .. (path traversal)', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_HinhAnhSanPham_DuongDan%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE dbo.QuangCao SET DuongDanLienKet = N'https://evil.example' WHERE MaQuangCao = 1;
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C16', N'Banner trỏ ra website ngoài', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C16', N'Banner trỏ ra website ngoài', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_QuangCao_LienKet%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE dbo.GioHang SET SoLuong = 6 WHERE MaGioHang = 1;
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C17', N'Giỏ hàng số lượng 6 (D21)', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C17', N'Giỏ hàng số lượng 6 (D21)', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_GioHang_SoLuong%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT dbo.GioHang (MaNguoiDung, MaSanPham, SoLuong) SELECT MaNguoiDung, MaSanPham, 1 FROM dbo.GioHang WHERE MaGioHang = 1;
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C18', N'Trùng sản phẩm trong giỏ của 1 khách (BR20)', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C18', N'Trùng sản phẩm trong giỏ của 1 khách (BR20)', CASE WHEN @err IN (2627, 2601) AND (@msg LIKE '%UQ_GioHang_NguoiDung_SanPham%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT dbo.KhuyenMai (TenKhuyenMai, LoaiGiam, GiaTriGiam, NgayBatDau, NgayKetThuc) VALUES (N'Test 95', 'PHAN_TRAM', 95, '2026-12-01', '2026-12-31');
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C19', N'Khuyến mãi giảm 95% (BR14)', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C19', N'Khuyến mãi giảm 95% (BR14)', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_KhuyenMai_GiaTri%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT dbo.KhuyenMai (TenKhuyenMai, LoaiGiam, GiaTriGiam, NgayBatDau, NgayKetThuc) VALUES (N'Test ngày', 'SO_TIEN', 100000, '2026-12-31', '2026-12-01');
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C20', N'Khuyến mãi ngày kết thúc trước ngày bắt đầu (BR14)', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C20', N'Khuyến mãi ngày kết thúc trước ngày bắt đầu (BR14)', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_KhuyenMai_ThoiGian%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    DELETE FROM dbo.KhuyenMai WHERE MaKhuyenMai = (SELECT TOP 1 MaKhuyenMai FROM dbo.ChiTietDonHang WHERE MaKhuyenMai IS NOT NULL);
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C21', N'Xóa khuyến mãi đã áp dụng vào đơn hàng', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C21', N'Xóa khuyến mãi đã áp dụng vào đơn hàng', CASE WHEN @err IN (547) AND (@msg LIKE '%FK_ChiTietDonHang_KhuyenMai%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE dbo.DanhGia SET SoSao = 6 WHERE MaDanhGia = 1;
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C22', N'Đánh giá 6 sao (BR32)', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C22', N'Đánh giá 6 sao (BR32)', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_DanhGia_SoSao%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE dbo.DanhGia SET NoiDung = N'Tốt' WHERE MaDanhGia = 1;
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C23', N'Nội dung đánh giá dưới 10 ký tự (BR32)', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C23', N'Nội dung đánh giá dưới 10 ký tự (BR32)', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_DanhGia_NoiDung%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT dbo.DanhGia (MaNguoiDung, MaSanPham, SoSao, NoiDung) SELECT MaNguoiDung, MaSanPham, 5, N'Đánh giá lần hai cho cùng sản phẩm' FROM dbo.DanhGia WHERE MaDanhGia = 1;
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C24', N'Khách đánh giá 2 lần 1 sản phẩm (BR31)', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C24', N'Khách đánh giá 2 lần 1 sản phẩm (BR31)', CASE WHEN @err IN (2627, 2601) AND (@msg LIKE '%UQ_DanhGia_NguoiDung_SanPham%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT dbo.DonHang (MaNguoiDung, TenNguoiNhan, SdtNguoiNhan, DiaChiGiaoHang, PhuongThucThanhToan, TrangThaiThanhToan, TrangThai, TongTien, NgayXacNhan) VALUES (2, N'Test', '0911111111', N'Địa chỉ test', 'CHUYEN_KHOAN', 'CHUA_THANH_TOAN', 'DA_XAC_NHAN', 1000000, SYSDATETIME());
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C25', N'Đơn chuyển khoản DA_XAC_NHAN khi chưa DA_THANH_TOAN (D22)', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C25', N'Đơn chuyển khoản DA_XAC_NHAN khi chưa DA_THANH_TOAN (D22)', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_DonHang_ChuyenKhoanTraTruocXacNhan%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE dbo.DonHang SET NgayGiaoThanhCong = NULL WHERE MaDonHang = (SELECT TOP 1 MaDonHang FROM dbo.DonHang WHERE TrangThai = 'DA_GIAO');
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C26', N'Đơn DA_GIAO nhưng chưa có ngày giao', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C26', N'Đơn DA_GIAO nhưng chưa có ngày giao', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_DonHang_NgayGiaoThanhCong%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE dbo.DonHang SET TrangThaiThanhToan = 'DA_HOAN_TIEN' WHERE MaDonHang = (SELECT TOP 1 MaDonHang FROM dbo.DonHang WHERE PhuongThucThanhToan = 'THANH_TOAN_KHI_NHAN' AND TrangThai = 'DA_HUY');
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C27', N'Đơn THANH_TOAN_KHI_NHAN bị ghi nhận DA_HOAN_TIEN', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C27', N'Đơn THANH_TOAN_KHI_NHAN bị ghi nhận DA_HOAN_TIEN', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_DonHang_KhiNhanKhongHoanTien%' OR @msg LIKE '%CK_DonHang_NgayThanhToan%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE dbo.DonHang SET TrangThaiThanhToan = 'DA_THANH_TOAN' WHERE MaDonHang = (SELECT TOP 1 MaDonHang FROM dbo.DonHang WHERE TrangThaiThanhToan = 'DA_HOAN_TIEN');
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C28', N'Đơn hủy nhưng thanh toán vẫn DA_THANH_TOAN (D22)', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C28', N'Đơn hủy nhưng thanh toán vẫn DA_THANH_TOAN (D22)', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_DonHang_DaHuyKhongDaThanhToan%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE dbo.DonHang SET TrangThai = 'RETURNED' WHERE MaDonHang = (SELECT TOP 1 MaDonHang FROM dbo.DonHang WHERE TrangThai = 'CHO_XAC_NHAN');
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C29', N'Trạng thái đơn không hợp lệ', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C29', N'Trạng thái đơn không hợp lệ', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_DonHang_TrangThai%' OR @msg LIKE '%CK_DonHang_NgayXacNhan%' OR @msg LIKE '%CK_DonHang_NgayBanGiao%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE dbo.ChiTietDonHang SET DonGiaBan = DonGiaGoc + 1 WHERE MaDonHang = 1;
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C30', N'Giá sau KM lớn hơn giá gốc', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C30', N'Giá sau KM lớn hơn giá gốc', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_ChiTietDonHang_DonGia%' OR @msg LIKE '%CK_ChiTietDonHang_KhuyenMai%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE dbo.ChiTietDonHang SET DonGiaBan = DonGiaGoc - 1000 WHERE MaKhuyenMai IS NULL AND MaDonHang = (SELECT TOP 1 MaDonHang FROM dbo.ChiTietDonHang WHERE MaKhuyenMai IS NULL);
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C31', N'Giảm giá nhưng không ghi khuyến mãi', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C31', N'Giảm giá nhưng không ghi khuyến mãi', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_ChiTietDonHang_KhuyenMai%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE dbo.ChiTietDonHang SET SoLuong = 6 WHERE MaDonHang = 1;
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C32', N'Số lượng 1 sản phẩm trong đơn = 6 (D21)', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C32', N'Số lượng 1 sản phẩm trong đơn = 6 (D21)', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_ChiTietDonHang_SoLuong%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT dbo.LichSuTrangThaiDon (MaDonHang, TuTrangThai, SangTrangThai, NguoiThucHien) VALUES (1, 'DA_GIAO', 'CHO_XAC_NHAN', 1);
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C33', N'Chuyển trạng thái ngược DA_GIAO -> CHO_XAC_NHAN (BR27)', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C33', N'Chuyển trạng thái ngược DA_GIAO -> CHO_XAC_NHAN (BR27)', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_LichSuTrangThaiDon_ChuyenTrangThai%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT dbo.LichSuTrangThaiDon (MaDonHang, TuTrangThai, SangTrangThai, NguoiThucHien) VALUES (1, 'CHO_XAC_NHAN', 'DA_GIAO', 1);
    ROLLBACK TRANSACTION;
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet) VALUES ('C', 'C34', N'Chuyển trạng thái nhảy cóc CHO_XAC_NHAN -> DA_GIAO (BR26)', 'KHONG_DAT', N'Lệnh sai KHÔNG bị chặn');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT @err = ERROR_NUMBER(), @msg = ERROR_MESSAGE();
    INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
    VALUES ('C', 'C34', N'Chuyển trạng thái nhảy cóc CHO_XAC_NHAN -> DA_GIAO (BR26)', CASE WHEN @err IN (547) AND (@msg LIKE '%CK_LichSuTrangThaiDon_ChuyenTrangThai%') THEN 'DAT' ELSE 'KHONG_DAT' END, N'Lỗi ' + CAST(@err AS NVARCHAR(10)) + N': ' + LEFT(@msg, 200));
END CATCH;
BEGIN TRANSACTION;
UPDATE dbo.SanPham SET SoLuongTon = SoLuongTon - 9999 WHERE MaSanPham = 1 AND SoLuongTon >= 9999;
SET @n = @@ROWCOUNT;
ROLLBACK TRANSACTION;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
VALUES ('C', 'C35', N'Trừ kho có điều kiện khi không đủ hàng: 0 dòng cập nhật (BR22)', CASE WHEN @n = 0 THEN 'DAT' ELSE 'KHONG_DAT' END,
        N'Số dòng cập nhật: ' + CAST(@n AS NVARCHAR(10)));
BEGIN TRANSACTION;
DELETE FROM dbo.SanPham WHERE MaSanPham = 41;   -- SP ngừng KD, chưa có đơn: xóa được, ảnh + liên kết KM xóa theo (CASCADE)
SELECT @n = COUNT(*) FROM dbo.HinhAnhSanPham WHERE MaSanPham = 41;
ROLLBACK TRANSACTION;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
VALUES ('C', 'C36', N'Xóa SP chưa có đơn: ảnh bị xóa theo (CASCADE)', CASE WHEN @n = 0 THEN 'DAT' ELSE 'KHONG_DAT' END,
        N'Ảnh còn lại: ' + CAST(@n AS NVARCHAR(10)));

-- ===== PHẦN D: truy vấn nghiệp vụ mẫu
DECLARE @At DATETIME2(0) = '2026-11-15T12:00:00';   -- mốc cố định để kết quả không phụ thuộc ngày chạy
DECLARE @GiaBan TABLE (MaSanPham INT, GiaMongDoi DECIMAL(18,0), MaKmMongDoi INT);
INSERT @GiaBan VALUES (1, 15990000, NULL), (6, 32391000, 3), (12, 19990000, 4), (21, 32391000, 3), (28, 20490000, 4), (42, 26990000, NULL), (43, 29691000, 3), (5, 44990000, NULL);
-- S03 / BR16: giá hiện hành = giá gốc - mức giảm lớn nhất của KM đang hoạt động; bằng nhau lấy KM kết thúc sớm hơn
;WITH UngVien AS (
    SELECT p.MaSanPham, p.GiaBan, pm.MaKhuyenMai, pm.NgayKetThuc,
           CASE WHEN pm.LoaiGiam = 'PHAN_TRAM' THEN ROUND(p.GiaBan * pm.GiaTriGiam / 100, 0) ELSE pm.GiaTriGiam END AS TienGiamKm
    FROM dbo.SanPham p
    JOIN dbo.SanPhamKhuyenMai pp ON pp.MaSanPham = p.MaSanPham
    JOIN dbo.KhuyenMai pm ON pm.MaKhuyenMai = pp.MaKhuyenMai
    WHERE pm.DangHoatDong = 1 AND @At BETWEEN pm.NgayBatDau AND pm.NgayKetThuc
), TotNhat AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY MaSanPham ORDER BY TienGiamKm DESC, NgayKetThuc ASC) AS ThuHang FROM UngVien
)
SELECT @n = COUNT(*)
FROM @GiaBan e
JOIN dbo.SanPham p ON p.MaSanPham = e.MaSanPham
LEFT JOIN TotNhat b ON b.MaSanPham = p.MaSanPham AND b.ThuHang = 1
WHERE p.GiaBan - ISNULL(b.TienGiamKm, 0) <> e.GiaMongDoi OR ISNULL(b.MaKhuyenMai, 0) <> ISNULL(e.MaKmMongDoi, 0);
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
VALUES ('D', 'D01', N'Giá khuyến mãi (KM chồng nhau, KM ngừng hoạt động, KM chưa tới hạn)', CASE WHEN @n = 0 THEN 'DAT' ELSE 'KHONG_DAT' END,
        N'Số SP tính sai: ' + CAST(@n AS NVARCHAR(10)));

SELECT @n = COUNT(*) FROM (SELECT SUM(TongTien) AS s FROM dbo.DonHang WHERE TrangThai = 'DA_GIAO') x WHERE x.s = 1260872000;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
VALUES ('D', 'D02', N'Tổng doanh thu chỉ tính đơn DA_GIAO = 1.260.872.000 đ (D13)', CASE WHEN @n = 1 THEN 'DAT' ELSE 'KHONG_DAT' END, NULL);
SELECT @n = COUNT(*) FROM (
    SELECT MaSanPham FROM dbo.SanPham ORDER BY NgayTao DESC, MaSanPham DESC OFFSET 12 ROWS FETCH NEXT 12 ROWS ONLY) x;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
VALUES ('D', 'D03', N'Phân trang OFFSET/FETCH: trang 2, 12 SP/trang', CASE WHEN @n = 12 THEN 'DAT' ELSE 'KHONG_DAT' END,
        N'Số dòng trang 2: ' + CAST(@n AS NVARCHAR(10)));
SELECT @n = COUNT(*) FROM dbo.SanPham p
WHERE p.TrangThai = 'DANG_BAN' AND NOT EXISTS (SELECT 1 FROM dbo.ChiTietDonHang d JOIN dbo.DonHang o ON o.MaDonHang = d.MaDonHang
                                          WHERE d.MaSanPham = p.MaSanPham AND o.TrangThai = 'DA_GIAO');
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
VALUES ('D', 'D04', N'Có SP chưa bán được để test thống kê (D26)', CASE WHEN @n > 0 THEN 'DAT' ELSE 'KHONG_DAT' END,
        N'Số SP chưa bán: ' + CAST(@n AS NVARCHAR(10)));
SELECT @n = COUNT(*) FROM dbo.SanPham WHERE TrangThai = 'DANG_BAN' AND SoLuongTon <= 5;
INSERT @R (Phan, MaKiemTra, MoTa, KetQua, ChiTiet)
VALUES ('D', 'D05', N'Có SP tồn kho thấp (<= 5) để test Dashboard (BR35)', CASE WHEN @n > 0 THEN 'DAT' ELSE 'KHONG_DAT' END,
        N'Số SP: ' + CAST(@n AS NVARCHAR(10)));

-- ===== KẾT QUẢ
SELECT Phan, MaKiemTra, MoTa, KetQua, ChiTiet FROM @R ORDER BY STT;
SELECT COUNT(*) AS TongSo,
       SUM(CASE WHEN KetQua = 'DAT' THEN 1 ELSE 0 END) AS Dat,
       SUM(CASE WHEN KetQua = 'KHONG_DAT' THEN 1 ELSE 0 END) AS KhongDat
FROM @R;
IF EXISTS (SELECT 1 FROM @R WHERE KetQua = 'KHONG_DAT')
    PRINT N'KẾT QUẢ: CÓ KIỂM TRA THẤT BẠI - xem các dòng KHONG_DAT.';
ELSE
    PRINT N'KẾT QUẢ: TẤT CẢ KIỂM TRA ĐỀU ĐẠT.';
GO

-- ===== THAM KHẢO: báo cáo nhanh (không phải kiểm tra)
-- Doanh thu theo tháng năm 2026 (chỉ đơn DA_GIAO, theo ngày giao)
SELECT MONTH(NgayGiaoThanhCong) AS Thang, COUNT(*) AS SoDon, SUM(TongTien) AS DoanhThu
FROM dbo.DonHang WHERE TrangThai = 'DA_GIAO' AND YEAR(NgayGiaoThanhCong) = 2026
GROUP BY MONTH(NgayGiaoThanhCong) ORDER BY Thang;

-- Top 5 laptop bán chạy năm 2026 (chỉ đơn DA_GIAO)
SELECT TOP 5 p.MaSanPham, p.TenSanPham, SUM(d.SoLuong) AS SoLuongBan
FROM dbo.ChiTietDonHang d JOIN dbo.DonHang o ON o.MaDonHang = d.MaDonHang JOIN dbo.SanPham p ON p.MaSanPham = d.MaSanPham
WHERE o.TrangThai = 'DA_GIAO' AND YEAR(o.NgayGiaoThanhCong) = 2026
GROUP BY p.MaSanPham, p.TenSanPham ORDER BY SoLuongBan DESC, p.MaSanPham;

-- Đơn theo trạng thái
SELECT TrangThai, COUNT(*) AS SoDon FROM dbo.DonHang GROUP BY TrangThai;
GO
