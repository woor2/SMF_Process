<%@ page language="java" contentType="application/json; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.Statement, java.sql.ResultSet, java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="org.json.simple.JSONArray, org.json.simple.JSONObject" %>

<%
Connection conn5 = null;
Statement stmt5 = null;
ResultSet rs5 = null;
try {
    Class.forName("oracle.jdbc.driver.OracleDriver");
    conn5 = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "HELLOUSER", "HELLOUSER");
    stmt5 = conn5.createStatement();

    rs5 = stmt5.executeQuery("SELECT temperature FROM (SELECT temperature FROM b_process ORDER BY num DESC) WHERE ROWNUM <= 1");

    JSONObject dataObj = new JSONObject();
    if (rs5.next()) {
        int temperature = rs5.getInt("temperature");

        dataObj.put("temperature", temperature);

    }

    response.getWriter().print(dataObj.toString());
} catch (ClassNotFoundException | SQLException e) {
    e.printStackTrace();
} finally {
    try {
        if (rs5 != null) rs5.close();
        if (stmt5 != null) stmt5.close();
        if (conn5 != null) conn5.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>
