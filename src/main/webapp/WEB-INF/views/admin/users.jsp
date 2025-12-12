<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tourdulich.model.NguoiDung" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Người dùng - DUT Travel Admin</title>
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
                <h1 class="admin-header-title">Tất cả tài khoản</h1>
            </header>
            
            <div class="admin-content">
                <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success">
                    ✅ Cập nhật thành công!
                </div>
                <% } %>
                
                <div class="admin-table-card">
                    <div class="admin-table-header">
                        <h3 class="admin-table-title">Tất cả tài khoản</h3>
                    </div>
                    
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Họ và Tên</th>
                                <th>Email</th>
                                <th>SDT</th>
                                <th>Vai trò</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                @SuppressWarnings("unchecked")
                                List<NguoiDung> users = (List<NguoiDung>) request.getAttribute("users");
                                Integer currentPage = (Integer) request.getAttribute("currentPage");
                                Boolean needsPagination = (Boolean) request.getAttribute("needsPagination");
                                int pageSize = 10;
                                int startStt = 1;
                                if (needsPagination != null && needsPagination && currentPage != null && currentPage > 1) {
                                    startStt = (currentPage - 1) * pageSize + 1;
                                }
                                if (users != null && !users.isEmpty()) {
                                    int stt = startStt;
                                    for (NguoiDung user : users) {
                            %>
                            <tr>
                                <td><%= stt++ %></td>
                                <td>
                                    <span style="color: var(--accent-color); font-weight: 500;">
                                        <%= user.getHotennguoidung() %>
                                    </span>
                                </td>
                                <td><%= user.getEmail() %></td>
                                <td><%= user.getSdt() != null ? user.getSdt() : "---" %></td>
                                <td>
                                    <% if (user.getRole() == NguoiDung.Role.ADMIN) { %>
                                        <span class="status-badge info">Admin</span>
                                    <% } else { %>
                                        <span class="status-badge">Khách hàng</span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if (user.getStatus() == NguoiDung.Status.ACTIVE) { %>
                                        <span class="status-badge success">Hoạt động</span>
                                    <% } else { %>
                                        <span class="status-badge danger">Đã khóa</span>
                                    <% } %>
                                </td>
                                <td>
                                    <div class="table-actions">
                                        <a href="<%= request.getContextPath() %>/admin/users/edit/<%= user.getId() %>" 
                                           class="btn-action edit" title="Sửa">Sửa</a>
                                        <% if (user.getStatus() == NguoiDung.Status.ACTIVE) { %>
                                            <a href="<%= request.getContextPath() %>/admin/users/lock/<%= user.getId() %>" 
                                               class="btn-action delete" title="Khóa tài khoản">Khóa</a>
                                        <% } else { %>
                                            <a href="<%= request.getContextPath() %>/admin/users/unlock/<%= user.getId() %>" 
                                               class="btn-action edit" title="Mở khóa tài khoản">Mở khóa</a>
                                        <% } %>
                                        <a href="<%= request.getContextPath() %>/admin/users/delete/<%= user.getId() %>" 
                                           class="btn-action delete" title="Xóa">Xóa</a>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="7" style="text-align: center; padding: 40px; color: var(--text-secondary);">
                                    Chưa có người dùng nào.
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                
                <% 
                    Integer totalPages = (Integer) request.getAttribute("totalPages");
                    String currentFilter = (String) request.getAttribute("currentFilter");
                    String filterParam = currentFilter != null ? "&filter=" + currentFilter : "";
                    
                    if (needsPagination != null && needsPagination && totalPages != null && totalPages > 1) {
                %>
                <div class="pagination" style="margin-top: 24px;">
                    <% if (currentPage > 1) { %>
                    <a href="<%= request.getContextPath() %>/admin/users?page=<%= currentPage - 1 %><%= filterParam %>" class="pagination-item">←</a>
                    <% } %>
                    
                    <% 
                        int startPage = Math.max(1, currentPage - 2);
                        int endPage = Math.min(totalPages, currentPage + 2);
                        
                        if (startPage > 1) {
                    %>
                    <a href="<%= request.getContextPath() %>/admin/users?page=1<%= filterParam %>" class="pagination-item">1</a>
                    <% if (startPage > 2) { %>
                    <span class="pagination-item" style="cursor: default;">...</span>
                    <% } %>
                    <% } %>
                    
                    <% for (int i = startPage; i <= endPage; i++) { %>
                    <a href="<%= request.getContextPath() %>/admin/users?page=<%= i %><%= filterParam %>" 
                       class="pagination-item <%= i == currentPage ? "active" : "" %>"><%= i %></a>
                    <% } %>
                    
                    <% if (endPage < totalPages) { %>
                    <% if (endPage < totalPages - 1) { %>
                    <span class="pagination-item" style="cursor: default;">...</span>
                    <% } %>
                    <a href="<%= request.getContextPath() %>/admin/users?page=<%= totalPages %><%= filterParam %>" class="pagination-item"><%= totalPages %></a>
                    <% } %>
                    
                    <% if (currentPage < totalPages) { %>
                    <a href="<%= request.getContextPath() %>/admin/users?page=<%= currentPage + 1 %><%= filterParam %>" class="pagination-item">→</a>
                    <% } %>
                </div>
                <% } %>
            </div>
        </main>
    </div>
</body>
</html>
