<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Logout</title>
</head>
<body>
    <%
        // 세션 무효화
        session.invalidate();

        // 로그인 페이지로 리다이렉트
        response.sendRedirect("login");
    %>
</body>
</html>
