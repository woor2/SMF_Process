<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.Statement, java.sql.ResultSet, java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="config.OracleInfo" %>

<%
Connection conn = null;
Statement stmt = null;
ResultSet rs = null;

double c = 0;

try {
    Class.forName(OracleInfo.driver);
    conn = DriverManager.getConnection(OracleInfo.url, OracleInfo.username, OracleInfo.password);
    stmt = conn.createStatement();
    rs = stmt.executeQuery("SELECT (SELECT sc1 FROM (SELECT sc1 FROM a_process ORDER BY time1 DESC) WHERE ROWNUM = 1) AS sc_value, (SELECT COUNT(*) FROM a_process) AS total_count FROM dual");

    double a = 0;
    double b = 0;

    JSONObject dataObj = new JSONObject();
    if (rs.next()) {
        a = rs.getDouble("total_count");
        b = rs.getDouble("sc_value");

        if (b != 0) {
            c = (b / a) * 100;
            c = Math.round(c * 100.0) / 100.0;
            
	    	dataObj.put("c", c);      
        }
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