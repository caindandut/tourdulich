<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Tour Du Lịch</title>
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
        
        .login-container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 400px;
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .login-header h1 {
            color: #667eea;
            font-size: 2em;
            margin-bottom: 10px;
        }
        
        .login-header p {
            color: #666;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .error-message {
            background: #fee;
            color: #c33;
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #c33;
        }
        
        .success-message {
            background: #efe;
            color: #3c3;
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #3c3;
        }
        
        .btn-login {
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
        
        .btn-login:hover {
            background: #5568d3;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .login-footer {
            text-align: center;
            margin-top: 20px;
            color: #666;
        }
        
        .login-footer a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }
        
        .login-footer a:hover {
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
    <div class="login-container">
        <div class="login-header">
            <h1>🔐 Đăng nhập</h1>
            <p>Đăng nhập để đặt tour du lịch</p>
        </div>
        
        <% if (request.getParameter("success") != null && request.getParameter("success").equals("register")) { %>
        <div class="success-message">
            ✓ Đăng ký thành công! Vui lòng đăng nhập.
        </div>
        <% } %>
        
        <% if (request.getParameter("error") != null && request.getParameter("error").equals("require_login")) { %>
        <div class="error-message">
            ✗ Bạn cần đăng nhập để tiếp tục.
        </div>
        <% } %>
        
        <% if (request.getAttribute("error") != null) { %>
        <div class="error-message">
            ✗ <%= request.getAttribute("error") %>
        </div>
        <% } %>
        
        <form method="POST" action="<%= request.getContextPath() %>/login">
            <div class="form-group">
                <label for="tendangnhap">Tên đăng nhập</label>
                <input type="text" 
                       id="tendangnhap" 
                       name="tendangnhap" 
                       value="<%= request.getAttribute("tendangnhap") != null ? request.getAttribute("tendangnhap") : "" %>"
                       required 
                       autofocus>
            </div>
            
            <div class="form-group">
                <label for="matkhau">Mật khẩu</label>
                <input type="password" 
                       id="matkhau" 
                       name="matkhau" 
                       required>
            </div>
            
            <button type="submit" class="btn-login">Đăng nhập</button>
        </form>
        
        <div class="login-footer">
            Chưa có tài khoản? <a href="<%= request.getContextPath() %>/register">Đăng ký ngay</a>
        </div>
        
        <div class="back-home">
            <a href="<%= request.getContextPath() %>/">← Về trang chủ</a>
        </div>
    </div>
</body>
</html>



