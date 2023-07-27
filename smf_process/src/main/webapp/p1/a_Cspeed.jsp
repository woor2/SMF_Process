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
                <th colspan="4">커팅 속도</th>
            </tr>
</table>
<div id="chart-container" style="width: 100%; height: 100%;"></div>
   <script>
$(document).ready(function() {
    function updateData() {
        $.ajax({
            url: "p1/getDataCspeed.jsp",
            type: "GET",
            dataType: "json",
            success: function(data) {
                var cValue = 0; // 기본값 설정

                if (data.cspeed1) {
                    cValue = data.cspeed1;
                }

                var dom = document.getElementById('chart-container');
                var myChart = echarts.init(dom, null, {
                    renderer: 'canvas',
                    useDirtyRect: false
                });
                var app = {};
                var option;

                option = {
                    series: [
                        {
                            type: 'gauge',
                            startAngle: 180,
                            endAngle: 0,
                            center: ['50%', '75%'],
                            radius: '90%',
                            min: 0,
                            max: 2,
                            splitNumber: 8,
                            axisLine: {
                                lineStyle: {
                                    width: 6,
                                    color: [
                                        [0.5, '#579'],
                                        [1, '#579']
                                    ]
                                }
                            },
                            pointer: {
                                icon: 'path://M12.8,0.7l12,40.1H0.7L12.8,0.7z',
                                length: '12%',
                                width: 20,
                                offsetCenter: [0, '-60%'],
                                itemStyle: {
                                    color: 'auto'
                                }
                            },
                            axisTick: {
                                length: 12,
                                lineStyle: {
                                    color: 'auto',
                                    width: 2
                                }
                            },
                            splitLine: {
                                length: 20,
                                lineStyle: {
                                    color: 'auto',
                                    width: 5
                                }
                            },
                            axisLabel: {
                                color: '#464646',
                                fontSize: 20,
                                distance: -60,
                                rotate: 'tangential',
                                formatter: function (value) {
                                    if (value === 0.1) {
                                        return 'Grade A';
                                    } else if (value === 0.2) {
                                        return 'Grade B';
                                    } else if (value === 0.3) {
                                        return 'Grade C';
                                    }
                                    return '';
                                }
                            },
                            title: {
                                offsetCenter: [0, '-10%'],
                                fontSize: 20
                            },
                            detail: {
                                fontSize: 30,
                                offsetCenter: [0, '-35%'],
                                valueAnimation: true,
                                formatter: function (value) {
                                    return Math.round(value * 1) + '';
                                },
                                color: 'inherit'
                            },
                            data: [
                                {
                                    value: cValue,
                                    name: 'Cutting Speed'
                                }
                            ]
                        }
                    ]
                };

                if (option && typeof option === 'object') {
                    myChart.setOption(option);
                }

                window.addEventListener('resize', function () {
                    myChart.resize();
                });
            },
            error: function(xhr, status, error) {
                console.log("AJAX Error: " + status + " - " + error);
            }
        });
    }

    updateData();
    setInterval(updateData, 500);
});
</script>
    
</body>
</html>