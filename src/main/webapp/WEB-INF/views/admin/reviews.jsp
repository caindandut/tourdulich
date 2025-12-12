<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tourdulich.model.DanhGia" %>
<%@ page import="com.tourdulich.model.NguoiDung" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Đánh giá - DUT Travel Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/dut-theme.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin-theme.css">
    <style>
        .review-content {
            max-width: 400px;
            word-wrap: break-word;
            white-space: normal;
            line-height: 1.5;
        }
    </style>
</head>
<body>
    <div class="admin-layout">
        <%@ include file="/WEB-INF/includes/admin-sidebar.jsp" %>
        
        <main class="admin-main">
            <header class="admin-header">
                <h1 class="admin-header-title">Danh sách bình luận</h1>
            </header>
            
            <div class="admin-content">
                <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success">
                    ✅ 
                    <% 
                        String success = request.getParameter("success");
                        if ("deleted".equals(success)) out.print("Đã xóa đánh giá!");
                        else if ("status_updated".equals(success)) out.print("Đã cập nhật trạng thái!");
                        else out.print("Cập nhật thành công!");
                    %>
                </div>
                <% } %>
                
                <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-error">
                    ❌ 
                    <% 
                        String error = request.getParameter("error");
                        if ("update_failed".equals(error)) out.print("Cập nhật thất bại!");
                        else if ("delete_failed".equals(error)) out.print("Xóa thất bại!");
                        else out.print("Có lỗi xảy ra!");
                    %>
                </div>
                <% } %>
                
                <div class="admin-table-card">
                    <div class="admin-table-header">
                        <h3 class="admin-table-title">Danh sách bình luận</h3>
                    </div>
                    
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Tên User</th>
                                <th>Email</th>
                                <th>Tour</th>
                                <th>Nội dung</th>
                                <th>Trạng Thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                @SuppressWarnings("unchecked")
                                List<DanhGia> reviews = (List<DanhGia>) request.getAttribute("reviews");
                                if (reviews != null && !reviews.isEmpty()) {
                                    int stt = 1;
                                    for (DanhGia review : reviews) {
                                        boolean isVisible = review.getTrangthai() == null || review.getTrangthai() == DanhGia.TrangThai.HIEN_THI;
                            %>
                            <tr style="<%= !isVisible ? "opacity: 0.6;" : "" %>">
                                <td><%= stt++ %></td>
                                <td>
                                    <span style="color: var(--accent-color); font-weight: 500;">
                                        <%= review.getKhachHang() != null && review.getKhachHang().getNguoiDung() != null 
                                            ? review.getKhachHang().getNguoiDung().getHotennguoidung() 
                                            : "Khách #" + review.getKhachhangId() %>
                                    </span>
                                </td>
                                <td>
                                    <%= review.getKhachHang() != null && review.getKhachHang().getNguoiDung() != null 
                                        ? review.getKhachHang().getNguoiDung().getEmail() 
                                        : "---" %>
                                </td>
                                <td>
                                    <%= review.getTour() != null ? review.getTour().getTentour() : "Tour #" + review.getTourId() %>
                                </td>
                                <td>
                                    <div class="review-content">
                                        <%= review.getNoidung() != null ? review.getNoidung() : "---" %>
                                    </div>
                                    <div style="margin-top: 4px;">
                                        <span class="rating-badge"><%= review.getRating() != null ? review.getRating() : 5 %>.0 ⭐</span>
                                        <% if (review.getThoigian() != null) { %>
                                        <small style="color: #64748b; margin-left: 8px;">
                                            <%= review.getThoigian().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) %>
                                        </small>
                                        <% } %>
                                    </div>
                                </td>
                                <td>
                                    <% if (isVisible) { %>
                                    <span class="status-badge success">Hiển thị</span>
                                    <% } else { %>
                                    <span class="status-badge danger">Đã ẩn</span>
                                    <% } %>
                                </td>
                                <td>
                                    <div class="table-actions">
                                        <% if (isVisible) { %>
                                        <a href="<%= request.getContextPath() %>/admin/reviews/hide/<%= review.getId() %>" 
                                           class="btn-action delete" title="Ẩn đánh giá">Ẩn</a>
                                        <% } else { %>
                                        <a href="<%= request.getContextPath() %>/admin/reviews/show/<%= review.getId() %>" 
                                           class="btn-action edit" title="Hiện đánh giá">Hiện</a>
                                        <% } %>
                                        <a href="<%= request.getContextPath() %>/admin/reviews/delete/<%= review.getId() %>" 
                                           class="btn-action delete" title="Xóa">Xóa</a>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="7" style="text-align: center; padding: 40px; color: var(--text-secondary);">
                                    Chưa có đánh giá nào.
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
