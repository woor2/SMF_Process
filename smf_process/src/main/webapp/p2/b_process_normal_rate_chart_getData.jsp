<%@ page language="java" contentType="application/json; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.Statement, java.sql.ResultSet, java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="org.json.simple.JSONArray, org.json.simple.JSONObject" %>

<%
Connection conn6 = null;
Statement stmt6 = null;
ResultSet rs6 = null;

try {
    Class.forName("oracle.jdbc.driver.OracleDriver");
    conn6 = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "HELLOUSER", "HELLOUSER");
    stmt6 = conn6.createStatement();

    rs6 = stmt6.executeQuery("SELECT a.num, a.sc1, b.sc2, b.fc2 FROM a_process a JOIN b_process b ON a.num = b.num WHERE b.time2 = ( SELECT MAX(time2) FROM b_process)");
    
    
    JSONObject dataObj = new JSONObject();
    if (rs6.next()) {
        int sc1 = rs6.getInt("sc1");  //1공정 합격 누적 수량
		int sc2 = rs6.getInt("sc2");  //2공정 합격 누적 수량
		int fc2 = rs6.getInt("fc2");  //2공정 불량 누적 수량
        
        dataObj.put("sc1", sc1);
        dataObj.put("sc2", sc2);
        dataObj.put("fc2", fc2);
    }

    response.getWriter().print(dataObj.toString());
} catch (ClassNotFoundException | SQLException e) {
    e.printStackTrace();
} finally {
    try {
        if (rs6 != null) rs6.close();
        if (stmt6 != null) stmt6.close();
        if (conn6 != null) conn6.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>
