package com.example.demo.service.impl;

import com.example.demo.mapper.QuizMapper;
import com.example.demo.mapper.QuizQuestionMapper;
import com.example.demo.model.Quiz;
import com.example.demo.model.QuizQuestion;
import com.example.demo.service.QuizService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class QuizServiceImpl implements QuizService {

    @Autowired
    private QuizMapper quizMapper;

    @Autowired
    private QuizQuestionMapper questionMapper;

    @Override
    @Transactional
    public boolean createQuiz(Quiz quiz, List<QuizQuestion> questions) {
        try {
            // 设置测验创建时间和状态
            quiz.setCreateTime(new Date());
            quiz.setStatus(0); // 0表示未发布
            int quizResult = quizMapper.insert(quiz);

            // 批量插入问题，确保questions不为空
            if (questions != null && !questions.isEmpty()) {
                for (QuizQuestion question : questions) {
                    question.setQuizId(quiz.getId());
                    // 确保选项字段不为null
                    if (question.getOptionA() == null) question.setOptionA("");
                    if (question.getOptionB() == null) question.setOptionB("");
                    if (question.getOptionC() == null) question.setOptionC("");
                    if (question.getOptionD() == null) question.setOptionD("");
                    if (question.getCorrectAnswer() == null) question.setCorrectAnswer("");
                    // 确保score字段不为null
                    if (question.getScore() == null) question.setScore(0);
                }
                int questionResult = questionMapper.insertBatch(questions);
                return quizResult > 0 && questionResult == questions.size();
            }
            
            // 如果没有问题，只需要测验创建成功即可
            return quizResult > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    @Transactional
    public boolean updateQuiz(Quiz quiz) {
        try {
            // 更新测验主表信息
            int quizResult = quizMapper.update(quiz);
            if (quizResult <= 0) {
                return false;
            }
            
            // 获取测验的问题列表
            List<QuizQuestion> questions = quiz.getQuestions();
            
            // 如果有问题，先删除该测验的所有旧问题，再插入新问题
            if (questions != null && !questions.isEmpty()) {
                // 删除旧问题
                questionMapper.deleteByQuizId(quiz.getId());
                
                // 批量插入新问题
                for (QuizQuestion question : questions) {
                    question.setQuizId(quiz.getId());
                    // 确保选项字段不为null
                    if (question.getOptionA() == null) question.setOptionA("");
                    if (question.getOptionB() == null) question.setOptionB("");
                    if (question.getOptionC() == null) question.setOptionC("");
                    if (question.getOptionD() == null) question.setOptionD("");
                    if (question.getCorrectAnswer() == null) question.setCorrectAnswer("");
                    // 确保score字段不为null
                    if (question.getScore() == null) question.setScore(0);
                }
                int questionResult = questionMapper.insertBatch(questions);
                return quizResult > 0 && questionResult == questions.size();
            }
            
            // 如果没有问题，只需要测验更新成功即可
            return quizResult > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Quiz getQuizById(Integer id) {
        Quiz quiz = quizMapper.selectById(id);
        if (quiz != null) {
            List<QuizQuestion> questions = questionMapper.selectByQuizId(id);
            if (questions == null) {
                questions = new ArrayList<>();
            }
            quiz.setQuestions(questions);
        }
        return quiz;
    }

    @Override
    public List<Quiz> getQuizzesByTeacherId(Integer teacherId) {
        return quizMapper.selectByTeacherId(teacherId);
    }

    @Override
    public List<Quiz> getAllQuizzes() {
        return quizMapper.selectAll();
    }

    @Override
    public boolean publishQuiz(Integer id) {
        return quizMapper.updateStatus(id, 1) > 0; // 1表示已发布
    }

    @Override
    public boolean endQuiz(Integer id) {
        return quizMapper.updateStatus(id, 2) > 0; // 2表示已结束
    }

    @Override
    public List<QuizQuestion> getQuestionsByQuizId(Integer quizId) {
        return questionMapper.selectByQuizId(quizId);
    }
    
    @Override
    @Transactional
    public boolean deleteQuiz(Integer id) {
        try {
            // 先删除该测验的所有问题
            questionMapper.deleteByQuizId(id);
            
            // 然后删除测验本身
            int result = quizMapper.delete(id);
            
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public void updateQuizStatusByTime() {
        Date now = new Date();
        System.out.println("=== 开始更新测验状态 ===");
        System.out.println("当前时间: " + new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(now));
        
        List<Quiz> allQuizzes = quizMapper.selectAll();
        System.out.println("需要检查的测验数量: " + allQuizzes.size());
        
        for (Quiz quiz : allQuizzes) {
            Integer currentStatus = quiz.getStatus();
            Date startTime = quiz.getStartTime();
            Date endTime = quiz.getEndTime();
            
            Integer newStatus = null;
            
            if (now.before(startTime)) {
                newStatus = 0;
            } else if (now.after(endTime)) {
                newStatus = 2;
            } else {
                newStatus = 1;
            }
            
            System.out.println("测验ID: " + quiz.getId() + ", 标题: " + quiz.getTitle() + 
                             ", 当前状态: " + currentStatus + ", 新状态: " + newStatus);
            
            if (newStatus != null && !newStatus.equals(currentStatus)) {
                int result = quizMapper.updateStatus(quiz.getId(), newStatus);
                System.out.println("更新测验ID " + quiz.getId() + " 的状态从 " + currentStatus + " 到 " + newStatus + 
                                 ", 结果: " + (result > 0 ? "成功" : "失败"));
            }
        }
        System.out.println("=== 测验状态更新完成 ===");
    }
}