<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - Tour Du Lịch</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .register-container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 500px;
        }
        
        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .register-header h1 {
            color: #667eea;
            font-size: 2em;
            margin-bottom: 10px;
        }
        
        .register-header p {
            color: #666;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }
        
        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 60px;
        }
        
        .error-message {
            background: #fee;
            color: #c33;
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #c33;
        }
        
        .btn-register {
            width: 100%;
            padding: 12px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-register:hover {
            background: #5568d3;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .register-footer {
            text-align: center;
            margin-top: 20px;
            color: #666;
        }
        
        .register-footer a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }
        
        .register-footer a:hover {
            text-decoration: underline;
        }
        
        .back-home {
            text-align: center;
            margin-top: 15px;
        }
        
        .back-home a {
            color: #999;
            text-decoration: none;
            font-size: 14px;
        }
        
        .back-home a:hover {
            color: #667eea;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h1>📝 Đăng ký</h1>
            <p>Tạo tài khoản để đặt tour du lịch</p>
        </div>
        
        <% if (request.getAttribute("error") != null) { %>
        <div class="error-message">
            ✗ <%= request.getAttribute("error") %>
        </div>
        <% } %>
        
        <form method="POST" action="<%= request.getContextPath() %>/register">
            <div class="form-row">
                <div class="form-group">
                    <label for="tendangnhap">Tên đăng nhập *</label>
                    <input type="text" 
                           id="tendangnhap" 
                           name="tendangnhap" 
                           value="<%= request.getAttribute("tendangnhap") != null ? request.getAttribute("tendangnhap") : "" %>"
                           required 
                           autofocus
                           placeholder="4-20 ký tự">
                </div>
                
                <div class="form-group">
                    <label for="hotennguoidung">Họ tên *</label>
                    <input type="text" 
                           id="hotennguoidung" 
                           name="hotennguoidung" 
                           value="<%= request.getAttribute("hotennguoidung") != null ? request.getAttribute("hotennguoidung") : "" %>"
                           required
                           placeholder="Nguyễn Văn A">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="matkhau">Mật khẩu *</label>
                    <input type="password" 
                           id="matkhau" 
                           name="matkhau" 
                           required
                           placeholder="Tối thiểu 6 ký tự">
                </div>
                
                <div class="form-group">
                    <label for="matkhauConfirm">Xác nhận mật khẩu *</label>
                    <input type="password" 
                           id="matkhauConfirm" 
                           name="matkhauConfirm" 
                           required
                           placeholder="Nhập lại mật khẩu">
                </div>
            </div>
            
            <div class="form-group">
                <label for="email">Email *</label>
                <input type="email" 
                       id="email" 
                       name="email" 
                       value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                       required
                       placeholder="example@email.com">
            </div>
            
            <div class="form-group">
                <label for="sdt">Số điện thoại</label>
                <input type="tel" 
                       id="sdt" 
                       name="sdt" 
                       value="<%= request.getAttribute("sdt") != null ? request.getAttribute("sdt") : "" %>"
                       placeholder="0901234567">
            </div>
            
            <div class="form-group">
                <label for="diachi">Địa chỉ</label>
                <textarea id="diachi" 
                          name="diachi" 
                          placeholder="Địa chỉ của bạn"><%= request.getAttribute("diachi") != null ? request.getAttribute("diachi") : "" %></textarea>
            </div>
            
            <button type="submit" class="btn-register">Đăng ký</button>
        </form>
        
        <div class="register-footer">
            Đã có tài khoản? <a href="<%= request.getContextPath() %>/login">Đăng nhập</a>
        </div>
        
        <div class="back-home">
            <a href="<%= request.getContextPath() %>/">← Về trang chủ</a>
        </div>
    </div>
</body>
</html>



