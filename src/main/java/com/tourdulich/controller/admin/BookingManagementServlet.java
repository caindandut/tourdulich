package com.tourdulich.controller.admin;

import com.tourdulich.dao.DatTourDAO;
import com.tourdulich.dao.KhachHangDAO;
import com.tourdulich.dao.NguoiDungDAO;
import com.tourdulich.dao.TourDAO;
import com.tourdulich.dao.impl.DatTourDAOImpl;
import com.tourdulich.dao.impl.KhachHangDAOImpl;
import com.tourdulich.dao.impl.NguoiDungDAOImpl;
import com.tourdulich.dao.impl.TourDAOImpl;
import com.tourdulich.model.DatTour;
import com.tourdulich.model.KhachHang;
import com.tourdulich.model.NguoiDung;
import com.tourdulich.model.Tour;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/admin/bookings/*")
public class BookingManagementServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(BookingManagementServlet.class);
    
    private final DatTourDAO datTourDAO = new DatTourDAOImpl();
    private final KhachHangDAO khachHangDAO = new KhachHangDAOImpl();
    private final NguoiDungDAO nguoiDungDAO = new NguoiDungDAOImpl();
    private final TourDAO tourDAO = new TourDAOImpl();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        logger.info("BookingManagementServlet doGet - pathInfo: {}", pathInfo);
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.isEmpty()) {
            listBookings(request, response);
        } else if (pathInfo.startsWith("/view/")) {
            String idStr = pathInfo.substring(6);
            try {
                Long id = Long.parseLong(idStr);
                viewBooking(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/confirm/")) {
            String idStr = pathInfo.substring(9);
            try {
                Long id = Long.parseLong(idStr);
                confirmBooking(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/cancel/")) {
            String idStr = pathInfo.substring(8);
            try {
                Long id = Long.parseLong(idStr);
                cancelBooking(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();
        
        if (pathInfo != null && pathInfo.startsWith("/paid/")) {
            String idStr = pathInfo.substring(6);
            try {
                Long id = Long.parseLong(idStr);
                markAsPaid(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void listBookings(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<DatTour> bookings = datTourDAO.findAll();
            
            // Load related data
            for (DatTour booking : bookings) {
                if (booking.getKhachhangId() != null) {
                    Optional<KhachHang> khachHangOpt = khachHangDAO.findById(booking.getKhachhangId());
                    if (khachHangOpt.isPresent()) {
                        KhachHang khachHang = khachHangOpt.get();
                        // Load NguoiDung
                        if (khachHang.getNguoidungId() != null) {
                            Optional<NguoiDung> nguoiDungOpt = nguoiDungDAO.findById(khachHang.getNguoidungId());
                            if (nguoiDungOpt.isPresent()) {
                                khachHang.setNguoiDung(nguoiDungOpt.get());
                            }
                        }
                        booking.setKhachHang(khachHang);
                    }
                }
                if (booking.getTourId() != null) {
                    Optional<Tour> tourOpt = tourDAO.findById(booking.getTourId());
                    if (tourOpt.isPresent()) {
                        booking.setTour(tourOpt.get());
                    }
                }
            }
            
            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("/WEB-INF/views/admin/bookings.jsp").forward(request, response);
        } catch (Exception e) {
            logger.error("Lỗi load danh sách đặt tour", e);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=load_failed");
        }
    }
    
    private void viewBooking(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws ServletException, IOException {
        try {
            Optional<DatTour> bookingOpt = datTourDAO.findById(id);
            if (bookingOpt.isPresent()) {
                DatTour booking = bookingOpt.get();
                
                // Load related data
                if (booking.getKhachhangId() != null) {
                    Optional<KhachHang> khachHangOpt = khachHangDAO.findById(booking.getKhachhangId());
                    if (khachHangOpt.isPresent()) {
                        KhachHang khachHang = khachHangOpt.get();
                        // Load NguoiDung
                        if (khachHang.getNguoidungId() != null) {
                            Optional<NguoiDung> nguoiDungOpt = nguoiDungDAO.findById(khachHang.getNguoidungId());
                            if (nguoiDungOpt.isPresent()) {
                                khachHang.setNguoiDung(nguoiDungOpt.get());
                            }
                        }
                        booking.setKhachHang(khachHang);
                    }
                }
                if (booking.getTourId() != null) {
                    Optional<Tour> tourOpt = tourDAO.findById(booking.getTourId());
                    if (tourOpt.isPresent()) {
                        booking.setTour(tourOpt.get());
                    }
                }
                
                request.setAttribute("booking", booking);
                request.getRequestDispatcher("/WEB-INF/views/admin/booking-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/bookings?error=not_found");
            }
        } catch (Exception e) {
            logger.error("Lỗi load chi tiết đặt tour", e);
            response.sendRedirect(request.getContextPath() + "/admin/bookings?error=load_failed");
        }
    }
    
    private void confirmBooking(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws IOException {
        try {
            if (datTourDAO.updateTrangThai(id, DatTour.TinhTrang.CONFIRMED)) {
                response.sendRedirect(request.getContextPath() + "/admin/bookings?success=confirmed");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/bookings?error=update_failed");
            }
        } catch (Exception e) {
            logger.error("Lỗi xác nhận đặt tour", e);
            response.sendRedirect(request.getContextPath() + "/admin/bookings?error=update_failed");
        }
    }
    
    private void cancelBooking(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws IOException {
        try {
            if (datTourDAO.updateTrangThai(id, DatTour.TinhTrang.CANCELLED)) {
                response.sendRedirect(request.getContextPath() + "/admin/bookings?success=cancelled");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/bookings?error=update_failed");
            }
        } catch (Exception e) {
            logger.error("Lỗi hủy đặt tour", e);
            response.sendRedirect(request.getContextPath() + "/admin/bookings?error=update_failed");
        }
    }
    
    private void markAsPaid(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws IOException {
        try {
            if (datTourDAO.updateDaThanhToan(id, true)) {
                response.sendRedirect(request.getContextPath() + "/admin/bookings?success=payment_marked");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/bookings?error=update_failed");
            }
        } catch (Exception e) {
            logger.error("Lỗi đánh dấu thanh toán", e);
            response.sendRedirect(request.getContextPath() + "/admin/bookings?error=update_failed");
        }
    }
}