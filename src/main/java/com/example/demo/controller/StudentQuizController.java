package com.example.demo.controller;

import com.example.demo.model.Quiz;
import com.example.demo.model.QuizAnswer;
import com.example.demo.model.QuizQuestion;
import com.example.demo.model.User;
import com.example.demo.service.QuizAnswerService;
import com.example.demo.service.QuizService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/student/quiz")
public class StudentQuizController {

    @Autowired
    private QuizService quizService;

    @Autowired
    private QuizAnswerService quizAnswerService;

    // 查看可参与的测验列表
    @GetMapping("/list")
    public String quizList(Model model, HttpSession session) {
        System.out.println("=== 进入学生测验列表方法 ===");
        
        // 根据当前时间更新测验状态
        quizService.updateQuizStatusByTime();
        
        List<Quiz> quizzes = quizService.getAllQuizzes();
        System.out.println("获取到的测验数量: " + quizzes.size());
        for (Quiz quiz : quizzes) {
            System.out.println("测验ID: " + quiz.getId() + ", 标题: " + quiz.getTitle() + ", 状态: " + quiz.getStatus());
        }
        
        // 获取当前学生ID
        User user = (User) session.getAttribute("user");
        System.out.println("当前用户: " + user);
        if (user != null) {
            Integer studentId = user.getId();
            System.out.println("当前学生ID: " + studentId);
            // 为每个测验添加学生的得分信息
            for (Quiz quiz : quizzes) {
                Integer score = quizAnswerService.getStudentScore(studentId, quiz.getId());
                if (score != null) {
                    quiz.setMyScore(score);
                    System.out.println("测验ID: " + quiz.getId() + ", 学生得分: " + score);
                } else {
                    System.out.println("测验ID: " + quiz.getId() + ", 学生未得分");
                }
            }
        }
        
        model.addAttribute("quizzes", quizzes);
        System.out.println("添加到model的测验数量: " + quizzes.size());
        System.out.println("=== 学生测验列表方法结束 ===");
        return "student/quiz/list";
    }

    // 进入测验页面
    @GetMapping("/participate/{id}")
    public String participateQuiz(@PathVariable Integer id, Model model, HttpSession session) {
        Quiz quiz = quizService.getQuizById(id);
        model.addAttribute("quiz", quiz);
        model.addAttribute("questions", quiz.getQuestions());
        
        // 获取学生已提交的答案
        User user = (User) session.getAttribute("user");
        if (user != null) {
            List<QuizAnswer> submittedAnswers = quizAnswerService.getAnswersByStudentIdAndQuizId(user.getId(), id);
            model.addAttribute("submittedAnswers", submittedAnswers);
        }
        
        return "student/quiz/take";
    }

