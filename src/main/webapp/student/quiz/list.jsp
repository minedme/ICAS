<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>我的测验 - 智能课堂系统</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
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
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: bold;
            display: inline-block;
        }
        .status-active {
            background-color: #4CAF50;
            color: white;
        }
        .status-pending {
            background-color: #ff9800;
            color: white;
        }
        .status-ended {
            background-color: #f44336;
            color: white;
        }
        .action-links a {
            margin-right: 10px;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 4px;
            font-size: 14px;
            display: inline-block;
        }
        .action-take {
            background-color: #2196F3;
            color: white;
        }
        .action-view {
            background-color: #4CAF50;
            color: white;
        }
        .score {
            font-weight: bold;
            color: #4CAF50;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>可用测验</h2>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>测验标题</th>
                    <th>课程名称</th>
                    <th>开始时间</th>
                    <th>结束时间</th>
                    <th>状态</th>
                    <th>我的得分</th>
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
                            <span class="status status-${quiz.status eq 1 ? 'active' : (quiz.status eq 0 ? 'pending' : 'ended')}">
                                ${quiz.status eq 1 ? '进行中' : (quiz.status eq 0 ? '未开始' : '已结束')}
                            </span>
                        </td>
                        <td>
                            <c:if test="${not empty quiz.myScore}">
                                <span class="score">${quiz.myScore}</span>
                            </c:if>
                            <c:if test="${empty quiz.myScore}">
                                -</c:if>
                        </td>
                        <td class="action-links">
                            <c:if test="${quiz.status eq 1 and empty quiz.myScore}">
                                <a href="/student/quiz/participate/${quiz.id}" class="action-take">参加测验</a>
                            </c:if>
                            <c:if test="${quiz.status eq 0}">
                                -</c:if>
                            <c:if test="${quiz.status eq 2 or not empty quiz.myScore}">
                                <a href="/student/quiz/result/${quiz.id}" class="action-view">查看结果</a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <c:if test="${empty quizzes}">
            <p style="text-align: center; color: #999; margin-top: 50px;">暂无测验记录</p>
        </c:if>
    </div>
</body>
</html>
