package com.example.demo.util;

import com.example.demo.mapper.QuizMapper;
import com.example.demo.model.Quiz;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class QuizChecker implements CommandLineRunner {
    
    @Autowired
    private QuizMapper quizMapper;
    
    @Override
    public void run(String... args) throws Exception {
        System.out.println("=== 检查测验数据 ===");
        System.out.println("获取所有测验:");
        List<Quiz> quizzes = quizMapper.selectAll();
        System.out.println("测验总数: " + quizzes.size());
        for (Quiz quiz : quizzes) {
            System.out.println("测验ID: " + quiz.getId() + ", 标题: " + quiz.getTitle() + ", 状态: " + quiz.getStatus() + ", 教师ID: " + quiz.getTeacherId());
        }
        System.out.println("=== 测验数据检查完成 ===");
    }
}