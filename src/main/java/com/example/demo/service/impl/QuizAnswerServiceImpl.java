package com.example.demo.service.impl;

import com.example.demo.mapper.QuizAnswerMapper;
import com.example.demo.mapper.QuizQuestionMapper;
import com.example.demo.mapper.QuizMapper;
import com.example.demo.mapper.UserMapper;
import com.example.demo.model.Quiz;
import com.example.demo.model.QuizAnswer;
import com.example.demo.model.QuizQuestion;
import com.example.demo.model.User;
import com.example.demo.service.QuizAnswerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class QuizAnswerServiceImpl implements QuizAnswerService {

    @Autowired
    private QuizAnswerMapper answerMapper;

    @Autowired
    private QuizQuestionMapper questionMapper;

    @Autowired
    private QuizMapper quizMapper;

    @Autowired
    private UserMapper userMapper;

    @Override
    @Transactional
    public boolean submitAnswers(List<QuizAnswer> answers) {
        // 为每个答案设置提交时间
        Date now = new Date();
        for (QuizAnswer answer : answers) {
            // 初始化默认值
            answer.setIsCorrect(false);
            answer.setScore(0);
            
            // 获取正确答案
            QuizQuestion question = questionMapper.selectById(answer.getQuestionId());
            if (question != null) {
                // 判断答案是否正确
                boolean isCorrect = checkAnswer(question, answer.getStudentAnswer());
                answer.setIsCorrect(isCorrect);
                // 设置得分
                answer.setScore(isCorrect ? question.getScore() : 0);
            }
            answer.setAnswerTime(now);
        }
        // 批量插入答案
        int result = answerMapper.insertBatch(answers);
        return result > 0;
    }
    
    // 检查答案是否正确
    private boolean checkAnswer(QuizQuestion question, String studentAnswer) {
        String correctAnswer = question.getCorrectAnswer();
        String type = question.getType();
        
        if (studentAnswer == null || studentAnswer.isEmpty()) {
            return false;
        }
        
        // 复选框多选题：需要完全匹配
        if ("checkbox".equals(type)) {
            return checkCheckboxAnswer(correctAnswer, studentAnswer);
        }
        
        // 单选题和判断题：直接比较
        return correctAnswer.equals(studentAnswer);
    }
    
    // 检查复选框答案是否正确
    private boolean checkCheckboxAnswer(String correctAnswer, String studentAnswer) {
        if (correctAnswer == null || studentAnswer == null) {
            return false;
        }
        
        // 将答案转换为字符数组并排序
        char[] correctChars = correctAnswer.toCharArray();
        char[] studentChars = studentAnswer.toCharArray();
        
        // 如果长度不同，直接返回false
        if (correctChars.length != studentChars.length) {
            return false;
        }
        
        // 排序后比较
        java.util.Arrays.sort(correctChars);
        java.util.Arrays.sort(studentChars);
        
        return java.util.Arrays.equals(correctChars, studentChars);
    }

    @Override
    @Transactional
    public boolean updateAnswers(List<QuizAnswer> answers) {
        // 为每个答案设置提交时间
        Date now = new Date();
        for (QuizAnswer answer : answers) {
            // 初始化默认值
            answer.setIsCorrect(false);
            answer.setScore(0);
            
            // 获取正确答案
            QuizQuestion question = questionMapper.selectById(answer.getQuestionId());
            if (question != null) {
                // 判断答案是否正确
                boolean isCorrect = checkAnswer(question, answer.getStudentAnswer());
                answer.setIsCorrect(isCorrect);
                // 设置得分
                answer.setScore(isCorrect ? question.getScore() : 0);
            }
            answer.setAnswerTime(now);
        }
        // 批量更新答案
        int result = answerMapper.updateBatch(answers);
        return result > 0;
    }

    @Override
    public List<QuizAnswer> getAnswersByQuizId(Integer quizId) {
        return answerMapper.selectByQuizId(quizId);
    }

    @Override
    public List<QuizAnswer> getAnswersByStudentIdAndQuizId(Integer studentId, Integer quizId) {
        return answerMapper.selectByStudentIdAndQuizId(studentId, quizId);
    }

    @Override
    public Integer getStudentScore(Integer studentId, Integer quizId) {
        return answerMapper.selectScoreByStudentIdAndQuizId(studentId, quizId);
    }

    @Override
    public Double getAverageScore(Integer quizId) {
        List<QuizAnswer> answers = answerMapper.selectByQuizId(quizId);
        if (answers == null || answers.isEmpty()) {
            return 0.0;
        }
        // 计算每个学生的总分
        // 这里需要优化，应该使用SQL查询来获取平均分数
        // 暂时使用内存计算
        int totalScore = 0;
        // 使用Map来存储每个学生的总分
        Map<Integer, Integer> studentScores = new HashMap<>();
        
        for (QuizAnswer answer : answers) {
            Integer studentId = answer.getStudentId();
            int score = answer.getScore();
            
            if (studentScores.containsKey(studentId)) {
                // 如果学生已经有记录，累加分数
                studentScores.put(studentId, studentScores.get(studentId) + score);
            } else {
                // 如果是新学生，初始化分数
                studentScores.put(studentId, score);
            }
        }
        
        // 计算平均分数
        int studentCount = studentScores.size();
        if (studentCount == 0) {
            return 0.0;
        }
        
        // 计算所有学生的总分
        for (Integer score : studentScores.values()) {
            totalScore += score;
        }
        
        return (double) totalScore / studentCount;
    }

    @Override
    public Integer getAnswerCount(Integer quizId) {
        List<QuizAnswer> answers = answerMapper.selectByQuizId(quizId);
        if (answers == null) {
            return 0;
        }
        // 简单实现，实际应该使用SQL查询去重学生数
        return answers.size();
    }

    @Override
    public List<Map<String, Object>> getGradeTrend(Integer studentId, String course, LocalDate startDate, LocalDate endDate) {
        List<QuizAnswer> allAnswers = answerMapper.selectByStudentId(studentId);
        
        List<Map<String, Object>> result = new ArrayList<>();
        
        for (QuizAnswer answer : allAnswers) {
            LocalDate answerDate = answer.getAnswerTime().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
            
            if (answerDate.isBefore(startDate) || answerDate.isAfter(endDate)) {
                continue;
            }
            
            if (course != null && !course.isEmpty()) {
                Quiz quiz = quizMapper.selectById(answer.getQuizId());
                if (quiz == null || !course.equals(quiz.getCourseName())) {
                    continue;
                }
            }
            
            Map<String, Object> data = new HashMap<>();
            data.put("date", answerDate.toString());
            data.put("quizId", answer.getQuizId());
            data.put("score", answer.getScore() != null ? answer.getScore() : 0);
            data.put("isCorrect", answer.getIsCorrect());
            
            result.add(data);
        }
        
        return result;
    }

    @Override
    public List<String> getStudentCourses(Integer studentId) {
        List<QuizAnswer> answers = answerMapper.selectByStudentId(studentId);
        Set<String> courses = new HashSet<>();
        
        for (QuizAnswer answer : answers) {
            Quiz quiz = quizMapper.selectById(answer.getQuizId());
            if (quiz != null && quiz.getCourseName() != null) {
                courses.add(quiz.getCourseName());
            }
        }
        
        return new ArrayList<>(courses);
    }

    @Override
    public List<Map<String, Object>> getClassKnowledgeMastery(Integer classId) {
        List<Map<String, Object>> result = new ArrayList<>();
        
        List<User> students = userMapper.selectByClassId(classId);
        if (students == null || students.isEmpty()) {
            return result;
        }
        
        Map<String, Map<String, Integer>> knowledgeScores = new HashMap<>();
        
        for (User student : students) {
            List<QuizAnswer> answers = answerMapper.selectByStudentId(student.getId());
            
            for (QuizAnswer answer : answers) {
                QuizQuestion question = questionMapper.selectById(answer.getQuestionId());
                if (question == null) {
                    continue;
                }
                
                String knowledgePoint = question.getContent();
                if (knowledgePoint.length() > 20) {
                    knowledgePoint = knowledgePoint.substring(0, 20) + "...";
                }
                
                if (!knowledgeScores.containsKey(knowledgePoint)) {
                    knowledgeScores.put(knowledgePoint, new HashMap<>());
                    knowledgeScores.get(knowledgePoint).put("total", 0);
                    knowledgeScores.get(knowledgePoint).put("correct", 0);
                }
                
                knowledgeScores.get(knowledgePoint).put("total", knowledgeScores.get(knowledgePoint).get("total") + 1);
                if (answer.getIsCorrect() != null && answer.getIsCorrect()) {
                    knowledgeScores.get(knowledgePoint).put("correct", knowledgeScores.get(knowledgePoint).get("correct") + 1);
                }
            }
        }
        
        for (Map.Entry<String, Map<String, Integer>> entry : knowledgeScores.entrySet()) {
            Map<String, Object> knowledgeData = new HashMap<>();
            knowledgeData.put("name", entry.getKey());
            
            int total = entry.getValue().get("total");
            int correct = entry.getValue().get("correct");
            double masteryRate = total > 0 ? (double) correct / total * 100 : 0;
            
            knowledgeData.put("total", total);
            knowledgeData.put("correct", correct);
            knowledgeData.put("masteryRate", masteryRate);
            knowledgeData.put("value", masteryRate);
            
            result.add(knowledgeData);
        }
        
        return result;
    }
}
