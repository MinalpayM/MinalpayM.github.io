<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<script>
    document.title = "管理账号";
</script>
<style>
    .container {
        padding-top: 80px;
        width: 95%;
        margin: auto;
    }
    
    .header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }
    
    .search-bar {
        display: flex;
        gap: 10px;
        margin-bottom: 20px;
    }
    
    .search-bar input {
        flex: 1;
        padding: 8px;
        border: 1px solid #ccc;
        border-radius: 5px;
    }
    
    .btn-primary {
        background: #1e88e5;
        color: white;
        border: none;
        padding: 8px 16px;
        border-radius: 5px;
        cursor: pointer;
        text-decoration: none;
    }
    
    .user-table {
        width: 100%;
        background: white;
        border-radius: 8px;
        box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        overflow: hidden;
    }
    
    .user-table th,
    .user-table td {
        padding: 12px 15px;
        text-align: left;
        border-bottom: 1px solid #eee;
    }
    
    .user-table th {
        background: #f8f9fa;
        font-weight: bold;
    }
    
    .status-active {
        color: #4caf50;
        font-weight: bold;
    }
    
    .status-inactive {
        color: #f44336;
        font-weight: bold;
    }
    
    .actions a {
        margin-right: 10px;
        color: #1e88e5;
        text-decoration: none;
    }
    
    .badge {
        padding: 3px 8px;
        border-radius: 10px;
        font-size: 12px;
        margin-left: 5px;
    }
    
    .badge-admin {
        background: #ff9800;
        color: white;
    }
    
    .badge-doctor {
        background: #2196f3;
        color: white;
    }
    
    .badge-staff {
        background: #4caf50;
        color: white;
    }
</style>

<div class="container">
    <div class="header">
        <h2>账号管理</h2>
        <a href="${pageContext.request.contextPath}/admin/account/add" class="btn-primary">
            添加账号
        </a>
    </div>
    
    <form class="search-bar" method="get" action="${pageContext.request.contextPath}/admin/account">
        <input type="text" name="keyword" placeholder="搜索用户名或角色..." value="${param.keyword}">
        <button type="submit" class="btn-primary">搜索</button>
        <a href="${pageContext.request.contextPath}/admin/account" class="btn-primary">重置</a>
    </form>
    
    <table class="user-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>用户名</th>
                <th>角色</th>
                <th>关联医生</th>
                <th>状态</th>
                <th>创建时间</th>
                <th>操作</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="user" items="${users}">
                <tr>
                    <td>${user.userId}</td>
                    <td>${user.username}</td>
                    <td>
                        ${user.role}
                        <c:choose>
                            <c:when test="${user.role == 'admin'}">
                                <span class="badge badge-admin">管理员</span>
                            </c:when>
                            <c:when test="${user.role == 'doctor'}">
                                <span class="badge badge-doctor">医生</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-staff">员工</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${user.doctorId != null}">
                                医生ID: ${user.doctorId}
                            </c:when>
                            <c:otherwise>
                                无
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${user.status == 1}">
                                <span class="status-active">启用</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-inactive">禁用</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:if test="${user.createTime != null}">
                            ${user.createTime}
                        </c:if>
                    </td>
                    <td class="actions">
                        <a href="${pageContext.request.contextPath}/admin/account/edit?id=${user.userId}">编辑</a>
                        <a href="${pageContext.request.contextPath}/admin/account/toggle-status?id=${user.userId}"
                           onclick="return confirm('确定要${user.status == 1 ? '禁用' : '启用'}此账号吗？')">
                            ${user.status == 1 ? '禁用' : '启用'}
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/account/delete?id=${user.userId}"
                           onclick="return confirm('确定要删除此账号吗？')"
                           style="color: #f44336;">删除</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    
    <div style="margin-top: 20px; text-align: center; color: #666;">
        共 ${totalUsers} 个账号
    </div>
</div>
