package com.clinic.service;

import com.clinic.dao.UserDao;
import com.clinic.model.SysUser;
import com.clinic.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {
	@Autowired 
	private UserDao userDao;
	 public SysUser login(String username, String password) {
	        username = username.trim();
	        password = password.trim();
	        
	        // 从数据库查询用户
	        SysUser user = userDao.findByUsername(username);
	        
	        // 验证密码
	        if (user != null && user.getPassword().equals(password) && user.getStatus() == 1) {
	            return user;
	        }
	        return null;
	    }
    
 // 获取所有用户
    public List<SysUser> getAllUsers() {
        return userDao.findAll();
    }
    
    // 根据ID获取用户
    public SysUser getUserById(int userId) {
        return userDao.findById(userId);
    }
    
    // 添加用户
    public boolean addUser(SysUser user) {
        // 检查用户名是否已存在
        if (userDao.isUsernameExists(user.getUsername(), null)) {
            return false;
        }
        return userDao.insert(user);
    }
    
    // 更新用户
    public boolean updateUser(SysUser user) {
        // 检查用户名是否已存在（排除当前用户）
        if (userDao.isUsernameExists(user.getUsername(), user.getUserId())) {
            return false;
        }
        return userDao.update(user);
    }
    
    // 删除用户
    public boolean deleteUser(int userId) {
        return userDao.delete(userId);
    }
    
    // 搜索用户
    public List<SysUser> searchUsers(String keyword) {
        return userDao.search(keyword);
    }
    
 // 获取用户数量
    public int getUserCount() {
        return userDao.count();
    }
    
    // 获取所有医生用户
    public List<SysUser> getAllDoctors() {
        return userDao.findAllDoctors();
    }
    
    // 获取所有医生信息
    public List<Map<String, Object>> getAllDoctorInfo() {
        return userDao.findAllDoctorInfo();
    }
    
    // 启用/禁用用户
    public boolean toggleUserStatus(int userId) {
        SysUser user = userDao.findById(userId);
        if (user != null) {
            int newStatus = user.getStatus() == 1 ? 0 : 1;
            user.setStatus(newStatus);
            return userDao.update(user);
        }
        return false;
    }
}