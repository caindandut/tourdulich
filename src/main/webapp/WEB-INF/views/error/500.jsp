<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>500 - Lỗi server</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                max-width: 600px;
            }

            .error-code {
                font-size: 120px;
                font-weight: bold;
                color: #f5576c;
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
                background: #f5576c;
                color: white;
                text-decoration: none;
                border-radius: 50px;
                transition: all 0.3s;
            }

            a:hover {
                background: #f093fb;
                transform: translateY(-2px);
            }
        </style>
    </head>

    <body>
        <div class="error-container">
            <div class="error-code">500</div>
            <h1>Lỗi máy chủ</h1>
            <p>Xin lỗi, đã xảy ra lỗi khi xử lý yêu cầu của bạn.<br>Vui lòng thử lại sau.</p>
            <a href="<%= request.getContextPath() %>/home">Về trang chủ</a>

            <% if (exception !=null) { %>
                <div
                    style="margin-top: 30px; padding: 20px; background: #fee2e2; border-radius: 10px; text-align: left; overflow-x: auto;">
                    <h3 style="color: #991b1b;">Debug Info:</h3>
                    <p><strong>
                            <%= exception.getClass().getName() %>
                        </strong>: <%= exception.getMessage() %>
                    </p>
                    <pre
                        style="font-size: 12px; white-space: pre-wrap; word-wrap: break-word;"><% exception.printStackTrace(new java.io.PrintWriter(out)); %></pre>
                </div>
                <% } %>
        </div>
    </body>

    </html>