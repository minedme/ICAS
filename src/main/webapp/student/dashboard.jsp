<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>学生控制面板 - 智能课堂系统</title>
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
        .personal-info {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        .personal-info h2 {
            color: #333;
            margin-top: 0;
            margin-bottom: 20px;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        .info-item {
            margin-bottom: 15px;
        }
        .info-label {
            font-weight: bold;
            color: #555;
            margin-bottom: 5px;
        }
        .info-value {
            color: #333;
        }
        .warning { color: #f44336; font-weight: bold; }
        .good { color: #4CAF50; font-weight: bold; }
    </style>
</head>
<body>
    <div class="header">
        <h1>智能课堂考勤与学习行为分析系统</h1>
        <p>欢迎您，${user.realName} 同学</p>
    </div>
    
    <div class="nav">
        <a href="/student/dashboard">控制面板</a>
        <a href="/student/profile">个人档案</a>
        <a href="/class/join">加入班级</a>
        <a href="/student/attendance/list">考勤记录</a>
        <a href="/student/quiz/list">测验</a>
        <a href="/user/logout" style="float: right;">退出登录</a>
    </div>
    
    <div class="content">
        <!-- 个人信息 -->
        <div class="personal-info">
            <h2>个人信息</h2>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">学号</div>
                    <div class="info-value">${user.username}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">姓名</div>
                    <div class="info-value">${user.realName}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">性别</div>
                    <div class="info-value">-</div>
                </div>
                <div class="info-item">
                    <div class="info-label">班级</div>
                    <div class="info-value">
                        <c:if test="${user.classId != null}">
                            <c:if test="${classInfo != null}">
                                ${classInfo.className} (${classInfo.classCode})
                            </c:if>
                            <c:if test="${classInfo == null}">
                                已加入班级
                            </c:if>
                        </c:if>
                        <c:if test="${user.classId == null}">
                            <a href="/class/join" style="color: #4CAF50;">点击加入班级</a>
                        </c:if>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">联系电话</div>
                    <div class="info-value">${user.phone}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">邮箱</div>
                    <div class="info-value">${user.email}</div>
                </div>
            </div>
        </div>
        
        <!-- 学习统计 -->
        <div class="dashboard-cards">
            <div class="card">
                <h3>出勤率</h3>
                <div class="card-value">${stats.attendanceRate}%</div>
                <div style="margin-top: 10px; font-size: 14px;">
                    <c:if test="${stats.attendanceRate >= 90}">
                        <span class="good">出勤情况良好</span>
                    </c:if>
                    <c:if test="${stats.attendanceRate < 90 && stats.attendanceRate >= 70}">
                        <span>出勤情况一般</span>
                    </c:if>
                    <c:if test="${stats.attendanceRate < 70}">
                        <span class="warning">出勤情况较差，请加强</span>
                    </c:if>
                </div>
            </div>
            <div class="card">
                <h3>平均测验得分</h3>
                <div class="card-value">${stats.averageScore}</div>
                <div style="margin-top: 10px; font-size: 14px;">
                    <c:if test="${stats.averageScore >= 80}">
                        <span class="good">成绩优秀</span>
                    </c:if>
                    <c:if test="${stats.averageScore < 80 && stats.averageScore >= 60}">
                        <span>成绩合格</span>
                    </c:if>
                    <c:if test="${stats.averageScore < 60}">
                        <span class="warning">成绩不合格，请努力</span>
                    </c:if>
                </div>
            </div>
            <div class="card">
                <h3>已完成测验</h3>
                <div class="card-value">${stats.completedQuizzes}</div>
            </div>
            <div class="card">
                <h3>本月考勤</h3>
                <div class="card-value">${stats.monthlyAttendance}</div>
            </div>
            <div class="card">
                <h3>本月缺勤</h3>
                <div class="card-value">${stats.monthlyAbsent}</div>
            </div>
            <div class="card">
                <h3>本月迟到</h3>
                <div class="card-value">${stats.monthlyLate}</div>
            </div>
        </div>
        
        <!-- 最近学习活动 -->
        <div class="recent-activities">
            <h3>最近学习活动</h3>
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
        const API_URL = '/student/stats';
        
        // 数据卡片映射
        const cardMap = {
            '出勤率': 'attendanceRate',
            '平均测验得分': 'averageScore',
            '已完成测验': 'completedQuizzes',
            '本月考勤': 'monthlyAttendance',
            '本月缺勤': 'monthlyAbsent',
            '本月迟到': 'monthlyLate'
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
                        if (title === '出勤率') {
                            valueElement.textContent = currentValue + '%';
                            
                            // 更新出勤情况提示
                            const statusElement = card.querySelector('div span');
                            if (statusElement) {
                                statusElement.parentElement.innerHTML = '';
                            }
                            
                            let statusText = '';
                            let statusClass = '';
                            if (currentValue >= 90) {
                                statusClass = 'good';
                                statusText = '出勤情况良好';
                            } else if (currentValue < 90 && currentValue >= 70) {
                                statusText = '出勤情况一般';
                            } else {
                                statusClass = 'warning';
                                statusText = '出勤情况较差，请加强';
                            }
                            
                            const statusDiv = document.createElement('div');
                            statusDiv.style.marginTop = '10px';
                            statusDiv.style.fontSize = '14px';
                            
                            const statusSpan = document.createElement('span');
                            if (statusClass) {
                                statusSpan.className = statusClass;
                            }
                            statusSpan.textContent = statusText;
                            
                            statusDiv.appendChild(statusSpan);
                            card.appendChild(statusDiv);
                        } else {
                            valueElement.textContent = currentValue;
                            
                            // 更新成绩提示
                            if (title === '平均测验得分') {
                                const statusElement = card.querySelector('div span');
                                if (statusElement) {
                                    statusElement.parentElement.innerHTML = '';
                                }
                                
                                let statusText = '';
                                let statusClass = '';
                                if (currentValue >= 80) {
                                    statusClass = 'good';
                                    statusText = '成绩优秀';
                                } else if (currentValue < 80 && currentValue >= 60) {
                                    statusText = '成绩合格';
                                } else {
                                    statusClass = 'warning';
                                    statusText = '成绩不合格，请努力';
                                }
                                
                                const statusDiv = document.createElement('div');
                                statusDiv.style.marginTop = '10px';
                                statusDiv.style.fontSize = '14px';
                                
                                const statusSpan = document.createElement('span');
                                if (statusClass) {
                                    statusSpan.className = statusClass;
                                }
                                statusSpan.textContent = statusText;
                                
                                statusDiv.appendChild(statusSpan);
                                card.appendChild(statusDiv);
                            }
                        }
                        
                        // 添加或更新趋势指示
                        let trendElement = card.querySelector('.card-trend');
                        if (!trendElement) {
                            trendElement = document.createElement('div');
                            trendElement.className = 'card-trend';
                            card.appendChild(trendElement);
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
