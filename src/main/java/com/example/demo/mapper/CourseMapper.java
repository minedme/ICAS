package com.example.demo.mapper;

import com.example.demo.model.Course;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CourseMapper {
    // 根据ID查询课程
    Course selectById(Integer id);

    // 查询所有课程
    List<Course> selectAll();

    // 插入课程
    int insert(Course course);

    // 更新课程
    int update(Course course);

    // 删除课程
    int delete(Integer id);
    
    // 根据课程名称或代码搜索课程
    List<Course> searchCourses(@Param("courseName") String courseName, @Param("courseCode") String courseCode);
}