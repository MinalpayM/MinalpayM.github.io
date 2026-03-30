package com.clinic.controller;

import com.clinic.model.SysUser;
import com.clinic.service.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/login")
public class LoginController {

    @Autowired
    private UserService userService;

    // 1. 打开登录页
    @GetMapping
    public String loginPage() {
        return "login";   // /WEB-INF/jsp/login.jsp
    }

    // 2. 登录提交
    @PostMapping
    public String doLogin(
            @RequestParam String username,
            @RequestParam String password,
            HttpSession session,
            Model model) {

        // ① 校验账号密码
        SysUser user = userService.login(username, password);

        if (user == null) {
            model.addAttribute("error", "用户名或密码错误");
            return "login";
        }

        // ② 放入 session
        session.setAttribute("user", user);

        // ③ 根据角色跳转
        if ("ADMIN".equals(user.getRole())) {
            return "redirect:/admin/index";
        } else if ("DOCTOR".equals(user.getRole())) {
            return "redirect:/doctor/index";
        } else {
            
            model.addAttribute("error", "账号角色异常");
            session.invalidate();
            return "login";
        }
    }
}