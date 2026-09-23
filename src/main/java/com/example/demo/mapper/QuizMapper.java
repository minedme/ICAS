package com.example.demo.mapper;

import com.example.demo.model.Quiz;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface QuizMapper {
    // 创建测验
    int insert(Quiz quiz);

    // 更新测验
    int update(Quiz quiz);

    // 根据ID查询测验
    Quiz selectById(Integer id);

    // 根据教师ID查询测验
    List<Quiz> selectByTeacherId(Integer teacherId);

    // 查询所有测验
    List<Quiz> selectAll();

    // 更新测验状态
    int updateStatus(@Param("id") Integer id, @Param("status") Integer status);
    
    // 删除测验
    int delete(Integer id);
}