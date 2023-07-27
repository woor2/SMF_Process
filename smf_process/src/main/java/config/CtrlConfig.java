package config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import boards.BoardDAO;
import controller.BoardController;
import controller.ChartController;
import controller.ErrorDAO;
import controller.ProcessController;
import controller.ProcessDao;

@Configuration
public class CtrlConfig {
	
	@Autowired
	private ProcessDao processDao;

	@Bean
	public ProcessController processController() {
		return new ProcessController(processDao);
	}

	@Bean
	public ChartController chartController(ErrorDAO errorDAO) {
		return new ChartController(errorDAO);
	}
	
	@Bean
	public BoardController boardController(BoardDAO boardDAO) {
		return new BoardController(boardDAO);
	}

	
}
