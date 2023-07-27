package config;

import org.apache.tomcat.jdbc.pool.DataSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import boards.BoardDAO;
import controller.ErrorDAO;
import controller.ErrorLogDAO;
import controller.ProcessDao;
import controller.TableDAO;


@Configuration
@EnableTransactionManagement
public class DaoConfig {

	@Bean(destroyMethod = "close")
	public DataSource dataSource() {
		DataSource ds = new DataSource();
		ds.setDriverClassName(OracleInfo.driver);
		ds.setUrl(OracleInfo.url);
		ds.setUsername(OracleInfo.username);
		ds.setPassword(OracleInfo.password);
		ds.setInitialSize(5);							// 커넥션 풀을 초기화 할 때 생성할 초기 커넥션 갯수
		ds.setMaxActive(10);							// 커넥션 풀에서 가져올 수 있는 최대 커넥션 갯수
		ds.setMaxIdle(10);								// 커넥션 풀에 유지할 수 있는 최대 커넥션 갯수
		ds.setTestWhileIdle(true);						// 커넥션 풀이 유휴 상태로 있는 동안에 검사할지 여부
		ds.setMinEvictableIdleTimeMillis(60000 * 3);	// 커넥션 풀에 유휴 상태로 유지할 최소 시간(밀리초)	: 3분
		ds.setTimeBetweenEvictionRunsMillis(10 * 1000);	// 커넥션 풀에 유휴 커넥션을 검사할 주기(밀리초) : 10초
		return ds;		
	}

	@Bean
	public PlatformTransactionManager transactionManager() {
		DataSourceTransactionManager tm = new DataSourceTransactionManager();
		tm.setDataSource(dataSource());
		return tm;
	}

	@Bean
	public ProcessDao processDao() {
		return new ProcessDao(dataSource());
	}
	
	@Bean
	public ErrorDAO errorDAO() {
	    return new ErrorDAO(dataSource());
	}
	
	@Bean
	public TableDAO tableDAO() {
	    return new TableDAO(dataSource());
	}

	@Bean
	public ErrorLogDAO errorLogDAO() {
	    return new ErrorLogDAO(dataSource());
	}
	
	@Bean
	public BoardDAO boardDAO() {
	    return new BoardDAO(dataSource());
	}



}
