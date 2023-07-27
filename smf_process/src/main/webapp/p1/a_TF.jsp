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
        <tbody>
            <tr>
                <th>품질 확인</th>
            </tr>    
        </tbody>
    <tbody id="datatf"></tbody>
    </table>
    <script>
    $(document).ready(function() {
        function updateData() {
            $.ajax({
                url: "p1/getDataTF.jsp", // 설명
                type: "GET",
                dataType: "json",
                success: function(data) {
                    if (data.tftf) {
                        var newRow = "<tr><th style='font-size: 25px; text-align: center; display: flex; justify-content: center; align-items: center;'>" + data.tftf + "</th></tr>"

                        $("#datatf").html(newRow);
                    } else {
                        $("#datatf").html("<tr><td colspan='2'>정지</td></tr>");
                    }
                },
                error: function(xhr, status, error) {
                    console.log("AJAX：" + status + " - " + error);
                }
            });
        }
        updateData();
        setInterval(updateData, 500);
    });
    </script>
    
</body>
</html>