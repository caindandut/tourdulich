<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tourdulich.model.NguoiDung" %>
<%
    NguoiDung currentUser = (NguoiDung) session.getAttribute("currentUser");
    String currentPath = request.getRequestURI();
%>
<header class="wink-header">
    <div class="header-container">
        <a href="<%= request.getContextPath() %>/home" class="logo">
            <span class="logo-icon">🌍</span>
            <span>DUT Travel</span>
        </a>
        
        <nav class="nav-menu">
            <a href="<%= request.getContextPath() %>/home" class="nav-link <%= currentPath.contains("/home") ? "active" : "" %>">Trang chủ</a>
            <a href="<%= request.getContextPath() %>/search" class="nav-link <%= currentPath.contains("/search") ? "active" : "" %>">Tour</a>
            
            <% if (currentUser != null) { %>
                <% if (currentUser.getRole() == NguoiDung.Role.ADMIN) { %>
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="nav-link">Quản trị</a>
                <% } %>
                
                <div class="user-menu">
                    <a href="<%= request.getContextPath() %>/profile" class="nav-link">
                        👤 <%= currentUser.getHotennguoidung() %>
                    </a>
                    <a href="<%= request.getContextPath() %>/logout" class="btn-header btn-login">Đăng xuất</a>
                </div>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/login" class="btn-header btn-login">Đăng nhập</a>
                <a href="<%= request.getContextPath() %>/register" class="btn-header btn-register">Đăng ký</a>
            <% } %>
        </nav>
    </div>
</header>



