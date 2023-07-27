<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection, java.sql.Statement, java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager, java.sql.SQLException, config.OracleInfo" %>
<%@ page import="java.util.ArrayList, java.util.List" %>
<%@ page import="org.json.simple.JSONArray, org.json.simple.JSONObject" %>

<%
// 데이터베이스 연결 및 데이터 조회
Connection conn3 = null;
Statement stmt3 = null;
ResultSet rs3 = null;
List<JSONObject> data = new ArrayList<>();

try {
    Class.forName(OracleInfo.driver);
    conn3 = DriverManager.getConnection(OracleInfo.url, OracleInfo.username, OracleInfo.password);
    stmt3 = conn3.createStatement();
    rs3 = stmt3.executeQuery("SELECT * FROM c_process ORDER BY time3 DESC");

    while (rs3.next()) {
        int id = rs3.getInt("num");
        int tf = rs3.getInt("tf3");
        String productionTime = rs3.getString("time3");

        JSONObject item = new JSONObject();
        item.put("id", id);
        item.put("tf", tf);
        item.put("productionTime", productionTime);
        data.add(item);
    }
} catch (ClassNotFoundException e) {
    e.printStackTrace();
} catch (SQLException e) {
    e.printStackTrace();
} finally {
    // 연결 및 리소스 해제
    try {
        if (rs3 != null) rs3.close();
        if (stmt3 != null) stmt3.close();
        if (conn3 != null) conn3.close();
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

