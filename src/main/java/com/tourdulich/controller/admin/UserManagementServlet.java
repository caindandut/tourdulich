package com.tourdulich.controller.admin;

import com.tourdulich.dao.NguoiDungDAO;
import com.tourdulich.dao.impl.NguoiDungDAOImpl;
import com.tourdulich.model.NguoiDung;
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

@WebServlet({"/admin/users", "/admin/users/*"})
public class UserManagementServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(UserManagementServlet.class);
    
    private final NguoiDungDAO nguoiDungDAO = new NguoiDungDAOImpl();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        String servletPath = request.getServletPath();
        String requestURI = request.getRequestURI();
        
        logger.info("UserManagementServlet doGet - pathInfo: {}, servletPath: {}, requestURI: {}", 
                    pathInfo, servletPath, requestURI);
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.isEmpty()) {
            listUsers(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            String idStr = pathInfo.substring(6);
            try {
                Long id = Long.parseLong(idStr);
                showEditForm(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/lock/")) {
            String idStr = pathInfo.substring(6);
            try {
                Long id = Long.parseLong(idStr);
                lockUser(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/unlock/")) {
            String idStr = pathInfo.substring(8);
            try {
                Long id = Long.parseLong(idStr);
                unlockUser(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/delete/")) {
            String idStr = pathInfo.substring(8);
            try {
                Long id = Long.parseLong(idStr);
                deleteUser(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();
        
        if (pathInfo != null && pathInfo.startsWith("/edit/")) {
            String idStr = pathInfo.substring(6);
            try {
                Long id = Long.parseLong(idStr);
                updateUser(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void listUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            logger.debug("Bắt đầu load danh sách người dùng");
            List<NguoiDung> users = nguoiDungDAO.findAll();
            logger.debug("Đã load được {} người dùng", users != null ? users.size() : 0);
            request.setAttribute("users", users);
            logger.debug("Forward đến users.jsp");
            request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
        } catch (ServletException e) {
            logger.error("Lỗi ServletException khi load danh sách người dùng", e);
            throw e;
        } catch (IOException e) {
            logger.error("Lỗi IOException khi load danh sách người dùng", e);
            throw e;
        } catch (Exception e) {
            logger.error("Lỗi không xác định khi load danh sách người dùng", e);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=load_failed");
        }
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws ServletException, IOException {
        try {
            Optional<NguoiDung> userOpt = nguoiDungDAO.findById(id);
            if (userOpt.isPresent()) {
                request.setAttribute("user", userOpt.get());
                request.getRequestDispatcher("/WEB-INF/views/admin/user-form.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=not_found");
            }
        } catch (Exception e) {
            logger.error("Lỗi load người dùng để sửa", e);
            response.sendRedirect(request.getContextPath() + "/admin/users?error=load_failed");
        }
    }
    
    private void updateUser(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws IOException {
        try {
            Optional<NguoiDung> userOpt = nguoiDungDAO.findById(id);
            if (userOpt.isPresent()) {
                NguoiDung user = userOpt.get();
                
                user.setHotennguoidung(request.getParameter("hotennguoidung"));
                user.setEmail(request.getParameter("email"));
                user.setSdt(request.getParameter("sdt"));
                
                String roleStr = request.getParameter("role");
                if (roleStr != null && !roleStr.isEmpty()) {
                    try {
                        user.setRole(NguoiDung.Role.valueOf(roleStr));
                    } catch (IllegalArgumentException e) {
                        logger.warn("Lỗi parse role: " + roleStr);
                    }
                }
                
                if (nguoiDungDAO.update(user)) {
                    response.sendRedirect(request.getContextPath() + "/admin/users?success=updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/users/edit/" + id + "?error=failed");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=not_found");
            }
        } catch (Exception e) {
            logger.error("Lỗi cập nhật người dùng", e);
            response.sendRedirect(request.getContextPath() + "/admin/users/edit/" + id + "?error=failed");
        }
    }
    
    private void lockUser(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws IOException {
        try {
            if (nguoiDungDAO.updateStatus(id, NguoiDung.Status.LOCKED)) {
                response.sendRedirect(request.getContextPath() + "/admin/users?success=locked");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=lock_failed");
            }
        } catch (Exception e) {
            logger.error("Lỗi khóa người dùng", e);
            response.sendRedirect(request.getContextPath() + "/admin/users?error=lock_failed");
        }
    }
    
    private void unlockUser(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws IOException {
        try {
            if (nguoiDungDAO.updateStatus(id, NguoiDung.Status.ACTIVE)) {
                response.sendRedirect(request.getContextPath() + "/admin/users?success=unlocked");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=unlock_failed");
            }
        } catch (Exception e) {
            logger.error("Lỗi mở khóa người dùng", e);
            response.sendRedirect(request.getContextPath() + "/admin/users?error=unlock_failed");
        }
    }
    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws IOException {
        try {
            if (nguoiDungDAO.delete(id)) {
                response.sendRedirect(request.getContextPath() + "/admin/users?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=delete_failed");
            }
        } catch (Exception e) {
            logger.error("Lỗi xóa người dùng", e);
            response.sendRedirect(request.getContextPath() + "/admin/users?error=delete_failed");
        }
    }
}