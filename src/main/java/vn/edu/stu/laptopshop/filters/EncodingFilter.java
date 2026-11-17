package vn.edu.stu.laptopshop.filters;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import java.io.IOException;

/**
 * Đặt mã hóa UTF-8 cho mọi request / response (NF08).
 *
 * <p>Quan trọng với form gửi bằng POST: nếu không đặt UTF-8 trước khi đọc tham số,
 * tên danh mục / thương hiệu có dấu (VD: "Đồ họa") sẽ bị lỗi font khi lưu vào CSDL.</p>
 * <p>Dùng chung cho cả phần Admin và phần User.</p>
 */
@WebFilter("/*")
public class EncodingFilter implements Filter {

    private static final String UTF8 = "UTF-8";

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        // Chỉ đặt khi trình duyệt chưa khai báo mã hóa, và phải đặt TRƯỚC khi đọc bất kỳ tham số nào
        if (request.getCharacterEncoding() == null) {
            request.setCharacterEncoding(UTF8);
        }
        response.setCharacterEncoding(UTF8);
        chain.doFilter(request, response);
    }
}
