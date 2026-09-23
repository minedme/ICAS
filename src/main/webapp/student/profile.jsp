<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人学习档案 - 智能课堂系统</title>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background-color: #f5f7fa;
            padding: 20px;
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .header h1 {
            margin: 0;
            font-size: 28px;
        }
        .header p {
            margin: 10px 0 0 0;
            font-size: 16px;
            opacity: 0.9;
        }
        .card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        .card-title {
            font-size: 20px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #667eea;
        }
        .card-content {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
        .chart-container {
            flex: 1;
            min-width: 300px;
            height: 400px;
            background: #f9f9f9;
            border-radius: 8px;
            padding: 15px;
        }
        .stat-item {
            flex: 1;
            min-width: 200px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
        }
        .stat-value {
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .stat-label {
            font-size: 14px;
            opacity: 0.9;
        }
        .nav-buttons {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .nav-btn {
            padding: 12px 30px;
            background: white;
            border: 2px solid #667eea;
            color: #667eea;
            border-radius: 25px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: all 0.3s;
            text-decoration: none;
        }
        .nav-btn:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(102, 126, 234, 0.3);
        }
        .filter-section {
            background: #f9f9f9;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .filter-row {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }
        .filter-label {
            font-weight: bold;
            color: #555;
            min-width: 80px;
        }
        .filter-input {
            padding: 8px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            min-width: 150px;
        }
        .filter-btn {
            padding: 8px 20px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }
        .filter-btn:hover {
            background: #764ba2;
            transform: translateY(-2px);
        }
        @media (max-width: 768px) {
            .card-content {
                flex-direction: column;
            }
            .chart-container {
                min-width: 100%;
            }
            .nav-buttons {
                flex-direction: column;
            }
            .filter-row {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>个人学习档案</h1>
            <p>欢迎，${student.realName}！这里是您的学习数据分析中心</p>
        </div>

        <div class="card">
            <div class="card-title">快速导航</div>
            <div class="nav-buttons">
                <a href="/student/profile/attendance" class="nav-btn">出勤趋势</a>
                <a href="/student/profile/grades" class="nav-btn">成绩变化</a>
            </div>
        </div>

        <div class="card">
            <div class="card-title">学习概览</div>
            <div class="card-content">
                <div class="stat-item">
                    <div class="stat-value">--</div>
                    <div class="stat-label">总出勤次数</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">--</div>
                    <div class="stat-label">测验次数</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">--</div>
                    <div class="stat-label">平均成绩</div>
                </div>
            </div>
        </div>
    </div>

    <script>
        window.onload = function() {
            var studentId = ${student.id};
            
            fetch('/api/student/stats/' + studentId)
                .then(response => response.json())
                .then(data => {
                    document.querySelectorAll('.stat-value')[0].textContent = data.totalAttendance || '--';
                    document.querySelectorAll('.stat-value')[1].textContent = data.totalQuizzes || '--';
                    document.querySelectorAll('.stat-value')[2].textContent = data.averageGrade ? data.averageGrade.toFixed(1) : '--';
                })
                .catch(error => console.error('获取统计数据失败:', error));
        };
    </script>
</body>
</html>
