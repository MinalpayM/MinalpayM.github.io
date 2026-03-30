package com.clinic.controller;

import com.clinic.model.Medicine;
import com.clinic.service.MedicineService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/admin/medicine")
public class MedicineController {
    
	@Autowired  
    private MedicineService medicineService;
    
    // 显示药品列表
    @GetMapping("/list")
    public String listMedicines(Model model) {
        List<Medicine> medicines = medicineService.getAllMedicines();
        model.addAttribute("medicines", medicines);
        return "admin/medicine/list";
    }
    
    // 显示添加药品表单
    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("medicine", new Medicine());
        return "admin/medicine/add";
    }
    
    // 显示编辑药品表单
    @GetMapping("/edit")
    public String showEditForm(@RequestParam("id") int medicineId, Model model) {
        Medicine medicine = medicineService.getMedicineById(medicineId);
        model.addAttribute("medicine", medicine);
        return "admin/medicine/edit";
    }
    
    // 删除药品
    @GetMapping("/delete")
    public String deleteMedicine(@RequestParam("id") int medicineId) {
        medicineService.deleteMedicine(medicineId);
        return "redirect:list";
    }
    
    // 搜索药品
    @GetMapping("/search")
    public String searchMedicines(@RequestParam("keyword") String keyword, Model model) {
        List<Medicine> medicines = medicineService.searchMedicines(keyword);
        model.addAttribute("medicines", medicines);
        model.addAttribute("keyword", keyword);
        return "admin/medicine/list";
    }
    
    // 保存药品（添加）
    @PostMapping("/save")
    public String saveMedicine(Medicine medicine) {
        medicineService.addMedicine(medicine);
        return "redirect:list";
    }
    
    // 更新药品
    @PostMapping("/update")
    public String updateMedicine(Medicine medicine) {
        medicineService.updateMedicine(medicine);
        return "redirect:list";
    }
    
    // 查询库存不足的药品
    @GetMapping("/low-stock")
    public String listLowStockMedicines(
            @RequestParam(value = "threshold", defaultValue = "10") int threshold,
            Model model) {
        
        List<Medicine> medicines = medicineService.getLowStockMedicines(threshold);
        model.addAttribute("medicines", medicines);
        model.addAttribute("threshold", threshold);
        model.addAttribute("isLowStockPage", true); // 标记这是库存不足页面
        
        return "admin/medicine/list";
    }
}