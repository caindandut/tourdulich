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
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    
    private final TourService tourService = new TourServiceImpl();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String keyword = request.getParameter("keyword");
        String location = request.getParameter("location");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        
        BigDecimal minPrice = null;
        BigDecimal maxPrice = null;
        
        try {
            if (minPriceStr != null && !minPriceStr.isEmpty()) {
                minPrice = new BigDecimal(minPriceStr);
            }
            if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
                maxPrice = new BigDecimal(maxPriceStr);
            }
        } catch (NumberFormatException e) {
        }
        
        List<Tour> allResults;
        
        if ((keyword == null || keyword.trim().isEmpty()) && 
            (location == null || location.trim().isEmpty()) && 
            minPrice == null && maxPrice == null) {
            allResults = tourService.getAllActiveTours();
        } else {
            allResults = tourService.searchTours(keyword, location, minPrice, maxPrice);
        }
        
        int pageSize = 9;
        int totalResults = allResults.size();
        boolean needsPagination = totalResults > pageSize;
        
        List<Tour> searchResults;
        int currentPage = 1;
        int totalPages = 1;
        
        if (needsPagination) {
            String pageParam = request.getParameter("page");
            try {
                currentPage = pageParam != null ? Integer.parseInt(pageParam) : 1;
                if (currentPage < 1) currentPage = 1;
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
            
            totalPages = (int) Math.ceil((double) totalResults / pageSize);
            if (currentPage > totalPages) currentPage = totalPages;
            
            int startIndex = (currentPage - 1) * pageSize;
            int endIndex = Math.min(startIndex + pageSize, totalResults);
            searchResults = allResults.subList(startIndex, endIndex);
        } else {
            searchResults = allResults;
        }
        
        request.setAttribute("tours", searchResults);
        request.setAttribute("keyword", keyword);
        request.setAttribute("location", location);
        request.setAttribute("minPrice", minPriceStr);
        request.setAttribute("maxPrice", maxPriceStr);
        request.setAttribute("totalResults", totalResults);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("needsPagination", needsPagination);
        
        request.getRequestDispatcher("/WEB-INF/views/search.jsp").forward(request, response);
    }
}



