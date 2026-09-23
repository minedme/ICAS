package com.example.demo.controller;

import com.example.demo.model.AttendanceRecord;
import com.example.demo.model.QuizAnswer;
import com.example.demo.model.User;
import com.example.demo.service.AttendanceService;
import com.example.demo.service.QuizAnswerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Controller
public class StudentProfileController {

    @Autowired
    private AttendanceService attendanceService;

    @Autowired
    private QuizAnswerService quizAnswerService;

    @GetMapping("/student/profile")
    public String studentProfile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Integer studentId = user.getId();

        model.addAttribute("student", user);

        return "student/profile";
    }

    @GetMapping("/student/profile/attendance")
    public String attendanceTrend(@RequestParam(defaultValue = "daily") String period,
                                @RequestParam(required = false) String startDate,
                                @RequestParam(required = false) String endDate,
                                HttpSession session,
                                Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Integer studentId = user.getId();

        LocalDate start = startDate != null ? LocalDate.parse(startDate) : LocalDate.now().minusDays(30);
        LocalDate end = endDate != null ? LocalDate.parse(endDate) : LocalDate.now();

        List<Map<String, Object>> attendanceData = attendanceService.getAttendanceTrend(studentId, period, start, end);

        model.addAttribute("attendanceData", attendanceData);
        model.addAttribute("period", period);
        model.addAttribute("startDate", start);
        model.addAttribute("endDate", end);

        return "student/profile/attendance";
    }

    @GetMapping("/student/profile/grades")
    public String gradeTrend(@RequestParam(required = false) String course,
                             @RequestParam(required = false) String startDate,
                             @RequestParam(required = false) String endDate,
                             HttpSession session,
                             Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Integer studentId = user.getId();

        LocalDate start = startDate != null ? LocalDate.parse(startDate) : LocalDate.now().minusMonths(3);
        LocalDate end = endDate != null ? LocalDate.parse(endDate) : LocalDate.now();

        List<Map<String, Object>> gradeData = quizAnswerService.getGradeTrend(studentId, course, start, end);
        List<String> courses = quizAnswerService.getStudentCourses(studentId);

        model.addAttribute("gradeData", gradeData);
        model.addAttribute("courses", courses);
        model.addAttribute("selectedCourse", course);
        model.addAttribute("startDate", start);
        model.addAttribute("endDate", end);

        return "student/profile/grades";
    }

    @GetMapping("/api/student/stats/{studentId}")
    @ResponseBody
    public Map<String, Object> getStudentStats(@PathVariable Integer studentId) {
        Map<String, Object> stats = new HashMap<>();
        
        LocalDate now = LocalDate.now();
        LocalDate startDate = now.minusMonths(3);
        
        List<Map<String, Object>> attendanceData = attendanceService.getAttendanceTrend(studentId, "daily", startDate, now);
        int totalAttendance = attendanceData.stream().mapToInt(data -> (Integer) data.get("count")).sum();
        
        List<Map<String, Object>> gradeData = quizAnswerService.getGradeTrend(studentId, null, startDate, now);
        int totalQuizzes = gradeData.size();
        double averageGrade = gradeData.stream()
            .mapToDouble(data -> data.get("score") != null ? ((Number) data.get("score")).doubleValue() : 0.0)
            .average()
            .orElse(0.0);
        
        stats.put("totalAttendance", totalAttendance);
        stats.put("totalQuizzes", totalQuizzes);
        stats.put("averageGrade", averageGrade);
        
        return stats;
    }
}
