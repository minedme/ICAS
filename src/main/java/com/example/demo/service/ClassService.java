package com.example.demo.service;

import com.example.demo.model.ClassInfo;

import java.util.List;

public interface ClassService {
    boolean createClass(ClassInfo classInfo);

    boolean updateClass(ClassInfo classInfo);

    boolean deleteClass(Integer id);

    ClassInfo getClassById(Integer id);

    ClassInfo getClassByCode(String classCode);

    List<ClassInfo> getAllClasses();

    List<ClassInfo> getClassesByTeacherId(Integer teacherId);

    List<ClassInfo> getClassesByPage(int offset, int size);

    int getClassCount();

    List<ClassInfo> searchClasses(String className, String classCode, String major);

    boolean updateStudentCount(Integer classId, int count);
}
