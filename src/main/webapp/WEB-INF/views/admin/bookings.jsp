<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tourdulich.model.DatTour" %>
<%@ page import="com.tourdulich.model.Tour" %>
<%@ page import="com.tourdulich.model.KhachHang" %>
<%@ page import="com.tourdulich.model.NguoiDung" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Đơn đặt tour - DUT Travel Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/dut-theme.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin-theme.css">
    <style>
        .table-meta {
            font-size: 0.85rem;
            line-height: 1.6;
        }
        .table-meta strong {
            color: var(--text-secondary);
            font-weight: 500;
        }
        .admin-table td {
            vertical-align: top;
            padding: 16px 12px;
        }
        .admin-table th {
            padding: 14px 12px;
            white-space: nowrap;
        }
        .tour-name {
            font-weight: 600;
            color: var(--accent-color);
            text-decoration: none;
        }
        .tour-name:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="admin-layout">
        <%@ include file="/WEB-INF/includes/admin-sidebar.jsp" %>
        
        <main class="admin-main">
            <header class="admin-header">
                <h1 class="admin-header-title">Danh sách đặt tour</h1>
            </header>
            
            <div class="admin-content">
                <% if (request.getParameter("success") != null) { %>
                    <% if ("payment_marked".equals(request.getParameter("success"))) { %>
                    <div class="alert alert-success">
                        ✅ Đã đánh dấu thanh toán thành công!
                    </div>
                    <% } else { %>
                    <div class="alert alert-success">
                        ✅ Cập nhật trạng thái thành công!
                    </div>
                    <% } %>
                <% } %>
                
                <div class="admin-table-card">
                    <div class="admin-table-header">
                        <h3 class="admin-table-title">Danh sách đặt tour</h3>
                    </div>
                    
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Tên Tour</th>
                                <th>Thông tin khách hàng</th>
                                <th>Thông tin tour</th>
                                <th>Trạng Thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                @SuppressWarnings("unchecked")
                                List<DatTour> bookings = (List<DatTour>) request.getAttribute("bookings");
                                if (bookings != null && !bookings.isEmpty()) {
                                    int stt = 1;
                                    for (DatTour booking : bookings) {
                                        Tour tour = booking.getTour();
                                        KhachHang khachHang = booking.getKhachHang();
                                        NguoiDung nguoiDung = (khachHang != null) ? khachHang.getNguoiDung() : null;
                                        
                                        String tourName = (tour != null) ? tour.getTentour() : "Tour #" + booking.getTourId();
                                        String customerName = (nguoiDung != null && nguoiDung.getHotennguoidung() != null) 
                                            ? nguoiDung.getHotennguoidung() : "Khách hàng #" + booking.getKhachhangId();
                                        String email = (nguoiDung != null && nguoiDung.getEmail() != null) 
                                            ? nguoiDung.getEmail() : "---";
                                        String phone = (nguoiDung != null && nguoiDung.getSdt() != null) 
                                            ? nguoiDung.getSdt() : "---";
                                        String address = (khachHang != null && khachHang.getDiachi() != null) 
                                            ? khachHang.getDiachi() : "---";
                                        

                                        String pttt = booking.getPttt();

                                        boolean isDirectPayment = true;
                                        if (pttt != null && !pttt.trim().isEmpty()) {
                                            String ptttLower = pttt.toLowerCase();

                                            isDirectPayment = !(ptttLower.contains("chuyển khoản") || 
                                                               ptttLower.contains("chuyen khoan") ||
                                                               ptttLower.contains("thẻ") ||
                                                               ptttLower.contains("the") ||
                                                               ptttLower.contains("card") ||
                                                               ptttLower.contains("online") ||
                                                               ptttLower.contains("banking"));
                                        }
                                        boolean isPaid = booking.getDathanhtoan() != null && booking.getDathanhtoan();
                                        

                                        DatTour.TinhTrang tinhTrang = booking.getTinhtrang();
                            %>
                            <tr>
                                <td><%= stt++ %></td>
                                <td>
                                    <a href="<%= request.getContextPath() %>/admin/bookings/view/<%= booking.getId() %>" 
                                       class="tour-name">
                                        <%= tourName %>
                                    </a>
                                </td>
                                <td>
                                    <div class="table-meta">
                                        <strong>Tên:</strong> <%= customerName %><br>
                                        <strong>Email:</strong> <%= email %><br>
                                        <strong>SĐT:</strong> <%= phone %><br>
                                        <strong>Địa chỉ:</strong> <%= address %>
                                    </div>
                                </td>
                                <td>
                                    <div class="table-meta">
                                        <strong>Ngày khởi hành:</strong> <%= booking.getNgayKhoihanh() != null ? booking.getNgayKhoihanh().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "N/A" %><br>
                                        <strong>Số phòng:</strong> <%= booking.getSoPhong() > 0 ? booking.getSoPhong() : 1 %> phòng<br>
                                        <strong>Số người:</strong> <%= booking.getSoLuongNguoi() %> người<br>
                                        <strong>Tổng giá:</strong> <span class="table-price"><%= booking.getTongtien() != null ? String.format("%,.0f", booking.getTongtien()) : "0" %>VND</span><br>
                                        <strong>Ghi chú:</strong> <%= booking.getGhichu() != null && !booking.getGhichu().isEmpty() ? booking.getGhichu() : "" %>
                                    </div>
                                </td>
                                <td>
                                    <%
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
                                    %>
                                    <span class="status-badge <%= statusClass %>"><%= statusText %></span>
                                </td>
                                <td>
                                    <div class="table-actions">
                                        <% 
                                            if (tinhTrang == DatTour.TinhTrang.PENDING) {
                                        %>
                                        <a href="<%= request.getContextPath() %>/admin/bookings/confirm/<%= booking.getId() %>" 
                                           class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">
                                            Tiếp Nhận
                                        </a>
                                        <a href="<%= request.getContextPath() %>/admin/bookings/cancel/<%= booking.getId() %>" 
                                           class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.8rem;">
                                            Hủy
                                        </a>
                                        <% } %>
                                        
                                        <% 




                                            if (tinhTrang == DatTour.TinhTrang.CONFIRMED && !isPaid) { 
                                        %>
                                        <form method="POST" action="<%= request.getContextPath() %>/admin/bookings/paid/<%= booking.getId() %>" 
                                              style="display: inline-block; margin: 0;">
                                            <button type="submit" 
                                                    class="btn btn-success" 
                                                    style="padding: 6px 12px; font-size: 0.8rem; margin-right: 4px;">
                                                💰 Đã thanh toán
                                            </button>
                                        </form>
                                        <% } %>
                                        
                                        <a href="<%= request.getContextPath() %>/admin/bookings/view/<%= booking.getId() %>" 
                                           class="btn-action view" title="Xem chi tiết">Xem</a>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 40px; color: var(--text-secondary);">
                                    Chưa có đơn đặt tour nào.
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
