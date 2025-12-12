package com.tourdulich.controller;

import com.tourdulich.dao.DanhGiaDAO;
import com.tourdulich.dao.KhachHangDAO;
import com.tourdulich.dao.NguoiDungDAO;
import com.tourdulich.dao.impl.DanhGiaDAOImpl;
import com.tourdulich.dao.impl.KhachHangDAOImpl;
import com.tourdulich.dao.impl.KhachSanDAOImpl;
import com.tourdulich.dao.impl.NguoiDungDAOImpl;
import com.tourdulich.model.DanhGia;
import com.tourdulich.model.KhachHang;
import com.tourdulich.model.KhachSan;
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
import java.util.List;
import java.util.Optional;

@WebServlet("/tour/detail")
public class TourDetailServlet extends HttpServlet {
    
    private final TourService tourService = new TourServiceImpl();
    private final DanhGiaDAO danhGiaDAO = new DanhGiaDAOImpl();
    private final KhachSanDAOImpl khachSanDAO = new KhachSanDAOImpl();
    private final KhachHangDAO khachHangDAO = new KhachHangDAOImpl();
    private final NguoiDungDAO nguoiDungDAO = new NguoiDungDAOImpl();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        try {
            Long tourId = Long.parseLong(idParam);
            Optional<Tour> tourOpt = tourService.getTourById(tourId);
            
            if (tourOpt.isPresent()) {
                Tour tour = tourOpt.get();
                
                List<DanhGia> reviews = danhGiaDAO.findByTourId(tourId);
                long reviewCount = danhGiaDAO.countByTourId(tourId);
                
                for (DanhGia review : reviews) {
                    loadReviewDetails(review);
                }
                
                double avgRating = 0.0;
                if (!reviews.isEmpty()) {
                    int totalRating = 0;
                    int count = 0;
                    for (DanhGia review : reviews) {
                        if (review.getRating() != null) {
                            totalRating += review.getRating();
                            count++;
                        }
                    }
                    if (count > 0) {
                        avgRating = (double) totalRating / count;
                    }
                }
                List<KhachSan> hotels;
                if (tour.getDiadiem() != null && !tour.getDiadiem().isEmpty()) {
                    String loc = tour.getDiadiem();
                    String[] parts = loc.split(",");
                    String mainLoc = parts.length > 0 ? parts[0].trim() : loc;
                    hotels = khachSanDAO.findAvailableByDiaChi(mainLoc);
                } else {
                    hotels = khachSanDAO.findAvailableByDiaChi("");
                }
                
                
                HttpSession session = request.getSession(false);
                NguoiDung currentUser = null;
                if (session != null) {
                    currentUser = (NguoiDung) session.getAttribute("currentUser");
                }
                
                request.setAttribute("tour", tour);
                request.setAttribute("reviews", reviews);
                request.setAttribute("reviewCount", reviewCount);
                request.setAttribute("avgRating", avgRating);
                request.setAttribute("hotels", hotels);
                request.setAttribute("currentUser", currentUser);
                
               
                try {
                    java.io.FileWriter fw = new java.io.FileWriter("d:\\TourDuLich\\.cursor\\debug.log", true);
                    fw.write("{\"timestamp\":" + System.currentTimeMillis() + ",\"location\":\"TourDetailServlet.java:100\",\"message\":\"Before forwarding to JSP\",\"data\":{\"jspPath\":\"/WEB-INF/views/tour-detail.jsp\",\"tourId\":" + tourId + ",\"tourName\":\"" + (tour.getTentour() != null ? tour.getTentour().replace("\"", "\\\"") : "null") + "\"},\"sessionId\":\"debug-session\",\"runId\":\"run1\",\"hypothesisId\":\"A\"}\n");
                    fw.close();
                } catch (Exception logEx) {}
                // #endregion
                
                request.getRequestDispatcher("/WEB-INF/views/tour-detail.jsp").forward(request, response);
                
               
                try {
                    java.io.FileWriter fw = new java.io.FileWriter("d:\\TourDuLich\\.cursor\\debug.log", true);
                    fw.write("{\"timestamp\":" + System.currentTimeMillis() + ",\"location\":\"TourDetailServlet.java:105\",\"message\":\"After forwarding to JSP\",\"data\":{},\"sessionId\":\"debug-session\",\"runId\":\"run1\",\"hypothesisId\":\"A\"}\n");
                    fw.close();
                } catch (Exception logEx) {}
                // #endregion
            } else {
                response.sendRedirect(request.getContextPath() + "/home?error=tour_not_found");
            }
            
        } catch (Exception e) {
       
            try {
                java.io.FileWriter fw = new java.io.FileWriter("d:\\TourDuLich\\.cursor\\debug.log", true);
                java.io.StringWriter sw = new java.io.StringWriter();
                java.io.PrintWriter pw = new java.io.PrintWriter(sw);
                e.printStackTrace(pw);
                fw.write("{\"timestamp\":" + System.currentTimeMillis() + ",\"location\":\"TourDetailServlet.java:105\",\"message\":\"Exception caught\",\"data\":{\"exceptionType\":\"" + e.getClass().getName() + "\",\"exceptionMessage\":\"" + (e.getMessage() != null ? e.getMessage().replace("\"", "\\\"").replace("\n", "\\n") : "null") + "\",\"stackTrace\":\"" + sw.toString().replace("\"", "\\\"").replace("\n", "\\n") + "\"},\"sessionId\":\"debug-session\",\"runId\":\"run1\",\"hypothesisId\":\"B\"}\n");
                fw.close();
            } catch (Exception logEx) {}
            // #endregion
            
            e.printStackTrace();
            getServletContext().log("Lỗi trong TourDetailServlet", e);
            
            response.setContentType("text/html;charset=UTF-8");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            java.io.PrintWriter out = response.getWriter();
            out.println("<html><head><title>Error Debug</title></head><body>");
            out.println("<h1>Lỗi 500 - Debug Info</h1>");
            out.println("<h2>" + e.getClass().getName() + ": " + e.getMessage() + "</h2>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
            out.println("</body></html>");
        }
    }
    
    private void loadReviewDetails(DanhGia review) {
        if (review.getKhachhangId() != null) {
            Optional<KhachHang> khachHangOpt = khachHangDAO.findById(review.getKhachhangId());
            if (khachHangOpt.isPresent()) {
                KhachHang khachHang = khachHangOpt.get();
                if (khachHang.getNguoidungId() != null) {
                    Optional<NguoiDung> nguoiDungOpt = nguoiDungDAO.findById(khachHang.getNguoidungId());
                    nguoiDungOpt.ifPresent(khachHang::setNguoiDung);
                }
                review.setKhachHang(khachHang);
            }
        }
    }
}



