package com.example.demo.controller;

import com.example.demo.model.AttendanceSetting;
import com.example.demo.model.User;
import com.example.demo.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
@RequestMapping("/teacher")
public class TeacherController {

    @Autowired
    private CourseService courseService;

    @Autowired
    private QuizService quizService;

    @Autowired
    private AttendanceRecordService attendanceRecordService;

    @Autowired
    private DataAnalysisService dataAnalysisService;

    @Autowired
    private AttendanceSettingService attendanceSettingService;

    // 教师首页
    @GetMapping("/index")
    public String index(Model model, HttpSession session) {
        return dashboard(model, session);
    }

    // 教师控制面板
    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        // 获取统计数据
        Map<String, Object> stats = new HashMap<>();

        // 课程数量
        int courseCount = courseService.findAll().size();
        stats.put("courseCount", courseCount);

        // 测验数量
        int quizCount = quizService.getQuizzesByTeacherId(user.getId()).size();
        stats.put("quizCount", quizCount);

        // 本月考勤次数
        int monthlyAttendance = 0;
        List<com.example.demo.model.AttendanceRecord> allRecords = attendanceRecordService.getAllRecords();
        Calendar cal = Calendar.getInstance();
        int currentMonth = cal.get(Calendar.MONTH) + 1;
        int currentYear = cal.get(Calendar.YEAR);

        for (com.example.demo.model.AttendanceRecord record : allRecords) {
            if (record.getAttendanceTime() != null) {
                Calendar recordCal = Calendar.getInstance();
                recordCal.setTime(record.getAttendanceTime());
                if (recordCal.get(Calendar.MONTH) + 1 == currentMonth && recordCal.get(Calendar.YEAR) == currentYear) {
                    monthlyAttendance++;
                }
            }
        }
        stats.put("attendanceCount", monthlyAttendance);

        // 今日签到率 - 暂时设为0
        stats.put("todayAttendanceRate", 0);

        // 待处理预警 - 暂时设为0
        stats.put("warningCount", 0);

        model.addAttribute("stats", stats);
        return "teacher/dashboard";
    }
    
    // 数据分析页面
    @GetMapping("/analysis")
    public String analysis(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        // 添加用户信息
        model.addAttribute("user", user);
        
        // 获取考勤统计数据
        Map<String, Object> attendanceStats = dataAnalysisService.getAttendanceStatistics();
        model.addAttribute("attendanceStats", attendanceStats);
        
        // 获取测验成绩统计
        Map<String, Object> scoreStats = dataAnalysisService.getScoreStatistics();
        model.addAttribute("scoreStats", scoreStats);
        
        // 获取班级签到分布 (暂时使用1作为默认班级ID)
        Map<String, Integer> classSignInDistribution = dataAnalysisService.getClassSignInDistribution(1);
        model.addAttribute("classSignInDistribution", classSignInDistribution);
        
        // 获取缺勤警告学生列表
        List<Map<String, Object>> absentWarningStudents = dataAnalysisService.getAbsentWarningStudents();
        model.addAttribute("absentWarningStudents", absentWarningStudents);
        
        return "teacher/analysis";
    }
    
    // 获取教师统计数据API
    @GetMapping("/stats")
    @ResponseBody
    public Map<String, Object> stats(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return new HashMap<>();
        }
        
        Map<String, Object> stats = new HashMap<>();
        
        // 课程数量
        int courseCount = courseService.findAll().size();
        stats.put("courseCount", courseCount);
        
        // 测验数量
        int quizCount = quizService.getQuizzesByTeacherId(user.getId()).size();
        stats.put("quizCount", quizCount);
        
        // 本月考勤次数
        int monthlyAttendance = 0;
        List<com.example.demo.model.AttendanceRecord> allRecords = attendanceRecordService.getAllRecords();
        Calendar cal = Calendar.getInstance();
        int currentMonth = cal.get(Calendar.MONTH) + 1;
        int currentYear = cal.get(Calendar.YEAR);
        
        for (com.example.demo.model.AttendanceRecord record : allRecords) {
            if (record.getAttendanceTime() != null) {
                Calendar recordCal = Calendar.getInstance();
                recordCal.setTime(record.getAttendanceTime());
                if (recordCal.get(Calendar.MONTH) + 1 == currentMonth && recordCal.get(Calendar.YEAR) == currentYear) {
                    monthlyAttendance++;
                }
            }
        }
        stats.put("attendanceCount", monthlyAttendance);
        
        // 今日签到率
        stats.put("todayAttendanceRate", 0);
        
        // 待处理预警
        List<Map<String, Object>> warningStudents = dataAnalysisService.getAbsentWarningStudents();
        stats.put("warningCount", warningStudents.size());
        
        // 学生人数
        int studentCount = 0;
        // 这里需要根据教师的课程获取对应的学生人数
        stats.put("studentCount", studentCount);
        
        return stats;
    }

    // 获取教师考勤设置API
    @GetMapping("/attendance-setting")
    @ResponseBody
    public AttendanceSetting getAttendanceSetting(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return null;
        }
        
        AttendanceSetting setting = attendanceSettingService.getSettingByTeacherId(user.getId());
        if (setting == null) {
            // 如果没有设置，返回默认设置
            setting = new AttendanceSetting();
            setting.setTeacherId(user.getId());
            setting.setLatitude(0.0);
            setting.setLongitude(0.0);
            setting.setRadius(50.0);
            setting.setDuration(30);
            setting.setEarlySignMinutes(5);
            setting.setLateSignMinutes(10);
            setting.setEnableLocation(false);
            setting.setEnableFaceRecognition(false);
            attendanceSettingService.saveSetting(setting);
        }
        
        return setting;
    }
}

