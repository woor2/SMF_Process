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
    rs = stmt.executeQuery("SELECT * FROM A_PROCESS ORDER BY TIME1");

    while (rs.next()) {
        int num = rs.getInt("num");
        int tf = rs.getInt("tf1");
        int csize = rs.getInt("csize");
        int cspeed = rs.getInt("cspeed");
        int sc = rs.getInt("sc1");
        int fc = rs.getInt("fc1");
        String time = rs.getString("time1");

        JSONObject item = new JSONObject();
        item.put("num", num);
        item.put("tf", tf);
        item.put("csize", csize);
        item.put("cspeed", cspeed);
        item.put("sc", sc);
        item.put("fc", fc);
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
