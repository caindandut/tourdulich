<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tourdulich.model.NguoiDung" %>
<%@ page import="com.tourdulich.model.DatTour" %>
<%@ page import="com.tourdulich.model.Tour" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ của tôi - DUT Travel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/dut-theme.css">
    <style>
        .profile-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 24px;
            display: grid;
            grid-template-columns: 280px 1fr;
            gap: 24px;
        }
        
        .profile-sidebar {
            background: white;
            border-radius: 16px;
            padding: 28px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            height: fit-content;
            position: sticky;
            top: 100px;
        }
        
        .profile-avatar {
            width: 90px;
            height: 90px;
            background: linear-gradient(135deg, #3b4d9b, #5b6fc4);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
            margin: 0 auto 16px;
            font-weight: 600;
        }
        
        .profile-name {
            text-align: center;
            font-size: 1.15rem;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 4px;
        }
        
        .profile-email {
            text-align: center;
            color: #64748b;
            font-size: 0.85rem;
            margin-bottom: 20px;
        }
        
        .profile-nav {
            border-top: 1px solid #e2e8f0;
            padding-top: 16px;
        }
        
        .profile-nav-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 14px;
            border-radius: 8px;
            color: #64748b;
            text-decoration: none;
            margin-bottom: 4px;
            font-size: 0.95rem;
            transition: all 0.2s;
            cursor: pointer;
        }
        
        .profile-nav-item:hover {
            background: #f1f5f9;
            color: #3b4d9b;
        }
        
        .profile-nav-item.active {
            background: #eff6ff;
            color: #3b4d9b;
            font-weight: 500;
        }
        
        .profile-nav-item.danger:hover {
            background: #fef2f2;
            color: #dc2626;
        }
        
        .profile-main {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .profile-section {
            background: white;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
        }
        
        .profile-section-title {
            font-size: 1rem;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }
        
        .info-item {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        
        .info-item label {
            font-size: 0.85rem;
            color: #64748b;
        }
        
        .info-item span {
            font-weight: 500;
            color: #1e293b;
        }
        
        .booking-card {
            display: flex;
            gap: 16px;
            padding: 16px;
            background: #f8fafc;
            border-radius: 12px;
            margin-bottom: 12px;
            border: 1px solid #e2e8f0;
        }
        
        .booking-card:last-child {
            margin-bottom: 0;
        }
        
        .booking-image {
            width: 100px;
            height: 75px;
            border-radius: 8px;
            background: linear-gradient(135deg, #3b4d9b, #5b6fc4);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            flex-shrink: 0;
            overflow: hidden;
        }
        
        .booking-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .booking-info {
            flex: 1;
            min-width: 0;
        }
        
        .booking-tour-name {
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 6px;
            font-size: 0.95rem;
        }
        
        .booking-meta {
            font-size: 0.85rem;
            color: #64748b;
            line-height: 1.6;
        }
        
        .booking-meta strong {
            color: #475569;
        }
        
        .booking-price {
            font-weight: 700;
            color: #3b82f6;
            font-size: 1.1rem;
        }
        
        .booking-status {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 8px;
            flex-shrink: 0;
        }
        
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 10px;
            border-radius: 999px;
            font-weight: 600;
            font-size: 0.82rem;
            letter-spacing: 0.1px;
        }
        
        .status-badge::before {
            content: '';
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: currentColor;
        }
        
        .status-badge.pending {
            color: #b45309;
            background: #fff7ed;
            border: 1px solid #fed7aa;
        }
        
        .status-badge.success {
            color: #166534;
            background: #ecfdf3;
            border: 1px solid #bbf7d0;
        }
        
        .status-badge.danger {
            color: #b91c1c;
            background: #fef2f2;
            border: 1px solid #fecdd3;
        }
        
        .status-badge.info {
            color: #1d4ed8;
            background: #eff6ff;
            border: 1px solid #bfdbfe;
        }
        
        .paid-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 10px;
            border-radius: 999px;
            font-weight: 600;
            font-size: 0.82rem;
            letter-spacing: 0.1px;
            color: #166534;
            background: #ecfdf3;
            border: 1px solid #bbf7d0;
        }
        
        .paid-badge::before {
            content: '✔';
            font-size: 0.85rem;
        }
        
        .tab-content {
            display: none;
        }
        
        .tab-content.active {
            display: block;
        }
        
        @media (max-width: 900px) {
            .profile-container {
                grid-template-columns: 1fr;
            }
            
            .profile-sidebar {
                position: static;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
            
            .booking-card {
                flex-direction: column;
            }
            
            .booking-status {
                flex-direction: row;
                align-items: center;
                justify-content: space-between;
            }
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/includes/header.jsp" %>
    
    <div class="profile-container">
        <div class="profile-sidebar">
            <div class="profile-avatar">
                <%= currentUser != null && currentUser.getHotennguoidung() != null ? 
                    currentUser.getHotennguoidung().substring(0, 1).toUpperCase() : "U" %>
            </div>
            <div class="profile-name">
                <%= currentUser != null ? currentUser.getHotennguoidung() : "Người dùng" %>
            </div>
            <div class="profile-email">
                <%= currentUser != null ? currentUser.getEmail() : "" %>
            </div>
            
            <nav class="profile-nav">
                <a href="javascript:void(0)" class="profile-nav-item active" onclick="showTab('personal-info', this)">
                    <span>👤</span> Thông tin cá nhân
                </a>
                <a href="javascript:void(0)" class="profile-nav-item" onclick="showTab('booking-history', this)">
                    <span>📋</span> Lịch sử đặt tour
                </a>
                <a href="<%= request.getContextPath() %>/logout" class="profile-nav-item danger">
                    <span>🚪</span> Đăng xuất
                </a>
            </nav>
        </div>
        
        <div class="profile-main">
            <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success">
                ✅ 
                <% 
                    String success = request.getParameter("success");
                    if ("booking_created".equals(success)) {
                        out.print("Đặt tour thành công!");
                    } else if ("profile_updated".equals(success)) {
                        out.print("Cập nhật thông tin thành công!");
                    } else {
                        out.print("Thao tác thành công!");
                    }
                %>
            </div>
            <% } %>
            
            <div id="personal-info" class="tab-content active">
                <div class="profile-section">
                    <h2 class="profile-section-title">👤 Thông tin cá nhân</h2>
                    <div class="info-grid">
                        <div class="info-item">
                            <label>Họ và tên</label>
                            <span><%= currentUser != null ? currentUser.getHotennguoidung() : "---" %></span>
                        </div>
                        <div class="info-item">
                            <label>Email</label>
                            <span><%= currentUser != null ? currentUser.getEmail() : "---" %></span>
                        </div>
                        <div class="info-item">
                            <label>Số điện thoại</label>
                            <span><%= currentUser != null && currentUser.getSdt() != null ? currentUser.getSdt() : "Chưa cập nhật" %></span>
                        </div>
                        <div class="info-item">
                            <label>Tên đăng nhập</label>
                            <span><%= currentUser != null ? currentUser.getTendangnhap() : "---" %></span>
                        </div>
                    </div>
                </div>
            </div>
            
            <div id="booking-history" class="tab-content">
                <div class="profile-section">
                    <h2 class="profile-section-title">📋 Lịch sử đặt tour</h2>
                    
                    <%
                        @SuppressWarnings("unchecked")
                        List<DatTour> bookings = (List<DatTour>) request.getAttribute("bookings");
                        if (bookings != null && !bookings.isEmpty()) {
                            for (DatTour booking : bookings) {
                                String status = booking.getTinhtrang() != null ? booking.getTinhtrang().toString() : "PENDING";
                                String statusClass = "pending";
                                String statusText = "Chờ xác nhận";
                                if ("CONFIRMED".equals(status)) {
                                    statusClass = "success";
                                    statusText = "Đã xác nhận";
                                } else if ("CANCELLED".equals(status)) {
                                    statusClass = "danger";
                                    statusText = "Đã hủy";
                                } else if ("COMPLETED".equals(status)) {
                                    statusClass = "info";
                                    statusText = "Hoàn thành";
                                }
                                

                                Tour tour = booking.getTour();
                                String tourName = (tour != null) ? tour.getTentour() : "Tour #" + booking.getTourId();
                                String tourImage = (tour != null && tour.getHinhanh() != null) ? tour.getHinhanh() : null;
                                boolean daThanhToan = booking.getDathanhtoan();
                                

                                LocalDateTime ngayDat = booking.getNgaydat();
                                if (ngayDat == null) {
                                    ngayDat = booking.getCreatedAt();
                                }
                    %>
                    <div class="booking-card">
                        <div class="booking-image">
                            <% if (tourImage != null) { %>
                            <img src="<%= tourImage %>" alt="<%= tourName %>">
                            <% } else { %>
                            🏖️
                            <% } %>
                        </div>
                        <div class="booking-info">
                            <div class="booking-tour-name"><%= tourName %></div>
                            <div class="booking-meta">
                                <strong>Ngày đặt:</strong> <%= ngayDat != null ? ngayDat.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "---" %><br>
                                <strong>Ngày khởi hành:</strong> <%= booking.getNgayKhoihanh() != null ? booking.getNgayKhoihanh().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "---" %><br>
                                <strong>Số người:</strong> <%= booking.getSoLuongNguoi() %> người
                            </div>
                            <div class="booking-price"><%= String.format("%,.0f", booking.getTongtien()) %> VND</div>
                        </div>
                        <div class="booking-status">
                            <% if (daThanhToan) { %>
                                <span class="paid-badge">Đã thanh toán</span>
                            <% } else { %>
                                <span class="status-badge <%= statusClass %>"><%= statusText %></span>
                            <% } %>
                            <a href="<%= request.getContextPath() %>/booking/detail?id=<%= booking.getId() %>" 
                               class="btn btn-secondary" style="padding: 6px 14px; font-size: 0.85rem;">
                                Xem đơn
                            </a>
                            <% if (!daThanhToan && ("PENDING".equals(status) || "CONFIRMED".equals(status))) { %>
                            <form action="<%= request.getContextPath() %>/profile" method="post" style="margin:0;">
                                <input type="hidden" name="action" value="cancel_booking">
                                <input type="hidden" name="bookingId" value="<%= booking.getId() %>">
                                <button type="submit" class="btn btn-danger" style="padding: 6px 14px; font-size: 0.85rem;">
                                    Hủy đơn
                                </button>
                            </form>
                            <% } %>
                        </div>
                    </div>
                    <%
                            }
                        } else {
                    %>
                    <div style="text-align: center; padding: 40px; color: #64748b;">
                        <div style="font-size: 3rem; margin-bottom: 16px;">📋</div>
                        <p>Bạn chưa đặt tour nào.</p>
                        <a href="<%= request.getContextPath() %>/search" class="btn btn-primary" style="margin-top: 16px;">
                            Khám phá tour ngay →
                        </a>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="/WEB-INF/includes/footer.jsp" %>
    
    <script>
        function showTab(tabId, element) {

            document.querySelectorAll('.tab-content').forEach(tab => {
                tab.classList.remove('active');
            });
            

            document.querySelectorAll('.profile-nav-item').forEach(item => {
                item.classList.remove('active');
            });
            

            document.getElementById(tabId).classList.add('active');
            

            element.classList.add('active');
        }
        

        if (window.location.hash === '#bookings') {
            showTab('booking-history', document.querySelector('.profile-nav-item:nth-child(2)'));
        }
    </script>
</body>
</html>
