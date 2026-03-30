package com.clinic.controller.doctor;

import com.clinic.model.Patient;
import com.clinic.model.SysUser;
import com.clinic.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.beans.propertyeditors.CustomDateEditor;

import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/doctor/patient")
public class DoctorPatientController {
    
    @Autowired
    private PatientService patientService;
    
    // 解决日期格式化问题
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        sdf.setLenient(false);
        binder.registerCustomEditor(Date.class, new CustomDateEditor(sdf, true));
    }
    
    // 病人列表页面
    @GetMapping
    public String patientList(HttpSession session, Model model,
                            @RequestParam(required = false) String keyword) {
        SysUser user = (SysUser) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        
        List<Patient> patients;
        if (keyword != null && !keyword.isEmpty()) {
            patients = patientService.searchPatients(user.getDoctorId(), keyword);
            model.addAttribute("keyword", keyword);
        } else {
            patients = patientService.getPatientsByDoctorId(user.getDoctorId());
        }
        
        model.addAttribute("patients", patients);
        model.addAttribute("totalPatients", patientService.countPatientsByDoctorId(user.getDoctorId()));
        return "doctor/patient/list";
    }
    
    // 显示添加病人表单
    @GetMapping("/add")
    public String showAddForm(HttpSession session, Model model) {
        SysUser user = (SysUser) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        
        Patient patient = new Patient();
        patient.setDoctorId(user.getDoctorId());
        model.addAttribute("patient", patient);
        return "doctor/patient/add";
    }
    
    // 添加病人
    @PostMapping("/add")
    @ResponseBody
    public String addPatient(Patient patient, HttpSession session) {
        SysUser user = (SysUser) session.getAttribute("user");
        if (user == null) return "login";
        
        patient.setDoctorId(user.getDoctorId());
        boolean success = patientService.addPatient(patient);
        return success ? "ok" : "error";
    }
    
    // 显示编辑病人表单
    @GetMapping("/edit")
    public String showEditForm(@RequestParam int id, HttpSession session, Model model) {
        SysUser user = (SysUser) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        
        Patient patient = patientService.getPatientById(id);
        // 检查病人是否属于当前医生
        if (patient == null || !patient.getDoctorId().equals(user.getDoctorId())) {
            return "redirect:/doctor/patient";
        }
        
        model.addAttribute("patient", patient);
        return "doctor/patient/edit";
    }
    
    // 更新病人
    @PostMapping("/update")
    @ResponseBody
    public String updatePatient(Patient patient, HttpSession session) {
        SysUser user = (SysUser) session.getAttribute("user");
        if (user == null) return "login";
        
        // 确保病人属于当前医生
        Patient existingPatient = patientService.getPatientById(patient.getPatientId());
        if (existingPatient == null || !existingPatient.getDoctorId().equals(user.getDoctorId())) {
            return "permission_denied";
        }
        
        patient.setDoctorId(user.getDoctorId());
        boolean success = patientService.updatePatient(patient);
        return success ? "ok" : "error";
    }
    
    // 删除病人
    @GetMapping("/delete")
    @ResponseBody
    public String deletePatient(@RequestParam int id, HttpSession session) {
        SysUser user = (SysUser) session.getAttribute("user");
        if (user == null) return "login";
        
        // 检查病人是否属于当前医生
        Patient patient = patientService.getPatientById(id);
        if (patient == null || !patient.getDoctorId().equals(user.getDoctorId())) {
            return "permission_denied";
        }
        
        boolean success = patientService.deletePatient(id);
        return success ? "ok" : "error";
    }
    
    // 查看病人详情（模态框用）
    @GetMapping("/view")
    public String viewPatient(@RequestParam int id, HttpSession session, Model model) {
        SysUser user = (SysUser) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        
        Patient patient = patientService.getPatientById(id);
        // 检查病人是否属于当前医生
        if (patient == null || !patient.getDoctorId().equals(user.getDoctorId())) {
            return "redirect:/doctor/patient";
        }
        
        model.addAttribute("patient", patient);
        return "doctor/patient/view";
    }
}