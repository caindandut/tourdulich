<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tourdulich.model.Tour" %>
<%@ page import="com.tourdulich.model.DatTour" %>
<%@ page import="com.tourdulich.model.NguoiDung" %>
<%@ page import="com.tourdulich.model.KhachHang" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalDateTime" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt tour thành công - DUT Travel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/dut-theme.css">
    <style>
        .success-page {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 24px;
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 40px;
        }
        
        .success-card {
            background: white;
            padding: 48px;
            border-radius: 16px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
        }
        
        .success-header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .success-icon {
            width: 72px;
            height: 72px;
            background: #3b4d9b;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
        }
        
        .success-icon svg {
            width: 36px;
            height: 36px;
            stroke: white;
            stroke-width: 3;
        }
        
        .success-title {
            font-size: 1.75rem;
            font-weight: 600;
            color: #1e293b;
            font-style: italic;
        }
        
        .order-details {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 24px;
            padding: 24px;
            background: #f8fafc;
            border-radius: 12px;
            margin-bottom: 32px;
        }
        
        .order-detail-item {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        
        .order-detail-label {
            font-size: 0.875rem;
            color: #64748b;
        }
        
        .order-detail-value {
            font-weight: 600;
            color: #1e293b;
            font-size: 0.95rem;
        }
        
        .order-detail-value a {
            color: #3b82f6;
            text-decoration: none;
        }
        
        .order-detail-value a:hover {
            text-decoration: underline;
        }
        
        .customer-info {
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 24px;
        }
        
        .customer-info-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 20px;
            padding-bottom: 16px;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .customer-info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #f1f5f9;
        }
        
        .customer-info-row:last-child {
            border-bottom: none;
        }
        
        .customer-info-label {
            color: #64748b;
            font-size: 0.9rem;
        }
        
        .customer-info-value {
            font-weight: 500;
            color: #1e293b;
        }
        
        .customer-info-value a {
            color: #3b82f6;
            text-decoration: none;
        }
        
        .customer-info-value a:hover {
            text-decoration: underline;
        }
        
        .booking-summary {
            background: white;
            border-radius: 16px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            overflow: hidden;
            position: sticky;
            top: 100px;
            height: fit-content;
        }
        
        .booking-summary-header {
            padding: 20px 24px;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .booking-summary-header h3 {
            font-size: 1.125rem;
            font-weight: 600;
            color: #1e293b;
            margin: 0;
        }
        
        .booking-tour-info {
            display: flex;
            gap: 16px;
            padding: 20px 24px;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .booking-tour-image {
            width: 100px;
            height: 80px;
            border-radius: 8px;
            overflow: hidden;
            background: #f1f5f9;
            flex-shrink: 0;
        }
        
        .booking-tour-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .booking-tour-details {
            flex: 1;
        }
        
        .booking-tour-name {
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 4px;
            font-size: 0.95rem;
        }
        
        .booking-tour-location {
            font-size: 0.85rem;
            color: #64748b;
            margin-bottom: 8px;
        }
        
        .booking-tour-rating {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .rating-badge {
            background: #3b82f6;
            color: white;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .rating-text {
            font-size: 0.8rem;
            color: #64748b;
        }
        
        .rating-reviews {
            font-size: 0.75rem;
            color: #94a3b8;
        }
        
        .booking-details {
            padding: 20px 24px;
        }
        
        .booking-detail-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            padding: 12px 0;
            border-bottom: 1px solid #f1f5f9;
        }
        
        .booking-detail-row:last-child {
            border-bottom: none;
        }
        
        .booking-detail-label {
            font-size: 0.875rem;
            color: #64748b;
        }
        
        .booking-detail-value {
            font-size: 0.875rem;
            font-weight: 500;
            color: #1e293b;
            text-align: right;
        }
        
        .booking-total {
            background: #f8fafc;
            padding: 20px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid #e2e8f0;
        }
        
        .booking-total-label {
            font-size: 1rem;
            font-weight: 500;
            color: #1e293b;
        }
        
        .booking-total-value {
            font-size: 1.375rem;
            font-weight: 700;
            color: #3b82f6;
        }
        
        @media (max-width: 900px) {
            .success-page {
                grid-template-columns: 1fr;
            }
            
            .order-details {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .booking-summary {
                position: static;
                order: -1;
            }
        }
        
        @media (max-width: 500px) {
            .order-details {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/includes/header.jsp" %>
    
    <%
        Tour tour = (Tour) request.getAttribute("tour");
        DatTour booking = (DatTour) request.getAttribute("booking");
        KhachHang khachHang = (KhachHang) session.getAttribute("khachHang");
        
        if (tour == null) {
            tour = new Tour();
            tour.setTentour("Tour Du Lịch");
            tour.setDiadiem("Việt Nam");
            tour.setThoiluong("3 ngày 2 đêm");
            tour.setGia(new java.math.BigDecimal(5000000));
        }
        if (booking == null) {
            booking = new DatTour();
            booking.setId(0L);
            booking.setTongtien(new java.math.BigDecimal(5000000));
            booking.setSoLuongNguoi(2);
        }
        
        LocalDateTime ngayDat = booking.getNgaydat() != null ? booking.getNgaydat() : LocalDateTime.now();
        LocalDateTime ngayKhoihanh = booking.getNgayKhoihanh();
        String diaChiHienThi = (khachHang != null && khachHang.getDiachi() != null && !khachHang.getDiachi().trim().isEmpty())
                ? khachHang.getDiachi()
                : (tour.getDiadiem() != null ? tour.getDiadiem() : "---");
        

        int days = 3;
        String thoiluong = tour.getThoiluong();
        if (thoiluong != null) {
            try {
                String numStr = thoiluong.replaceAll("[^0-9]", " ").trim().split("\\s+")[0];
                days = Integer.parseInt(numStr);
            } catch (Exception e) {
                days = 3;
            }
        }
    %>
    
    <div class="success-page">
        <div class="success-card">
            <div class="success-header">
                <div class="success-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7" />
                        </svg>
                </div>
                <h1 class="success-title">Đặt tour thành công!</h1>
            </div>
            
            <div class="order-details">
                <div class="order-detail-item">
                    <div class="order-detail-label">Mã đơn</div>
                    <div class="order-detail-value">
                        <a href="#"><%= booking.getId() %></a>
                    </div>
                </div>
                <div class="order-detail-item">
                    <div class="order-detail-label">Ngày</div>
                    <div class="order-detail-value">
                        <%= ngayDat.format(DateTimeFormatter.ofPattern("dd-MM-yyyy")) %>
                    </div>
                </div>
                <div class="order-detail-item">
                    <div class="order-detail-label">Tổng cộng</div>
                    <div class="order-detail-value">
                        <%= String.format("%,.0f", booking.getTongtien()) %> VND
                    </div>
                </div>
                <div class="order-detail-item">
                    <div class="order-detail-label">Phương thức thanh toán</div>
                    <div class="order-detail-value">
                        <a href="#">Thanh toán trực tiếp</a>
                    </div>
                </div>
            </div>
            
            <div class="customer-info">
                <h3 class="customer-info-title">Thông tin Khách hàng</h3>
                
                <div class="customer-info-row">
                    <span class="customer-info-label">Tên Khách Hàng:</span>
                    <span class="customer-info-value">
                        <a href="#"><%= currentUser != null ? currentUser.getHotennguoidung() : "Khách hàng" %></a>
                    </span>
                </div>
                <div class="customer-info-row">
                    <span class="customer-info-label">Email</span>
                    <span class="customer-info-value">
                        <a href="mailto:<%= currentUser != null ? currentUser.getEmail() : "" %>">
                            <%= currentUser != null ? currentUser.getEmail() : "---" %>
                        </a>
                    </span>
                </div>
                <div class="customer-info-row">
                    <span class="customer-info-label">SDT</span>
                    <span class="customer-info-value">
                        <a href="tel:<%= currentUser != null && currentUser.getSdt() != null ? currentUser.getSdt() : "" %>">
                            <%= currentUser != null && currentUser.getSdt() != null ? currentUser.getSdt() : "---" %>
                        </a>
                    </span>
                </div>
                <div class="customer-info-row">
                    <span class="customer-info-label">Địa chỉ</span>
                    <span class="customer-info-value"><%= diaChiHienThi %></span>
                </div>
                <div class="customer-info-row">
                    <span class="customer-info-label">Nước</span>
                    <span class="customer-info-value">
                        <a href="#">Việt Nam</a>
                    </span>
                </div>
            </div>
        </div>
        
        <div class="booking-summary">
            <div class="booking-summary-header">
                <h3>Thông tin đặt tour của bạn</h3>
            </div>
            
            <div class="booking-tour-info">
                <div class="booking-tour-image">
                    <% if (tour.getHinhanh() != null && !tour.getHinhanh().trim().isEmpty()) { %>
                        <img src="<%= tour.getHinhanh() %>" alt="<%= tour.getTentour() %>">
                    <% } else { %>
                        <div style="width: 100%; height: 100%; background: #3b4d9b; display: flex; align-items: center; justify-content: center; color: white; font-size: 2rem;">🏖️</div>
                    <% } %>
                </div>
                <div class="booking-tour-details">
                    <div class="booking-tour-name"><%= tour.getTentour() %></div>
                    <div class="booking-tour-location"><%= tour.getDiadiem() %></div>
                </div>
            </div>
            
            <div class="booking-details">
                <div class="booking-detail-row">
                    <span class="booking-detail-label">Ngày đi</span>
                    <span class="booking-detail-value">
                        <%= ngayKhoihanh != null ? ngayKhoihanh.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) : "---" %>
                    </span>
                </div>
                <div class="booking-detail-row">
                    <span class="booking-detail-label">Ngày về</span>
                    <span class="booking-detail-value">
                        <%
                            if (ngayKhoihanh != null) {
                                out.print(ngayKhoihanh.plusDays(days).format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
                            } else {
                                out.print("---");
                            }
                        %>
                    </span>
                </div>
                <div class="booking-detail-row">
                    <span class="booking-detail-label">Lịch Trình</span>
                    <span class="booking-detail-value"><%= tour.getThoiluong() %></span>
                </div>
                <div class="booking-detail-row">
                    <span class="booking-detail-label">Bạn đã chọn:</span>
                    <span class="booking-detail-value">
                        1 phòng, <%= booking.getSoLuongNguoi() %> người
                    </span>
                </div>
            </div>
            
            <div class="booking-total">
                <span class="booking-total-label">Giá</span>
                <span class="booking-total-value"><%= String.format("%,.0f", booking.getTongtien()) %> VND</span>
            </div>
        </div>
    </div>
    
    <%@ include file="/WEB-INF/includes/footer.jsp" %>
</body>
</html>
