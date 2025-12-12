package com.tourdulich.controller.admin;

import com.tourdulich.dao.TourDAO;
import com.tourdulich.dao.impl.TourDAOImpl;
import com.tourdulich.model.Tour;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@WebServlet({"/admin/tours", "/admin/tours/*"})
public class TourManagementServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(TourManagementServlet.class);
    
    private final TourDAO tourDAO = new TourDAOImpl();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        String servletPath = request.getServletPath();
        String requestURI = request.getRequestURI();
        
        logger.info("TourManagementServlet doGet - pathInfo: {}, servletPath: {}, requestURI: {}", 
                    pathInfo, servletPath, requestURI);
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.isEmpty()) {
            listTours(request, response);
        } else if (pathInfo.equals("/add")) {
            showAddForm(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            String idStr = pathInfo.substring(6);
            try {
                Long id = Long.parseLong(idStr);
                showEditForm(request, response, id);
            } catch (NumberFormatException e) {
                logger.error("Lỗi parse ID từ path: {}", pathInfo, e);
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/delete/")) {
            String idStr = pathInfo.substring(8);
            try {
                Long id = Long.parseLong(idStr);
                deleteTour(request, response, id);
            } catch (NumberFormatException e) {
                logger.error("Lỗi parse ID từ path khi xóa: {}", pathInfo, e);
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            logger.warn("Path không được hỗ trợ: {}", pathInfo);
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();
        
        if (pathInfo != null && pathInfo.equals("/add")) {
            addTour(request, response);
        } else if (pathInfo != null && pathInfo.startsWith("/edit/")) {
            String idStr = pathInfo.substring(6);
            try {
                Long id = Long.parseLong(idStr);
                updateTour(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void listTours(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            logger.debug("Bắt đầu load danh sách tour");
            List<Tour> tours = tourDAO.findAll();
            logger.debug("Đã load được {} tour", tours != null ? tours.size() : 0);
            request.setAttribute("tours", tours);
            logger.debug("Forward đến tours.jsp");
            request.getRequestDispatcher("/WEB-INF/views/admin/tours.jsp").forward(request, response);
        } catch (ServletException e) {
            logger.error("Lỗi ServletException khi load danh sách tour", e);
            throw e;
        } catch (IOException e) {
            logger.error("Lỗi IOException khi load danh sách tour", e);
            throw e;
        } catch (Exception e) {
            logger.error("Lỗi không xác định khi load danh sách tour", e);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=load_failed");
        }
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/admin/tour-form.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws ServletException, IOException {
        try {
            Optional<Tour> tourOpt = tourDAO.findById(id);
            if (tourOpt.isPresent()) {
                request.setAttribute("tour", tourOpt.get());
                request.getRequestDispatcher("/WEB-INF/views/admin/tour-form.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/tours?error=not_found");
            }
        } catch (Exception e) {
            logger.error("Lỗi load tour để sửa", e);
            response.sendRedirect(request.getContextPath() + "/admin/tours?error=load_failed");
        }
    }
    
    private void addTour(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            Tour tour = extractTourFromRequest(request);
            Long savedId = tourDAO.save(tour);
            if (savedId != null) {
                response.sendRedirect(request.getContextPath() + "/admin/tours?success=created");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/tours/add?error=failed");
            }
        } catch (Exception e) {
            logger.error("Lỗi thêm tour", e);
            response.sendRedirect(request.getContextPath() + "/admin/tours/add?error=failed");
        }
    }
    
    private void updateTour(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws IOException {
        try {
            Optional<Tour> tourOpt = tourDAO.findById(id);
            if (tourOpt.isPresent()) {
                Tour tour = extractTourFromRequest(request);
                tour.setId(id);
                
                if (tourDAO.update(tour)) {
                    response.sendRedirect(request.getContextPath() + "/admin/tours?success=updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/tours/edit/" + id + "?error=failed");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/tours?error=not_found");
            }
        } catch (Exception e) {
            logger.error("Lỗi cập nhật tour", e);
            response.sendRedirect(request.getContextPath() + "/admin/tours/edit/" + id + "?error=failed");
        }
    }
    
    private void deleteTour(HttpServletRequest request, HttpServletResponse response, Long id)
            throws IOException {
        try {
            boolean deleted = tourDAO.delete(id);
            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/admin/tours?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/tours?error=delete_failed");
            }
        } catch (Exception e) {
            logger.error("Lỗi xóa tour", e);
            response.sendRedirect(request.getContextPath() + "/admin/tours?error=delete_failed");
        }
    }
    
    private Tour extractTourFromRequest(HttpServletRequest request) {
        Tour tour = new Tour();
        
        tour.setTentour(request.getParameter("tentour"));
        tour.setDiadiem(request.getParameter("diadiem"));
        tour.setThoiluong(request.getParameter("thoiluong"));
        tour.setHinhanh(request.getParameter("hinhanh"));
        tour.setMota(request.getParameter("mota"));
        
        String giaStr = request.getParameter("gia");
        if (giaStr != null && !giaStr.isEmpty()) {
            try {
                tour.setGia(new BigDecimal(giaStr.replace(",", "")));
            } catch (NumberFormatException e) {
                logger.warn("Lỗi parse giá: " + giaStr);
            }
        }
        
        String ngaykhoihanhStr = request.getParameter("ngaykhoihanh");
        if (ngaykhoihanhStr == null || ngaykhoihanhStr.isEmpty()) {
            ngaykhoihanhStr = request.getParameter("ngaydi");
        }
        if (ngaykhoihanhStr != null && !ngaykhoihanhStr.isEmpty()) {
            try {
                tour.setNgaykhoihanh(LocalDate.parse(ngaykhoihanhStr));
            } catch (Exception e) {
                logger.warn("Lỗi parse ngày khởi hành: " + ngaykhoihanhStr);
            }
        }
        
        String trangthaiStr = request.getParameter("trangthai");
        if (trangthaiStr != null && !trangthaiStr.isEmpty()) {
            try {
                tour.setStatus(Tour.Status.valueOf(trangthaiStr));
            } catch (IllegalArgumentException e) {
                tour.setStatus(Tour.Status.ACTIVE);
            }
        } else {
            tour.setStatus(Tour.Status.ACTIVE);
        }
        
        return tour;
    }
}