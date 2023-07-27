<%@ page contentType="text/html; charset=utf-8" %>

<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #808080;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        
        .container {
            background-color: rgb(200, 200, 200);
            border-radius: 5px;
            padding: 40px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            width: 400px;
        }
        
        h2 {
            margin-bottom: 20px;
            color: #333;
        }
        
        input[type="text"],
        input[type="password"] {
            width: 90%;
            max-width: 300px;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
            margin-bottom: 20px;
            text-align: left;
        }
        
        button {
            background-color: #444;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            width: 50%;
        }
        
        button:hover {
            background-color: #555;
        }
    </style>
</head>
<body>
	<div class="container">
	<h2>물티슈 공정</h2>
	<form action="loginprocess.jsp">
		<input type="text" name="id" placeholder="ID"><br>
        <input type="password" name="password" placeholder="비밀번호"><br>
        <button type="submit">로그인</button>
	</form>
	</div>
</body>
</html>