package controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import boards.BoardDAO;

// 假设Board类在这个包中

import boards.FabricBean;

@Controller
public class BoardController {
	
    private BoardDAO boardDAO;
    
    // @Autowired
    public BoardController(BoardDAO boardDAO) {
    	System.out.println("[BoardController] BoardController() " + boardDAO);
        this.boardDAO = boardDAO;
    }
    
    @PostMapping("/updateRollAmount")
    @ResponseBody
    public void updateRollAmount(@RequestBody List<Map<String, String>> requestData) {
    	System.out.println("[BoardController] /updateRollAmount : requestData=" + (requestData != null) );
    	
        for (Map<String, String> data : requestData) {
            String batchNumber = data.get("batchNumber");
            String samountStr = data.get("rollAmount");

            // 将samount转换为整数
            int samount = Integer.parseInt(samountStr);
            
            // 在这里调用boardDAO.updateBoard()方法来更新数据库中的数据
            // 假设boardDAO.updateBoard()方法的实现如下：
             boardDAO.updateRollAmount(batchNumber, samount);

            // 更新数据库操作代码可以根据您的具体情况进行调整
        }
    }
    
    
    
    
    
    @PostMapping("/startProduce")
    @ResponseBody
     public List<FabricBean> startProduction(@RequestParam("type") String type, @RequestParam("amount") int amount) {
        // 创建一个FabricBean列表，用于存储返回的多个FabricBean
    	System.out.println("[do startProduce] start");
        List<FabricBean> fabricList = new ArrayList<>();

        // 假设boardDAO.startProducton(type, amount)方法返回一个包含多个FabricBean的List
        List<FabricBean> result = boardDAO.startProduction(type, amount);

        // 将返回的FabricBean列表添加到fabricList中
        fabricList.addAll(result);
        
        System.out.println("[do startProduce] end"+fabricList);
        // 返回包含多个FabricBean的列表
        return fabricList;
    }
    
    
    
    @GetMapping("/searchBoard")
    @ResponseBody
    public void searchBoard(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{
    	System.out.println("[searchBoard] start");
    	String searchc = request.getParameter("type");
    	String value = request.getParameter("value");
    	System.out.println("[searchc:]"+searchc+"[value:]"+value);
    	List<FabricBean> searchResult =boardDAO.search(searchc,value);
    	
    	ObjectMapper objectMapper = new ObjectMapper();
    	response.setContentType("application/json");
    	response.setCharacterEncoding("utf-8");
    	response.getWriter().write(objectMapper.writeValueAsString(searchResult));
    }	
    
    
    @PostMapping("/deleteBoard")
    @ResponseBody
    public void deleteBoard(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{
    	System.out.println("[deleteBoard] start ");
    	String batchNumber = request.getParameter("batchNumber");
    	boardDAO.deleteBoard(batchNumber);
    	System.out.println("Batch Number: " + batchNumber);
    	System.out.println("[deleteBoard] end ");
    	//response.sendRedirect("index.html"); 
    }
    
    
    @PostMapping("/addBoard")
    @ResponseBody
    public void addBoard(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{

			System.out.println("[addBoard]start");
			 FabricBean fabricBean = new FabricBean();
			 String batchNumber = request.getParameter("batchNumber");
			    int specification = Integer.parseInt(request.getParameter("specification"));
			    int length = Integer.parseInt(request.getParameter("length"));
			    String pattern = request.getParameter("pattern");
			    int rollAmount = Integer.parseInt(request.getParameter("rollAmount"));

			    // 设置属性值
			    fabricBean.setBatchNumber(batchNumber);
			    fabricBean.setSpecification(specification);
			    fabricBean.setLength(length);
			    fabricBean.setPattern(pattern);
			    fabricBean.setRollAmount(rollAmount);

			    // 调用BoardDAO中的insertBoard方法将数据写入数据库
			    boardDAO.insertBoard(fabricBean);

			
			System.out.println("Batch Number: " + batchNumber);
			System.out.println("Specification: " + specification);
			System.out.println("Length: " + length);
			System.out.println("Pattern: " + pattern);
			System.out.println("Roll Amount: " + rollAmount);
			
          //  response.sendRedirect("index.html"); 
       }
    

    @GetMapping("/showBoardList")
    @ResponseBody
    public List<FabricBean> showBoardList() {
        // 将板块数据传递给前端页面
    	System.out.println("[showBoardList start] ");
    	List<FabricBean> boardList =boardDAO.getAllBoards();
        //model.addAttribute("boardList", boardList);
        System.out.println(boardList);
        System.out.println("[showBoardList end]");
        return boardList;
    }
    
    
    
    
    
}
