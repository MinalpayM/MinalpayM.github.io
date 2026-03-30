package com.clinic.controller.doctor;

import com.clinic.model.*;
import com.clinic.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/doctor/prescription")
public class DoctorPrescriptionController {

    @Autowired
    private MedicalCaseService medicalCaseService;

    @Autowired
    private PatientService patientService;

    @Autowired
    private MedicineService medicineService;

    // 病例列表页面
    @GetMapping
    public String prescriptionList(
    	    @RequestParam(required = false) String keyword,
    	    HttpSession session, 
    	    Model model) {
    	    
    	    SysUser user = (SysUser) session.getAttribute("user");
    	    if (user == null) return "redirect:/login";
    	    
    	    // 获取医生的所有病例（支持搜索）
    	    List<MedicalCase> cases;
    	    if (keyword != null && !keyword.trim().isEmpty()) {
    	        // 如果有搜索关键词，执行搜索
    	        cases = medicalCaseService.searchCases(user.getDoctorId(), keyword.trim());
    	    } else {
    	        // 否则获取所有病例
    	        cases = medicalCaseService.getCasesByDoctorId(user.getDoctorId());
    	    }
    	    
    	    model.addAttribute("cases", cases);
    	    model.addAttribute("doctorId", user.getDoctorId());
    	    model.addAttribute("keyword", keyword); // 传递搜索关键词到页面
    	    return "doctor/prescription/list";
    	}

    // 创建新病例页面
    @GetMapping("/create")
    public String createCaseForm(HttpSession session, Model model) {
        SysUser user = (SysUser) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        // 获取该医生的所有病人
        List<Patient> patients = patientService.getPatientsByDoctorId(user.getDoctorId());
        model.addAttribute("patients", patients);
        model.addAttribute("doctorId", user.getDoctorId());

        return "doctor/prescription/create";
    }

    // 创建新病例
    @PostMapping("/create")
    @ResponseBody
    public String createCase(
            @RequestParam Integer patientId,
            @RequestParam String symptom,
            HttpSession session) {
        
        SysUser user = (SysUser) session.getAttribute("user");
        if (user == null) return "login";
        
        MedicalCase medicalCase = new MedicalCase();
        medicalCase.setPatientId(patientId);
        medicalCase.setDoctorId(user.getDoctorId());
        medicalCase.setSymptom(symptom);
        medicalCase.setTotalFee(0.0);
        
        boolean success = medicalCaseService.createCase(medicalCase);
        return success ? "ok" : "error";
    }

    // 显示编辑病例表单
    @GetMapping("/edit")
    public String editCaseForm(@RequestParam int caseId, HttpSession session, Model model) {
        SysUser user = (SysUser) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        
        MedicalCase medicalCase = medicalCaseService.getCaseById(caseId);
        // 验证权限：确保医生只能访问自己的病例
        if (medicalCase == null || !medicalCase.getDoctorId().equals(user.getDoctorId())) {
            return "redirect:/doctor/prescription";
        }
        
        // 获取该医生的所有病人
        List<Patient> patients = patientService.getPatientsByDoctorId(user.getDoctorId());
        model.addAttribute("medicalCase", medicalCase);
        model.addAttribute("patients", patients);
        model.addAttribute("doctorId", user.getDoctorId());
        
        return "doctor/prescription/edit";
    }

    // 更新病例信息
    @PostMapping("/updateCase")
    @ResponseBody
    public String updateCase(MedicalCase medicalCase, HttpSession session) {
        SysUser user = (SysUser) session.getAttribute("user");
        if (user == null) return "login";
        
        // 验证权限
        MedicalCase existingCase = medicalCaseService.getCaseById(medicalCase.getCaseId());
        if (existingCase == null || !existingCase.getDoctorId().equals(user.getDoctorId())) {
            return "permission_denied";
        }
        
        // 设置医生ID，确保只能修改自己的病例
        medicalCase.setDoctorId(user.getDoctorId());
        boolean success = medicalCaseService.updateCase(medicalCase);
        return success ? "ok" : "error";
    }
    
