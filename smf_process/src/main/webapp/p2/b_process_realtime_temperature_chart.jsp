<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection, java.sql.Statement, java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager, java.sql.SQLException, config.OracleInfo" %>
<%@ page import="java.util.List" %> <!-- 추가 -->
<%@ page import="java.util.ArrayList" %> <!-- 추가 -->
<%@ page import="com.google.gson.Gson" %> <!-- 추가 -->
<%@ page import="org.json.simple.JSONObject" %>

<!DOCTYPE html>
<html>
<head>
    <title>2공정 실시간 온도</title>
    <script type="text/javascript" src="static/echarts.min.js"></script>
    <script type="text/javascript" src="static/jquery.min.js"></script> <!-- jQuery 라이브러리 추가 -->
</head>
<body>
    <div id="b_process_realtime_temperature_chart" style="width:350px; height:350px;"></div>

    <script type="text/javascript">
        var dom1 = document.getElementById('b_process_realtime_temperature_chart');
        var myChart1 = echarts.init(dom1, null, {
            renderer: 'canvas',
            useDirtyRect: false
        });

        var option1;
        var temper = [];

        option1 = {
      	      title: {
      	        text: '2공정 실시간 온도',
    	        left : 'center',
    	        textStyle : {
    	        	fontSize: 20,
					  	fontWeight: 'bold',
				  	color: '#000'
    	        	}
      	      },
      		  series: [
      		    {
      		      type: 'gauge',
      		      center: ['50%', '60%'],
      		      startAngle: 200,
      		      endAngle: -20,
      		      min: 175,
      		      max: 185,
      		      splitNumber: 10,
      		      itemStyle: {
      		        color: '#FFAB91'
      		      },
      		      progress: {
      		        show: true,
      		        width: 30
      		      },
      		      pointer: {
      		        show: true
      		      },
      		      axisLine: {		//배경 게이지
      		        lineStyle: {
      		          width: 30
      		        }
      		      },
      		      axisTick: {		 //사이 눈금
      		    	show: true,  
      		        distance: 0,
      		        splitNumber: 5,
      		        lineStyle: {
      		          width: 1,
      		          color: '#999'
      		        }
      		      },
      		      splitLine: { 		//메인 눈금
      		        distance: 0,
      		        length: 10,
      		        lineStyle: {
      		          width: 2,
      		          color: '#999'
      		        }
      		      },
      		      axisLabel: {		//메인 눈금의 숫자
      		        distance: 35,
      		        color: '#999',
      		        fontSize: 11
      		      },
      		      anchor: {
      		        show: false
      		      },
      		      title: {
      		        show: false
      		      },
      		      detail: {
      		        valueAnimation: true,
      		        width: '60%',
      		        lineHeight: 40,
      		        borderRadius: 8,
      		        offsetCenter: [0, '40%'],
      		        fontSize: 30,
      		        fontWeight: 'bolder',
      		        formatter: '{value} °C',
      		        color: 'inherit'
      		      },
      		      data: [
      		        {
      		          value: temper[0]
      		        }
      		      ]
      		    },
      		    {
      		      type: 'gauge',
      		      center: ['50%', '60%'],
      		      startAngle: 200,
      		      endAngle: -20,
      		      min: 175,
      		      max: 185,
      		      itemStyle: {
      		        color: '#FD7347'
      		      },
      		      progress: {
      		        show: true,
      		        width: 8
      		      },
      		      pointer: {
      		        show: false
      		      },
      		      axisLine: {
      		        show: false
      		      },
      		      axisTick: {
      		        show: false
      		      },
      		      splitLine: {
      		        show: false
      		      },
      		      axisLabel: {
      		        show: false
      		      },
      		      detail: {
      		        show: false
      		      },
      		      data: [
      		        {
      		          value: temper[0]
      		        }
      		      ]
      		    }
      		  ]
      		};

        // 차트 업데이트 함수
        function updateChart1() {
        	$.ajax({
            	url: 'p2/b_process_realtime_temperature_chart_getData.jsp', // 온도 데이터를 반환하는 JSP 파일 경로
            	type: 'GET',
            	dataType: 'json',
            	success: function(data) {
            		console.log(data.temperature);
              		temper = data.temperature; // 온도 데이터 업데이트
              		option1.series[0].data[0].value = temper; // 차트 데이터 업데이트

              		myChart1.setOption(option1); // 차트 업데이트
            	},
            	error: function(xhr, status, error) {
              		console.error(error);
            	}
          	});
        }

        // 초기 차트 업데이트
        updateChart1();

        // 2초마다 차트 업데이트
        setInterval(function() {
          updateChart1();
        }, 2000);
        
        if (option1 && typeof option1 === 'object') {
            myChart1.setOption(option1);
        }
    </script>
</body>
</html>
