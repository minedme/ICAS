<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>管理员控制面板 - 智能课堂系统</title>
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
        .dashboard-cards {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            margin-bottom: 30px;
        }
        .card {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            width: 31%;
            min-width: 200px;
        }
        .card h3 {
            color: #333;
            margin-top: 0;
            margin-bottom: 15px;
        }
        .card-value {
            font-size: 36px;
            font-weight: bold;
            color: #2196F3;
        }
        .section {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .section h3 {
            color: #333;
            margin-top: 0;
            margin-bottom: 20px;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        .stat-item {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 8px;
        }
        .stat-label {
            font-weight: bold;
            color: #666;
            margin-bottom: 5px;
        }
        .stat-value {
            font-size: 24px;
            color: #333;
        }
        .management-links {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-top: 20px;
        }
        .management-link {
            background-color: #2196F3;
            color: white;
            padding: 15px 25px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 16px;
            font-weight: bold;
            display: inline-block;
        }
        .management-link:hover {
            background-color: #0b7dda;
        }
        
        /* 加载状态样式 */
        .card.loading {
            opacity: 0.7;
        }
        
        .loading-spinner {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #2196F3;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            animation: spin 1s linear infinite;
            display: inline-block;
            margin-left: 10px;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        /* 趋势指示样式 */
        .card-trend {
            margin-top: 10px;
            font-size: 14px;
            color: #666;
        }
        
        .trend-up {
            color: #4CAF50;
        }
        
        .trend-down {
            color: #F44336;
        }
        
        .trend-stable {
            color: #FFC107;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>智能课堂考勤与学习行为分析系统</h1>
        <p>欢迎您，${user.realName} 管理员</p>
    </div>
    
    <div class="nav">
        <a href="/admin/dashboard">控制面板</a>
        <a href="/admin/user/list">用户管理</a>
        <a href="/admin/class/list">班级管理</a>
        <a href="/admin/course/list">课程管理</a>
        <a href="/admin/analysis">系统分析</a>
        <a href="/user/logout" style="float: right;">退出登录</a>
    </div>
    
    <div class="content">
        <div class="dashboard-cards">
            <div class="card">
                <h3>总用户数</h3>
                <div class="card-value">${stats.totalUsers}</div>
            </div>
            <div class="card">
                <h3>教师数</h3>
                <div class="card-value">${stats.teacherCount}</div>
            </div>
            <div class="card">
                <h3>学生数</h3>
                <div class="card-value">${stats.studentCount}</div>
            </div>
            <div class="card">
                <h3>课程总数</h3>
                <div class="card-value">${stats.courseCount}</div>
            </div>
            <div class="card">
                <h3>本月考勤</h3>
                <div class="card-value">${stats.monthlyAttendance}</div>
            </div>
            <div class="card">
                <h3>测验总数</h3>
                <div class="card-value">${stats.totalQuizzes}</div>
            </div>

        </div>
        

        
        <div class="section">
            <h3>系统统计</h3>
            <div class="stats-grid">
                <div class="stat-item">
                    <div class="stat-label">平均出勤率</div>
                    <div class="stat-value">${stats.avgAttendanceRate}%</div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">平均测验得分</div>
                    <div class="stat-value">${stats.avgQuizScore}</div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">活跃课程数</div>
                    <div class="stat-value">${stats.activeCourses}</div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">待处理预警</div>
                    <div class="stat-value">${stats.pendingWarnings}</div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // 定义API接口URL
        const API_URL = '/admin/stats';
        
        // 数据卡片映射
        const cardMap = {
            '总用户数': 'totalUsers',
            '教师数': 'teacherCount',
            '学生数': 'studentCount',
            '课程总数': 'courseCount',
            '本月考勤': 'monthlyAttendance',
            '测验总数': 'totalQuizzes'
        };
        
        // 上一次的数据，用于计算趋势
        let previousData = null;
        
        // 显示加载状态
        function showLoading() {
            document.querySelectorAll('.card').forEach(card => {
                card.classList.add('loading');
                const valueElement = card.querySelector('.card-value');
                if (valueElement && !valueElement.querySelector('.loading-spinner')) {
                    valueElement.innerHTML += '<div class="loading-spinner"></div>';
                }
            });
        }
        
        // 隐藏加载状态
        function hideLoading() {
            document.querySelectorAll('.card').forEach(card => {
                card.classList.remove('loading');
                const spinner = card.querySelector('.loading-spinner');
                if (spinner) {
                    spinner.remove();
                }
            });
        }
        
        // 更新卡片数据
        function updateCardData(stats) {
            Object.keys(cardMap).forEach(title => {
                const dataKey = cardMap[title];
                const cards = document.querySelectorAll('.card');
                
                cards.forEach(card => {
                    const cardTitle = card.querySelector('h3').textContent;
                    if (cardTitle === title) {
                        const valueElement = card.querySelector('.card-value');
                        const currentValue = stats[dataKey];
                        
                        // 更新数值
                        valueElement.textContent = currentValue;
                        
                        // 添加或更新趋势指示
                        let trendElement = card.querySelector('.card-trend');
                        if (!trendElement) {
                            trendElement = document.createElement('div');
                            trendElement.className = 'card-trend';
                            card.appendChild(trendElement);
                        }
                        
                        // 计算趋势
                        if (previousData && previousData[dataKey] !== undefined) {
                            const previousValue = previousData[dataKey];
                            if (currentValue > previousValue) {
                                trendElement.className = 'card-trend trend-up';
                                trendElement.textContent = `↑ ${(currentValue - previousValue)}`;
                            } else if (currentValue < previousValue) {
                                trendElement.className = 'card-trend trend-down';
                                trendElement.textContent = `↓ ${(previousValue - currentValue)}`;
                            } else {
                                trendElement.className = 'card-trend trend-stable';
                                trendElement.textContent = '→ 持平';
                            }
                        } else {
                            trendElement.className = 'card-trend';
                            trendElement.textContent = '';
                        }
                    }
                });
            });
            
            // 保存当前数据用于下次比较
            previousData = stats;
        }
        
        // 加载统计数据
        async function loadStats() {
            try {
                showLoading();
                const response = await fetch(API_URL);
                if (!response.ok) {
                    throw new Error('网络请求失败');
                }
                const stats = await response.json();
                updateCardData(stats);
            } catch (error) {
                console.error('加载统计数据失败:', error);
            } finally {
                hideLoading();
            }
        }
        
        // 页面加载完成后立即加载数据
        document.addEventListener('DOMContentLoaded', loadStats);
        
        // 设置定时更新，每30秒更新一次数据
        setInterval(loadStats, 30000);
    </script>
</body>
</html>