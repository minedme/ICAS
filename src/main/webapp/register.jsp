<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>智能课堂考勤与学习行为分析系统 - 注册</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .register-container {
            background-color: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            width: 350px;
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            color: #555;
        }
        input[type="text"], input[type="password"], input[type="email"], select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        button {
            width: 100%;
            padding: 12px;
            background-color: #2196F3;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover {
            background-color: #0b7dda;
        }
        .error {
            color: red;
            text-align: center;
            margin-top: 15px;
        }
        .success {
            color: green;
            text-align: center;
            margin-top: 15px;
        }
        .login-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
        }
        .login-link a {
            color: #2196F3;
            text-decoration: none;
        }
        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h2>智能课堂系统 - 注册</h2>
        <form action="/user/register" method="post">
            <div class="form-group">
                <label for="username">用户名</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="password">密码</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div class="form-group">
                <label for="realName">真实姓名</label>
                <input type="text" id="realName" name="realName" required>
            </div>
            <div class="form-group">
                <label for="role">角色</label>
                <select id="role" name="role" required>
                    <option value="teacher">教师</option>
                    <option value="student">学生</option>
                </select>
            </div>
            <div class="form-group">
                <label for="phone">手机号</label>
                <input type="text" id="phone" name="phone">
            </div>
            <div class="form-group">
                <label for="email">邮箱</label>
                <input type="email" id="email" name="email">
            </div>
            <button type="submit">注册</button>
            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="success">${success}</div>
            </c:if>
            <div class="login-link">
                已有账号？<a href="/login.jsp">登录</a>
            </div>
        </form>
    </div>
</body>
</html>