package controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import process.XProcess;

@Controller
public class ProcessController {
	
	private ProcessDao processDao;
	private XProcess xp;
	
	public ProcessController(ProcessDao processDao) {
		this.processDao = processDao;
	}
	
	@GetMapping("/home")
	public String doHome() {
		return "home";
	}

	@PostMapping("/process.do")
	public String doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		
    	System.out.println("/process.do");
    	
        String action = request.getParameter("action");
        System.out.println("@@@ action=" + action);

        if (action != null) {
            switch (action) {
                case "start":
                    int maxTaskNum = Integer.parseInt(request.getParameter("maxTaskNum"));
                    xp = new XProcess(maxTaskNum);
                    xp.start();
                    break;
                case "stop":
                    // 작업 중지 요청을 받았을 때, XProcess의 stopProcessing() 메서드 호출하여 작업 중지
                    if (xp != null) {
                        xp.stopProcessing();
                    }
                    break;
                case "pause":
                    // 작업 일시 중지 요청을 받았을 때, XProcess의 pauseProcess() 메서드 호출하여 작업 일시 중지
                    if (xp != null) {
                        xp.pauseProcessing();
                    }
                    break;
                case "resume":
                    // 작업 재개 요청을 받았을 때, XProcess의 resumeProcess() 메서드 호출하여 작업 재개
                    if (xp != null) {
                        xp.resumeProcessing();
                    }
                    break;
                case "deleteData":
                    // 작업 재개 요청을 받았을 때, XProcess의 resumeProcess() 메서드 호출하여 작업 재개
                    processDao.deleteData();
                    break;
                default:
                    // 지원하지 않는 액션에 대한 처리 (예외 처리 등)
                    break;
            }
        }

        return "home";
	}

}
