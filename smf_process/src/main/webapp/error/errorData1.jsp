<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection, java.sql.Statement, java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager, java.sql.SQLException, config.OracleInfo" %>
<%@ page import="java.util.ArrayList, java.util.List" %>
<%@ page import="org.json.simple.JSONArray, org.json.simple.JSONObject" %>

<%
Connection conn = null;
Statement stmt = null;
ResultSet rs = null;
List<JSONObject> data = new ArrayList<>();

try {
	Class.forName(OracleInfo.driver);
    conn = DriverManager.getConnection(OracleInfo.url, OracleInfo.username, OracleInfo.password);
    stmt = conn.createStatement();
    rs = stmt.executeQuery("SELECT * FROM total ORDER BY TIME");

    while (rs.next()) {
        int num = rs.getInt("num");
        String process = rs.getString("process");
        String error = rs.getString("error");
        String time = rs.getString("time");

        JSONObject item = new JSONObject();
        item.put("num", num);
        item.put("process", process);
        item.put("error", error);
        item.put("time", time);
        data.add(item);
    }
} catch (ClassNotFoundException e) {
    e.printStackTrace();
} catch (SQLException e) {
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

JSONArray jsonArray = new JSONArray();
jsonArray.addAll(data);

String jsonString = jsonArray.toString();
response.setContentType("application/json");
response.setCharacterEncoding("UTF-8");
response.getWriter().write(jsonString);
%>
