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
                <th colspan="4">가동률</th>
            </tr>
</table>
<div id="gaugeChart" style="width: 100%; height: 100%;"></div>
<script>
$(document).ready(function() {
    function updateData() {
        $.ajax({
            url: "p1/getDataOperate.jsp",
            type: "GET",
            dataType: "json",
            success: function(data) {
                if (data.c) {
                    var cValue = data.c;
                    var gaugeChart = echarts.init(document.getElementById('gaugeChart'));

                    var option = {
                        series: [{
                            type: 'gauge',
                            progress: {
                                show: true,
                                width: 18
                            },
                            axisLine: {
                                lineStyle: {
                                    width: 18
                                }
                            },
                            pointer: {
                                show: false
                            },
                            axisTick: {
                                show: false
                            },
                            axisLabel: {
                                show: false
                            },
                            splitLine: {
                                length: 12,
                                lineStyle: {
                                    width: 2,
                                    color: '#999'
                                }
                            },
                            title: {
                                offsetCenter: [0, '90%'],
                                fontSize: 16
                            },
                            detail: {
                                offsetCenter: [0, '40%'],
                                fontSize: 24,
                                fontWeight: 'bold',
                                formatter: '{value}%'
                            },
                            data: [{
                                value: cValue // JavaScript 변수를 사용합니다.
                            }]
                        }]
                    };

                    gaugeChart.setOption(option);
                    window.addEventListener('resize', gaugeChart.resize);
                }
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