<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Tour Du Lịch</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            background-size: 200% 200%;
            animation: gradientShift 15s ease infinite;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }
        
        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        
        body::before {
            content: '';
            position: absolute;
            width: 500px;
            height: 500px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            top: -250px;
            right: -250px;
            animation: float 20s ease-in-out infinite;
        }
        
        body::after {
            content: '';
            position: absolute;
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 50%;
            bottom: -200px;
            left: -200px;
            animation: float 25s ease-in-out infinite reverse;
        }
        
        @keyframes float {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            33% { transform: translate(30px, -30px) rotate(120deg); }
            66% { transform: translate(-20px, 20px) rotate(240deg); }
        }
        
        .login-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 50px 45px;
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3),
                        0 0 0 1px rgba(255, 255, 255, 0.5);
            width: 100%;
            max-width: 440px;
            position: relative;
            z-index: 1;
            animation: slideUp 0.6s ease-out;
        }
        
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .login-header .icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 36px;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
            animation: pulse 2s ease-in-out infinite;
        }
        
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
        
        .login-header h1 {
            color: #1a1a2e;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }
        
        .login-header p {
            color: #6b7280;
            font-size: 15px;
            font-weight: 400;
        }
        
        .form-group {
            margin-bottom: 24px;
            position: relative;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #374151;
            font-weight: 500;
            font-size: 14px;
            letter-spacing: 0.2px;
        }
        
        .input-wrapper {
            position: relative;
        }
        
        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #9ca3af;
            font-size: 18px;
            z-index: 1;
            transition: color 0.3s;
        }
        
        .form-group input {
            width: 100%;
            padding: 14px 16px 14px 48px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.3s;
            background: #f9fafb;
            color: #1a1a2e;
            font-family: inherit;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }
        
        .form-group input:focus + .input-icon {
            color: #667eea;
        }
        
        .password-toggle {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #9ca3af;
            cursor: pointer;
            font-size: 18px;
            padding: 4px;
            transition: color 0.3s;
            z-index: 2;
        }
        
        .password-toggle:hover {
            color: #667eea;
        }
        
        .error-message {
            background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
            color: #dc2626;
            padding: 14px 18px;
            border-radius: 12px;
            margin-bottom: 24px;
            border-left: 4px solid #dc2626;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: shake 0.5s;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }
        
        .success-message {
            background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
            color: #059669;
            padding: 14px 18px;
            border-radius: 12px;
            margin-bottom: 24px;
            border-left: 4px solid #059669;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideDown 0.5s ease-out;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .btn-login {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 8px;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            position: relative;
            overflow: hidden;
        }
        
        .btn-login::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }
        
        .btn-login:hover::before {
            width: 300px;
            height: 300px;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.5);
        }
        
        .btn-login:active {
            transform: translateY(0);
        }
        
        .btn-login span {
            position: relative;
            z-index: 1;
        }
        
        .login-footer {
            text-align: center;
            margin-top: 28px;
            color: #6b7280;
            font-size: 14px;
        }
        
        .login-footer a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            position: relative;
        }
        
        .login-footer a::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 0;
            height: 2px;
            background: #667eea;
            transition: width 0.3s;
        }
        
        .login-footer a:hover::after {
            width: 100%;
        }
        
        .back-home {
            text-align: center;
            margin-top: 20px;
        }
        
        .back-home a {
            color: #9ca3af;
            text-decoration: none;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s;
        }
        
        .back-home a:hover {
            color: #667eea;
            transform: translateX(-4px);
        }
        
        @media (max-width: 480px) {
            .login-container {
                padding: 40px 30px;
            }
            
            .login-header h1 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <div class="icon">🔐</div>
            <h1>Đăng nhập</h1>
            <p>Chào mừng bạn trở lại</p>
        </div>
        
        <% if (request.getParameter("success") != null && request.getParameter("success").equals("register")) { %>
        <div class="success-message">
            <span>✓</span>
            <span>Đăng ký thành công! Vui lòng đăng nhập.</span>
        </div>
        <% } %>
        
        <% if (request.getParameter("error") != null && request.getParameter("error").equals("require_login")) { %>
        <div class="error-message">
            <span>✗</span>
            <span>Bạn cần đăng nhập để tiếp tục.</span>
        </div>
        <% } %>
        
        <% if (request.getAttribute("error") != null) { %>
        <div class="error-message">
            <span>✗</span>
            <span><%= request.getAttribute("error") %></span>
        </div>
        <% } %>
        
        <form method="POST" action="<%= request.getContextPath() %>/login" id="loginForm">
            <div class="form-group">
                <label for="tendangnhap">Tên đăng nhập</label>
                <div class="input-wrapper">
                    <span class="input-icon">👤</span>
                    <input type="text" 
                           id="tendangnhap" 
                           name="tendangnhap" 
                           value="<%= request.getAttribute("tendangnhap") != null ? request.getAttribute("tendangnhap") : "" %>"
                           required 
                           autofocus
                           placeholder="Nhập tên đăng nhập">
                </div>
            </div>
            
            <div class="form-group">
                <label for="matkhau">Mật khẩu</label>
                <div class="input-wrapper">
                    <span class="input-icon">🔒</span>
                    <input type="password" 
                           id="matkhau" 
                           name="matkhau" 
                           required
                           placeholder="Nhập mật khẩu">
                    <button type="button" class="password-toggle" onclick="togglePassword()">👁️</button>
                </div>
            </div>
            
            <button type="submit" class="btn-login">
                <span>Đăng nhập</span>
            </button>
        </form>
        
        <div class="login-footer">
            Chưa có tài khoản? <a href="<%= request.getContextPath() %>/register">Đăng ký ngay</a>
        </div>
        
        <div class="back-home">
            <a href="<%= request.getContextPath() %>/">
                <span>←</span>
                <span>Về trang chủ</span>
            </a>
        </div>
    </div>
    
    <script>
        function togglePassword() {
            const passwordInput = document.getElementById('matkhau');
            const toggleBtn = document.querySelector('.password-toggle');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleBtn.textContent = '🙈';
            } else {
                passwordInput.type = 'password';
                toggleBtn.textContent = '👁️';
            }
        }
        
        // Add smooth focus animations
        document.querySelectorAll('input').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.style.transform = 'scale(1.02)';
            });
            
            input.addEventListener('blur', function() {
                this.parentElement.style.transform = 'scale(1)';
            });
        });
    </script>
</body>
</html>



