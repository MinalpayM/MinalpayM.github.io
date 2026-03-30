package com.clinic.controller;

import com.clinic.model.SysUser;
import com.clinic.service.DoctorService;
import com.clinic.service.MedicineService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin/index")
public class IndexController {

    @Autowired
    private DoctorService doctorService;

    @Autowired
    private MedicineService medicineService;

    @GetMapping
    public String index(Model model, HttpSession session) {
        // 当前登录用户
        SysUser user = (SysUser) session.getAttribute("user");
        model.addAttribute("user", user);

        // 医生概览
        model.addAttribute("doctors", doctorService.listDoctors());
        model.addAttribute("totalDoctors", doctorService.countDoctors());

        // 药品概览
        model.addAttribute("medicineCount", medicineService.getAllMedicines().size());
        model.addAttribute("lowStockCount", medicineService.getLowStockCount(10));
        model.addAttribute("lowStockMedicines", medicineService.getLowStockMedicines(10));
        model.addAttribute("medicines", medicineService.getAllMedicines());

        return "admin/index"; // 对应 /WEB-INF/jsp/admin/index.jsp
    }
}
