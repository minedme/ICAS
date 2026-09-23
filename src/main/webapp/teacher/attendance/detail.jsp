<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>考勤详情 - 智能课堂系统</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1000px;
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
        .detail-info {
            margin-bottom: 30px;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 8px;
        }
        .detail-info p {
            margin: 10px 0;
            font-size: 16px;
        }
        .detail-info label {
            font-weight: bold;
            color: #555;
            margin-right: 10px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
            font-weight: bold;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .status {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-present {
            background-color: #4CAF50;
            color: white;
        }
        .status-absent {
            background-color: #f44336;
            color: white;
        }
        .btn-back {
            display: inline-block;
            padding: 10px 20px;
            background-color: #2196F3;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        .btn-back:hover {
            background-color: #1976D2;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="/teacher/attendance/list" class="btn-back">返回考勤列表</a>
        <h2>考勤详情</h2>
        
        <div class="detail-info">
            <p><label>考勤ID：</label>${attendance.id}</p>
            <p><label>课程名称：</label>${attendance.courseName}</p>
            <p><label>开始时间：</label>${attendance.startTime}</p>
            <p><label>结束时间：</label>${attendance.endTime}</p>
            <p><label>状态：</label>
                <span class="status status-${attendance.status eq 1 ? 'present' : 'absent'}">
                    ${attendance.status eq 1 ? '进行中' : '已结束'}
                </span>
            </p>
        </div>
        
        <h3>考勤记录</h3>
        <table>
            <thead>
                <tr>
                    <th>学生ID</th>
                    <th>学生姓名</th>
                    <th>签到时间</th>
                    <th>状态</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${records}" var="record">
                    <tr>
                        <td>${record.studentId}</td>
                        <td>${record.studentName}</td>
                        <td>${record.checkinTime}</td>
                        <td>
                            <span class="status status-present">
                                已签到
                            </span>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <c:if test="${empty records}">
            <p style="text-align: center; color: #999; margin-top: 50px;">暂无考勤记录</p>
        </c:if>
    </div>
</body>
</html>