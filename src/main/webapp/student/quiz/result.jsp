<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>测验结果 - 智能课堂系统</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            color: #333;
            margin-bottom: 20px;
        }
        .score-summary {
            background-color: #e3f2fd;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            text-align: center;
        }
        .score-value {
            font-size: 48px;
            font-weight: bold;
            color: #1565c0;
            margin: 10px 0;
        }
        .score-label {
            font-size: 18px;
            color: #666;
        }
        .question {
            margin-bottom: 30px;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 8px;
        }
        .question-number {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        .question-content {
            font-size: 16px;
            margin-bottom: 15px;
            line-height: 1.5;
        }
        .answer-info {
            margin-top: 15px;
            padding: 10px;
            border-radius: 4px;
        }
        .answer-correct {
            background-color: #d4edda;
            border-left: 4px solid #28a745;
        }
        .answer-wrong {
            background-color: #f8d7da;
            border-left: 4px solid #dc3545;
        }
        .answer-label {
            font-weight: bold;
            margin-bottom: 5px;
        }
        .answer-text {
            margin-bottom: 5px;
        }
        .correct-answer {
            color: #28a745;
            font-weight: bold;
        }
        .wrong-answer {
            color: #dc3545;
            font-weight: bold;
        }
        button {
            padding: 10px 20px;
            background-color: #2196F3;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
        }
        button:hover {
            background-color: #1976d2;
        }
        .back-button {
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>测验结果</h2>
        
        <div class="score-summary">
            <div class="score-label">您的得分</div>
            <div class="score-value">${score}</div>
        </div>
        
        <c:if test="${not empty answers}">
            <c:forEach items="${answers}" var="answer" varStatus="status">
                <div class="question">
                    <div class="question-number">问题 ${status.index + 1}</div>
                    <div class="question-content">${answer.questionContent}</div>
                    
                    <c:set var="isCorrect" value="${answer.isCorrect == true}" />
                    <div class="answer-info ${isCorrect ? 'answer-correct' : 'answer-wrong'}">
                        <div class="answer-label">您的答案：</div>
                        <div class="answer-text ${isCorrect ? 'correct-answer' : 'wrong-answer'}">${answer.studentAnswer}</div>
                        <c:if test="${not isCorrect}">
                            <div class="answer-label">正确答案：</div>
                            <div class="answer-text correct-answer">${answer.correctAnswer}</div>
                        </c:if>
                        <div class="answer-label">得分：</div>
                        <div class="answer-text">${answer.score != null ? answer.score : 0}</div>
                    </div>
                </div>
            </c:forEach>
        </c:if>
        
        <c:if test="${empty answers}">
            <p style="text-align: center; color: #999; margin-top: 50px;">暂无答案记录</p>
        </c:if>
        
        <div class="back-button">
            <a href="/student/quiz/list" style="text-decoration: none;">
                <button>返回测验列表</button>
            </a>
        </div>
    </div>
</body>
</html>
