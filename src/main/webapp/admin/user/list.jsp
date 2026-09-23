<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>用户管理 - 智能课堂系统</title>
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
        .user-table {
            width: 100%;
            border-collapse: collapse;
        }
        .user-table th, .user-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .user-table th {
            background-color: #f2f2f2;
            font-weight: bold;
            color: #333;
        }
        .user-table tr:hover {
            background-color: #f5f5f5;
        }
        .role-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .role-admin {
            background-color: #ffeb3b;
            color: #333;
        }
        .role-teacher {
            background-color: #4caf50;
            color: white;
        }
        .role-student {
            background-color: #2196f3;
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
        <a href="/admin/user/list" class="active">用户管理</a>
        <a href="/admin/course/list">课程管理</a>
        <a href="/admin/analysis">系统分析</a>
        <a href="/user/logout" style="float: right;">退出登录</a>
    </div>
    
    <div class="content">
        <div class="section">
            <h2>用户管理</h2>
            
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
            
            <form action="/admin/user/list" method="get" class="search-bar">
                <input type="text" placeholder="用户名" name="username">
                <select name="role">
                    <option value="">所有角色</option>
                    <option value="admin">管理员</option>
                    <option value="teacher">教师</option>
                    <option value="student">学生</option>
                </select>
                <button type="submit">搜索</button>
            </form>
            
            <table class="user-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>用户名</th>
                        <th>真实姓名</th>
                        <th>角色</th>
                        <th>手机号</th>
                        <th>邮箱</th>
                        <th>创建时间</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${users}" var="user">
                        <tr>
                            <td>${user.id}</td>
                            <td>${user.username}</td>
                            <td>${user.realName}</td>
                            <td>
                                <span class="role-badge role-${user.role}">
                                    <c:choose>
                                        <c:when test="${user.role eq 'admin'}">管理员</c:when>
                                        <c:when test="${user.role eq 'teacher'}">教师</c:when>
                                        <c:when test="${user.role eq 'student'}">学生</c:when>
                                    </c:choose>
                                </span>
                            </td>
                            <td>${user.phone}</td>
                            <td>${user.email}</td>
                            <td>${user.createTime}</td>
                            <td>
                                <div class="action-buttons">
                                    <a href="/admin/user/detail/${user.id}" class="btn btn-view">查看</a>
                                    <a href="/admin/user/edit/${user.id}" class="btn btn-edit">编辑</a>
                                    <a href="/admin/user/delete/${user.id}" class="btn btn-delete" onclick="return confirm('确定要删除该用户吗？');">删除</a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <div class="pagination">
                <c:if test="${currentPage > 1}">
                    <a href="/admin/user/list?page=${currentPage - 1}&username=${not empty username ? username : ''}&role=${not empty role ? role : ''}">上一页</a>
                </c:if>
                <c:forEach begin="1" end="${totalPages}" var="pageNum">
                    <c:choose>
                        <c:when test="${pageNum == currentPage}">
                            <a href="/admin/user/list?page=${pageNum}&username=${not empty username ? username : ''}&role=${not empty role ? role : ''}" class="active">${pageNum}</a>
                        </c:when>
                        <c:otherwise>
                            <a href="/admin/user/list?page=${pageNum}&username=${not empty username ? username : ''}&role=${not empty role ? role : ''}">${pageNum}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                <c:if test="${currentPage < totalPages}">
                    <a href="/admin/user/list?page=${currentPage + 1}&username=${not empty username ? username : ''}&role=${not empty role ? role : ''}">下一页</a>
                </c:if>
            </div>
        </div>
    </div>
</body>
</html>