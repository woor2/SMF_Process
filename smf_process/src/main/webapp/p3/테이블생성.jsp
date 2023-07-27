<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection, java.sql.Statement, java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager, java.sql.SQLException, config.OracleInfo" %>

<!DOCTYPE html>
<html>
<head>
    <title>공정 테이블</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .center-align {
            text-align: center;
        }

        .table-border {
            border: 1px solid black;
        }

        tr, td, th {
            border: 1px solid black;
        }

        .table-wrapper {
            display: flex;
        }

        .table-wrapper table {
            flex: 1;
            margin-right: 10px;
        }

        .table-wrapper table, .table-wrapper th, .table-wrapper td {
            border: 1px solid black;
            padding: 5px;
            font-size: 12px;
            height: 12px;
        }

        .red-cell {
            background-color: red;
            color: white;
        }
    </style>
    <script>
        $(document).ready(function() {
            function updateData() {
                $.ajax({
                    url: "p3/getData1.jsp",
                    method: "GET",
                    success: function(response) {
                        var tableBody = $("#table-body");
                        tableBody.empty();

                        response.forEach(function(data) {
                            var id = data.id;
                            var tf = data.tf;
                            var productionTime = data.productionTime;

                            var row = "<tr>" +
                                "<td class='center-align'>" + id + "</td>" +
                                "<td class='center-align " + (tf == 0 ? "red-cell" : "") + "'>" + tf + "</td>" +
                                "<td class='center-align'>" + productionTime + "</td>" +
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
            setInterval(updateData, 1000);
        });
    </script>
</head>
<body>
    <h1 class="center-align">LOG</h1>
    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
                    <th class="center-align" width="50px">ID</th>
                    <th class="center-align" width="100px">정상/불량</th>
                    <th class="center-align" width="250px">생산시간</th>
                </tr>
            </thead>
            <tbody id="table-body">
				<% 
	            // 데이터베이스 연결 및 데이터 조회
	            Connection conn3 = null;
	            Statement stmt3 = null;
	            ResultSet rs3 = null;
	            try {
	                Class.forName(OracleInfo.driver);
	                conn3 = DriverManager.getConnection(OracleInfo.url, OracleInfo.username, OracleInfo.password);
	                stmt3 = conn3.createStatement();
	                rs3 = stmt3.executeQuery("SELECT * FROM c_process ORDER BY time3 desc");
	
	                while (rs3.next()) {
	                    int id = rs3.getInt("num");
	                    int tf = rs3.getInt("tf3");

	                    String production_time = rs3.getString("time3");
	                    %>
	                    <tr>
                        <td class="center-align"><%= id %></td>
                        <td class="center-align <% if (tf == 0) { %>red-cell<% } %>"><%= tf %></td>
                        <td class="center-align"><%= production_time %></td>
	                    </tr>
	                    <%
	                }
	            } catch (ClassNotFoundException e) {
	                e.printStackTrace();
	            } catch (SQLException e) {
	                e.printStackTrace();
	            } finally {
	                // 연결 및 리소스 해제
	                try {
	                    if (rs3 != null) rs3.close();
	                    if (stmt3 != null) stmt3.close();
	                    if (conn3 != null) conn3.close();
	                } catch (SQLException e) {
	                    e.printStackTrace();
	                }
	            }
	            %>
	        </tbody>
            </tbody>
        </table>
    </div>
</body>
</html>
