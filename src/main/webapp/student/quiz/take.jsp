<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>参加测验 - 智能课堂系统</title>
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
        .quiz-info {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        .info-item {
            margin-bottom: 5px;
            font-size: 14px;
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
        .options {
            margin-top: 15px;
        }
        .option {
            margin-bottom: 10px;
            font-size: 15px;
        }
        .option input {
            margin-right: 10px;
        }
        button {
            width: 100%;
            padding: 15px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 18px;
            font-weight: bold;
            margin-top: 20px;
        }
        button:hover {
            background-color: #45a049;
        }
        .timer {
            text-align: center;
            background-color: #ff9800;
            color: white;
            padding: 10px;
            border-radius: 4px;
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 30px;
        }
        .instructions {
            background-color: #e3f2fd;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #2196f3;
        }
        .instructions h3 {
            margin-top: 0;
            color: #1565c0;
        }
        .instructions p {
            margin: 5px 0;
            color: #333;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
        }
        .action-buttons button {
            flex: 1;
        }
        .btn-primary {
            background-color: #4CAF50;
        }
        .btn-primary:hover {
            background-color: #45a049;
        }
        .btn-secondary {
            background-color: #2196f3;
        }
        .btn-secondary:hover {
            background-color: #1976d2;
        }
        .submitted-info {
            background-color: #fff3cd;
            padding: 10px 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            border-left: 4px solid #ffc107;
        }
    </style>
    <script>
        var timerInterval;

        // 倒计时功能
        function startTimer(duration, display) {
            var timer = duration, minutes, seconds;
            
            // 清除之前的计时器
            if (timerInterval) {
                clearInterval(timerInterval);
            }
            
            timerInterval = setInterval(function () {
                minutes = parseInt(timer / 60, 10);
                seconds = parseInt(timer % 60, 10);

                minutes = minutes < 10 ? "0" + minutes : minutes;
                seconds = seconds < 10 ? "0" + seconds : seconds;

                display.textContent = minutes + ":" + seconds;

                if (--timer < 0) {
                    clearInterval(timerInterval);
                    // 时间结束，自动提交
                    display.textContent = "00:00";
                    alert("测验时间已到，系统将自动提交您的答案！");
                    // 处理复选框答案后提交
                    handleCheckboxAnswers();
                    document.getElementById('quiz-form').submit();
                }
            }, 1000);
        }

        // 处理复选框答案
        function handleCheckboxAnswers() {
            var checkboxes = document.querySelectorAll('input[type="checkbox"]');
            var answerMap = {};
            
            checkboxes.forEach(function(checkbox) {
                var name = checkbox.name;
                var match = name.match(/answers\[(\d+)\]\.studentAnswer/);
                if (match) {
                    var index = match[1];
                    var value = checkbox.value;
                    
                    if (checkbox.checked) {
                        if (!answerMap[index]) {
                            answerMap[index] = "";
                        }
                        answerMap[index] += value;
                    }
                }
            });
            
            // 将拼接后的答案设置到对应的input
            for (var index in answerMap) {
                var inputs = document.querySelectorAll('input[name="answers[' + index + '].studentAnswer"]');
                if (inputs.length > 0) {
                    inputs[0].value = answerMap[index];
                }
            }
            
            // 处理未选中的复选框
            var allQuestions = document.querySelectorAll('.question');
            allQuestions.forEach(function(question, index) {
                var hasCheckbox = question.querySelector('input[type="checkbox"]');
                if (hasCheckbox) {
                    var inputs = document.querySelectorAll('input[name="answers[' + index + '].studentAnswer"]');
                    if (inputs.length > 0 && inputs[0].value === "") {
                        inputs[0].value = "";
                    }
                }
            });
        }

        // 表单提交前处理复选框答案
        document.addEventListener('DOMContentLoaded', function() {
            var form = document.getElementById('quiz-form');
            if (form) {
                form.addEventListener('submit', function(e) {
                    handleCheckboxAnswers();
                });
            }
        });

        window.onload = function () {
            var display = document.querySelector('#timer');
            var form = document.getElementById('quiz-form');
            
            if (!display || !form) {
                console.error('计时器或表单元素未找到');
                return;
            }
            
            // 计算剩余时间
            var endTimeStr = '${quiz.endTime}';
            console.log('结束时间字符串:', endTimeStr);
            
            var endTime = new Date(endTimeStr).getTime();
            var now = new Date().getTime();
            var timeLeft = Math.floor((endTime - now) / 1000);
            
            console.log('结束时间戳:', endTime);
            console.log('当前时间戳:', now);
            console.log('剩余秒数:', timeLeft);
            console.log('剩余分钟:', Math.floor(timeLeft / 60));
            
            if (timeLeft > 0) {
                startTimer(timeLeft, display);
            } else {
                // 时间已到
                display.textContent = "00:00";
                alert("测验时间已到，系统将自动提交您的答案！");
                // 处理复选框答案后提交
                handleCheckboxAnswers();
                form.submit();
            }
        };
    </script>
</head>
<body>
    <div class="container">
        <h2>${quiz.title}</h2>
        
        <div class="quiz-info">
            <div class="info-item">课程：${quiz.courseName}</div>
            <div class="info-item">开始时间：${quiz.startTime}</div>
            <div class="info-item">结束时间：${quiz.endTime}</div>
        </div>
        
        <div id="timer" class="timer">
            00:00
        </div>
        
        <div class="instructions">
            <h3>操作指引</h3>
            <p>1. 请仔细阅读每个题目，然后选择您认为正确的答案。</p>
            <p>2. 选择题使用单选按钮或复选框，判断题使用单选按钮。</p>
            <p>3. 您可以在提交前随时修改已作答的题目。</p>
            <p>4. 点击"提交答案"按钮完成测验，点击"保存修改"按钮更新已作答题目。</p>
            <p>5. 测验时间结束后系统将自动提交您的答案。</p>
        </div>
        
        <c:if test="${not empty submittedAnswers and submittedAnswers.size() > 0}">
            <div class="submitted-info">
                <p>您已经提交过答案，当前可以修改并重新保存或提交。</p>
            </div>
        </c:if>
        
        <form id="quiz-form" action="<c:if test='${not empty submittedAnswers and submittedAnswers.size() > 0}'>/student/quiz/update/${quiz.id}</c:if><c:if test='${empty submittedAnswers or submittedAnswers.size() == 0}'>/student/quiz/submit/${quiz.id}</c:if>" method="post">
            <input type="hidden" name="quizId" value="${quiz.id}">
            
            <c:forEach items="${questions}" var="question" varStatus="status">
                <div class="question">
                    <div class="question-number">问题 ${status.index + 1}</div>
                    <div class="question-content">${question.content}</div>
                    
                    <input type="hidden" name="answers[${status.index}].questionId" value="${question.id}">
                    
                    <div class="options">
                        <c:if test="${question.type eq 'radio'}">
                            <c:forEach items="${question.optionsList}" var="option" varStatus="optStatus">
                                <div class="option">
                                    <c:set var="isChecked" value="false" />
                                    <c:forEach items="${submittedAnswers}" var="submittedAnswer">
                                        <c:if test="${submittedAnswer.questionId eq question.id and submittedAnswer.studentAnswer eq 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.charAt(optStatus.index)}">
                                            <c:set var="isChecked" value="true" />
                                        </c:if>
                                    </c:forEach>
                                    <input type="radio" name="answers[${status.index}].studentAnswer" value="${'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.charAt(optStatus.index)}" <c:if test="${isChecked}">checked</c:if>>
                                    <label>${'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.charAt(optStatus.index)}. ${option}</label>
                                </div>
                            </c:forEach>
                        </c:if>
                        
                        <c:if test="${question.type eq 'checkbox'}">
                            <c:forEach items="${question.optionsList}" var="option" varStatus="optStatus">
                                <div class="option">
                                    <c:set var="isChecked" value="false" />
                                    <c:forEach items="${submittedAnswers}" var="submittedAnswer">
                                        <c:if test="${submittedAnswer.questionId eq question.id and fn:contains(submittedAnswer.studentAnswer, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.charAt(optStatus.index))}">
                                            <c:set var="isChecked" value="true" />
                                        </c:if>
                                    </c:forEach>
                                    <input type="checkbox" name="answers[${status.index}].studentAnswer" value="${'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.charAt(optStatus.index)}" <c:if test="${isChecked}">checked</c:if>>
                                    <label>${'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.charAt(optStatus.index)}. ${option}</label>
                                </div>
                            </c:forEach>
                        </c:if>
                        
                        <c:if test="${question.type eq 'judge'}">
                            <div class="option">
                                <c:set var="isChecked" value="false" />
                                <c:forEach items="${submittedAnswers}" var="submittedAnswer">
                                    <c:if test="${submittedAnswer.questionId eq question.id and submittedAnswer.studentAnswer eq 'A'}">
                                        <c:set var="isChecked" value="true" />
                                    </c:if>
                                </c:forEach>
                                <input type="radio" name="answers[${status.index}].studentAnswer" value="A" <c:if test="${isChecked}">checked</c:if>>
                                <label>A. 正确</label>
                            </div>
                            <div class="option">
                                <c:set var="isChecked" value="false" />
                                <c:forEach items="${submittedAnswers}" var="submittedAnswer">
                                    <c:if test="${submittedAnswer.questionId eq question.id and submittedAnswer.studentAnswer eq 'B'}">
                                        <c:set var="isChecked" value="true" />
                                    </c:if>
                                </c:forEach>
                                <input type="radio" name="answers[${status.index}].studentAnswer" value="B" <c:if test="${isChecked}">checked</c:if>>
                                <label>B. 错误</label>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
            
            <div class="action-buttons">
                <button type="submit" class="btn-primary">提交答案</button>
                <c:if test="${not empty submittedAnswers and submittedAnswers.size() > 0}">
                    <button type="button" class="btn-secondary" onclick="document.getElementById('quiz-form').submit();">保存修改</button>
                </c:if>
            </div>
        </form>
    </div>
</body>
</html>
