# DEVELOPMENT_PROGRESS – LaptopShop

Cập nhật: 15/11/2026
Thư mục dự án: `F:\STUWeb\LaptopStore`
Thực hiện: nhóm 2 người (D25 cập nhật 13/11/2026) – tài liệu này theo dõi phần **Admin + công việc chung**; phần User do thành viên còn lại phụ trách.
Quản lý mã nguồn: **chưa dùng Git** cho đến khi nhóm thống nhất (D17 tạm hoãn).

## Đã hoàn thành (đã kiểm tra)

- [x] **GĐ1 – Phân tích yêu cầu** (`docs/PROJECT_REQUIREMENTS.md` v1.1) – xác nhận 13/11/2026.
  - 13 chức năng phía khách, 12 chức năng Admin, 6 chức năng hệ thống; 25 Use Case; 13 Activity Diagram; BR01–BR37; NF01–NF12; D01–D26; P01–P13.

## Đang thực hiện

- [ ] **GĐ2 – Thiết kế CSDL** – đã có đủ file, **chờ chạy trên SQL Server thật + xác nhận**.
  - `docs/DATABASE_DESIGN.md`, `docs/ERD.md`
  - `database/00_drop_database.sql`, `01_create_database.sql`, `02_seed_data.sql`, `03_integrity_check.sql`
  - 15 bảng, 17 FK, 15 UNIQUE + 1 filtered unique index, 67 CHECK, 23 index.
  - Dữ liệu mẫu: 46 laptop, 13 tài khoản, 44 đơn hàng (12/2025 → 11/2026), 31 đánh giá, 6 khuyến mãi.
  - Đã kiểm tra trong môi trường phát triển: dữ liệu mẫu đạt mọi quy tắc, mô phỏng `LIKE`/độ dài cột, parser T-SQL 0 lỗi, ERD vẽ được.
  - 13/11/2026: database `CuaHangLaptop` **đã có trên máy thật** (SQL Server 2022, 16.0.1220.3) với đủ 15 bảng (ảnh chụp SSMS).
  - 13/11/2026 – T0 đã xác minh trên DB thật: cột của `DanhMuc` (6) và `ThuongHieu` (7) khớp thiết kế; 2 khóa ngoại `FK_SanPham_DanhMuc`, `FK_SanPham_ThuongHieu` đều NO_ACTION; 5 danh mục (14/14/5/9/4 SP) và 7 thương hiệu (7/7/9/8/5/5/5 SP) = 46 SP, khớp dữ liệu mẫu.
  - **Chưa kiểm tra:** kết quả `03_integrity_check.sql` (không bắt buộc cho Nhiệm vụ 2).
  - 13/11/2026: đổi toàn bộ tên trong DB sang tiếng Việt không dấu (DB10 / D27): database `CuaHangLaptop`, 15 bảng, 105 cột, ràng buộc, index, mã trạng thái. Đã kiểm tra lại: không còn tên tiếng Anh (trừ `Email`, `Webcam` giữ chủ ý), cột trong INSERT/UPDATE khớp bảng, parser T-SQL 0 lỗi, dữ liệu mẫu đạt mọi quy tắc, ERD vẽ được.
  - Chờ xác nhận các quyết định DB01–DB09 (`DATABASE_DESIGN.md` mục 8).

