package com.clinic.controller;

import com.clinic.model.Doctor;
import com.clinic.service.DoctorService;
import com.clinic.util.ValidatorUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("/admin/doctor")
public class DoctorController {

    @Autowired
    private DoctorService service;

    // 解决 Date 类型绑定问题（400 Bad Request 的常见原因之一）
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        sdf.setLenient(false);
        binder.registerCustomEditor(Date.class, new CustomDateEditor(sdf, true));
    }

    // 医生列表 + 搜索
    @GetMapping
    public String list(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String title,
            Model model) {

        List<Doctor> list;
        if ((keyword != null && !keyword.trim().isEmpty()) ||
            (title != null && !title.trim().isEmpty())) {
            list = service.search(keyword, title);
        } else {
            list = service.listDoctors();
        }

        model.addAttribute("doctors", list);
        model.addAttribute("totalDoctors", service.countDoctors());
        return "admin/doctor/doctor";
    }

    // 新增医生（AJAX 提交，返回 JSON）
    @PostMapping("/add")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> addDoctor(
            Doctor doctor,
            @RequestParam(value = "avatarFile", required = false) MultipartFile file,
            HttpServletRequest request) {

        Map<String, String> errors = new LinkedHashMap<>();

        // 必填字段校验（可根据实际业务调整哪些是必填）
        if (doctor.getName() == null || doctor.getName().trim().isEmpty()) {
            errors.put("name", "姓名不能为空");
        }

        if (doctor.getGender() == null || doctor.getGender().trim().isEmpty()) {
            errors.put("gender", "性别不能为空");
        }

        if (doctor.getBirthDate() == null) {
            errors.put("birthDate", "出生日期不能为空");
        }

        // 电话校验（假设电话必填）
        if (doctor.getPhone() == null || doctor.getPhone().trim().isEmpty()) {
            errors.put("phone", "电话不能为空");
        } else if (!ValidatorUtil.isValidPhone(doctor.getPhone())) {
            errors.put("phone", "电话格式不正确（需11位数字）");
        }

        // 身份证校验（假设身份证必填）
        if (doctor.getIdCard() == null || doctor.getIdCard().trim().isEmpty()) {
            errors.put("idCard", "身份证不能为空");
        } else if (!ValidatorUtil.isValidIdCard(doctor.getIdCard())) {
            errors.put("idCard", "身份证格式不正确（18位，前17位数字，最后一位数字或X）");
        }

        // 如果有任何校验错误，直接返回错误信息
        if (!errors.isEmpty()) {
            Map<String, Object> result = new HashMap<>();
            result.put("errors", errors);
            return ResponseEntity.ok(result);
        }

        // 处理头像上传
        if (file != null && !file.isEmpty()) {
            try {
                String originalFilename = file.getOriginalFilename();
                String fileName = System.currentTimeMillis() + "_" + originalFilename;
                String uploadPath = request.getServletContext().getRealPath("/images/doctor_images/");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                File destFile = new File(uploadPath + File.separator + fileName);
                file.transferTo(destFile);
                doctor.setAvatar("images/doctor_images/" + fileName);
            } catch (Exception e) {
                Map<String, Object> result = new HashMap<>();
                result.put("errors", Collections.singletonMap("avatarFile", "头像上传失败：" + e.getMessage()));
                return ResponseEntity.ok(result);
            }
        }

        // 保存到数据库
        try {
            service.addDoctor(doctor);
        } catch (Exception e) {
            Map<String, Object> result = new HashMap<>();
            result.put("errors", Collections.singletonMap("global", "保存失败：" + e.getMessage()));
            return ResponseEntity.ok(result);
        }

        // 成功返回
        Map<String, Object> result = new HashMap<>();
        result.put("status", "success");
        return ResponseEntity.ok(result);
    }

    // 查看医生详情（用于弹窗）
    @GetMapping("/view")
    public String viewDoctor(@RequestParam("id") int id, Model model) {
        Doctor doctor = service.getDoctor(id);
        model.addAttribute("doctor", doctor);
        return "admin/doctor/doctor_view";
    }

    // 编辑医生页面（用于弹窗加载）
    @GetMapping("/edit")
    public String editDoctor(@RequestParam("id") int id, Model model) {
        Doctor doctor = service.getDoctor(id);
        model.addAttribute("doctor", doctor);
        return "admin/doctor/doctor_edit";
    }

    // 更新医生
    @PostMapping("/update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateDoctor(
            Doctor doctor,
            @RequestParam(value = "avatarFile", required = false) MultipartFile file,
            HttpServletRequest request) {

        Map<String, String> errors = new LinkedHashMap<>();

        // 必填字段 + 格式校验
        if (doctor.getName() == null || doctor.getName().trim().isEmpty()) {
            errors.put("name", "姓名不能为空");
        }
        if (doctor.getGender() == null || doctor.getGender().trim().isEmpty()) {
            errors.put("gender", "性别不能为空");
        }
        if (doctor.getPhone() != null && !doctor.getPhone().trim().isEmpty()) {
            if (!ValidatorUtil.isValidPhone(doctor.getPhone())) {
                errors.put("phone", "电话格式不正确（需11位数字）");
            }
        } else {
            errors.put("phone", "电话不能为空");
        }
        if (doctor.getIdCard() != null && !doctor.getIdCard().trim().isEmpty()) {
            if (!ValidatorUtil.isValidIdCard(doctor.getIdCard())) {
                errors.put("idCard", "身份证格式不正确（18位）");
            }
        } else {
            errors.put("idCard", "身份证不能为空");
        }

        if (!errors.isEmpty()) {
            Map<String, Object> result = new HashMap<>();
            result.put("errors", errors);
            return ResponseEntity.ok(result);
        }

        // 头像处理
        if (file != null && !file.isEmpty()) {
            try {
                String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
                String path = request.getServletContext().getRealPath("/images/doctor_images/");
                File dir = new File(path);
                if (!dir.exists()) dir.mkdirs();
                file.transferTo(new File(path + File.separator + fileName));
                doctor.setAvatar("images/doctor_images/" + fileName);
            } catch (Exception e) {
                Map<String, Object> result = new HashMap<>();
                result.put("errors", Collections.singletonMap("avatarFile", "头像上传失败"));
                return ResponseEntity.ok(result);
            }
        } else {
            // 保留原头像
            Doctor old = service.getDoctor(doctor.getDoctorId());
            doctor.setAvatar(old.getAvatar());
        }

        // 更新
        try {
            service.updateDoctor(doctor);
        } catch (Exception e) {
            Map<String, Object> result = new HashMap<>();
            result.put("errors", Collections.singletonMap("global", "保存失败：" + e.getMessage()));
            return ResponseEntity.ok(result);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("status", "success");
        return ResponseEntity.ok(result);
    }

    // 删除医生
    @GetMapping("/delete")
    public String deleteDoctor(@RequestParam("id") int id) {
        service.deleteDoctor(id);
        return "redirect:/admin/doctor";
    }
}