<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>出勤率统计</title>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            text-align: center;
        }

        .header h1 {
            color: #667eea;
            font-size: 32px;
            margin-bottom: 10px;
        }

        .header p {
            color: #666;
            font-size: 16px;
        }

        .nav-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 20px;
        }

        .nav-btn {
            padding: 12px 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .nav-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .card-title {
            font-size: 20px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #667eea;
        }

        .filter-section {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: center;
            margin-bottom: 20px;
        }

        .filter-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .filter-label {
            font-size: 14px;
            color: #666;
            font-weight: 500;
        }

        .filter-input {
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            outline: none;
            transition: border-color 0.3s;
        }

        .filter-input:focus {
            border-color: #667eea;
        }

        .filter-btn {
            padding: 10px 25px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .filter-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .stat-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .stat-item {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }

        .stat-value {
            font-size: 32px;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 5px;
        }

        .stat-label {
            font-size: 14px;
            color: #666;
        }

        .chart-container {
            width: 100%;
            height: 400px;
        }

        .error-message {
            background: #fee;
            color: #c33;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            font-size: 16px;
        }

        @media (max-width: 768px) {
            .header h1 {
                font-size: 24px;
            }

            .nav-buttons {
                flex-direction: column;
            }

            .filter-section {
                flex-direction: column;
                align-items: stretch;
            }

            .stat-grid {
                grid-template-columns: 1fr 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>出勤率统计</h1>
            <p>查看班级整体出勤情况和趋势分析</p>
            <div class="nav-buttons">
                <a href="/teacher/class" class="nav-btn">返回班级管理</a>
                <a href="/teacher/class/knowledge" class="nav-btn">知识点掌握</a>
                <a href="/teacher/dashboard" class="nav-btn">返回主页</a>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>

        <c:if test="${empty error}">
            <div class="card">
                <div class="card-title">数据筛选</div>
                <div class="filter-section">
                    <div class="filter-group">
                        <label class="filter-label">开始日期：</label>
                        <input type="date" id="startDate" class="filter-input" value="${startDate}">
                    </div>
                    <div class="filter-group">
                        <label class="filter-label">结束日期：</label>
                        <input type="date" id="endDate" class="filter-input" value="${endDate}">
                    </div>
                    <button class="filter-btn" onclick="updateChart()">更新图表</button>
                </div>
            </div>

            <div class="card">
                <div class="card-title">出勤率概览</div>
                <div class="stat-grid">
                    <div class="stat-item">
                        <div class="stat-value">
                            <c:if test="${not empty attendanceData}">
                                ${attendanceData.attendanceRate}%
                            </c:if>
                            <c:if test="${empty attendanceData}">
                                --
                            </c:if>
                        </div>
                        <div class="stat-label">总体出勤率</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">
                            <c:if test="${not empty attendanceData}">
                                ${attendanceData.totalAttendance}
                            </c:if>
                            <c:if test="${empty attendanceData}">
                                --
                            </c:if>
                        </div>
                        <div class="stat-label">总出勤次数</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">
                            <c:if test="${not empty attendanceData}">
                                ${attendanceData.totalAbsent}
                            </c:if>
                            <c:if test="${empty attendanceData}">
                                --
                            </c:if>
                        </div>
                        <div class="stat-label">总缺勤次数</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">
                            <c:if test="${not empty attendanceData}">
                                ${attendanceData.totalStudents}
                            </c:if>
                            <c:if test="${empty attendanceData}">
                                --
                            </c:if>
                        </div>
                        <div class="stat-label">班级人数</div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-title">出勤率趋势图</div>
                <div id="attendanceChart" class="chart-container"></div>
            </div>
        </c:if>
    </div>

    <c:if test="${not empty attendanceData and empty error}">
        <script>
            var attendanceChart = echarts.init(document.getElementById('attendanceChart'));

            var option = {
                tooltip: {
                    trigger: 'axis',
                    axisPointer: {
                        type: 'shadow'
                    }
                },
                legend: {
                    data: ['出勤', '缺勤']
                },
                grid: {
                    left: '3%',
                    right: '4%',
                    bottom: '3%',
                    containLabel: true
                },
                xAxis: {
                    type: 'category',
                    data: ['出勤', '缺勤']
                },
                yAxis: {
                    type: 'value'
                },
                series: [
                    {
                        name: '出勤',
                        type: 'bar',
                        data: [
                            {
                                value: ${attendanceData.totalAttendance},
                                itemStyle: {
                                    color: '#5470c6'
                                }
                            },
                            {
                                value: 0,
                                itemStyle: {
                                    color: '#5470c6'
                                }
                            }
                        ]
                    },
                    {
                        name: '缺勤',
                        type: 'bar',
                        data: [
                            {
                                value: 0,
                                itemStyle: {
                                    color: '#ff6b6b'
                                }
                            },
                            {
                                value: ${attendanceData.totalAbsent},
                                itemStyle: {
                                    color: '#ff6b6b'
                                }
                            }
                        ]
                    }
                ]
            };

            attendanceChart.setOption(option);

            window.addEventListener('resize', function() {
                attendanceChart.resize();
            });

            function updateChart() {
                var startDate = document.getElementById('startDate').value;
                var endDate = document.getElementById('endDate').value;

                if (startDate && endDate) {
                    window.location.href = '/teacher/class/attendance?startDate=' + startDate + '&endDate=' + endDate;
                }
            }
        </script>
    </c:if>
</body>
</html>
