<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tourdulich.model.NguoiDung" %>
<%@ page import="com.tourdulich.model.DatTour" %>
<%@ page import="com.tourdulich.model.DanhGia" %>
<%@ page import="com.tourdulich.model.Tour" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - DUT Travel Admin</title>
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
                <h1 class="admin-header-title">Dashboard</h1>
                <div class="admin-header-actions">
                </div>
            </header>
            
            <div class="admin-content">
                <div class="admin-stats">
                    <div class="admin-stat-card">
                        <div class="stat-icon green">💰</div>
                        <div class="stat-value" style="font-size: 1.1rem;">
                            <% 
                                java.math.BigDecimal revenue = (java.math.BigDecimal) request.getAttribute("totalRevenue");
                                if (revenue != null) {
                                    out.print(String.format("%,.0f", revenue) + " VND");
                                } else {
                                    out.print("0 VND");
                                }
                            %>
                        </div>
                        <div class="stat-label">Doanh thu</div>
                    </div>
                    
                    <div class="admin-stat-card">
                        <div class="stat-icon blue">🏖️</div>
                        <div class="stat-value"><%= request.getAttribute("totalTours") != null ? request.getAttribute("totalTours") : 0 %></div>
                        <div class="stat-label">Tổng số Tour</div>
                    </div>
                    
                    <div class="admin-stat-card">
                        <div class="stat-icon green">📋</div>
                        <div class="stat-value"><%= request.getAttribute("totalBookings") != null ? request.getAttribute("totalBookings") : 0 %></div>
                        <div class="stat-label">Đơn đặt tour</div>
                    </div>
                    
                    <div class="admin-stat-card">
                        <div class="stat-icon purple">👥</div>
                        <div class="stat-value"><%= request.getAttribute("totalUsers") != null ? request.getAttribute("totalUsers") : 0 %></div>
                        <div class="stat-label">Người dùng</div>
                    </div>
                    
                    <div class="admin-stat-card">
                        <div class="stat-icon orange">💬</div>
                        <div class="stat-value"><%= request.getAttribute("totalReviews") != null ? request.getAttribute("totalReviews") : 0 %></div>
                        <div class="stat-label">Đánh giá</div>
                    </div>
                </div>
                
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px;">
                    <div class="admin-table-card">
                        <div class="admin-table-header">
                            <h3 class="admin-table-title">Đơn đặt tour gần đây</h3>
                            <a href="<%= request.getContextPath() %>/admin/bookings" class="btn btn-secondary" style="padding: 8px 16px; font-size: 0.85rem;">
                                Xem tất cả →
                            </a>
                        </div>
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>Mã đơn</th>
                                    <th>Tour</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    @SuppressWarnings("unchecked")
                                    List<DatTour> recentBookings = (List<DatTour>) request.getAttribute("recentBookings");
                                    if (recentBookings != null && !recentBookings.isEmpty()) {
                                        for (DatTour booking : recentBookings) {
                                            boolean isPaid = booking.getDathanhtoan() != null && booking.getDathanhtoan();
                                            String statusClass = "pending";
                                            String statusText = "Chờ xác nhận";
                                            if (booking.getTinhtrang() == DatTour.TinhTrang.CONFIRMED) {
                                                if (isPaid) {
                                                    statusClass = "success";
                                                    statusText = "Đã thanh toán";
                                                } else {
                                                    statusClass = "warning";
                                                    statusText = "Đã xác nhận chưa thanh toán";
                                                }
                                            } else if (booking.getTinhtrang() == DatTour.TinhTrang.CANCELLED) {
                                                statusClass = "danger";
                                                statusText = "Đã hủy";
                                            }
                                %>
                                <tr>
                                    <td>#<%= booking.getMadattour() != null ? booking.getMadattour() : booking.getId() %></td>
                                    <td><%= booking.getTour() != null ? booking.getTour().getTentour() : "Tour #" + booking.getTourId() %></td>
                                    <td><span class="status-badge <%= statusClass %>"><%= statusText %></span></td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="3" style="text-align: center; color: var(--text-secondary);">Chưa có đơn đặt tour</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                    
                    <div class="admin-table-card">
                        <div class="admin-table-header">
                            <h3 class="admin-table-title">Đánh giá gần đây</h3>
                            <a href="<%= request.getContextPath() %>/admin/reviews" class="btn btn-secondary" style="padding: 8px 16px; font-size: 0.85rem;">
                                Xem tất cả →
                            </a>
                        </div>
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>Người dùng</th>
                                    <th>Tour</th>
                                    <th>Đánh giá</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    @SuppressWarnings("unchecked")
                                    List<DanhGia> recentReviews = (List<DanhGia>) request.getAttribute("recentReviews");
                                    if (recentReviews != null && !recentReviews.isEmpty()) {
                                        for (DanhGia review : recentReviews) {
                                %>
                                <tr>
                                    <td><%= review.getKhachHang() != null && review.getKhachHang().getNguoiDung() != null 
                                            ? review.getKhachHang().getNguoiDung().getHotennguoidung() 
                                            : "Khách #" + review.getKhachhangId() %></td>
                                    <td><%= review.getTour() != null ? review.getTour().getTentour() : "Tour #" + review.getTourId() %></td>
                                    <td><span class="rating-badge"><%= review.getRating() != null ? review.getRating() : 5 %> ⭐</span></td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="3" style="text-align: center; color: var(--text-secondary);">Chưa có đánh giá</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <div class="admin-table-card" style="margin-top: 24px;">
                    <div class="admin-table-header">
                        <h3 class="admin-table-title">Thao tác nhanh</h3>
                    </div>
                    <div style="padding: 24px; display: flex; gap: 16px; flex-wrap: wrap;">
                        <a href="<%= request.getContextPath() %>/admin/tours/add" class="btn btn-primary">
                            ➕ Thêm Tour mới
                        </a>
                        <a href="<%= request.getContextPath() %>/admin/bookings" class="btn btn-secondary">
                            📋 Xem đơn đặt tour
                        </a>
                        <a href="<%= request.getContextPath() %>/admin/users" class="btn btn-secondary">
                            👥 Quản lý người dùng
                        </a>
                        <a href="<%= request.getContextPath() %>/home" class="btn btn-outline">
                            🏠 Về trang chủ
                        </a>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
