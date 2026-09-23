<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>课程详情 - 智能课堂系统</title>
    <style>
        /* 复用list.jsp中的基础样式 */
        .course-detail {
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
            <h2>课程详情</h2>
            
            <div class="course-detail">
                <div class="detail-item">
                    <span class="detail-label">课程ID：</span>
                    <span>${course.id}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">课程名称：</span>
                    <span>${course.courseName}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">课程代码：</span>
                    <span>${course.courseCode}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">教师ID：</span>
                    <span>${course.teacherId}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">学分：</span>
                    <span>${course.credit}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">描述：</span>
                    <span>${course.description}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">状态：</span>
                    <span>
                        <c:choose>
                            <c:when test="${course.status eq 1}">正常</c:when>
                            <c:otherwise>禁用</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">创建时间：</span>
                    <span>${course.createTime}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">更新时间：</span>
                    <span>${course.updateTime}</span>
                </div>
            </div>
            
            <a href="/admin/course/list" class="back-button">返回课程列表</a>
        </div>
    </div>
</body>
</html>