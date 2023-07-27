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
                <th colspan="4">커팅 사이즈</th>
            </tr>
</table>
<div id="chart-container1" style="height: 100%"></div>
<script>
$(document).ready(function() {
    var num = [];
    var csize = [];

    function updateData() {
        $.ajax({
            url: "p1/getDataCsize.jsp",
            type: "GET",
            dataType: "json",
            success: function(data) {
                num = [];
                csize = [];

                for (var i = Math.max(0, data.length - 200); i < data.length; i++) {
                    var item = data[i];
                    if (item.num && item.csize) {
                        num.push(item.num);
                        csize.push(item.csize);
                    }
                }

                // Refresh the chart
                myChart.setOption({
                    xAxis: {
                        data: num
                    },
                    series: [
                        {
                            data: csize,
                            symbol: 'none'
                        }
                    ]
                });
            },
            error: function(xhr, status, error) {
                console.log("Error: " + error);
            }
        });
    }

    var dom = document.getElementById('chart-container1');
    var myChart = echarts.init(dom, null, {
        renderer: 'canvas',
        useDirtyRect: false
    });

    var option = {
        xAxis: {
            type: 'category',
            data: []
        },
        yAxis: {
            type: 'value',
            min: 120,
            max: 180,
            interval: 20
        },
        series: [
            {
                data: [],
                type: 'line'
            }
        ]
    };

    if (option && typeof option === 'object') {
        myChart.setOption(option);
    }

    window.addEventListener('resize', myChart.resize);

    updateData();
    setInterval(updateData, 2000);
});
</script>

</body>
</html>