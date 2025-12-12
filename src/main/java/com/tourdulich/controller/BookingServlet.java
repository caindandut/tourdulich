package com.tourdulich.controller;

import com.tourdulich.dao.KhachHangDAO;
import com.tourdulich.dao.KhachSanDAO;
import com.tourdulich.dao.impl.KhachHangDAOImpl;
import com.tourdulich.dao.impl.KhachSanDAOImpl;
import com.tourdulich.model.DatTour;
import com.tourdulich.model.KhachHang;
import com.tourdulich.model.KhachSan;
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
import java.util.Optional;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(BookingServlet.class);
    
    private final TourService tourService = new TourServiceImpl();
    private final BookingService bookingService = new BookingServiceImpl();
    private final KhachHangDAO khachHangDAO = new KhachHangDAOImpl();
    private final KhachSanDAO khachSanDAO = new KhachSanDAOImpl();
    
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
                String hotelIdParam = request.getParameter("hotelId");
                
                request.setAttribute("selectedSoNguoi", soNguoiParam);
                request.setAttribute("selectedSoPhong", soPhongParam);
                request.setAttribute("selectedNgayDi", ngayDiParam);
                request.setAttribute("selectedNgayVe", ngayVeParam);
                request.setAttribute("selectedHotelId", hotelIdParam);
                
                // Lấy thông tin khách sạn nếu có
                KhachSan selectedHotel = null;
                if (hotelIdParam != null && !hotelIdParam.isEmpty()) {
                    try {
                        Long hotelId = Long.parseLong(hotelIdParam);
                        Optional<KhachSan> hotelOpt = khachSanDAO.findById(hotelId);
                        if (hotelOpt.isPresent()) {
                            selectedHotel = hotelOpt.get();
                            request.setAttribute("selectedHotel", selectedHotel);
                        }
                    } catch (NumberFormatException e) {
                        logger.warn("HotelID không hợp lệ: {}", hotelIdParam);
                    }
                }
                
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
            String soPhongStr = request.getParameter("soPhong");
            int soPhong = 1; 
            if (soPhongStr != null && !soPhongStr.isEmpty()) {
                try {
                    soPhong = Integer.parseInt(soPhongStr);
                } catch (NumberFormatException e) {
                    logger.warn("Số phòng không hợp lệ: {}, sử dụng mặc định 1", soPhongStr);
                }
            }
            String ngayKhoihanhStr = request.getParameter("ngayKhoihanh");
            String ngayVeStr = request.getParameter("ngayve");
            String hotelIdStr = request.getParameter("hotelId");
            String ghichu = request.getParameter("ghichu");
            
            logger.info("TourID: {}, SoLuong: {}, SoPhong: {}, NgayKhoihanh: {}, HotelID: {}", tourId, soLuongNguoi, soPhong, ngayKhoihanhStr, hotelIdStr);
            
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
            LocalDate ngayVe = null;
            if (ngayKhoihanhStr != null && !ngayKhoihanhStr.isEmpty()) {
                ngayKhoihanh = LocalDate.parse(ngayKhoihanhStr);
                logger.info("Ngày khởi hành parsed: {}", ngayKhoihanh);
            }
            if (ngayVeStr != null && !ngayVeStr.isEmpty()) {
                ngayVe = LocalDate.parse(ngayVeStr);
                logger.info("Ngày về parsed: {}", ngayVe);
            }
            
            // Tính số đêm
            int soDem = 1;
            if (ngayKhoihanh != null && ngayVe != null) {
                long daysBetween = java.time.temporal.ChronoUnit.DAYS.between(ngayKhoihanh, ngayVe);
                soDem = (int) Math.max(1, daysBetween);
            } else if (tour.getThoiluong() != null) {
                // Nếu không có ngày cụ thể, tính từ thoiluong
                try {
                    String numStr = tour.getThoiluong().replaceAll("[^0-9]", " ").trim().split("\\s+")[0];
                    int days = Integer.parseInt(numStr);
                    soDem = Math.max(1, days - 1); // Trừ 1 vì thường là số ngày, số đêm = số ngày - 1
                } catch (Exception e) {
                    soDem = 2; // Mặc định 2 đêm
                }
            }
            
            // Tính giá tour
            BigDecimal giaTour = tour.getGia().multiply(new BigDecimal(soLuongNguoi));
            
            // Tính giá phòng
            BigDecimal giaPhong = BigDecimal.ZERO;
            if (hotelIdStr != null && !hotelIdStr.isEmpty()) {
                try {
                    Long hotelId = Long.parseLong(hotelIdStr);
                    java.util.Optional<KhachSan> hotelOpt = khachSanDAO.findById(hotelId);
                    if (hotelOpt.isPresent()) {
                        KhachSan hotel = hotelOpt.get();
                        if (hotel.getGia() != null) {
                            giaPhong = hotel.getGia()
                                .multiply(new BigDecimal(soPhong))
                                .multiply(new BigDecimal(soDem));
                            logger.info("Giá phòng: {} × {} phòng × {} đêm = {}", 
                                hotel.getGia(), soPhong, soDem, giaPhong);
                        }
                    }
                } catch (NumberFormatException e) {
                    logger.warn("HotelID không hợp lệ: {}", hotelIdStr);
                }
            }
            
            // Tổng tiền = Giá tour + Giá phòng
            BigDecimal tongTien = giaTour.add(giaPhong);
            logger.info("Tổng tiền: Giá tour ({} × {}) + Giá phòng = {}", 
                tour.getGia(), soLuongNguoi, tongTien);
            
            DatTour datTour = new DatTour();
            datTour.setKhachhangId(khachHang.getId());
            datTour.setTourId(tourId);
            datTour.setSoLuongNguoi(soLuongNguoi);
            datTour.setSoPhong(soPhong);
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


