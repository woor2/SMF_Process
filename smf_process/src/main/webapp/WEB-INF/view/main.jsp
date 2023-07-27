<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
String authority = (String) session.getAttribute("AUTHORITY");
if (authority == null) {
    // 로그인 되지 않은 경우, 로그인 페이지로 이동
    response.sendRedirect("login");
} 
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MAIN PAGE</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="static/style.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

</head>
<body>
    <div id="container">
        <div id="sidebar">
            <!-- 左侧菜单栏内容 -->            
            <ul><li><h2>  수원1공장</h2></li>
            	<li><h2>Manufacturing</h2></li>
            	<li> <h2>Process</h2></li>
                <li><a href="#" data-panel="panel1">1공정 실시간 모니터링</a></li>
                <li><a href="#" data-panel="panel2">2공정 실시간 모니터링</a></li>
                <li><a href="#" data-panel="panel3">3공정 실시간 모니터링</a></li>
                <li><a href="#" data-panel="inventory">재고 관리</a></li>
                <li><a href="#" data-panel="production">공정&생산 관리</a></li>
               
            </ul>
        </div>
        <div id="right-panel">
            <div id="top-panel">
                <!-- 控制面板内容 -->
                <!-- 这里根据当前选中的菜单项来动态显示对应的控制面板 -->
                <div id="panel1" style="display: none;"><a href="step1">1. Cutting process</a></div>
                <div id="panel2" style="display: none;"><a href="step2">2. Packaging process</a></div>
                <div id="panel3" style="display: none;"><a href="step3">3. Lid attachment process</a></div>
                <div id="inventory" style="display: none;">
                    <form action="http://localhost:8584/smf_process/showBoardList" method='get'>
                        <button type='submit' class="custom-button">재고 확인</button>                        
                    </form>
                    <form action="javascript:void(0)" method='get'>
                        <button type="button" onClick=" showInventoryInputForm()" class="custom-button">재고 입력</button>                        
                    </form>
                    <form action="#" method='get'>
                    	<button type="button" onClick="showInventoryDeleteForm()" class="custom-button">재고 삭제</button>                    	                 
                    </form>
                    <form action="#" method='post'>
                    	<button type="button" onClick= "showInventorySearchForm()" class="custom-button">재고 검색</button>
                    </form>
                </div>
                <div id="production" style="display: none;">
                	<div style="display: inline-block;">
				        <form id="productionForm" action="http://localhost:8584/smf_process/startProduce" method="post">
				            <fieldset>
				                <legend>생산 관리</legend>
				                <p>select type of wet tissue to produce:
				                    <select name="type">
				                        <option>여우비</option>
				                        <option>슈</option>
				                        <option>베베랑</option>
				                    </select>
				                </p>
				                <p>input amount: <input name="amount" type="text"></p>
				                <button type="submit">submit</button>
				                <button type="reset">reset</button>
				            </fieldset>
				        </form>
                    </div>
                    <div style="display: inline-block;">
                    <form id="startA"  method='post' style="height:100%">
                        <fieldset>
                            <legend>1공정</legend>
                            <p>cutting speed :
                                <select name="cspeed">
                                    <option>1</option>
                                    <option>2</option>
                                    <option>3</option>
                                    <option>4</option>
                                </select>
                            </p>
                            <p>cutting size:<input name="csize" type="text"></p>
                            <input id="operate" type="hidden" name="operate" value="true">
                            <button type="button" onClick="startA(event)">startA</button>
                            <button type="reset">reset</button>
                            <button type="button"onClick="stopA(event)">stopA</button>
                        </fieldset>
                    </form>                   
                    </div>
                     <div style="display: inline-block;">
                    <form id="startB" method = 'post' style ="height:100%">
        		<fieldset>
        		<legend>2공정</legend>
        		<p>sealing temperature :<br>
        			<input name = "sealingTemperature" type="text">
        		</p>
        		
        		<button type = "button" onClick="startB(event)">startB</button>
        		<button type = "reset">reset</button>    
        		<input type = "hidden" name ="operate" value = "true">  
        		<button type = "button" onClick="stopB(event)">stopB</button>   		
        		</fieldset>      	      	
        	</form>        	
        	</div>
        	<div style="display: inline-block;">
        		<form id="startC" method = 'post' style ="height:80%">
        		<fieldset>
        		<legend>3공정</legend>
        		<p>environment temperature :<input name = "environmentTemperature" type="text"></p>  
        		<p>standard weight: <input name = "standard weight" type="text"></p>      		
        		<button type = "button" onClick="startC(event)">startC</button>
        		<button type = "reset">reset</button>    
        		<button type = "button" onClick="stopC(event)">stopC</button>
        		<input type = "hidden" name ="operate" value = "true">   		
        		</fieldset>      	      	
        	  </form>        	  	    	
        	</div>
                </div>
              
            </div>
            <div id="chart">
                <div id="chartContent"></div>
                 <div id="inventoryInputForm" style="display: none;">
			        <form id="inventoryInputF"action="#" method="post">
			            <fieldset>
			                <legend>재고 입력</legend>
			                <p>Batch Number:
			                    <input name="batchNumber" type="text">
			                </p>
			                <p>Specification(g/m²):
			                    <input name="specification" type="text">
			                </p>
			                <p>Length(m):
			                    <input name="length" type="text">
			                </p>
			                <p>Pattern or no:
			                    <input name="pattern" type="text">
			                </p>
			                <p>Roll Amount:
			                    <input name="rollAmount" type="text">
			                </p>
			                <button type="button" onClick="addBoard()">Submit</button>
			                <button type="reset">Reset</button>
			            </fieldset>
			        </form>
                  </div>
                  <div id="inventorySearchForm" style="display:none;">
                  	<form id="searchForm" action="http://localhost:8584/smf_process/searchBoard" method='get'>
                  	  <fieldset>
                  	  			<legend>재고검색</legend>
                  	  			<p>검색 방식:
                  	  			<select name="type">
                  	  				<option>batchNumber</option>
                  	  				<option>specification</option>
                  	  				<option>length</option>
                  	  				<option>pattern</option>
                  	  				<option>rollAmount</option>
                  	  			</select>
                  	  			<input name="value" type="text"> 
                  	  			<button type="submit">Submit</button><button type="reset">Reset</button></p>
                  	  </fieldset>                  	
                  	</form>
                  	</div>
                  <div id="inventoryDeleteForm" style="display:none;">
                  	<form id="inventoryDeleteF" action = "#" method="post">
                  	      <fieldset>
                  	        <legend>재고삭제</legend>
                  	        <P>BatchNumber 입력하세요:
                  	        	<input name="batchNumber" type="text">
                  	        </P>
                  	        <button type = "button" onClick="deleteBoard()">Submit</button>
                  	        <button type = "reset">Reset  </button>
                  	      </fieldset>                  	
                  	</form>
                  	</div>           
                <div id="board" style="display: none;">
                    <table id="boardTable">
                        <thead>
                            <tr>
                                <th>Batch Number</th>
                                <th>Specification(g/m²)</th>
                                <th>Length(m)</th>
                                <th>Patter or no</th>
                                <th>Roll Amount</th>
                            </tr>
                        </thead>
                        <tbody id="boardContent">
                        </tbody>
                    </table>
                </div>
                <div id="searchB" style="display:none;">
                	<table id = "resultTable">
                		<thead>
                			<tr>
                			 <th>Batch Number</th>
                             <th>Specification(g/m²)</th>
                             <th>Length(m)</th>
                             <th>Patter or no</th>
                             <th>Roll Amount</th>
                             </tr>
                		</thead>
                		<tbody id="resultContent"></tbody>          
                	</table>
                </div>
                <div id = "produce" style="display:none;">
                  <form id="updateRoll" method="post"">
                  	<button type="button"  class="custom-button" onClick="updateRollAmount()">submit</button>
					<table id = "pStartTable">
					<thead>
					<tr>
					 <th>Batch Number</th>
					 <th>Specification(g/m²)</th>
					 <th>Length(m)</th>
					 <th>Patter or no</th>
					 <th>Roll Amount</th>
					 <th>Selected Rolls</th>
					</tr>	
					</thead>
					<tbody id ="pstartContent">
					</tbody>
					</table>
					</form>
					<div id= "pchartcontainer">
					<div class="pc">
					<p>chart1</p>
						<canvas id="pie-chart1"></canvas>
					
					</div>
					<div class="pc">
					<p>chart2</p>
						 <canvas id="pie-chart2"></canvas>
					</div>
					<div class="pc">
					<p>chart3</p>
					    <canvas id="pie-chart3"></canvas>
					</div>
					</div>
					</div>
				   </div>
        </div>
    </div>
    <%@ include file="/main/main1.jsp" %>
</body>
</html>
