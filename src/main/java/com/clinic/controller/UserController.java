package com.clinic.controller;

import com.clinic.model.SysUser;
import com.clinic.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/account")
public class UserController {
    
    @Autowired
    private UserService userService;
    
    
    // 显示用户列表 - 主页面
    @GetMapping
    public String listUsers(@RequestParam(required = false) String keyword, Model model) {
        System.out.println("=== UserController.listUsers() called ===");
        System.out.println("userService = " + userService);
        
        List<SysUser> users;
        
        if (keyword != null && !keyword.isEmpty()) {
            users = userService.searchUsers(keyword);
        } else {
            users = userService.getAllUsers();
        }
        
        model.addAttribute("users", users);
        model.addAttribute("totalUsers", userService.getUserCount());
        return "admin/account/list";
    }
    
 // 显示添加用户表单
    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("user", new SysUser());
        
        // 获取所有医生信息
        List<Map<String, Object>> doctors = userService.getAllDoctorInfo();
        
        // 添加详细的调试输出
        System.out.println("=== showAddForm 被调用 ===");
        System.out.println("查询到的医生数量: " + doctors.size());
        
        if (doctors.isEmpty()) {
            System.out.println("警告: doctors 列表为空!");
        } else {
            for (Map<String, Object> doctor : doctors) {
                System.out.println("医生: ID=" + doctor.get("doctorId") + 
                                 ", 姓名=" + doctor.get("name") + 
                                 ", 职称=" + doctor.get("title"));
            }
        }
        
        // 检查模型属性
        model.addAttribute("doctors", doctors);
        System.out.println("已将 doctors 添加到 Model，大小: " + doctors.size());
        
        return "admin/account/add";
    }
    
 // 显示编辑用户表单
    @GetMapping("/edit")
    public String showEditForm(@RequestParam("id") int userId, Model model) {
        SysUser user = userService.getUserById(userId);
        if (user == null) {
            return "redirect:/admin/account";
        }
        
        System.out.println("=== 编辑用户页面 ===");
        System.out.println("用户ID: " + userId);
        System.out.println("用户名: " + user.getUsername());
        System.out.println("当前关联医生ID: " + user.getDoctorId());
        
        // 获取所有医生信息
        List<Map<String, Object>> doctors = userService.getAllDoctorInfo();
        System.out.println("医生数量: " + doctors.size());
        
        for (Map<String, Object> doctor : doctors) {
            System.out.println("医生: ID=" + doctor.get("doctorId") + 
                             ", 姓名=" + doctor.get("name"));
        }
        
        model.addAttribute("user", user);
        model.addAttribute("doctors", doctors);
        
        return "admin/account/edit";
    }
    
    // 添加用户
    @PostMapping("/save")
    public String saveUser(SysUser user, Model model) {
        // 设置默认状态为启用
        if (user.getStatus() != 0 && user.getStatus() != 1) {
            user.setStatus(1);
        }
        
        boolean success = userService.addUser(user);
        if (!success) {
            model.addAttribute("error", "用户名已存在");
            model.addAttribute("user", user);
            return "admin/account/add";
        }
        
        return "redirect:/admin/account";
    }
    
    // 更新用户
    @PostMapping("/update")
    public String updateUser(SysUser user, Model model) {
        boolean success = userService.updateUser(user);
        if (!success) {
            model.addAttribute("error", "用户名已存在");
            model.addAttribute("user", user);
            return "admin/account/edit";
        }
        
        return "redirect:/admin/account";
    }
    
    // 删除用户
    @GetMapping("/delete")
    public String deleteUser(@RequestParam("id") int userId) {
        userService.deleteUser(userId);
        return "redirect:/admin/account";
    }
    
    // 切换用户状态（启用/禁用）
    @GetMapping("/toggle-status")
    public String toggleUserStatus(@RequestParam("id") int userId) {
        userService.toggleUserStatus(userId);
        return "redirect:/admin/account";
    }
}