- [ ] **Nhiệm vụ 2 (giảng viên) – phần Admin:** quản lý 4 bảng danh mục `DanhMuc`, `ThuongHieu`, `BoXuLy`, `CardDoHoa` (xem, thêm, sửa, xóa khi không vi phạm ràng buộc) + hàm DAO lấy dữ liệu combo box (D33, D34). Kế hoạch: T9.0 WebUtil → T9.1 combo DanhMuc → T10 ThuongHieu → T11 BoXuLy → T12 CardDoHoa → T13 kiểm thử tổng hợp. T0 (xác minh DB) ✅. Kế hoạch đã duyệt 13/11/2026 (kèm 4 điều chỉnh).
  - **T1 – Khởi tạo project Maven:** đã viết `pom.xml`, `web.xml`, 6 `package-info.java`.
    - Kiểm tra tĩnh: XML hợp lệ ✅; `mvn validate` (đọc cấu trúc pom) ✅; `javac --release 17` các file Java ✅.
    - Biên dịch Maven đầy đủ: ✅ **BUILD SUCCESS trên máy thật** (14/11/2026, Maven 3.8.3, JDK 17.0.18, Windows 11) → tạo `target\laptopshop.war`. Lần chạy đầu bằng Command Prompt thường bị lỗi `Error while storing the mojo status ... inputFiles.lst`; chạy lại bằng Command Prompt quyền Administrator thì thành công (nguyên nhân chưa xác định chính xác, nghi do quyền ghi thư mục `target`).
  - **T2 – Kết nối DB (Windows Authentication):** đã viết `db.properties.example`, `db.properties`, `utils/DBContext.java`, `controllers/admin/KiemTraKetNoiServlet.java` (trang tạm `/admin/kiem-tra-ket-noi`, chỉ SELECT).
    - Kiểm tra tĩnh: biên dịch bằng stub Servlet API ✅; chạy thử đọc cấu hình → URL đúng, báo lỗi rõ khi thiếu file / thiếu driver ✅.
    - Biên dịch thật + chạy trên Tomcat 10.1.61: ✅ (14/11/2026).
    - **Kết nối DB thật: ✅** trang `/admin/kiem-tra-ket-noi` báo KẾT NỐI THÀNH CÔNG: Microsoft JDBC Driver 13.6.2.0, database `CuaHangLaptop`, đăng nhập Windows `DESKTOP-M0ORI1B\DELL`, SQL Server 16.0.1220.3, DanhMuc = 5, ThuongHieu = 7 (khớp DB). Ảnh chụp màn hình do chủ dự án cung cấp.
    - Trang kiểm tra kết nối là trang tạm (D29): cần xóa hoặc bảo vệ bằng đăng nhập trước khi triển khai thật.
  - **T3 – EncodingFilter + layout Admin:** đã viết `filters/EncodingFilter.java`, `views/admin/layout/header.jspf`, `footer.jspf` (Bootstrap 5.3.3 CDN, menu Danh mục / Thương hiệu, vùng thông báo flash); chuyển trang kiểm tra kết nối sang `views/admin/kiem-tra-ket-noi.jsp` dùng layout; `web.xml` thêm `*.jspf` vào nhóm UTF-8.
    - Kiểm tra tĩnh: biên dịch Java bằng stub ✅; `web.xml` hợp lệ ✅; cân bằng thẻ JSTL/HTML sau khi ghép layout ✅. JSP chưa được Jasper biên dịch (chỉ có trên Tomcat).
    - Chạy thật trên Tomcat: ✅ (14/11/2026, ảnh chụp) – JSP biên dịch được, layout hiển thị đúng (menu, nhãn môi trường phát triển, bảng Bootstrap), tiếng Việt đúng, kết nối vẫn thành công.
    - Chưa có bằng chứng: menu thu gọn trên màn hình nhỏ, lỗi 404 mong đợi khi bấm Danh mục / Thương hiệu. Hiệu lực EncodingFilter với form POST kiểm chứng ở T6.
  - **T4 – Entity + DAO DanhMuc:** đã đối chiếu cấu trúc bảng thật (6 cột, PK/UQ/CK/DF – ảnh SSMS 14/11/2026) rồi viết `entities/DanhMuc.java`, `dao/DanhMucDAO.java` (timKiem + phân trang OFFSET/FETCH, demTimKiem, timTheoMa, tonTaiTen, tonTaiDuongDan, demSanPham, them, capNhat, xoa). Thêm phần kiểm tra hàm ĐỌC của DAO vào trang tạm `/admin/kiem-tra-ket-noi` (12 kiểm tra, chỉ SELECT).
    - Kiểm tra tĩnh: biên dịch bằng stub ✅; parser T-SQL 8/8 câu lệnh ✅; mọi cột dùng trong SQL có trong DB thật ✅; hàm thoát ký tự LIKE chạy đúng ✅.
    - Biên dịch thật + chạy thật các hàm ĐỌC: ✅ (14/11/2026, ảnh chụp) – 11/11 kiểm tra ĐẠT; dữ liệu trang 1: 5 danh mục, 14+14+5+9+4 = 46 SP, ngày tạo 01/11/2025 08:00 khớp dữ liệu mẫu. Đã xác nhận: phân trang OFFSET/FETCH, tìm không phân biệt hoa thường, thoát ký tự LIKE, chuỗi SQL Injection không có tác dụng, kiểm tra trùng tên khi thêm / khi sửa.
    - Các hàm GHI (them, capNhat, xoa): chưa kiểm thử – sẽ kiểm thử thật qua giao diện ở T6–T8.
  - **T5 – Danh sách danh mục:** đã viết `controllers/admin/DanhMucServlet.java` (`/admin/danh-muc/*`, hiện chỉ xử lý GET danh sách; đường dẫn con khác trả 404) và `views/admin/danhmuc/list.jsp` (bảng, tìm theo tên, phân trang 10 dòng, thông báo khi rỗng / lỗi DB; nút Thêm / Sửa / Xóa hiển thị nhưng vô hiệu hóa chờ T6–T8).
    - Kiểm tra tĩnh: biên dịch bằng stub ✅; cân bằng thẻ JSP ✅; mọi thuộc tính `dm.*` có getter ✅; mọi biến JSP đều được Servlet đặt ✅.
    - Chạy thật (14/11/2026, ảnh chụp): ✅ #1 danh sách 5 danh mục (14/14/5/9/4 SP, menu Danh mục tô sáng, không có thanh phân trang); ✅ #3 tìm "đồ họa" (chữ thường, có dấu) → 1 dòng "Đồ họa - Kỹ thuật", URL `tuKhoa=đồ+họa`, nút "Xóa bộ lọc" hiện.
    - #2, #4, #5, #6, #7: chủ dự án **xác nhận T5** (14/11/2026) nhưng không gửi kết quả chi tiết → ghi nhận là "xác nhận chung", chưa có bằng chứng riêng. Giao diện phân trang chưa kiểm chứng (chỉ 5 danh mục < 10).
  - **T6 – Thêm danh mục:** đã viết `utils/SlugUtil.java` (tạo đường dẫn không dấu, kiểm tra định dạng), `views/admin/danhmuc/form.jsp`; sửa `DanhMucServlet` (thêm GET/POST `/admin/danh-muc/them`, kiểm tra dữ liệu, kiểm tra trùng, bắt lỗi SQL 2627/2601/547, Post/Redirect/Get + thông báo flash); sửa `list.jsp` (bật nút "+ Thêm danh mục").
    - Kiểm tra tĩnh: biên dịch bằng stub ✅; cân bằng thẻ JSP ✅; tên ô form khớp tham số Servlet ✅.
    - Chạy thử không cần DB: SlugUtil 8/8 ví dụ + 10 ca định dạng ✅; đọc form + kiểm tra dữ liệu 9 ca (rỗng, 1 ký tự, 101 ký tự, URL sai, URL viết hoa, tên toàn ký hiệu, mô tả 501 ký tự, bỏ chọn hoạt động) ✅.
    - **Ghi DB thật ✅** (14/11/2026, ảnh SSMS + ảnh danh sách): ca A thêm "Học sinh - Sinh viên" → `MaDanhMuc` 6, `hoc-sinh-sinh-vien`, mô tả đúng dấu, `DangHoatDong` 1, `NgayTao` 2026-11-14 23:17:55 do DB tự sinh; danh sách 6 dòng, 0 SP. → **EncodingFilter với form POST đã kiểm chứng** (tiếng Việt lưu đúng).
    - SSMS chỉ có 6 dòng → các ca lỗi C–F không ghi vào DB ✅.
    - Ca B (F5 không thêm trùng), C (tên rỗng), D (trùng tên "gaming"), E (URL sai định dạng), F (trùng URL): chủ dự án báo "ok hết" – không kèm ảnh. Khung thông báo xanh sau khi thêm chưa có trong ảnh chụp.
    - Dữ liệu kiểm thử còn lại trong DB: danh mục mã 6 "Học sinh - Sinh viên" (dùng cho T7 sửa, T8 xóa).
  - **T7 – Sửa danh mục:** sửa `DanhMucServlet` (GET/POST `/admin/danh-muc/sua`; gom kiểm tra trùng + xử lý lỗi SQL thành hàm dùng chung cho thêm/sửa; mã sai / không tồn tại → về danh sách kèm thông báo lỗi), `form.jsp` (dùng chung 2 chế độ, khi sửa hiện mã / ngày tạo / số SP chỉ đọc, gửi mã bằng ô ẩn), `list.jsp` (bật nút Sửa).
    - Kiểm tra tĩnh: biên dịch bằng stub ✅; cân bằng thẻ JSP ✅.
    - Chạy thử không cần DB: hồi quy T6 (SlugUtil 8/8, kiểm tra form 9 ca) ✅; 6 ca mã sai (thiếu, `abc`, `0`, `-3`, POST thiếu / sai mã) → chuyển về danh sách kèm thông báo lỗi ✅; `/xoa` và đường dẫn lạ → 404 ✅.
    - **Cập nhật DB thật ✅** (14/11/2026, ảnh SSMS + danh sách): mã 6 → tên "Sinh viên - Học sinh", mô tả "(đã sửa)", `DangHoatDong` 0 (nhãn "Ngừng hoạt động"), `NgayTao` giữ nguyên 2026-11-14 23:17:55, dòng 1–5 không đổi, vẫn 6 dòng.
    - Ca A, C (lưu không đổi → không báo trùng chính nó), D (trùng tên), E (trùng URL), G (mã 99999 / abc): chủ dự án báo "ok", không kèm ảnh. Xác nhận T7.
  - **T8 – Xóa danh mục:** sửa `DanhMucServlet` (POST `/admin/danh-muc/xoa`; GET `/xoa` → 405; kiểm tra mã → kiểm tra tồn tại → đếm sản phẩm, còn SP thì từ chối và gợi ý "Ngừng hoạt động" → xóa; lỗi SQL 547 vẫn báo đúng; quay lại đúng từ khóa + trang đang xem), `list.jsp` (nút Xóa = form POST + hộp thoại xác nhận, tên danh mục đọc từ thuộc tính data đã escape).
    - Kiểm tra tĩnh: biên dịch bằng stub ✅; cân bằng thẻ JSP ✅.
    - Chạy thử không cần DB: GET /xoa → 405; 4 ca mã sai → về danh sách kèm thông báo lỗi; URL quay lại mã hóa đúng từ khóa có dấu / ký tự đặc biệt ✅; hồi quy T6/T7 ✅.
    - **Xóa thật trên DB ✅** (14/11/2026, ảnh SSMS + ảnh giao diện): SSMS còn đúng 5 danh mục (mã 1–5, nguyên vẹn) → danh mục thử mã 6 đã bị xóa (ca C). Ca D: xóa "Gaming" khi đang lọc "gam" → khung đỏ "Không thể xóa … đang có 14 sản phẩm …", vẫn giữ kết quả lọc, Gaming còn nguyên.
    - Ca A, B (Cancel), E (GET /xoa → 405): chủ dự án báo "ok", không kèm ảnh. Câu `COUNT(*) FROM SanPham` (mong đợi 46) chưa có ảnh. Xác nhận T8.
  - ✅ **Quản lý DanhMuc hoàn thành chức năng** (xem + tìm + phân trang, thêm, sửa, xóa có kiểm tra ràng buộc) – đã chạy thật trên DB. Hạn chế còn lại: giao diện phân trang chưa kiểm chứng (chỉ 5 danh mục).
  - **T9.0 – Tách `utils/WebUtil.java` (D35):** chuyển `docSoNguyenDuong`, `chuanHoa`, `datThongBaoVaChuyen`, `taoUrlDanhSach` (thêm tham số đường dẫn), mã lỗi SQL 2627/2601/547 + `laLoiTrung` / `laLoiRangBuoc`, tên thuộc tính thông báo; sửa `DanhMucServlet` dùng lại (399 → 361 dòng). Hành vi không đổi.
    - Kiểm tra hồi quy không cần DB: chạy cùng bộ thử trước / sau khi tách → TestSlug, TestForm, TestSua giống hệt; TestXoa giống hệt phần kết quả (chỉ khác thứ tự in tham số đầu vào); WebUtil 7/7 + NFC + mã lỗi ✅.
    - Biên dịch thật + kiểm thử nhanh Danh mục trên Tomcat (tìm, thêm, sửa, xóa bị chặn, xóa thành công): ✅ chủ dự án báo "ok hết" (15/11/2026), không kèm ảnh.
  - **T9.1 – Combo box DanhMuc (D34):** thêm `DanhMucDAO.layDanhSachChoComboBox(Integer maLuonKem)` – chỉ danh mục đang hoạt động, sắp theo tên; `maLuonKem` để form sửa sản phẩm sau này vẫn hiện được danh mục cũ đã ngừng hoạt động. Thêm kiểm tra vào trang tạm (so với chính dữ liệu trong DB).
    - Kiểm tra tĩnh: biên dịch bằng stub ✅; parser T-SQL ✅; hồi quy TestSlug / TestForm / TestSua giống hệt ✅.
    - Chạy thật: ⏳ chờ kết quả (gộp vào lượt kiểm thử T10–T12).
  - **T9.2 – Tách `utils/SqlUtil.java`:** chuyển `chuanHoaTuKhoa`, `taoMauLike` (thoát `! % _ [`) từ DanhMucDAO sang dùng chung; thêm `WebUtil.docChuoiAscii` (cột VARCHAR), `WebUtil.docSoNguyenTrongKhoang` (cột TINYINT). Hồi quy DanhMuc không cần DB: TestSlug / TestForm / TestSua giống hệt, TestXoa giống hệt phần kết quả ✅.
  - **T10 – ThuongHieu:** `entities/ThuongHieu.java`, `dao/ThuongHieuDAO.java` (tìm theo tên, phân trang, combo `layDanhSachChoComboBox(maLuonKem)` giống DanhMuc, kiểm tra trùng tên / đường dẫn, thêm / sửa **không ghi `DuongDanLogo`** – D30, xóa), `controllers/admin/ThuongHieuServlet.java` (`/admin/thuong-hieu/*`), `views/admin/thuonghieu/list.jsp`, `form.jsp`.
  - **T11 – BoXuLy (CPU):** `entities/BoXuLy.java` (hãng Intel / AMD / Apple; số nhân 1–64; số luồng 1–128 và ≥ số nhân; xung 1–7 GHz, cho để trống), `dao/BoXuLyDAO.java` (tìm theo model / dòng chip / hãng; combo lấy tất cả – bảng không có cột trạng thái), `controllers/admin/BoXuLyServlet.java` (`/admin/cpu/*`), `views/admin/cpu/list.jsp`, `form.jsp`. Chữ có dấu bị từ chối (cột VARCHAR).
  - **T12 – CardDoHoa (GPU):** `entities/CardDoHoa.java` (hãng Intel / AMD / NVIDIA / Apple; loại TICH_HOP / ROI; VRAM 1–48), `dao/CardDoHoaDAO.java`, `controllers/admin/CardDoHoaServlet.java` (`/admin/card-do-hoa/*`; card rời bắt buộc VRAM, card tích hợp phải để trống VRAM), `views/admin/carddohoa/list.jsp`, `form.jsp`.
  - Chung T10–T12: menu Admin thêm CPU, Card đồ họa; trang tạm `/admin/kiem-tra-ket-noi` thêm kiểm tra ĐỌC cho 3 DAO mới (combo box, tổng số SP mỗi bảng = `COUNT(*) FROM SanPham`, dữ liệu GPU hiện có theo quy tắc rời/tích hợp).
    - **Cấu trúc BoXuLy, CardDoHoa lấy từ `01_create_database.sql`, CHƯA đối chiếu với DB thật** (ThuongHieu đã đối chiếu ở T0) → bước đầu lượt kiểm thử.
    - Kiểm tra tĩnh (15/11/2026): biên dịch 24 file bằng stub, `-Xlint:all` 0 cảnh báo ✅; parser T-SQL mọi câu SQL ✅; cân bằng thẻ 6 JSP mới ✅; mọi ô form khớp tham số Servlet đọc, mọi biến EL có attribute ✅.
    - Chạy thử không cần DB: 3 Servlet × (GET /xoa → 405, đường dẫn lạ → 404, mã sai → về danh sách kèm lỗi, URL quay lại giữ từ khóa có dấu) ✅; validate form 14 ca (tên rỗng, quá dài, URL sai định dạng, hãng không hợp lệ, chữ có dấu, số luồng < số nhân, xung 7.5 / "4,5", số 0 / 200 / -1 / chữ, card rời thiếu VRAM, card tích hợp có VRAM) ✅.
    - **Đối chiếu cấu trúc DB thật (15/11/2026, ảnh SSMS):** `BoXuLy` 7/7 cột khớp code (MaBoXuLy int identity; HangSanXuat varchar(20); DongChip varchar(30); TenModel varchar(50); SoNhan, SoLuongLuong tinyint; XungNhipToiDaGHz decimal(3,2) NULL); có CK_HangSanXuat, CK_SoNhan (1–64), CK_SoLuongLuong (≥ SoNhan), CK_XungNhip (cho NULL), PK, UQ_TenModel. `CardDoHoa`: thấy CK_HangSanXuat, CK_Loai ('ROI','TICH_HOP'). Dữ liệu: 16 CPU, 15 GPU, 46 SP.
      - Chưa có trong ảnh: các cột 2–5 của `CardDoHoa`, phần cuối định nghĩa CHECK (cận trên số luồng, khoảng xung nhịp, VRAM).
    - **Chạy thật T9.1 + T10–T12 (build, Tomcat, DB thật):** ✅ chủ dự án báo "chức năng test ok hết" (15/11/2026) – xác nhận chung, **không kèm ảnh từng ca**; chưa có ảnh trang `/admin/kiem-tra-ket-noi` và ảnh SSMS sau khi dọn dữ liệu thử.
    - **Trang `/admin/kiem-tra-ket-noi` (15/11/2026, ảnh chụp):** mọi dòng kiểm tra ĐẠT – T4 (12 dòng), T9.1 combo DanhMuc (5 mục, sắp đúng thứ tự tiếng Việt), ThuongHieu (7, tổng 46 SP, combo đúng 7 thương hiệu đang hoạt động, sắp theo tên), CPU (16, tổng 46 SP), Card đồ họa (15, tổng 46 SP, 0 dòng lệch quy tắc rời/tích hợp).
      - Chưa thử được: combo kèm mục **ngừng hoạt động** (`maLuonKem`) – DB hiện không có danh mục / thương hiệu nào ngừng hoạt động.
      - Phát hiện lỗi hiển thị: nhãn combo CPU "Apple Apple M3 8-core" (TenModel của Apple đã chứa tên hãng). Đã sửa `BoXuLy.getNhanComboBox()` – chỉ ghép tên hãng khi tên model chưa bắt đầu bằng tên hãng. Kiểm tra tĩnh + chạy thử 6 ca không cần DB ✅; chạy thật ⏳ chờ build lại.
  - ✅ **Nhiệm vụ 2 – phần Admin hoàn thành chức năng** (4 bảng danh mục + hàm combo box) theo xác nhận của chủ dự án. Còn lại: T13 – tài liệu ca kiểm thử + danh sách ảnh minh chứng cho báo cáo.

