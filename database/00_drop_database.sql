/* =====================================================================
   LaptopShop - 00_drop_database.sql
   XÓA HOÀN TOÀN database CuaHangLaptop (dùng khi cần tạo lại từ đầu).
   CẢNH BÁO: mất toàn bộ dữ liệu. Không chạy trên môi trường có dữ liệu thật.
   ===================================================================== */
USE master;
GO

IF DB_ID(N'CuaHangLaptop') IS NOT NULL
BEGIN
    -- Ngắt các kết nối đang mở (VD: Tomcat, SSMS) rồi xóa
    ALTER DATABASE CuaHangLaptop SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE CuaHangLaptop;
    PRINT N'Đã xóa database CuaHangLaptop.';
END
ELSE
    PRINT N'Database CuaHangLaptop không tồn tại, không cần xóa.';
GO
