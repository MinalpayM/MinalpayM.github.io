<%@ page contentType="text/html;charset=UTF-8" %>
<script>
    // 防止后退按钮回到已登录页面
    window.addEventListener("pageshow", function(event) {
        if (event.persisted || (window.performance && window.performance.navigation.type === 2)) {
            window.location.reload(); // 强制刷新页面
        }
    });
</script>

<%
    com.clinic.model.SysUser u = (com.clinic.model.SysUser) session.getAttribute("user");
    String username = (u != null ? u.getUsername() : "未登录");
%>

<style>
    .topbar {
        width: 100%;
        height: 60px;
        background: #1e88e5;
        color: white;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0 20px; /* 右侧文字向左一点 */
        position: fixed;
        top: 0;
        left: 0;
        z-index: 1000;
        box-shadow: 0 2px 6px rgba(0,0,0,0.15);
        font-family: Arial, sans-serif;
    }

    .topbar-left {
        font-size: 18px;
        font-weight: bold;
        letter-spacing: 1px;
    }

    .topbar-right {
        display: flex;
        align-items: center;
        gap: 20px; /* 控制间距 */
    }

    .topbar-right a {
        color: white;
        text-decoration: none;
        font-size: 15px;
    }

    .topbar-right a:hover {
        text-decoration: underline;
    }

    .topbar-identity {
        font-size: 15px;
        opacity: 0.9;
        margin-left: 10px; /* 往左靠一点 */
    }

    .page-content {
        padding-top: 70px; /* 避开顶部栏 */
    }
</style>

<div class="topbar">
    <div class="topbar-left">
        在线系统｜个人诊所
    </div>

    <div class="topbar-right">
        <!-- 医生功能路径 -->
        
        <a href="${pageContext.request.contextPath}/doctor/patient">管理病人</a >
        <a href="${pageContext.request.contextPath}/doctor/prescription">开药</a >
        <a href="${pageContext.request.contextPath}/doctor/account">个人信息</a >

        <span class="topbar-identity">
            身份：医生（<%= username %>）
        </span>

        <!-- 退出登录按钮 -->
        <a href="${pageContext.request.contextPath}/logout">退出登录</a >
    </div>
</div>