## Chưa thực hiện

- [ ] GĐ3 – Thiết kế kiến trúc
- [ ] GĐ4 – Backend (M00 → M14)
- [ ] GĐ5 – Frontend
- [ ] GĐ6 – Kiểm thử
- [ ] GĐ7 – Hoàn thiện (không làm file báo cáo – D24)

## Lỗi / rủi ro còn tồn tại

- T11/T12: đã đối chiếu `BoXuLy`; `CardDoHoa` mới thấy một phần (ảnh bị cắt) – chức năng chạy thật đã được báo ok nên rủi ro thấp.
- Trang tạm `/admin/kiem-tra-ket-noi` và toàn bộ trang Admin chưa có đăng nhập (D29) – chỉ dùng local.
- GĐ2: chưa chạy script trên SQL Server thật → có thể còn lỗi chỉ lộ ra khi chạy.
- C1: dùng JSTL 3.0 bản Jakarta cho Tomcat 10.1 → GĐ3.
- C2: IntelliJ Community không tích hợp Tomcat → GĐ3.
- C4: Windows Authentication cần DLL `mssql-jdbc_auth` + quyền tài khoản chạy Tomcat → GĐ3.
- C9: đã đề xuất tham số PBKDF2 (DB02), chờ xác nhận.
- C10: Gson + `LocalDateTime` trên JDK 17 → kiểm chứng ở module tìm kiếm.
- C15: file ảnh demo chưa có (DB chỉ có đường dẫn) → GĐ3.

