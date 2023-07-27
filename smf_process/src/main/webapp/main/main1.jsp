<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.2/dist/echarts.min.js"></script>
    <script type="text/javascript" src="https://fastly.jsdelivr.net/npm/echarts@5.4.2/dist/echarts.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<script>
 // 点击菜单项切换面板和数据
    const menuItems = document.querySelectorAll("#sidebar a");
    const chartContent = document.getElementById("chartContent");
    const board = document.getElementById("board"); // 获取整个表格
    const boardContent = document.getElementById("boardContent"); // 获取表格的tbody元素
    const inventoryInputForm = document.getElementById("inventoryInputForm");
    const inventoryDeleteForm = document.getElementById("inventoryDeleteForm");
    const inventorySearchForm = document.getElementById("inventorySearchForm");
    const searchB = document.getElementById("searchB");
    const resultContent = document.getElementById("resultContent");
    let isTableShown = false; // 用于跟踪表格的显示状态
	let currentPanel = null;
    menuItems.forEach(item => {
        item.addEventListener("click", function(event) {
            event.preventDefault();
            const panelId = this.getAttribute("data-panel");

            // 隐藏所有控制面板
            const panels = document.querySelectorAll("#top-panel > div");
            panels.forEach(panel => {
                panel.style.display = "none";
            });

            // 根据选中的菜单项显示相应的控制面板
            const selectedPanel = document.getElementById(panelId);
            selectedPanel.style.display = "block";
			
            if(currentPanel !== null && currentPanel !== selectedPanel){
            	currentPanel.style.display = "none";
            }
            
            // 根据选中的菜单项更新显示区域内容
           // chartContent.textContent = "在这里显示" + this.textContent + "的数据";
         // 判断是否是在库输入菜单项，如果是，则显示在库输入表单，否则隐藏表单
            if (panelId === "inventoryInputForm") {
                inventoryInputForm.style.display = "block";
            } else {
                inventoryInputForm.style.display = "none";
            }
            if (panelId === "inventoryDeleteForm") {
                inventoryDeleteForm.style.display = "block";
            } else {
                inventoryDeleteForm.style.display = "none";
            }
            if (panelId === "inventorySearchForm") {
                inventorySearchForm.style.display = "block";
            } else {
                inventorySearchForm.style.display = "none";
            }
         
            // 清除整个表格
            board.style.display = "none";
            searchB.style.display = "none";
            isTableShown = false;
            
            currentPanel = selectedPanel;
        });
    });
	
    // 点击“재고확인”按钮后获取并显示板块数据
    const inventoryButton = document.querySelector("#inventory button");
    inventoryButton.addEventListener("click", function(event) {
        event.preventDefault();

        // 显示表格
        board.style.display = "block";
        // 隐藏在库输入表单
        inventoryInputForm.style.display = "none";
		inventoryDeleteForm.style.display = "none";
		inventorySearchForm.style.display = "none";
        // 获取并展示板块数据
        fetchBoardData();
        isTableShown = true;
    });

    // 用于获取并展示板块数据的函数
    function fetchBoardData() {
        fetch('http://localhost:8584/smf_process/showBoardList')
            .then(response => response.json())
            .then(data => {
                displayBoardData(data); // 调用显示板块数据的函数
            })
            .catch(error => console.error('获取板块数据时出错：', error));
    }
    
    function searchfetchBoardData(searchc, value) {
    	fetch('http://localhost:8584/smf_process/searchBoard?type=' + searchc + "&value=" + value)
    		.then(response => response.json())
    		.then(data => {
    			displayResultData(data);
    			alert("I've sent data"+data);
    		})
    		.catch(error => console.error("error occurs when getting data",error));
    	
    }
    

    // 显示板块数据的函数
    function displayBoardData(data) {
        // 清空表格内容
        boardContent.innerHTML = '';

        // 遍历数据，创建表格行来展示板块数据
        data.forEach(item => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${item.batchNumber}</td>
                <td>${item.specification}</td>
                <td>${item.length}</td>
                <td>${item.pattern}</td>
                <td>${item.rollAmount}</td>
            `;
            boardContent.appendChild(row);
        });
        //searchB.style.display = "none";
        inventorySearchForm.style.display = "none";
    }
    function displayResultData(data){
    	alert("I have received the data now let me handle them."+data);
    	resultContent.innerHTML =  '';
    	data.forEach(item => {
    		const row = document.createElement('tr');
    		row.innerHTML = `
    			 <td>${item.batchNumber}</td>
                <td>${item.specification}</td>
                <td>${item.length}</td>
                <td>${item.pattern}</td>
                <td>${item.rollAmount}</td>
                
                
            `;
            resultContent.appendChild(row);
    	});
    	const searchB = document.getElementById("searchB");
        searchB.style.display = "block";
        board.style.display = "none";
        isTableShown = false;
        
    }
    function showInventoryInputForm() {
        // 隐藏所有控制面板
       // const panels = document.querySelectorAll("#top-panel > div");
      //  panels.forEach(panel => {
       //     panel.style.display = "none";
       // });

        // 根据选中的菜单项显示相应的控制面板
        const selectedPanel = document.getElementById("inventoryInputForm");
        selectedPanel.style.display = "block";
        board.style.display = "none";
        isTableShown = false;


        // 根据选中的菜单项更新显示区域内容
       // chartContent.textContent = "please input ";
    }
    function showInventoryDeleteForm(){
    	const selectedPanel = document.getElementById("inventoryDeleteForm");
    	selectedPanel.style.display = "block";
    	isTableShown = false;
    	board.style.display = "none";
    }
	function showInventorySearchForm(){
		const selectedPanel = document.getElementById("inventorySearchForm");
		selectedPanel.style.display = "block";
		isTableShown = false;
		board.style.display = "none";
		
	}
	// 获取"재고 검색"表单的引用
	const searchForm = document.getElementById("searchForm");

	// 添加表单提交事件处理程序
	searchForm.addEventListener("submit", function (event) {
	    event.preventDefault();

	    // 获取表单数据并进行处理
	    const formData = new FormData(searchForm);
	    const searchc = formData.get("type");
	    const value = formData.get("value");

	    alert("searchc=" + searchc + ", value=" + value);
	    
	    // 调用searchfetchBoardData()函数以获取搜索结果数据并显示
	    searchfetchBoardData(searchc, value);
	});
	document.getElementById("productionForm").addEventListener("submit", submitProductionForm);

	 function submitProductionForm(event) {
	        event.preventDefault(); // 阻止默认的表单提交行为
	        alert("I have been activated.");
	        // 获取表单元素
	        const productionForm = document.getElementById("productionForm");

	        // 获取表单数据
	        const formData = new FormData(productionForm);
	        const type = formData.get("type"); // 获取type的值
	        const amount = formData.get("amount"); // 获取value的值

	        // 使用fetch API或其他方法来处理表单数据的提交
	        // 例如，可以使用fetch API来异步发送表单数据给服务器
	        fetch('http://localhost:8584/smf_process/startProduce?type=' + type + '&amount=' + amount, {
	            method: 'POST',
	            body: formData
	        })
	        .then(response => response.json())
		.then(data =>{
		  displaypstartContent(data);
	           
	        })
	        .catch(error => {
	            // 处理错误情况
	            console.error('Form submission failed:', error);
	        });
	    }
		 function displaypstartContent(data){
			 alert("I have received the data now let me handle them."+data);
			  pstartContent.innerHTML = '';
			data.forEach(item =>{
				const row = document.createElement('tr');
				row.innerHTML = `
				            <td>${item.batchNumber}</td>
			                <td>${item.specification}</td>
			                <td>${item.length}</td>
			                <td>${item.pattern}</td>
			                <td>${item.rollAmount}</td>
			                <td><input type="number" min="0" max="${item.rollAmount}" value="0" name="samount"> <input type="hidden" name="sbatchNumber" value="${item.batchNumber}"></td>
			            `;
				    pstartContent.appendChild(row);
					});
				const produceDiv = document.getElementById("produce");
				produceDiv.style.display = "block";
				}
		 function updateRollAmount(){
			 alert("update rollamount fuction start");
			 const selectedRolls = []; 

				  const rollAmountInputs = document.querySelectorAll('input[name="samount"]');
				  console.log("rollAmountInputs:", rollAmountInputs);
			    
			    const batchNumberInputs = document.querySelectorAll('input[name="sbatchNumber"]');
			    console.log("batchNumberInputs:", batchNumberInputs);
			    
			    for (let i = 0; i < rollAmountInputs.length; i++) {
			        const rollAmount = rollAmountInputs[i].value;
			        //alert("rollAmount:"+rollAmount);
			        const batchNumber = batchNumberInputs[i].value;
			       // alert("batchNumber:"+batchNumber);
			        selectedRolls.push({ batchNumber, rollAmount });
			    }

			    // 将数组转换成JSON字符串
			    const jsonData = JSON.stringify(selectedRolls);
				

			    // 使用AJAX通过POST请求将jsonData数据发送到服务器
			    const xhr = new XMLHttpRequest(); // 创建XMLHttpRequest对象
			    xhr.open('POST', 'http://localhost:8584/smf_process/updateRollAmount', true); // 配置请求方法和URL
			    xhr.setRequestHeader('Content-Type', 'application/json'); // 设置请求头的Content-Type为application/json，表示发送的是JSON数据
			    
			    xhr.onload = function() {
			        // 处理服务器响应，如果需要的话
			        if (xhr.status >= 200 && xhr.status < 300) {
			            console.log(xhr.responseText); // 在控制台打印服务器返回的响应数据
			        } else {
			            console.error('Request failed:', xhr.statusText); // 如果请求失败，则在控制台打印错误信息
			        }
			    };
			    
			    xhr.onerror = function() {
			        console.error('Request failed.'); // 如果请求出现错误，则在控制台打印错误信息
			    };
			    
			    xhr.send(jsonData); // 发送请求，并将jsonData作为请求体发送到服务器
			    alert("update rollamount fuction end i'v sent data:"+jsonData);
			    const produceTable = document.getElementById("updateRoll");
			    produceTable.style.display = "none";
		 }
		 function deleteBoard() {
		        const formData = $('#inventoryDeleteF').serialize(); // Serialize the form data

		        $.ajax({
		            type: 'POST',
		            url: 'http://localhost:8584/smf_process/deleteBoard', // Your server endpoint URL
		            data: formData,
		            success: function (response) {
		                // Handle the response from the server here, if needed
		                console.log('Board deleted successfully');
		            },
		            error: function (xhr, status, error) {
		                // Handle the error, if any
		                console.error('Error deleting board:', error);
		            }
		        });
		    }
		 function addBoard() {
			    const formData = $('#inventoryInputF').serialize(); // Serialize the form data

			    $.ajax({
			        type: 'POST',
			        url: 'http://localhost:8584/smf_process/addBoard', // Your server endpoint URL for adding a board
			        data: formData,
			        success: function (response) {
			            // Handle the response from the server here, if needed
			            console.log('Board added successfully');
			        },
			        error: function (xhr, status, error) {
			            // Handle the error, if any
			            console.error('Error adding board:', error);
			        }
			    });
			}

			//chart
	    const canvas = document.getElementById('pie-chart1');
        const ctx = canvas.getContext('2d');

        // 创建饼图对象
        const pieChart1 = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: ['成功数量', '失败数量'],
                datasets: [{
                    data: [0, 0], // 初始值为0
                    backgroundColor: ['rgba(75, 192, 192, 0.6)', 'rgba(255, 99, 132, 0.6)'],
                    borderColor: ['rgba(75, 192, 192, 1)', 'rgba(255, 99, 132, 1)'],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top'
                    },
                    title: {
                        display: true,
                        text: '成功与失败的饼图'
                    }
                }
            }
        });
        const canvas2 = document.getElementById('pie-chart2');
        const ctx2 = canvas2.getContext('2d');

        const pieChart2 = new Chart(ctx2, {
        	type: 'bar',
            data: {
                labels: ['成功数量', '失败数量'],
                datasets: [{
                    data: [0, 0], // 初始值为0
                    backgroundColor: ['rgba(75, 192, 192, 0.6)', 'rgba(255, 99, 132, 0.6)'],
                    borderColor: ['rgba(75, 192, 192, 1)', 'rgba(255, 99, 132, 1)'],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top'
                    },
                    title: {
                        display: true,
                        text: '成功与失败的饼图'
                    }
                }
            }
            
        });
        const canvas3 = document.getElementById('pie-chart3');
        const ctx3 = canvas3.getContext('2d');

        const pieChart3 = new Chart(ctx3, {
            // Configuration for chart3
            // ...
            type: 'pie',
            data: {
                labels: ['成功数量', '失败数量'],
                datasets: [{
                    data: [0, 0], // 初始值为0
                    backgroundColor: ['rgba(75, 192, 192, 0.6)', 'rgba(255, 99, 132, 0.6)'],
                    borderColor: ['rgba(75, 192, 192, 1)', 'rgba(255, 99, 132, 1)'],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top'
                    },
                    title: {
                        display: true,
                        text: '成功与失败的饼图'
                    }
                }
            }
        });

        // 使用Ajax定时获取数据并更新饼图
        function updatePieChart1() {
            // 使用Ajax发送请求到后端控制器（假设数据在 /api/data 接口上）
            $.ajax({
                url: 'http://localhost:8584/smf_process/piechart1', // 请将此URL替换为您的后端控制器的URL
                type: 'GET',
                dataType: 'json',
                success: function (data) {
                    // 更新饼图数据
                    pieChart1.data.datasets[0].data = [data[0], data[1]]; 
                    pieChart1.update(); // 更新饼图显示
                },
                error: function (xhr, status, error) {
                    console.error('获取数据时出错：', error);
                }
            });
        }
        function updatePieChart2() {
            // 使用Ajax发送请求到后端控制器（假设数据在 /api/data 接口上）
            $.ajax({
                url: 'http://localhost:8584/smf_process/piechart2', // 请将此URL替换为您的后端控制器的URL
                type: 'GET',
                dataType: 'json',
                success: function (data) {
                    // 更新饼图数据
                    pieChart2.data.datasets[0].data = [data[0], data[1]]; 
                    pieChart2.update(); // 更新饼图显示
                },
                error: function (xhr, status, error) {
                    console.error('获取数据时出错：', error);
                }
            });
        }
        function updatePieChart3() {
            // 使用Ajax发送请求到后端控制器（假设数据在 /api/data 接口上）
            $.ajax({
                url: 'http://localhost:8584/smf_process/piechart3', // 请将此URL替换为您的后端控制器的URL
                type: 'GET',
                dataType: 'json',
                success: function (data) {
                    // 更新饼图数据
                    pieChart3.data.datasets[0].data = [data[0], data[1]]; 
                    pieChart3.update(); // 更新饼图显示
                },
                error: function (xhr, status, error) {
                    console.error('获取数据时出错：', error);
                }
            });
        }

        // 每隔一段时间调用一次updatePieChart函数，模拟实时更新
          setInterval(updatePieChart1, 5000); // 5000 毫秒，即 5 秒
          setInterval(updatePieChart2, 5000); // 5000 毫秒，即 5 秒
          setInterval(updatePieChart3, 5000); // 5000 毫秒，即 5 秒	
		
        function startA(event) {
	        event.preventDefault(); // 阻止默认的表单提交行为
	        alert("NOW START A");
	        // 获取表单元素
	        const startAForm = document.getElementById("startA");

	        // 获取表单数据
	        const formData = new FormData(startAForm);
	        const csize = formData.get("csize"); // 获取type的值
	        const cspeed = formData.get("cspeed"); // 获取value的值
	        const operate= formData.get("operate")

	        // 使用fetch API或其他方法来处理表单数据的提交
	        // 例如，可以使用fetch API来异步发送表单数据给服务器
	        fetch('http://localhost:8584/smf_process/startA?csize=' + csize + '&cspeed=' + cspeed+'&operate='+operate, {
	            method: 'POST',
	            body: formData
	        })
	        .then(response => {
	            if (response.ok) {
	                console.log('START A 请求成功');
	            } else {
	                console.error('START A 请求失败:', response.status);
	            }
	        })
	        .catch(error => {
	            // 处理错误情况
	            console.error('Form submission failed:', error);
	        });
	    }
        function stopA(event) {
            event.preventDefault(); // 阻止默认的表单提交行为
            alert("NOW STOP A");

            // 使用fetch API或其他方法来处理停止请求
            // 例如，可以使用fetch API来异步发送停止请求给服务器
            fetch('http://localhost:8584/smf_process/stopA', {
                method: 'POST',
            })
            .then(response => {
                if (response.ok) {
                    console.log('停止请求成功');
                } else {
                    console.error('停止请求失败:', response.status);
                }
            })
            .catch(error => {
                // 处理错误情况
                console.error('停止请求失败：', error);
            });
        }
        function startB(event) {
	        event.preventDefault(); // 阻止默认的表单提交行为
	        alert("NOW START B");
	        // 获取表单元素
	        const startBForm = document.getElementById("startB");

	        // 获取表单数据
	        const formData = new FormData(startBForm);
	        const sealingTemperature = formData.get("sealingTemperature"); // 获取type的值
	      // 获取value的值
	        const operate= formData.get("operate")

	        // 使用fetch API或其他方法来处理表单数据的提交
	        // 例如，可以使用fetch API来异步发送表单数据给服务器
	        fetch('http://localhost:8584/smf_process/startB?sealingTemperature=' + sealingTemperature+'&operate='+operate, {
	            method: 'POST',
	            body: formData
	        })
	        .then(response => {
	            if (response.ok) {
	                console.log('START B 请求成功');
	            } else {
	                console.error('START B 请求失败:', response.status);
	            }
	        })
	        .catch(error => {
	            // 处理错误情况
	            console.error('Form submission failed:', error);
	        });
	    }
        function stopB(event) {
            event.preventDefault(); // 阻止默认的表单提交行为
            alert("NOW STOP B");

            // 使用fetch API或其他方法来处理停止请求
            // 例如，可以使用fetch API来异步发送停止请求给服务器
            fetch('http://localhost:8584/smf_process/stopB', {
                method: 'POST',
            })
            .then(response => {
                if (response.ok) {
                    console.log('停止请求成功');
                } else {
                    console.error('停止请求失败:', response.status);
                }
            })
            .catch(error => {
                // 处理错误情况
                console.error('停止请求失败：', error);
            });
        }
			
        function startC(event) {
	        event.preventDefault(); // 阻止默认的表单提交行为
	        alert("NOW START C");
	        // 获取表单元素
	        const startCForm = document.getElementById("startC");

	        // 获取表单数据
	        const formData = new FormData(startCForm);
	        const environmentTemperature = formData.get("environmentTemperature"); // 获取type的值
	        const standardweight = formData.get("standard weight"); // 获取value的值
	        const operate= formData.get("operate")

	        // 使用fetch API或其他方法来处理表单数据的提交
	        // 例如，可以使用fetch API来异步发送表单数据给服务器
	        fetch('http://localhost:8584/smf_process/startC?environmentTemperature=' + environmentTemperature + '&standardweight=' + standardweight+'&operate='+operate, {
	            method: 'POST',
	            body: formData
	        })
	        .then(response => {
	            if (response.ok) {
	                console.log('START C 请求成功');
	            } else {
	                console.error('START C 请求失败:', response.status);
	            }
	        })
	        .catch(error => {
	            // 处理错误情况
	            console.error('Form submission failed:', error);
	        });
	    }	
        function stopC(event) {
            event.preventDefault(); // 阻止默认的表单提交行为
            alert("NOW STOP C");

            // 使用fetch API或其他方法来处理停止请求
            // 例如，可以使用fetch API来异步发送停止请求给服务器
            fetch('http://localhost:8584/smf_process/stopC', {
                method: 'POST',
            })
            .then(response => {
                if (response.ok) {
                    console.log('停止请求成功');
                } else {
                    console.error('停止请求失败:', response.status);
                }
            })
            .catch(error => {
                // 处理错误情况
                console.error('停止请求失败：', error);
            });
        }		
		
    </script>
</body>
</html>