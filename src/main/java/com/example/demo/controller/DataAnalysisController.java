package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.service.DataAnalysisService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/analysis")
public class DataAnalysisController {

    @Autowired
    private DataAnalysisService dataAnalysisService;

    // 管理员查看数据分析首页
    @GetMapping("/admin/index")
    public String adminIndex(Model model) {
        // 获取考勤统计
        Map<String, Object> attendanceStats = dataAnalysisService.getAttendanceStatistics();
        model.addAttribute("attendanceStats", attendanceStats);
        
        // 获取成绩统计
        Map<String, Object> scoreStats = dataAnalysisService.getScoreStatistics();
        model.addAttribute("scoreStats", scoreStats);
        
        // 获取缺勤预警学生
        List<Map<String, Object>> warningStudents = dataAnalysisService.getAbsentWarningStudents();
        model.addAttribute("warningStudents", warningStudents);
        
        return "admin/analysis/index";
    }

    // 教师查看班级数据分析
    @GetMapping("/teacher/class")
    public String teacherClassAnalysis(@RequestParam Integer classId, Model model) {
        // 获取班级平均考勤率
        Double attendanceRate = dataAnalysisService.getClassAttendanceRate(classId);
        model.addAttribute("attendanceRate", attendanceRate);
        
        // 获取班级平均分
        Double averageScore = dataAnalysisService.getClassAverageScore(classId);
        model.addAttribute("averageScore", averageScore);
        
        // 获取班级签到人数分布
        Map<String, Integer> signInDistribution = dataAnalysisService.getClassSignInDistribution(classId);
        model.addAttribute("signInDistribution", signInDistribution);
        
        return "teacher/analysis/class";
    }

    // 学生查看个人数据分析
    @GetMapping("/student/personal")
    public String studentPersonalAnalysis(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        Integer studentId = user.getId();
        
        // 获取个人考勤率
        Double attendanceRate = dataAnalysisService.getStudentAttendanceRate(studentId);
        model.addAttribute("attendanceRate", attendanceRate);
        
        // 获取个人平均分
        Double averageScore = dataAnalysisService.getStudentAverageScore(studentId);
        model.addAttribute("averageScore", averageScore);
        
        return "student/analysis/personal";
    }

    // 获取缺勤预警学生列表（API）
    @GetMapping("/api/absent-warning")
    @ResponseBody
    public List<Map<String, Object>> getAbsentWarningStudentsApi() {
        return dataAnalysisService.getAbsentWarningStudents();
    }

    // 获取班级考勤率（API）
    @GetMapping("/api/class-attendance-rate/{classId}")
    @ResponseBody
    public Double getClassAttendanceRateApi(@PathVariable Integer classId) {
        return dataAnalysisService.getClassAttendanceRate(classId);
    }

    // 获取班级平均分（API）
    @GetMapping("/api/class-average-score/{classId}")
    @ResponseBody
    public Double getClassAverageScoreApi(@PathVariable Integer classId) {
        return dataAnalysisService.getClassAverageScore(classId);
    }
}