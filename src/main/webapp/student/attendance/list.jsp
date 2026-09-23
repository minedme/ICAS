<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>我的考勤记录 - 智能课堂系统</title>
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
        .status-late {
            background-color: #ff9800;
            color: white;
        }
        .attendance-rate {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border-radius: 4px;
            font-size: 18px;
            font-weight: bold;
            display: inline-block;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>我的考勤记录</h2>
        
        <div class="attendance-rate">
            出勤率：${attendanceRate}%
        </div>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>课程名称</th>
                    <th>考勤时间</th>
                    <th>签到时间</th>
                    <th>状态</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${attendanceRecords}" var="record">
                    <tr>
                        <td>${record.id != null ? record.id : '-'}</td>
                        <td>${record.courseName}</td>
                        <td>${record.attendanceDate}</td>
                        <td>${record.signTime != null ? record.signTime : '-'}</td>
                        <td>
                            <span class="status status-${record.status eq '正常' ? 'present' : (record.status eq '迟到' ? 'late' : (record.status eq '缺勤' ? 'absent' : 'absent'))}">
                                ${record.status}
                            </span>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <c:if test="${empty attendanceRecords}">
            <p style="text-align: center; color: #999; margin-top: 50px;">暂无考勤记录</p>
        </c:if>
    </div>
</body>
</html>
