package process;

public class XProcessMain {
    public static int MAX_TASKNUM = 1000;
    
    public static void main(String[] args) {
    	
        XProcess xp = new XProcess(MAX_TASKNUM);
        
        xp.start();
    }
}
