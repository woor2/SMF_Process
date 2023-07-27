<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection, java.sql.Statement, java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager, java.sql.SQLException, config.OracleInfo" %>
<%@ page import="java.util.ArrayList, java.util.List" %>
<%@ page import="org.json.simple.JSONArray, org.json.simple.JSONObject" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Chart</title>
  <style>
    * {
      margin: 0;
      padding: 0;
    }
    #c_chart-container {
      position: relative;
      height: 100%;
      width: 100%;
      overflow: hidden;
    }
  </style>
</head>
<body>
  <div id="c_chart-container"></div>
  <script src="https://cdn.jsdelivr.net/npm/echarts@5/dist/echarts.min.js"></script>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- jQuery 라이브러리 추가 -->
  <script type="text/javascript">
    var dom = document.getElementById('c_chart-container');
    var DynamicDataChart = echarts.init(dom, null, {
      renderer: 'canvas',
      useDirtyRect: false
    });
    var app = {};

    var option;

    var MAX_DATA_POINTS = 10; // 최대 데이터 포인트 수

    option = {
      title: {
        text: '차트'
      },
      tooltip: {
        trigger: 'axis',
        axisPointer: {
          type: 'cross',
          label: {
            backgroundColor: '#283b56'
          }
        }
      },
      legend: {},
      toolbox: {
        show: true,
        feature: {
          dataView: { readOnly: false },
          restore: {},
          saveAsImage: {}
        }
      },
      dataZoom: {
        show: false,
        start: 0,
        end: 100
      },
      xAxis: {
        type: 'category',
        boundaryGap: true,
        data: [] // 초기값은 빈 배열로 설정
      },
      yAxis: [
        {
          type: 'value',
          scale: true,
          name: '℃',
          max: 60,
          min: 0,
          boundaryGap: [0.2, 0.2]
        },
        {
          type: 'value',
          scale: true,
          name: 'g',
          max: 600,
          min: 0,
          boundaryGap: [0.2, 0.2]
        }
      ],
      series: [
        {
          name: '온도',
          type: 'line',
          yAxisIndex: 0,
          data: [] // 초기값은 빈 배열로 설정
        },
        {
          name: '무게',
          type: 'line',
          yAxisIndex: 1,
          data: [] // 초기값은 빈 배열로 설정
        },
        {
          name: '성공',
          type: 'bar',
          yAxisIndex: 1,
          data: [] // 초기값은 빈 배열로 설정
        },
        {
          name: '실패',
          type: 'bar',
          yAxisIndex: 1,
          data: []
    	}
      ]
    };

    function fetchData() {
      $.ajax({
        url: 'p3/getData2.jsp',
        type: 'GET',
        dataType: 'json',
        success: function(response) {
          var data = response; // JSON 데이터를 가져옴

          // 데이터 업데이트
          var categories = [];
          var temperatureData = [];
          var weightData = [];
          var successData = [];
          var failData = [];

          for (var i = data.length - 1; i >= 0; i--) {
            var time = parseTime(data[i].time3); // 시간 값을 파싱하여 형식화
            var temperature = data[i].temperature;
            var weight = data[i].weight;
            var success = data[i].tf3 === 1 ? 600 : undefined; // TF3 값이 1이면 무게를 성공 데이터로 표시
            var fail = data[i].error === "무게 에러 입니다." ? weight : temperature ;

            categories.unshift(time); // 시간 값을 x축 앞에 추가 (time3 필드 사용)
            temperatureData.unshift(temperature); // 온도 값을 series 앞에 추가
            weightData.unshift(weight); // 무게 값을 series 앞에 추가
            successData.unshift(success); // 성공 값을 series 앞에 추가
            failData.unshift(fail);

            // 최대 데이터 포인트 수를 유지하기 위해 데이터 배열의 길이를 조정
            if (categories.length > MAX_DATA_POINTS) {
              categories.pop();
              temperatureData.pop();
              weightData.pop();
              successData.pop();
              failData.pop();
            }
          }

          option.xAxis.data = categories; // x축 데이터 업데이트
          option.series[0].data = temperatureData; // 시리즈 데이터 업데이트
          option.series[1].data = weightData; // 시리즈 데이터 업데이트
          option.series[2].data = successData; // 시리즈 데이터 업데이트
          option.series[3].data = failData;

          DynamicDataChart.setOption(option);
        },
        error: function(xhr, status, error) {
          console.error(error);
        }
      });
    }

    // 시간 형식 변환 함수 추가
    function parseTime(time) {
      // 시간 형식에 맞게 파싱하여 반환
      var parts = time.split(/[- :]/);
      var year = parseInt(parts[0]);
      var month = parseInt(parts[1]) - 1;
      var day = parseInt(parts[2]);
      var hour = parseInt(parts[3]);
      var minute = parseInt(parts[4]);
      var second = parseInt(parts[5]);

      return new Date(year, month, day, hour, minute, second);
    }

    $(document).ready(function() {
      fetchData();
      setInterval(fetchData, 2000);
    });

    if (option && typeof option === 'object') {
      DynamicDataChart.setOption(option);
    }
  </script>
</body>
</html>