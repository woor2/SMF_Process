<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.Statement, java.sql.ResultSet, java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="config.OracleInfo" %>

<%
Connection conn = null;
Statement stmt = null;
ResultSet rs = null;

try {
    Class.forName(OracleInfo.driver);
    conn = DriverManager.getConnection(OracleInfo.url, OracleInfo.username, OracleInfo.password);
    stmt = conn.createStatement();
    rs = stmt.executeQuery("SELECT num, tf1 FROM a_process ORDER BY num DESC");

    JSONObject dataObj = new JSONObject();
    if (rs.next()) {
    	int num = rs.getInt("num");
    	int tf = rs.getInt("tf1");
        String tftf = (tf == 1) ? "정상" : "불량";
        
        dataObj.put("num", num);
        dataObj.put("tf", tf);
        dataObj.put("tftf", tftf);
    }

    response.getWriter().print(dataObj.toString());
} catch (ClassNotFoundException | SQLException e) {
    e.printStackTrace();
} finally {
    // 연결 및 리소스 해제
    try {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>