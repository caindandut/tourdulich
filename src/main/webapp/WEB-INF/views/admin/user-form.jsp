<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tourdulich.model.NguoiDung" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa Người dùng - DUT Travel Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/dut-theme.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin-theme.css">
    <style>
        .admin-form .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        .admin-form .form-group {
            margin-bottom: 16px;
        }
        .admin-form .form-label {
            display: block;
            margin-bottom: 6px;
            font-weight: 500;
            color: #374151;
        }
        .admin-form .form-input {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 0.95rem;
        }
        .admin-form .form-input:focus {
            outline: none;
            border-color: #3b4d9b;
            box-shadow: 0 0 0 3px rgba(59, 77, 155, 0.1);
        }
        .admin-form .form-input:disabled {
            background: #f3f4f6;
            cursor: not-allowed;
        }
        .admin-form .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 24px;
            padding-top: 20px;
            border-top: 1px solid #e5e7eb;
        }
        .admin-form-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .user-avatar {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #3b4d9b, #5b6fc4);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 16px;
        }
    </style>
</head>
<body>
    <div class="admin-layout">
        <%@ include file="/WEB-INF/includes/admin-sidebar.jsp" %>
        
        <main class="admin-main">
            <%
                NguoiDung user = (NguoiDung) request.getAttribute("user");
            %>
            <header class="admin-header">
                <h1 class="admin-header-title">Sửa thông tin người dùng</h1>
                <div class="admin-header-actions">
                    <a href="<%= request.getContextPath() %>/admin/users" class="btn btn-secondary">
                        ← Quay lại
                    </a>
                </div>
            </header>
            
            <div class="admin-content">
                <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-error">
                    ❌ Có lỗi xảy ra, vui lòng thử lại!
                </div>
                <% } %>
                
                <% if (user != null) { %>
                <div class="admin-form-card">
                    <div style="text-align: center; margin-bottom: 24px;">
                        <div class="user-avatar" style="margin: 0 auto 12px;">
                            <%= user.getHotennguoidung() != null ? user.getHotennguoidung().substring(0, 1).toUpperCase() : "U" %>
                        </div>
                        <h3 style="margin: 0; color: #1e293b;"><%= user.getHotennguoidung() %></h3>
                        <p style="margin: 4px 0 0; color: #64748b; font-size: 0.9rem;"><%= user.getEmail() %></p>
                    </div>
                    
                    <form action="<%= request.getContextPath() %>/admin/users/edit/<%= user.getId() %>" 
                          method="POST" class="admin-form">
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Tên đăng nhập</label>
                                <input type="text" class="form-input" value="<%= user.getTendangnhap() %>" disabled>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Mã người dùng</label>
                                <input type="text" class="form-input" value="<%= user.getManguoidung() != null ? user.getManguoidung() : "" %>" disabled>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Họ và tên *</label>
                            <input type="text" name="hotennguoidung" class="form-input" required
                                   value="<%= user.getHotennguoidung() != null ? user.getHotennguoidung() : "" %>"
                                   placeholder="Nhập họ và tên">
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Email *</label>
                                <input type="email" name="email" class="form-input" required
                                       value="<%= user.getEmail() != null ? user.getEmail() : "" %>"
                                       placeholder="Nhập email">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Số điện thoại</label>
                                <input type="tel" name="sdt" class="form-input"
                                       value="<%= user.getSdt() != null ? user.getSdt() : "" %>"
                                       placeholder="Nhập số điện thoại">
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Vai trò</label>
                                <select name="role" class="form-input">
                                    <option value="CUSTOMER" <%= user.getRole() == NguoiDung.Role.CUSTOMER ? "selected" : "" %>>Khách hàng</option>
                                    <option value="ADMIN" <%= user.getRole() == NguoiDung.Role.ADMIN ? "selected" : "" %>>Admin</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Trạng thái</label>
                                <select name="status" class="form-input">
                                    <option value="ACTIVE" <%= user.getStatus() == NguoiDung.Status.ACTIVE ? "selected" : "" %>>Hoạt động</option>
                                    <option value="LOCKED" <%= user.getStatus() == NguoiDung.Status.LOCKED ? "selected" : "" %>>Đã khóa</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">
                                💾 Cập nhật
                            </button>
                            <a href="<%= request.getContextPath() %>/admin/users" class="btn btn-secondary">
                                Hủy
                            </a>
                        </div>
                    </form>
                </div>
                <% } else { %>
                <div class="alert alert-error">
                    ❌ Không tìm thấy người dùng!
                </div>
                <% } %>
            </div>
        </main>
    </div>
</body>
</html>


