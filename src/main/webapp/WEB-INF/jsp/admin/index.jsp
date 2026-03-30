<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<script>
    document.title = "管理员主页";
</script>

<style>
body {
    background: #f5f6f7;
    font-family: Arial, sans-serif;
    margin:0;
    padding:0;
}
.container {
    display: flex;
    width: 100%;
    height: calc(100vh - 60px);
    margin-top: 60px;
}

/* 左侧 */
.left-panel {
    width: 20%;
    padding: 20px;
    box-sizing: border-box;
}
.left-panel .card {
    background: #fff;
    border-radius: 8px;
    padding: 20px;
    margin-bottom: 20px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.08);
    text-align: center;
}
#clock { font-size: 20px; font-weight: bold; color: #1e88e5; }
#calendar { width: 100%; border-collapse: collapse; margin-top: 10px; text-align: center; }
#calendar th, #calendar td { width: 14.28%; height: 40px; text-align: center; vertical-align: middle; }
#calendar th { color: #1e88e5; font-weight: bold; }
#calendar td.today { border: 2px solid #1e88e5; border-radius: 50%; font-weight: bold; color: #1e88e5; }

/* 右侧 */
.right-panel {
    width: 80%;
    display: flex;
    flex-direction: column;
    gap: 20px;
    padding: 20px;
    box-sizing: border-box;
}
.card {
    background: #fff;
    border-radius: 8px;
    padding: 20px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.08);
}
.card-title {
    font-size: 16px;
    font-weight: bold;
    color: #1e88e5;
    margin-bottom: 15px;
}

/* 医生概览 + 库房概览 */
.overview-box {
    display: flex;
    gap: 20px;
    min-height: 400px;
}
.overview-box .card {
    flex: 1;
    overflow-y: auto;
    cursor: pointer;
}

/* 医生列表 */
.doctor-item {
    display: flex;
    align-items: center;
    margin-bottom: 12px;
}
.doctor-item img {
    width: 60px; height: 60px;
    border-radius: 50%;
    object-fit: cover;
    margin-right: 12px;
}
.doctor-item span { font-size: 14px; }

/* 库房列表 */
.medicine-item { margin-bottom: 8px; font-size: 14px; }
.medicine-item.low { font-weight: bold; }
</style>

<div class="container">

    <!-- 左侧：时间 + 日历 -->
    <div class="left-panel">
        <div class="card">
            <div class="card-title">当前时间</div>
            <div id="clock"></div>
        </div>
        <div class="card">
            <div class="card-title">日历</div>
            <table id="calendar"></table>
        </div>
    </div>

    <!-- 右侧 -->
    <div class="right-panel">

        <!-- 账号信息 -->
        <div class="card">
            <div class="card-title">账号信息</div>
            <p>用户名：${user.username}</p >
            <p>角色：${user.role}</p >
        </div>

        <!-- 医生概览 + 库房概览 -->
        <div class="overview-box">

            <!-- 医生概览 -->
            <div class="card" onclick="location.href='${pageContext.request.contextPath}/admin/doctor'">
                <div class="card-title">医生概览（共 ${totalDoctors} 人）</div>
                <c:forEach var="d" items="${doctors}">
                    <div class="doctor-item">
                        <img src="${pageContext.request.contextPath}/${d.avatar}" alt="${d.name}">
                        <span>${d.name}（${d.age}岁）</span>
                    </div>
                </c:forEach>
            </div>

            <!-- 库房概览 -->
            <div class="card" onclick="location.href='${pageContext.request.contextPath}/admin/medicine/list'">
                <div class="card-title">库房概览（共 ${medicineCount} 种药品）</div>
                <c:forEach var="m" items="${medicines}">
                    <div class="medicine-item ${m.stock < 10 ? 'low' : ''}">
                        ${m.medicineName}：${m.stock} 件
                    </div>
                </c:forEach>
            </div>

        </div>
    </div>
</div>

<script>
// 时钟
function updateClock() {
    const now = new Date();
    document.getElementById("clock").innerText = now.toLocaleString();
}
setInterval(updateClock, 1000);
updateClock();

// 日历
function generateCalendar() {
    const now = new Date();
    const year = now.getFullYear();
    const month = now.getMonth();
    const today = now.getDate();
    const firstDay = new Date(year, month, 1).getDay();
    const daysInMonth = new Date(year, month+1, 0).getDate();
    const calendar = document.getElementById("calendar");
    calendar.innerHTML = "";
    const header = ["日","一","二","三","四","五","六"];
    let tr = document.createElement("tr");
    header.forEach(h => { let th=document.createElement("th"); th.innerText=h; tr.appendChild(th); });
    calendar.appendChild(tr);
    let trDays=document.createElement("tr");
    let dayCounter=1;
    for(let i=0;i<7;i++){
        let td=document.createElement("td");
        if(i<firstDay){ td.innerText=""; }
        else { td.innerText=dayCounter; if(dayCounter===today) td.classList.add("today"); dayCounter++; }
        trDays.appendChild(td);
    }
    calendar.appendChild(trDays);
    while(dayCounter<=daysInMonth){
        let tr=document.createElement("tr");
        for(let i=0;i<7;i++){
            let td=document.createElement("td");
            if(dayCounter<=daysInMonth){
                td.innerText=dayCounter;
                if(dayCounter===today) td.classList.add("today");
                dayCounter++;
            } else td.innerText="";
            tr.appendChild(td);
        }
        calendar.appendChild(tr);
    }
}
generateCalendar();
</script>
