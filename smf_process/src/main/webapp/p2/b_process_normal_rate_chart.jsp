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
    <title>2공정 정상품률</title>
    <script type="text/javascript" src="static/echarts.min.js"></script>
    <script type="text/javascript" src="static/jquery.min.js"></script> <!-- jQuery 라이브러리 추가 -->
    <link rel="stylesheet" href="resources/css/styles.css">
</head>
<body>
    <div id="b_process_normal_rate_chart" style="width:350px; height:350px; "></div>
    
    <script type="text/javascript">
    var chartDom2 = document.getElementById('b_process_normal_rate_chart');
    var myChart2 = echarts.init(chartDom2, null, {
        renderer: 'canvas',
        useDirtyRect: false
    });
    var option2;
    
    var sc1;
    var sc2;
    var fc2;
    var num = [];
    
    option2 = {
    	      title: {
        	        text: '2공정 정상품률',//\n' +'(수량:'+sc2+')',
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
    		      progress: {	//메인 게이지
    		        show: true,
    		        width: 20,
    		        itemStyle: {
    		            color: '#008000' // 여기에 원하는 색상을 지정하세요.
    		          }
    		      },
    		      axisLine: {
    		        lineStyle: {
    		          width: 30  //배경 게이지
    		        }
    		      },
    		      axisTick: {
    		        show: true,	//사이 눈금 표시
    		        lineStyle: {
      		          width: 1,		//눈금 두께
      		          color: '#999'
      		        }
    		      },
    		      splitLine: {
    		        length: 10,		//눈금 길이
    		        lineStyle: {
    		          width: 2,		//눈금 두께
    		          color: '#999'
    		        }
    		      },
    		      axisLabel: {
    		        distance: 35, //눈금과 숫자와의 사이 간격
    		        color: '#999',
    		        fontSize: 11 //눈금 숫자 폰트 사이즈
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
    		        fontSize: 30, //퍼센트 숫자 사이즈
    		        offsetCenter: [0, '80%'], //위치
    		     	formatter: function(value) {
    		            // sc2 값을 포함하여 포맷팅하는 함수
    		            return [
    		                '{value|' + value.toFixed(2) + '%}',
    		                '{sc2|정상 수량 : ' + sc2 + '}'
    		              ].join('\n');
    		          },
    		          rich: {
    		        	    value: {
    		        	      fontSize: 30,
    		        	      color: '#008000',
    		        	      fontWeight: 'bold'
    		        	    },
    		        	    sc2: {
    		        	      fontSize: 20,
    		        	      color: '#008000',
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
    function updateChart2() {
    	$.ajax({
        	url: 'p2/b_process_normal_rate_chart_getData.jsp', 
        	type: 'GET',
        	dataType: 'json',
        	success: function(data) {
        		console.log(data);
        		sc2 = data.sc2;
          		num = ((data.sc2) / data.sc1)*100;
          		option2.series[0].data[0].value = num.toFixed(2); // 차트 데이터 업데이트
				//option2.title.text='2공정 정상품률\n'+'(수량:'+sc2+')';
          		myChart2.setOption(option2); // 차트 업데이트
        	},
        	error: function(xhr, status, error) {
          		console.error(error);
        	}
      	});
    }    
    // 초기 차트 업데이트
    updateChart2();

    // 2초마다 차트 업데이트
    setInterval(function() {
      updateChart2();
    }, 2000);
    
    if (option2 && typeof option2 === 'object') {
        myChart2.setOption(option2);
    }
	</script>
</body>
</html>
