package com.example.demo.service;

import com.example.demo.model.Quiz;
import com.example.demo.model.QuizQuestion;

import java.util.List;

public interface QuizService {
    // 创建测验
    boolean createQuiz(Quiz quiz, List<QuizQuestion> questions);

    // 更新测验
    boolean updateQuiz(Quiz quiz);

    // 根据ID查询测验
    Quiz getQuizById(Integer id);

    // 根据教师ID查询测验
    List<Quiz> getQuizzesByTeacherId(Integer teacherId);

    // 查询所有测验
    List<Quiz> getAllQuizzes();

    // 发布测验
    boolean publishQuiz(Integer id);

    // 结束测验
    boolean endQuiz(Integer id);
    
    // 根据测验ID获取题目
    List<QuizQuestion> getQuestionsByQuizId(Integer quizId);
    
    // 删除测验
    boolean deleteQuiz(Integer id);
    
    // 根据当前时间更新测验状态
    void updateQuizStatusByTime();
}