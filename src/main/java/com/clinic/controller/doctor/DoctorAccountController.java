package com.clinic.controller.doctor;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.clinic.model.Doctor;
import com.clinic.model.SysUser;
import com.clinic.service.DoctorService;
import com.clinic.service.UserService;
import com.clinic.util.ValidatorUtil; // 引入校验工具类

@Controller
@RequestMapping("/doctor/account")
public class DoctorAccountController {

    @Autowired
    private DoctorService doctorService;

    @Autowired
    private UserService userService;

    // 进入账号页面
    @GetMapping
    public String account(HttpSession session, Model model) {
        SysUser user = (SysUser) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        Doctor doctor = doctorService.getDoctor(user.getDoctorId());

        model.addAttribute("user", user);
        model.addAttribute("doctor", doctor);

        return "doctor/account";
    }

    // 修改账号信息
    @PostMapping("/updateAccount")
    @ResponseBody
    public String updateAccount(String username, String password, HttpSession session) {
        SysUser user = (SysUser) session.getAttribute("user");
        if (user == null) return "login";

        if ((username == null || username.isEmpty()) && (password == null || password.isEmpty())) {
            return "empty";
        }

        // 校验用户名
        if (username != null && !username.isEmpty()) {
            if (!ValidatorUtil.isValidUsername(username)) {
                return "invalidUsername";
            }
            user.setUsername(username);
        }

        // 校验密码
        if (password != null && !password.isEmpty()) {
            if (!ValidatorUtil.isValidPassword(password)) {
                return "invalidPassword";
            }
            user.setPassword(password);
        }

        userService.updateUser(user);
        session.setAttribute("user", user);

        return "ok";
    }

    // 修改医生联系方式
    @PostMapping("/updateDoctor")
    @ResponseBody
    public String updateDoctorInfo(String phone, String address, HttpSession session) {
        SysUser user = (SysUser) session.getAttribute("user");
        if (user == null) return "login";

        Doctor d = doctorService.getDoctor(user.getDoctorId());

        // 校验电话
        if (phone != null && !phone.isEmpty()) {
            if (!ValidatorUtil.isValidPhone(phone)) {
                return "invalidPhone";
            }
            d.setPhone(phone);
        }

        d.setAddress(address);

        doctorService.updateDoctor(d);

        return "ok";
    }
}
