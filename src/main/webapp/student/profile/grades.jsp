<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>成绩变化曲线 - 智能课堂系统</title>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background-color: #f5f7fa;
            padding: 20px;
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .header h1 {
            margin: 0;
            font-size: 28px;
        }
        .back-btn {
            display: inline-block;
            padding: 10px 20px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 1px solid white;
            border-radius: 5px;
            text-decoration: none;
            margin-top: 10px;
            font-size: 14px;
            transition: all 0.3s;
        }
        .back-btn:hover {
            background: white;
            color: #667eea;
        }
        .card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
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
            background: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .filter-row {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }
        .filter-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .filter-label {
            font-weight: bold;
            color: #555;
            min-width: 80px;
        }
        .filter-select {
            padding: 8px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            min-width: 150px;
            background: white;
            cursor: pointer;
        }
        .filter-input {
            padding: 8px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            min-width: 150px;
        }
        .filter-btn {
            padding: 10px 25px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            transition: all 0.3s;
        }
        .filter-btn:hover {
            background: #764ba2;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(102, 126, 234, 0.3);
        }
        .chart-container {
            width: 100%;
            height: 500px;
            background: #f9f9f9;
            border-radius: 8px;
            padding: 20px;
        }
        .legend {
            display: flex;
            gap: 20px;
            margin-bottom: 15px;
            justify-content: center;
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
        @media (max-width: 768px) {
            .filter-row {
                flex-direction: column;
                align-items: flex-start;
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
            <h1>成绩变化曲线</h1>
            <a href="/student/profile" class="back-btn">返回档案首页</a>
        </div>

        <div class="card">
            <div class="card-title">数据筛选</div>
            <div class="filter-section">
                <div class="filter-row">
                    <div class="filter-group">
                        <label class="filter-label">课程：</label>
                        <select id="courseSelect" class="filter-select" onchange="updateChart()">
                            <option value="">全部课程</option>
                            <c:forEach items="${courses}" var="course">
                                <option value="${course}" ${selectedCourse eq course ? 'selected' : ''}>${course}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label class="filter-label">开始日期：</label>
                        <input type="date" id="startDate" class="filter-input" value="${startDate}" onchange="updateChart()">
                    </div>
                    <div class="filter-group">
                        <label class="filter-label">结束日期：</label>
                        <input type="date" id="endDate" class="filter-input" value="${endDate}" onchange="updateChart()">
                    </div>
                    <button class="filter-btn" onclick="updateChart()">更新图表</button>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-title">成绩变化曲线</div>
            <div class="legend">
                <div class="legend-item">
                    <div class="legend-color" style="background: #5470c6;"></div>
                    <span class="legend-text">得分</span>
                </div>
                <div class="legend-item">
                    <div class="legend-color" style="background: #91cc75;"></div>
                    <span class="legend-text">正确</span>
                </div>
                <div class="legend-item">
                    <div class="legend-color" style="background: #ff6b6b;"></div>
                    <span class="legend-text">错误</span>
                </div>
            </div>
            <div id="gradeChart" class="chart-container"></div>
        </div>
    </div>

    <script>
        var gradeData = ${gradeData != null ? '[]' : gradeData};
        var chart;

        function initChart() {
            var chartDom = document.getElementById('gradeChart');
            chart = echarts.init(chartDom);

            var dates = gradeData.map(function(item) {
                return item.date;
            });

            var scores = gradeData.map(function(item) {
                return item.score;
            });

            var isCorrectData = gradeData.map(function(item) {
                return item.isCorrect ? 1 : 0;
            });

            var option = {
                title: {
                    text: '成绩变化曲线',
                    left: 'center',
                    textStyle: {
                        fontSize: 18,
                        fontWeight: 'bold'
                    }
                },
                tooltip: {
                    trigger: 'axis',
                    formatter: function(params) {
                        var date = params[0].name;
                        var score = params[0].value;
                        var isCorrect = gradeData[params[0].dataIndex].isCorrect;
                        var status = isCorrect ? '正确' : '错误';
                        return '日期: ' + date + '<br/>' + '得分: ' + score + '<br/>' + '状态: ' + status;
                    }
                },
                legend: {
                    data: ['得分', '正确', '错误'],
                    top: 10
                },
                grid: {
                    left: '3%',
                    right: '4%',
                    bottom: '3%',
                    containLabel: true
                },
                xAxis: {
                    type: 'category',
                    data: dates,
                    axisLabel: {
                        rotate: 45,
                        interval: 0
                    },
                    axisLine: {
                        lineStyle: {
                            color: '#666'
                        }
                    }
                },
                yAxis: [
                    {
                        type: 'value',
                        name: '得分',
                        position: 'left',
                        axisLine: {
                            lineStyle: {
                                color: '#666'
                            }
                        },
                        splitLine: {
                            lineStyle: {
                                color: '#eee'
                            }
                        }
                    },
                    {
                        type: 'value',
                        name: '正确/错误',
                        position: 'right',
                        min: 0,
                        max: 1,
                        axisLabel: {
                            formatter: function(value) {
                                return value === 1 ? '正确' : '错误';
                            }
                        },
                        axisLine: {
                            lineStyle: {
                                color: '#666'
                            }
                        },
                        splitLine: {
                            lineStyle: {
                                color: '#eee'
                            }
                        }
                    }
                ],
                series: [
                    {
                        name: '得分',
                        type: 'line',
                        yAxisIndex: 0,
                        data: scores,
                        smooth: true,
                        itemStyle: {
                            color: '#5470c6'
                        },
                        lineStyle: {
                            width: 3
                        },
                        areaStyle: {
                            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                                {offset: 0, color: 'rgba(84, 112, 198, 0.3)'},
                                {offset: 1, color: 'rgba(84, 112, 198, 0.05)'}
                            ])
                        },
                        markPoint: {
                            data: scores.map(function(score, index) {
                                return {
                                    value: score,
                                    itemStyle: {
                                        color: gradeData[index].isCorrect ? '#91cc75' : '#ff6b6b'
                                    }
                                };
                            })
                        }
                    },
                    {
                        name: '正确',
                        type: 'scatter',
                        yAxisIndex: 1,
                        data: isCorrectData,
                        itemStyle: {
                            color: '#91cc75'
                        },
                        symbolSize: 10
                    },
                    {
                        name: '错误',
                        type: 'scatter',
                        yAxisIndex: 1,
                        data: isCorrectData.map(function(val) {
                            return 1 - val;
                        }),
                        itemStyle: {
                            color: '#ff6b6b'
                        },
                        symbolSize: 10
                    }
                ],
                animationEasing: 'elasticOut',
                animationDelayUpdate: function (idx) {
                    return idx * 100;
                }
            };

            chart.setOption(option);

            window.addEventListener('resize', function() {
                chart.resize();
            });
        }

        function updateChart() {
            var course = document.getElementById('courseSelect').value;
            var startDate = document.getElementById('startDate').value;
            var endDate = document.getElementById('endDate').value;

            var url = '/student/profile/grades';
            if (course) {
                url += '?course=' + course;
            }
            if (startDate) {
                url += '&startDate=' + startDate;
            }
            if (endDate) {
                url += '&endDate=' + endDate;
            }

            window.location.href = url;
        }

        window.onload = function() {
            initChart();
        };
    </script>
</body>
</html>
