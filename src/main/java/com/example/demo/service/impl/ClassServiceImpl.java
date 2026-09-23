package com.example.demo.service.impl;

import com.example.demo.mapper.ClassMapper;
import com.example.demo.model.ClassInfo;
import com.example.demo.service.ClassService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClassServiceImpl implements ClassService {

    @Autowired
    private ClassMapper classMapper;

    @Override
    public boolean createClass(ClassInfo classInfo) {
        if (classInfo.getStatus() == null) {
            classInfo.setStatus(1);
        }
        return classMapper.insert(classInfo) > 0;
    }

    @Override
    public boolean updateClass(ClassInfo classInfo) {
        return classMapper.update(classInfo) > 0;
    }

    @Override
    public boolean deleteClass(Integer id) {
        return classMapper.delete(id) > 0;
    }

    @Override
    public ClassInfo getClassById(Integer id) {
        return classMapper.selectById(id);
    }

    @Override
    public ClassInfo getClassByCode(String classCode) {
        return classMapper.selectByCode(classCode);
    }

    @Override
    public List<ClassInfo> getAllClasses() {
        return classMapper.selectAll();
    }

    @Override
    public List<ClassInfo> getClassesByTeacherId(Integer teacherId) {
        return classMapper.selectByTeacherId(teacherId);
    }

    @Override
    public List<ClassInfo> getClassesByPage(int offset, int size) {
        return classMapper.selectByPage(offset, size);
    }

    @Override
    public int getClassCount() {
        return classMapper.count();
    }

    @Override
    public List<ClassInfo> searchClasses(String className, String classCode, String major) {
        return classMapper.searchClasses(className, classCode, major);
    }

    @Override
    public boolean updateStudentCount(Integer classId, int count) {
        return classMapper.updateStudentCount(classId, count) > 0;
    }
}
