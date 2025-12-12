package com.tourdulich.controller;

import com.tourdulich.dao.TourDAO;
import com.tourdulich.dao.impl.TourDAOImpl;
import com.tourdulich.model.DatTour;
import com.tourdulich.model.KhachHang;
import com.tourdulich.model.NguoiDung;
import com.tourdulich.model.Tour;
import com.tourdulich.service.BookingService;
import com.tourdulich.service.impl.BookingServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    
    private final BookingService bookingService = new BookingServiceImpl();
    private final TourDAO tourDAO = new TourDAOImpl();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        NguoiDung currentUser = (NguoiDung) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        

        if (currentUser.getRole() != NguoiDung.Role.CUSTOMER) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        KhachHang khachHang = (KhachHang) session.getAttribute("khachHang");
        
        if (khachHang != null) {

            List<DatTour> bookings = bookingService.getBookingsByKhachHang(khachHang.getId());
            

            for (DatTour booking : bookings) {
                Optional<Tour> tourOpt = tourDAO.findById(booking.getTourId());
                tourOpt.ifPresent(booking::setTour);
                

                if (booking.getNgaydat() == null && booking.getCreatedAt() != null) {
                    booking.setNgaydat(booking.getCreatedAt());
                }
            }
            
            request.setAttribute("bookings", bookings);
            request.setAttribute("khachHang", khachHang);
        }
        
        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        if ("cancel_booking".equals(action)) {
            handleCancelBooking(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }
    
    private void handleCancelBooking(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession();
        KhachHang khachHang = (KhachHang) session.getAttribute("khachHang");
        
        if (khachHang == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            Long bookingId = Long.parseLong(request.getParameter("bookingId"));
            
            boolean success = bookingService.cancelBooking(bookingId, khachHang.getId());
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/profile?success=cancelled");
            } else {
                response.sendRedirect(request.getContextPath() + "/profile?error=cancel_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/profile?error=invalid_booking");
        }
    }
}



