package com.tourdulich.controller.admin;

import com.tourdulich.dao.DanhGiaDAO;
import com.tourdulich.dao.DatTourDAO;
import com.tourdulich.dao.KhachHangDAO;
import com.tourdulich.dao.NguoiDungDAO;
import com.tourdulich.dao.TourDAO;
import com.tourdulich.dao.impl.DanhGiaDAOImpl;
import com.tourdulich.dao.impl.DatTourDAOImpl;
import com.tourdulich.dao.impl.KhachHangDAOImpl;
import com.tourdulich.dao.impl.NguoiDungDAOImpl;
import com.tourdulich.dao.impl.TourDAOImpl;
import com.tourdulich.model.DanhGia;
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

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(AdminDashboardServlet.class);
    
    private final TourDAO tourDAO = new TourDAOImpl();
    private final DatTourDAO datTourDAO = new DatTourDAOImpl();
    private final NguoiDungDAO nguoiDungDAO = new NguoiDungDAOImpl();
    private final DanhGiaDAO danhGiaDAO = new DanhGiaDAOImpl();
    private final KhachHangDAO khachHangDAO = new KhachHangDAOImpl();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        logger.info("Admin Dashboard accessed");
        
        try {

            long totalTours = tourDAO.count();
            long totalBookings = datTourDAO.count();
            long totalUsers = nguoiDungDAO.count();
            long totalReviews = danhGiaDAO.count();
            
            long pendingBookings = datTourDAO.countByTrangThai(DatTour.TinhTrang.PENDING);
            long confirmedBookings = datTourDAO.countByTrangThai(DatTour.TinhTrang.CONFIRMED);
            long cancelledBookings = datTourDAO.countByTrangThai(DatTour.TinhTrang.CANCELLED);
            

            java.math.BigDecimal totalRevenue = datTourDAO.getTotalRevenue();
            

            List<DatTour> recentBookings = datTourDAO.findAll();
            if (recentBookings.size() > 5) {
                recentBookings = recentBookings.subList(0, 5);
            }
            

            for (DatTour booking : recentBookings) {
                Optional<Tour> tourOpt = tourDAO.findById(booking.getTourId());
                tourOpt.ifPresent(booking::setTour);
            }
            

            List<DanhGia> recentReviews = danhGiaDAO.findAll();
            if (recentReviews.size() > 5) {
                recentReviews = recentReviews.subList(0, 5);
            }
            

            for (DanhGia review : recentReviews) {
                Optional<KhachHang> khachHangOpt = khachHangDAO.findById(review.getKhachhangId());
                if (khachHangOpt.isPresent()) {
                    KhachHang khachHang = khachHangOpt.get();
                    Optional<NguoiDung> nguoiDungOpt = nguoiDungDAO.findById(khachHang.getNguoidungId());
                    nguoiDungOpt.ifPresent(khachHang::setNguoiDung);
                    review.setKhachHang(khachHang);
                }
                Optional<Tour> tourOpt = tourDAO.findById(review.getTourId());
                tourOpt.ifPresent(review::setTour);
            }
            

            request.setAttribute("totalTours", totalTours);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalReviews", totalReviews);
            request.setAttribute("pendingBookings", pendingBookings);
            request.setAttribute("confirmedBookings", confirmedBookings);
            request.setAttribute("cancelledBookings", cancelledBookings);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("recentBookings", recentBookings);
            request.setAttribute("recentReviews", recentReviews);
            
            request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.error("Lỗi load dashboard", e);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=load_failed");
        }
    }
}

