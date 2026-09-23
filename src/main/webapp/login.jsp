<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>智能课堂考勤与学习行为分析系统 - 登录</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-size: cover;
            background-position: center;
        }
        
        .login-container {
            background-color: white;
            padding: 50px 40px;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            transition: all 0.3s ease;
        }
        
        .login-container:hover {
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.15);
        }
        
        .logo {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .logo-icon {
            font-size: 60px;
            color: #667eea;
            margin-bottom: 15px;
        }
        
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 35px;
            font-weight: 600;
            font-size: 24px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
            font-size: 14px;
        }
        
        input[type="text"], input[type="password"], select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 16px;
            transition: all 0.3s ease;
            background-color: #f9fafb;
        }
        
        input[type="text"]:focus, input[type="password"]:focus, select:focus {
            outline: none;
            border-color: #667eea;
            background-color: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .button-group {
            margin-top: 30px;
        }
        
        button {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .login-btn {
            background-color: #667eea;
            color: white;
            margin-bottom: 12px;
        }
        
        .login-btn:hover {
            background-color: #5a6fd8;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }
        
        .register-btn {
            background-color: #f0f2f5;
            color: #333;
        }
        
        .register-btn:hover {
            background-color: #e4e6eb;
            transform: translateY(-2px);
        }
        
        button:active {
            transform: translateY(0);
        }
        
        .error {
            color: #e53935;
            text-align: center;
            margin-top: 20px;
            padding: 10px;
            background-color: #ffebee;
            border-radius: 6px;
            font-size: 14px;
            border: 1px solid #ffcdd2;
        }
        
        .form-checkbox {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .form-checkbox input[type="checkbox"] {
            margin-right: 8px;
            width: auto;
        }
        
        .form-checkbox label {
            margin-bottom: 0;
            font-weight: 400;
            cursor: pointer;
        }
        
        /* 响应式设计 */
        @media (max-width: 480px) {
            .login-container {
                padding: 40px 25px;
                margin: 0 20px;
            }
            
            h2 {
                font-size: 20px;
            }
            
            input[type="text"], input[type="password"], select {
                padding: 10px 12px;
                font-size: 14px;
            }
            
            button {
                padding: 12px;
                font-size: 14px;
            }
        }
        
        /* 加载动画 */
        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 1s ease-in-out infinite;
            margin-right: 8px;
        }
        
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo">
            <div class="logo-icon">📚</div>
        </div>
        <h2>智能课堂系统</h2>
        <form action="/user/login" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="username">用户名</label>
                <input type="text" id="username" name="username" required placeholder="请输入用户名">
            </div>
            <div class="form-group">
                <label for="password">密码</label>
                <input type="password" id="password" name="password" required placeholder="请输入密码">
            </div>
            <div class="form-group">
                <label for="role">角色</label>
                <select id="role" name="role" required>
                    <option value="">请选择角色</option>
                    <option value="admin">管理员</option>
                    <option value="teacher">教师</option>
                    <option value="student">学生</option>
                </select>
            </div>
            <div class="form-checkbox">
                <input type="checkbox" id="remember" name="remember">
                <label for="remember">记住密码</label>
            </div>
            <div class="button-group">
                <button type="submit" class="login-btn" id="loginBtn">
                    <span id="btnText">登录</span>
                </button>
                <button type="button" onclick="window.location.href='/user/register'" class="register-btn">立即注册</button>
            </div>
            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>
        </form>
    </div>
    
    <script>
        function validateForm() {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value;
            const role = document.getElementById('role').value;
            
            if (!username) {
                alert('请输入用户名');
                document.getElementById('username').focus();
                return false;
            }
            
            if (!password) {
                alert('请输入密码');
                document.getElementById('password').focus();
                return false;
            }
            
            if (!role) {
                alert('请选择角色');
                document.getElementById('role').focus();
                return false;
            }
            
            // 显示加载状态
            const loginBtn = document.getElementById('loginBtn');
            const btnText = document.getElementById('btnText');
            loginBtn.disabled = true;
            btnText.innerHTML = '<span class="loading"></span>登录中...';
            
            return true;
        }
    </script>
</body>
</html>