package controller;

import java.util.List;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;

public class ErrorDAO {
	private JdbcTemplate jdbcTemplate;

	public ErrorDAO(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	
	public List<Error> getErrorsByMonth() {
		// TODO Auto-generated method stub
		return null;
	}
	public List<Error> getErrorsByDay() {
		// TODO Auto-generated method stub
		return null;
	}
	

}
