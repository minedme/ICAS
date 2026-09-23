package com.example.demo.controller;

import com.example.demo.model.Quiz;
import com.example.demo.model.QuizQuestion;
import com.example.demo.model.User;
import com.example.demo.service.QuizService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/teacher/quiz")
public class TeacherQuizController {

    @Autowired
    private QuizService quizService;

    // 进入创建测验页面
    @GetMapping("/create")
    public String createQuizPage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        model.addAttribute("quiz", new Quiz());
        return "teacher/quiz/create";
    }

    // 提交测验创建
    @PostMapping("/create")
    public String createQuiz(@ModelAttribute Quiz quiz, HttpSession session, RedirectAttributes redirectAttributes) {
        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                return "redirect:/user/login";
            }
            quiz.setTeacherId(user.getId());
            List<QuizQuestion> questions = quiz.getQuestions();
            boolean success = quizService.createQuiz(quiz, questions);
            if (success) {
                redirectAttributes.addAttribute("successMessage", "测验创建成功！");
            } else {
                redirectAttributes.addAttribute("errorMessage", "测验创建失败，请重试！");
            }
        } catch (Exception e) {
            redirectAttributes.addAttribute("errorMessage", "创建过程中发生错误：" + e.getMessage());
        }
        return "redirect:/teacher/quiz/list";
    }

    // 查看教师的测验列表
    @GetMapping("/list")
    public String quizList(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        // 根据当前时间更新测验状态
        quizService.updateQuizStatusByTime();
        
        List<Quiz> quizzes = quizService.getQuizzesByTeacherId(user.getId());
        model.addAttribute("quizzes", quizzes);
        return "teacher/quiz/list";
    }

    // 发布测验
    @GetMapping("/publish/{id}")
    public String publishQuiz(HttpSession session, @PathVariable Integer id) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        quizService.publishQuiz(id);
        return "redirect:/teacher/quiz/list";
    }

    // 结束测验
    @GetMapping("/end/{id}")
    public String endQuiz(HttpSession session, @PathVariable Integer id) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        quizService.endQuiz(id);
        return "redirect:/teacher/quiz/list";
    }

    // 查看测验详情
    @GetMapping("/detail/{id}")
    public String quizDetail(HttpSession session, @PathVariable Integer id, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        Quiz quiz = quizService.getQuizById(id);
        model.addAttribute("quiz", quiz);
        return "teacher/quiz/detail";
    }

    // 进入编辑测验页面
    @GetMapping("/edit/{id}")
    public String editQuizPage(HttpSession session, @PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        Quiz quiz = quizService.getQuizById(id);
        if (quiz == null) {
            redirectAttributes.addAttribute("errorMessage", "测验不存在或已被删除！");
            return "redirect:/teacher/quiz/list";
        }
        model.addAttribute("quiz", quiz);
        return "teacher/quiz/edit";
    }

    // 提交测验编辑
    @PostMapping("/edit")
    public String editQuiz(@ModelAttribute Quiz quiz, HttpSession session, RedirectAttributes redirectAttributes) {
        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                return "redirect:/user/login";
            }
            boolean success = quizService.updateQuiz(quiz);
            if (success) {
                redirectAttributes.addAttribute("successMessage", "测验编辑成功！");
            } else {
                redirectAttributes.addAttribute("errorMessage", "测验编辑失败，请重试！");
            }
        } catch (Exception e) {
            redirectAttributes.addAttribute("errorMessage", "编辑过程中发生错误：" + e.getMessage());
        }
        return "redirect:/teacher/quiz/list";
    }
    
    // 删除测验
    @GetMapping("/delete/{id}")
    public String deleteQuiz(HttpSession session, @PathVariable Integer id, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        try {
            boolean success = quizService.deleteQuiz(id);
            if (success) {
                redirectAttributes.addAttribute("successMessage", "测验删除成功！");
            } else {
                redirectAttributes.addAttribute("errorMessage", "测验删除失败，请重试！");
            }
        } catch (Exception e) {
            redirectAttributes.addAttribute("errorMessage", "删除过程中发生错误：" + e.getMessage());
        }
        return "redirect:/teacher/quiz/list";
    }
}
