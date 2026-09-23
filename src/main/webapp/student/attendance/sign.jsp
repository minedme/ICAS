﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>考勤签到 - 智能课堂系统</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            color: #333;
            margin-bottom: 30px;
            text-align: center;
        }
        .attendance-info {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        .info-item {
            margin-bottom: 10px;
            font-size: 16px;
        }
        .info-label {
            font-weight: bold;
            color: #555;
        }
        .qrcode-container {
            text-align: center;
            margin-bottom: 30px;
        }
        .qrcode {
            width: 200px;
            height: 200px;
            margin: 0 auto;
            background-color: white;
            padding: 10px;
            border: 1px solid #ddd;
        }
        .status {
            text-align: center;
            padding: 20px;
            margin-bottom: 30px;
            border-radius: 8px;
            font-size: 18px;
            font-weight: bold;
        }
        .status-success {
            background-color: #4CAF50;
            color: white;
        }
        .status-pending {
            background-color: #ff9800;
            color: white;
        }
        .status-error {
            background-color: #f44336;
            color: white;
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
        }
        button:hover {
            background-color: #45a049;
        }
        button:disabled {
            background-color: #cccccc;
            cursor: not-allowed;
        }
        .error-message {
            color: red;
            text-align: center;
            margin-top: 15px;
        }
    </style>
    <script>
        // 自动刷新二维码（每30秒）
        function refreshQRCode() {
            const qrcodeImg = document.getElementById('qrcode-img');
            if (qrcodeImg) {
                const currentSrc = qrcodeImg.src;
                const newSrc = currentSrc.split('?')[0] + '?t=' + new Date().getTime();
                qrcodeImg.src = newSrc;
            }
        }
        
        setInterval(refreshQRCode, 30000);
        
        // GPS定位签到
        function signWithGPS() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(position) {
                    const lat = position.coords.latitude;
                    const lng = position.coords.longitude;
                    
                    // 创建表单提交
                    const form = document.createElement('form');
                    form.method = 'post';
                    form.action = '/student/attendance/sign/gps';
                    
                    const latInput = document.createElement('input');
                    latInput.type = 'hidden';
                    latInput.name = 'latitude';
                    latInput.value = lat;
                    
                    const lngInput = document.createElement('input');
                    lngInput.type = 'hidden';
                    lngInput.name = 'longitude';
                    lngInput.value = lng;
                    
                    const attendanceIdInput = document.createElement('input');
                    attendanceIdInput.type = 'hidden';
                    attendanceIdInput.name = 'attendanceId';
                    attendanceIdInput.value = '${attendance.id}';
                    
                    form.appendChild(latInput);
                    form.appendChild(lngInput);
                    form.appendChild(attendanceIdInput);
                    
                    document.body.appendChild(form);
                    form.submit();
                }, function(error) {
                    alert('获取位置信息失败：' + error.message);
                });
            } else {
                alert('您的浏览器不支持GPS定位功能');
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <h2>考勤签到</h2>
        
        <div class="attendance-info">
            <div class="info-item">
                <span class="info-label">课程名称：</span>
                <span>${attendance.courseName}</span>
            </div>
            <div class="info-item">
                <span class="info-label">开始时间：</span>
                <span>${attendance.startTime}</span>
            </div>
            <div class="info-item">
                <span class="info-label">结束时间：</span>
                <span>${attendance.endTime}</span>
            </div>
        </div>
        
        <c:if test="${attendance.status eq 1}">
            <div class="qrcode-container">
                <h3>扫描二维码签到</h3>
                <div class="qrcode">
                    <img id="qrcode-img" src="/teacher/attendance/qrcode?id=${attendance.id}" alt="签到二维码" width="200" height="200">
                </div>
                <p style="margin-top: 10px; color: #666; font-size: 14px;">二维码每30秒自动更新</p>
            </div>
            
            <div class="status status-pending">
                请扫描上方二维码或使用GPS定位签到
            </div>
            
            <button onclick="signWithGPS()">使用GPS定位签到</button>
        </c:if>
        
        <c:if test="${attendance.status eq 0}">
            <div class="status status-error">
                该考勤已结束，无法签到
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        
        <c:if test="${not empty success}">
            <div class="status status-success">
                ${success}
            </div>
        </c:if>
    </div>
</body>
</html>