## Quyết định kỹ thuật đã thống nhất

| Mã | Quyết định |
|---|---|
| D01 | JDK 17.0.18 |
| D02 | IntelliJ IDEA Community |
| D03 | Maven 3.8.3, đóng gói WAR |
| D04 | Apache Tomcat 10.1, `jakarta.servlet` |
| D05 | SQL Server – phiên bản có sẵn trên máy (kiểm tra ≥ 2012 bằng `03_integrity_check.sql` V01) |
| D06 | Windows Authentication |
| D07 | JSTL (bản Jakarta) + Gson; băm mật khẩu PBKDF2 của JDK |
| D08 | Mỗi cấu hình laptop là một sản phẩm riêng |
| D09 | Giỏ hàng lưu trong Database |
| D10 | Thanh toán COD + chuyển khoản ngân hàng |
| D11 | Miễn phí vận chuyển |
| D12 | Nhiều khuyến mãi cùng lúc → áp dụng mức giảm lớn nhất |
| D13 | Doanh thu chỉ tính đơn DELIVERED |
| D14 | Phải đăng nhập mới thêm vào giỏ và đặt hàng |
| D15 | Không dùng coupon |
| D16 | Trạng thái đơn: PENDING → CONFIRMED → SHIPPING → DELIVERED; CANCELLED |
| D17 | ~~Dùng Git/GitHub~~ → **Tạm hoãn**: chưa tạo repository cho đến khi nhóm thống nhất |
| D18 | Khách sửa (không xóa) đánh giá; Admin ẩn đánh giá |
| D19 | Chỉ 2 vai trò: CUSTOMER, ADMIN |
| D20 | Ảnh upload ra thư mục ngoài WebApp; DB lưu đường dẫn |
| D21 | Tối đa 5 máy / sản phẩm / đơn |
| D22 | Chuyển khoản phải PAID trước CONFIRMED; hủy đơn đã PAID → REFUNDED |
| D23 | 1 giá bán gốc; giá KM tính từ bảng khuyến mãi |
| D24 | Không làm file báo cáo đồ án |
| D25 | ~~Làm 1 mình~~ → **Nhóm 2 người**: mình phụ trách Admin + công việc chung (project, cấu hình, kết nối DB, tích hợp); thành viên còn lại phụ trách User. Không gắn mốc thời hạn |
| D26 | Thống kê bán chạy / chưa bán chỉ tính đơn DELIVERED |
| D27 | Tên database, bảng, cột, ràng buộc, mã trạng thái bằng tiếng Việt không dấu (DB `CuaHangLaptop`) |
| D28 | ~~Nhiệm vụ 2 – phần Admin chỉ gồm `DanhMuc` và `ThuongHieu`~~ → thay bằng D33 (4 bảng). Vẫn không làm phần User |
| D29 | Trang `/admin` tạm thời truy cập không cần đăng nhập, **chỉ trong môi trường phát triển local**; không phải cơ chế bảo mật, không triển khai công khai khi chưa có xác thực |
| D30 | Thương hiệu: Nhiệm vụ 2 **không** làm upload logo; form không có trường logo, `DuongDanLogo` giữ nguyên giá trị đang có |
| D31 | Package Java: `vn.edu.stu.laptopshop` (dùng chung cả nhóm) |
| D32 | Thư viện Nhiệm vụ 2: `jakarta.servlet-api` 6.0.0 (provided), JSTL API 3.0.0 + GlassFish JSTL 3.0.1, `mssql-jdbc` 13.6.2.jre11. Chưa thêm Gson (chưa cần) |
| D33 | (14/11/2026, **đã xác nhận**) Nhiệm vụ 2 – Admin: "Quản lý các bảng liên quan đến danh mục sản phẩm"; danh mục = các bảng **bên 1** dùng cho **combo box**. Truy vấn khóa ngoại thật của `SanPham` cho đúng 4 bảng: `DanhMuc`, `ThuongHieu`, `BoXuLy`, `CardDoHoa` (đều NO_ACTION). **Thay D28; bỏ DB06** (CPU/GPU nay có màn hình Admin) |
| D34 | Mỗi bảng danh mục có thêm hàm DAO dùng chung lấy dữ liệu cho combo box (dùng cho bộ lọc phía User và form sản phẩm sau này); **chỉ làm hàm DAO**, không làm giao diện User / form sản phẩm |
| D35 | Tách các hàm web dùng chung (đọc số từ tham số, chuẩn hóa chuỗi, thông báo + chuyển trang, mã lỗi SQL) sang `utils/WebUtil.java`; sửa `DanhMucServlet` dùng lại và kiểm thử lại phần Danh mục |
