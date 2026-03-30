<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>药品管理</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Microsoft YaHei', sans-serif;
            background: #f5f7fa;
            color: #333;
        }
        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
        }
        .header {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header h1 {
            color: #2c3e50;
            margin: 0;
        }
        .actions {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .btn-primary {
            background: #3498db;
            color: white;
        }
        .btn-primary:hover {
            background: #2980b9;
        }
        .btn-success {
            background: #2ecc71;
            color: white;
        }
        .btn-success:hover {
            background: #27ae60;
        }
        .btn-warning {
            background: #f39c12;
            color: white;
        }
        .btn-warning:hover {
            background: #d68910;
        }
        .btn-danger {
            background: #e74c3c;
            color: white;
        }
        .btn-danger:hover {
            background: #c0392b;
        }
        .btn-info {
            background: #17a2b8;
            color: white;
        }
        .btn-info:hover {
            background: #138496;
        }
        .search-box {
            background: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .filter-options {
            display: flex;
            gap: 15px;
            align-items: center;
            margin-bottom: 15px;
            flex-wrap: wrap;
        }
        .filter-label {
            font-weight: 500;
            color: #2c3e50;
        }
        .filter-controls {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .threshold-input {
            width: 80px;
            padding: 8px 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            text-align: center;
        }
        .search-form {
            display: flex;
            width: 100%;
            gap: 10px;
        }
        .search-form input {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        .search-form .btn {
            padding: 10px 30px;
        }
        .table-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th {
            background: #2c3e50;
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }
        td {
            padding: 15px;
            border-bottom: 1px solid #eee;
        }
        tr:hover {
            background: #f9f9f9;
        }
        .stock-low {
            color: #e74c3c;
            font-weight: bold;
        }
        .stock-warning {
            color: #f39c12;
            font-weight: bold;
        }
        .stock-normal {
            color: #27ae60;
        }
        .stock-critical {
            background-color: #ffeaea;
            color: #e74c3c;
            font-weight: bold;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 12px;
        }
        .actions-cell {
            display: flex;
            gap: 10px;
        }
        .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
        }
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
        }
        .empty-state i {
            font-size: 48px;
            margin-bottom: 20px;
            color: #bdc3c7;
        }
        .stats-bar {
            background: #f8f9fa;
            padding: 10px 15px;
            border-radius: 6px;
            margin-bottom: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-left: 4px solid #17a2b8;
        }
        .stat-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }
        .stat-value {
            font-weight: bold;
            color: #2c3e50;
        }
        .low-stock-alert {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
            padding: 10px 15px;
            border-radius: 6px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .low-stock-alert i {
            font-size: 20px;
        }
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
            gap: 5px;
        }
        .pagination .btn {
            padding: 8px 15px;
            background: #f8f9fa;
            color: #495057;
            border: 1px solid #dee2e6;
        }
        .pagination .btn:hover {
            background: #e9ecef;
        }
        .pagination .active {
            background: #007bff;
            color: white;
            border-color: #007bff;
        }
        .debug-info {
            display: none;
            background: #f8f9fa;
            padding: 10px;
            margin: 10px 0;
            border-left: 4px solid #007bff;
            font-size: 12px;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- 调试信息 -->
        <div class="debug-info">
            当前上下文路径: ${pageContext.request.contextPath}<br>
            请求URL: ${pageContext.request.requestURL}<br>
            搜索关键词: ${param.keyword}<br>
            库存阈值: ${empty param.threshold ? 10 : param.threshold}
        </div>

        <div class="header">
            <h1>📦 药品管理</h1>
            <div class="actions">
                <!-- 刷新按钮 -->
                <c:url var="listUrl" value="/admin/medicine/list" />
                <a href="${listUrl}" class="btn btn-primary">
                    🔄 全部药品
                </a>
                
                <!-- 库存不足药品按钮 -->
                <c:url var="lowStockUrl" value="/admin/medicine/low-stock">
                    <c:param name="threshold" value="10" />
                </c:url>
                <a href="${lowStockUrl}" class="btn btn-warning">
                    ⚠️ 库存不足
                </a>
                
                <!-- 添加药品按钮 -->
                <c:url var="addUrl" value="/admin/medicine/add" />
                <a href="${addUrl}" class="btn btn-success">
                    ➕ 添加药品
                </a>
            </div>
        </div>

        <!-- 搜索和筛选区域 -->
        <div class="search-box">
            <!-- 库存筛选 -->
            <div class="filter-options">
                <div class="filter-label">📊 库存筛选:</div>
                <div class="filter-controls">
                    <form action="${pageContext.request.contextPath}/admin/medicine/low-stock" method="get" style="display: flex; gap: 10px; align-items: center;">
                        <span>显示库存低于</span>
                        <input type="number" name="threshold" class="threshold-input" 
                               value="${empty param.threshold ? 10 : param.threshold}" 
                               min="1" max="1000" required>
                        <span>的药品</span>
                        <button type="submit" class="btn btn-info btn-sm">筛选</button>
                    </form>
                </div>
            </div>
            
            <!-- 搜索表单 -->
            <c:url var="searchUrl" value="/admin/medicine/search" />
            <form action="${searchUrl}" method="get" class="search-form">
                <input type="text" name="keyword" 
                       placeholder="搜索药品名称或描述..." 
                       value="${param.keyword}" required>
                <button type="submit" class="btn btn-primary">🔍 搜索</button>
            </form>
        </div>

        <!-- 统计信息栏 -->
        <c:if test="${isLowStockPage}">
            <div class="low-stock-alert">
                <div>⚠️</div>
                <div>
                    <strong>库存不足药品提醒</strong>
                    <p style="margin: 5px 0 0 0; font-size: 13px;">
                        当前显示库存低于 ${empty param.threshold ? 10 : param.threshold} 的药品，共 ${empty medicines ? 0 : medicines.size()} 种。
                        <c:if test="${not empty medicines && medicines.size() > 0}">
                            建议及时补货。
                        </c:if>
                    </p>
                </div>
            </div>
        </c:if>

        <!-- 药品列表 -->
        <div class="table-container">
            <c:choose>
                <c:when test="${not empty medicines}">
                    <table>
                        <thead>
                            <tr>
                                
                                <th>药品名称</th>
                                <th>价格</th>
                                <th>库存</th>
                                <th>状态</th>
                                <th>描述</th>
                                <th>创建时间</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="medicine" items="${medicines}">
                                <tr>
                                   
                                    <td>${medicine.medicineName}</td>
                                    <td>¥${medicine.price}</td>
                                    <td>
                                        <span class="
                                            ${medicine.stock < 5 ? 'stock-critical' : 
                                              medicine.stock < 10 ? 'stock-low' : 
                                              medicine.stock < 20 ? 'stock-warning' : 'stock-normal'}">
                                            ${medicine.stock}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${medicine.stock < 5}">
                                                <span style="color: #e74c3c; font-size: 12px;">🔥 严重不足</span>
                                            </c:when>
                                            <c:when test="${medicine.stock < 10}">
                                                <span style="color: #e74c3c; font-size: 12px;">⚠️ 库存不足</span>
                                            </c:when>
                                            <c:when test="${medicine.stock < 20}">
                                                <span style="color: #f39c12; font-size: 12px;">📉 库存偏低</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #27ae60; font-size: 12px;">✅ 库存正常</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${medicine.description}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty medicine.createTime}">
                                                ${medicine.createTime}
                                            </c:when>
                                            <c:otherwise>
                                                暂无时间
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="actions-cell">
                                        <!-- 编辑链接 -->
                                        <c:url var="editUrl" value="/admin/medicine/edit">
                                            <c:param name="id" value="${medicine.medicineId}" />
                                        </c:url>
                                        <a href="${editUrl}" class="btn btn-warning btn-sm">
                                            ✏️ 编辑
                                        </a>
                                        
                                        <!-- 快速补货按钮（新增功能） -->
                                        <c:if test="${medicine.stock < 10}">
                                            <c:url var="quickRestockUrl" value="/admin/medicine/edit">
                                                <c:param name="id" value="${medicine.medicineId}" />
                                            </c:url>
                                            <a href="${quickRestockUrl}" class="btn btn-info btn-sm" 
                                               title="快速补货" style="padding: 5px 8px;">
                                                📦 补货
                                            </a>
                                        </c:if>
                                        
                                        <!-- 删除链接 -->
                                        <c:url var="deleteUrl" value="/admin/medicine/delete">
                                            <c:param name="id" value="${medicine.medicineId}" />
                                        </c:url>
                                        <a href="${deleteUrl}" class="btn btn-danger btn-sm"
                                           onclick="return confirm('确定要删除药品【${medicine.medicineName}】吗？')">
                                            🗑️ 删除
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div>📭</div>
                        <h3>暂无药品数据</h3>
                        <c:choose>
                            <c:when test="${isLowStockPage}">
                                <p>没有找到库存低于 ${empty param.threshold ? 10 : param.threshold} 的药品</p>
                                <c:url var="allMedicinesUrl" value="/admin/medicine/list" />
                                <a href="${allMedicinesUrl}" class="btn btn-primary" style="margin-top: 15px;">
                                    查看所有药品
                                </a>
                            </c:when>
                            <c:when test="${not empty param.keyword}">
                                <p>没有找到包含"${param.keyword}"的药品</p>
                                <c:url var="allMedicinesUrl" value="/admin/medicine/list" />
                                <a href="${allMedicinesUrl}" class="btn btn-primary" style="margin-top: 15px;">
                                    查看所有药品
                                </a>
                            </c:when>
                            <c:otherwise>
                                <p>点击"添加药品"按钮开始添加</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- 页面底部统计 -->
        <div class="stats-bar">
            <div class="stat-item">
                <span>📊 总数:</span>
                <span class="stat-value">${empty medicines ? 0 : medicines.size()} 种药品</span>
            </div>
            <c:if test="${isLowStockPage}">
                <div class="stat-item">
                    <span>⚠️ 库存不足:</span>
                    <span class="stat-value" style="color: #e74c3c;">
                        <c:set var="lowCount" value="0" />
                        <c:forEach var="medicine" items="${medicines}">
                            <c:if test="${medicine.stock < 10}">
                                <c:set var="lowCount" value="${lowCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${lowCount} 种
                    </span>
                </div>
                <div class="stat-item">
                    <span>🔥 严重不足:</span>
                    <span class="stat-value" style="color: #c0392b;">
                        <c:set var="criticalCount" value="0" />
                        <c:forEach var="medicine" items="${medicines}">
                            <c:if test="${medicine.stock < 5}">
                                <c:set var="criticalCount" value="${criticalCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${criticalCount} 种
                    </span>
                </div>
            </c:if>
            <div class="stat-item">
                <span>📅 更新时间:</span>
                <span class="stat-value"><%= new java.util.Date() %></span>
            </div>
        </div>
    </div>

    <script>
        // 显示/隐藏调试信息
        document.addEventListener('keydown', function(event) {
            // 按 Ctrl+Shift+D 显示调试信息
            if (event.ctrlKey && event.shiftKey && event.key === 'D') {
                const debugInfo = document.querySelector('.debug-info');
                debugInfo.style.display = debugInfo.style.display === 'none' ? 'block' : 'none';
            }
        });

        // 库存预警提示
        document.addEventListener('DOMContentLoaded', function() {
            // 为严重不足的药品添加特殊标记
            const criticalItems = document.querySelectorAll('.stock-critical');
            criticalItems.forEach(item => {
                const stock = parseInt(item.textContent);
                const row = item.closest('tr');
                if (row && stock < 3) {
                    row.style.backgroundColor = '#fff5f5';
                    row.style.borderLeft = '3px solid #e74c3c';
                }
            });
            
            // 为不足的药品添加标记
            const lowItems = document.querySelectorAll('.stock-low');
            lowItems.forEach(item => {
                const stock = parseInt(item.textContent);
                const row = item.closest('tr');
                if (row && stock < 10) {
                    row.style.backgroundColor = '#fffaf0';
                }
            });
        });
        
        // 快速补货功能
        function quickRestock(medicineId, medicineName) {
            const newStock = prompt(`为药品【${medicineName}】设置新的库存数量:`, "50");
            if (newStock && !isNaN(newStock) && newStock > 0) {
                // 这里可以调用API更新库存
                alert(`已将 ${medicineName} 的库存设置为 ${newStock}`);
                // 实际开发中可以发送AJAX请求到后端
                // fetch(`/medicine/restock?id=${medicineId}&stock=${newStock}`, {method: 'POST'})
                //   .then(response => location.reload());
            }
        }
    </script>
</body>
</html>