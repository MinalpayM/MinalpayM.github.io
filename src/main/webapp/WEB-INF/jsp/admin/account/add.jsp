<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<style>
    .container {
        padding-top: 80px;
        width: 95%;
        margin: auto;
        max-width: 800px;
    }
    
    .card {
        background: white;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }
    
    .form-group {
        margin-bottom: 20px;
    }
    
    .form-group label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
    }
    
    .form-group input,
    .form-group select {
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
        font-size: 14px;
    }
    
    .btn-primary {
        background: #1e88e5;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 5px;
        cursor: pointer;
        font-size: 14px;
    }
    
    .btn-secondary {
        background: #6c757d;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 5px;
        cursor: pointer;
        text-decoration: none;
        display: inline-block;
        margin-right: 10px;
    }
    
    .error {
        color: #f44336;
        font-size: 14px;
        margin-top: 5px;
    }
    
    .form-actions {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        margin-top: 30px;
    }
</style>

<div class="container">
    <div class="card">
        <h2 style="margin-bottom: 30px;">添加账号</h2>
        
        <c:if test="${not empty error}">
            <div style="background: #ffebee; color: #f44336; padding: 10px; border-radius: 5px; margin-bottom: 20px;">
                ${error}
            </div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/admin/account/save" method="post">
            <div class="form-group">
                <label for="username">用户名 *</label>
                <input type="text" id="username" name="username" required
                       value="${user.username}" placeholder="请输入用户名">
            </div>
            
            <div class="form-group">
                <label for="password">密码 *</label>
                <input type="password" id="password" name="password" required
                       placeholder="请输入密码">
            </div>
            
            <div class="form-group">
                <label for="role">角色 *</label>
                <select id="role" name="role" required>
                    <option value="">请选择角色</option>
                    <option value="admin" ${user.role == 'admin' ? 'selected' : ''}>管理员</option>
                    <option value="doctor" ${user.role == 'doctor' ? 'selected' : ''}>医生</option>
                    <option value="staff" ${user.role == 'staff' ? 'selected' : ''}>员工</option>
                </select>
            </div>
            
            <div class="form-group">
    			<label for="doctorId">关联医生</label>
   				<select id="doctorId" name="doctorId">
    			<option value="">无关联医生</option>
    			<c:forEach var="doctor" items="${doctors}">
        			<option value="${doctor.doctorId}"
            			${user.doctorId == doctor.doctorId ? 'selected' : ''}>
            			${doctor.name} (${doctor.title})
        			</option>
    			</c:forEach>
				</select>
    			<small style="color: #666;">只有角色为"医生"时才需要关联</small>
			</div>
            
            <div class="form-group">
                <label for="status">状态</label>
                <select id="status" name="status">
                    <option value="1" ${user.status == 1 ? 'selected' : ''}>启用</option>
                    <option value="0" ${user.status == 0 ? 'selected' : ''}>禁用</option>
                </select>
            </div>
            
            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/admin/account" class="btn-secondary">取消</a>
                <button type="submit" class="btn-primary">保存</button>
            </div>
        </form>
    </div>
</div>

<script>
// 根据选择的角色显示/隐藏医生选择
document.getElementById('role').addEventListener('change', function() {
    var doctorSelect = document.getElementById('doctorId');
    if (this.value === 'doctor') {
        doctorSelect.disabled = false;
        doctorSelect.style.opacity = '1';
    } else {
        doctorSelect.disabled = true;
        doctorSelect.style.opacity = '0.5';
        doctorSelect.value = '';
    }
});

// 页面加载时初始化
window.onload = function() {
    var roleSelect = document.getElementById('role');
    var doctorSelect = document.getElementById('doctorId');
    if (roleSelect.value !== 'doctor') {
        doctorSelect.disabled = true;
        doctorSelect.style.opacity = '0.5';
    }
};
</script>
