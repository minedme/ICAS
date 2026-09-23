<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>教师控制面板 - 智能课堂系统</title>
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
            width: 30%;
            min-width: 250px;
        }
        .card h3 {
            color: #333;
            margin-top: 0;
            margin-bottom: 15px;
        }
        .card-value {
            font-size: 36px;
            font-weight: bold;
            color: #4CAF50;
        }
        .attendance-settings {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        
        .settings-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .setting-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        
        .setting-item:last-child {
            border-bottom: none;
        }
        
        .setting-value {
            font-weight: bold;
            color: #4CAF50;
        }
        
        .recent-activities {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        .recent-activities h3 {
            color: #333;
            margin-top: 0;
            margin-bottom: 20px;
        }
        .activity-item {
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .activity-item:last-child {
            border-bottom: none;
        }
        .activity-time {
            color: #666;
            font-size: 12px;
            margin-left: 10px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>智能课堂考勤与学习行为分析系统</h1>
        <p>欢迎您，${user.realName} 教师</p>
    </div>
    
    <div class="nav">
        <a href="/teacher/dashboard">控制面板</a>
        <a href="/teacher/class">班级管理</a>
        <a href="/teacher/attendance/list">考勤管理</a>
        <a href="/teacher/quiz/list">测验管理</a>
        <a href="/teacher/analysis">数据分析</a>
        <a href="/user/logout" style="float: right;">退出登录</a>
    </div>
    
    <div class="content">
        <div class="dashboard-cards">
            <div class="card">
                <h3>课程数量</h3>
                <div class="card-value">${stats.courseCount}</div>
            </div>
            <div class="card">
                <h3>本月考勤次数</h3>
                <div class="card-value">${stats.attendanceCount}</div>
            </div>
            <div class="card">
                <h3>已创建测验</h3>
                <div class="card-value">${stats.quizCount}</div>
            </div>
            <div class="card">
                <h3>今日签到率</h3>
                <div class="card-value">${stats.todayAttendanceRate}%</div>
            </div>
            <div class="card">
                <h3>待处理预警</h3>
                <div class="card-value">${stats.warningCount}</div>
            </div>
            <div class="card">
                <h3>学生人数</h3>
                <div class="card-value">${stats.studentCount}</div>
            </div>
        </div>
        
        <div class="attendance-settings">
            <h3>考勤设置</h3>
            <div class="settings-grid">
                <div class="setting-item">
                    <label>考勤时长(分钟):</label>
                    <span id="duration" class="setting-value">30</span>
                </div>
                <div class="setting-item">
                    <label>允许提前签到(分钟):</label>
                    <span id="earlySignMinutes" class="setting-value">5</span>
                </div>
                <div class="setting-item">
                    <label>允许迟到签到(分钟):</label>
                    <span id="lateSignMinutes" class="setting-value">10</span>
                </div>
                <div class="setting-item">
                    <label>定位签到半径(米):</label>
                    <span id="radius" class="setting-value">50</span>
                </div>
                <div class="setting-item">
                    <label>启用定位签到:</label>
                    <span id="enableLocation" class="setting-value">否</span>
                </div>
                <div class="setting-item">
                    <label>启用人脸识别:</label>
                    <span id="enableFaceRecognition" class="setting-value">否</span>
                </div>
            </div>
        </div>
        
        <div class="recent-activities">
            <h3>最近活动</h3>
            <c:forEach items="${recentActivities}" var="activity">
                <div class="activity-item">
                    ${activity.content}
                    <span class="activity-time">${activity.time}</span>
                </div>
            </c:forEach>
            
            <c:if test="${empty recentActivities}">
                <p>暂无最近活动记录</p>
            </c:if>
        </div>
    </div>
    
    <script>
        // 定义API接口URL
        const API_URL = '/teacher/stats';
        
        // 数据卡片映射
        const cardMap = {
            '课程数量': 'courseCount',
            '本月考勤次数': 'attendanceCount',
            '已创建测验': 'quizCount',
            '今日签到率': 'todayAttendanceRate',
            '待处理预警': 'warningCount',
            '学生人数': 'studentCount'
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
                        if (title === '今日签到率') {
                            valueElement.textContent = currentValue + '%';
                        } else {
                            valueElement.textContent = currentValue;
                        }
                        
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
        
        // 考勤设置API接口URL
        const SETTINGS_API_URL = '/teacher/attendance-setting';
        
        // 加载考勤设置数据
        async function loadAttendanceSettings() {
            try {
                const response = await fetch(SETTINGS_API_URL);
                if (!response.ok) {
                    throw new Error('网络请求失败');
                }
                const settings = await response.json();
                updateAttendanceSettings(settings);
            } catch (error) {
                console.error('加载考勤设置失败:', error);
            }
        }
        
        // 更新考勤设置显示
        function updateAttendanceSettings(settings) {
            document.getElementById('duration').textContent = settings.duration;
            document.getElementById('earlySignMinutes').textContent = settings.earlySignMinutes;
            document.getElementById('lateSignMinutes').textContent = settings.lateSignMinutes;
            document.getElementById('radius').textContent = settings.radius;
            document.getElementById('enableLocation').textContent = settings.enableLocation ? '是' : '否';
            document.getElementById('enableFaceRecognition').textContent = settings.enableFaceRecognition ? '是' : '否';
        }
        
        // 设置定时更新，每5秒更新一次数据
        setInterval(loadStats, 5000);
        setInterval(loadAttendanceSettings, 5000);
        
        // 页面加载完成后立即加载考勤设置数据
        document.addEventListener('DOMContentLoaded', loadAttendanceSettings);
    </script>
    
    <style>
        /* 加载状态样式 */
        .card.loading {
            opacity: 0.7;
        }
        
        .loading-spinner {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #4CAF50;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            animation: spin 1s linear infinite;
            display: inline-block;
            margin-left: 10px;
            vertical-align: middle;
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
</body>
</html>
