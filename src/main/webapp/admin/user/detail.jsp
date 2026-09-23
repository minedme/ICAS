<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>用户详情 - 智能课堂系统</title>
    <style>
        /* 可以复用list.jsp中的样式，这里只添加必要的样式 */
        .user-detail {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
        }
        .detail-item {
            margin-bottom: 15px;
        }
        .detail-label {
            font-weight: bold;
            color: #333;
            display: inline-block;
            width: 100px;
        }
        .back-button {
            margin-top: 20px;
            padding: 8px 16px;
            background-color: #2196F3;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
        }
        .back-button:hover {
            background-color: #0b7dda;
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
            <h2>用户详情</h2>
            
            <div class="user-detail">
                <div class="detail-item">
                    <span class="detail-label">用户ID：</span>
                    <span>${user.id}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">用户名：</span>
                    <span>${user.username}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">真实姓名：</span>
                    <span>${user.realName}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">角色：</span>
                    <span>
                        <c:choose>
                            <c:when test="${user.role eq 'admin'}">管理员</c:when>
                            <c:when test="${user.role eq 'teacher'}">教师</c:when>
                            <c:when test="${user.role eq 'student'}">学生</c:when>
                        </c:choose>
                    </span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">手机号：</span>
                    <span>${user.phone}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">邮箱：</span>
                    <span>${user.email}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">创建时间：</span>
                    <span>${user.createTime}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">更新时间：</span>
                    <span>${user.updateTime}</span>
                </div>
            </div>
            
            <a href="/admin/user/list" class="back-button">返回用户列表</a>
        </div>
    </div>
</body>
</html>