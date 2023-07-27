package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import controller.ErrorLog;
import controller.ErrorLogDAO;

@Controller
public class MainController {
    private final ErrorLogDAO errorLogDAO;

    // @Autowired
    public MainController(ErrorLogDAO errorLogDAO) {
        this.errorLogDAO = errorLogDAO;
    }

    @GetMapping("/main")
    public String showMainPage(Model model) {
    	System.out.println("[MainController] /main start");
        List<ErrorLog> errorLogs = errorLogDAO.getAllErrorLogs();
        System.out.println(errorLogs);
        model.addAttribute("errorLogs", errorLogs);
        System.out.println("[MainController] /main end");
        return "main";
    }
    
    @PostMapping("/mainchart")
    public void dochart(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{
    	request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter writer = response.getWriter();
		JSONArray charts = new JSONArray();
		charts = (JSONArray) errorLogDAO.getAllErrorLogs();
		String jsonInfo = charts.toJSONString();
		System.out.println(jsonInfo);
		writer.print(jsonInfo);
    }
}

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
	
	


