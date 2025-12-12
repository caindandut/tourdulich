package com.tourdulich.controller.admin;

import com.tourdulich.dao.KhachSanDAO;
import com.tourdulich.dao.impl.KhachSanDAOImpl;
import com.tourdulich.model.KhachSan;

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

@WebServlet({"/admin/hotels", "/admin/hotels/add", "/admin/hotels/edit", "/admin/hotels/delete", "/admin/hotels/status"})
public class HotelManagementServlet extends HttpServlet {
    
    private final KhachSanDAOImpl khachSanDAO = new KhachSanDAOImpl();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        switch (path) {
            case "/admin/hotels":
                listHotels(request, response);
                break;
            case "/admin/hotels/add":
                showAddForm(request, response);
                break;
            case "/admin/hotels/edit":
                showEditForm(request, response);
                break;
            case "/admin/hotels/delete":
                deleteHotel(request, response);
                break;
            case "/admin/hotels/status":
                updateStatus(request, response);
                break;
            default:
                listHotels(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();
        
        if ("/admin/hotels/add".equals(path)) {
            addHotel(request, response);
        } else if ("/admin/hotels/edit".equals(path)) {
            updateHotel(request, response);
        }
    }
    
    private void listHotels(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<KhachSan> hotels = khachSanDAO.findAll();
        request.setAttribute("hotels", hotels);
        request.getRequestDispatcher("/WEB-INF/views/admin/hotels.jsp").forward(request, response);
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setAttribute("isEdit", false);
        request.getRequestDispatcher("/WEB-INF/views/admin/hotel-form.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            Long id = Long.parseLong(idParam);
            Optional<KhachSan> hotelOpt = khachSanDAO.findById(id);
            if (hotelOpt.isPresent()) {
                request.setAttribute("hotel", hotelOpt.get());
                request.setAttribute("isEdit", true);
                request.getRequestDispatcher("/WEB-INF/views/admin/hotel-form.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/hotels?error=not_found");
    }
    
    private void addHotel(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        KhachSan hotel = extractHotelFromRequest(request);
        
        KhachSan saved = khachSanDAO.save(hotel);
        if (saved != null) {
            response.sendRedirect(request.getContextPath() + "/admin/hotels?success=created");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/hotels/add?error=failed");
        }
    }
    
    private void updateHotel(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        
        Optional<KhachSan> hotelOpt = khachSanDAO.findById(id);
        if (hotelOpt.isPresent()) {
            KhachSan hotel = extractHotelFromRequest(request);
            hotel.setId(id);
            
            if (khachSanDAO.update(hotel)) {
                response.sendRedirect(request.getContextPath() + "/admin/hotels?success=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/hotels/edit?id=" + id + "&error=failed");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/hotels?error=not_found");
        }
    }
    
    private void deleteHotel(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            Long id = Long.parseLong(idParam);
            if (khachSanDAO.delete(id)) {
                response.sendRedirect(request.getContextPath() + "/admin/hotels?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/hotels?error=delete_failed");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/hotels");
        }
    }
    
    private void updateStatus(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String idParam = request.getParameter("id");
        String statusParam = request.getParameter("status");
        
        if (idParam != null && statusParam != null) {
            Long id = Long.parseLong(idParam);
            try {
                KhachSan.TrangThai trangthai = KhachSan.TrangThai.valueOf(statusParam);
                if (khachSanDAO.updateTrangThai(id, trangthai)) {
                    response.sendRedirect(request.getContextPath() + "/admin/hotels?success=updated");
                    return;
                }
            } catch (IllegalArgumentException e) {

            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/hotels?error=update_failed");
    }
    
    private KhachSan extractHotelFromRequest(HttpServletRequest request) {
        KhachSan hotel = new KhachSan();
        hotel.setMakhachsan(request.getParameter("makhachsan"));
        hotel.setTenkhachsan(request.getParameter("tenkhachsan"));
        hotel.setDiachi(request.getParameter("diachi"));
        hotel.setChatluong(request.getParameter("chatluong"));
        hotel.setHinhanh(request.getParameter("hinhanh"));
        

        String giaStr = request.getParameter("gia");
        if (giaStr != null && !giaStr.isEmpty()) {
            hotel.setGia(new BigDecimal(giaStr.replace(",", "")));
        }
        

        String ngaydenStr = request.getParameter("ngayden");
        if (ngaydenStr != null && !ngaydenStr.isEmpty()) {
            hotel.setNgayden(LocalDate.parse(ngaydenStr));
        }
        

        String trangthaiStr = request.getParameter("trangthai");
        if (trangthaiStr != null && !trangthaiStr.isEmpty()) {
            try {
                hotel.setTrangthai(KhachSan.TrangThai.valueOf(trangthaiStr));
            } catch (IllegalArgumentException e) {
                hotel.setTrangthai(KhachSan.TrangThai.CON_PHONG);
            }
        } else {
            hotel.setTrangthai(KhachSan.TrangThai.CON_PHONG);
        }
        
        return hotel;
    }
}
