<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tourdulich.model.Tour" %>
<%@ page import="com.tourdulich.model.DanhGia" %>
<%@ page import="com.tourdulich.model.NguoiDung" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.tourdulich.model.KhachSan" %>
<%@ page import="java.time.LocalDate" %>
<%
    Tour tour = (Tour) request.getAttribute("tour");
    double rating = request.getAttribute("avgRating") != null ? (Double) request.getAttribute("avgRating") : 4.5;
    Long reviewCount = request.getAttribute("reviewCount") != null ? (Long) request.getAttribute("reviewCount") : 0L;
    if (tour == null) {
        response.sendRedirect(request.getContextPath() + "/home");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= tour.getTentour() %> - DUT Travel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/dut-theme.css">
                                        <style>
                                            .tour-detail-container {
                                                max-width: 1200px;
                                                margin: 0 auto;
                                                padding: 24px;
                                                display: grid;
                                                grid-template-columns: 1fr 380px;
                                                gap: 32px;
                                            }

                                            .tour-detail-main {}

                                            .tour-breadcrumb {
                                                font-size: 0.875rem;
                                                color: #64748b;
                                                margin-bottom: 16px;
                                            }

                                            .tour-breadcrumb a {
                                                color: #3b82f6;
                                                text-decoration: none;
                                            }

                                            .tour-gallery-main {
                                                width: 100%;
                                                height: 400px;
                                                border-radius: 16px;
                                                overflow: hidden;
                                                background: #f1f5f9;
                                            }

                                            .tour-gallery-main img {
                                                width: 100%;
                                                height: 100%;
                                                object-fit: cover;
                                            }

                                            .tour-info-header {
                                                margin-top: 24px;
                                            }

                                            .tour-title {
                                                font-size: 1.75rem;
                                                font-weight: 700;
                                                color: #1e293b;
                                                margin-bottom: 12px;
                                            }

                                            .tour-rating-row {
                                                display: flex;
                                                align-items: center;
                                                gap: 12px;
                                                margin-bottom: 20px;
                                            }

                                            .tour-meta-row {
                                                display: flex;
                                                flex-wrap: wrap;
                                                gap: 24px;
                                                padding: 20px 0;
                                                border-top: 1px solid #e2e8f0;
                                                border-bottom: 1px solid #e2e8f0;
                                            }

                                            .tour-meta-item {
                                                display: flex;
                                                flex-direction: column;
                                                gap: 4px;
                                            }

                                            .tour-meta-item .icon {
                                                font-size: 1.25rem;
                                            }

                                            .tour-meta-item span {
                                                color: #64748b;
                                                font-size: 0.875rem;
                                            }

                                            .tour-meta-item strong {
                                                color: #1e293b;
                                            }

                                            .tour-section {
                                                margin-top: 32px;
                                            }

                                            .tour-section-title {
                                                font-size: 1.25rem;
                                                font-weight: 600;
                                                color: #1e293b;
                                                margin-bottom: 16px;
                                                padding-bottom: 12px;
                                                border-bottom: 2px solid #e2e8f0;
                                            }

                                            .tour-description {
                                                color: #475569;
                                                line-height: 1.7;
                                            }

                                            .booking-sidebar {
                                                position: sticky;
                                                top: 100px;
                                                height: fit-content;
                                            }

                                            .booking-card {
                                                background: white;
                                                border-radius: 16px;
                                                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
                                                overflow: hidden;
                                            }

                                            .booking-card-header {
                                                background: linear-gradient(135deg, #1e3a5f, #2d4a7c);
                                                color: white;
                                                padding: 20px 24px;
                                            }

                                            .booking-price-label {
                                                font-size: 0.875rem;
                                                opacity: 0.9;
                                            }

                                            .booking-price {
                                                font-size: 1.75rem;
                                                font-weight: 700;
                                            }

                                            .booking-card-body {
                                                padding: 24px;
                                            }

                                            .booking-form-group {
                                                margin-bottom: 16px;
                                            }

                                            .booking-form-group label {
                                                display: block;
                                                font-size: 0.875rem;
                                                font-weight: 500;
                                                color: #374151;
                                                margin-bottom: 8px;
                                            }

                                            .booking-date-display {
                                                background: #f8fafc;
                                                border: 2px solid #e5e7eb;
                                                border-radius: 10px;
                                                padding: 12px 16px;
                                                display: flex;
                                                align-items: center;
                                                justify-content: center;
                                                gap: 12px;
                                            }

                                            .booking-date-display .date-value {
                                                font-weight: 600;
                                                color: #1f2937;
                                            }

                                            .booking-date-display .date-separator {
                                                color: #3b82f6;
                                                font-weight: bold;
                                            }

                                            .booking-select {
                                                width: 100%;
                                                padding: 12px 16px;
                                                border: 2px solid #e5e7eb;
                                                border-radius: 10px;
                                                font-size: 0.95rem;
                                                background: white;
                                                cursor: pointer;
                                            }

                                            .hotel-selection {
                                                margin: 20px 0;
                                            }

                                            .hotel-selection-title {
                                                font-size: 0.95rem;
                                                font-weight: 600;
                                                color: #374151;
                                                margin-bottom: 12px;
                                            }

                                            .hotel-option {
                                                display: flex;
                                                align-items: center;
                                                gap: 12px;
                                                padding: 12px;
                                                border: 2px solid #e5e7eb;
                                                border-radius: 12px;
                                                margin-bottom: 10px;
                                                cursor: pointer;
                                                transition: all 0.2s ease;
                                            }

                                            .hotel-option:hover {
                                                border-color: #3b82f6;
                                                background: #f8fafc;
                                            }

                                            .hotel-option.selected {
                                                border-color: #3b82f6;
                                                background: #eff6ff;
                                            }

                                            .hotel-option-image {
                                                width: 50px;
                                                height: 50px;
                                                border-radius: 8px;
                                                overflow: hidden;
                                                background: #3b4d9b;
                                                flex-shrink: 0;
                                            }

                                            .hotel-option-image img {
                                                width: 100%;
                                                height: 100%;
                                                object-fit: cover;
                                            }

                                            .hotel-option-info {
                                                flex: 1;
                                            }

                                            .hotel-option-name {
                                                font-weight: 600;
                                                color: #1f2937;
                                                font-size: 0.9rem;
                                            }

                                            .hotel-option-rating {
                                                font-size: 0.75rem;
                                                color: #f59e0b;
                                            }

                                            .hotel-option-price {
                                                font-size: 0.85rem;
                                                color: #059669;
                                                font-weight: 600;
                                            }

                                            .hotel-check-icon {
                                                width: 24px;
                                                height: 24px;
                                                border-radius: 50%;
                                                background: #3b82f6;
                                                color: white;
                                                display: none;
                                                align-items: center;
                                                justify-content: center;
                                                font-size: 0.8rem;
                                            }

                                            .hotel-option.selected .hotel-check-icon {
                                                display: flex;
                                            }

                                            .room-price-info {
                                                margin-top: 8px;
                                                font-size: 0.85rem;
                                                color: #6b7280;
                                                text-align: right;
                                            }

                                            .room-price-info .total {
                                                font-weight: 600;
                                                color: #059669;
                                            }

                                            .btn-book-now {
                                                width: 100%;
                                                padding: 16px 24px;
                                                background: linear-gradient(135deg, #3b82f6, #2563eb);
                                                color: white;
                                                border: none;
                                                border-radius: 12px;
                                                font-size: 1.1rem;
                                                font-weight: 700;
                                                cursor: pointer;
                                                margin-top: 20px;
                                            }

                                            .btn-book-now:hover {
                                                transform: translateY(-2px);
                                                box-shadow: 0 6px 20px rgba(59, 130, 246, 0.4);
                                            }

                                            .reviews-section {
                                                margin-top: 40px;
                                            }

                                            .reviews-header {
                                                display: flex;
                                                gap: 24px;
                                                align-items: center;
                                                margin-bottom: 24px;
                                            }

                                            .reviews-score {
                                                text-align: center;
                                                padding: 16px 24px;
                                                background: #f8fafc;
                                                border-radius: 12px;
                                            }

                                            .reviews-score-value {
                                                font-size: 2rem;
                                                font-weight: 700;
                                                color: #1e293b;
                                            }

                                            .review-item {
                                                display: flex;
                                                gap: 16px;
                                                padding: 20px 0;
                                                border-bottom: 1px solid #e2e8f0;
                                            }

                                            .review-avatar {
                                                width: 48px;
                                                height: 48px;
                                                border-radius: 50%;
                                                background: linear-gradient(135deg, #3b82f6, #8b5cf6);
                                                color: white;
                                                display: flex;
                                                align-items: center;
                                                justify-content: center;
                                                font-weight: 600;
                                                flex-shrink: 0;
                                            }

                                            .review-content {
                                                flex: 1;
                                            }

                                            .review-header {
                                                display: flex;
                                                justify-content: space-between;
                                                margin-bottom: 8px;
                                            }

                                            .review-author {
                                                font-weight: 600;
                                                color: #1e293b;
                                            }

                                            .review-date {
                                                color: #64748b;
                                                font-size: 0.875rem;
                                            }

                                            .review-text {
                                                color: #475569;
                                                line-height: 1.6;
                                            }

                                            .review-form {
                                                background: #f8fafc;
                                                padding: 24px;
                                                border-radius: 12px;
                                                margin-top: 24px;
                                            }

                                            .review-form-title {
                                                font-size: 1.1rem;
                                                font-weight: 600;
                                                margin-bottom: 16px;
                                            }

                                            .star-rating-input {
                                                display: flex;
                                                gap: 8px;
                                                margin-bottom: 16px;
                                            }

                                            .star-rating-input .star {
                                                font-size: 1.5rem;
                                                cursor: pointer;
                                                opacity: 0.3;
                                            }

                                            .star-rating-input .star.active {
                                                opacity: 1;
                                            }

                                            .review-textarea {
                                                width: 100%;
                                                padding: 12px;
                                                border: 1px solid #e2e8f0;
                                                border-radius: 8px;
                                                min-height: 100px;
                                                resize: vertical;
                                                margin-bottom: 16px;
                                            }

                                            .btn-submit-review {
                                                padding: 12px 24px;
                                                background: #3b82f6;
                                                color: white;
                                                border: none;
                                                border-radius: 8px;
                                                cursor: pointer;
                                            }

                                            .alert {
                                                padding: 12px 16px;
                                                border-radius: 8px;
                                                margin-bottom: 16px;
                                            }

                                            .alert-success {
                                                background: #d1fae5;
                                                color: #065f46;
                                            }

                                            .alert-error {
                                                background: #fee2e2;
                                                color: #991b1b;
                                            }

                                            @media (max-width: 900px) {
                                                .tour-detail-container {
                                                    grid-template-columns: 1fr;
                                                }

                                                .booking-sidebar {
                                                    position: static;
                                                }
                                            }
                                        </style>
                                    </head>

                                    <body>
                                        <%@ include file="/WEB-INF/includes/header.jsp" %>

                                            <div class="tour-detail-container">
                                                <div class="tour-detail-main">
                                                    <div class="tour-breadcrumb">
                                                        <a href="<%= request.getContextPath() %>/home">Trang chủ</a> /
                                                        <a href="<%= request.getContextPath() %>/search">Tour</a> /
                                                        <%= tour.getTentour() %>
                                                    </div>

                                                    <div class="tour-gallery">
                                                        <div class="tour-gallery-main">
                                                            <% 
                                                                String imageUrl = null;
                                                                if (tour.getHinhanh() != null && !tour.getHinhanh().trim().isEmpty()) {
                                                                    String hinhanh = tour.getHinhanh().trim();
                                                                    if (hinhanh.toLowerCase().startsWith("http://") || hinhanh.toLowerCase().startsWith("https://")) {
                                                                        imageUrl = hinhanh;
                                                                    } else if (hinhanh.startsWith("/")) {
                                                                        imageUrl = hinhanh;
                                                                    } else {
                                                                        imageUrl = request.getContextPath() + "/" + hinhanh;
                                                                    }
                                                                }
                                                            %>
                                                            <% if (imageUrl != null) { %>
                                                                <img src="<%= imageUrl %>"
                                                                    alt="<%= tour.getTentour() %>"
                                                                    onerror="handleImageError(this)">
                                                            <% } else { %>
                                                                <div style="width:100%;height:100%;background:linear-gradient(135deg,#1a2b49,#2d4a7c);display:flex;align-items:center;justify-content:center;color:white;font-size:5rem;">
                                                                    🏖️
                                                                </div>
                                                            <% } %>
                                                        </div>
                                                    </div>

                                                    <div class="tour-info-header">
                                                        <h1 class="tour-title">
                                                            <%= tour.getTentour() %>
                                                        </h1>

                                                        <div class="tour-rating-row">
                                                            <div class="tour-rating">
                                                                <% for (int i=1; i <=5; i++) { if (i
                                                                    <=Math.floor(rating)) out.print("⭐"); } %>
                                                                    <span>
                                                                        <%= String.format("%.1f", rating) %>
                                                                    </span>
                                                            </div>
                                                            <span>(<%= reviewCount !=null ? reviewCount : 0 %> đánh
                                                                    giá)</span>
                                                            <span>📍 <%= tour.getDiadiem() %></span>
                                                        </div>

                                                        <div class="tour-meta-row">
                                                            <div class="tour-meta-item">
                                                                <span class="icon">⏱️</span>
                                                                <span>Lịch trình</span>
                                                                <strong>
                                                                    <%= tour.getThoiluong() !=null ? tour.getThoiluong()
                                                                        : "Linh hoạt" %>
                                                                </strong>
                                                            </div>
                                                            <div class="tour-meta-item">
                                                                <span class="icon">📍</span>
                                                                <span>Địa điểm</span>
                                                                <strong>
                                                                    <%= tour.getDiadiem() !=null ? tour.getDiadiem()
                                                                        : "Việt Nam" %>
                                                                </strong>
                                                            </div>
                                                            <div class="tour-meta-item">
                                                                <span class="icon">🚌</span>
                                                                <span>Phương tiện</span>
                                                                <strong>
                                                                    <%= tour.getPhuongtienchinh() !=null ?
                                                                        tour.getPhuongtienchinh() : "Xe du lịch" %>
                                                                </strong>
                                                            </div>
                                                            <div class="tour-meta-item">
                                                                <span class="icon">📅</span>
                                                                <span>Ngày khởi hành</span>
                                                                <strong>
                                                                    <%= tour.getNgaykhoihanh() !=null ?
                                                                        tour.getNgaykhoihanh().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"))
                                                                        : "Linh hoạt" %>
                                                                </strong>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <%
                                                        String mota = tour.getMota();
                                                        if (mota != null && !mota.trim().isEmpty()) {
                                                            // Parse nội dung thành các section
                                                            String gioiThieu = "";
                                                            String diemNoiBat = "";
                                                            String moTaTour = "";
                                                            
                                                            
                                                            String motaLower = mota.toLowerCase();
                                                            int idxGioiThieu = motaLower.indexOf("giới thiệu:");
                                                            int idxDiemNoiBat = motaLower.indexOf("điểm nổi bật:");
                                                            int idxMoTaTour = motaLower.indexOf("mô tả tour:");
                                                            
                                                            
                                                            if (idxGioiThieu >= 0) {
                                                                int start = idxGioiThieu + "giới thiệu:".length();
                                                                int end = mota.length();
                                                                
                                                                if (idxDiemNoiBat > idxGioiThieu && idxDiemNoiBat < end) {
                                                                    end = idxDiemNoiBat;
                                                                } else if (idxMoTaTour > idxGioiThieu && idxMoTaTour < end) {
                                                                    end = idxMoTaTour;
                                                                }
                                                                
                                                                gioiThieu = mota.substring(start, end).trim();
                                                            }
                                                            
                                                            if (idxDiemNoiBat >= 0) {
                                                                int start = idxDiemNoiBat + "điểm nổi bật:".length();
                                                                int end = mota.length();
                                                                
                                                                if (idxMoTaTour > idxDiemNoiBat && idxMoTaTour < end) {
                                                                    end = idxMoTaTour;
                                                                }
                                                                
                                                                diemNoiBat = mota.substring(start, end).trim();
                                                            }
                                                            
                                                            if (idxMoTaTour >= 0) {
                                                                int start = idxMoTaTour + "mô tả tour:".length();
                                                                moTaTour = mota.substring(start).trim();
                                                            }
                                                            
                                                           
                                                            if (gioiThieu.isEmpty() && diemNoiBat.isEmpty() && moTaTour.isEmpty()) {
                                                                gioiThieu = mota;
                                                            }
                                                            
                                                           
                                                            if (!gioiThieu.isEmpty()) {
                                                    %>
                                                    <div class="tour-section">
                                                        <h2 class="tour-section-title">Giới thiệu</h2>
                                                        <div class="tour-description">
                                                            <%= gioiThieu.replace("\n", "<br>") %>
                                                        </div>
                                                    </div>
                                                    <%
                                                            }
                                                            
                                                           
                                                            if (!diemNoiBat.isEmpty()) {
                                                    %>
                                                    <div class="tour-section">
                                                        <h2 class="tour-section-title">Điểm nổi bật</h2>
                                                        <div class="tour-description">
                                                            <%= diemNoiBat.replace("\n", "<br>") %>
                                                        </div>
                                                    </div>
                                                    <%
                                                            }
                                                            
                                                           
                                                            if (!moTaTour.isEmpty()) {
                                                    %>
                                                    <div class="tour-section">
                                                        <h2 class="tour-section-title">Mô tả tour</h2>
                                                        <div class="tour-description">
                                                            <%= moTaTour.replace("\n", "<br>") %>
                                                        </div>
                                                    </div>
                                                    <%
                                                            }
                                                        } else {
                                                    %>
                                                    <div class="tour-section">
                                                        <h2 class="tour-section-title">Giới thiệu</h2>
                                                        <div class="tour-description">
                                                            Thông tin chi tiết đang được cập nhật.
                                                        </div>
                                                    </div>
                                                    <%
                                                        }
                                                    %>

                                                    <div class="reviews-section">
                                                        <% if ("review_created".equals(request.getParameter("success")))
                                                            { %>
                                                            <div class="alert alert-success">✅ Cảm ơn bạn đã đánh giá
                                                                tour!
                                                            </div>
                                                            <% } %>

                                                                <% if
                                                                    ("already_reviewed".equals(request.getParameter("error")))
                                                                    { %>
                                                                    <div class="alert alert-error">❌ Bạn đã đánh giá
                                                                        tour
                                                                        này rồi!</div>
                                                                    <% } %>

                                                                        <div class="reviews-header">
                                                                            <div class="reviews-score">
                                                                                <div class="reviews-score-value">
                                                                                    <%= String.format("%.1f", rating) %>
                                                                                </div>
                                                                                <div>
                                                                                    <% for (int i=1; i
                                                                                        <=Math.floor(rating); i++)
                                                                                        out.print("⭐"); %>
                                                                                </div>
                                                                                <div>
                                                                                    <%= reviewCount !=null ? reviewCount
                                                                                        : 0 %> đánh giá
                                                                                </div>
                                                                            </div>
                                                                            <h2 class="tour-section-title"
                                                                                style="border:none;margin:0;padding:0;">
                                                                                Đánh
                                                                                giá</h2>
                                                                        </div>

                                                                        <%
                                                                        @SuppressWarnings("unchecked")
                                                                        List<DanhGia> reviews = (List<DanhGia>) request.getAttribute("reviews");
                                                                        if (reviews != null && !reviews.isEmpty()) {
                                                                            for (DanhGia review : reviews) {
                                                                                int reviewRating = review.getRating() != null ? review.getRating() : 5;
                                                                        %>
                                                                                <div class="review-item">
                                                                                    <div class="review-avatar">
                                                                                        <% 
                                                                                        String avatarText = "K";
                                                                                        String customerName = "Khách hàng";
                                                                                        if (review.getKhachHang() != null && review.getKhachHang().getNguoiDung() != null) {
                                                                                            customerName = review.getKhachHang().getNguoiDung().getHotennguoidung();
                                                                                            if (customerName != null && !customerName.trim().isEmpty()) {
                                                                                                avatarText = customerName.substring(0, 1).toUpperCase();
                                                                                            }
                                                                                        } else if (review.getKhachhangId() != null) {
                                                                                            avatarText = review.getKhachhangId().toString().substring(0, 1).toUpperCase();
                                                                                        }
                                                                                        %>
                                                                                        <%= avatarText %>
                                                                                    </div>
                                                                                    <div class="review-content">
                                                                                        <div class="review-header">
                                                                                            <div>
                                                                                                <div class="review-author">
                                                                                                    <%= customerName %>
                                                                                                </div>
                                                                                                <div class="review-rating">
                                                                                                    <% for (int i=1; i <= reviewRating; i++) out.print("⭐"); %>
                                                                                                </div>
                                                                                            </div>
                                                                                            <div class="review-date">
                                                                                                <%= review.getThoigian() != null 
                                                                                                    ? review.getThoigian().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"))
                                                                                                    : "" %>
                                                                                            </div>
                                                                                        </div>
                                                                                        <p class="review-text">
                                                                                            <%= review.getNoidung() %>
                                                                                        </p>
                                                                                    </div>
                                                                                </div>
                                                                                <% }} else { %>
                                                                                    <div
                                                                                        style="text-align:center;padding:40px;color:#64748b;">
                                                                                        <p>Chưa có đánh giá nào cho tour
                                                                                            này.</p>
                                                                                        <p
                                                                                            style="margin-top:8px;font-size:0.9rem;">
                                                                                            Hãy là người đầu tiên đánh
                                                                                            giá!
                                                                                        </p>
                                                                                    </div>
                                                                                    <% } %>

                                                                                        <% NguoiDung
                                                                                            currentUserForReview=(NguoiDung)
                                                                                            request.getAttribute("currentUser");
                                                                                            if (currentUserForReview
                                                                                            !=null &&
                                                                                            currentUserForReview.getRole()==NguoiDung.Role.CUSTOMER)
                                                                                            { %>
                                                                                            <div class="review-form">
                                                                                                <h3
                                                                                                    class="review-form-title">
                                                                                                    Viết đánh giá của
                                                                                                    bạn
                                                                                                </h3>
                                                                                                <form
                                                                                                    action="<%= request.getContextPath() %>/review"
                                                                                                    method="POST">
                                                                                                    <input type="hidden"
                                                                                                        name="tourId"
                                                                                                        value="<%= tour.getId() %>">
                                                                                                    <div class="star-rating-input"
                                                                                                        id="starRating">
                                                                                                        <input
                                                                                                            type="hidden"
                                                                                                            name="rating"
                                                                                                            id="ratingInput"
                                                                                                            value="5">
                                                                                                        <label
                                                                                                            onclick="setRating(1)"
                                                                                                            class="star"
                                                                                                            data-value="1">⭐</label>
                                                                                                        <label
                                                                                                            onclick="setRating(2)"
                                                                                                            class="star"
                                                                                                            data-value="2">⭐</label>
                                                                                                        <label
                                                                                                            onclick="setRating(3)"
                                                                                                            class="star"
                                                                                                            data-value="3">⭐</label>
                                                                                                        <label
                                                                                                            onclick="setRating(4)"
                                                                                                            class="star"
                                                                                                            data-value="4">⭐</label>
                                                                                                        <label
                                                                                                            onclick="setRating(5)"
                                                                                                            class="star active"
                                                                                                            data-value="5">⭐</label>
                                                                                                    </div>
                                                                                                    <textarea
                                                                                                        name="noidung"
                                                                                                        class="review-textarea"
                                                                                                        placeholder="Chia sẻ trải nghiệm của bạn..."
                                                                                                        required
                                                                                                        minlength="10"></textarea>
                                                                                                    <button
                                                                                                        type="submit"
                                                                                                        class="btn-submit-review">📝
                                                                                                        Gửi đánh
                                                                                                        giá</button>
                                                                                                </form>
                                                                                            </div>
                                                                                            <% } %>
                                                    </div>
                                                </div>

                                                <div class="booking-sidebar">
                                                    <div class="booking-card">
                                                        <div class="booking-card-header">
                                                            <div class="booking-price-label">Giá</div>
                                                            <div class="booking-price">
                                                                <%= String.format("%,.0f", tour.getGia()) %> VND
                                                            </div>
                                                        </div>

                                                        <div class="booking-card-body">
                                                            <form action="<%= request.getContextPath() %>/booking"
                                                                method="GET" id="bookingForm">
                                                                <input type="hidden" name="tourId"
                                                                    value="<%= tour.getId() %>">
                                                                <input type="hidden" name="hotelId" id="selectedHotelId"
                                                                    value="">
                                                                <input type="hidden" name="soNguoi" id="hiddenSoNguoi"
                                                                    value="2">
                                                                <input type="hidden" name="soPhong" id="hiddenSoPhong"
                                                                    value="1">

                                                                <% 
                                                                LocalDate ngayDi = tour.getNgaykhoihanh(); 
                                                                LocalDate ngayVe = null; 
                                                                int soDem = 1; 
                                                                if (ngayDi != null && tour.getThoiluong() != null) { 
                                                                    String thoiluong = tour.getThoiluong(); 
                                                                    try { 
                                                                        String[] parts = thoiluong.split(" ");
                                                                        int soNgay = Integer.parseInt(parts[0]);
                                                                        ngayVe = ngayDi.plusDays(soNgay - 1);
                                                                        soDem = soNgay > 1 ? soNgay - 1 : 1;
                                                                    } catch (Exception e) {
                                                                        ngayVe = ngayDi.plusDays(1);
                                                                        soDem = 1;
                                                                    }
                                                                } else if (ngayDi != null) {
                                                                    ngayVe = ngayDi.plusDays(1);
                                                                    soDem = 1;
                                                                }
                                                                DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy"); 
                                                                %>

                                                                    <input type="hidden" name="ngaydi" id="hiddenNgayDi"
                                                                        value="<%= ngayDi != null ? ngayDi : "" %>">
                                                                    <input type="hidden" name="ngayve" id="hiddenNgayVe"
                                                                        value="<%= ngayVe != null ? ngayVe : "" %>">

                                                                    <div class="booking-form-group">
                                                                        <label>📅 Ngày đi - Ngày về</label>
                                                                        <div class="booking-date-display">
                                                                            <% if (ngayDi !=null && ngayVe !=null) { %>
                                                                                <span class="date-value">
                                                                                    <%= ngayDi.format(fmt) %>
                                                                                </span>
                                                                                <span class="date-separator">→</span>
                                                                                <span class="date-value">
                                                                                    <%= ngayVe.format(fmt) %>
                                                                                </span>
                                                                                <% } else { %>
                                                                                    <span class="date-value">Liên hệ để
                                                                                        biết
                                                                                        lịch trình</span>
                                                                                    <% } %>
                                                                        </div>
                                                                    </div>

                                                                    <div class="booking-form-group">
                                                                        <label>👥 Số người</label>
                                                                        <select name="songuoi" class="booking-select"
                                                                            id="soNguoiSelect">
                                                                            <option value="1">1 người</option>
                                                                            <option value="2" selected>2 người</option>
                                                                            <option value="3">3 người</option>
                                                                            <option value="4">4 người</option>
                                                                            <option value="5">5 người</option>
                                                                            <option value="6">6 người</option>
                                                                            <option value="7">7 người</option>
                                                                            <option value="8">8 người</option>
                                                                            <option value="9">9 người</option>
                                                                            <option value="10">10+ người</option>
                                                                        </select>
                                                                    </div>

                                                                    <div class="hotel-selection">
                                                                        <h4 class="hotel-selection-title">🏨 Chọn Khách
                                                                            Sạn
                                                                        </h4>
                                                                        <%
                                                                        @SuppressWarnings("unchecked")
                                                                        List<KhachSan> hotels = (List<KhachSan>) request.getAttribute("hotels");
                                                                        if (hotels != null && !hotels.isEmpty()) {
                                                                            boolean isFirst = true;
                                                                            for (KhachSan hotel : hotels) {
                                                                                String hotelImg = hotel.getHinhanh();
                                                                                if (hotelImg == null || hotelImg.trim().isEmpty()) {
                                                                                    hotelImg = "https://via.placeholder.com/150?text=Hotel";
                                                                                } else if (!hotelImg.toLowerCase().startsWith("http")) {
                                                                                    hotelImg = request.getContextPath() + "/" + hotelImg;
                                                                                }
                                                                        %>
                                                                                <div class="hotel-option <%= isFirst ? "selected" : "" %>"
                                                                                    data-hotel-id="<%= hotel.getId() %>"
                                                                                    data-hotel-name="<%= hotel.getTenkhachsan() %>"
                                                                                    data-hotel-price="<%= hotel.getGia() != null ? hotel.getGia() : 0 %>"
                                                                                            onclick="selectHotel(this)">
                                                                                            <div
                                                                                                class="hotel-option-image">
                                                                                                <img src="<%= hotelImg %>"
                                                                                                    alt="<%= hotel.getTenkhachsan() %>"
                                                                                                    onerror="this.onerror=null; this.src='https://via.placeholder.com/150?text=Hotel'"
                                                                                            </div>
                                                                                            <div
                                                                                                class="hotel-option-info">
                                                                                                <div
                                                                                                    class="hotel-option-name">
                                                                                                    <%= hotel.getTenkhachsan()
                                                                                                        %>
                                                                                                </div>
                                                                                                <div
                                                                                                    class="hotel-option-rating">
                                                                                                    <% if
                                                                                                        (hotel.getChatluong()
                                                                                                        !=null) { %>⭐
                                                                                                        <%= hotel.getChatluong()
                                                                                                            %>
                                                                                                            <% } %>
                                                                                                </div>
                                                                                                <div
                                                                                                    class="hotel-option-price">
                                                                                                    <%= hotel.getGia()
                                                                                                        !=null ?
                                                                                                        String.format("%,.0f",
                                                                                                        hotel.getGia())
                                                                                                        : "Liên hệ" %>
                                                                                                        ₫/đêm
                                                                                                </div>
                                                                                            </div>
                                                                                            <div
                                                                                                class="hotel-check-icon">
                                                                                                ✓
                                                                                            </div>
                                                                                </div>
                                                                                <% if (isFirst) isFirst=false; }} else {
                                                                                    %>
                                                                                    <div
                                                                                        style="text-align:center;padding:20px;color:#6b7280;background:#f9fafb;border-radius:10px;">
                                                                                        <p>🏨 Chưa có khách sạn phù hợp
                                                                                        </p>
                                                                                    </div>
                                                                                    <% } %>
                                                                                <div id="selectedHotelName" style="margin-top:12px;font-weight:600;color:#1f2937;display:none;"></div>
                                                                    </div>

                                                                    <div class="booking-form-group" id="roomSelection"
                                                                        style="display:none;">
                                                                        <label>🛏️ Số phòng</label>
                                                                        <select name="sophong" class="booking-select"
                                                                            id="soPhongSelect">
                                                                            <option value="1" selected>1 phòng</option>
                                                                            <option value="2">2 phòng</option>
                                                                            <option value="3">3 phòng</option>
                                                                            <option value="4">4 phòng</option>
                                                                            <option value="5">5 phòng</option>
                                                                        </select>
                                                                        <div class="room-price-info" id="roomPriceInfo">
                                                                        </div>
                                                                    </div>

                                                                    <button type="submit" class="btn-book-now">🎫 Đặt
                                                                        Tour
                                                                        Ngay</button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <%@ include file="/WEB-INF/includes/footer.jsp" %>

                                                <script>
                                                    function handleImageError(img) {
                                                        img.onerror = null;
                                                        img.style.display = 'none';
                                                        var placeholder = document.createElement('div');
                                                        placeholder.style.cssText = 'width:100%;height:100%;background:linear-gradient(135deg,#1a2b49,#2d4a7c);display:flex;align-items:center;justify-content:center;color:white;font-size:5rem;';
                                                        placeholder.textContent = '🏖️';
                                                        img.parentElement.appendChild(placeholder);
                                                    }

                                                    function setRating(value) {
                                                        document.getElementById('ratingInput').value = value;
                                                        var stars = document.querySelectorAll('.star-rating-input .star');
                                                        stars.forEach(function (star, index) {
                                                            if (index < value) star.classList.add('active');
                                                            else star.classList.remove('active');
                                                        });
                                                    }

                                                    var selectedHotelPrice = 0;
                                                    var soDem = <%= soDem %>;

                                                    function selectHotel(element) {
                                                        document.querySelectorAll('.hotel-option').forEach(function (opt) {
                                                            opt.classList.remove('selected');
                                                        });
                                                        element.classList.add('selected');
                                                        document.getElementById('selectedHotelId').value = element.getAttribute('data-hotel-id');
                                                        selectedHotelPrice = parseFloat(element.getAttribute('data-hotel-price')) || 0;
                                                        var nameEl = document.getElementById('selectedHotelName');
                                                        if (nameEl) {
                                                            var hotelName = element.getAttribute('data-hotel-name') || '';
                                                            nameEl.textContent = hotelName || '';
                                                            nameEl.style.display = hotelName ? 'block' : 'none';
                                                        }
                                                        document.getElementById('roomSelection').style.display = 'block';
                                                        updateRoomPriceInfo();
                                                    }

                                                    function updateRoomPriceInfo() {
                                                        var soPhong = parseInt(document.getElementById('soPhongSelect').value) || 1;
                                                        var totalHotelPrice = selectedHotelPrice * soPhong * soDem;
                                                        var priceInfo = document.getElementById('roomPriceInfo');
                                                        if (selectedHotelPrice > 0) {
                                                            priceInfo.innerHTML = soPhong + ' phòng × ' + soDem + ' đêm = <span class="total">' + totalHotelPrice.toLocaleString('vi-VN') + '₫</span>';
                                                        }
                                                        document.getElementById('hiddenSoPhong').value = soPhong;
                                                    }

                                                    document.getElementById('soPhongSelect').addEventListener('change', updateRoomPriceInfo);
                                                    document.getElementById('soNguoiSelect').addEventListener('change', function () {
                                                        document.getElementById('hiddenSoNguoi').value = this.value;
                                                    });

                                                    document.addEventListener('DOMContentLoaded', function () {
                                                        var firstHotel = document.querySelector('.hotel-option.selected');
                                                        if (firstHotel) selectHotel(firstHotel);
                                                    });

                                                    document.getElementById('bookingForm').addEventListener('submit', function (e) {
                                                        if (!document.getElementById('selectedHotelId').value) {
                                                            e.preventDefault();
                                                        }
                                                    });
                                                </script>
                                    </body>

                                    </html>