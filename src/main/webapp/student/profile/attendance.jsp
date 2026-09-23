<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>出勤趋势 - 智能课堂系统</title>
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
            <h1>出勤趋势分析</h1>
            <a href="/student/profile" class="back-btn">返回档案首页</a>
        </div>

        <div class="card">
            <div class="card-title">数据筛选</div>
            <div class="filter-section">
                <div class="filter-row">
                    <div class="filter-group">
                        <label class="filter-label">统计周期：</label>
                        <select id="periodSelect" class="filter-select" onchange="updateChart()">
                            <option value="daily" ${period eq 'daily' ? 'selected' : ''}>每日</option>
                            <option value="weekly" ${period eq 'weekly' ? 'selected' : ''}>每周</option>
                            <option value="monthly" ${period eq 'monthly' ? 'selected' : ''}>每月</option>
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
            <div class="card-title">出勤趋势图</div>
            <div class="legend">
                <div class="legend-item">
                    <div class="legend-color" style="background: #5470c6;"></div>
                    <span class="legend-text">出勤次数</span>
                </div>
                <div class="legend-item">
                    <div class="legend-color" style="background: #91cc75;"></div>
                    <span class="legend-text">缺勤次数</span>
                </div>
            </div>
            <div id="attendanceChart" class="chart-container"></div>
        </div>
    </div>

    <script>
        var attendanceData = ${attendanceData != null ? '[]' : attendanceData};
        var currentPeriod = '${period}';
        var chart;

        function initChart() {
            var chartDom = document.getElementById('attendanceChart');
            chart = echarts.init(chartDom);

            var dates = attendanceData.map(function(item) {
                return item.date;
            });

            var counts = attendanceData.map(function(item) {
                return item.count;
            });

            var option = {
                title: {
                    text: '出勤趋势图',
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
                        var count = params[0].value;
                        var status = count > 0 ? '出勤' : '缺勤';
                        return '日期: ' + date + '<br/>' + '状态: ' + status + '<br/>' + '次数: ' + count;
                    }
                },
                legend: {
                    data: ['出勤次数'],
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
                yAxis: {
                    type: 'value',
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
                series: [{
                    name: '出勤次数',
                    type: 'bar',
                    data: counts,
                    itemStyle: {
                        color: function(params) {
                            return params.value > 0 ? '#5470c6' : '#ff6b6b';
                        }
                    },
                    barWidth: '60%',
                    label: {
                        show: true,
                        position: 'top',
                        formatter: function(params) {
                            return params.value;
                        }
                    },
                    animationDelay: function (idx) {
                        return idx * 100;
                    },
                    animationEasing: 'elasticOut',
                    animationDelayUpdate: function (idx) {
                        return idx * 5;
                    }
                }]
            };

            chart.setOption(option);

            window.addEventListener('resize', function() {
                chart.resize();
            });
        }

        function updateChart() {
            var period = document.getElementById('periodSelect').value;
            var startDate = document.getElementById('startDate').value;
            var endDate = document.getElementById('endDate').value;

            var url = '/student/profile/attendance?period=' + period;
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
