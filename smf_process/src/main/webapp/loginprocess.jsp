<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="config.OracleInfo" %>
<%@ page import="java.sql.*" %>

<%
String id = request.getParameter("id");
String password = request.getParameter("password");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
String authority = null; // 권한 정보 변수

try {
    Class.forName(OracleInfo.driver);
    conn = DriverManager.getConnection(OracleInfo.url, OracleInfo.username, OracleInfo.password);

    String sql = "SELECT AUTHORITY FROM login WHERE ID=? AND PASSWORD=?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, id);
    pstmt.setString(2, password);
    rs = pstmt.executeQuery();

    if (rs.next()) {
        authority = rs.getString("AUTHORITY");
    }

} catch (ClassNotFoundException e) {
    e.printStackTrace();
} catch (SQLException e) {
    e.printStackTrace();
} finally {
    // 리소스 정리 (Connection, PreparedStatement, ResultSet)
    if (rs != null) {
        try {
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    if (pstmt != null) {
        try {
            pstmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    if (conn != null) {
        try {
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

if (authority != null) {
    // 로그인 성공 - AUTHORITY를 세션에 저장
    session.setAttribute("AUTHORITY", authority);
    response.sendRedirect("home");
} else {
    // 로그인 실패
    response.sendRedirect("login?error=true");
}
%>
