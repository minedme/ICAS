<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>编辑用户 - 智能课堂系统</title>
    <style>
        /* 可以复用list.jsp中的样式，这里只添加必要的样式 */
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
            <h2>编辑用户</h2>
            
            <form class="edit-form" action="/admin/user/update" method="post">
                <input type="hidden" name="id" value="${user.id}">
                
                <div class="form-item">
                    <label class="form-label">用户名：</label>
                    <input type="text" class="form-input" name="username" value="${user.username}" readonly>
                </div>
                
                <input type="hidden" name="password" value="${user.password}">
                
                <div class="form-item">
                    <label class="form-label">真实姓名：</label>
                    <input type="text" class="form-input" name="realName" value="${user.realName}">
                </div>
                
                <div class="form-item">
                    <label class="form-label">角色：</label>
                    <select class="form-select" name="role">
                        <option value="admin" <c:if test="${user.role eq 'admin'}">selected</c:if>>管理员</option>
                        <option value="teacher" <c:if test="${user.role eq 'teacher'}">selected</c:if>>教师</option>
                        <option value="student" <c:if test="${user.role eq 'student'}">selected</c:if>>学生</option>
                    </select>
                </div>
                
                <div class="form-item">
                    <label class="form-label">手机号：</label>
                    <input type="text" class="form-input" name="phone" value="${user.phone}">
                </div>
                
                <div class="form-item">
                    <label class="form-label">邮箱：</label>
                    <input type="email" class="form-input" name="email" value="${user.email}">
                </div>
                
                <div class="form-item">
                    <label class="form-label">状态：</label>
                    <select class="form-select" name="status">
                        <option value="1" <c:if test="${user.status eq 1}">selected</c:if>>启用</option>
                        <option value="0" <c:if test="${user.status eq 0}">selected</c:if>>禁用</option>
                    </select>
                </div>
                
                <div class="form-item">
                    <button type="submit" class="form-button">保存</button>
                    <a href="/admin/user/list" class="back-button">返回</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>