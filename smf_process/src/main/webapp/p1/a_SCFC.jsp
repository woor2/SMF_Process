<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.2/dist/echarts.min.js"></script>
    <script type="text/javascript" src="https://fastly.jsdelivr.net/npm/echarts@5.4.2/dist/echarts.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<table>
			<tr>
                <th colspan="4">성공 실패 차트</th>
            </tr>
</table>
<div id="chart-container2"></div>
    <script>
    $(document).ready(function() {
        function updateData() {
            $.ajax({
                url: "p1/getDataSCFC.jsp",
                type: "GET",
                dataType: "json",
                success: function(data) {
                    if (data.sc && data.fc) {
                        // Update chart data
                        sc.push(data.sc);
                        fc.push(data.fc);
                    }
                },
                error: function(xhr, status, error) {
                    console.log("AJAX Error: " + status + " - " + error);
                }
            });
        }

        var dom = document.getElementById('chart-container2');
        var myChart = echarts.init(dom, null, {
            renderer: 'canvas',
            useDirtyRect: false
        });

        var app = {};
        var option;
        var sc = [];
        var fc = [];

        option = {
            xAxis: {
                max: 'dataMax'
            },
            yAxis: {
                type: 'category',
                data: ['총성공', '총실패'],
                inverse: true,
                animationDuration: 500,
                animationDurationUpdate: 500,
                max: 1 // only the largest 3 bars will be displayed
            },
            series: [
                {
                    realtimeSort: true,
                    name: '수량',
                    type: 'bar',
                    data: [sc[0], fc[0]], // 초기 데이터 설정
                    label: {
                        show: true,
                        position: 'right',
                        valueAnimation: true
                    }
                }
            ],
            legend: {
                show: true
            },
            animationDuration: 500,
            animationDurationUpdate: 500,
            animationEasing: 'linear',
            animationEasingUpdate: 'linear'
        };

        function run() {
            myChart.setOption({
                series: [
                    {
                        data: [sc[sc.length - 1], fc[fc.length - 1]] // 최신 데이터 업데이트
                    }
                ]
            });
        }

        setTimeout(function () {
            run();
        }, 500);

        setInterval(function () {
            run();
        }, 500);

        if (option && typeof option === 'object') {
            myChart.setOption(option);
        }

        window.addEventListener('resize', function () {
            myChart.resize();
        });

        updateData(); // 초기 데이터 가져오기
        setInterval(updateData, 500); // 주기적으로 데이터 업데이트
    });
</script>
    
</body>
</html>