    // 合并后的开药页面（为特定病例）
    @GetMapping("/detail/{caseId}")
    public String prescriptionDetail(
            @PathVariable int caseId,
            HttpSession session,
            Model model,
            @RequestParam(required = false) String from,
            @RequestParam(required = false) String edit) {
        
        SysUser user = (SysUser) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        // 获取处方详情
        PrescriptionDetail detail = medicalCaseService.getPrescriptionDetail(caseId);
        if (detail == null) {
            return "redirect:/doctor/prescription";
        }

        // 验证权限：确保医生只能访问自己的病例
        if (!detail.getMedicalCase().getDoctorId().equals(user.getDoctorId())) {
            return "redirect:/doctor/prescription";
        }

        // 获取所有药品供选择
        List<Medicine> medicines = medicineService.getAllMedicines();

        // 添加来源信息到模型（如果有的话）
        model.addAttribute("detail", detail);
        model.addAttribute("medicines", medicines);
        
        // 设置是否来自编辑页面的标识
        if (from != null && from.equals("edit")) {
            model.addAttribute("fromEditPage", true);
        }
        
        if (edit != null && edit.equals("true")) {
            model.addAttribute("editMode", true);
        }

        return "doctor/prescription/detail";
    }

    // 添加处方项
    @PostMapping("/addItem")
    @ResponseBody
    public String addPrescriptionItem(@RequestParam int caseId,
                                      @RequestParam int medicineId,
                                      @RequestParam int quantity,
                                      HttpSession session) {
        SysUser user = (SysUser) session.getAttribute("user");
        if (user == null) return "login";
        
        // 验证权限
        MedicalCase medicalCase = medicalCaseService.getCaseById(caseId);
        if (medicalCase == null || !medicalCase.getDoctorId().equals(user.getDoctorId())) {
            return "permission_denied";
        }
        
        // 获取药品信息
        Medicine medicine = medicineService.getMedicineById(medicineId);
        if (medicine == null) {
            return "medicine_not_found";
        }
        
        // 检查库存
        if (medicine.getStock() < quantity) {
            return "insufficient_stock";
        }
        
        // 创建处方项
        Prescription prescription = new Prescription();
        prescription.setCaseId(caseId);
        prescription.setMedicineId(medicineId);
        prescription.setQuantity(quantity);
        prescription.setPrice(medicine.getPrice());
        
        // 添加处方项
        boolean success = medicalCaseService.addPrescriptionItem(prescription);
        
        if (success) {
            // 更新药品库存
            boolean stockUpdated = medicineService.updateStock(medicineId, medicine.getStock() - quantity);
            if (!stockUpdated) {
                // 如果库存更新失败，记录日志
                System.err.println("库存更新失败，但处方项已添加: medicineId=" + medicineId);
            }
        }
        
        return success ? "ok" : "error";
    }

    // 删除处方项
    @PostMapping("/deleteItem")
    @ResponseBody
    public String deletePrescriptionItem(@RequestParam int id, @RequestParam int caseId, HttpSession session) {
        SysUser user = (SysUser) session.getAttribute("user");
        if (user == null) return "login";

        // 验证权限
        MedicalCase medicalCase = medicalCaseService.getCaseById(caseId);
        if (medicalCase == null || !medicalCase.getDoctorId().equals(user.getDoctorId())) {
            return "permission_denied";
        }

        boolean success = medicalCaseService.deletePrescriptionItem(id, caseId);
        return success ? "ok" : "error";
    }

    // 删除病例
    @PostMapping("/deleteCase")
    @ResponseBody
    public String deleteCase(@RequestParam int caseId, HttpSession session) {
        SysUser user = (SysUser) session.getAttribute("user");
        if (user == null) return "login";

        boolean success = medicalCaseService.deleteCase(caseId, user.getDoctorId());
        return success ? "ok" : "error";
    }

    // 查看病例详情（模态框）
    @GetMapping("/view/{caseId}")
    public String viewCase(@PathVariable int caseId, HttpSession session, Model model) {
        SysUser user = (SysUser) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        
        PrescriptionDetail detail = medicalCaseService.getPrescriptionDetail(caseId);
        
        if (detail == null || detail.getMedicalCase() == null || detail.getPatient() == null) {
            // 记录日志或返回错误页面
            System.err.println("PrescriptionDetail is null for caseId: " + caseId);
            return "redirect:/doctor/prescription";
        }
        
        if (!detail.getMedicalCase().getDoctorId().equals(user.getDoctorId())) {
            return "redirect:/doctor/prescription";
        }
        
        model.addAttribute("detail", detail);
        return "doctor/prescription/view";
    }
    
    // 查看药品详细信息页面
    @GetMapping("/medicine/view/{medicineId}")
    public String viewMedicine(@PathVariable int medicineId, HttpSession session, Model model) {
        SysUser user = (SysUser) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        
        Medicine medicine = medicineService.getMedicineById(medicineId);
        if (medicine == null) {
            return "redirect:/doctor/prescription";
        }
        
        model.addAttribute("medicine", medicine);
        return "doctor/prescription/medicine_view";
    }
}