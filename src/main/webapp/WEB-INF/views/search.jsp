<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tourdulich.model.Tour" %>
<%@ page import="com.tourdulich.model.NguoiDung" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm kiếm Tour - DUT Travel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/dut-theme.css">
</head>
<body>
    <%@ include file="/WEB-INF/includes/header.jsp" %>
    
    <section class="search-hero">
        <h1>Bạn muốn đi đâu?</h1>
        
        <div class="search-box" style="max-width: 600px; margin: 0 auto;">
            <form action="<%= request.getContextPath() %>/search" method="GET" style="display: flex; gap: 8px; width: 100%;">
                <div class="search-input-group" style="flex: 1;">
                    <span>🔍</span>
                    <input type="text" 
                           name="keyword" 
                           value="<%= request.getAttribute("keyword") != null ? request.getAttribute("keyword") : "" %>"
                           placeholder="Bạn muốn đi đâu?">
                </div>
                <button type="submit" class="search-btn">
                    🔍 Tìm kiếm
                </button>
            </form>
        </div>
    </section>
    
    <div class="tour-list">
        <div class="section-header">
            <h2 class="section-title">
                Tìm thấy 
                <span style="color: var(--accent-color);">
                    <%= request.getAttribute("totalResults") != null ? request.getAttribute("totalResults") : 0 %>
                </span> 
                kết quả
            </h2>
        </div>
        
        <%
            @SuppressWarnings("unchecked")
            List<Tour> tours = (List<Tour>) request.getAttribute("tours");
            if (tours != null && !tours.isEmpty()) {
                for (Tour tour : tours) {
        %>
        <div class="tour-card-horizontal">
            <div class="tour-card-image">
                <% if (tour.getHinhanh() != null && !tour.getHinhanh().trim().isEmpty()) { %>
                    <img src="<%= tour.getHinhanh() %>" alt="<%= tour.getTentour() %>" 
                         onerror="this.parentElement.innerHTML='<div class=\\'tour-card-image-placeholder\\'>🏖️</div>'">
                <% } else { %>
                    <div class="tour-card-image-placeholder">🏖️</div>
                <% } %>
            </div>
            <div class="tour-card-content">
                <div class="tour-card-header">
                    <div>
                        <h3 class="tour-card-title">
                            <a href="<%= request.getContextPath() %>/tour/detail?id=<%= tour.getId() %>">
                                <%= tour.getTentour() %>
                            </a>
                        </h3>
                        <div class="tour-card-location">
                            📍 <%= tour.getDiadiem() %>
                        </div>
                    </div>
                </div>
                
                <div class="tour-card-meta">
                    <div class="tour-card-meta-item">
                        ⏱️ <%= tour.getThoiluong() %>
                    </div>
                    <% if (tour.getPhuongtienchinh() != null) { %>
                    <div class="tour-card-meta-item">
                        🚌 <%= tour.getPhuongtienchinh() %>
                    </div>
                    <% } %>
                </div>
                
                <div class="tour-card-footer">
                    <div class="tour-price">
                        <span class="tour-price-value"><%= String.format("%,.0f", tour.getGia()) %> VND</span>
                    </div>
                    <a href="<%= request.getContextPath() %>/tour/detail?id=<%= tour.getId() %>" class="btn-view-tour">
                        Xem chi tiết →
                    </a>
                </div>
            </div>
        </div>
        <%
                }
            } else {
        %>
        <div style="text-align: center; padding: 80px 20px; background: white; border-radius: 12px;">
            <div style="font-size: 5rem; margin-bottom: 24px; opacity: 0.3;">🔍</div>
            <h3 style="color: #4A5568; font-size: 1.5rem; margin-bottom: 12px;">Không tìm thấy tour</h3>
            <p style="color: #A0AEC0;">Vui lòng thử lại với từ khóa khác</p>
        </div>
        <%
            }
        %>
        
        <% 
            Boolean needsPagination = (Boolean) request.getAttribute("needsPagination");
            Integer currentPage = (Integer) request.getAttribute("currentPage");
            Integer totalPages = (Integer) request.getAttribute("totalPages");
            String keyword = request.getParameter("keyword");
            String keywordParam = "";
            if (keyword != null && !keyword.trim().isEmpty()) {
                try {
                    keywordParam = "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8");
                } catch (Exception e) {
                    keywordParam = "&keyword=" + keyword;
                }
            }
            
            if (needsPagination != null && needsPagination && totalPages != null && totalPages > 1) {
        %>
        <div class="pagination">
            <% if (currentPage > 1) { %>
            <a href="<%= request.getContextPath() %>/search?page=<%= currentPage - 1 %><%= keywordParam %>" class="pagination-item">←</a>
            <% } %>
            
            <% 
                int startPage = Math.max(1, currentPage - 2);
                int endPage = Math.min(totalPages, currentPage + 2);
                
                if (startPage > 1) {
            %>
            <a href="<%= request.getContextPath() %>/search?page=1<%= keywordParam %>" class="pagination-item">1</a>
            <% if (startPage > 2) { %>
            <span class="pagination-item" style="cursor: default;">...</span>
            <% } %>
            <% } %>
            
            <% for (int i = startPage; i <= endPage; i++) { %>
            <a href="<%= request.getContextPath() %>/search?page=<%= i %><%= keywordParam %>" 
               class="pagination-item <%= i == currentPage ? "active" : "" %>"><%= i %></a>
            <% } %>
            
            <% if (endPage < totalPages) { %>
            <% if (endPage < totalPages - 1) { %>
            <span class="pagination-item" style="cursor: default;">...</span>
            <% } %>
            <a href="<%= request.getContextPath() %>/search?page=<%= totalPages %><%= keywordParam %>" class="pagination-item"><%= totalPages %></a>
            <% } %>
            
            <% if (currentPage < totalPages) { %>
            <a href="<%= request.getContextPath() %>/search?page=<%= currentPage + 1 %><%= keywordParam %>" class="pagination-item">→</a>
            <% } %>
        </div>
        <% } %>
    </div>
    
    <%@ include file="/WEB-INF/includes/footer.jsp" %>
</body>
</html>
