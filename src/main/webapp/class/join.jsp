<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>加入班级 - 智能课堂系统</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }
        .header {
            background-color: #4CAF50;
            color: white;
            padding: 20px;
            text-align: center;
        }
        .header h1 {
            margin: 0;
            font-size: 24px;
        }
        .nav {
            background-color: #333;
            overflow: hidden;
        }
        .nav a {
            float: left;
            display: block;
            color: white;
            text-align: center;
            padding: 14px 16px;
            text-decoration: none;
        }
        .nav a:hover {
            background-color: #ddd;
            color: black;
        }
        .content {
            padding: 20px;
            max-width: 800px;
            margin: 0 auto;
        }
        .form-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .form-group input:focus {
            outline: none;
            border-color: #4CAF50;
        }
        .form-buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            text-align: center;
        }
        .btn-primary {
            background-color: #4CAF50;
            color: white;
        }
        .btn-secondary {
            background-color: #666;
            color: white;
        }
        .btn:hover {
            opacity: 0.8;
        }
        .error-message {
            background-color: #fee;
            color: #c33;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 20px;
            display: none;
        }
        .success-message {
            background-color: #e8f5e9;
            color: #4CAF50;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 20px;
            display: none;
        }
        .class-list {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .class-item {
            padding: 15px;
            border: 1px solid #eee;
            border-radius: 4px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .class-item:hover {
            background-color: #f9f9f9;
            border-color: #4CAF50;
        }
        .class-item h4 {
            margin: 0 0 10px 0;
            color: #333;
        }
        .class-item p {
            margin: 0;
            color: #666;
            font-size: 14px;
        }
        .class-item .meta {
            display: flex;
            gap: 15px;
            margin-top: 10px;
            font-size: 12px;
            color: #999;
        }
        .class-item .meta span {
            background-color: #f0f0f0;
            padding: 3px 8px;
            border-radius: 3px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>智能课堂考勤与学习行为分析系统</h1>
        <p>加入班级</p>
    </div>
    
    <div class="nav">
        <a href="/student/dashboard">控制面板</a>
        <a href="/student/profile">个人档案</a>
        <a href="/student/attendance/list">考勤记录</a>
        <a href="/student/quiz/list">测验</a>
        <a href="/user/logout" style="float: right;">退出登录</a>
    </div>
    
    <div class="content">
        <div id="errorMessage" class="error-message"></div>
        <div id="successMessage" class="success-message"></div>
        
        <div class="form-container">
            <div class="form-group">
                <label for="classCode">班级代码 *</label>
                <input type="text" id="classCode" name="classCode" placeholder="请输入班级代码" required>
            </div>
            
            <div class="form-buttons">
                <button type="button" class="btn btn-primary" onclick="joinClass()">加入班级</button>
                <a href="/student/dashboard" class="btn btn-secondary">返回</a>
            </div>
        </div>
        
        <div class="class-list">
            <h3>可用班级列表</h3>
            <c:forEach items="${classes}" var="classInfo">
                <div class="class-item" onclick="selectClass('${classInfo.classCode}')">
                    <h4>${classInfo.className} (${classInfo.classCode})</h4>
                    <p>${classInfo.description}</p>
                    <div class="meta">
                        <span>专业：${classInfo.major}</span>
                        <span>年级：${classInfo.grade}</span>
                        <span>班主任：${classInfo.teacherName}</span>
                        <span>学生人数：${classInfo.studentCount}</span>
                    </div>
                </div>
            </c:forEach>
            
            <c:if test="${empty classes}">
                <p>暂无可用班级</p>
            </c:if>
        </div>
    </div>
    
    <script>
        function selectClass(classCode) {
            document.getElementById('classCode').value = classCode;
        }
        
        function joinClass() {
            const classCode = document.getElementById('classCode').value.trim();
            
            if (!classCode) {
                showError('请输入班级代码');
                return;
            }
            
            fetch('/class/join', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'classCode=' + encodeURIComponent(classCode)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showSuccess(data.message);
                    setTimeout(() => {
                        window.location.href = '/student/dashboard';
                    }, 1500);
                } else {
                    showError(data.message);
                }
            })
            .catch(error => {
                showError('加入班级失败：' + error);
            });
        }
        
        function showError(message) {
            const errorDiv = document.getElementById('errorMessage');
            errorDiv.textContent = message;
            errorDiv.style.display = 'block';
            
            const successDiv = document.getElementById('successMessage');
            successDiv.style.display = 'none';
        }
        
        function showSuccess(message) {
            const successDiv = document.getElementById('successMessage');
            successDiv.textContent = message;
            successDiv.style.display = 'block';
            
            const errorDiv = document.getElementById('errorMessage');
            errorDiv.style.display = 'none';
        }
    </script>
</body>
</html>