    // 提交测验答案
    @PostMapping("/submit/{quizId}")
    public String submitQuiz(@PathVariable Integer quizId, 
                             @RequestParam Map<String, String> allParams,
                             HttpSession session, 
                             Model model) {
        System.out.println("=== 提交测验答案 ===");
        System.out.println("Session ID: " + session.getId());
        User user = (User) session.getAttribute("user");
        System.out.println("Session中的用户: " + user);
        
        if (user == null) {
            System.out.println("用户未登录，重定向到登录页面");
            return "redirect:/login";
        }
        
        Integer studentId = user.getId();
        System.out.println("学生ID: " + studentId + ", 测验ID: " + quizId);
        
        // 获取测验的问题
        Quiz quiz = quizService.getQuizById(quizId);
        List<QuizQuestion> questions = quiz.getQuestions();
        
        // 构建答案列表
        List<QuizAnswer> answers = new ArrayList<>();
        
        // 处理每个问题的答案
        for (int i = 0; i < questions.size(); i++) {
            QuizQuestion question = questions.get(i);
            String answerKey = "answers[" + i + "].studentAnswer";
            String studentAnswer = allParams.get(answerKey);
            
            QuizAnswer answer = new QuizAnswer();
            answer.setStudentId(studentId);
            answer.setQuizId(quizId);
            answer.setQuestionId(question.getId());
            answer.setStudentAnswer(studentAnswer != null ? studentAnswer : "");
            
            answers.add(answer);
        }
        
        // 提交答案
        try {
            boolean success = quizAnswerService.submitAnswers(answers);
            System.out.println("提交答案结果: " + success);
            if (success) {
                System.out.println("准备重定向到结果页面: /student/quiz/result/" + quizId);
                return "redirect:/student/quiz/result/" + quizId;
            } else {
                model.addAttribute("error", "提交失败，请重试");
                model.addAttribute("quiz", quiz);
                model.addAttribute("questions", questions);
                return "student/quiz/take";
            }
        } catch (Exception e) {
            System.out.println("提交答案异常: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "提交失败：" + e.getMessage());
            model.addAttribute("quiz", quiz);
            model.addAttribute("questions", questions);
            return "student/quiz/take";
        }
    }
    
    // 修改测验答案
    @PostMapping("/update/{quizId}")
    public String updateQuiz(@PathVariable Integer quizId, 
                             @RequestParam Map<String, String> allParams,
                             HttpSession session, 
                             Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        Integer studentId = user.getId();
        
        // 获取测验的问题
        Quiz quiz = quizService.getQuizById(quizId);
        List<QuizQuestion> questions = quiz.getQuestions();
        
        // 构建答案列表
        List<QuizAnswer> answers = new ArrayList<>();
        
        // 处理每个问题的答案
        for (int i = 0; i < questions.size(); i++) {
            QuizQuestion question = questions.get(i);
            String answerKey = "answers[" + i + "].studentAnswer";
            String studentAnswer = allParams.get(answerKey);
            
            QuizAnswer answer = new QuizAnswer();
            answer.setStudentId(studentId);
            answer.setQuizId(quizId);
            answer.setQuestionId(question.getId());
            answer.setStudentAnswer(studentAnswer != null ? studentAnswer : "");
            
            answers.add(answer);
        }
        
        // 更新答案
        try {
            boolean success = quizAnswerService.updateAnswers(answers);
            if (success) {
                return "redirect:/student/quiz/result/" + quizId;
            } else {
                model.addAttribute("error", "修改失败，请重试");
                model.addAttribute("quiz", quiz);
                model.addAttribute("questions", questions);
                return "student/quiz/take";
            }
        } catch (Exception e) {
            model.addAttribute("error", "修改失败：" + e.getMessage());
            model.addAttribute("quiz", quiz);
            model.addAttribute("questions", questions);
            return "student/quiz/take";
        }
    }

    // 查看测验结果
    @GetMapping("/result/{quizId}")
    public String quizResult(@PathVariable Integer quizId, 
                            HttpSession session, 
                            Model model) {
        System.out.println("=== 进入测验结果页面 ===");
        System.out.println("Session ID: " + session.getId());
        User user = (User) session.getAttribute("user");
        System.out.println("Session中的用户: " + user);
        
        if (user == null) {
            System.out.println("用户未登录，重定向到登录页面");
            return "redirect:/login";
        }
        
        Integer studentId = user.getId();
        System.out.println("学生ID: " + studentId + ", 测验ID: " + quizId);
        
        // 获取学生的答案
        List<QuizAnswer> answers = quizAnswerService.getAnswersByStudentIdAndQuizId(studentId, quizId);
        System.out.println("获取到的答案数量: " + (answers != null ? answers.size() : 0));
        
        // 检查是否有答案记录
        if (answers == null || answers.isEmpty()) {
            model.addAttribute("error", "暂无答题记录，请先参加测验");
            return "student/quiz/list";
        }
        
        // 获取测验的问题
        List<QuizQuestion> questions = quizService.getQuestionsByQuizId(quizId);
        
        // 为每个答案添加问题内容和正确答案，并设置isCorrect和score
        for (QuizAnswer answer : answers) {
            QuizQuestion question = questions.stream()
                .filter(q -> q.getId().equals(answer.getQuestionId()))
                .findFirst()
                .orElse(null);
            if (question != null) {
                answer.setQuestionContent(question.getContent());
                answer.setCorrectAnswer(question.getCorrectAnswer());
                // 设置isCorrect和score（从数据库获取的值）
                if (answer.getIsCorrect() == null) {
                    answer.setIsCorrect(false);
                }
                if (answer.getScore() == null) {
                    answer.setScore(0);
                }
            } else {
                // 如果找不到对应的问题，设置默认值
                answer.setQuestionContent("问题已删除");
                answer.setCorrectAnswer("");
                answer.setIsCorrect(false);
                answer.setScore(0);
            }
        }
        
        // 获取学生的得分
        Integer score = quizAnswerService.getStudentScore(studentId, quizId);
        System.out.println("学生得分: " + score);
        
        model.addAttribute("answers", answers);
        model.addAttribute("score", score != null ? score : 0);
        model.addAttribute("quizId", quizId);
        
        System.out.println("=== 测验结果页面结束 ===");
        return "student/quiz/result";
    }
}
