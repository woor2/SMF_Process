<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<script>
    $(document).ready(function() {
        function updateData() {
            $.ajax({
                url: "error/errorData1.jsp",
                method: "GET",
                success: function(response) {
                	var tableBody = $("#table-body");
                	tableBody.empty();
                	
                    response.forEach(function(data) {
                    	var num = data.num;
                    	var process = data.process;
                    	var error = data.error;
                    	var time = data.time;
                    	
                        var row = "<tr>" +
                        	"<td class='center-align'>" + num + "</td>" +
                            "<td class='center-align'>" + process + "</td>" +
                            "<td class='center-align'>" + error + "</td>" +
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
                <th colspan="7">1공정 생산 현황</th>
            </tr>
            <tr>
                <th class="center-align">제품번호</th>
                <th class="center-align">공정번호</th>
                <th class="center-align">에러</th>
                <th class="center-align">시간</th>
            </tr>
        <tbody id="table-body"></tbody>
        </table>

</body>
</html>