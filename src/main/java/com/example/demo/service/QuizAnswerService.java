package com.example.demo.service;

import com.example.demo.model.QuizAnswer;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public interface QuizAnswerService {
    // 提交测验答案
    boolean submitAnswers(List<QuizAnswer> answers);

    // 更新测验答案
    boolean updateAnswers(List<QuizAnswer> answers);

    // 根据测验ID查询所有答案
    List<QuizAnswer> getAnswersByQuizId(Integer quizId);

    // 根据学生ID和测验ID查询答案
    List<QuizAnswer> getAnswersByStudentIdAndQuizId(Integer studentId, Integer quizId);

    // 获取学生在测验中的得分
    Integer getStudentScore(Integer studentId, Integer quizId);

    // 获取测验的平均得分
    Double getAverageScore(Integer quizId);

    // 获取测验的答题人数
    Integer getAnswerCount(Integer quizId);

    // 获取学生成绩趋势
    List<Map<String, Object>> getGradeTrend(Integer studentId, String course, LocalDate startDate, LocalDate endDate);

    // 获取学生课程列表
    List<String> getStudentCourses(Integer studentId);

    // 获取班级知识点掌握情况
    List<Map<String, Object>> getClassKnowledgeMastery(Integer classId);
}