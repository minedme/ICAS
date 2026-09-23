package com.example.demo.service.impl;

import com.example.demo.mapper.CourseMapper;
import com.example.demo.model.Course;
import com.example.demo.service.CourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class CourseServiceImpl implements CourseService {

    @Autowired
    private CourseMapper courseMapper;

    @Override
    public Course findById(Integer id) {
        return courseMapper.selectById(id);
    }

    @Override
    public List<Course> findAll() {
        return courseMapper.selectAll();
    }

    @Override
    public boolean addCourse(Course course) {
        Date now = new Date();
        course.setCreateTime(now);
        course.setUpdateTime(now);
        course.setStatus(1); // 1表示正常状态
        return courseMapper.insert(course) > 0;
    }

    @Override
    public boolean updateCourse(Course course) {
        course.setUpdateTime(new Date());
        return courseMapper.update(course) > 0;
    }

    @Override
    public boolean deleteCourse(Integer id) {
        return courseMapper.delete(id) > 0;
    }

    @Override
    public List<Course> searchCourses(String courseName, String courseCode) {
        return courseMapper.searchCourses(courseName, courseCode);
    }
}