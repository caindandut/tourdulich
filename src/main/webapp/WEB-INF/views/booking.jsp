<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.tourdulich.model.Tour" %>
        <%@ page import="com.tourdulich.model.KhachHang" %>
            <%@ page import="com.tourdulich.model.NguoiDung" %>
                <%@ page import="java.time.format.DateTimeFormatter" %>
                    <%@ page import="java.time.LocalDate" %>
                        <!DOCTYPE html>
                        <html lang="vi">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <% 

                                Tour tour=(Tour) request.getAttribute("tour");
                                String selectedSoNguoiParam=(String) request.getAttribute("selectedSoNguoi");
                                String selectedSoPhongParam=(String) request.getAttribute("selectedSoPhong");
                                String selectedNgayDiParam=(String) request.getAttribute("selectedNgayDi");
                                String selectedNgayVeParam=(String) request.getAttribute("selectedNgayVe");
                                int selectedSoNguoi=2;
                                int selectedSoPhong=1;
                                LocalDate selectedNgayDi=tour.getNgaykhoihanh();
                                LocalDate selectedNgayVe=null;
                                LocalDate today=LocalDate.now();
                                try {
                                    if (selectedSoNguoiParam !=null)
                                        selectedSoNguoi=Integer.parseInt(selectedSoNguoiParam);
                                } catch(Exception ignored) {}
                                try {
                                    if (selectedSoPhongParam !=null)
                                        selectedSoPhong=Integer.parseInt(selectedSoPhongParam);
                                } catch(Exception ignored) {}
                                try {
                                    if (selectedNgayDiParam !=null && !selectedNgayDiParam.isEmpty())
                                        selectedNgayDi=LocalDate.parse(selectedNgayDiParam);
                                } catch(Exception ignored) {}
                                try {
                                    if (selectedNgayVeParam !=null && !selectedNgayVeParam.isEmpty())
                                        selectedNgayVe=LocalDate.parse(selectedNgayVeParam);
                                } catch(Exception ignored) {}
                                if (selectedNgayDi==null) {
                                    selectedNgayDi=tour.getNgaykhoihanh() !=null ? tour.getNgaykhoihanh() : today.plusDays(7);
                                }
                                if (selectedNgayVe==null) {

                                    int days=3;
                                    String thoiluong=tour.getThoiluong();
                                    if (thoiluong !=null) {
                                        try {
                                            String numStr=thoiluong.replaceAll("[^0-9]", " ").trim().split("\\s+")[0];
                                            days=Integer.parseInt(numStr);
                                        } catch (Exception e) {
                                            days=3;
                                        }
                                    }
                                    selectedNgayVe=selectedNgayDi.plusDays(days> 0 ? days : 3);
                                }
                                %>
                                <title>Đặt Tour - DUT Travel</title>
                                <link rel="preconnect" href="https://fonts.googleapis.com">
                                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
                                <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/dut-theme.css">
                                <style>
                                    .booking-page {
                                        max-width: 1200px;
                                        margin: 0 auto;
                                        padding: 40px 24px;
                                        display: grid;
                                        grid-template-columns: 1fr 380px;
                                        gap: 40px;
                                    }

                                    .booking-form-section {
                                        background: white;
                                        padding: 40px;
                                        border-radius: 16px;
                                        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
                                    }

                                    .booking-form-title {
                                        font-size: 1.5rem;
                                        font-weight: 600;
                                        color: #1e293b;
                                        margin-bottom: 32px;
                                    }

                                    .form-group {
                                        margin-bottom: 24px;
                                    }

                                    .form-label {
                                        display: block;
                                        font-size: 0.875rem;
                                        font-weight: 500;
                                        color: #64748b;
                                        margin-bottom: 8px;
                                    }

                                    .form-input {
                                        width: 100%;
                                        padding: 14px 16px;
                                        border: 1px solid #e2e8f0;
                                        border-radius: 8px;
                                        font-size: 1rem;
                                        color: #1e293b;
                                        background: #fff;
                                        transition: all 0.2s;
                                    }

                                    .form-input:focus {
                                        outline: none;
                                        border-color: #3b82f6;
                                        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
                                    }

                                    .form-input::placeholder {
                                        color: #94a3b8;
                                    }

                                    .form-row {
                                        display: grid;
                                        grid-template-columns: 1fr 1fr;
                                        gap: 20px;
                                    }

                                    .form-textarea {
                                        min-height: 100px;
                                        resize: vertical;
                                        font-family: inherit;
                                    }

                                    .form-agreement {
                                        font-size: 0.875rem;
                                        color: #64748b;
                                        margin-bottom: 24px;
                                        line-height: 1.6;
                                    }

                                    .form-agreement a {
                                        color: #3b82f6;
                                        text-decoration: none;
                                    }

                                    .form-agreement a:hover {
                                        text-decoration: underline;
                                    }

                                    .btn-continue {
                                        display: inline-flex;
                                        align-items: center;
                                        justify-content: center;
                                        padding: 14px 32px;
                                        background: #3b4d9b;
                                        color: white;
                                        border: none;
                                        border-radius: 8px;
                                        font-size: 1rem;
                                        font-weight: 600;
                                        cursor: pointer;
                                        transition: background 0.2s;
                                        float: right;
                                    }

                                    .btn-continue:hover {
                                        background: #2d3a78;
                                    }

                                    .booking-summary {
                                        background: white;
                                        border-radius: 16px;
                                        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
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

                                    .alert-error {
                                        background: #fef2f2;
                                        border: 1px solid #fecaca;
                                        color: #dc2626;
                                        padding: 12px 16px;
                                        border-radius: 8px;
                                        margin-bottom: 24px;
                                    }

                                    @media (max-width: 900px) {
                                        .booking-page {
                                            grid-template-columns: 1fr;
                                        }

                                        .booking-summary {
                                            position: static;
                                            order: -1;
                                        }
                                    }
                                </style>
                        </head>

                        <body>
                            <%@ include file="/WEB-INF/includes/header.jsp" %>

                                <div class="booking-page">
                                    <div class="booking-form-section">
                                        <h2 class="booking-form-title">Hãy cho DUT Travel biết bạn là ai</h2>

                                        <% if (request.getParameter("error") !=null) { %>
                                            <div class="alert-error">
                                                ❌
                                                <% 
                                                    String error=request.getParameter("error");
                                                    if (error.equals("booking_failed")) {
                                                        out.print("Đặt tour thất bại. Vui lòng thử lại!");
                                                    } else if (error.equals("invalid_data")) {
                                                        out.print("Dữ liệu không hợp lệ!");
                                                    } else if (error.equals("invalid_quantity")) {
                                                        out.print("Số lượng người không hợp lệ!");
                                                    } else {
                                                        out.print("Có lỗi xảy ra!");
                                                    }
                                                %>
                                            </div>
                                            <% } %>

                                                <form action="<%= request.getContextPath() %>/booking" method="POST"
                                                    id="bookingForm">
                                                    <input type="hidden" name="tourId" value="<%= tour.getId() %>">

                                                    <div class="form-group">
                                                        <label class="form-label">Họ và Tên</label>
                                                        <input type="text" name="hoten" class="form-input"
                                                            value="<%= currentUser != null ? currentUser.getHotennguoidung() : "" %>"
                                                            placeholder="Nhập họ và tên" required>
                                                    </div>

                                                    <div class="form-row">
                                                        <div class="form-group">
                                                            <label class="form-label">Email</label>
                                                            <input type="email" name="email" class="form-input"
                                                                value="<%= currentUser != null ? currentUser.getEmail() : "" %>"
                                                                placeholder="Nhập email" required>
                                                        </div>
                                                        <div class="form-group">
                                                            <label class="form-label">SDT</label>
                                                            <input type="tel" name="sdt" class="form-input"
                                                                value="<%= currentUser != null && currentUser.getSdt() != null ? currentUser.getSdt() : "" %>"
                                                                placeholder="Nhập số điện thoại" required>
                                                        </div>
                                                    </div>

                                                    <div class="form-group">
                                                        <label class="form-label">Địa Chỉ</label>
                                                        <input type="text" name="diachi" class="form-input"
                                                            placeholder="Nhập địa chỉ">
                                                    </div>

                                                    <div class="form-group">
                                                        <label class="form-label">Ghi chú</label>
                                                        <textarea name="ghichu" class="form-input form-textarea"
                                                            placeholder="Yêu cầu đặc biệt hoặc ghi chú..."></textarea>
                                                    </div>

                                                    <input type="hidden" name="soLuongNguoi"
                                                        value="<%= selectedSoNguoi %>">
                                                    <input type="hidden" name="soPhong" value="<%= selectedSoPhong %>">
                                                    <input type="hidden" name="ngayKhoihanh"
                                                        value="<%= selectedNgayDi.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) %>">
                                                    <input type="hidden" name="ngayve"
                                                        value="<%= selectedNgayVe.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) %>">

                                                    <p class="form-agreement">
                                                        Bằng việc tiếp tục, tôi đồng ý với các
                                                        <a href="#">điều khoản</a> và
                                                        <a href="#">chính sách quyền riêng tư</a> của DUT Travel.
                                                    </p>

                                                    <div style="text-align: right;">
                                                        <button type="submit" class="btn-continue">
                                                            Tiếp Tục
                                                        </button>
                                                    </div>
                                                </form>
                                    </div>

                                    <div class="booking-summary">
                                        <div class="booking-summary-header">
                                            <h3>Thông tin đặt tour của bạn</h3>
                                        </div>

                                        <div class="booking-tour-info">
                                            <div class="booking-tour-image">
                                                <% if (tour.getHinhanh() !=null && !tour.getHinhanh().trim().isEmpty())
                                                    { %>
                                                    <img src="<%= tour.getHinhanh() %>" alt="<%= tour.getTentour() %>">
                                                    <% } else { %>
                                                        <div
                                                            style="width: 100%; height: 100%; background: #3b4d9b; display: flex; align-items: center; justify-content: center; color: white; font-size: 2rem;">
                                                            🏖️</div>
                                                        <% } %>
                                            </div>
                                            <div class="booking-tour-details">
                                                <div class="booking-tour-name">
                                                    <%= tour.getTentour() %>
                                                </div>
                                                <div class="booking-tour-location">
                                                    <%= tour.getDiadiem() %>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="booking-details">
                                            <div class="booking-detail-row">
                                                <span class="booking-detail-label">Ngày đi</span>
                                                <span class="booking-detail-value" id="displayNgayDi">
                                                    <%= selectedNgayDi.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) %>
                                                </span>
                                            </div>
                                            <div class="booking-detail-row">
                                                <span class="booking-detail-label">Ngày về</span>
                                                <span class="booking-detail-value" id="displayNgayVe">
                                                    <%= selectedNgayVe.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) %>
                                                </span>
                                            </div>
                                            <div class="booking-detail-row">
                                                <span class="booking-detail-label">Lịch Trình</span>
                                                <span class="booking-detail-value">
                                                    <%= tour.getThoiluong() %>
                                                </span>
                                            </div>
                                            <div class="booking-detail-row">
                                                <span class="booking-detail-label">Bạn đã chọn:</span>
                                                <span class="booking-detail-value" id="displaySoNguoi">
                                                    <%= selectedSoPhong %> phòng, <%= selectedSoNguoi %> người
                                                </span>
                                            </div>
                                        </div>

                                        <div class="booking-total">
                                            <span class="booking-total-label">Giá</span>
                                            <span class="booking-total-value" id="displayTongTien">
                                                <%= String.format("%,.0f", tour.getGia().multiply(new
                                                    java.math.BigDecimal(selectedSoNguoi))) %> VND
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <%@ include file="/WEB-INF/includes/footer.jsp" %>

                                    <script>

                                    </script>
                        </body>

                        </html>