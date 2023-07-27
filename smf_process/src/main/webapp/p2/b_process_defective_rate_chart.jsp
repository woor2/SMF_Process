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
    <title>2공정 불량품률</title>
    <script type="text/javascript" src="static/echarts.min.js"></script>
    <script type="text/javascript" src="static/jquery.min.js"></script> <!-- jQuery 라이브러리 추가 -->
</head>
<body>
    <div id="b_process_defective_rate_chart" style="width:350px; height:350px;"></div>
    
    <script type="text/javascript">
    var chartDom4 = document.getElementById('b_process_defective_rate_chart');
    var myChart4 = echarts.init(chartDom4, null, {
        renderer: 'canvas',
        useDirtyRect: false
    });
    var option4;
    
    var sc1;
    var sc2;
    var fc2;
    var num = [];
    
    option4 = {
    	      title: {
        	        text: '2공정 불량품률', //\n' +'(수량:'+fc2+')',
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
    		      progress: {
    		        show: true,
    		        width: 20,
    		        itemStyle: {
    		            color: '#ff0000' // 여기에 원하는 색상을 지정하세요.
    		          }
    		      },
    		      axisLine: {		//배경 게이지
    		        lineStyle: {
    		          width: 30  	
    		        }
    		      },
    		      axisTick: {
      		        show: true,		//사이 눈금 표시
    		        lineStyle: {
      		          width: 1,		//사이 눈금 두께
      		          color: '#999'
      		        }
    		      },
    		      splitLine: {
      		        length: 10,		//메인 눈금 길이
    		        lineStyle: {
    		          width: 2,		//메인 눈금 두께
    		          color: '#999'
    		        }
    		      },
    		      axisLabel: {
      		        distance: 35, //메인 눈금과 숫자와의 사이 간격
    		        color: '#999',
    		        fontSize: 11 //메인 눈금 숫자 폰트 사이즈
    		      },
    		      anchor: {
    		        show: true,
    		        showAbove: true,
    		        size: 2,		//침 사이즈
    		        itemStyle: {
    		          borderWidth: 10
    		        }
    		      },
    		      title: {
    		        show: false
    		      },
    		      detail: {
    		        valueAnimation: true,
    		        fontSize: 30,	//퍼센트 숫자 사이즈
    		        offsetCenter: [0, '80%'],
    		     	formatter: function(value) {
    		            // fc2 값을 포함하여 포맷팅하는 함수
    		            return [
    		                '{value|' + value.toFixed(2) + '%}',
    		                '{fc2|불량 수량 : ' + fc2 + '}'
    		              ].join('\n');
    		          },
    		          rich: {
    		        	    value: {
    		        	      fontSize: 30,
    		        	      color: '#ff0000',
    		        	      fontWeight: 'bold'
      		        	    },
    		        	    fc2: {
    		        	      fontSize: 20,
    		        	      color: '#ff0000',
    		        	      fontWeight: 'bold'
    		        	    }
    		        }
    		      },
    		      data: [
    		        {
    		          value: num[0]
    		        }
    		      ]
    		    }
    		  ]
    		};
    // 차트 업데이트 함수
    function updateChart4() {
    	$.ajax({
        	url: 'p2/b_process_normal_rate_chart_getData.jsp', 
        	type: 'GET',
        	dataType: 'json',
        	success: function(data) {
        		console.log(data);
        		fc2 = data.fc2;
          		num = ((data.fc2) / data.sc1)*100;
          		option4.series[0].data[0].value = num.toFixed(2); // 차트 데이터 업데이트
				//option4.title.text='2공정 불량품률\n'+'(수량:'+fc2+')';
          		myChart4.setOption(option4); // 차트 업데이트
        	},
        	error: function(xhr, status, error) {
          		console.error(error);
        	}
      	});
    }    
    // 초기 차트 업데이트
    updateChart4();

    // 2초마다 차트 업데이트
    setInterval(function() {
      updateChart4();
    }, 2000);
    
    if (option4 && typeof option4 === 'object') {
        myChart4.setOption(option4);
    }
	</script>
</body>
</html>
