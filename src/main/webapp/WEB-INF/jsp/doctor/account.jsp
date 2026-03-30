<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/jsp/common/doctor_header.jsp" %>

<script>
    document.title = "修改信息";
</script>

<style>
body{
    background:#f5f6f7;
    font-family: Arial, sans-serif;
}
.container{
    width:90%;
    margin:90px auto 0;
    display:flex;
    gap:30px;
    align-items:flex-start;
}

/* 左侧 */
.left{
    width:45%;
    display:flex;
    flex-direction:column;
    gap:20px;
}
.card{
    background:#fff;
    border-radius:10px;
    padding:20px 25px;
    box-shadow:0 4px 12px rgba(0,0,0,.08);
}
.profile{
    text-align:center;
}
.profile img{
    width:120px;
    height:120px;
    border-radius:50%;
    object-fit:cover;
    border:3px solid #1e88e5;
}
.profile h2{
    margin:12px 0 5px;
    color:#1e88e5;
    font-size:20px;
}
.profile span{
    color:#777;
    font-size:14px;
    letter-spacing:1px;
}

.info-row{
    display:flex;
    margin-bottom:12px;
    font-size:15px;
}
.info-label{
    width:90px;
    color:#666;
    font-weight:bold;
}
.info-value{
    color:#333;
}

/* 右侧 */
.right{
    width:55%;
    display:flex;
    flex-direction:column;
    gap:20px;
}
.form-group{
    margin-bottom:12px;
    position: relative;
}
.form-group input{
    width:100%;
    padding:10px;
    border-radius:5px;
    border:1px solid #ccc;
    transition:0.2s;
}
.form-group input:focus{
    border-color:#1e88e5;
    box-shadow:0 0 5px rgba(30,136,229,.3);
}
.hint{
    font-size:12px;
    color:#666;
    margin:5px 0 10px;
}
.btn{
    width:100%;
    padding:12px;
    background:#1e88e5;
    border:none;
    border-radius:6px;
    color:#fff;
    cursor:pointer;
    font-size:15px;
    font-weight:bold;
    transition:0.3s;
}
.btn:hover{
    background:#1565c0;
}

/* 密码眼睛 */
.pwd-box{
    position:relative;
}
.pwd-box input{
    height:42px;
    line-height:42px;
    padding-right:42px;
}
.eye{
    position:absolute;
    right:12px;
    top:0;
    height:42px;
    display:flex;
    align-items:center;
    cursor:pointer;
    font-size:18px;
    color:#666;
}

/* ===== 高级提示框 ===== */
.toast{
    position:fixed;
    top:50%;
    left:50%;
    transform:translate(-50%,-40%);
    padding:16px 28px;
    border-radius:10px;
    font-size:15px;
    font-weight:500;
    color:#fff;
    letter-spacing:.5px;
    box-shadow:0 6px 18px rgba(0,0,0,.25);
    opacity:0;
    transition:all .35s ease;
    z-index:3000;
}
.toast.show{
    opacity:1;
    transform:translate(-50%,-50%);
}
.toast.success{
    background:linear-gradient(135deg,#43cea2,#2ebf91);
}
.toast.error{
    background:linear-gradient(135deg,#ff5f6d,#ffc371);
}
.toast.info{
    background:linear-gradient(135deg,#1e88e5,#42a5f5);
}
</style>

<div class="container">

    <!-- 左侧 -->
    <div class="left">

        <div class="card profile">
            <img src="${pageContext.request.contextPath}/${doctor.avatar != null ? doctor.avatar : 'images/default.png'}">
            <h2>${user.username}</h2>
            <span>医生账号</span>
        </div>

        <div class="card">
            <div class="info-row"><div class="info-label">姓名</div><div class="info-value">${doctor.name}</div></div>
            <div class="info-row"><div class="info-label">性别</div><div class="info-value">${doctor.gender=='M'?'男':'女'}</div></div>
            <div class="info-row"><div class="info-label">出生日期</div><div class="info-value">${doctor.birthDate}</div></div>
            <div class="info-row"><div class="info-label">职称</div><div class="info-value">${doctor.title}</div></div>
            <div class="info-row"><div class="info-label">电话</div><div class="info-value">${doctor.phone}</div></div>
            <div class="info-row"><div class="info-label">地址</div><div class="info-value">${doctor.address}</div></div>
            <div class="info-row"><div class="info-label">身份证</div><div class="info-value">${doctor.idCard}</div></div>
        </div>

    </div>

    <!-- 右侧 -->
    <div class="right">

        <div class="card">
            <h3 style="color:#1e88e5">修改账号信息</h3>
            <form id="accountForm">
                <div class="form-group">
                    <input name="username" placeholder="新用户名（不填则默认原用户名）">
                    <div class="hint">字母或数字，5~10 位，不能以数字开头</div>
                </div>
                <div class="form-group pwd-box">
                    <input type="password" id="pwd" name="password" placeholder="新密码（不填则默认原密码）">
                    <span class="eye" onclick="togglePwd()">👁</span>
                    <div class="hint">字母+数字组合，5~15 位</div>
                </div>
                <button type="button" class="btn" onclick="updateAccount()">确认更新</button>
            </form>
        </div>

        <div class="card">
            <h3 style="color:#1e88e5">修改联系方式</h3>
            <div class="hint">其他信息请联系管理员修改</div>
            <form id="doctorForm">
                <div class="form-group">
                    <input name="phone" value="${doctor.phone}">
                </div>
                <div class="form-group">
                    <input name="address" value="${doctor.address}">
                </div>
                <button type="button" class="btn" onclick="updateDoctor()">确认更新</button>
            </form>
        </div>

    </div>
</div>

<div id="toast" class="toast"></div>

<script>
function showToast(msg,type){
    const t=document.getElementById("toast");
    t.className="toast show "+(type||"info");
    t.innerText=msg;
    setTimeout(()=>t.classList.remove("show"),3000);
}

function updateAccount(){
    fetch("${pageContext.request.contextPath}/doctor/account/updateAccount",{
        method:"POST",
        body:new FormData(accountForm)
    }).then(r=>r.text()).then(res=>{
        if(res==="ok") showToast("✔ 账号信息已更新","success"),setTimeout(()=>location.reload(),1500);
        else if(res==="invalidUsername") showToast("用户名不符合规范","error");
        else if(res==="invalidPassword") showToast("密码不符合规范","error");
        else if(res==="empty") showToast("请至少修改一项","info");
        else showToast("更新失败","error");
    });
}

function updateDoctor(){
    fetch("${pageContext.request.contextPath}/doctor/account/updateDoctor",{
        method:"POST",
        body:new FormData(doctorForm)
    }).then(r=>r.text()).then(res=>{
        if(res==="ok") showToast("✔ 联系方式已更新","success"),setTimeout(()=>location.reload(),1500);
        else showToast("更新失败","error");
    });
}

function togglePwd(){
    const p=document.getElementById("pwd");
    p.type=p.type==="password"?"text":"password";
}
</script>