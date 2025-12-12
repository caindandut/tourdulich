<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tourdulich.model.NguoiDung" %>
<%
    NguoiDung adminUser = (NguoiDung) session.getAttribute("currentUser");
    String adminPath = request.getRequestURI();
%>
<aside class="admin-sidebar">
    <div class="admin-logo">
        <a href="<%= request.getContextPath() %>/admin/dashboard">
            <span class="logo-icon">🌍</span>
            <span>DUT Travel</span>
        </a>
    </div>
    
    <nav class="admin-nav">
        <div class="admin-nav-section">
            <div class="admin-nav-title">Menu</div>
            
            <a href="<%= request.getContextPath() %>/admin/dashboard" 
               class="admin-nav-item <%= adminPath.contains("/dashboard") ? "active" : "" %>">
                <span class="icon">📊</span>
                <span>Dashboard</span>
            </a>
            
            <a href="<%= request.getContextPath() %>/admin/tours" 
               class="admin-nav-item <%= adminPath.contains("/tours") ? "active" : "" %>">
                <span class="icon">🏖️</span>
                <span>Quản lý Tour</span>
            </a>
            
            <a href="<%= request.getContextPath() %>/admin/bookings" 
               class="admin-nav-item <%= adminPath.contains("/bookings") ? "active" : "" %>">
                <span class="icon">📋</span>
                <span>Đơn đặt tour</span>
            </a>
            
            <a href="<%= request.getContextPath() %>/admin/hotels" 
               class="admin-nav-item <%= adminPath.contains("/hotels") ? "active" : "" %>">
                <span class="icon">🏨</span>
                <span>Khách sạn</span>
            </a>
            
            <a href="<%= request.getContextPath() %>/admin/users" 
               class="admin-nav-item <%= adminPath.contains("/users") ? "active" : "" %>">
                <span class="icon">👥</span>
                <span>Người dùng</span>
            </a>
            
            <a href="<%= request.getContextPath() %>/admin/reviews" 
               class="admin-nav-item <%= adminPath.contains("/reviews") ? "active" : "" %>">
                <span class="icon">💬</span>
                <span>Đánh giá</span>
            </a>
        </div>
    </nav>
    
    <div class="admin-user">
        <div class="admin-user-content">
            <div class="admin-user-avatar">
                <%= adminUser != null && adminUser.getHotennguoidung() != null ? 
                    adminUser.getHotennguoidung().substring(0, 1).toUpperCase() : "A" %>
            </div>
            <div class="admin-user-info">
                <div class="admin-user-name">
                    <%= adminUser != null ? adminUser.getHotennguoidung() : "Admin" %>
                </div>
                <div class="admin-user-role">(Admin)</div>
            </div>
        </div>
        <a href="<%= request.getContextPath() %>/logout" class="admin-logout-btn">
            🚪 Đăng xuất
        </a>
    </div>
</aside>

