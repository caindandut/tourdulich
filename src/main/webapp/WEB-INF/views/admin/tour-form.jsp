<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tourdulich.model.Tour" %>
<%@ page import="com.tourdulich.model.NguoiDung" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%
        Tour tour = (Tour) request.getAttribute("tour");
        boolean isEdit = tour != null && tour.getId() != null;
    %>
    <title><%= isEdit ? "Sửa Tour" : "Thêm Tour" %> - DUT Travel Admin</title>
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
                <h1 class="admin-header-title"><%= isEdit ? "Sửa Tour" : "Thêm Tour mới" %></h1>
                <div class="admin-header-actions">
                    <a href="<%= request.getContextPath() %>/admin/tours" class="btn btn-secondary">
                        ← Quay lại
                    </a>
                </div>
            </header>
            
            <div class="admin-content">
                <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-error">
                    ❌ Có lỗi xảy ra. Vui lòng thử lại!
                </div>
                <% } %>
                
                <div class="admin-form-card">
                    <div class="admin-form-header">
                        <h3 class="admin-form-title">Nội dung</h3>
                    </div>
                    
                    <div class="admin-form-body">
                        <form action="<%= request.getContextPath() %>/admin/tours/<%= isEdit ? "edit/" + tour.getId() : "add" %>" method="POST">
                            <% if (isEdit) { %>
                            <input type="hidden" name="id" value="<%= tour.getId() %>">
                            <% } %>
                            
                            <div class="admin-form-group">
                                <label>Tên Tour *</label>
                                <input type="text" name="tentour" placeholder="Tên Tour" required
                                       value="<%= isEdit ? tour.getTentour() : "" %>">
                            </div>
                            
                            <div class="admin-form-row">
                                <div class="admin-form-group">
                                    <label>Địa Điểm *</label>
                                    <input type="text" name="diadiem" placeholder="VD: Đà Nẵng, Hội An" required
                                           value="<%= isEdit && tour.getDiadiem() != null ? tour.getDiadiem() : "" %>">
                                </div>
                                <div class="admin-form-group">
                                    <label>Trạng Thái</label>
                                    <select name="status">
                                        <option value="ACTIVE" <%= !isEdit || tour.getStatus() == Tour.Status.ACTIVE ? "selected" : "" %>>Hoạt động</option>
                                        <option value="INACTIVE" <%= isEdit && tour.getStatus() == Tour.Status.INACTIVE ? "selected" : "" %>>Tạm dừng</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="admin-form-row">
                                <div class="admin-form-group">
                                    <label>Giá (VND) *</label>
                                    <input type="number" name="gia" placeholder="Giá" required
                                           value="<%= isEdit && tour.getGia() != null ? String.format("%.0f", tour.getGia()) : "" %>">
                                </div>
                                <div class="admin-form-group">
                                    <label>Lịch Trình *</label>
                                    <input type="text" name="thoiluong" placeholder="VD: 2 ngày 1 đêm" required
                                           value="<%= isEdit && tour.getThoiluong() != null ? tour.getThoiluong() : "" %>">
                                </div>
                            </div>
                            
                            <div class="admin-form-row">
                                <div class="admin-form-group">
                                    <label>Phương tiện di chuyển</label>
                                    <input type="text" name="phuongtienchinh" placeholder="VD: Xe du lịch, Máy bay"
                                           value="<%= isEdit && tour.getPhuongtienchinh() != null ? tour.getPhuongtienchinh() : "" %>">
                                </div>
                                <div class="admin-form-group">
                                    <label>Ngày khởi hành</label>
                                    <input type="date" name="ngaykhoihanh"
                                           value="<%= isEdit && tour.getNgaykhoihanh() != null ? tour.getNgaykhoihanh().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) : "" %>">
                                </div>
                            </div>
                            
                            <div class="admin-form-group">
                                <label>URL Hình ảnh</label>
                                <input type="text" name="hinhanh" placeholder="https:
                                       value="<%= isEdit && tour.getHinhanh() != null ? tour.getHinhanh() : "" %>">
                                <% if (isEdit && tour.getHinhanh() != null && !tour.getHinhanh().isEmpty()) { %>
                                <div style="margin-top: 10px;">
                                    <img src="<%= tour.getHinhanh() %>" alt="Preview" style="max-width: 200px; border-radius: 8px;">
                                </div>
                                <% } %>
                            </div>
                            
                            <div class="admin-form-group">
                                <label>Mô tả tour</label>
                                <textarea name="mota" placeholder="Mô tả chi tiết về tour..." rows="6"><%= isEdit && tour.getMota() != null ? tour.getMota() : "" %></textarea>
                            </div>
                            
                            <div class="admin-form-actions">
                                <button type="submit" class="btn btn-primary">
                                    <%= isEdit ? "💾 Cập nhật Tour" : "➕ Thêm Tour" %>
                                </button>
                                <a href="<%= request.getContextPath() %>/admin/tours" class="btn btn-secondary">
                                    Hủy bỏ
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
