package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.service.AttendanceService;
import com.example.demo.service.QuizAnswerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Controller
public class TeacherClassController {

    @Autowired
    private AttendanceService attendanceService;

    @Autowired
    private QuizAnswerService quizAnswerService;

    @GetMapping("/teacher/class")
    public String classDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        if (!"teacher".equals(user.getRole())) {
            return "redirect:/login";
        }

        Integer classId = user.getClassId();
        if (classId == null) {
            model.addAttribute("error", "您还未分配班级");
            return "teacher/class/dashboard";
        }

        LocalDate startDate = LocalDate.now().minusDays(30);
        LocalDate endDate = LocalDate.now();

        Map<String, Object> attendanceData = attendanceService.getClassAttendanceRate(classId, startDate, endDate);
        List<Map<String, Object>> knowledgeData = quizAnswerService.getClassKnowledgeMastery(classId);

        model.addAttribute("attendanceData", attendanceData);
        model.addAttribute("knowledgeData", knowledgeData);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);

        return "teacher/class/dashboard";
    }

    @GetMapping("/teacher/class/attendance")
    public String classAttendance(@RequestParam(required = false) String startDate,
                                 @RequestParam(required = false) String endDate,
                                 HttpSession session,
                                 Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        if (!"teacher".equals(user.getRole())) {
            return "redirect:/login";
        }

        Integer classId = user.getClassId();
        if (classId == null) {
            model.addAttribute("error", "您还未分配班级");
            return "teacher/class/attendance";
        }

        LocalDate start = startDate != null ? LocalDate.parse(startDate) : LocalDate.now().minusDays(30);
        LocalDate end = endDate != null ? LocalDate.parse(endDate) : LocalDate.now();

        Map<String, Object> attendanceData = attendanceService.getClassAttendanceRate(classId, start, end);

        model.addAttribute("attendanceData", attendanceData);
        model.addAttribute("startDate", start);
        model.addAttribute("endDate", end);

        return "teacher/class/attendance";
    }

    @GetMapping("/teacher/class/knowledge")
    public String classKnowledge(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        if (!"teacher".equals(user.getRole())) {
            return "redirect:/login";
        }

        Integer classId = user.getClassId();
        if (classId == null) {
            model.addAttribute("error", "您还未分配班级");
            return "teacher/class/knowledge";
        }

        List<Map<String, Object>> knowledgeData = quizAnswerService.getClassKnowledgeMastery(classId);

        model.addAttribute("knowledgeData", knowledgeData);

        return "teacher/class/knowledge";
    }
}
