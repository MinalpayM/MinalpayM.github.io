package com.clinic.service;

import com.clinic.dao.MedicalCaseDao;
import com.clinic.dao.PrescriptionDao;
import com.clinic.model.MedicalCase;
import com.clinic.model.Prescription;
import com.clinic.model.PrescriptionDetail;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MedicalCaseService {

    @Autowired
    private MedicalCaseDao medicalCaseDao;

    @Autowired
    private PrescriptionDao prescriptionDao;

    @Autowired
    private PatientService patientService;

    // 获取医生的所有病例
    public List<MedicalCase> getCasesByDoctorId(int doctorId) {
        return medicalCaseDao.findByDoctorId(doctorId);
    }

    // 获取病人的所有病例
    public List<MedicalCase> getCasesByPatientId(int patientId) {
        return medicalCaseDao.findByPatientId(patientId);
    }

    // 根据ID获取病例
    public MedicalCase getCaseById(int caseId) {
        return medicalCaseDao.findById(caseId);
    }

    // 创建新病例
    public boolean createCase(MedicalCase medicalCase) {
        return medicalCaseDao.create(medicalCase);
    }

    // 更新病例
    public boolean updateCase(MedicalCase medicalCase) {
        return medicalCaseDao.update(medicalCase);
    }
    
 // 搜索病例（按病人姓名或症状）
    public List<MedicalCase> searchCases(int doctorId, String keyword) {
        return medicalCaseDao.searchByKeyword(doctorId, keyword);
    }
    
 // 删除病例
    public boolean deleteCase(int caseId, int doctorId) {
        // 先删除处方项
        prescriptionDao.deleteByCaseId(caseId);
        // 再删除病例
        return medicalCaseDao.delete(caseId, doctorId);
    }

    // 获取处方详情
    public PrescriptionDetail getPrescriptionDetail(int caseId) {
        PrescriptionDetail detail = new PrescriptionDetail();
        
        // 获取病例信息
        MedicalCase medicalCase = medicalCaseDao.findById(caseId);
        if (medicalCase == null) {
            return null;
        }
        
        // 获取病人信息
        detail.setPatient(patientService.getPatientById(medicalCase.getPatientId()));
        
        // 获取处方项
        List<Prescription> prescriptions = prescriptionDao.findByCaseId(caseId);
        
        detail.setMedicalCase(medicalCase);
        detail.setPrescriptions(prescriptions);
        
        return detail;
    }
    
 // 添加处方项
    public boolean addPrescriptionItem(Prescription prescription) {
        boolean success = prescriptionDao.add(prescription);
        if (success) {
            double totalFee = prescriptionDao.calculateTotalFee(prescription.getCaseId());
            medicalCaseDao.updateTotalFee(prescription.getCaseId(), totalFee);
        }
        return success;
    }

    // 删除处方项
    public boolean deletePrescriptionItem(int id, int caseId) {
        boolean success = prescriptionDao.delete(id);
        if (success) {
            // 更新病例总费用
            double totalFee = prescriptionDao.calculateTotalFee(caseId);
            medicalCaseDao.updateTotalFee(caseId, totalFee);
        }
        return success;
    }

    // 获取病例的处方项
    public List<Prescription> getPrescriptionsByCaseId(int caseId) {
        return prescriptionDao.findByCaseId(caseId);
    }
}