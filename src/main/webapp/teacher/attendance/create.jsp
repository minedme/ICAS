<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>创建考勤 - 智能课堂系统</title>
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
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-weight: bold;
        }
        input[type="text"], input[type="datetime-local"], select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
        }
        button {
            padding: 12px 24px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin-right: 10px;
        }
        button:hover {
            background-color: #45a049;
        }
        .btn-cancel {
            background-color: #f44336;
        }
        .btn-cancel:hover {
            background-color: #da190b;
        }
        .form-row {
            display: flex;
            gap: 20px;
        }
        .form-row .form-group {
            flex: 1;
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
        <a href="/class/join">加入班级</a>
        <a href="/teacher/quiz/list">测验管理</a>
        <a href="/teacher/attendance/list" class="active">考勤管理</a>
        <a href="/user/logout" style="float: right;">退出登录</a>
    </div>
    
    <div class="container">
        <h2>创建新考勤</h2>
        <form action="/teacher/attendance/create" method="post">
            <div class="form-group">
                <label for="courseName">课程名称</label>
                <input type="text" id="courseName" name="courseName" required>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="startTime">开始时间</label>
                    <input type="datetime-local" id="startTime" name="startTime" required>
                </div>
                <div class="form-group">
                    <label for="endTime">结束时间</label>
                    <input type="datetime-local" id="endTime" name="endTime" required>
                </div>
            </div>
            
            <div class="form-group">
                <label for="location">考勤地点</label>
                <input type="text" id="location" name="location" placeholder="如：教学楼B301室">
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="latitude">纬度</label>
                    <input type="text" id="latitude" name="latitude" placeholder="自动获取">
                </div>
                <div class="form-group">
                    <label for="longitude">经度</label>
                    <input type="text" id="longitude" name="longitude" placeholder="自动获取">
                </div>
            </div>
            
            <div class="form-group">
                <label for="qrCodeExpiry">二维码有效期(秒)</label>
                <input type="text" id="qrCodeExpiry" name="qrCodeExpiry" value="300" placeholder="默认300秒">
            </div>
            
            <div class="form-group">
                <label for="range">GPS范围验证(米)</label>
                <input type="text" id="range" name="range" value="50" placeholder="默认50米">
            </div>
            
            <button type="submit">创建考勤</button>
            <a href="/teacher/attendance/list" class="btn-cancel" style="display: inline-block; padding: 12px 24px; text-decoration: none; color: white; border-radius: 4px;">取消</a>
        </form>
    </div>
    
    <script>
        // 自动获取当前时间作为默认值
        document.addEventListener('DOMContentLoaded', function() {
            const now = new Date();
            const startTimeInput = document.getElementById('startTime');
            const endTimeInput = document.getElementById('endTime');
            
            // 设置开始时间为当前时间
            startTimeInput.value = now.toISOString().slice(0, 16);
            
            // 设置结束时间为30分钟后            const endTime = new Date(now.getTime() + 30 * 60 * 1000);
            endTimeInput.value = endTime.toISOString().slice(0, 16);
        });
    </script>
</body>
</html>
