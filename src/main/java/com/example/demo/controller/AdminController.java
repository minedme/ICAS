package com.example.demo.controller;

import com.example.demo.mapper.AttendanceRecordMapper;
import com.example.demo.mapper.CourseMapper;
import com.example.demo.mapper.UserMapper;
import com.example.demo.model.AttendanceRecord;
import com.example.demo.service.DataAnalysisService;
import com.example.demo.service.QuizService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private DataAnalysisService dataAnalysisService;
    
    @Autowired
    private UserMapper userMapper;
    
    @Autowired
    private CourseMapper courseMapper;
    
    @Autowired
    private AttendanceRecordMapper attendanceRecordMapper;
    
    @Autowired
    private QuizService quizService;

    // 管理员首页
    @GetMapping("/index")
    public String index(Model model, HttpSession session) {
        return "admin/dashboard";
    }

    // 管理员控制面板
    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        // 添加统计数据到Model中，确保页面初始加载时有数据显示
        model.addAttribute("stats", stats());
        return "admin/dashboard";
    }

    // 系统分析页面
    @GetMapping("/analysis")
    public String analysis(Model model) {
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
    
    // 获取统计数据API
    @GetMapping("/stats")
    @ResponseBody
    public Map<String, Object> stats() {
        Map<String, Object> stats = new HashMap<>();
        
        // 获取总用户数
        int totalUsers = userMapper.selectAll().size();
        stats.put("totalUsers", totalUsers);
        
        // 获取学生数
        int studentCount = userMapper.selectByRole("student").size();
        stats.put("studentCount", studentCount);
        
        // 获取教师数
        int teacherCount = userMapper.selectByRole("teacher").size();
        stats.put("teacherCount", teacherCount);
        
        // 获取课程总数
        int courseCount = courseMapper.selectAll().size();
        stats.put("courseCount", courseCount);
        
        // 获取测验总数
        int totalQuizzes = quizService.getAllQuizzes().size();
        stats.put("totalQuizzes", totalQuizzes);
        
        // 获取本月考勤数据（本月考勤记录数）
        List<AttendanceRecord> allRecords = attendanceRecordMapper.selectAll();
        int monthlyAttendance = 0;
        Calendar cal = Calendar.getInstance();
        int currentMonth = cal.get(Calendar.MONTH) + 1;
        int currentYear = cal.get(Calendar.YEAR);
        
        for (AttendanceRecord record : allRecords) {
            if (record.getAttendanceTime() != null) {
                Calendar recordCal = Calendar.getInstance();
                recordCal.setTime(record.getAttendanceTime());
                if (recordCal.get(Calendar.MONTH) + 1 == currentMonth && recordCal.get(Calendar.YEAR) == currentYear) {
                    monthlyAttendance++;
                }
            }
        }
        
        stats.put("monthlyAttendance", monthlyAttendance);
        
        // 获取平均出勤率
        Map<String, Object> attendanceStats = dataAnalysisService.getAttendanceStatistics();
        stats.put("avgAttendanceRate", attendanceStats.get("averageAttendanceRate"));
        
        // 获取平均测验得分
        Map<String, Object> scoreStats = dataAnalysisService.getScoreStatistics();
        stats.put("avgQuizScore", scoreStats.get("averageScore"));
        
        // 获取活跃课程数（有考勤记录的课程）
        stats.put("activeCourses", courseCount);
        
        // 获取待处理预警（缺勤2次及以上的学生）
        List<Map<String, Object>> warningStudents = dataAnalysisService.getAbsentWarningStudents();
        stats.put("pendingWarnings", warningStudents.size());
        
        return stats;
    }
}
