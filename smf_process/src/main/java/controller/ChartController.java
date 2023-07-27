package controller;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;



@Controller
public class ChartController {
	
	boolean shouldExitA = false;
	boolean shouldExitB = false;
	boolean shouldExitC = false;
	final static int MachineN = 20;
	private ErrorDAO errorDAO;
	
	//@Autowired
	public ChartController(ErrorDAO errorDAO) {
		this.errorDAO = errorDAO;
	}
	@PostMapping("/chart")
	public void doChart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("[ChartController] /chart");
		
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		//PrintWriter writer = response.getWriter();

		JSONArray charts = new JSONArray();
		
		
		for (int cnt=0;cnt<MachineN; cnt++) {
			int x = (int)(Math.random()*2+0.5);
			charts.add(x);
		}
		
		String jsonInfo = charts.toJSONString();
		System.out.println(jsonInfo);
		response.getWriter().print(jsonInfo);
		
	}
	
	@PostMapping("/t_chart")
	public void cut_chart(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{
		System.out.println("[ChartController] /cut_chart");
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter writer = response.getWriter();
		
		JSONArray charts = new JSONArray();
		for (int cnt=0;cnt<MachineN; cnt++) {
			int x = (int)(1-Math.random());
			charts.add(x);
		}
		String jsonInfo = charts.toJSONString();
		System.out.println(jsonInfo);
		writer.print(jsonInfo);
		
	}
	@PostMapping("/errorchart")
	public void errorchartdo(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{
		System.out.println("[chartcontroller] /errorchart ");
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		
		String type = (String)request.getParameter("selectField");
		String sql;
		if (type.equals("일별")) {
			
			List<Error> errors = errorDAO.getErrorsByDay();
		}
		else if (type.equals("월별")) {
			sql = "select * from error where month = ?";
			List<Error> errors = errorDAO.getErrorsByMonth();
		}
		else if (type.equals("공정별")) {
			sql = "";
			List<Error> errors = errorDAO.getErrorsByMonth();
		}
		
	}
	
	@PostMapping("/startA")
	public void startA(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{
		
		int standardsize =Integer.parseInt(request.getParameter("csize"));
		int csize = 0;
		int cspeed = Integer.parseInt(request.getParameter("cspeed"));
		boolean operate = Boolean.parseBoolean(request.getParameter("operate"));
	   
		Random random = new Random();
		int[]numbers1 = {0,0,0,0,0,0,0,0,0,0,0,-1,1};
		int[] numbers2 = {0,0,0,2,-1,-2,0,0,1,0,0,0,0};
		int[] numbers3 = {0,0,0,0,-1,-2,3,1,0,0,0,0,2};
		int[] numbers4 = {0,0,0,0,0,0,0,-4,3,-2,1,-1,4,3,-8};
		shouldExitA = false;
		if(operate) {
			while(!shouldExitA) {
				switch(cspeed) {
				case 1:
					int index1 = random.nextInt(numbers1.length);
					csize = standardsize + numbers1[index1];
					break;
				case 2:
					int index2 = random.nextInt(numbers2.length);
					csize = standardsize + numbers2[index2];
					break;
				case 3:
					int index3 = random.nextInt(numbers3.length);
					csize = standardsize + numbers3[index3];
					break;
				case 4:
					int index4 = random.nextInt(numbers4.length);
					csize = standardsize + numbers4[index4];
					break;
				default:
					break;
				}
			if(standardsize-1<= csize&& csize<=standardsize+1) {
				TableDAO.goodcut(csize,cspeed);
			}
			else {
				TableDAO.badcut(csize,cspeed);
			}
			try {
			    Thread.sleep(1000); // 等待一秒钟
			} catch (InterruptedException e) {
			    e.printStackTrace();
			}
			}
		}
		
		// response.sendRedirect("index.html");
	}
	
	@PostMapping("/stopA")
	@ResponseBody
	 public void  stopA(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{
		shouldExitA = true;
		 
	}
	@PostMapping("/startB")
	 public void startB(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{
		System.out.println("[startB controller]start");
		int sealingT = Integer.parseInt(request.getParameter("sealingTemperature"));
		boolean operate = Boolean.parseBoolean(request.getParameter("operate"));
		Random random = new Random();
		shouldExitB = false;
		//int []numbers1 = {0,0,0,0,0,0,0,0,0,0,-1,1};
		//int []numbers2 = {0,0,0,0,0,0,0,0,0,0,-1,1,-2,2};
		//int []numbers3 = {0,0,0,0,0,0,0,0,0,0,-1,-2,-3,
		if(operate) {
			while(!shouldExitB) {
				int num=TableDAO.readA();
				if(num!=-1) {
				TableDAO.writeB(num,sealingT);
				System.out.println("Data written to Oracle: num = " + num + ", sealingT = " + sealingT);
				}
				else {
					shouldExitB= true;
					operate = false;
				}
				try {
				    Thread.sleep(1000); // 等待一秒钟
				} catch (InterruptedException e) {
				    e.printStackTrace();
				}
				
			}
		}
	}
	
	@PostMapping("/stopB")
	 public void  stopB(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{
		shouldExitB = true;
		
	}
	
	@PostMapping("/startC")
	public void startC(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{
		int environT = Integer.parseInt(request.getParameter("environmentTemperature"));
		boolean operate = Boolean.parseBoolean(request.getParameter("operate"));
		int standardW = Integer.parseInt(request.getParameter("standardweight"));
		shouldExitC = false;
		if(operate) {
			while(!shouldExitC) {
				int num = TableDAO.readB();
				if(num!=-1) {
				TableDAO.writeC( num, environT, standardW);}
				else {
					shouldExitC = true;
					operate = false;
				}
				try {
				    Thread.sleep(1000); // 等待一秒钟
				} catch (InterruptedException e) {
				    e.printStackTrace();
				}
				}
			}
			
		    
	  }
	
	@PostMapping("/stopC")
	 public void  stopC(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{
		shouldExitC = true;
		
	}
	
	
	@GetMapping("/piechart1")
	@ResponseBody
	public int[] dopiechart1() {
		 int[] result = TableDAO.chart1();
		    
		return result;
		
	}
	@GetMapping("/piechart2")
	@ResponseBody
	public int[] dopiechart2() {
		 int[] result = TableDAO.chart2();
		    
		return result;
		
	}
	
	@GetMapping("/piechart3")
	@ResponseBody
	public int[] dopiechart3() {
		 int[] result = TableDAO.chart3();
		    
		return result;
		
	}
	
	
	
	
	
	
	
	

}
