<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>系统分析 - 智能课堂系统</title>
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
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        .stat-card {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
            border-left: 5px solid #2196F3;
        }
        .stat-label {
            font-weight: bold;
            color: #666;
            margin-bottom: 10px;
            font-size: 16px;
        }
        .stat-value {
            font-size: 36px;
            color: #333;
            font-weight: bold;
        }
        .chart-container {
            height: 400px;
            margin-top: 20px;
        }
        .table-container {
            margin-top: 20px;
            overflow-x: auto;
        }
        .data-table {
            width: 100%;
            border-collapse: collapse;
        }
        .data-table th,
        .data-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .data-table th {
            background-color: #f2f2f2;
            font-weight: bold;
            color: #333;
        }
        .data-table tr:hover {
            background-color: #f5f5f5;
        }
        .warning-highlight {
            background-color: #fff3cd;
            border-left: 5px solid #ffc107;
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
        <a href="/admin/analysis" class="active">系统分析</a>
        <a href="/user/logout" style="float: right;">退出登录</a>
    </div>
    
    <div class="content">
        <div class="section">
            <h2>系统分析</h2>
            
            <!-- 统计概览 -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-label">总考勤次数</div>
                    <div class="stat-value">${attendanceStats.totalSignIns}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">平均考勤率</div>
                    <div class="stat-value">${attendanceStats.averageAttendanceRate}%</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">总测试次数</div>
                    <div class="stat-value">${scoreStats.totalQuizzes}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">平均成绩</div>
                    <div class="stat-value">${scoreStats.averageScore}</div>
                </div>
            </div>
        </div>
        
        <!-- 缺勤预警学生 -->
        <div class="section">
            <h2>缺勤预警学生</h2>
            <div class="table-container">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>学生ID</th>
                            <th>姓名</th>
                            <th>班级</th>
                            <th>缺勤次数</th>
                            <th>出勤率</th>
                            <th>预警等级</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${warningStudents}" var="student">
                            <tr class="warning-highlight">
                                <td>${student.studentId}</td>
                                <td>${student.studentName}</td>
                                <td>${student.className}</td>
                                <td>${student.absentCount}</td>
                                <td>${student.attendanceRate}%</td>
                                <td>${student.warningLevel}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>