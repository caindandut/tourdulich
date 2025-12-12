package com.tourdulich.controller;

import com.tourdulich.model.Tour;
import com.tourdulich.model.DatTour;
import com.tourdulich.model.NguoiDung;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/booking/success")
public class BookingSuccessServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        NguoiDung currentUser = (NguoiDung) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        

        Tour tour = (Tour) session.getAttribute("lastBookedTour");
        DatTour booking = (DatTour) session.getAttribute("lastBooking");
        
        if (tour == null || booking == null) {

            response.sendRedirect(request.getContextPath() + "/profile?success=booking_created");
            return;
        }
        
        request.setAttribute("tour", tour);
        request.setAttribute("booking", booking);
        

        session.removeAttribute("lastBookedTour");
        session.removeAttribute("lastBooking");
        session.removeAttribute("bookingSuccess");
        
        request.getRequestDispatcher("/WEB-INF/views/booking-success.jsp").forward(request, response);
    }
}




