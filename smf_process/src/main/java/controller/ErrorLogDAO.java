package controller;

import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;

public class ErrorLogDAO {
	private final JdbcTemplate jdbcTemplate;
	
	public ErrorLogDAO(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	
	public List<ErrorLog>getAllErrorLogs(){
		String query = "select *from error_log";
		return jdbcTemplate.query(query, (rs, rowNum) -> {
            ErrorLog errorLog = new ErrorLog();
            errorLog.setId(rs.getInt("MACHINE_ID"));
            errorLog.setError1(rs.getInt("ERROR1"));
            errorLog.setError2(rs.getInt("ERROR2"));
            errorLog.setError3(rs.getInt("ERROR3"));
            errorLog.setCreatedAt(rs.getString("LOG_TIME"));
            return errorLog;
        });
	}
}
