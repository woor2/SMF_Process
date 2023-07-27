<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection, java.sql.Statement, java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager, java.sql.SQLException, config.OracleInfo" %>
<%@ page import="java.util.List" %> <!-- 추가 -->
<%@ page import="java.util.ArrayList" %> <!-- 추가 -->
<%@ page import="com.google.gson.Gson" %> <!-- 추가 -->
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="process.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>2공정 목표달성률</title>
    <script type="text/javascript" src="static/echarts.min.js"></script>
    <script type="text/javascript" src="static/jquery.min.js"></script> <!-- jQuery 라이브러리 추가 -->
</head>
<body>
	<div id="b_process_target_achievement_late_chat" style="width: 350px;height:350px;"></div>
	<script type="text/javascript">
		var target_quantity = <%=XProcessMain.MAX_TASKNUM%>;
		
		var chartDom9 = document.getElementById('b_process_target_achievement_late_chat');
		var myChart9 = echarts.init(chartDom9, null, {
            renderer: 'canvas',
            useDirtyRect: false
        });
		
		var option9;
		var fc1=0;
		var fc2=0;
		var sc2=0;
		
		
		option9 = {
				
   	      title: {
       	        text: '전체 목표수량 대비 2공정 진행률',  <%--  \n'+'(전체목표수량:'+'<%=VALUE.NUM%>'+')', --%>
    	        left : 'center'
       	      },		
		  tooltip: {
		    trigger: 'item',
		    formatter: '{b}: {c}%'
		  },
		  legend: {
	    	show: true, // 범례 표시 여부
		    top: '10%',
		    left: 'right',
		    orient: 'vertical'

		  },
		  series: [
		    {
		      name: 'Access From',
		      type: 'pie',
		      radius: ['45%', '70%'],
		      avoidLabelOverlap: false,
		      itemStyle: {
		        borderRadius: 10,
		        borderColor: '#fff',
		        borderWidth: 2
		      },
		      label: {
		        show: true,			// 차트 중앙에 값 표시를 위해 true로 설정
                position: 'inside', // 변경된 설정
                formatter: '{b}:'+'\n'+' {c}%', // 변경된 설정
                fontSize: 15, // 기본 글씨 크기 설정
                fontWeight: 'bold'
		      },
		      emphasis: {
		        label: {
		          show: true,
		          fontSize: 25,
		          fontWeight: 'bold'
		        }
		      },
		      labelLine: {
		        show: true
		      },
		      data: [
		        { value: (sc2/target_quantity)*100, name: '진행률' },
		        { value: ((target_quantity-sc2-fc2-fc1)/target_quantity)*100, name: '2공정\n잔여물량' },
		        { value: (fc1+fc2/target_quantity)*100, name: '누적\n불량률' }
		      ]
		    }
		  ],
		  graphic: [
			    {
			      type: 'text',
			      left: 'center',
			      top: 'middle',
			      style: {
			        text: '', //'전체\n목표수량\n' + sc2 + '/' + target_quantity,
			        fill: '#000',
			        fontSize: 25,
			        fontWeight: 'bold',
			        textAlign: 'center', // 수평 가운데 정렬
			        textVerticalAlign: 'middle' // 수직 가운데 정렬
			      }
			    }
			  ]
		};

        // 차트 업데이트 함수
        function updateChart9() {
        	$.ajax({
            	url: 'p2/b_process_target_achievement_late_chat_getData.jsp',
            	type: 'GET',
            	dataType: 'json',
            	success: function(data) {
            		console.log(data);
            		fc1 = data.fc1;
            		fc2 = data.fc2;
            		sc2 = data.sc2;
            		
              		option9.series[0].data[0].value = ((sc2/target_quantity) * 100).toFixed(2);
              		option9.series[0].data[1].value = (((target_quantity-sc2-fc2-fc1)/target_quantity) * 100).toFixed(2);
              		option9.series[0].data[2].value = (((fc1+fc2)/target_quantity)*100).toFixed(2);

              		//option9.title.text = '전체 목표수량 대비 2공정 진행률\n (2공정잔여물량 : ' + (target_quantity-sc2-fc2-fc1)+')';
					option9.title.text = ['전체 목표수량 대비 2공정 진행률','{b|2공정잔여물량: ' + (target_quantity-sc2-fc2-fc1) + '}'].join('\n');
					
					// title 스타일 설정
					option9.title.textStyle = {
					  fontSize: 20, // '전체 목표수량 대비 2공정 진행률' 폰트 크기
					  fontWeight: 'bold',
					  color: '#000',
					  rich: {
					    b: {
					      fontSize: 12, // (target_quantity-sc2-fc2-fc1) 폰트 크기
					      fontWeight: 'bold',
					      lineHeight: 20, // (target_quantity-sc2-fc2-fc1) 높이 조절
					      color: '#FF0000' // (target_quantity-sc2-fc2-fc1) 폰트 색상
					    }
					  }
					};		
					
              		option9.tooltip.formatter = '{b}: {c}%';

					// 텍스트 업데이트
					option9.graphic[0].style.text = [
					  '{a| ▼2공정합격수량}',
					  '{b|' + sc2 + '/' + target_quantity + '}',
					  '{c| 전체목표수량▲}'].join('\n');	
					
					// 텍스트 스타일 정의
					option9.graphic[0].style.rich = {
					  a: {
					    fontSize: 14, // '전체' 텍스트의 폰트 크기
					    fontWeight: 'bold',
					    lineHeight: 30, // '전체' 텍스트의 높이 조절
					    color: '#000'
					  },
					  b: {
					    fontSize: 25, // '목표수량' 텍스트의 폰트 크기
					    fontWeight: 'bold',
					    lineHeight: 25, // '목표수량' 텍스트의 높이 조절
					    color: '#000'
					  },
					  c: {
					    fontSize: 14, // '전체' 텍스트의 폰트 크기
					    fontWeight: 'bold',
					    lineHeight: 30, // '전체' 텍스트의 높이 조절
					    color: '#000'
					  }
					};
              		
              		myChart9.setOption(option9); // 차트 업데이트
            	},
            	error: function(xhr, status, error) {
              		console.error(xhr, status, error);
            	}
          	});
        }

        // 초기 차트 업데이트
        updateChart9();

        // 2초마다 차트 업데이트
        setInterval(function() {
          updateChart9();
        }, 2000);
        
        if (option9 && typeof option9 === 'object') {
            myChart9.setOption(option9);
        }
    
	</script>

</body>
</html>
