<%@ page language="java" contentType="application/json; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.Statement, java.sql.ResultSet, java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="org.json.simple.JSONArray, org.json.simple.JSONObject" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.google.gson.Gson" %>

<%
Connection conn7 = null;
Statement stmt7 = null;
ResultSet rs7 = null;

try {
    Class.forName("oracle.jdbc.driver.OracleDriver");
    conn7 = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "HELLOUSER", "HELLOUSER");

    stmt7 = conn7.createStatement();
    rs7 = stmt7.executeQuery("SELECT time2, num, tf2, temperature FROM (SELECT time2, num, tf2, temperature FROM b_process ORDER BY time2 DESC) WHERE ROWNUM <=1");
    //rs7 = stmt.executeQuery("SELECT time2, num, tf2, temperature FROM b_process ORDER BY time2 DESC");
    
 	JSONObject dataObj = new JSONObject();
    while (rs7.next()) {

        String time2 = rs7.getString("time2");
        int num = rs7.getInt("num");
        int tf2 = rs7.getInt("tf2");
        int temperature = rs7.getInt("temperature");
        
        dataObj.put("time2", time2);
        dataObj.put("num", num);
        dataObj.put("tf2", tf2);
        dataObj.put("temperature", temperature);

      }
    
	 response.getWriter().print(dataObj.toString());
	 
	} catch (ClassNotFoundException | SQLException e) {
	    e.printStackTrace();
	} finally {
	    try {
	        if (rs7 != null) rs7.close();
	        if (stmt7 != null) stmt7.close();
	        if (conn7 != null) conn7.close();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	}
 /*   
    class ProcessData {
        public String time2;
        public int num;
        public int tf2;
        public int temperature;
      }
    List<ProcessData> dataList = new ArrayList<>();
    
    while (rs7.next()) {
        ProcessData data = new ProcessData();
        data.time2 = rs7.getString("time2");
        data.num = rs7.getInt("num");
        data.tf2 = rs7.getInt("tf2");
        data.temperature = rs7.getInt("temperature");
        dataList.add(data);
        //System.out.println(data.tf2);
      	//System.out.println(dataList);
      }
    
    Gson gson = new Gson();
    String json = gson.toJson(dataList);
    
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write(json);
    
    rs7.close();
    stmt.close();
    conn.close();
  } catch (SQLException e) {
    e.printStackTrace();
    // 에러 핸들링 등을 수행할 수 있습니다.
    // ...
  }
    
    */
%>
