package process;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Random;

import config.OracleInfo;

public class XProcess extends Thread {
    private Connection conn = null;
    private int taskNum;
    int successCountA = 0; // 총 성공량
    int failureCountA = 0; // 총 실패량
    int successCountB = 0; // 총 성공량
    int failureCountB = 0; // 총 실패량
    int successCountC = 0; // 총 성공량
    int failureCountC = 0; // 총 실패량
    private volatile boolean running = true;
    private volatile boolean paused = false;

    public XProcess(int taskNum) {
        this.taskNum = taskNum;
    }

    public void stopProcessing() {
        running = false;
        interrupt();
    }

    public void pauseProcessing() {
        paused = true;
    }

    public void resumeProcessing() {
        paused = false;
        synchronized (this) {
            notify();
        }
    }

    @Override
    public void run() {
        try {
            Class.forName(OracleInfo.driver);
            conn = DriverManager.getConnection(OracleInfo.url, OracleInfo.username, OracleInfo.password);

            if (conn != null) {
                for (int id = 1; id <= this.taskNum && running; id++) {
                    if (paused) {
                        try {
                            synchronized (this) {
                                while (paused) {
                                    wait();
                                }
                            }
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    }

                    int a_tf = taskA(id);

                    try {
                        Thread.sleep(2000); // 2초 딜레이
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }

                    int b_tf = taskB(id, a_tf);

                    try {
                        Thread.sleep(2000); // 2초 딜레이
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }

                    int c_tf = taskC(id, b_tf);
                }
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    int taskA(int id) {
        PreparedStatement pstmt = null;
        PreparedStatement pstmt2 = null;
        ResultSet rs = null;
        int tf = 0;
        String error1 = "";
        
        try {
            // 랜덤한 값 INSERT
            Random random = new Random();
            
            String sqltot = "insert into total values(?,?,?,?)";
	        pstmt2 = conn.prepareStatement(sqltot); 
            
        	int[] numbers = {2, 2, 2, 1};
            int index = random.nextInt(numbers.length);
            int cspeed = numbers[index];
            double csize = 0;
            final double ss = 128;

            if (cspeed == 1) {
                if (random.nextInt(2) == 0) {
                    csize = 130;
                } else {
                    csize = 129;
                }
            } else {
                csize = ss + cspeed;
            }

            if (csize == 130) {  // csize 값이 130인 경우 성공
                tf = 1;
                successCountA++;
            } else {
                tf = 0;
                failureCountA++;
                if (random.nextInt(2) == 1) {
                		error1="기계 에러 입니다.";
                	} else {
                		error1="사이즈 에러 입니다.";
                }
            }
            if (tf==0) {
            	  pstmt2.setInt(1, id);
            	  pstmt2.setString(2, "a_process");
            	  pstmt2.setString(3, error1);
            	  pstmt2.setTimestamp(4,new Timestamp(System.currentTimeMillis()));
            	  pstmt2.executeUpdate();
			  }
            
            String sqlInsert = "insert into a_process values (PROCESS_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?)";

            pstmt = conn.prepareStatement(sqlInsert);
            pstmt.setInt(1, tf);
            pstmt.setDouble(2, csize);
            pstmt.setInt(3, cspeed);
            pstmt.setInt(4, successCountA);
            pstmt.setInt(5, failureCountA);
            pstmt.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
            pstmt.executeUpdate();
            pstmt.close();
        
        if(tf == 1)
        	System.out.println("1공정 = " + id + "번째 제품 생산 : 정상");
        else
        	System.out.println("1공정 = " + id + "번째 제품 생산 : 불량품");
        } 
        catch (SQLException e) {
            e.printStackTrace();
        } 
        finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return tf;
    }
    
    int taskB(int id, int a_tf) {
        // 병렬로 실행할 작업을 정의합니다.
        PreparedStatement pstmt4 = null;
        PreparedStatement pstmt5 = null;
        int selectedTemperature = 0;
        String error2 = "";
        int b_tf = 0;
        
        try {
            String sqltot = "insert into total values(?,?,?,?)";
	        pstmt4 = conn.prepareStatement(sqltot); 
	        
        	if(a_tf == 1) {
				  Random random = new Random();
				  
				  int[] temperature = {182, 181, 180, 180, 180, 180, 180, 180, 180, 180, 180, 180, 180, 180, 180, 180, 180, 180, 179, 178};  
				  int index = random.nextInt(temperature.length);
				  selectedTemperature = temperature[index];
				
				  int randomNum = random.nextInt(10);
				  
				  if (selectedTemperature == 180) {
				      if (randomNum < 10) {
				    	  b_tf = 1;
				    	  
				      } else {
				    	  b_tf = 0;
				    	  error2="온도 에러 입니다.";
				      }
				  } else if (selectedTemperature == 179 || selectedTemperature == 181) { 
					  if (randomNum < 7) {
				    	  b_tf = 1;
				      } else {
				    	  b_tf = 0;
				    	  error2="온도 에러 입니다.";
				      }
				  } else if (selectedTemperature == 178  || selectedTemperature == 182) {
				      if (randomNum < 4) {
				    	  b_tf = 1;
				      } else {
				    	  b_tf = 0;
				    	  error2="온도 에러 입니다.";
				      }
				  } 
				  if (b_tf==0) {
					  failureCountB++;
					  pstmt4.setInt(1,id);
                  	  pstmt4.setString(2, "b_process");
                  	  pstmt4.setString(3, error2);
                  	  pstmt4.setTimestamp(4,new Timestamp(System.currentTimeMillis()));
                  	  pstmt4.executeUpdate(); 
				  }
				  else if (b_tf==1) {
					  successCountB++;
				  }
	              String sqlInsert = "insert into b_process values (?, ?, ?, ?, ?, ?) ";                    		
	              pstmt5 = conn.prepareStatement(sqlInsert);
	              
	              pstmt5.setInt(1, id);
	              pstmt5.setInt(2, b_tf);
	              pstmt5.setInt(3, selectedTemperature);
	              pstmt5.setInt(4, successCountB);
	              pstmt5.setInt(5, failureCountB);	              
	              pstmt5.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
	              pstmt5.executeUpdate();
	              
	              if(b_tf == 1)
	            	  System.out.println("					2공정 = " + id + "번째 제품 생산 : 정상");
	              else {
	            	  System.out.println("					2공정 = " + id + "번째 제품 생산 : 불량품");
	            	  
	              }      
        	}           
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt4 != null) pstmt4.close();
                if (pstmt5 != null) pstmt5.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return b_tf;
    }
    
    int taskC(int id, int b_tf) {
        // 병렬로 실행할 작업을 정의합니다.
        PreparedStatement pstmt8 = null;
        PreparedStatement pstmt9 = null;
        int selectedTemperature = 0;
        double rw = 0;
        String error3 = "";
        int c_tf = 0;

        try {
            String sqltot = "insert into total values(?,?,?,?)";
            pstmt8= conn.prepareStatement(sqltot);

            if (b_tf == 1) {
                Random random = new Random();

                int[] temperature = { 26, 27, 28, 29 };
                int index = random.nextInt(temperature.length);
                selectedTemperature = temperature[index];

                int randomNum = random.nextInt(10);

                if (selectedTemperature == 26) {
                    if (randomNum < 10) {
                        c_tf = 1;
                    } else {
                        c_tf = 0;
                        error3 = "온도 에러 입니다.";
                    }
                } else if (selectedTemperature == 27) {
                    if (randomNum < 9) {
                        c_tf = 1;
                    } else {
                        c_tf = 0;
                        error3 = "온도 에러 입니다.";
                    }
                } else if (selectedTemperature == 28) {
                    if (randomNum < 8) {
                        c_tf = 1;
                    } else {
                        c_tf = 0;
                        error3 = "온도 에러 입니다.";
                    }
                } else if (selectedTemperature == 29) {
                    if (randomNum < 7) {
                        c_tf = 1;
                    } else {
                        c_tf = 0;
                        error3 = "온도 에러 입니다.";
                    }
                }
                if (c_tf == 1) {
                    final double sw = 500;
                    rw = sw - selectedTemperature;
                    if (rw < 474) {
                        c_tf = 1;
                    } else {
                        c_tf = 0;
                        error3 = "무게 에러 입니다.";
                    }
                }
                if (c_tf==0) {
                	failureCountC++;
                    pstmt8.setInt(1, id);
                    pstmt8.setString(2, "c_process");
                    pstmt8.setString(3, error3);
                    pstmt8.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
                    pstmt8.executeUpdate();
                }
                else if (c_tf==1) {
                	successCountC++;
                }
                String sqlInsert = "insert into c_process values (?, ?, ?, ?, ?, ?, ?) ";

                pstmt9 = conn.prepareStatement(sqlInsert);
                pstmt9.setInt(1, id);
                pstmt9.setInt(2, c_tf);
                pstmt9.setInt(3, selectedTemperature);
                pstmt9.setDouble(4, rw);
                pstmt9.setInt(5, successCountC); // 성공 카운트 저장
                pstmt9.setInt(6, failureCountC); // 실패 카운트 저장
                pstmt9.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
                pstmt9.executeUpdate();
                pstmt9.close();

                if (c_tf == 1) 
                    System.out.println("      				                    			          3공정 = " + id + "번째 제품 생산 : 정상");
                 else {
                    System.out.println("      			                			                  3공정 = " + id + "번째 제품 생산 : 불량품");
                }
            }
        } 
        catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt8 != null) pstmt8.close();
                if (pstmt9 != null) pstmt9.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return c_tf;
    }

}
