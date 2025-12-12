<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tourdulich.model.Tour" %>
<%@ page import="com.tourdulich.model.NguoiDung" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh giá Tour - DUT Travel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/dut-theme.css">
    <style>
        .review-page {
            max-width: 700px;
            margin: 0 auto;
            padding: 48px 24px;
        }
        
        .review-card {
            background: white;
            border-radius: var(--radius-lg);
            padding: 40px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
        }
        
        .review-header {
            text-align: center;
            margin-bottom: 32px;
        }
        
        .review-header h1 {
            font-size: 1.75rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 8px;
        }
        
        .review-header p {
            color: var(--text-secondary);
        }
        
        .tour-preview {
            display: flex;
            gap: 16px;
            padding: 20px;
            background: var(--bg-secondary);
            border-radius: var(--radius-md);
            margin-bottom: 32px;
        }
        
        .tour-preview-image {
            width: 100px;
            height: 75px;
            border-radius: var(--radius-sm);
            background: var(--primary-color);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2rem;
            flex-shrink: 0;
        }
        
        .tour-preview-info h3 {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 4px;
        }
        
        .tour-preview-info p {
            font-size: 0.9rem;
            color: var(--text-secondary);
        }
        
        .star-rating-wrapper {
            text-align: center;
            margin-bottom: 24px;
        }
        
        .star-rating-wrapper label {
            display: block;
            margin-bottom: 12px;
            font-weight: 500;
            color: var(--text-secondary);
        }
        
        .star-rating-select {
            display: flex;
            justify-content: center;
            gap: 8px;
        }
        
        .star-rating-select .star {
            font-size: 2.5rem;
            color: var(--border-color);
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .star-rating-select .star:hover,
        .star-rating-select .star.active {
            color: #fbbf24;
            transform: scale(1.1);
        }
        
        .rating-text {
            margin-top: 12px;
            font-weight: 500;
            color: var(--text-primary);
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/includes/header.jsp" %>
    
    <%
        Tour tour = (Tour) request.getAttribute("tour");
    %>
    
    <div class="review-page">
        <div class="review-card">
            <div class="review-header">
                <h1>💬 Đánh giá Tour</h1>
                <p>Chia sẻ trải nghiệm của bạn</p>
            </div>
            
            <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-error" style="margin-bottom: 24px;">
                ❌ 
                <% 
                    String error = request.getParameter("error");
                    if ("empty_content".equals(error)) {
                        out.print("Vui lòng nhập nội dung đánh giá!");
                    } else if ("review_failed".equals(error)) {
                        out.print("Đánh giá thất bại. Vui lòng thử lại!");
                    } else {
                        out.print("Có lỗi xảy ra!");
                    }
                %>
            </div>
            <% } %>
            
            <div class="tour-preview">
                <div class="tour-preview-image">
                    <% if (tour.getHinhanh() != null && !tour.getHinhanh().trim().isEmpty()) { %>
                        <img src="<%= tour.getHinhanh() %>" alt="<%= tour.getTentour() %>" 
                             style="width: 100%; height: 100%; object-fit: cover; border-radius: var(--radius-sm);">
                    <% } else { %>
                        🏖️
                    <% } %>
                </div>
                <div class="tour-preview-info">
                    <h3><%= tour.getTentour() %></h3>
                    <p>📍 <%= tour.getDiadiem() %></p>
                    <p>⏱️ <%= tour.getThoiluong() %></p>
                </div>
            </div>
            
            <form action="<%= request.getContextPath() %>/review" method="POST">
                <input type="hidden" name="tourId" value="<%= tour.getId() %>">
                <input type="hidden" name="rating" id="ratingInput" value="5">
                
                <div class="star-rating-wrapper">
                    <label>Đánh giá của bạn</label>
                    <div class="star-rating-select" id="starRating">
                        <span class="star active" data-value="1" onclick="setRating(1)">⭐</span>
                        <span class="star active" data-value="2" onclick="setRating(2)">⭐</span>
                        <span class="star active" data-value="3" onclick="setRating(3)">⭐</span>
                        <span class="star active" data-value="4" onclick="setRating(4)">⭐</span>
                        <span class="star active" data-value="5" onclick="setRating(5)">⭐</span>
                    </div>
                    <div class="rating-text" id="ratingText">5 sao - Tuyệt vời</div>
                </div>
                
                <div class="form-group" style="margin-bottom: 24px;">
                    <label class="form-label">Nội dung đánh giá *</label>
                    <textarea name="noidung" class="form-input" 
                              style="min-height: 150px; resize: vertical;"
                              placeholder="Chia sẻ trải nghiệm của bạn về tour này..."
                              required minlength="10" maxlength="1000"></textarea>
                    <div style="text-align: right; font-size: 0.85rem; color: var(--text-light); margin-top: 8px;">
                        <span id="charCount">0</span> / 1000 ký tự
                    </div>
                </div>
                
                <div style="display: flex; gap: 12px;">
                    <a href="<%= request.getContextPath() %>/tour/detail?id=<%= tour.getId() %>" 
                       class="btn btn-secondary" style="flex: 1; text-align: center;">
                        ← Quay lại
                    </a>
                    <button type="submit" class="btn btn-primary" style="flex: 2;">
                        ✅ Gửi đánh giá
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <%@ include file="/WEB-INF/includes/footer.jsp" %>
    
    <script>
        const ratingTexts = {
            1: '1 sao - Không hài lòng',
            2: '2 sao - Tạm được',
            3: '3 sao - Bình thường',
            4: '4 sao - Hài lòng',
            5: '5 sao - Tuyệt vời'
        };
        
        function setRating(value) {
            document.getElementById('ratingInput').value = value;
            document.getElementById('ratingText').textContent = ratingTexts[value];
            
            const stars = document.querySelectorAll('.star-rating-select .star');
            stars.forEach((star, index) => {
                if (index < value) {
                    star.classList.add('active');
                } else {
                    star.classList.remove('active');
                }
            });
        }
        

        const textarea = document.querySelector('textarea[name="noidung"]');
        const charCount = document.getElementById('charCount');
        textarea.addEventListener('input', function() {
            charCount.textContent = this.value.length;
        });
    </script>
</body>
</html>
