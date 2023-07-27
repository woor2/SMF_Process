package controller;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;

public class ProcessDao {
	private JdbcTemplate jdbcTemplate;

	public ProcessDao(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}

	public boolean isMemberID(String id) {
		Integer count = jdbcTemplate.queryForObject("select count(*) from login where id = ?", new Object[] {id},	Integer.class);	
		return (count > 0) ? true : false;
	}
	public void deleteData() {
        // 데이터베이스 데이터 삭제 쿼리 실행
        jdbcTemplate.update("TRUNCATE TABLE a_process");
        jdbcTemplate.update("TRUNCATE TABLE b_process");
        jdbcTemplate.update("TRUNCATE TABLE c_process");
        jdbcTemplate.update("TRUNCATE TABLE total");
        jdbcTemplate.update("drop sequence process_seq");
        jdbcTemplate.update("CREATE SEQUENCE PROCESS_SEQ START WITH 1 INCREMENT BY 1 MAXVALUE 10000 CYCLE");
    }
}
