<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tourdulich.model.KhachSan" %>
<%@ page import="com.tourdulich.model.NguoiDung" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Khách sạn - DUT Travel Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/dut-theme.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin-theme.css">
    <style>
        .hotel-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
            gap: 24px;
        }
        
        .hotel-card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            border: 1px solid #e5e7eb;
            transition: all 0.3s ease;
        }
        
        .hotel-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.12);
        }
        
        .hotel-card-image {
            position: relative;
            height: 180px;
            overflow: hidden;
        }
        
        .hotel-card-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        
        .hotel-card:hover .hotel-card-image img {
            transform: scale(1.05);
        }
        
        .hotel-card-placeholder {
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #3b4d9b 0%, #5b6fc4 50%, #7c8bd6 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            gap: 8px;
        }
        
        .hotel-card-placeholder .icon {
            font-size: 3rem;
            opacity: 0.9;
        }
        
        .hotel-card-placeholder .text {
            color: rgba(255,255,255,0.8);
            font-size: 0.85rem;
        }
        
        .hotel-card-badge {
            position: absolute;
            top: 12px;
            left: 12px;
            display: flex;
            gap: 8px;
        }
        
        .hotel-star-badge {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: white;
            padding: 5px 10px;
            border-radius: 16px;
            font-size: 0.75rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 4px;
            box-shadow: 0 2px 8px rgba(217, 119, 6, 0.3);
        }
        
        .hotel-status-badge {
            padding: 5px 10px;
            border-radius: 16px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        
        .hotel-status-badge.available {
            background: rgba(16, 185, 129, 0.9);
            color: white;
        }
        
        .hotel-status-badge.unavailable {
            background: rgba(239, 68, 68, 0.9);
            color: white;
        }
        
        .hotel-card-actions-overlay {
            position: absolute;
            top: 12px;
            right: 12px;
            display: flex;
            gap: 8px;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .hotel-card:hover .hotel-card-actions-overlay {
            opacity: 1;
        }
        
        .hotel-card-action-btn {
            padding: 6px 12px;
            min-height: 32px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            font-weight: 500;
            transition: all 0.2s ease;
            backdrop-filter: blur(8px);
            white-space: nowrap;
            text-decoration: none;
        }
        
        .hotel-card-action-btn.edit {
            background: rgba(255,255,255,0.95);
            color: #3b82f6;
        }
        
        .hotel-card-action-btn.delete {
            background: rgba(255,255,255,0.95);
            color: #ef4444;
        }
        
        .hotel-card-action-btn:hover {
            transform: scale(1.1);
        }
        
        .hotel-card-body {
            padding: 16px 20px;
        }
        
        .hotel-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 8px;
        }
        
        .hotel-card-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 2px;
            line-height: 1.3;
        }
        
        .hotel-card-code {
            font-size: 0.8rem;
            color: #6b7280;
            font-weight: 500;
        }
        
        .hotel-card-price {
            text-align: right;
        }
        
        .hotel-card-price-value {
            font-size: 1.1rem;
            font-weight: 700;
            color: #059669;
        }
        
        .hotel-card-price-unit {
            font-size: 0.75rem;
            color: #6b7280;
        }
        
        .hotel-card-location {
            display: flex;
            align-items: center;
            gap: 6px;
            color: #6b7280;
            font-size: 0.85rem;
            margin-bottom: 12px;
        }
        
        .hotel-card-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 12px;
            border-top: 1px solid #f3f4f6;
        }
        
        .hotel-card-stat {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 0.8rem;
            color: #6b7280;
        }
        
        .quick-action-btn {
            padding: 6px 14px;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
        }
        
        .quick-action-btn.edit {
            background: #eff6ff;
            color: #3b82f6;
        }
        
        .quick-action-btn.edit:hover {
            background: #dbeafe;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 40px;
            background: white;
            border-radius: 16px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
        }
        
        .empty-state-icon {
            font-size: 4rem;
            margin-bottom: 20px;
        }
        
        .empty-state-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 10px;
        }
        
        .empty-state-desc {
            color: #6b7280;
            margin-bottom: 20px;
        }
        
        .hotel-stats-bar {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }
        
        .hotel-stat-item {
            background: white;
            padding: 16px 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            border: 1px solid #e5e7eb;
        }
        
        .hotel-stat-item .value {
            font-size: 1.75rem;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 2px;
        }
        
        .hotel-stat-item .label {
            font-size: 0.85rem;
            color: #6b7280;
        }
        
        .hotel-stat-item.total .value { color: #3b82f6; }
        .hotel-stat-item.available .value { color: #10b981; }
        .hotel-stat-item.unavailable .value { color: #ef4444; }
        .hotel-stat-item.featured .value { color: #f59e0b; }
        
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }
        
        .modal-overlay.active {
            opacity: 1;
            visibility: visible;
        }
        
        .modal-content {
            background: white;
            padding: 28px;
            border-radius: 16px;
            max-width: 400px;
            width: 90%;
            text-align: center;
            transform: scale(0.9);
            transition: transform 0.3s ease;
        }
        
        .modal-overlay.active .modal-content {
            transform: scale(1);
        }
        
        .modal-icon {
            font-size: 3rem;
            margin-bottom: 12px;
        }
        
        .modal-title {
            font-size: 1.15rem;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 8px;
        }
        
        .modal-desc {
            color: #6b7280;
            margin-bottom: 20px;
            font-size: 0.95rem;
        }
        
        .modal-actions {
            display: flex;
            gap: 12px;
            justify-content: center;
        }
        
        @media (max-width: 768px) {
            .hotel-grid {
                grid-template-columns: 1fr;
            }
            
            .hotel-stats-bar {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
</head>
<body>
    <div class="admin-layout">
        <%@ include file="/WEB-INF/includes/admin-sidebar.jsp" %>
        
        <main class="admin-main">
            <header class="admin-header">
                <h1 class="admin-header-title">🏨 Quản lý Khách sạn</h1>
                <div class="admin-header-actions">
                    <a href="<%= request.getContextPath() %>/admin/hotels/add" class="btn btn-primary">
                        ➕ Thêm Khách sạn
                    </a>
                </div>
            </header>
            
            <div class="admin-content">
                <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success">
                    ✅ 
                    <% 
                        String success = request.getParameter("success");
                        if ("created".equals(success)) out.print("Thêm khách sạn thành công!");
                        else if ("updated".equals(success)) out.print("Cập nhật khách sạn thành công!");
                        else if ("deleted".equals(success)) out.print("Xóa khách sạn thành công!");
                    %>
                </div>
                <% } %>
                
                <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-error">
                    ❌ 
                    <% 
                        String error = request.getParameter("error");
                        if ("not_found".equals(error)) out.print("Không tìm thấy khách sạn!");
                        else if ("delete_failed".equals(error)) out.print("Xóa khách sạn thất bại!");
                        else out.print("Có lỗi xảy ra!");
                    %>
                </div>
                <% } %>
                
                <%
                    @SuppressWarnings("unchecked")
                    List<KhachSan> hotels = (List<KhachSan>) request.getAttribute("hotels");
                    int totalHotels = hotels != null ? hotels.size() : 0;
                    int availableCount = 0;
                    int unavailableCount = 0;
                    int fiveStarCount = 0;
                    
                    if (hotels != null) {
                        for (KhachSan h : hotels) {
                            if (h.getTrangthai() == null || h.getTrangthai() == KhachSan.TrangThai.CON_PHONG) {
                                availableCount++;
                            } else {
                                unavailableCount++;
                            }
                            if ("5 sao".equals(h.getChatluong())) {
                                fiveStarCount++;
                            }
                        }
                    }
                %>
                
                <div class="hotel-stats-bar">
                    <div class="hotel-stat-item total">
                        <div class="value"><%= totalHotels %></div>
                        <div class="label">Tổng khách sạn</div>
                    </div>
                    <div class="hotel-stat-item available">
                        <div class="value"><%= availableCount %></div>
                        <div class="label">Còn phòng</div>
                    </div>
                    <div class="hotel-stat-item unavailable">
                        <div class="value"><%= unavailableCount %></div>
                        <div class="label">Hết phòng</div>
                    </div>
                    <div class="hotel-stat-item featured">
                        <div class="value"><%= fiveStarCount %></div>
                        <div class="label">Khách sạn 5 sao</div>
                    </div>
                </div>
                
                <% if (hotels != null && !hotels.isEmpty()) { %>
                <div class="hotel-grid">
                    <% for (KhachSan hotel : hotels) {
                        boolean conPhong = hotel.getTrangthai() == null || hotel.getTrangthai() == KhachSan.TrangThai.CON_PHONG;
                    %>
                    <div class="hotel-card">
                        <div class="hotel-card-image">
                            <% if (hotel.getHinhanh() != null && !hotel.getHinhanh().isEmpty()) { %>
                            <img src="<%= hotel.getHinhanh() %>" alt="<%= hotel.getTenkhachsan() %>" 
                                 onerror="this.parentElement.innerHTML='<div class=\'hotel-card-placeholder\'><span class=\'icon\'>🏨</span><span class=\'text\'>Không tải được ảnh</span></div>'">
                            <% } else { %>
                            <div class="hotel-card-placeholder">
                                <span class="icon">🏨</span>
                                <span class="text">Chưa có hình ảnh</span>
                            </div>
                            <% } %>
                            
                            <div class="hotel-card-badge">
                                <% if (hotel.getChatluong() != null && !hotel.getChatluong().isEmpty()) { %>
                                <span class="hotel-star-badge">
                                    ⭐ <%= hotel.getChatluong() %>
                                </span>
                                <% } %>
                                <span class="hotel-status-badge <%= conPhong ? "available" : "unavailable" %>">
                                    <%= conPhong ? "Còn phòng" : "Hết phòng" %>
                                </span>
                            </div>
                            
                            <div class="hotel-card-actions-overlay">
                                <a href="<%= request.getContextPath() %>/admin/hotels/edit?id=<%= hotel.getId() %>" 
                                   class="hotel-card-action-btn edit" title="Chỉnh sửa">Sửa</a>
                                <button onclick="showDeleteModal(<%= hotel.getId() %>, '<%= hotel.getTenkhachsan() %>')" 
                                        class="hotel-card-action-btn delete" title="Xóa">Xóa</button>
                            </div>
                        </div>
                        
                        <div class="hotel-card-body">
                            <div class="hotel-card-header">
                                <div>
                                    <h3 class="hotel-card-title"><%= hotel.getTenkhachsan() %></h3>
                                    <span class="hotel-card-code">Mã: <%= hotel.getMakhachsan() %></span>
                                </div>
                                <div class="hotel-card-price">
                                    <div class="hotel-card-price-value">
                                        <%= hotel.getGia() != null ? String.format("%,.0f", hotel.getGia()) : "0" %>đ
                                    </div>
                                    <div class="hotel-card-price-unit">/đêm</div>
                                </div>
                            </div>
                            
                            <div class="hotel-card-location">
                                <span>📍</span>
                                <span><%= hotel.getDiachi() != null && !hotel.getDiachi().isEmpty() ? hotel.getDiachi() : "Chưa cập nhật địa chỉ" %></span>
                            </div>
                            
                            <div class="hotel-card-footer">
                                <div class="hotel-card-stat">
                                    <span>🛏️</span>
                                    <span><%= conPhong ? "Sẵn sàng" : "Đã đặt hết" %></span>
                                </div>
                                <a href="<%= request.getContextPath() %>/admin/hotels/edit?id=<%= hotel.getId() %>" 
                                   class="quick-action-btn edit">Sửa</a>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                <% } else { %>
                <div class="empty-state">
                    <div class="empty-state-icon">🏨</div>
                    <h3 class="empty-state-title">Chưa có khách sạn nào</h3>
                    <p class="empty-state-desc">Bắt đầu bằng việc thêm khách sạn đầu tiên của bạn</p>
                    <a href="<%= request.getContextPath() %>/admin/hotels/add" class="btn btn-primary">
                        ➕ Thêm Khách sạn mới
                    </a>
                </div>
                <% } %>
            </div>
        </main>
    </div>
    
    <div id="deleteModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-icon">⚠️</div>
            <h3 class="modal-title">Xác nhận xóa</h3>
            <p class="modal-desc">Bạn có chắc chắn muốn xóa khách sạn <strong id="hotelNameToDelete"></strong>?</p>
            <div class="modal-actions">
                <button onclick="hideDeleteModal()" class="btn btn-secondary">Hủy</button>
                <button onclick="confirmDelete()" class="btn btn-primary" style="background: #ef4444;">Xóa</button>
            </div>
        </div>
    </div>
    
    <script>
        var hotelIdToDelete = null;
        
        function showDeleteModal(hotelId, hotelName) {
            hotelIdToDelete = hotelId;
            document.getElementById('hotelNameToDelete').textContent = hotelName;
            document.getElementById('deleteModal').classList.add('active');
        }
        
        function hideDeleteModal() {
            document.getElementById('deleteModal').classList.remove('active');
            hotelIdToDelete = null;
        }
        
        function confirmDelete() {
            if (hotelIdToDelete) {
                window.location.href = '<%= request.getContextPath() %>/admin/hotels/delete?id=' + hotelIdToDelete;
            }
        }
        

        document.getElementById('deleteModal').addEventListener('click', function(e) {
            if (e.target === this) {
                hideDeleteModal();
            }
        });
    </script>
</body>
</html>
