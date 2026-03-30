package com.clinic.service;

import com.clinic.dao.MedicineDao;
import com.clinic.model.Medicine;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MedicineService {
	@Autowired
    private MedicineDao medicineDao = new MedicineDao();
    
    public List<Medicine> getAllMedicines() {
        return medicineDao.findAll();
    }
    
    public Medicine getMedicineById(int medicineId) {
        return medicineDao.findById(medicineId);
    }
    
 // 更新库存 - 新增方法
    public boolean updateStock(int medicineId, int newStock) {
        return medicineDao.updateStock(medicineId, newStock);
    }
    
    public boolean addMedicine(Medicine medicine) {
        return medicineDao.insert(medicine);
    }
    
    public boolean updateMedicine(Medicine medicine) {
        return medicineDao.update(medicine);
    }
    
    public boolean deleteMedicine(int medicineId) {
        return medicineDao.delete(medicineId);
    }
    
    public List<Medicine> searchMedicines(String keyword) {
        return medicineDao.search(keyword);
    }
    
    // 获取库存不足药品
    public List<Medicine> getLowStockMedicines(int threshold) {
        return medicineDao.findLowStock(threshold);
    }

    // 获取库存不足药品数量
    public int getLowStockCount(int threshold) {
        return medicineDao.countLowStock(threshold);
    }

}