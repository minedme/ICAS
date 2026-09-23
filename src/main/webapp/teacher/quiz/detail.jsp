<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>测验详情 - 智能课堂系统</title>
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
        .nav a.logout {
            float: right;
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
        .quiz-info {
            margin-bottom: 30px;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 8px;
        }
        .info-item {
            margin-bottom: 10px;
        }
        .info-label {
            font-weight: bold;
            color: #333;
            display: inline-block;
            width: 100px;
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
        .questions-section {
            margin-top: 30px;
        }
        .question {
            background-color: #f0f0f0;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #eee;
        }
        .question h4 {
            margin-top: 0;
            color: #333;
        }
        .options {
            margin-top: 10px;
        }
        .option {
            margin-bottom: 10px;
        }
        .correct-answer {
            color: #4CAF50;
            font-weight: bold;
            margin-top: 10px;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
            margin-right: 10px;
        }
        .btn-edit {
            background-color: #ff9800;
            color: white;
        }
        .btn-back {
            background-color: #6c757d;
            color: white;
        }
        .btn:hover {
            opacity: 0.8;
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
        <a href="/user/logout" class="logout">退出登录</a>
    </div>
    
    <div class="content">
        <div class="section">
            <h2>测验详情</h2>
            
            <div class="quiz-info">
                <div class="info-item">
                    <span class="info-label">测验标题：</span>
                    <span>${quiz.title}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">课程名称：</span>
                    <span>${quiz.courseName}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">开始时间：</span>
                    <span>${quiz.startTime}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">结束时间：</span>
                    <span>${quiz.endTime}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">状态：</span>
                    <span class="status-badge status-${quiz.status eq 1 ? 'active' : (quiz.status eq 0 ? 'pending' : 'ended')}">
                        ${quiz.status eq 1 ? '进行中' : (quiz.status eq 0 ? '未开始' : '已结束')}
                    </span>
                </div>
            </div>
            
            <div class="questions-section">
                <h3>测验问题</h3>
                <c:forEach items="${quiz.questions}" var="question" varStatus="status">
                    <div class="question">
                        <h4>问题 ${status.index + 1} (${question.type eq 'radio' ? '单选题' : (question.type eq 'checkbox' ? '多选题' : '判断题')})</h4>
                        <div class="info-item">
                            <span class="info-label">问题内容：</span>
                            <span>${question.content}</span>
                        </div>
                        <div class="options">
                            <c:if test="not empty question.optionA">
                                <div class="option">A. ${question.optionA}</div>
                            </c:if>
                            <c:if test="not empty question.optionB">
                                <div class="option">B. ${question.optionB}</div>
                            </c:if>
                            <c:if test="not empty question.optionC">
                                <div class="option">C. ${question.optionC}</div>
                            </c:if>
                            <c:if test="not empty question.optionD">
                                <div class="option">D. ${question.optionD}</div>
                            </c:if>
                        </div>
                        <div class="correct-answer">
                            <span class="info-label">正确答案：</span>
                            <span>${question.correctAnswer}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">分值：</span>
                            <span>${question.score}分</span>
                        </div>
                    </div>
                </c:forEach>
            </div>
            
            <div style="margin-top: 30px;">
                <a href="/teacher/quiz/list" class="btn btn-back">返回列表</a>
            </div>
        </div>
    </div>
</body>
</html>