<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>404 - Không tìm thấy trang</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }
        .error-container {
            text-align: center;
            background: white;
            padding: 60px;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        .error-code {
            font-size: 120px;
            font-weight: bold;
            color: #667eea;
            margin: 0;
        }
        h1 {
            color: #333;
            margin: 20px 0;
        }
        p {
            color: #666;
            margin-bottom: 30px;
        }
        a {
            display: inline-block;
            padding: 15px 40px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 50px;
            transition: all 0.3s;
        }
        a:hover {
            background: #764ba2;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-code">404</div>
        <h1>Không tìm thấy trang</h1>
        <p>Xin lỗi, trang bạn đang tìm kiếm không tồn tại.</p>
        <a href="<%= request.getContextPath() %>/">Về trang chủ</a>
    </div>
</body>
</html>

