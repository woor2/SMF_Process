<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.2/dist/echarts.min.js"></script>
    <script type="text/javascript" src="https://fastly.jsdelivr.net/npm/echarts@5.4.2/dist/echarts.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="https://fastly.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
</head>
<body>
    <table>
        <tr>
            <th colspan="4">공정별 불량률</th>
        </tr>
    </table>
    <div id="bar" style="width: 100%; height: 100%;"></div>
    <script type="text/javascript">
        $(document).ready(function () {
            function updateData() {
                $.ajax({
                    url: "error/errorData2.jsp",
                    type: "GET",
                    dataType: "json",
                    success: function (data) {
                        // Update chart data
                        updateChart(data);
                    },
                    error: function (xhr, status, error) {
                        console.log("AJAX Error: " + status + " - " + error);
                    }
                });
            }

            function updateChart(data) {
                var dom = document.getElementById('bar');
                var myChart = echarts.init(dom, null, {
                    renderer: 'canvas',
                    useDirtyRect: false
                });

                var option = {
                    xAxis: {
                        type: 'category',
                        data: ['1공정', '2공정', '3공정']
                    },
                    yAxis: {
                        type: 'value'
                    },
                    series: [
                        {
                            data: [data.a_process, data.b_process, data.c_process],
                            type: 'bar',
                            label: {
                                show: true,
                                position: 'top',
                                color: 'black',
                                formatter: '{c}',
                            },
                        }
                    ]
                };

                if (option && typeof option === 'object') {
                    myChart.setOption(option);
                }

                window.addEventListener('resize', myChart.resize);
            }

            // 초기 데이터 로드
            updateData();

            // 일정 시간마다 데이터 업데이트
            setInterval(function () {
                updateData();
            }, 2000);
        });
    </script>

</body>
</html>
