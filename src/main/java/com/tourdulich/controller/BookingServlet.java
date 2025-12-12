package com.tourdulich.controller;

import com.tourdulich.dao.KhachHangDAO;
import com.tourdulich.dao.impl.KhachHangDAOImpl;
import com.tourdulich.model.DatTour;
import com.tourdulich.model.KhachHang;
import com.tourdulich.model.NguoiDung;
import com.tourdulich.model.Tour;
import com.tourdulich.service.BookingService;
import com.tourdulich.service.TourService;
import com.tourdulich.service.impl.BookingServiceImpl;
import com.tourdulich.service.impl.TourServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Optional;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(BookingServlet.class);
    
    private final TourService tourService = new TourServiceImpl();
    private final BookingService bookingService = new BookingServiceImpl();
    private final KhachHangDAO khachHangDAO = new KhachHangDAOImpl();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        NguoiDung currentUser = (NguoiDung) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=booking&tourId=" 
                + request.getParameter("tourId"));
            return;
        }
        
        if (currentUser.getRole() != NguoiDung.Role.CUSTOMER) {
            response.sendRedirect(request.getContextPath() + "/home?error=customer_only");
            return;
        }
        
        String tourIdParam = request.getParameter("tourId");
        if (tourIdParam == null || tourIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home?error=missing_tour");
            return;
        }
        
        try {
            Long tourId = Long.parseLong(tourIdParam);
            Optional<Tour> tourOpt = tourService.getTourById(tourId);
            
            if (tourOpt.isPresent()) {
                Tour tour = tourOpt.get();
                
                String soNguoiParam = request.getParameter("soNguoi");
                String soPhongParam = request.getParameter("soPhong");
                String ngayDiParam = request.getParameter("ngaydi");
                String ngayVeParam = request.getParameter("ngayve");
                
                request.setAttribute("selectedSoNguoi", soNguoiParam);
                request.setAttribute("selectedSoPhong", soPhongParam);
                request.setAttribute("selectedNgayDi", ngayDiParam);
                request.setAttribute("selectedNgayVe", ngayVeParam);
                
                KhachHang khachHang = (KhachHang) session.getAttribute("khachHang");
                
                request.setAttribute("tour", tour);
                request.setAttribute("khachHang", khachHang);
                
                request.getRequestDispatcher("/WEB-INF/views/booking.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/home?error=tour_not_found");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home?error=invalid_tour_id");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        NguoiDung currentUser = (NguoiDung) session.getAttribute("currentUser");
        KhachHang khachHang = (KhachHang) session.getAttribute("khachHang");
        
        logger.info("=== BẮT ĐẦU XỬ LÝ ĐẶT TOUR ===");
        logger.info("CurrentUser: {}", currentUser != null ? currentUser.getTendangnhap() : "NULL");
        logger.info("KhachHang trong session: {}", khachHang != null ? khachHang.getId() : "NULL");
        
        if (currentUser == null) {
            logger.error("Chưa đăng nhập");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        if (khachHang == null) {
            logger.warn("KhachHang chưa có trong session, đang tìm...");
            java.util.Optional<KhachHang> khachHangOpt = khachHangDAO.findByNguoiDungId(currentUser.getId());
            if (khachHangOpt.isPresent()) {
                khachHang = khachHangOpt.get();
                session.setAttribute("khachHang", khachHang);
                logger.info("Đã tìm thấy và lưu KhachHang vào session: ID={}", khachHang.getId());
            } else {
                logger.info("Tạo mới KhachHang cho NguoiDung ID: {}", currentUser.getId());
                khachHang = new KhachHang();
                khachHang.setMakhachhang("KH" + System.currentTimeMillis());
                khachHang.setNguoidungId(currentUser.getId());
                Long khachHangId = khachHangDAO.save(khachHang);
                if (khachHangId != null) {
                    khachHang.setId(khachHangId);
                    session.setAttribute("khachHang", khachHang);
                    logger.info("Đã tạo mới KhachHang: ID={}", khachHangId);
                } else {
                    logger.error("Không thể tạo KhachHang!");
                    response.sendRedirect(request.getContextPath() + "/home?error=system_error");
                    return;
                }
            }
        }
        
        try {
            Long tourId = Long.parseLong(request.getParameter("tourId"));
            int soLuongNguoi = Integer.parseInt(request.getParameter("soLuongNguoi"));
            String ngayKhoihanhStr = request.getParameter("ngayKhoihanh");
            String ghichu = request.getParameter("ghichu");
            
            logger.info("TourID: {}, SoLuong: {}, NgayKhoihanh: {}", tourId, soLuongNguoi, ngayKhoihanhStr);
            
            if (soLuongNguoi <= 0) {
                logger.warn("Số lượng người không hợp lệ: {}", soLuongNguoi);
                response.sendRedirect(request.getContextPath() + "/booking?tourId=" + tourId 
                    + "&error=invalid_quantity");
                return;
            }
            
            Optional<Tour> tourOpt = tourService.getTourById(tourId);
            if (!tourOpt.isPresent()) {
                logger.error("Không tìm thấy tour với ID: {}", tourId);
                response.sendRedirect(request.getContextPath() + "/home?error=tour_not_found");
                return;
            }
            
            Tour tour = tourOpt.get();
            logger.info("Tìm thấy tour: {} - Giá: {}", tour.getTentour(), tour.getGia());
            
            LocalDate ngayKhoihanh = null;
            if (ngayKhoihanhStr != null && !ngayKhoihanhStr.isEmpty()) {
                ngayKhoihanh = LocalDate.parse(ngayKhoihanhStr);
                logger.info("Ngày khởi hành parsed: {}", ngayKhoihanh);
            }
            
            BigDecimal tongTien = tour.getGia().multiply(new BigDecimal(soLuongNguoi));
            logger.info("Tổng tiền tính được: {}", tongTien);
            
            DatTour datTour = new DatTour();
            datTour.setKhachhangId(khachHang.getId());
            datTour.setTourId(tourId);
            datTour.setSoLuongNguoi(soLuongNguoi);
            datTour.setTongtien(tongTien);
            datTour.setNgayKhoihanh(ngayKhoihanh != null ? ngayKhoihanh.atStartOfDay() : null);
            datTour.setGhichu(ghichu);
            datTour.setTinhtrang(DatTour.TinhTrang.PENDING);
            
            logger.info("Đối tượng DatTour đã tạo: KhachHangID={}, TourID={}, SoLuong={}, TongTien={}", 
                datTour.getKhachhangId(), datTour.getTourId(), datTour.getSoLuongNguoi(), datTour.getTongtien());
            
            logger.info("Đang gọi bookingService.createBooking()...");
            Long bookingId = bookingService.createBooking(datTour, tour);
            
            if (bookingId != null) {
                logger.info("✅ ĐẶT TOUR THÀNH CÔNG! BookingID: {}", bookingId);
                session.setAttribute("bookingSuccess", "true");
                session.setAttribute("bookingId", bookingId);
                session.setAttribute("lastBookedTour", tour);
                datTour.setId(bookingId);
                session.setAttribute("lastBooking", datTour);
                response.sendRedirect(request.getContextPath() + "/booking/success");
            } else {
                logger.error("❌ ĐẶT TOUR THẤT BẠI! createBooking() trả về NULL");
                session.setAttribute("bookingError", "booking_failed");
                response.sendRedirect(request.getContextPath() + "/booking?tourId=" + tourId 
                    + "&error=booking_failed");
            }
            
        } catch (NumberFormatException e) {
            logger.error("Lỗi parse số: {}", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/home?error=invalid_data");
        } catch (Exception e) {
            logger.error("❌ LỖI HỆ THỐNG KHI ĐẶT TOUR:", e);
            session.setAttribute("bookingError", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/home?error=system_error");
        }
    }
}


