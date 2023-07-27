package spring;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/login")
public class LoginReview extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String id = request.getParameter("id");
		String pw = request.getParameter("password");
		
		MemberDAO dao = new MemberDAO();
		int result = dao.selectMember(id, pw);
		
		String printing = "";
		if (result == 0) {
			printing = "<h3>" + id + "정상 로그인 되었습니다.</h3>";
		}
		else if (result == 1) {
			printing = "<h3>" + id + "암호를 확인하세요.</h3>";
		}
		else {
			printing = "<h3>" + id + "존재하지 않는 id입니다.</h3>";
		}
		response.setContentType("text./html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(printing);
	}
		

}
