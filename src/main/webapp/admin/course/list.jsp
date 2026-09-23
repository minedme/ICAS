<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>课程管理 - 智能课堂系统</title>
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
            margin-bottom: 20px;
        }
        .section h2 {
            color: #333;
            margin-top: 0;
            margin-bottom: 20px;
        }
        .action-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .search-bar {
            display: flex;
            gap: 10px;
        }
        .search-bar input, .search-bar button {
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
        .btn-add {
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            text-decoration: none;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }
        .btn-add:hover {
            background-color: #45a049;
        }
        .course-table {
            width: 100%;
            border-collapse: collapse;
        }
        .course-table th, .course-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .course-table th {
            background-color: #f2f2f2;
            font-weight: bold;
            color: #333;
        }
        .course-table tr:hover {
            background-color: #f5f5f5;
        }
        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-active {
            background-color: #4CAF50;
            color: white;
        }
        .status-inactive {
            background-color: #f44336;
            color: white;
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
        <a href="/admin/dashboard">控制面板</a>
        <a href="/admin/user/list">用户管理</a>
        <a href="/admin/course/list" class="active">课程管理</a>
        <a href="/admin/analysis">系统分析</a>
        <a href="/user/logout" style="float: right;">退出登录</a>
    </div>
    
    <div class="content">
        <div class="section">
            <h2>课程管理</h2>
            
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
            
            <div class="action-bar">
                <form action="/admin/course/list" method="get" class="search-bar">
                    <input type="text" placeholder="课程名称" name="courseName">
                    <input type="text" placeholder="课程代码" name="courseCode">
                    <button type="submit">搜索</button>
                </form>
                <a href="/admin/course/add" class="btn-add">添加课程</a>
            </div>
            
            <table class="course-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>课程名称</th>
                        <th>课程代码</th>
                        <th>教师ID</th>
                        <th>学分</th>
                        <th>状态</th>
                        <th>创建时间</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${courses}" var="course">
                        <tr>
                            <td>${course.id}</td>
                            <td>${course.courseName}</td>
                            <td>${course.courseCode}</td>
                            <td>${course.teacherId}</td>
                            <td>${course.credit}</td>
                            <td>
                                <span class="status-badge status-${course.status eq 1 ? 'active' : 'inactive'}">
                                    <c:choose>
                                        <c:when test="${course.status eq 1}">正常</c:when>
                                        <c:otherwise>禁用</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td>${course.createTime}</td>
                            <td>
                                <div class="action-buttons">
                                    <a href="/admin/course/detail/${course.id}" class="btn btn-view">查看</a>
                                    <a href="/admin/course/edit/${course.id}" class="btn btn-edit">编辑</a>
                                    <a href="/admin/course/delete/${course.id}" class="btn btn-delete" onclick="return confirm('确定要删除该课程吗？');">删除</a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <div class="pagination">
                <a href="#">上一页</a>
                <a href="#" class="active">1</a>
                <a href="#">2</a>
                <a href="#">3</a>
                <a href="#">下一页</a>
            </div>
        </div>
    </div>
</body>
</html>