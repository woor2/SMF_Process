<%@ page language="java" contentType="application/json; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.Statement, java.sql.ResultSet, java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="org.json.simple.JSONArray, org.json.simple.JSONObject" %>

<%
Connection conn8 = null;
Statement stmt8 = null;
ResultSet rs8 = null;

try {
    Class.forName("oracle.jdbc.driver.OracleDriver");
    conn8 = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "HELLOUSER", "HELLOUSER");
    stmt8 = conn8.createStatement();

    rs8 = stmt8.executeQuery("SELECT a.fc1, b.fc2, b.sc2 FROM a_process a JOIN b_process b ON a.num = b.num WHERE b.time2 = ( SELECT MAX(time2) FROM b_process)");
    
    JSONObject dataObj = new JSONObject();
    if (rs8.next()) {
		int fc1 = rs8.getInt("fc1");	//1공정 불량 누적 수량
		int fc2 = rs8.getInt("fc2");	//2공정 불량 누적 수량
		int sc2 = rs8.getInt("sc2");	//2공정 합격 누적 수량

		
		dataObj.put("fc1", fc1);
		dataObj.put("fc2", fc2);
		dataObj.put("sc2", sc2);
    }

    response.getWriter().print(dataObj.toString());
} catch (ClassNotFoundException | SQLException e) {
    e.printStackTrace();
} finally {
    try {
        if (rs8 != null) rs8.close();
        if (stmt8 != null) stmt8.close();
        if (conn8 != null) conn8.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>