<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<html>
<head>
    <title>添加药品</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Microsoft YaHei', sans-serif;
            background: #f5f7fa;
        }
        
        .container {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
        }
        
        .card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px 30px;
        }
        
        .card-header h1 {
            margin: 0;
            font-size: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .card-body {
            padding: 30px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #2c3e50;
            font-weight: 500;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            font-size: 15px;
            transition: border-color 0.3s;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #3498db;
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 30px;
            padding-top: 25px;
            border-top: 1px solid #eee;
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s;
            font-size: 15px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }
        
        .btn-primary {
            background: #3498db;
            color: white;
        }
        
        .btn-primary:hover {
            background: #2980b9;
        }
        
        .btn-secondary {
            background: #95a5a6;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #7f8c8d;
        }
        
        .error-message {
            color: #e74c3c;
            background: #ffeaea;
            padding: 10px 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #e74c3c;
        }
        
        .input-hint {
            font-size: 12px;
            color: #7f8c8d;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="card-header">
                <h1>➕ 添加新药品</h1>
            </div>
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="error-message">
                        ❌ ${error}
                    </div>
                </c:if>
                
                <form action="${pageContext.request.contextPath}/admin/medicine/save" method="post">
                    <div class="form-group">
                        <label for="medicineName">药品名称 *</label>
                        <input type="text" id="medicineName" name="medicineName" 
                               class="form-control" required 
                               placeholder="请输入药品名称">
                    </div>
                    
                    <div class="form-group">
                        <label for="price">价格 *</label>
                        <input type="number" id="price" name="price" 
                               class="form-control" step="0.01" min="0" required 
                               placeholder="请输入价格">
                        <div class="input-hint">单位：元</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="stock">库存数量 *</label>
                        <input type="number" id="stock" name="stock" 
                               class="form-control" min="0" required 
                               placeholder="请输入库存数量">
                        <div class="input-hint">低于10个将显示库存不足</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="description">药品描述</label>
                        <textarea id="description" name="description" 
                                  class="form-control" rows="4" 
                                  placeholder="请输入药品描述（如：适应症、用法用量等）"></textarea>
                    </div>
                    
                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/medicine/list" 
                           class="btn btn-secondary">← 返回列表</a>
                        <button type="submit" class="btn btn-primary">💾 保存药品</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>