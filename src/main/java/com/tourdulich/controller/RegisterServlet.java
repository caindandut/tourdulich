package com.tourdulich.controller;

import com.tourdulich.service.AuthService;
import com.tourdulich.service.impl.AuthServiceImpl;
import com.tourdulich.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    private final AuthService authService = new AuthServiceImpl();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String tendangnhap = request.getParameter("tendangnhap");
        String matkhau = request.getParameter("matkhau");
        String matkhauConfirm = request.getParameter("matkhauConfirm");
        String hotennguoidung = request.getParameter("hotennguoidung");
        String email = request.getParameter("email");
        String sdt = request.getParameter("sdt");
        String diachi = request.getParameter("diachi");
        
        StringBuilder errors = new StringBuilder();
        
        if (!ValidationUtil.isValidUsername(tendangnhap)) {
            errors.append("Username phải từ 4-20 ký tự, chỉ chứa chữ, số và gạch dưới. ");
        }
        
        if (!ValidationUtil.isValidPassword(matkhau)) {
            errors.append("Mật khẩu phải có ít nhất 6 ký tự. ");
        }
        
        if (!matkhau.equals(matkhauConfirm)) {
            errors.append("Mật khẩu xác nhận không khớp. ");
        }
        
        if (!ValidationUtil.isValidEmail(email)) {
            errors.append("Email không hợp lệ. ");
        }
        
        if (!ValidationUtil.isNotEmpty(hotennguoidung)) {
            errors.append("Họ tên không được để trống. ");
        }
        
        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString());
            request.setAttribute("tendangnhap", tendangnhap);
            request.setAttribute("hotennguoidung", hotennguoidung);
            request.setAttribute("email", email);
            request.setAttribute("sdt", sdt);
            request.setAttribute("diachi", diachi);
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }
        
        if (authService.isUsernameExists(tendangnhap)) {
            request.setAttribute("error", "Tên đăng nhập đã tồn tại");
            request.setAttribute("hotennguoidung", hotennguoidung);
            request.setAttribute("email", email);
            request.setAttribute("sdt", sdt);
            request.setAttribute("diachi", diachi);
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }
        
        if (authService.isEmailExists(email)) {
            request.setAttribute("error", "Email đã được sử dụng");
            request.setAttribute("tendangnhap", tendangnhap);
            request.setAttribute("hotennguoidung", hotennguoidung);
            request.setAttribute("sdt", sdt);
            request.setAttribute("diachi", diachi);
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }
        
        Long nguoidungId = authService.register(tendangnhap, matkhau, hotennguoidung, email, sdt, diachi);
        
        if (nguoidungId != null) {
            response.sendRedirect(request.getContextPath() + "/login?success=register");
        } else {
            request.setAttribute("error", "Đăng ký thất bại, vui lòng thử lại");
            request.setAttribute("tendangnhap", tendangnhap);
            request.setAttribute("hotennguoidung", hotennguoidung);
            request.setAttribute("email", email);
            request.setAttribute("sdt", sdt);
            request.setAttribute("diachi", diachi);
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }
}



