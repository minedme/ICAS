package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.example.demo.model.Quiz;
import com.example.demo.service.QuizAnswerService;

import javax.servlet.http.HttpSession;
import com.example.demo.model.User;
import com.example.demo.model.AttendanceRecord;
import com.example.demo.service.DataAnalysisService;
import com.example.demo.service.AttendanceRecordService;
import com.example.demo.service.QuizService;
import com.example.demo.service.ClassService;
import com.example.demo.model.ClassInfo;
import com.example.demo.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.Calendar;
import java.util.Date;

@Controller
@RequestMapping("/student")
public class StudentController {

    @Autowired
    private AttendanceRecordService attendanceRecordService;
    
    @Autowired
    private QuizService quizService;
    
    @Autowired
    private QuizAnswerService quizAnswerService;

    @Autowired
    private ClassService classService;

    @Autowired
    private UserMapper userMapper;

    // 学生首页
    @GetMapping("/index")
    public String index(Model model, HttpSession session) {
        // 从session中获取当前用户
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        // 重新从数据库获取用户信息，确保获取最新的班级信息
        User updatedUser = getUserById(user.getId());
        if (updatedUser != null) {
            session.setAttribute("user", updatedUser);
            user = updatedUser;
        }
        
        // 添加用户信息到模型
        model.addAttribute("user", user);
        
        // 如果用户有班级，获取班级信息
        if (user.getClassId() != null) {
            ClassInfo classInfo = classService.getClassById(user.getClassId());
            model.addAttribute("classInfo", classInfo);
        }
        
        // 获取真实统计数据
        Map<String, Object> stats = calculateStats(user.getId());
        model.addAttribute("stats", stats);
        
        // 创建模拟活动记录
        java.util.List<java.util.Map<String, String>> recentActivities = new java.util.ArrayList<>();
        java.util.Map<String, String> activity1 = new java.util.HashMap<>();
        activity1.put("content", "完成了数学测验，得分88");
        activity1.put("time", "2025-12-27 14:30");
        recentActivities.add(activity1);
        
        java.util.Map<String, String> activity2 = new java.util.HashMap<>();
        activity2.put("content", "参加了物理课考勤签到");
        activity2.put("time", "2025-12-26 09:00");
        recentActivities.add(activity2);
        
        java.util.Map<String, String> activity3 = new java.util.HashMap<>();
        activity3.put("content", "提交了英语作业");
        activity3.put("time", "2025-12-25 16:45");
        recentActivities.add(activity3);
        
        model.addAttribute("recentActivities", recentActivities);
        
        return "student/dashboard";
    }

    // 学生控制面板
    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        return index(model, session);
    }
    
    // 从数据库获取用户信息
    private User getUserById(Integer userId) {
        return userMapper.selectById(userId);
    }
    
    // 获取学生统计数据API
    @GetMapping("/stats")
    @ResponseBody
    public Map<String, Object> stats(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return new HashMap<>();
        }
        
        // 获取真实统计数据
        return calculateStats(user.getId());
    }
    
    // 计算学生统计数据
    private Map<String, Object> calculateStats(Integer studentId) {
        Map<String, Object> stats = new HashMap<>();
        
        // 获取学生所有考勤记录
        List<AttendanceRecord> attendanceRecords = attendanceRecordService.getRecordsByStudentId(studentId);
        
        // 计算出勤率
        int totalAttendance = attendanceRecords.size();
        int normalAttendance = 0;
        int lateAttendance = 0;
        int absentAttendance = 0;
        
        // 计算本月考勤统计
        int monthlyNormal = 0;
        int monthlyLate = 0;
        int monthlyAbsent = 0;
        
        // 获取当前月份
        Calendar calendar = Calendar.getInstance();
        int currentMonth = calendar.get(Calendar.MONTH);
        int currentYear = calendar.get(Calendar.YEAR);
        
        for (AttendanceRecord record : attendanceRecords) {
            if (record.getStatus() != null) {
                if ("正常".equals(record.getStatus())) {
                    normalAttendance++;
                } else if ("迟到".equals(record.getStatus())) {
                    lateAttendance++;
                } else if ("缺勤".equals(record.getStatus())) {
                    absentAttendance++;
                }
                
                // 检查是否为本月记录
                if (record.getAttendanceTime() != null) {
                    calendar.setTime(record.getAttendanceTime());
                    int recordMonth = calendar.get(Calendar.MONTH);
                    int recordYear = calendar.get(Calendar.YEAR);
                    
                    if (recordMonth == currentMonth && recordYear == currentYear) {
                        if ("正常".equals(record.getStatus())) {
                            monthlyNormal++;
                        } else if ("迟到".equals(record.getStatus())) {
                            monthlyLate++;
                        } else if ("缺勤".equals(record.getStatus())) {
                            monthlyAbsent++;
                        }
                    }
                }
            }
        }
        
        // 计算出勤率（避免除以零）
        int attendanceRate = totalAttendance > 0 ? (int) ((double) normalAttendance / totalAttendance * 100) : 0;
        
        // 计算本月考勤总次数
        int monthlyTotal = monthlyNormal + monthlyLate + monthlyAbsent;
        
        // 计算测验统计数据
        List<Quiz> allQuizzes = quizService.getAllQuizzes();
        int completedQuizzes = 0;
        int totalScore = 0;
        
        for (Quiz quiz : allQuizzes) {
            Integer score = quizAnswerService.getStudentScore(studentId, quiz.getId());
            if (score != null) {
                completedQuizzes++;
                totalScore += score;
            }
        }
        
        // 计算平均成绩（避免除以零）
        int averageScore = completedQuizzes > 0 ? totalScore / completedQuizzes : 0;
        
        // 填充统计数据
        stats.put("attendanceRate", attendanceRate);
        stats.put("averageScore", averageScore);
        stats.put("completedQuizzes", completedQuizzes);
        stats.put("monthlyAttendance", monthlyNormal);
        stats.put("monthlyAbsent", monthlyAbsent);
        stats.put("monthlyLate", monthlyLate);
        stats.put("totalAttendance", totalAttendance);
        stats.put("monthlyTotal", monthlyTotal);
        
        return stats;
    }
}
