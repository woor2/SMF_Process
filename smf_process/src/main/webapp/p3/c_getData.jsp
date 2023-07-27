<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jsqr/dist/jsQR.min.js"></script>
</head>
<body>
   <table class="data-table">
       <thead>
           <tr>
               <td style="background-color: rgb(50, 255, 50);">양</td>
               <td style="background-color: rgb(255, 50, 50);">불</td>
               <td style="background-color: rgb(50, 50, 255);">총</td>
           </tr>
       </thead>
       <tbody id="dataTbody"></tbody>
   </table>
   <script>
       $(document).ready(function() {
           function updateData() {
               $.ajax({
                   url: "p3/getData.jsp",
                   type: "GET",
                   dataType: "json",
                   success: function(data) {
                       if (data.goodCount) {

                           var newRow = "<tr>" +
                               "<td style='background-color: rgb(50, 255, 50, 0.5);'>" + data.goodCount + "</td>" +
                               "<td style='background-color: rgb(255, 50, 50, 0.5);'>" + data.defectCount + "</td>" +
                               "<td style='background-color: rgb(50, 50, 255, 0.5);'>" + data.totalCount + "</td>" +
                               "</tr>";
                           $("#dataTbody").html(newRow);
                       } else {

                           $("#dataTbody").html("<tr><td colspan='4'>null</td></tr>");
                       }
                   },
                   error: function(xhr, status, error) {
                       console.log("AJAX：" + status + " - " + error);
                   }
               });
           }
           updateData();
           setInterval(updateData, 1000);
       });

   </script>
</body>
</html>