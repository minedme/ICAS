<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>编辑班级 - 智能课堂系统</title>
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
            max-width: 800px;
            margin: 0 auto;
        }
        .form-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .form-group textarea {
            min-height: 100px;
            resize: vertical;
        }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #4CAF50;
        }
        .form-buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            text-align: center;
        }
        .btn-primary {
            background-color: #4CAF50;
            color: white;
        }
        .btn-secondary {
            background-color: #666;
            color: white;
        }
        .btn:hover {
            opacity: 0.8;
        }
        .error-message {
            background-color: #fee;
            color: #c33;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 20px;
            display: none;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>智能课堂考勤与学习行为分析系统</h1>
        <p>编辑班级</p>
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
        <div class="form-container">
            <div id="errorMessage" class="error-message"></div>
            
            <form id="classForm">
                <input type="hidden" id="id" name="id" value="${classInfo.id}">
                
                <div class="form-group">
                    <label for="className">班级名称 *</label>
                    <input type="text" id="className" name="className" value="${classInfo.className}" required>
                </div>
                
                <div class="form-group">
                    <label for="classCode">班级代码 *</label>
                    <input type="text" id="classCode" name="classCode" value="${classInfo.classCode}" required>
                </div>
                
                <div class="form-group">
                    <label for="major">专业 *</label>
                    <input type="text" id="major" name="major" value="${classInfo.major}" required>
                </div>
                
                <div class="form-group">
                    <label for="grade">年级 *</label>
                    <input type="text" id="grade" name="grade" value="${classInfo.grade}" required>
                </div>
                
                <div class="form-group">
                    <label for="teacherId">班主任 *</label>
                    <select id="teacherId" name="teacherId" required>
                        <option value="">请选择班主任</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="description">班级描述</label>
                    <textarea id="description" name="description">${classInfo.description}</textarea>
                </div>
                
                <div class="form-group">
                    <label for="status">状态</label>
                    <select id="status" name="status">
                        <option value="1" ${classInfo.status == 1 ? 'selected' : ''}>正常</option>
                        <option value="0" ${classInfo.status == 0 ? 'selected' : ''}>禁用</option>
                    </select>
                </div>
                
                <div class="form-buttons">
                    <button type="submit" class="btn btn-primary">保存修改</button>
                    <a href="/admin/class/list" class="btn btn-secondary">取消</a>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        // 加载教师列表
        fetch('/admin/user/list?role=teacher')
            .then(response => response.text())
            .then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');
                const rows = doc.querySelectorAll('table tbody tr');
                const select = document.getElementById('teacherId');
                
                rows.forEach(row => {
                    const cells = row.querySelectorAll('td');
                    if (cells.length > 0) {
                        const id = cells[0].textContent.trim();
                        const name = cells[3].textContent.trim();
                        const option = document.createElement('option');
                        option.value = id;
                        option.textContent = name;
                        select.appendChild(option);
                    }
                });
                
                // 设置当前选中的教师
                if (${classInfo.teacherId}) {
                    select.value = ${classInfo.teacherId};
                }
            })
            .catch(error => {
                console.error('加载教师列表失败:', error);
            });
        
        // 表单提交
        document.getElementById('classForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = {
                id: parseInt(document.getElementById('id').value),
                className: document.getElementById('className').value,
                classCode: document.getElementById('classCode').value,
                major: document.getElementById('major').value,
                grade: document.getElementById('grade').value,
                teacherId: parseInt(document.getElementById('teacherId').value),
                description: document.getElementById('description').value,
                status: parseInt(document.getElementById('status').value)
            };
            
            fetch('/admin/class/edit', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(data.message);
                    window.location.href = '/admin/class/list';
                } else {
                    const errorDiv = document.getElementById('errorMessage');
                    errorDiv.textContent = data.message;
                    errorDiv.style.display = 'block';
                }
            })
            .catch(error => {
                const errorDiv = document.getElementById('errorMessage');
                errorDiv.textContent = '更新失败：' + error;
                errorDiv.style.display = 'block';
            });
        });
    </script>
</body>
</html>
