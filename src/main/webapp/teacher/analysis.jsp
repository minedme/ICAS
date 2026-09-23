<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>数据分析 - 智能课堂系统</title>
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
            margin-bottom: 30px;
        }
        .section h2 {
            color: #333;
            margin-top: 0;
            margin-bottom: 20px;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            border: 1px solid #eee;
        }
        .stat-value {
            font-size: 32px;
            font-weight: bold;
            color: #4CAF50;
            margin: 10px 0;
        }
        .stat-label {
            color: #666;
            font-size: 14px;
        }
        .chart-container {
            height: 400px;
            margin: 20px 0;
        }
        .table-container {
            overflow-x: auto;
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
        .warning { background-color: #ffebee; color: #c62828; }
        .good { background-color: #e8f5e9; color: #2e7d32; }
        .average { background-color: #fff3e0; color: #ef6c00; }
    </style>
</head>
<body>
    <div class="header">
        <h1>智能课堂考勤与学习行为分析系统</h1>
        <p>欢迎您，${user.realName} 老师</p>
    </div>
    
    <div class="nav">
        <a href="/teacher/dashboard">控制面板</a>
        <a href="/teacher/class">班级管理</a>
        <a href="/teacher/attendance/list">考勤管理</a>
        <a href="/teacher/quiz/list">测验管理</a>
        <a href="/teacher/analysis" class="active">数据分析</a>
        <a href="/user/logout" style="float: right;">退出登录</a>
    </div>
    
    <div class="content">
        <!-- 总体统计 -->
        <div class="section">
            <h2>总体统计概览</h2>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-value">${attendanceStats.averageAttendanceRate}%</div>
                    <div class="stat-label">总体出勤率</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">${scoreStats.averageScore}</div>
                    <div class="stat-label">平均测验得分</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">${attendanceStats.totalSignIns}</div>
                    <div class="stat-label">总考勤记录</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">${scoreStats.totalQuizzes}</div>
                    <div class="stat-label">总测验次数</div>
                </div>
            </div>
        </div>
        
        <!-- 考勤统计 -->
        <div class="section">
            <h2>考勤统计分析</h2>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-value">${attendanceStats.normalCount}</div>
                    <div class="stat-label">正常考勤</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">${attendanceStats.absentCount}</div>
                    <div class="stat-label">缺勤记录</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">${attendanceStats.lateCount}</div>
                    <div class="stat-label">迟到记录</div>
                </div>
            </div>
            
            <h3>课程签到分布</h3>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>课程名称</th>
                            <th>签到人数</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${classSignInDistribution}" var="entry">
                            <tr>
                                <td>${entry.key}</td>
                                <td>${entry.value}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        
        <!-- 测验统计 -->
        <div class="section">
            <h2>测验统计分析</h2>
            <div class="stats-grid">

                <div class="stat-card">
                    <div class="stat-value">${scoreStats.averageScore}</div>
                    <div class="stat-label">平均分</div>
                </div>
            </div>
        </div>
        
        <!-- 学生预警 -->
        <div class="section">
            <h2>学生预警</h2>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>学生ID</th>
                            <th>学生姓名</th>
                            <th>连续缺勤次数</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${absentWarningStudents}" var="warning">
                            <tr class="warning">
                                <td>${warning.studentId}</td>
                                <td>${warning.studentName}</td>
                                <td>${warning.absentCount}</td>
                                <td><a href="/teacher/student/detail?id=${warning.studentId}">查看详情</a></td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty absentWarningStudents}">
                            <tr>
                                <td colspan="4" style="text-align: center; color: #666;">无预警学生</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <script>
        // 可以在这里添加图表绘制代码，例如使用Chart.js
    </script>
</body>
</html>
