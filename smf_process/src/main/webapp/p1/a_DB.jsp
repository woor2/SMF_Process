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
<script>
    $(document).ready(function() {
        function updateData() {
            $.ajax({
                url: "p1/getDataDB.jsp",
                method: "GET",
                success: function(response) {
                	var tableBody = $("#table-body");
                	tableBody.empty();
                	
                    response.forEach(function(data) {
                    	var num = data.num;
                    	var tf = data.tf;
                    	var csize = data.csize;
                    	var cspeed = data.cspeed;
                    	var sc = data.sc;
                    	var fc = data.fc;
                    	var time = data.time;
                    	
                        var row = "<tr>" +
                        	"<td class='center-align'>" + num + "</td>" +
                            "<td class='center-align'>" + tf + "</td>" +
                            "<td class='center-align'>" + csize + "</td>" +
                            "<td class='center-align'>" + cspeed + "</td>" +
                            "<td class='center-align'>" + sc + "</td>" +
                            "<td class='center-align'>" + fc + "</td>" +
                            "<td class='center-align'>" + time + "</td>" +
                            "</tr>";
                        tableBody.append(row);
                    });
                },
                error: function(xhr, status, error) {
                    console.log("Error: " + error);
                }
            });
        }
        
        updateData();
        setInterval(updateData, 500);
    });
	</script>
    <table class="styled-table">
            <tr>
                <th colspan="7">1공정 생산 현황 테이블</th>
            </tr>
            <tr>
                <th class="center-align">제품번호</th>
                <th class="center-align">정상/불량</th>
                <th class="center-align">커팅사이즈</th>
                <th class="center-align">커팅속도</th>
                <th class="center-align">총성공</th>
                <th class="center-align">총실패</th>
                <th class="center-align">시간</th>
            </tr>
        <tbody id="table-body"></tbody>
        </table>
    
</body>
</html>