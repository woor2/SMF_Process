package controller;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Map;
import java.util.Random;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;

public class TableDAO {
	static int successCount1=0;
	static int failureCount1 = 0;
	static int successCount2=0;
	static int failureCount2 = 0;
	static int successCount3=0;
	static int failureCount3 = 0;
	static int tf1;
	
	private static JdbcTemplate jdbcTemplate;
	
	public TableDAO(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	
	public static void goodcut(int csize,int cspeed) {
		String query = "insert into a_process（num,tf1,csize,cspeed,sc1,fc1,time1） values (PROCESS_SEQ.NEXTVAL,?,?,?,?,?,?)";
	    tf1 = 1;
		successCount1++;
		
		jdbcTemplate.update(query,tf1,csize,cspeed,successCount1,failureCount1,new Timestamp(System.currentTimeMillis()));
		
	}
	public static void badcut(int csize,int cspeed) {
		String query = "insert into a_process (num,tf1,csize,cspeed,sc1,fc1,time1) values (PROCESS_SEQ.NEXTVAL,?,?,?,?,?,?)";
		tf1 = 0;
		failureCount1++;
		jdbcTemplate.update(query,tf1,csize,cspeed,successCount1,failureCount1,new Timestamp(System.currentTimeMillis()));
		long insertedSeq = jdbcTemplate.queryForObject("SELECT PROCESS_SEQ.CURRVAL FROM dual", Long.class);
		String query1 = "insert into total (num,process,error,time) values(?,?,?,?)";
		String process = "a process";
		String error = "cutting error";
		jdbcTemplate.update(query1,insertedSeq,process,error,new Timestamp(System.currentTimeMillis()));
		
	}
	public static int readA() {
		// TODO Auto-generated method stub
		 String query = "select num from (SELECT num from a_process where tf1 = 1 and num not in (select num from b_process) order by time1 desc) where rownum <= 1";
		    int num = -1; // 默认返回值设为 -1 或其他合适的默认值

		    try {
		        num = jdbcTemplate.queryForObject(query, Integer.class);
		    } catch (EmptyResultDataAccessException e) {
		        // 处理查询结果为空的情况
		        // 可以选择抛出自定义异常、返回默认值或采取其他逻辑
		    }

		    return num;
		
		
	}
	public static void writeB(int num,int sealingT) {
		// TODO Auto-generated method stub
		String query = "insert into b_process (num,tf2,temperature,sc2,fc2,time2) values(?,?,?,?,?,?)";
	    int tf2 = 1;
	   
	    successCount2++;
	    jdbcTemplate.update(query,num,tf2,sealingT,successCount2,failureCount2,new Timestamp(System.currentTimeMillis()));			
	}

	public static int readB() {
		String query = "select num from (select num from b_process where tf2 = 1 and num not in (select num from c_process) order by time2 desc) where rownum <=1";
		int num = -1;
		try {
			num = jdbcTemplate.queryForObject( query,Integer.class);
		} catch (EmptyResultDataAccessException e) {
			
		}
		return num;
	}

	public static void writeC(int num, int environT, int standardW) {
		int tf3=0;
		int realW=500;
		String error3="";
		Random random = new Random();
		int randomNum = random.nextInt(10);
		if (20<=environT&&environT<=22) {
			if(randomNum<10) {tf3=1;}else {tf3=0;error3="온도 에러입니다.";}
			}
		else if (18 <=environT&&environT<20) {
			if(randomNum<8){tf3=1;}else {tf3=0;error3="온도 에러입니다.";}
		}
		else if (22<environT&&environT<=24) {
			if(randomNum<8){tf3=1;}else {tf3=0;error3="온도 에러입니다.";}
		}
		else if (environT<18||environT>24) {
			if(randomNum<5){tf3=1;}else {tf3=0;error3="온도 에러입니다.";}
		}
		if(tf3==1) {
			realW = standardW-(environT-21);
			if(standardW-2<=realW&&realW<=standardW+2) {tf3=1;}
			else {tf3=0;error3="무게 에러 입니다.";}
		}
		switch(tf3) {
		case 1:
			successCount3++;
			String sql = "insert into c_process (num,tf3,temperature,weight,sc3,fc3,time3) values(?,?,?,?,?,?,?)";
			jdbcTemplate.update(sql,num,tf3,environT,realW,successCount3,failureCount3,new Timestamp(System.currentTimeMillis()));
			break;
		case 0:
			failureCount3++;
			String sql1= "insert into c_process (num,tf3,temperature,weight,sc3,fc3,time3) values(?,?,?,?,?,?,?)";
			jdbcTemplate.update(sql1,num,tf3,environT,realW,successCount3,failureCount3,new Timestamp(System.currentTimeMillis()));
			String sqltot = "insert into total (num,process,error,time) values(?,?,?,?)";
			String process = "c process";
			jdbcTemplate.update(sqltot,num,process,error3,new Timestamp(System.currentTimeMillis()));
			break;
		default:
			break;
		}
		
		
	}

	public static int[] chart1() {
	    String query = "SELECT sc1, fc1 FROM (SELECT sc1, fc1 FROM a_process ORDER BY time1 DESC) WHERE ROWNUM <= 1";
	    
	    int[] result = new int[2];

	    try {
	        // 使用JdbcTemplate执行查询并获取单个对象
	        Map<String, Object> row = jdbcTemplate.queryForMap(query);
	        
	        // 从结果中获取sc1和fc1的值
	      
	        BigDecimal sc1BigDecimal = (BigDecimal) row.get("sc1");
	        BigDecimal fc1BigDecimal = (BigDecimal) row.get("fc1");

	        int sc1 = sc1BigDecimal.intValue();
	        int fc1 = fc1BigDecimal.intValue();

	        // 将值存储到result数组中
	        result[0] = sc1;
	        result[1] = fc1;
	    } catch (DataAccessException e) {
	        // 处理异常，比如日志记录或其他操作
	        e.printStackTrace();
	    }
	    
	    return result;
	}

	public static int[] chart2() {
	    String query = "SELECT sc2, fc2 FROM (SELECT sc2, fc2 FROM b_process ORDER BY time2 DESC) WHERE ROWNUM <= 1";
	    
	    int[] result = new int[2];

	    try {
	        // 使用JdbcTemplate执行查询并获取单个对象
	        Map<String, Object> row = jdbcTemplate.queryForMap(query);
	        
	        // 从结果中获取sc1和fc1的值
	      
	        BigDecimal sc1BigDecimal = (BigDecimal) row.get("sc2");
	        BigDecimal fc1BigDecimal = (BigDecimal) row.get("fc2");

	        int sc2 = sc1BigDecimal.intValue();
	        int fc2 = fc1BigDecimal.intValue();

	        // 将值存储到result数组中
	        result[0] = sc2;
	        result[1] = fc2;
	    } catch (DataAccessException e) {
	        // 处理异常，比如日志记录或其他操作
	        e.printStackTrace();
	    }
	    
	    return result;
	}
	
	public static int[] chart3() {
	    String query = "SELECT sc3, fc3 FROM (SELECT sc3, fc3 FROM c_process ORDER BY time3 DESC) WHERE ROWNUM <= 1";
	    
	    int[] result = new int[2];

	    try {
	        // 使用JdbcTemplate执行查询并获取单个对象
	        Map<String, Object> row = jdbcTemplate.queryForMap(query);
	        
	        // 从结果中获取sc1和fc1的值
	      
	        BigDecimal sc1BigDecimal = (BigDecimal) row.get("sc3");
	        BigDecimal fc1BigDecimal = (BigDecimal) row.get("fc3");

	        int sc3 = sc1BigDecimal.intValue();
	        int fc3 = fc1BigDecimal.intValue();

	        // 将值存储到result数组中
	        result[0] = sc3;
	        result[1] = fc3;
	    } catch (DataAccessException e) {
	        // 处理异常，比如日志记录或其他操作
	        e.printStackTrace();
	    }
	    
	    return result;
	}

	

	
	
	
	
}
