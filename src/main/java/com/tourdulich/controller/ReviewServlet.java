package com.tourdulich.controller;

import com.tourdulich.dao.DanhGiaDAO;
import com.tourdulich.dao.impl.DanhGiaDAOImpl;
import com.tourdulich.model.DanhGia;
import com.tourdulich.model.KhachHang;
import com.tourdulich.model.NguoiDung;
import com.tourdulich.model.Tour;
import com.tourdulich.service.TourService;
import com.tourdulich.service.impl.TourServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {
    
    private final TourService tourService = new TourServiceImpl();
    private final DanhGiaDAO danhGiaDAO = new DanhGiaDAOImpl();
    
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
        
        String tourIdParam = request.getParameter("tourId");
        
        if (tourIdParam == null || tourIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home?error=missing_tour");
            return;
        }
        
        try {
            Long tourId = Long.parseLong(tourIdParam);
            Optional<Tour> tourOpt = tourService.getTourById(tourId);
            
            if (tourOpt.isPresent()) {
                request.setAttribute("tour", tourOpt.get());
                request.getRequestDispatcher("/WEB-INF/views/review.jsp").forward(request, response);
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
        
        if (currentUser == null || khachHang == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            Long tourId = Long.parseLong(request.getParameter("tourId"));
            String noidung = request.getParameter("noidung");
            String ratingStr = request.getParameter("rating");
            

            if (noidung == null || noidung.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/review?tourId=" + tourId 
                    + "&error=empty_content");
                return;
            }
            

            Integer rating = 5;
            if (ratingStr != null && !ratingStr.trim().isEmpty()) {
                try {
                    int ratingValue = Integer.parseInt(ratingStr);
                    if (ratingValue >= 1 && ratingValue <= 5) {
                        rating = ratingValue;
                    }
                } catch (NumberFormatException e) {

                }
            }
            

            if (danhGiaDAO.existsByKhachHangIdAndTourId(khachHang.getId(), tourId)) {
                response.sendRedirect(request.getContextPath() + "/tour/detail?id=" + tourId 
                    + "&error=already_reviewed");
                return;
            }
            

            DanhGia danhGia = new DanhGia();
            danhGia.setMadanhgia("DG" + System.currentTimeMillis());
            danhGia.setKhachhangId(khachHang.getId());
            danhGia.setTourId(tourId);
            danhGia.setNoidung(noidung.trim());
            danhGia.setRating(rating);
            
            Long reviewId = danhGiaDAO.save(danhGia);
            
            if (reviewId != null) {
                response.sendRedirect(request.getContextPath() + "/tour/detail?id=" + tourId 
                    + "&success=review_created");
            } else {
                response.sendRedirect(request.getContextPath() + "/review?tourId=" + tourId 
                    + "&error=review_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home?error=invalid_data");
        }
    }
}



