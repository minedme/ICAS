<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>我的测验 - 智能课堂系统</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }
        .header {
            background-color: #2196F3;
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
            max-width: 1200px;
            margin: 0 auto;
        }
        .section {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .section h2 {
            color: #333;
            margin-top: 0;
            margin-bottom: 20px;
        }
        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .btn-add {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
        }
        .btn-add:hover {
            background-color: #45a049;
        }
        .quiz-table {
            width: 100%;
            border-collapse: collapse;
        }
        .quiz-table th, .quiz-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .quiz-table th {
            background-color: #f2f2f2;
            font-weight: bold;
            color: #333;
        }
        .quiz-table tr:hover {
            background-color: #f5f5f5;
        }
        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-active {
            background-color: #4caf50;
            color: white;
        }
        .status-pending {
            background-color: #ffeb3b;
            color: #333;
        }
        .status-ended {
            background-color: #f44336;
            color: white;
        }
        .search-bar {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
        }
        .search-bar input, .search-bar select, .search-bar button {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .search-bar button {
            background-color: #2196F3;
            color: white;
            border: none;
            cursor: pointer;
        }
        .search-bar button:hover {
            background-color: #0b7dda;
        }
        .action-buttons {
            display: flex;
            gap: 5px;
        }
        .btn {
            padding: 5px 10px;
            border: none;
            border-radius: 4px;
            font-size: 12px;
            cursor: pointer;
            text-decoration: none;
        }
        .btn-view {
            background-color: #2196f3;
            color: white;
        }
        .btn-edit {
            background-color: #ff9800;
            color: white;
        }
        .btn-delete {
            background-color: #f44336;
            color: white;
        }
        .btn:hover {
            opacity: 0.8;
        }
        .pagination {
            margin-top: 20px;
            text-align: center;
        }
        .pagination a {
            padding: 8px 12px;
            margin: 0 4px;
            border: 1px solid #ddd;
            text-decoration: none;
            color: #2196f3;
            border-radius: 4px;
        }
        .pagination a:hover, .pagination a.active {
            background-color: #2196f3;
            color: white;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>智能课堂考勤与学习行为分析系统</h1>
    </div>
    
    <div class="nav">
        <a href="/teacher/dashboard">控制面板</a>
        <a href="/teacher/class">班级管理</a>
        <a href="/teacher/quiz/list" class="active">测验管理</a>
        <a href="/teacher/attendance/list">考勤管理</a>
        <a href="/user/logout" style="float: right;">退出登录</a>
    </div>
    
    <div class="content">
        <div class="section">
            <div class="header-section">
                <h2>我的测验</h2>
                <a href="/teacher/quiz/create" class="btn-add">创建测验</a>
            </div>
            
            <form action="/teacher/quiz/list" method="get" class="search-bar">
                <input type="text" placeholder="测验标题" name="title">
                <input type="text" placeholder="课程名称" name="courseName">
                <select name="status">
                    <option value="">所有状态</option>
                    <option value="0">未开始</option>
                    <option value="1">进行中</option>
                    <option value="2">已结束</option>
                </select>
                <button type="submit">搜索</button>
            </form>
            
            <c:if test="${not empty successMessage}">
                <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 4px; margin-bottom: 20px;">
                    ${successMessage}
                </div>
            </c:if>
            
            <c:if test="${not empty errorMessage}">
                <div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 4px; margin-bottom: 20px;">
                    ${errorMessage}
                </div>
            </c:if>
            
            <table class="quiz-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>测验标题</th>
                        <th>课程名称</th>
                        <th>开始时间</th>
                        <th>结束时间</th>
                        <th>状态</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${quizzes}" var="quiz">
                        <tr>
                            <td>${quiz.id}</td>
                            <td>${quiz.title}</td>
                            <td>${quiz.courseName}</td>
                            <td>${quiz.startTime}</td>
                            <td>${quiz.endTime}</td>
                            <td>
                                <span class="status-badge status-${quiz.status eq 1 ? 'active' : (quiz.status eq 0 ? 'pending' : 'ended')}">
                                    ${quiz.status eq 1 ? '进行中' : (quiz.status eq 0 ? '未开始' : '已结束')}
                                </span>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <a href="/teacher/quiz/detail/${quiz.id}" class="btn btn-view">查看</a>
                                    <a href="/teacher/quiz/delete/${quiz.id}" class="btn btn-delete" onclick="return confirm('确定要删除该测验吗？')">删除</a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <c:if test="${empty quizzes}">
                <p style="text-align: center; color: #999; margin-top: 50px;">暂无测验记录</p>
            </c:if>
        </div>
    </div>
</body>
</html>
