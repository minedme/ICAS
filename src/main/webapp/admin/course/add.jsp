<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>添加课程 - 智能课堂系统</title>
    <style>
        /* 复用list.jsp中的基础样式 */
        .edit-form {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
        }
        .form-item {
            margin-bottom: 15px;
        }
        .form-label {
            font-weight: bold;
            color: #333;
            display: inline-block;
            width: 100px;
        }
        .form-input {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 300px;
        }
        .form-textarea {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 300px;
            height: 100px;
            resize: vertical;
        }
        .form-select {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 320px;
        }
        .form-button {
            padding: 8px 16px;
            background-color: #2196F3;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
        }
        .form-button:hover {
            background-color: #0b7dda;
        }
        .back-button {
            padding: 8px 16px;
            background-color: #6c757d;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
        }
        .back-button:hover {
            background-color: #545b62;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>智能课堂考勤与学习行为分析系统</h1>
    </div>
    
    <div class="nav">
        <a href="/admin/dashboard">控制面板</a>
        <a href="/admin/user/list">用户管理</a>
        <a href="/admin/course/list">课程管理</a>
        <a href="/admin/analysis">系统分析</a>
        <a href="/user/logout" style="float: right;">退出登录</a>
    </div>
    
    <div class="content">
        <div class="section">
            <h2>添加课程</h2>
            
            <form class="edit-form" action="/admin/course/add" method="post">
                <div class="form-item">
                    <label class="form-label">课程名称：</label>
                    <input type="text" class="form-input" name="courseName" required>
                </div>
                
                <div class="form-item">
                    <label class="form-label">课程代码：</label>
                    <input type="text" class="form-input" name="courseCode" required>
                </div>
                
                <div class="form-item">
                    <label class="form-label">教师ID：</label>
                    <input type="text" class="form-input" name="teacherId" required>
                </div>
                
                <div class="form-item">
                    <label class="form-label">学分：</label>
                    <input type="number" class="form-input" name="credit" min="0" max="10" step="0.5" required>
                </div>
                
                <div class="form-item">
                    <label class="form-label">描述：</label>
                    <textarea class="form-textarea" name="description"></textarea>
                </div>
                
                <div class="form-item">
                    <label class="form-label">状态：</label>
                    <select class="form-select" name="status">
                        <option value="1" selected>正常</option>
                        <option value="0">禁用</option>
                    </select>
                </div>
                
                <div class="form-item">
                    <button type="submit" class="form-button">保存</button>
                    <a href="/admin/course/list" class="back-button">返回</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>