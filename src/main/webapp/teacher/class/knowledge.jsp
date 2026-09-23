<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>知识点掌握</title>
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

        .legend {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .legend-color {
            width: 20px;
            height: 20px;
            border-radius: 4px;
        }

        .legend-text {
            font-size: 14px;
            color: #666;
        }

        .chart-container {
            width: 100%;
            height: 500px;
        }

        .knowledge-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }

        .knowledge-item {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            padding: 20px;
            border-radius: 10px;
            transition: transform 0.3s;
        }

        .knowledge-item:hover {
            transform: translateY(-5px);
        }

        .knowledge-name {
            font-size: 16px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }

        .knowledge-stats {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .knowledge-stat {
            font-size: 14px;
            color: #666;
        }

        .mastery-bar {
            width: 100%;
            height: 10px;
            background: #e0e0e0;
            border-radius: 5px;
            overflow: hidden;
        }

        .mastery-progress {
            height: 100%;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            border-radius: 5px;
            transition: width 0.3s;
        }

        .mastery-label {
            font-size: 14px;
            color: #667eea;
            font-weight: bold;
            margin-top: 5px;
        }

        .error-message {
            background: #fee;
            color: #c33;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            font-size: 16px;
        }

        .empty-message {
            background: #f8f9fa;
            color: #666;
            padding: 30px;
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

            .knowledge-list {
                grid-template-columns: 1fr;
            }

            .chart-container {
                height: 400px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>知识点掌握情况</h1>
            <p>查看班级学生在不同知识点上的掌握程度分布</p>
            <div class="nav-buttons">
                <a href="/teacher/class" class="nav-btn">返回班级管理</a>
                <a href="/teacher/class/attendance" class="nav-btn">出勤率统计</a>
                <a href="/teacher/dashboard" class="nav-btn">返回主页</a>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>

        <c:if test="${empty error}">
            <c:if test="${empty knowledgeData}">
                <div class="empty-message">
                    暂无知识点数据，请先创建测验并让学生完成答题
                </div>
            </c:if>

            <c:if test="${not empty knowledgeData}">
                <div class="card">
                    <div class="card-title">知识点掌握热力图</div>
                    <div class="legend">
                        <div class="legend-item">
                            <div class="legend-color" style="background: #ff6b6b;"></div>
                            <span class="legend-text">掌握度 0-40% (需要加强)</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color" style="background: #ffa500;"></div>
                            <span class="legend-text">掌握度 40-60% (一般)</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color" style="background: #91cc75;"></div>
                            <span class="legend-text">掌握度 60-80% (良好)</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color" style="background: #5470c6;"></div>
                            <span class="legend-text">掌握度 80-100% (优秀)</span>
                        </div>
                    </div>
                    <div id="knowledgeChart" class="chart-container"></div>
                </div>

                <div class="card">
                    <div class="card-title">知识点详细列表</div>
                    <div class="knowledge-list">
                        <c:forEach items="${knowledgeData}" var="item">
                            <div class="knowledge-item">
                                <div class="knowledge-name">${item.name}</div>
                                <div class="knowledge-stats">
                                    <span class="knowledge-stat">总答题数: ${item.total}</span>
                                    <span class="knowledge-stat">正确数: ${item.correct}</span>
                                </div>
                                <div class="mastery-bar">
                                    <div class="mastery-progress" style="width: ${item.masteryRate}%"></div>
                                </div>
                                <div class="mastery-label">掌握度: ${item.masteryRate}%</div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
        </c:if>
    </div>

    <c:if test="${not empty knowledgeData and empty error}">
        <script>
            var knowledgeChart = echarts.init(document.getElementById('knowledgeChart'));
            
            var knowledgeData = [
                <c:forEach items="${knowledgeData}" var="item" varStatus="status">
                    {
                        name: '${item.name}',
                        value: ${item.masteryRate},
                        total: ${item.total},
                        correct: ${item.correct}
                    }${not status.last ? ',' : ''}
                </c:forEach>
            ];

            var option = {
                tooltip: {
                    trigger: 'item',
                    formatter: function(params) {
                        return params.name + '<br/>' +
                               '掌握度: ' + params.value.toFixed(1) + '%<br/>' +
                               '总答题数: ' + params.data.total + '<br/>' +
                               '正确数: ' + params.data.correct;
                    }
                },
                visualMap: {
                    min: 0,
                    max: 100,
                    text: ['高', '低'],
                    realtime: false,
                    calculable: true,
                    inRange: {
                        color: ['#ff6b6b', '#ffa500', '#91cc75', '#5470c6']
                    }
                },
                series: [{
                    name: '知识点掌握度',
                    type: 'pie',
                    radius: ['30%', '70%'],
                    center: ['50%', '50%'],
                    roseType: 'area',
                    itemStyle: {
                        borderRadius: 8
                    },
                    label: {
                        show: true,
                        formatter: '{b}: {c}%'
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
