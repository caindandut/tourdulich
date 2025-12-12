package com.tourdulich.controller;

import com.tourdulich.model.Tour;
import com.tourdulich.service.TourService;
import com.tourdulich.service.impl.TourServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    
    private final TourService tourService = new TourServiceImpl();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Tour> featuredTours = tourService.getTopNewestTours(6);
        
        long totalTours = tourService.getTotalActiveTours();
        
        request.setAttribute("featuredTours", featuredTours);
        request.setAttribute("totalTours", totalTours);
        
        request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
    }
}



