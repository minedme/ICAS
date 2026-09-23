package com.example.demo.mapper;

import com.example.demo.model.QuizAnswer;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface QuizAnswerMapper {
    // 提交测验答案
    int insert(QuizAnswer answer);

    // 批量提交测验答案
    int insertBatch(List<QuizAnswer> answers);

    // 更新测验答案
    int update(QuizAnswer answer);

    // 批量更新测验答案
    int updateBatch(List<QuizAnswer> answers);

    // 根据测验ID查询答案
    List<QuizAnswer> selectByQuizId(Integer quizId);

    // 根据学生ID和测验ID查询答案
    List<QuizAnswer> selectByStudentIdAndQuizId(@Param("studentId") Integer studentId, @Param("quizId") Integer quizId);

    // 根据学生ID查询答案
    List<QuizAnswer> selectByStudentId(Integer studentId);

    // 查询学生在测验中的得分
    Integer selectScoreByStudentIdAndQuizId(@Param("studentId") Integer studentId, @Param("quizId") Integer quizId);
    
    // 查询所有测验答案
    List<QuizAnswer> selectAll();
}