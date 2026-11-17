package vn.edu.stu.laptopshop.utils;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Lớp dùng chung để mở kết nối tới SQL Server (database CuaHangLaptop).
 *
 * <p>Cấu hình đọc từ file {@code src/main/resources/db.properties}
 * (khi đóng gói nằm ở {@code WEB-INF/classes/db.properties}).
 * Kết nối dùng Windows Authentication: {@code integratedSecurity=true}, không có mật khẩu trong mã nguồn (NF02).
 * Windows Authentication cần file DLL native {@code mssql-jdbc_auth-<phiên bản>.x64.dll}
 * cùng phiên bản với driver, nằm trong một thư mục thuộc biến môi trường PATH.</p>
 *
 * <p>Cách dùng (luôn đóng kết nối bằng try-with-resources):</p>
 * <pre>
 * try (Connection con = DBContext.getConnection()) { ... }
 * </pre>
 */
public final class DBContext {

    private static final String FILE_CAU_HINH = "db.properties";
    private static final String TEN_LOP_DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";

    /** Chuỗi kết nối, chỉ tạo một lần ở lần gọi đầu tiên. */
    private static String url;

    private DBContext() {
        // Lớp tiện ích, không tạo đối tượng
    }

    /**
     * Mở một kết nối mới tới SQL Server.
     *
     * @return kết nối đang mở; người gọi có trách nhiệm đóng
     * @throws SQLException khi thiếu cấu hình, thiếu driver hoặc SQL Server từ chối kết nối
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(layUrl());
    }

    /**
     * Trả về chuỗi kết nối (không chứa mật khẩu vì dùng Windows Authentication).
     * Dùng để hiển thị ở trang kiểm tra kết nối.
     */
    public static String layUrl() throws SQLException {
        synchronized (DBContext.class) {
            if (url == null) {
                String u = taoUrl(docCauHinh());
                napDriver();
                url = u;   // chỉ ghi nhớ khi cả cấu hình và driver đều hợp lệ
            }
            return url;
        }
    }

    /** Đọc file db.properties trong classpath. */
    private static Properties docCauHinh() throws SQLException {
        Properties p = new Properties();
        try (InputStream in = DBContext.class.getClassLoader().getResourceAsStream(FILE_CAU_HINH)) {
            if (in == null) {
                throw new SQLException("Không tìm thấy file " + FILE_CAU_HINH
                        + " trong classpath. Hãy sao chép db.properties.example thành db.properties"
                        + " trong thư mục src/main/resources rồi build lại.");
            }
            p.load(in);
        } catch (IOException e) {
            throw new SQLException("Không đọc được file " + FILE_CAU_HINH + ": " + e.getMessage(), e);
        }
        return p;
    }

    /** Ghép chuỗi kết nối JDBC từ các khóa trong db.properties. */
    private static String taoUrl(Properties p) throws SQLException {
        String server = batBuoc(p, "db.server");
        String port = batBuoc(p, "db.port");
        String dbName = batBuoc(p, "db.name");
        String encrypt = p.getProperty("db.encrypt", "true").trim();
        String trustCert = p.getProperty("db.trustServerCertificate", "false").trim();

        if (!port.matches("\\d{1,5}")) {
            throw new SQLException("Giá trị db.port không hợp lệ: " + port);
        }
        return "jdbc:sqlserver://" + server + ":" + port
                + ";databaseName=" + dbName
                + ";integratedSecurity=true"
                + ";encrypt=" + encrypt
                + ";trustServerCertificate=" + trustCert
                + ";applicationName=LaptopShop";
    }

    private static String batBuoc(Properties p, String khoa) throws SQLException {
        String giaTri = p.getProperty(khoa);
        if (giaTri == null || giaTri.trim().isEmpty()) {
            throw new SQLException("Thiếu cấu hình bắt buộc '" + khoa + "' trong " + FILE_CAU_HINH);
        }
        return giaTri.trim();
    }

    /**
     * Nạp lớp driver. Ứng dụng web chạy trong Tomcat nên nạp tường minh
     * để chắc chắn driver trong WEB-INF/lib được đăng ký.
     */
    private static void napDriver() throws SQLException {
        try {
            Class.forName(TEN_LOP_DRIVER);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Không tìm thấy JDBC Driver " + TEN_LOP_DRIVER
                    + ". Kiểm tra dependency mssql-jdbc trong pom.xml.", e);
        }
    }
}
