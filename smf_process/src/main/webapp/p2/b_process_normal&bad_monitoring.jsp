<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection, java.sql.Statement, java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager, java.sql.SQLException, config.OracleInfo" %>
<%@ page import="java.util.List" %> <!-- 추가 -->
<%@ page import="java.util.ArrayList" %> <!-- 추가 -->
<%@ page import="com.google.gson.Gson" %> <!-- 추가 -->

<!DOCTYPE html>
<html>
<head>
    <title>2공정 정상-불량 모니터링</title>
    <script type="text/javascript" src="static/echarts.min.js"></script>
</head>
<body>
    <div id="b_process_normal&bad_monitoring" style="width:700; height:350px;"></div>
    <script type="text/javascript">
    
	    var chartDom3 = document.getElementById('b_process_normal&bad_monitoring');
	    var myChart3 = echarts.init(chartDom3);
	    var option3;
	    var lastNum = null; //이전의 num 값 저장 변수
	    
	    var categories1 = [];
	    var categories2 = [];
	    var data1 = [];
	    var data2 = [];
	    
	    option3 = {
	      title: {
	        text: '2공정 정상-불량 모니터링',
	        left : 'center',
	        textStyle : {
	        	fontSize: 20,
				  	fontWeight: 'bold',
			  	color: '#000'
	        	}
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
	      legend: {
	    	    show: true, // 범례 표시 여부
	    	    orient: 'vertical', // 범례의 방향 (수평: 'horizontal', 수직: 'vertical')
	    	    x: 'right', // 범례의 가로 위치 ('left', 'center', 'right' 또는 픽셀 값)
	    	    y: 'center', // 범례의 세로 위치 ('top', 'bottom', 'center' 또는 픽셀 값)	    	  
	    	  
	      },
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
	      xAxis: [
	        {
	          type: 'category',
	          boundaryGap: true,
	          data: categories1.reverse()		//하단 x축 시간 데이터
	        },
	        {		
	          type: 'category',
	          boundaryGap: true,
	          data: categories2.reverse()		 //상단 x축 품번 데이터
	        }
	      ],
	      yAxis: [
	        { 						//왼쪽 y축 범위
	          type: 'value',
	          scale: true,
	          name: '℃',
	          max: 185,
	          min: 175,
	          boundaryGap: [0.2, 0.2]
	        },
	        {						//오른쪽 y축 범위
	          type: 'value',
	          scale: true,
	          name: 'T/F',
	          max: 1,
	          min: 0,
	          axisTick: {
	              show: false // 눈금 숨기기
	            },
	            axisLabel: {
	                show: true // 눈금 레이블 숨기기
	              },
	            splitLine: {
	              show: false
	            },// 눈금 숨기기
	              interval: 1
	        }
	      ],
	      series: [
	        {
	          name: '정상\n불량',
	          type: 'bar',
	          xAxisIndex: 1,
	          yAxisIndex: 1,
	          data: data1.reverse()		//오른쪽 x축 데이터
	        },
	        {
	          name: '온도',
	          type: 'line',
	          data: data2.reverse()		//왼쪽 y축 데이터
	        }
	      ]
	    };

	    function fetchData() {
	    	  // AJAX를 통해 서버로 데이터 요청을 보냅니다.
	    	  // 서버 측의 getChartData.jsp 파일을 요청하고, 응답으로 JSON 데이터를 받습니다.
	    	  // 적절한 URL과 파라미터 설정이 필요합니다.
	    	  // 이 예시에서는 jQuery AJAX를 사용하였습니다.
	    	  $.ajax({
	    	    url: 'p2/b_process_normal&bad_monitoring_getData.jsp',
	    	    type: 'GET',
	    	    dataType: 'json',
	    	    success: function(response) {
	    	    	
	    	      console.log(response);		
	    	      var time = response.time2; // 받아온 시간 데이터
	    	      var timeSplit = time.split(' ')[1].split(':'); // 시, 분, 초로 분리
	       	      var timeFormatted = timeSplit[0] + ':' + timeSplit[1] + ':' + timeSplit[2]; // 시, 분, 초를 구성하여 categories에 추가
	       	      
	       	      if (response.num !== undefined && response.num !== null) {
	       	        lastNum = response.num; // 새로운 num 값으로 갱신
	       	      }
			       	// 소수점 이하를 제거하여 시간 데이터를 표시
		       	   timeFormatted = timeFormatted.split('.')[0];
	    	      
	    	      if (!categories2.includes(lastNum)) {
	    	    	  
		    	      categories1.unshift(timeFormatted); // 받아온 데이터를 배열 맨 앞에 추가합니다.
		    	      if (categories1.length > 10) {
		    	        categories1.pop(); // 배열의 길이가 10을 초과하면 가장 오래된 값을 제거합니다.
		    	      }
		    	      
		    	      
		    	      categories2.unshift(lastNum); // 이전의 num 값을 사용 //받아온 데이터를 배열 맨 앞에 추가합니다.
		    	      if (categories2.length > 10) {
		    	        categories2.pop(); // 배열의 길이가 10을 초과하면 가장 오래된 값을 제거합니다.
		    	      }
		    	      
					
		    	      data1.unshift(response.tf2); // 받아온 데이터를 배열 맨 앞에 추가합니다.
		    	      if (data1.length > 10) {
		    	        data1.pop(); // 배열의 길이가 10을 초과하면 가장 오래된 값을 제거합니다.
		    	      }
		    	      
	
		    	      data2.unshift(response.temperature); // 받아온 데이터를 배열 맨 앞에 추가합니다.
		    	      if (data2.length > 10) {
		    	        data2.pop(); // 배열의 길이가 10을 초과하면 가장 오래된 값을 제거합니다.
		    	      }
		    	      
	
		    	      myChart3.setOption({
							xAxis: [
								{
									data: categories1.slice().reverse() // categories1 배열의 복사본을 역순으로 변경하여 할당
								},
								{
									data: categories2.slice().reverse() // categories2 배열의 복사본을 역순으로 변경하여 할당
								}
							],
							series: [
								{
									data: data1.slice().reverse() // data1 배열의 복사본을 역순으로 변경하여 할당
								},
								{
									data: data2.slice().reverse() // data2 배열의 복사본을 역순으로 변경하여 할당
								}
							]
						  });
	
			    	      // 차트 업데이트 등의 추가 작업을 수행할 수 있습니다.
			    	      // ...
	    	    	}
		   	    },
	    	    error: function(xhr, status, error) {
	    	    	console.error(error);
	    	      // 데이터 요청이 실패했을 때 처리하는 함수입니다.
	    	      // 에러 핸들링 등을 수행할 수 있습니다.
	    	      // ...
	    	    }
	    	  });
	    	}	    
	    fetchData();
	    
        // 1초마다 차트 업데이트
        setInterval(function() {
        	fetchData();
        }, 1000);
        
        if (option3 && typeof option3 === 'object') {
            myChart3.setOption(option3);
        }
    </script>
</body>
</html>
