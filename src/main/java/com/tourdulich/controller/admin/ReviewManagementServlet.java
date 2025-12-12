package com.tourdulich.controller.admin;

import com.tourdulich.dao.DanhGiaDAO;
import com.tourdulich.dao.KhachHangDAO;
import com.tourdulich.dao.NguoiDungDAO;
import com.tourdulich.dao.TourDAO;
import com.tourdulich.dao.impl.DanhGiaDAOImpl;
import com.tourdulich.dao.impl.KhachHangDAOImpl;
import com.tourdulich.dao.impl.NguoiDungDAOImpl;
import com.tourdulich.dao.impl.TourDAOImpl;
import com.tourdulich.model.DanhGia;
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

@WebServlet("/admin/reviews/*")
public class ReviewManagementServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(ReviewManagementServlet.class);
    
    private final DanhGiaDAO danhGiaDAO = new DanhGiaDAOImpl();
    private final KhachHangDAO khachHangDAO = new KhachHangDAOImpl();
    private final NguoiDungDAO nguoiDungDAO = new NguoiDungDAOImpl();
    private final TourDAO tourDAO = new TourDAOImpl();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        logger.info("ReviewManagementServlet doGet - pathInfo: {}", pathInfo);
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.isEmpty()) {
            listReviews(request, response);
        } else if (pathInfo.startsWith("/hide/")) {
            String idStr = pathInfo.substring(6);
            try {
                Long id = Long.parseLong(idStr);
                hideReview(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/show/")) {
            String idStr = pathInfo.substring(6);
            try {
                Long id = Long.parseLong(idStr);
                showReview(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/delete/")) {
            String idStr = pathInfo.substring(8);
            try {
                Long id = Long.parseLong(idStr);
                deleteReview(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void listReviews(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<DanhGia> reviews = danhGiaDAO.findAll();
            
            // Load related data
            for (DanhGia review : reviews) {
                if (review.getKhachhangId() != null) {
                    Optional<KhachHang> khachHangOpt = khachHangDAO.findById(review.getKhachhangId());
                    if (khachHangOpt.isPresent()) {
                        KhachHang khachHang = khachHangOpt.get();
                        // Load NguoiDung
                        if (khachHang.getNguoidungId() != null) {
                            Optional<NguoiDung> nguoiDungOpt = nguoiDungDAO.findById(khachHang.getNguoidungId());
                            if (nguoiDungOpt.isPresent()) {
                                khachHang.setNguoiDung(nguoiDungOpt.get());
                            }
                        }
                        review.setKhachHang(khachHang);
                    }
                }
                if (review.getTourId() != null) {
                    Optional<Tour> tourOpt = tourDAO.findById(review.getTourId());
                    if (tourOpt.isPresent()) {
                        review.setTour(tourOpt.get());
                    }
                }
            }
            
            request.setAttribute("reviews", reviews);
            request.getRequestDispatcher("/WEB-INF/views/admin/reviews.jsp").forward(request, response);
        } catch (Exception e) {
            logger.error("Lỗi load danh sách đánh giá", e);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=load_failed");
        }
    }
    
    private void hideReview(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws IOException {
        try {
            if (danhGiaDAO.updateTrangthai(id, DanhGia.TrangThai.AN)) {
                response.sendRedirect(request.getContextPath() + "/admin/reviews?success=status_updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/reviews?error=update_failed");
            }
        } catch (Exception e) {
            logger.error("Lỗi ẩn đánh giá", e);
            response.sendRedirect(request.getContextPath() + "/admin/reviews?error=update_failed");
        }
    }
    
    private void showReview(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws IOException {
        try {
            if (danhGiaDAO.updateTrangthai(id, DanhGia.TrangThai.HIEN_THI)) {
                response.sendRedirect(request.getContextPath() + "/admin/reviews?success=status_updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/reviews?error=update_failed");
            }
        } catch (Exception e) {
            logger.error("Lỗi hiện đánh giá", e);
            response.sendRedirect(request.getContextPath() + "/admin/reviews?error=update_failed");
        }
    }
    
    private void deleteReview(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws IOException {
        try {
            if (danhGiaDAO.delete(id)) {
                response.sendRedirect(request.getContextPath() + "/admin/reviews?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/reviews?error=delete_failed");
            }
        } catch (Exception e) {
            logger.error("Lỗi xóa đánh giá", e);
            response.sendRedirect(request.getContextPath() + "/admin/reviews?error=delete_failed");
        }
    }
}