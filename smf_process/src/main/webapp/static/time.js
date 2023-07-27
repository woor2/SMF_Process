 function updateTime() {
        var now = new Date();
        var date = now.toLocaleDateString();
        var time = now.toLocaleTimeString();

        document.getElementById("date").innerHTML = date;
        document.getElementById("time").innerHTML = time;
    }

    setInterval(updateTime, 1000); // 1초마다 updateTime 함수 호출
   