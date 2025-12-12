<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tourdulich.model.Tour" %>
<%@ page import="com.tourdulich.model.NguoiDung" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DUT Travel - Đặt Tour Du Lịch Trực Tuyến</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/dut-theme.css?v=2.0">
    <script>console.log('Context Path: <%= request.getContextPath() %>');</script>
    <script>console.log('CSS URL: <%= request.getContextPath() %>/assets/css/dut-theme.css?v=2.0');</script>
    <style>
        :root {
            --primary-color: #1a2b49;
            --primary-dark: #0f1a2e;
            --primary-light: #2d4a7c;
            --accent-color: #3b82f6;
            --accent-hover: #2563eb;
            --text-primary: #1f2937;
            --text-secondary: #6b7280;
            --text-light: #9ca3af;
            --bg-primary: #ffffff;
            --bg-secondary: #f9fafb;
            --bg-tertiary: #f3f4f6;
            --border-color: #e5e7eb;
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
            --radius-sm: 6px;
            --radius-md: 8px;
            --radius-lg: 12px;
            --radius-xl: 16px;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: var(--bg-secondary);
            color: var(--text-primary);
            line-height: 1.6;
            min-height: 100vh;
        }
        
        .hero-section {
            background: none;
            padding: 120px 24px 200px;
            min-height: 70vh;
            text-align: center;
            color: white;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('https://i.ex-cdn.com/vntravellive.com/files/news/2023/10/09/thoi-bao-anh-du-lich-viet-nam-dang-bung-no-la-diem-den-ly-tuong-voi-muc-gia-canh-tranh-160721.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            opacity: 1;
        }
        
        .hero-content {
            position: relative;
            z-index: 1;
            max-width: 900px;
            margin: 0 auto;
        }
        
        .hero-title {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 20px;
            letter-spacing: -1px;
            line-height: 1.2;
        }
        
        .hero-subtitle {
            font-size: 1.25rem;
            opacity: 0.9;
            margin-bottom: 40px;
            font-weight: 400;
        }
        
        .hero-search {
            max-width: 700px;
            margin: 0 auto;
        }
        
        .hero-search .search-box {
            margin-top: -80px;
            position: relative;
            z-index: 10;
        }
        
        .featured-section {
            max-width: 1280px;
            margin: 0 auto;
            padding: 80px 24px;
        }
        
        .section-header {
            text-align: center;
            margin-bottom: 48px;
        }
        
        .section-header h2 {
            font-size: 2.25rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 12px;
        }
        
        .section-header p {
            color: var(--text-secondary);
            font-size: 1.1rem;
        }
        
        .stats-section {
            background: var(--bg-tertiary);
            padding: 60px 24px;
        }
        
        .stats-container {
            max-width: 1280px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 32px;
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-value {
            font-size: 3rem;
            font-weight: 700;
            color: var(--accent-color);
            margin-bottom: 8px;
        }
        
        .stat-label {
            color: var(--text-secondary);
            font-size: 1rem;
        }
        
        .cta-section {
            background: linear-gradient(135deg, var(--accent-color) 0%, #1d4ed8 100%);
            padding: 80px 24px;
            text-align: center;
            color: white;
        }
        
        .cta-content h2 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 16px;
        }
        
        .cta-content p {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 32px;
        }
        
        .cta-btn {
            padding: 16px 48px;
            background: white;
            color: var(--accent-color);
            border: none;
            border-radius: var(--radius-lg);
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.2s;
        }
        
        .cta-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
            color: var(--accent-color);
        }
        
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.25rem;
            }
            
            .stats-container {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/includes/header.jsp" %>
    
    <section class="hero-section">
        <div class="hero-content">
            <h1 class="hero-title"> Khám phá Việt Nam cùng DUT Travel</h1>
        </div>
    </section>
    
    <div class="search-box-container">
        <div class="search-box">
            <form action="<%= request.getContextPath() %>/search" method="GET" class="search-form">
                <div class="search-input-group" style="max-width: 500px;">
                    <span>🔍</span>
                    <input type="text" name="keyword" placeholder="Bạn muốn đi đâu?">
                </div>
                <button type="submit" class="search-btn">
                    🔍 Tìm kiếm
                </button>
            </form>
        </div>
    </div>
    
    <section class="featured-section">
        <div class="section-header">
            <h2>🌟 Tour Nổi Bật</h2>
            <p>Những hành trình được yêu thích nhất</p>
        </div>
        
        <div class="tour-grid">
            <%
                @SuppressWarnings("unchecked")
                List<Tour> featuredTours = (List<Tour>) request.getAttribute("featuredTours");
                if (featuredTours != null && !featuredTours.isEmpty()) {
                    for (Tour tour : featuredTours) {
            %>
            <div class="tour-card-vertical">
                <div class="tour-card-image">
                    <% 
                        String imageUrl = null;
                        if (tour.getHinhanh() != null && !tour.getHinhanh().trim().isEmpty()) {
                            String hinhanh = tour.getHinhanh().trim();

                            if (hinhanh.toLowerCase().startsWith("http://") || hinhanh.toLowerCase().startsWith("https://")) {
                                imageUrl = hinhanh;
                            } else if (hinhanh.startsWith("/")) {
                                imageUrl = hinhanh;
                            } else {
                                imageUrl = null;
                            }
                        }
                        String tourName = tour.getTentour() != null ? tour.getTentour().replace("\"", "&quot;").replace("'", "&#39;") : "Tour";
                    %>
                    <% if (imageUrl != null) { %>
                        <img src="<%= imageUrl %>" alt="<%= tourName %>" 
                             class="tour-image" 
                             data-placeholder="true">
                    <% } else { %>
                        <div class="tour-card-image-placeholder">🏖️</div>
                    <% } %>
                </div>
                <div class="tour-card-content">
                    <h3 class="tour-card-title">
                        <a href="<%= request.getContextPath() %>/tour/detail?id=<%= tour.getId() %>">
                            <%= tour.getTentour() %>
                        </a>
                    </h3>
                    <div class="tour-card-location">
                        📍 <%= tour.getDiadiem() %>
                    </div>
                    <div class="tour-card-meta">
                        <div class="tour-card-meta-item">⏱️ <%= tour.getThoiluong() %></div>
                    </div>
                    <div class="tour-card-footer">
                        <div class="tour-price">
                            <span class="tour-price-value"><%= String.format("%,.0f", tour.getGia()) %> VND</span>
                        </div>
                        <a href="<%= request.getContextPath() %>/tour/detail?id=<%= tour.getId() %>" class="btn-view-tour">
                            Chi tiết →
                        </a>
                    </div>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div class="no-tours-message">
                <p>Chưa có tour nào. Vui lòng quay lại sau!</p>
            </div>
            <%
                }
            %>
        </div>
        
        <div class="view-all-tours">
            <a href="<%= request.getContextPath() %>/search" class="btn btn-primary btn-large">
                Xem tất cả tour →
            </a>
        </div>
    </section>
    
    <section class="cta-section">
        <div class="cta-content">
            <h2>Sẵn sàng cho chuyến đi tiếp theo?</h2>
            <p>Đăng ký ngay để nhận ưu đãi đặc biệt và thông tin tour mới nhất</p>
            <a href="<%= request.getContextPath() %>/register" class="cta-btn">
                Đăng ký ngay
            </a>
        </div>
    </section>
    
    <%@ include file="/WEB-INF/includes/footer.jsp" %>
    
    <script>

        document.addEventListener('DOMContentLoaded', function() {
            const tourImages = document.querySelectorAll('.tour-image[data-placeholder]');
            tourImages.forEach(function(img) {
                img.addEventListener('error', function() {
                    this.onerror = null;
                    const placeholder = document.createElement('div');
                    placeholder.className = 'tour-card-image-placeholder';
                    placeholder.innerHTML = '🏖️';
                    if (this.parentElement) {
                        this.parentElement.replaceChild(placeholder, this);
                    }
                });
            });
        });
    </script>
</body>
</html>
