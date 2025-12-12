package com.tourdulich.controller;

import com.tourdulich.model.KhachHang;
import com.tourdulich.model.NguoiDung;
import com.tourdulich.dao.KhachHangDAO;
import com.tourdulich.dao.impl.KhachHangDAOImpl;
import com.tourdulich.service.AuthService;
import com.tourdulich.service.impl.AuthServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(LoginServlet.class);
    
    private final AuthService authService = new AuthServiceImpl();
    private final KhachHangDAO khachHangDAO = new KhachHangDAOImpl();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String tendangnhap = request.getParameter("tendangnhap");
        String matkhau = request.getParameter("matkhau");
        
        if (tendangnhap == null || tendangnhap.trim().isEmpty() || 
            matkhau == null || matkhau.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin");
            request.setAttribute("tendangnhap", tendangnhap);
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }
        
        Optional<NguoiDung> nguoiDungOpt = authService.login(tendangnhap, matkhau);
        
        if (nguoiDungOpt.isPresent()) {
            NguoiDung nguoiDung = nguoiDungOpt.get();
            
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", nguoiDung);
            session.setMaxInactiveInterval(30 * 60);
            
            logger.info("Đăng nhập thành công: {} - Role: {}", nguoiDung.getTendangnhap(), nguoiDung.getRole());
            
            if (nguoiDung.getRole() == NguoiDung.Role.CUSTOMER) {
                Optional<KhachHang> khachHangOpt = khachHangDAO.findByNguoiDungId(nguoiDung.getId());
                if (khachHangOpt.isPresent()) {
                    session.setAttribute("khachHang", khachHangOpt.get());
                    logger.info("Đã lưu khachHang vào session: ID={}", khachHangOpt.get().getId());
                } else {
                    logger.warn("Không tìm thấy KhachHang cho NguoiDung ID: {}", nguoiDung.getId());
                    KhachHang newKhachHang = new KhachHang();
                    newKhachHang.setMakhachhang("KH" + System.currentTimeMillis());
                    newKhachHang.setNguoidungId(nguoiDung.getId());
                    Long khachHangId = khachHangDAO.save(newKhachHang);
                    if (khachHangId != null) {
                        newKhachHang.setId(khachHangId);
                        session.setAttribute("khachHang", newKhachHang);
                        logger.info("Đã tạo mới và lưu khachHang vào session: ID={}", khachHangId);
                    }
                }
            }
            
            if (nguoiDung.getRole() == NguoiDung.Role.ADMIN) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
                if (redirectUrl != null) {
                    session.removeAttribute("redirectAfterLogin");
                    response.sendRedirect(redirectUrl);
                } else {
                    response.sendRedirect(request.getContextPath() + "/");
                }
            }
        } else {
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng");
            request.setAttribute("tendangnhap", tendangnhap);
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }
}



