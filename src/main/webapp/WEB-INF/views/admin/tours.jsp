<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tourdulich.model.Tour" %>
<%@ page import="com.tourdulich.model.NguoiDung" %>
<%@ page import="com.tourdulich.model.DanhGia" %>
<%@ page import="com.tourdulich.dao.DanhGiaDAO" %>
<%@ page import="com.tourdulich.dao.impl.DanhGiaDAOImpl" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Tour - DUT Travel Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/dut-theme.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin-theme.css">
</head>
<body>
    <div class="admin-layout">
        <%@ include file="/WEB-INF/includes/admin-sidebar.jsp" %>
        
        <main class="admin-main">
            <header class="admin-header">
                <h1 class="admin-header-title">Tất cả các Tour</h1>
                <div class="admin-header-actions">
                    <a href="<%= request.getContextPath() %>/admin/tours/add" class="btn btn-primary">
                        ➕ Thêm Tour
                    </a>
                </div>
            </header>
            
            <div class="admin-content">
                <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success">
                    ✅ 
                    <% 
                        String success = request.getParameter("success");
                        if ("created".equals(success)) out.print("Thêm tour thành công!");
                        else if ("updated".equals(success)) out.print("Cập nhật tour thành công!");
                        else if ("deleted".equals(success)) out.print("Xóa tour thành công!");
                    %>
                </div>
                <% } %>
                
                <div class="admin-table-card">
                    <div class="admin-table-header">
                        <h3 class="admin-table-title">Tất cả các Tour</h3>
                    </div>
                    
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Tên Tour</th>
                                <th>Ảnh</th>
                                <th>Lịch trình/Giá</th>
                                <th>Thông tin/Địa Điểm</th>
                                <th>Trạng Thái</th>
                                <th>Đánh Giá</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                @SuppressWarnings("unchecked")
                                List<Tour> tours = (List<Tour>) request.getAttribute("tours");
                                Integer currentPage = (Integer) request.getAttribute("currentPage");
                                Boolean needsPagination = (Boolean) request.getAttribute("needsPagination");
                                int pageSize = 6;
                                int startStt = 1;
                                if (needsPagination != null && needsPagination && currentPage != null && currentPage > 1) {
                                    startStt = (currentPage - 1) * pageSize + 1;
                                }
                                if (tours != null && !tours.isEmpty()) {
                                    int stt = startStt;
                                    for (Tour tour : tours) {
                            %>
                            <tr>
                                <td><%= stt++ %></td>
                                <td>
                                    <a href="<%= request.getContextPath() %>/tour/detail?id=<%= tour.getId() %>" 
                                       style="color: var(--accent-color); font-weight: 500; text-decoration: none;">
                                        <%= tour.getTentour() %>
                                    </a>
                                </td>
                                <td>
                                    <% if (tour.getHinhanh() != null && !tour.getHinhanh().trim().isEmpty()) { %>
                                        <img src="<%= tour.getHinhanh() %>" alt="<%= tour.getTentour() %>" class="table-image"
                                             onerror="this.outerHTML='<div class=\\'table-image-placeholder\\'>🏖️</div>'">
                                    <% } else { %>
                                        <div class="table-image-placeholder">🏖️</div>
                                    <% } %>
                                </td>
                                <td>
                                    <div class="table-meta">
                                        <strong>Hành Trình:</strong> <%= tour.getDiadiem() %><br>
                                        <strong>Lịch Trình:</strong> <%= tour.getThoiluong() %><br>
                                        <strong>Giá:</strong> <span class="table-price"><%= String.format("%,.0f", tour.getGia()) %>VND</span>
                                    </div>
                                </td>
                                <td>
                                    <div class="table-meta">
                                        <strong>Địa điểm:</strong> <%= tour.getDiadiem() %><br>
                                        <strong>Di Chuyển:</strong> <%= tour.getPhuongtienchinh() != null ? tour.getPhuongtienchinh() : "Xe du lịch" %><br>
                                        <strong>Điểm Xuất Phát:</strong> <%= tour.getDiadiem() %><br>
                                        <strong>Ngày đi:</strong> <%= tour.getNgaykhoihanh() != null ? tour.getNgaykhoihanh().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "N/A" %>
                                    </div>
                                </td>
                                <td>
                                    <span class="status-badge <%= tour.getStatus() == Tour.Status.ACTIVE ? "active" : "inactive" %>">
                                        <%= tour.getStatus() == Tour.Status.ACTIVE ? "Hoạt động" : "Tạm dừng" %>
                                    </span>
                                </td>
                                <td>
                                    <%
                                        DanhGiaDAO danhGiaDAO = new DanhGiaDAOImpl();
                                        List<DanhGia> reviews = danhGiaDAO.findByTourId(tour.getId());
                                        double avgRating = 0.0;
                                        if (reviews != null && !reviews.isEmpty()) {
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
                                        if (avgRating > 0) {
                                            int fullStars = (int) Math.floor(avgRating);
                                            boolean hasHalfStar = (avgRating - fullStars) >= 0.5;
                                            int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);
                                    %>
                                    <span class="rating-badge" style="display: inline-flex; align-items: center; gap: 3px; background: #f0f9ff; padding: 4px 8px; border-radius: 6px;">
                                        <% for (int i = 0; i < fullStars; i++) { %>
                                            <span style="color: #f59e0b; font-size: 1.2rem; font-weight: bold;">★</span>
                                        <% } %>
                                        <% if (hasHalfStar) { %>
                                            <span style="color: #f59e0b; font-size: 1.2rem; font-weight: bold;">☆</span>
                                        <% } %>
                                        <% for (int i = 0; i < emptyStars; i++) { %>
                                            <span style="color: #cbd5e1; font-size: 1.2rem;">★</span>
                                        <% } %>
                                        <span style="margin-left: 6px; font-size: 0.9em; color: #1e293b; font-weight: 600;">(<%= String.format("%.1f", avgRating) %>)</span>
                                    </span>
                                    <% } else { %>
                                    <span class="rating-badge" style="background: #f1f5f9; padding: 4px 8px; border-radius: 6px; color: #64748b; font-weight: 500;">Chưa có</span>
                                    <% } %>
                                </td>
                                <td>
                                    <div class="table-actions">
                                        <a href="<%= request.getContextPath() %>/admin/tours/edit/<%= tour.getId() %>" 
                                           class="btn-action edit" title="Sửa">Sửa</a>
                                        <button onclick="confirmDelete(<%= tour.getId() %>)" 
                                                class="btn-action delete" title="Xóa">Xóa</button>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="8" style="text-align: center; padding: 40px; color: var(--text-secondary);">
                                    Chưa có tour nào. <a href="<%= request.getContextPath() %>/admin/tours/add">Thêm tour mới</a>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                
                <% 
                    Integer totalPages = (Integer) request.getAttribute("totalPages");
                    
                    if (needsPagination != null && needsPagination && totalPages != null && totalPages > 1) {
                %>
                <div class="pagination" style="margin-top: 24px;">
                    <% if (currentPage > 1) { %>
                    <a href="<%= request.getContextPath() %>/admin/tours?page=<%= currentPage - 1 %>" class="pagination-item">←</a>
                    <% } %>
                    
                    <% 
                        int startPage = Math.max(1, currentPage - 2);
                        int endPage = Math.min(totalPages, currentPage + 2);
                        
                        if (startPage > 1) {
                    %>
                    <a href="<%= request.getContextPath() %>/admin/tours?page=1" class="pagination-item">1</a>
                    <% if (startPage > 2) { %>
                    <span class="pagination-item" style="cursor: default;">...</span>
                    <% } %>
                    <% } %>
                    
                    <% for (int i = startPage; i <= endPage; i++) { %>
                    <a href="<%= request.getContextPath() %>/admin/tours?page=<%= i %>" 
                       class="pagination-item <%= i == currentPage ? "active" : "" %>"><%= i %></a>
                    <% } %>
                    
                    <% if (endPage < totalPages) { %>
                    <% if (endPage < totalPages - 1) { %>
                    <span class="pagination-item" style="cursor: default;">...</span>
                    <% } %>
                    <a href="<%= request.getContextPath() %>/admin/tours?page=<%= totalPages %>" class="pagination-item"><%= totalPages %></a>
                    <% } %>
                    
                    <% if (currentPage < totalPages) { %>
                    <a href="<%= request.getContextPath() %>/admin/tours?page=<%= currentPage + 1 %>" class="pagination-item">→</a>
                    <% } %>
                </div>
                <% } %>
            </div>
        </main>
    </div>
    
    <script>
        function confirmDelete(tourId) {
            window.location.href = '<%= request.getContextPath() %>/admin/tours/delete/' + tourId;
        }
    </script>
</body>
</html>
