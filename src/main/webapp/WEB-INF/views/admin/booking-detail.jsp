<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tourdulich.model.DatTour" %>
<%@ page import="com.tourdulich.model.Tour" %>
<%@ page import="com.tourdulich.model.KhachHang" %>
<%@ page import="com.tourdulich.model.NguoiDung" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đặt tour - DUT Travel Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/dut-theme.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin-theme.css">
    <style>
        .detail-table-container {
            background: white;
            border-radius: 12px;
            padding: 24px;
            border: 1px solid var(--border-color);
            margin-bottom: 20px;
            overflow-x: auto;
        }
        .detail-table {
            width: 100%;
            border-collapse: collapse;
        }
        .detail-table th {
            background: #f8fafc;
            padding: 14px 16px;
            text-align: left;
            font-weight: 600;
            color: var(--text-primary);
            border-bottom: 2px solid var(--border-color);
            font-size: 0.95rem;
            width: 200px;
        }
        .detail-table td {
            padding: 14px 16px;
            border-bottom: 1px solid #f1f5f9;
            color: var(--text-primary);
            vertical-align: top;
        }
        .detail-table tr:last-child td {
            border-bottom: none;
        }
        .detail-table tr:hover {
            background: #f8fafc;
        }
        .detail-value {
            font-weight: 500;
        }
        .tour-image-cell {
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .tour-image {
            width: 120px;
            height: 90px;
            border-radius: 8px;
            object-fit: cover;
            background: var(--bg-secondary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            flex-shrink: 0;
        }
        .tour-name {
            font-size: 1.05rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 4px;
        }
        .tour-info {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        .detail-actions {
            display: flex;
            gap: 12px;
            margin-top: 20px;
        }
        @media (max-width: 768px) {
            .detail-table-container {
                padding: 16px;
            }
            .detail-table th,
            .detail-table td {
                padding: 10px 12px;
                font-size: 0.85rem;
            }
            .detail-table th {
                width: 150px;
            }
        }
    </style>
</head>
<body>
    <div class="admin-layout">
        <%@ include file="/WEB-INF/includes/admin-sidebar.jsp" %>
        
        <main class="admin-main">
            <header class="admin-header">
                <h1 class="admin-header-title">Chi tiết đặt tour</h1>
                <div class="admin-header-actions">
                    <a href="<%= request.getContextPath() %>/admin/bookings" class="btn btn-secondary">
                        ← Quay lại
                    </a>
                </div>
            </header>
            
            <div class="admin-content">
                <%
                    DatTour booking = (DatTour) request.getAttribute("booking");
                    Tour tour = booking != null ? booking.getTour() : null;
                    KhachHang khachHang = booking != null ? booking.getKhachHang() : null;
                    NguoiDung nguoiDung = khachHang != null ? khachHang.getNguoiDung() : null;
                    
                    if (booking == null) {
                %>
                <div class="alert alert-error">
                    ❌ Không tìm thấy thông tin đặt tour
                </div>
                <%
                    } else {
                        DatTour.TinhTrang tinhTrang = booking.getTinhtrang();
                        boolean isPaid = booking.getDathanhtoan() != null && booking.getDathanhtoan();
                        String statusClass = "pending";
                        String statusText = "Chờ xác nhận";
                        if (tinhTrang == DatTour.TinhTrang.CONFIRMED) {
                            if (isPaid) {
                                statusClass = "success";
                                statusText = "Đã thanh toán";
                            } else {
                                statusClass = "warning";
                                statusText = "Đã xác nhận chưa thanh toán";
                            }
                        } else if (tinhTrang == DatTour.TinhTrang.CANCELLED) {
                            statusClass = "danger";
                            statusText = "Đã hủy";
                        }
                        

                        LocalDateTime ngayDat = booking.getNgaydat();
                        if (ngayDat == null) {
                            ngayDat = booking.getCreatedAt();
                        }
                %>
                <div class="detail-table-container">
                    <table class="detail-table">
                        <tbody>
                            <tr>
                                <th>📋 Mã đặt tour</th>
                                <td class="detail-value">#<%= booking.getId() %></td>
                            </tr>
                            <tr>
                                <th>📅 Ngày đặt</th>
                                <td class="detail-value"><%= ngayDat != null ? ngayDat.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : "N/A" %></td>
                            </tr>
                            <tr>
                                <th>✈️ Ngày khởi hành</th>
                                <td class="detail-value"><%= booking.getNgayKhoihanh() != null ? booking.getNgayKhoihanh().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "N/A" %></td>
                            </tr>
                            <tr>
                                <th>🛏️ Số phòng</th>
                                <td class="detail-value"><%= booking.getSoPhong() > 0 ? booking.getSoPhong() : 1 %> phòng</td>
                            </tr>
                            <tr>
                                <th>👥 Số người</th>
                                <td class="detail-value"><%= booking.getSoLuongNguoi() %> người</td>
                            </tr>
                            <tr>
                                <th>💰 Tổng tiền</th>
                                <td class="detail-value" style="color: var(--accent-color); font-size: 1.1rem; font-weight: 600;"><%= booking.getTongtien() != null ? String.format("%,.0f", booking.getTongtien()) : "0" %> VND</td>
                            </tr>
                            <tr>
                                <th>📊 Trạng thái</th>
                                <td><span class="status-badge <%= statusClass %>"><%= statusText %></span></td>
                            </tr>
                            <tr>
                                <th>📝 Ghi chú</th>
                                <td class="detail-value"><%= booking.getGhichu() != null && !booking.getGhichu().isEmpty() ? booking.getGhichu() : "Không có" %></td>
                            </tr>
                            
                            <tr>
                                <th>👤 Họ tên</th>
                                <td class="detail-value">
                                    <% if (nguoiDung != null) { %>
                                        <%= nguoiDung.getHotennguoidung() %>
                                    <% } else { %>
                                        Mã khách hàng: #<%= booking.getKhachhangId() %>
                                    <% } %>
                                </td>
                            </tr>
                            <% if (nguoiDung != null) { %>
                            <tr>
                                <th>📧 Email</th>
                                <td class="detail-value"><%= nguoiDung.getEmail() %></td>
                            </tr>
                            <tr>
                                <th>📱 Số điện thoại</th>
                                <td class="detail-value"><%= nguoiDung.getSdt() != null ? nguoiDung.getSdt() : "N/A" %></td>
                            </tr>
                            <% if (khachHang != null && khachHang.getDiachi() != null) { %>
                            <tr>
                                <th>📍 Địa chỉ</th>
                                <td class="detail-value"><%= khachHang.getDiachi() %></td>
                            </tr>
                            <% } %>
                            <% } %>
                            
                            <% if (tour != null) { %>
                            <tr>
                                <th>🏖️ Tour</th>
                                <td>
                                    <div class="tour-image-cell">
                                        <% if (tour.getHinhanh() != null && !tour.getHinhanh().isEmpty()) { %>
                                        <img src="<%= tour.getHinhanh() %>" alt="<%= tour.getTentour() %>" class="tour-image">
                                        <% } else { %>
                                        <div class="tour-image">🏖️</div>
                                        <% } %>
                                        <div class="tour-info">
                                            <div class="tour-name"><%= tour.getTentour() %></div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>🔖 Mã tour</th>
                                <td class="detail-value"><%= tour.getMatour() %></td>
                            </tr>
                            <tr>
                                <th>📍 Địa điểm</th>
                                <td class="detail-value"><%= tour.getDiadiem() %></td>
                            </tr>
                            <tr>
                                <th>⏱️ Thời lượng</th>
                                <td class="detail-value"><%= tour.getThoiluong() %></td>
                            </tr>
                            <tr>
                                <th>💵 Giá gốc</th>
                                <td class="detail-value"><%= String.format("%,.0f", tour.getGia()) %> VND/người</td>
                            </tr>
                            <% if (tour.getPhuongtienchinh() != null && !tour.getPhuongtienchinh().isEmpty()) { %>
                            <tr>
                                <th>🚌 Phương tiện</th>
                                <td class="detail-value"><%= tour.getPhuongtienchinh() %></td>
                            </tr>
                            <% } %>
                            <% } else { %>
                            <tr>
                                <th>🏖️ Tour</th>
                                <td class="detail-value">Mã tour: #<%= booking.getTourId() %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <div class="detail-actions">
                    <% if (tinhTrang == DatTour.TinhTrang.PENDING) { %>
                    <a href="<%= request.getContextPath() %>/admin/bookings/confirm/<%= booking.getId() %>" 
                       class="btn btn-primary">
                        ✅ Xác nhận đơn
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/bookings/cancel/<%= booking.getId() %>" 
                       class="btn btn-secondary">
                        ❌ Hủy đơn
                    </a>
                    <% } %>
                    
                    <% if (tinhTrang == DatTour.TinhTrang.CONFIRMED && !isPaid) { %>
                    <form method="POST" action="<%= request.getContextPath() %>/admin/bookings/paid/<%= booking.getId() %>" 
                          style="display: inline-block; margin: 0;">
                        <button type="submit" 
                                class="btn btn-success">
                            💰 Đã thanh toán
                        </button>
                    </form>
                    <% } %>
                </div>
                <% } %>
            </div>
        </main>
    </div>
</body>
</html>
