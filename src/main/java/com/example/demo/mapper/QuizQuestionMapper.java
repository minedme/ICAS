package com.example.demo.mapper;

import com.example.demo.model.QuizQuestion;

import java.util.List;

public interface QuizQuestionMapper {
    // 添加测验问题
    int insert(QuizQuestion question);

    // 批量添加测验问题
    int insertBatch(List<QuizQuestion> questions);

    // 根据测验ID查询问题
    List<QuizQuestion> selectByQuizId(Integer quizId);

    // 根据ID查询问题
    QuizQuestion selectById(Integer id);

    // 更新问题
    int update(QuizQuestion question);

    // 删除问题
    int delete(Integer id);
    
    // 根据测验ID删除所有问题
    int deleteByQuizId(Integer quizId);
}