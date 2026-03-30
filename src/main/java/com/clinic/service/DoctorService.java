package com.clinic.service;

import com.clinic.dao.DoctorDao;
import com.clinic.model.Doctor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DoctorService {

    @Autowired
    private DoctorDao dao;

    public List<Doctor> listDoctors() {
    	System.out.println("dao = " + dao);
        return dao.findAll();
    }

    public void addDoctor(Doctor d) {
        dao.addDoctor(d);
    }

    public Doctor getDoctor(int id) {
        return dao.findById(id);
    }

    public void updateDoctor(Doctor d) {
        dao.updateDoctor(d);
    }

    public void deleteDoctor(int id) {
        dao.deleteDoctor(id);
    }

    public int countDoctors() {
        return dao.countDoctors();
    }

    public List<Doctor> search(String keyword, String title) {
        return dao.search(keyword, title);
    }
}
