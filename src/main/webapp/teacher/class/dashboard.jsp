<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>班级管理</title>
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

        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 20px;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .card-title {
            font-size: 20px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #667eea;
        }

        .stat-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
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
            height: 300px;
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

            .cards {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>班级管理</h1>
            <p>查看班级整体学习情况和数据分析</p>
            <div class="nav-buttons">
                <a href="/teacher/class/attendance" class="nav-btn">出勤率统计</a>
                <a href="/teacher/class/knowledge" class="nav-btn">知识点掌握</a>
                <a href="/teacher/dashboard" class="nav-btn">返回主页</a>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>

        <c:if test="${empty error}">
            <div class="cards">
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
                    <div class="card-title">知识点掌握情况</div>
                    <div id="knowledgeChart" class="chart-container"></div>
                </div>
            </div>
        </c:if>
    </div>

    <c:if test="${not empty knowledgeData and empty error}">
        <script>
            var knowledgeChart = echarts.init(document.getElementById('knowledgeChart'));
            
            var knowledgeData = [
                <c:forEach items="${knowledgeData}" var="item" varStatus="status">
                    {
                        name: '${item.name}',
                        value: ${item.masteryRate}
                    }${not status.last ? ',' : ''}
                </c:forEach>
            ];

            var option = {
                tooltip: {
                    trigger: 'item',
                    formatter: function(params) {
                        return params.name + ': ' + params.value.toFixed(1) + '%';
                    }
                },
                series: [{
                    type: 'pie',
                    radius: ['40%', '70%'],
                    avoidLabelOverlap: false,
                    itemStyle: {
                        borderRadius: 10,
                        borderColor: '#fff',
                        borderWidth: 2
                    },
                    label: {
                        show: true,
                        formatter: '{b}: {c}%'
                    },
                    emphasis: {
                        label: {
                            show: true,
                            fontSize: 16,
                            fontWeight: 'bold'
                        }
                    },
                    data: knowledgeData
                }]
            };

            knowledgeChart.setOption(option);

            window.addEventListener('resize', function() {
                knowledgeChart.resize();
            });
        </script>
    </c:if>
</body>
</html>
