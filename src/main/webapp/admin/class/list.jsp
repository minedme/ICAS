<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>班级管理 - 智能课堂系统</title>
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
        .content {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .search-box {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .search-box form {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .search-box input {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            flex: 1;
            min-width: 200px;
        }
        .search-box button {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .search-box button:hover {
            background-color: #45a049;
        }
        .table-container {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .action-buttons {
            display: flex;
            gap: 5px;
        }
        .btn {
            padding: 5px 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            color: white;
            font-size: 12px;
        }
        .btn-primary {
            background-color: #4CAF50;
        }
        .btn-warning {
            background-color: #ff9800;
        }
        .btn-danger {
            background-color: #f44336;
        }
        .btn:hover {
            opacity: 0.8;
        }
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
            gap: 5px;
        }
        .pagination a, .pagination span {
            padding: 10px 15px;
            text-decoration: none;
            color: #333;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .pagination a:hover {
            background-color: #4CAF50;
            color: white;
        }
        .pagination .current {
            background-color: #4CAF50;
            color: white;
        }
        .add-btn {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-bottom: 20px;
        }
        .add-btn:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>智能课堂考勤与学习行为分析系统</h1>
        <p>班级管理</p>
    </div>
    
    <div class="nav">
        <a href="/admin/dashboard">控制面板</a>
        <a href="/admin/user/list">用户管理</a>
        <a href="/admin/class/list">班级管理</a>
        <a href="/admin/course/list">课程管理</a>
        <a href="/admin/analysis">数据分析</a>
        <a href="/user/logout" style="float: right;">退出登录</a>
    </div>
    
    <div class="content">
        <button class="add-btn" onclick="window.location.href='/admin/class/create'">+ 创建班级</button>
        
        <div class="search-box">
            <form action="/admin/class/list" method="get">
                <input type="text" name="className" placeholder="班级名称" value="${className}">
                <input type="text" name="classCode" placeholder="班级代码" value="${classCode}">
                <input type="text" name="major" placeholder="专业" value="${major}">
                <button type="submit">搜索</button>
            </form>
        </div>
        
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>班级名称</th>
                        <th>班级代码</th>
                        <th>专业</th>
                        <th>年级</th>
                        <th>班主任</th>
                        <th>学生人数</th>
                        <th>状态</th>
                        <th>创建时间</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${classes}" var="classInfo">
                        <tr>
                            <td>${classInfo.id}</td>
                            <td>${classInfo.className}</td>
                            <td>${classInfo.classCode}</td>
                            <td>${classInfo.major}</td>
                            <td>${classInfo.grade}</td>
                            <td>${classInfo.teacherName}</td>
                            <td>${classInfo.studentCount}</td>
                            <td>${classInfo.status == 1 ? '正常' : '禁用'}</td>
                            <td>${classInfo.createTime}</td>
                            <td>
                                <div class="action-buttons">
                                    <a href="/admin/class/edit/${classInfo.id}" class="btn btn-primary">编辑</a>
                                    <button class="btn btn-danger" onclick="deleteClass(${classInfo.id})">删除</button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <div class="pagination">
                <c:if test="${currentPage > 1}">
                    <a href="/admin/class/list?page=${currentPage - 1}&className=${className}&classCode=${classCode}&major=${major}">上一页</a>
                </c:if>
                <c:forEach begin="1" end="${totalPages}" var="page">
                    <c:if test="${page == currentPage}">
                        <span class="current">${page}</span>
                    </c:if>
                    <c:if test="${page != currentPage}">
                        <a href="/admin/class/list?page=${page}&className=${className}&classCode=${classCode}&major=${major}">${page}</a>
                    </c:if>
                </c:forEach>
                <c:if test="${currentPage < totalPages}">
                    <a href="/admin/class/list?page=${currentPage + 1}&className=${className}&classCode=${classCode}&major=${major}">下一页</a>
                </c:if>
            </div>
        </div>
    </div>
    
    <script>
        function deleteClass(id) {
            if (confirm('确定要删除这个班级吗？')) {
                fetch('/admin/class/delete/' + id, {
                    method: 'POST'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message);
                        window.location.reload();
                    } else {
                        alert(data.message);
                    }
                })
                .catch(error => {
                    alert('删除失败：' + error);
                });
            }
        }
    </script>
</body>
</html>
