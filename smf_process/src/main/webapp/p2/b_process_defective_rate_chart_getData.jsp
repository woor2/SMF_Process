<%@ page language="java" contentType="application/json; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.Statement, java.sql.ResultSet, java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="org.json.simple.JSONArray, org.json.simple.JSONObject" %>


<%
Connection conn9 = null;
Statement stmt9 = null;
ResultSet rs9 = null;

try {
    Class.forName("oracle.jdbc.driver.OracleDriver");
    conn9 = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "HELLOUSER", "HELLOUSER");
    stmt9 = conn9.createStatement();

    rs9 = stmt9.executeQuery("SELECT a.fc1, b.fc2, b.sc2 FROM a_process a INNER JOIN b_process b ON a.num = b.num WHERE (b.num, b.time2) IN (SELECT num, MAX(time2) FROM b_process GROUP BY num)");
    
    
    JSONObject dataObj = new JSONObject();
    if (rs9.next()) {
        int sc1 = rs9.getInt("sc1");  //1공정 합격 누적 수량
		int sc2 = rs9.getInt("sc2");  //2공정 합격 누적 수량
		int fc2 = rs9.getInt("fc2");  //2공정 불량 누적 수량
        
        dataObj.put("sc1", sc1);
        dataObj.put("sc2", sc2);
        dataObj.put("fc2", fc2);
    }

    response.getWriter().print(dataObj.toString());
} catch (ClassNotFoundException | SQLException e) {
    e.printStackTrace();
} finally {
    try {
        if (rs9 != null) rs9.close();
        if (stmt9 != null) stmt9.close();
        if (conn9 != null) conn9.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>
