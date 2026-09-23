package com.example.demo.service;

import com.example.demo.model.Course;

import java.util.List;

public interface CourseService {
    // 根据ID查询课程
    Course findById(Integer id);

    // 查询所有课程
    List<Course> findAll();

    // 添加课程
    boolean addCourse(Course course);

    // 更新课程
    boolean updateCourse(Course course);

    // 删除课程
    boolean deleteCourse(Integer id);

    // 根据课程名称或代码搜索课程
    List<Course> searchCourses(String courseName, String courseCode);
}