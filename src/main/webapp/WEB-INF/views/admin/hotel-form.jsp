<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tourdulich.model.KhachSan" %>
<%@ page import="com.tourdulich.model.NguoiDung" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%
        Boolean isEdit = (Boolean) request.getAttribute("isEdit");
        KhachSan hotel = (KhachSan) request.getAttribute("hotel");
        String pageTitle = (isEdit != null && isEdit) ? "Sửa Khách sạn" : "Thêm Khách sạn mới";
    %>
    <title><%= pageTitle %> - DUT Travel Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/dut-theme.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin-theme.css">
    <style>
        .form-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            border: 1px solid #e5e7eb;
            overflow: hidden;
            max-width: 800px;
        }
        
        .form-card-header {
            padding: 24px 28px;
            border-bottom: 1px solid #e5e7eb;
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
        }
        
        .form-card-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: #1f2937;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .form-card-title .icon {
            font-size: 1.3rem;
        }
        
        .form-card-body {
            padding: 28px;
        }
        
        .form-section {
            margin-bottom: 28px;
        }
        
        .form-section:last-child {
            margin-bottom: 0;
        }
        
        .form-section-title {
            font-size: 0.85rem;
            font-weight: 600;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 16px;
            padding-bottom: 8px;
            border-bottom: 2px solid #f3f4f6;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group:last-child {
            margin-bottom: 0;
        }
        
        .form-label {
            display: block;
            font-size: 0.9rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }
        
        .form-label .required {
            color: #ef4444;
            margin-left: 2px;
        }
        
        .form-label .hint {
            font-weight: 400;
            color: #9ca3af;
            font-size: 0.8rem;
        }
        
        .form-input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 0.95rem;
            color: #1f2937;
            background: #fafbfc;
            transition: all 0.2s ease;
        }
        
        .form-input:hover {
            border-color: #d1d5db;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #3b82f6;
            background: white;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
        }
        
        .form-input::placeholder {
            color: #9ca3af;
        }
        
        .input-with-icon {
            position: relative;
        }
        
        .input-with-icon .icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.1rem;
            color: #6b7280;
        }
        
        .input-with-icon .form-input {
            padding-left: 44px;
        }
        
        .price-input-wrapper {
            position: relative;
        }
        
        .price-input-wrapper .currency {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            font-weight: 600;
            color: #6b7280;
            font-size: 0.9rem;
        }
        
        .price-input-wrapper .form-input {
            padding-right: 60px;
        }
        
        .image-preview-container {
            margin-top: 12px;
            display: none;
        }
        
        .image-preview-container.visible {
            display: block;
        }
        
        .image-preview {
            max-width: 300px;
            max-height: 200px;
            border-radius: 10px;
            object-fit: cover;
            border: 2px solid #e5e7eb;
        }
        
        .star-options {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        
        .star-option {
            display: none;
        }
        
        .star-option-label {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 10px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
            background: white;
            font-size: 0.9rem;
        }
        
        .star-option:checked + .star-option-label {
            border-color: #f59e0b;
            background: #fffbeb;
        }
        
        .star-option-label:hover {
            border-color: #fbbf24;
        }
        
        .star-option-label .stars {
            color: #f59e0b;
        }
        
        .status-toggle {
            display: flex;
            gap: 12px;
        }
        
        .status-option {
            display: none;
        }
        
        .status-option-label {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.2s ease;
            font-weight: 500;
        }
        
        .status-option-label .icon {
            font-size: 1.2rem;
        }
        
        .status-option:checked + .status-option-label.available {
            border-color: #10b981;
            background: #ecfdf5;
            color: #059669;
        }
        
        .status-option:checked + .status-option-label.unavailable {
            border-color: #ef4444;
            background: #fef2f2;
            color: #dc2626;
        }
        
        .status-option-label:hover {
            border-color: #d1d5db;
        }
        
        .form-actions {
            display: flex;
            gap: 12px;
            padding-top: 24px;
            border-top: 2px solid #f3f4f6;
            margin-top: 8px;
        }
        
        .btn-submit {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 14px 28px;
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(59, 130, 246, 0.4);
        }
        
        .btn-cancel {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 14px 28px;
            background: #f3f4f6;
            color: #6b7280;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
        }
        
        .btn-cancel:hover {
            background: #e5e7eb;
            color: #374151;
        }
        
        @media (max-width: 640px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .star-options {
                flex-direction: column;
            }
            
            .status-toggle {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="admin-layout">
        <%@ include file="/WEB-INF/includes/admin-sidebar.jsp" %>
        
        <main class="admin-main">
            <header class="admin-header">
                <h1 class="admin-header-title">🏨 <%= pageTitle %></h1>
                <div class="admin-header-actions">
                    <a href="<%= request.getContextPath() %>/admin/hotels" class="btn btn-secondary">
                        ← Quay lại danh sách
                    </a>
                </div>
            </header>
            
            <div class="admin-content">
                <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-error">
                    ❌ Có lỗi xảy ra, vui lòng kiểm tra lại thông tin!
                </div>
                <% } %>
                
                <form action="<%= request.getContextPath() %>/admin/hotels/<%= isEdit != null && isEdit ? "edit" : "add" %>" 
                      method="POST" id="hotelForm">
                    
                    <% if (isEdit != null && isEdit && hotel != null) { %>
                    <input type="hidden" name="id" value="<%= hotel.getId() %>">
                    <% } %>
                    
                    <div class="form-card">
                        <div class="form-card-header">
                            <h2 class="form-card-title">
                                <span class="icon">📝</span>
                                Thông tin khách sạn
                            </h2>
                        </div>
                        
                        <div class="form-card-body">
                            <div class="form-section">
                                <h3 class="form-section-title">Thông tin cơ bản</h3>
                                
                                <div class="form-row">
                                    <div class="form-group">
                                        <label class="form-label">
                                            Mã khách sạn <span class="required">*</span>
                                        </label>
                                        <div class="input-with-icon">
                                            <span class="icon">🏷️</span>
                                            <input type="text" name="makhachsan" class="form-input" required
                                                   value="<%= hotel != null && hotel.getMakhachsan() != null ? hotel.getMakhachsan() : "" %>"
                                                   placeholder="VD: KS001">
                                        </div>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label class="form-label">
                                            Tên khách sạn <span class="required">*</span>
                                        </label>
                                        <div class="input-with-icon">
                                            <span class="icon">🏨</span>
                                            <input type="text" name="tenkhachsan" class="form-input" required
                                                   value="<%= hotel != null && hotel.getTenkhachsan() != null ? hotel.getTenkhachsan() : "" %>"
                                                   placeholder="VD: Vinpearl Resort & Spa">
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label class="form-label">
                                        Địa chỉ <span class="hint">(địa chỉ đầy đủ)</span>
                                    </label>
                                    <div class="input-with-icon">
                                        <span class="icon">📍</span>
                                        <input type="text" name="diachi" class="form-input"
                                               value="<%= hotel != null && hotel.getDiachi() != null ? hotel.getDiachi() : "" %>"
                                               placeholder="VD: 123 Trần Phú, Nha Trang, Khánh Hòa">
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label class="form-label">
                                        URL Hình ảnh <span class="hint">(link ảnh khách sạn)</span>
                                    </label>
                                    <div class="input-with-icon">
                                        <span class="icon">🖼️</span>
                                        <input type="url" name="hinhanh" class="form-input" id="hinhanh-input"
                                               value="<%= hotel != null && hotel.getHinhanh() != null ? hotel.getHinhanh() : "" %>"
                                               placeholder="https:
                                               oninput="previewImage(this.value)">
                                    </div>
                                    <div class="image-preview-container" id="previewContainer">
                                        <img src="" alt="Preview" class="image-preview" id="imagePreview">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-section">
                                <h3 class="form-section-title">Phân loại & Giá cả</h3>
                                
                                <div class="form-group">
                                    <label class="form-label">Chất lượng (hạng sao)</label>
                                    <div class="star-options">
                                        <% 
                                            String[] starOptions = {"1 sao", "2 sao", "3 sao", "4 sao", "5 sao"};
                                            String[] starSymbols = {"⭐", "⭐⭐", "⭐⭐⭐", "⭐⭐⭐⭐", "⭐⭐⭐⭐⭐"};
                                            for (int i = 0; i < starOptions.length; i++) {
                                                String starValue = starOptions[i];
                                                String stars = starSymbols[i];
                                                boolean isSelected = hotel != null && starValue.equals(hotel.getChatluong());
                                        %>
                                        <div>
                                            <input type="radio" name="chatluong" value="<%= starValue %>" 
                                                   id="star<%= i+1 %>" class="star-option"
                                                   <%= isSelected ? "checked" : "" %>>
                                            <label for="star<%= i+1 %>" class="star-option-label">
                                                <span class="stars"><%= stars %></span>
                                                <span><%= starValue %></span>
                                            </label>
                                        </div>
                                        <% } %>
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group">
                                        <label class="form-label">
                                            Giá phòng/đêm <span class="required">*</span>
                                        </label>
                                        <div class="price-input-wrapper">
                                            <input type="number" name="gia" class="form-input" 
                                                   min="0" step="10000" required
                                                   value="<%= hotel != null && hotel.getGia() != null ? hotel.getGia().intValue() : "" %>"
                                                   placeholder="1500000">
                                            <span class="currency">VNĐ</span>
                                        </div>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label class="form-label">Ngày áp dụng giá</label>
                                        <input type="date" name="ngayden" class="form-input"
                                               value="<%= hotel != null && hotel.getNgayden() != null ? hotel.getNgayden() : "" %>">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-section">
                                <h3 class="form-section-title">Trạng thái phòng</h3>
                                
                                <div class="form-group">
                                    <div class="status-toggle">
                                        <div>
                                            <input type="radio" name="trangthai" value="CON_PHONG" 
                                                   id="statusAvailable" class="status-option"
                                                   <%= hotel == null || hotel.getTrangthai() == null || hotel.getTrangthai() == KhachSan.TrangThai.CON_PHONG ? "checked" : "" %>>
                                            <label for="statusAvailable" class="status-option-label available">
                                                <span class="icon">✅</span>
                                                <span>Còn phòng</span>
                                            </label>
                                        </div>
                                        <div>
                                            <input type="radio" name="trangthai" value="HET_PHONG" 
                                                   id="statusUnavailable" class="status-option"
                                                   <%= hotel != null && hotel.getTrangthai() == KhachSan.TrangThai.HET_PHONG ? "checked" : "" %>>
                                            <label for="statusUnavailable" class="status-option-label unavailable">
                                                <span class="icon">🚫</span>
                                                <span>Hết phòng</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-actions">
                                <button type="submit" class="btn-submit">
                                    <%= isEdit != null && isEdit ? "💾 Lưu thay đổi" : "➕ Thêm khách sạn" %>
                                </button>
                                <a href="<%= request.getContextPath() %>/admin/hotels" class="btn-cancel">
                                    Hủy bỏ
                                </a>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </main>
    </div>
    
    <script>

        document.addEventListener('DOMContentLoaded', function() {
            var imageUrl = document.getElementById('hinhanh-input').value;
            if (imageUrl && imageUrl.trim() !== '') {
                previewImage(imageUrl);
            }
        });
        
        function previewImage(url) {
            var preview = document.getElementById('imagePreview');
            var container = document.getElementById('previewContainer');
            
            if (url && url.trim() !== '') {
                preview.src = url;
                preview.onerror = function() {
                    container.classList.remove('visible');
                };
                preview.onload = function() {
                    container.classList.add('visible');
                };
            } else {
                container.classList.remove('visible');
            }
        }
        

        document.getElementById('hotelForm').addEventListener('submit', function(e) {
            var makhachsan = document.querySelector('input[name="makhachsan"]').value.trim();
            var tenkhachsan = document.querySelector('input[name="tenkhachsan"]').value.trim();
            var gia = document.querySelector('input[name="gia"]').value;
            
            if (!makhachsan || !tenkhachsan) {
                e.preventDefault();
                return false;
            }
            
            if (gia && parseInt(gia) < 0) {
                e.preventDefault();
                return false;
            }
        });
    </script>
</body>
</html>
