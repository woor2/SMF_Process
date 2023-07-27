package spring;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import config.OracleInfo;

public class MemberDAO {
	public int selectMember(String id, String pw) {
		int result = 0;
		try {
			Class.forName(OracleInfo.driver);
			Connection conn = DriverManager.getConnection(OracleInfo.url,OracleInfo.username,OracleInfo.password);
			System.out.println("db연결성공");
			
			String sql = "select * from login where id = ?";
			PreparedStatement pt = conn.prepareStatement(sql);
			pt.setString(1 , id);
			ResultSet rs = pt.executeQuery();
			if(rs.next() == true) {
				String pwdb = rs.getString("password");
				if(pwdb.equals(pw)) {
					result = 0;
				}
				else {
					result = 1;
				}
			}
			else {
				result = 2;
			}
			
			conn.close();
			System.out.println("db 연결해제");
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
}
