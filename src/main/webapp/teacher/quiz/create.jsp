<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>创建测验 - 智能课堂系统</title>
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
        .edit-form {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
        }
        .form-item {
            margin-bottom: 20px;
        }
        .form-label {
            font-weight: bold;
            color: #333;
            display: inline-block;
            width: 100px;
        }
        .form-input {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 300px;
        }
        .form-textarea {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 300px;
            height: 100px;
            resize: vertical;
        }
        .form-select {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 320px;
        }
        .form-button {
            padding: 8px 16px;
            background-color: #2196F3;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
        }
        .form-button:hover {
            background-color: #0b7dda;
        }
        .back-button {
            padding: 8px 16px;
            background-color: #6c757d;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
        }
        .back-button:hover {
            background-color: #545b62;
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
        button.delete-btn {
            padding: 8px 16px;
            background-color: #f44336;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            margin-right: 10px;
        }
        button.delete-btn:hover {
            background-color: #da190b;
        }
        button.add-btn {
            padding: 8px 16px;
            background-color: #2196F3;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            margin-right: 10px;
            margin-bottom: 10px;
        }
        button.add-btn:hover {
            background-color: #0b7dda;
        }
        /* 适配datetime-local输入框 */
        input[type="datetime-local"] {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            width: 300px;
        }
        /* 错误消息样式 */
        .error-message {
            color: #f44336;
            margin-bottom: 15px;
        }
        /* 成功消息样式 */
        .success-message {
            color: #4CAF50;
            margin-bottom: 15px;
        }
    </style>
    <script>
        let questionCount = 1;

        // 页面加载完成后设置事件委托
        document.addEventListener('DOMContentLoaded', function() {
            // 为所有删除按钮设置事件委托
            const questionsContainer = document.getElementById('questions-container');
            questionsContainer.addEventListener('click', function(e) {
                if (e.target.classList.contains('delete-btn')) {
                    deleteQuestionByBtn(e.target);
                }
            });
        });

        function addQuestion() {
            questionCount++;
            const container = document.getElementById('questions-container');
            const questionIndex = questionCount - 1;
            
            // 创建问题容器
            const questionDiv = document.createElement('div');
            questionDiv.className = 'question';
            questionDiv.id = 'question-' + questionCount;
            
            // 创建问题标题
            const h4 = document.createElement('h4');
            h4.textContent = '问题 ' + questionCount;
            questionDiv.appendChild(h4);
            
            // 创建问题类型选择
            const typeGroup = createFormItem('问题类型');
            const typeSelect = document.createElement('select');
            typeSelect.className = 'form-select';
            typeSelect.name = 'questions[' + questionIndex + '].type';
            const types = [{value: 'radio', text: '单选题'}, {value: 'checkbox', text: '多选题'}, {value: 'judge', text: '判断题'}];
            types.forEach(type => {
                const option = document.createElement('option');
                option.value = type.value;
                option.textContent = type.text;
                typeSelect.appendChild(option);
            });
            typeGroup.appendChild(typeSelect);
            questionDiv.appendChild(typeGroup);
            
            // 创建问题内容输入
            const contentGroup = createFormItem('问题内容');
            const textarea = document.createElement('textarea');
            textarea.className = 'form-textarea';
            textarea.name = 'questions[' + questionIndex + '].content';
            textarea.rows = 3;
            textarea.required = true;
            contentGroup.appendChild(textarea);
            questionDiv.appendChild(contentGroup);
            
            // 创建选项容器
            const optionsGroup = createFormItem('选项');
            const optionsDiv = document.createElement('div');
            optionsDiv.className = 'options';
            
            // 创建各个选项
            const optionLabels = ['A', 'B', 'C', 'D'];
            optionLabels.forEach((label, idx) => {
                const optionDiv = document.createElement('div');
                optionDiv.className = 'option';
                
                const input = document.createElement('input');
                input.type = 'text';
                input.className = 'form-input';
                input.name = 'questions[' + questionIndex + '].option' + label;
                input.placeholder = '选项 ' + label;
                if (idx < 2) { // A和B是必填项
                    input.required = true;
                }
                
                optionDiv.appendChild(input);
                optionsDiv.appendChild(optionDiv);
            });
            
            optionsGroup.appendChild(optionsDiv);
            questionDiv.appendChild(optionsGroup);
            
            // 创建正确答案输入
            const answerGroup = createFormItem('正确答案');
            const answerInput = document.createElement('input');
            answerInput.type = 'text';
            answerInput.className = 'form-input';
            answerInput.name = 'questions[' + questionIndex + '].correctAnswer';
            answerInput.placeholder = '如：A 或 AB';
            answerInput.required = true;
            answerGroup.appendChild(answerInput);
            questionDiv.appendChild(answerGroup);
            
            // 创建分值输入
            const scoreGroup = createFormItem('分值');
            const scoreInput = document.createElement('input');
            scoreInput.type = 'number';
            scoreInput.className = 'form-input';
            scoreInput.name = 'questions[' + questionIndex + '].score';
            scoreInput.min = 1;
            scoreInput.max = 10;
            scoreInput.value = 5;
            scoreInput.required = true;
            scoreGroup.appendChild(scoreInput);
            questionDiv.appendChild(scoreGroup);
            
            // 创建删除按钮
            const deleteBtn = document.createElement('button');
            deleteBtn.type = 'button';
            deleteBtn.className = 'delete-btn';
            deleteBtn.setAttribute('data-question-id', questionCount);
            deleteBtn.textContent = '删除问题';
            questionDiv.appendChild(deleteBtn);
            
            // 添加到容器
            container.appendChild(questionDiv);
        }
        
        // 辅助函数：创建表单组
        function createFormItem(labelText) {
            const group = document.createElement('div');
            group.className = 'form-item';
            
            const label = document.createElement('label');
            label.className = 'form-label';
            label.textContent = labelText + '：';
            group.appendChild(label);
            
            return group;
        }

        // 通过按钮元素获取问题ID并删除
        function deleteQuestionByBtn(btn) {
            const questionId = parseInt(btn.getAttribute('data-question-id'));
            deleteQuestion(questionId);
        }
        
        function deleteQuestion(id) {
            const questionDiv = document.getElementById('question-' + id);
            if (questionDiv) {
                // 确认删除
                if (!confirm('确定要删除这个问题吗？此操作不可恢复。')) {
                    return;
                }
                
                questionDiv.remove();
                
                // 重新计算所有问题的索引
                const questionsContainer = document.getElementById('questions-container');
                // 将HTMLCollection转换为数组，避免在循环中DOM更新导致的问题
                // 使用兼容性更好的方式转换数组，支持所有浏览器
                const questions = [].slice.call(questionsContainer.getElementsByClassName('question'));
                
                // 更新问题数量
                questionCount = questions.length;
                
                // 重新命名所有问题的表单字段索引
                for (let i = 0; i < questions.length; i++) {
                    const question = questions[i];
                    const newId = i + 1;
                    
                    // 更新问题的ID
                    question.id = 'question-' + newId;
                    
                    // 更新问题标题
                    const h4 = question.querySelector('h4');
                    h4.textContent = '问题 ' + newId;
                    
                    // 更新所有表单字段的name属性
                    const inputs = question.querySelectorAll('input, select, textarea');
                    for (let j = 0; j < inputs.length; j++) {
                        const input = inputs[j];
                        if (input.name) {
                            input.name = input.name.replace(/questions\[(\d+)\]/g, 'questions[' + i + ']');
                        }
                    }
                    
                    // 更新删除按钮的data-question-id属性
                    const deleteBtn = question.querySelector('.delete-btn');
                    if (deleteBtn) {
                        deleteBtn.setAttribute('data-question-id', newId);
                    }
                }
            } else {
                console.error('未找到要删除的问题元素，ID: ' + id);
                alert('删除失败：未找到要删除的问题。');
            }
        }
    </script>
</head>
<body>
    <div class="header">
        <h1>智能课堂考勤与学习行为分析系统</h1>
    </div>
    
    <div class="nav">
        <a href="/teacher/dashboard">控制面板</a>
        <a href="/teacher/class">班级管理</a>
        <a href="/teacher/quiz/list">我的测验</a>
        <a href="/teacher/attendance/list">考勤管理</a>
        <a href="/user/logout" class="logout">退出登录</a>
    </div>
    
    <div class="content">
        <div class="section">
            <h2>创建测验</h2>
            
            <form class="edit-form" action="/teacher/quiz/create" method="post">
                <div class="form-item">
                    <label class="form-label">测验标题：</label>
                    <input type="text" class="form-input" id="title" name="title" required>
                </div>
                
                <div class="form-item">
                    <label class="form-label">课程名称：</label>
                    <input type="text" class="form-input" id="courseName" name="courseName" required>
                </div>
                
                <div class="form-item">
                    <label class="form-label">开始时间：</label>
                    <input type="datetime-local" class="form-input" id="startTime" name="startTime" required>
                </div>
                
                <div class="form-item">
                    <label class="form-label">结束时间：</label>
                    <input type="datetime-local" class="form-input" id="endTime" name="endTime" required>
                </div>
                
                <div class="form-item">
                    <h3>测验问题</h3>
                    <div id="questions-container">
                        <!-- 第一个问题 -->
                        <div class="question" id="question-1">
                            <h4>问题 1</h4>
                            <div class="form-item">
                                <label class="form-label">问题类型：</label>
                                <select class="form-select" name="questions[0].type">
                                    <option value="radio">单选题</option>
                                    <option value="checkbox">多选题</option>
                                    <option value="judge">判断题</option>
                                </select>
                            </div>
                            <div class="form-item">
                                <label class="form-label">问题内容：</label>
                                <textarea class="form-textarea" name="questions[0].content" rows="3" required></textarea>
                            </div>
                            <div class="form-item">
                                <label class="form-label">选项：</label>
                                <div class="options">
                                    <div class="option">
                                        <input type="text" class="form-input" name="questions[0].optionA" placeholder="选项 A" required>
                                    </div>
                                    <div class="option">
                                        <input type="text" class="form-input" name="questions[0].optionB" placeholder="选项 B" required>
                                    </div>
                                    <div class="option">
                                        <input type="text" class="form-input" name="questions[0].optionC" placeholder="选项 C">
                                    </div>
                                    <div class="option">
                                        <input type="text" class="form-input" name="questions[0].optionD" placeholder="选项 D">
                                    </div>
                                </div>
                            </div>
                            <div class="form-item">
                                <label class="form-label">正确答案：</label>
                                <input type="text" class="form-input" name="questions[0].correctAnswer" placeholder="如：A 或 AB" required>
                            </div>
                            <div class="form-item">
                                <label class="form-label">分值：</label>
                                <input type="number" class="form-input" name="questions[0].score" min="1" max="10" value="5" required>
                            </div>
                            <button type="button" class="delete-btn" data-question-id="1">删除问题</button>
                        </div>
                    </div>
                </div>
                
                <div class="form-item">
                    <button type="button" class="add-btn" onclick="addQuestion()">添加问题</button>
                </div>
                
                <div class="form-item">
                    <button type="submit" class="form-button">创建测验</button>
                    <a href="/teacher/quiz/list" class="back-button">返回</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
