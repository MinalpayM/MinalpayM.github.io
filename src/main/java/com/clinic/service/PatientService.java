package com.clinic.service;

import com.clinic.dao.PatientDao;
import com.clinic.model.Patient;
import com.clinic.util.ValidatorUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PatientService {
    
    @Autowired
    private PatientDao patientDao;
    
    // 获取医生下的所有病人
    public List<Patient> getPatientsByDoctorId(int doctorId) {
        return patientDao.findByDoctorId(doctorId);
    }
    
    // 根据ID获取病人
    public Patient getPatientById(int patientId) {
        return patientDao.findById(patientId);
    }
    
    // 添加病人
    public boolean addPatient(Patient patient) {
        // 校验身份证号
        if (patient.getIdCard() != null && !patient.getIdCard().isEmpty()) {
            if (!ValidatorUtil.isValidIdCard(patient.getIdCard())) {
                return false;
            }
        }
        
        // 校验电话号码
        if (patient.getPhone() != null && !patient.getPhone().isEmpty()) {
            if (!ValidatorUtil.isValidPhone(patient.getPhone())) {
                return false;
            }
        }
        
        return patientDao.addPatient(patient);
    }
    
    // 更新病人
    public boolean updatePatient(Patient patient) {
        // 校验身份证号
        if (patient.getIdCard() != null && !patient.getIdCard().isEmpty()) {
            if (!ValidatorUtil.isValidIdCard(patient.getIdCard())) {
                return false;
            }
        }
        
        // 校验电话号码
        if (patient.getPhone() != null && !patient.getPhone().isEmpty()) {
            if (!ValidatorUtil.isValidPhone(patient.getPhone())) {
                return false;
            }
        }
        
        return patientDao.updatePatient(patient);
    }
    
    // 删除病人
    public boolean deletePatient(int patientId) {
        return patientDao.deletePatient(patientId);
    }
    
    // 搜索病人
    public List<Patient> searchPatients(int doctorId, String keyword) {
        return patientDao.searchPatients(doctorId, keyword);
    }
    
    // 统计病人数量
    public int countPatientsByDoctorId(int doctorId) {
        return patientDao.countByDoctorId(doctorId);
    }
}