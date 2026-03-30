<%@ page contentType="text/html;charset=UTF-8" %>
<script>
    // 防止后退按钮回到已登录页面
    window.addEventListener("pageshow", function(event) {
        if (event.persisted || (window.performance && window.performance.navigation.type === 2)) {
            // 页面从缓存恢复或者是浏览器后退
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
        padding: 0 30px;
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

    .topbar-right a {
        color: white;
        text-decoration: none;
        margin-left: 25px;
        font-size: 15px;
    }

    .topbar-right a:hover {
        text-decoration: underline;
    }

    .topbar-identity {
        margin-left: 25px;
        font-size: 15px;
        opacity: 0.9;
    }

    .page-content {
        padding-top: 70px; /* 避开顶部栏，防止内容被遮挡 */
    }
</style>

<div class="topbar">
    <div class="topbar-left">
        在线系统｜个人诊所
    </div>

    <div class="topbar-right">
        <!-- SpringMVC 路径 -->
        <a href="${pageContext.request.contextPath}/admin/index">主页</a >
        <a href="${pageContext.request.contextPath}/admin/doctor">管理医生</a >
        <a href="${pageContext.request.contextPath}/admin/medicine/list">库房</a >
        <a href="${pageContext.request.contextPath}/admin/account">管理账号</a >

        <span class="topbar-identity">
            身份：管理员（<%= username %>）
        </span>

        <!-- 退出登录按钮 -->
        <a href="${pageContext.request.contextPath}/logout">退出登录</a >
    </div>
</div>
