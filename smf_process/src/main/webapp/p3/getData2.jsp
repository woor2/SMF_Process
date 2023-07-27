<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection, java.sql.Statement, java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager, java.sql.SQLException, config.OracleInfo" %>
<%@ page import="java.util.ArrayList, java.util.List" %>
<%@ page import="org.json.simple.JSONArray, org.json.simple.JSONObject" %>

<%
// 데이터베이스 연결 및 데이터 조회
Connection conn = null;
Statement stmt = null;
ResultSet rs = null;
List<JSONObject> data = new ArrayList<>();

try {
    Class.forName(OracleInfo.driver);
    conn = DriverManager.getConnection(OracleInfo.url, OracleInfo.username, OracleInfo.password);
    stmt = conn.createStatement();
    rs = stmt.executeQuery("SELECT c.tf3, c.temperature, c.weight, c.time3, t.process, t.ERROR FROM c_process c JOIN total t ON c.num = t.num order by c.TIME3 DESC");
    while (rs.next()) {
        int temperature = rs.getInt("temperature");
        int weight = rs.getInt("weight");
        String time = rs.getTimestamp("time3").toString();
        int tf3 = rs.getInt("tf3");
        String error = rs.getString("error");

        JSONObject item = new JSONObject();
        item.put("temperature", temperature);
        item.put("weight", weight);
        item.put("time3", time);
        item.put("tf3", tf3);
        item.put("error", error);
        data.add(item);
    }
} catch (ClassNotFoundException e) {
    e.printStackTrace();
} catch (SQLException e) {
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

// JSON 형식으로 데이터 반환
JSONArray jsonArray = new JSONArray();
jsonArray.addAll(data);

String jsonString = jsonArray.toString();
response.setContentType("application/json");
response.setCharacterEncoding("UTF-8");
response.getWriter().write(jsonString);
%>