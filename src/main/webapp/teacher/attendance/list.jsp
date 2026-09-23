<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>考勤管理 - 智能课堂系统</title>
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
        .nav a.active {
            background-color: #4CAF50;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            color: #333;
            margin-bottom: 30px;
        }
        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        button {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
        }
        button:hover {
            background-color: #45a049;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
            font-weight: bold;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .status {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-active {
            background-color: #4CAF50;
            color: white;
        }
        .status-ended {
            background-color: #f44336;
            color: white;
        }
        .action-links a {
            margin-right: 10px;
            text-decoration: none;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 14px;
        }
        .action-start {
            background-color: #2196F3;
            color: white;
        }
        .action-end {
            background-color: #f44336;
            color: white;
        }
        .action-view {
            background-color: #4CAF50;
            color: white;
        }
        .action-qrcode {
            background-color: #ff9800;
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
        <a href="/class/join">加入班级</a>
        <a href="/teacher/quiz/list">测验管理</a>
        <a href="/teacher/attendance/list" class="active">考勤管理</a>
        <a href="/user/logout" style="float: right;">退出登录</a>
    </div>
    
    <div class="container">
        <div class="header">
            <h2>考勤管理</h2>
            <a href="/teacher/attendance/create" class="button">创建新考勤</a>
        </div>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>课程名称</th>
                    <th>开始时间</th>
                    <th>结束时间</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${attendances}" var="attendance">
                    <tr>
                        <td>${attendance.id}</td>
                        <td>${attendance.courseName}</td>
                        <td>${attendance.startTime}</td>
                        <td>${attendance.endTime}</td>
                        <td>
                            <span class="status status-${attendance.status eq 1 ? 'active' : 'ended'}">
                                ${attendance.status eq 1 ? '进行中' : '已结束'}
                            </span>
                        </td>
                        <td class="action-links">
                            <a href="/teacher/attendance/detail/${attendance.id}" class="action-view">查看记录</a>
                            <c:if test="${attendance.status eq 1}">
                                <a href="/teacher/attendance/qrCode/${attendance.id}" class="action-qrcode">查看二维码</a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <c:if test="${empty attendances}">
            <p style="text-align: center; color: #999; margin-top: 50px;">暂无考勤记录</p>
        </c:if>
    </div>
</body>
</html>
