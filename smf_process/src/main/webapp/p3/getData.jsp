<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection, java.sql.Statement, java.sql.ResultSet, java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="org.json.simple.JSONObject" %>

<%
Connection conn = null;
Statement stmt = null;
ResultSet rs = null;
try {
    Class.forName("oracle.jdbc.driver.OracleDriver");
    conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "HELLOUSER", "HELLOUSER");
    stmt = conn.createStatement();

    rs = stmt.executeQuery("SELECT SUM(CASE WHEN TF3 = 1 THEN 1 ELSE 0 END) AS GOOD_COUNT, " +
            "SUM(CASE WHEN TF3 = 0 THEN 1 ELSE 0 END) AS DEFECT_COUNT, " +
            "COUNT(*) AS TOTAL_COUNT " +
            "FROM C_PROCESS");

    JSONObject dataObj = new JSONObject();
    if (rs.next()) {
        int goodCount = rs.getInt("GOOD_COUNT");
        int defectCount = rs.getInt("DEFECT_COUNT");
        int totalCount = rs.getInt("TOTAL_COUNT");

        dataObj.put("goodCount", goodCount);
        dataObj.put("defectCount", defectCount);
        dataObj.put("totalCount", totalCount);
    }

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().print(dataObj.toString());
} catch (ClassNotFoundException | SQLException e) {
    e.printStackTrace();
} finally {
    try {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>
