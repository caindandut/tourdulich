package com.tourdulich.controller;

import com.tourdulich.model.DatTour;
import com.tourdulich.model.KhachHang;
import com.tourdulich.model.NguoiDung;
import com.tourdulich.model.Tour;
import com.tourdulich.service.BookingService;
import com.tourdulich.service.impl.BookingServiceImpl;
import com.tourdulich.dao.TourDAO;
import com.tourdulich.dao.impl.TourDAOImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/booking/detail")
public class BookingDetailServlet extends HttpServlet {

    private final BookingService bookingService = new BookingServiceImpl();
    private final TourDAO tourDAO = new TourDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        NguoiDung currentUser = (NguoiDung) session.getAttribute("currentUser");
        KhachHang khachHang = (KhachHang) session.getAttribute("khachHang");

        if (currentUser == null || khachHang == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        try {
            Long bookingId = Long.parseLong(idParam);
            Optional<DatTour> bookingOpt = bookingService.getBookingById(bookingId);

            if (!bookingOpt.isPresent()) {
                response.sendRedirect(request.getContextPath() + "/profile?error=booking_not_found");
                return;
            }

            DatTour booking = bookingOpt.get();

            if (booking.getKhachhangId() == null || !booking.getKhachhangId().equals(khachHang.getId())) {
                response.sendRedirect(request.getContextPath() + "/profile?error=unauthorized");
                return;
            }

            Optional<Tour> tourOpt = tourDAO.findById(booking.getTourId());
            tourOpt.ifPresent(booking::setTour);

            if (booking.getTour() == null && !tourOpt.isPresent()) {
                response.sendRedirect(request.getContextPath() + "/profile?error=tour_not_found");
                return;
            }

            if (booking.getNgaydat() == null && booking.getCreatedAt() != null) {
                booking.setNgaydat(booking.getCreatedAt());
            }

            // Reuse booking-success view to show booking details
            request.setAttribute("tour", booking.getTour() != null ? booking.getTour() : tourOpt.orElse(new Tour()));
            request.setAttribute("booking", booking);
            request.getRequestDispatcher("/WEB-INF/views/booking-success.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/profile?error=invalid_booking");
        }
    }
}

