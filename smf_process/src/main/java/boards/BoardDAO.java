package boards;



import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

@Repository
public class BoardDAO {

    private final JdbcTemplate jdbcTemplate;

    // @Autowired
    public BoardDAO(DataSource dataSource) {
    	this.jdbcTemplate = new JdbcTemplate(dataSource);
        // this.jdbcTemplate = jdbcTemplate;
    }

    public List<FabricBean> getAllBoards() {
        String query = "SELECT * FROM board"; // 假设您的板块表名为 boards
        return jdbcTemplate.query(query,(rs,rowNum)->{
          	FabricBean board = new FabricBean();
            board.setBatchNumber(rs.getString("BATCHNUMBER"));
            board.setSpecification(rs.getInt("SPECIFICATION"));
            board.setLength(rs.getInt("LENGTH"));
            board.setPattern(rs.getString("PATTERN"));
            board.setRollAmount(rs.getInt("ROLLAMOUNT"));
            System.out.println("BoardDAO:" + board);
            return board;
        });
    }
    public void insertBoard(FabricBean board) {
        String query = "INSERT INTO board (BATCHNUMBER, SPECIFICATION, LENGTH, PATTERN, ROLLAMOUNT) VALUES (?, ?, ?, ?, ?)";
        Object[] params = {board.getBatchNumber(), board.getSpecification(), board.getLength(), board.getPattern(), board.getRollAmount()};
        jdbcTemplate.update(query, params);
    }

	
	public void deleteBoard(String batchNumber) {
		    String query = "DELETE FROM board WHERE BATCHNUMBER = ?";
		    Object[] params = {batchNumber};
		    jdbcTemplate.update(query, params);
		}

	public List<FabricBean> search(String searchc, String value) {
	    // 修整value以去除前导和尾随空格
	    if (value != null) {
	        value = value.trim();
	    }

	    // 检查jdbcTemplate是否不为null
	    if (jdbcTemplate == null) {
	        throw new IllegalStateException("jdbcTemplate not started properly");
	    }

	    String query = "SELECT * FROM board WHERE ";
	    switch (searchc) {
	        case "batchNumber":
	            query += "batchnumber = ?";
	            break;
	        case "specification":
	            query += "specification = ?";
	            break;
	        case "length":
	            query += "length = ?";
	            break;
	        case "pattern":
	            query += "pattern = ?";
	            break;
	        case "rollAmount":
	            query += "rollamount = ?";
	            break;
	        default:
	            throw new IllegalArgumentException("无效的搜索列：" + searchc);
	    }

	    // 执行查询并检索结果
	    List<FabricBean> fabricList = jdbcTemplate.query(query, (rs, rowNum) -> {
	        FabricBean fabricBean = new FabricBean();
	        fabricBean.setBatchNumber(rs.getString("BATCHNUMBER"));
	        fabricBean.setSpecification(rs.getInt("SPECIFICATION"));
	        fabricBean.setLength(rs.getInt("LENGTH"));
	        fabricBean.setPattern(rs.getString("PATTERN"));
	        fabricBean.setRollAmount(rs.getInt("ROLLAMOUNT"));
	        return fabricBean;
	    }, value);

	    return fabricList;
	}


	

	
	
	public List<FabricBean> startProduction(String type, int amount) {
        List<FabricBean> fabricList = new ArrayList<>();
        String query;

        switch (type) {
            case "여우비":
                query = "select * from board where specification = 58 and pattern = 'Y'";
                break;
            case "슈":
                query = "select * from board where specification = 35 and pattern = 'N'";
                break;
            case "베베랑":
                query = "select * from board where specification = 70 and pattern = 'Y'";
                break;
            default:
                query = "select * from board";
                break;
        }

        fabricList = jdbcTemplate.query(query, (rs, rowNum) -> {
            FabricBean fabricBean = new FabricBean();
            // 在这里根据数据库表中的字段设置FabricBean的属性
            fabricBean.setBatchNumber(rs.getString("batchNumber"));
            fabricBean.setSpecification(rs.getInt("specification"));
            fabricBean.setLength(rs.getInt("length"));
            fabricBean.setPattern(rs.getString("pattern"));
            fabricBean.setRollAmount(rs.getInt("rollAmount"));
            return fabricBean;
        });

        return fabricList;
    }

	public void updateRollAmount(String batchNumber, int samount) {
	    // 从数据库中查询对应batchNumber的记录
	    String query = "SELECT * FROM board WHERE BATCHNUMBER = ?";
	    Object[] params = {batchNumber};
	    FabricBean board = jdbcTemplate.queryForObject(query, params, new BeanPropertyRowMapper<>(FabricBean.class));

	    // 获取现有的rollAmount值
	    int existingRollAmount = board.getRollAmount();
	    System.out.println("existingRollAmount: "+existingRollAmount);
	    // 计算更新后的rollAmount值
	    int updatedRollAmount = existingRollAmount - samount;
	    System.out.println("updatedRollAmount: "+updatedRollAmount);
	    // 更新数据库中的数据
	    String updateQuery = "UPDATE board SET ROLLAMOUNT = ? WHERE BATCHNUMBER = ?";
	    Object[] updateParams = {updatedRollAmount, batchNumber};
	    jdbcTemplate.update(updateQuery, updateParams);
	}
    
	
	
	
	
	
	
	}
    
    
    
    


