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

    // a_process, b_process, c_process를 각각 카운팅
    String sqlA = "SELECT COUNT(*) AS a_count FROM total WHERE process='a_process'";
    String sqlB = "SELECT COUNT(*) AS b_count FROM total WHERE process='b_process'";
    String sqlC = "SELECT COUNT(*) AS c_count FROM total WHERE process='c_process'";

    rs = stmt.executeQuery(sqlA);
    JSONObject dataObj = new JSONObject();
    if (rs.next()) {
        int a_processCount = rs.getInt("a_count");
        dataObj.put("a_process", a_processCount);
    }

    rs = stmt.executeQuery(sqlB);
    if (rs.next()) {
        int b_processCount = rs.getInt("b_count");
        dataObj.put("b_process", b_processCount);
    }

    rs = stmt.executeQuery(sqlC);
    if (rs.next()) {
        int c_processCount = rs.getInt("c_count");
        dataObj.put("c_process", c_processCount);
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
