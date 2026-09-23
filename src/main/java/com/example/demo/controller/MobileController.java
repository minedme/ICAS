package com.example.demo.controller;

import com.example.demo.model.*;
import com.example.demo.service.*;
import com.example.demo.util.QRCodeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/mobile")
public class MobileController {

    @Autowired
    private UserService userService;

    @Autowired
    private AttendanceService attendanceService;

    @Autowired
    private AttendanceRecordService recordService;

    @Autowired
    private QuizService quizService;

    @Autowired
    private QuizAnswerService answerService;

    @Autowired
    private BulletScreenService bulletScreenService;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // 用户登录
    @PostMapping("/login")
    public Map<String, Object> login(@RequestParam String username, @RequestParam String password, @RequestParam String role) {
        Map<String, Object> result = new HashMap<>();
        User user = userService.login(username, password, role);
        if (user != null) {
            result.put("code", 200);
            result.put("message", "登录成功");
            result.put("data", user);
        } else {
            result.put("code", 400);
            result.put("message", "用户名、密码或角色错误");
        }
        return result;
    }

    // 用户注册
    @PostMapping("/register")
    public Map<String, Object> register(@RequestParam String username, @RequestParam String password,
                                      @RequestParam String realName, @RequestParam String role,
                                      @RequestParam(required = false) String phone,
                                      @RequestParam(required = false) String email) {
        Map<String, Object> result = new HashMap<>();
        
        // 验证角色，只允许教师和学生注册
        if (!"教师".equals(role) && !"学生".equals(role)) {
            result.put("code", 400);
            result.put("message", "只能注册教师和学生账号");
            return result;
        }
        
        // 创建用户对象
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setRealName(realName);
        user.setRole(role);
        user.setPhone(phone);
        user.setEmail(email);
        
        boolean success = userService.register(user);
        if (success) {
            result.put("code", 200);
            result.put("message", "注册成功");
        } else {
            result.put("code", 400);
            result.put("message", "注册失败，用户名可能已存在");
        }
        return result;
    }

    // 扫码签到
    @PostMapping("/attendance/scan")
    public Map<String, Object> scanSign(@RequestParam String qrCode, @RequestParam Integer studentId) {
        Map<String, Object> result = new HashMap<>();

        // 根据二维码查询考勤任务
        Attendance attendance = attendanceService.getAttendanceByQrCode(qrCode);
        if (attendance == null) {
            result.put("code", 400);
            result.put("message", "考勤任务不存在");
            return result;
        }

        // 检查是否已签到
        if (recordService.isStudentSigned(attendance.getId(), studentId)) {
            result.put("code", 400);
            result.put("message", "您已签到");
            return result;
        }

        // 创建考勤记录
        AttendanceRecord record = new AttendanceRecord();
        record.setAttendanceId(attendance.getId());
        record.setStudentId(studentId);

        boolean success = recordService.scanSign(record);
        if (success) {
            result.put("code", 200);
            result.put("message", "签到成功");
        } else {
            result.put("code", 400);
            result.put("message", "签到失败");
        }
        return result;
    }

    // GPS定位签到
    @PostMapping("/attendance/gps")
    public Map<String, Object> gpsSign(@RequestParam Integer attendanceId, @RequestParam Double latitude, 
                                      @RequestParam Double longitude, @RequestParam Integer studentId) {
        Map<String, Object> result = new HashMap<>();

        // 检查是否已签到
        if (recordService.isStudentSigned(attendanceId, studentId)) {
            result.put("code", 400);
            result.put("message", "您已签到");
            return result;
        }

        // 创建考勤记录
        AttendanceRecord record = new AttendanceRecord();
        record.setAttendanceId(attendanceId);
        record.setStudentId(studentId);

        boolean success = recordService.gpsSign(record, latitude, longitude);
        if (success) {
            result.put("code", 200);
            result.put("message", "签到成功");
        } else {
            result.put("code", 400);
            result.put("message", "签到失败");
        }
        return result;
    }

    // 获取学生考勤记录
    @GetMapping("/student/attendance/records")
    public Map<String, Object> getStudentAttendanceRecords(@RequestParam Integer studentId) {
        Map<String, Object> result = new HashMap<>();
        List<AttendanceRecord> records = recordService.getRecordsByStudentId(studentId);
        result.put("code", 200);
        result.put("message", "查询成功");
        result.put("data", records);
        return result;
    }

    // 获取学生测验列表
    @GetMapping("/student/quiz/list")
    public Map<String, Object> getStudentQuizList(@RequestParam Integer studentId) {
        Map<String, Object> result = new HashMap<>();
        List<Quiz> quizzes = quizService.getAllQuizzes();
        result.put("code", 200);
        result.put("message", "查询成功");
        result.put("data", quizzes);
        return result;
    }

    // 获取测验详情
    @GetMapping("/student/quiz/detail")
    public Map<String, Object> getQuizDetail(@RequestParam Integer quizId) {
        Map<String, Object> result = new HashMap<>();
        Quiz quiz = quizService.getQuizById(quizId);
        List<QuizQuestion> questions = quizService.getQuestionsByQuizId(quizId);
        Map<String, Object> data = new HashMap<>();
        data.put("quiz", quiz);
        data.put("questions", questions);
        result.put("code", 200);
        result.put("message", "查询成功");
        result.put("data", data);
        return result;
    }

    // 提交测验答案
    @PostMapping("/student/quiz/submit")
    public Map<String, Object> submitQuizAnswer(@RequestBody Map<String, Object> request) {
        Map<String, Object> result = new HashMap<>();
        try {
            Integer quizId = (Integer) request.get("quizId");
            Integer studentId = (Integer) request.get("studentId");
            List<Map<String, Object>> answers = (List<Map<String, Object>>) request.get("answers");
            
            List<QuizAnswer> quizAnswers = new ArrayList<>();
            for (Map<String, Object> answerData : answers) {
                QuizAnswer answer = new QuizAnswer();
                answer.setQuizId(quizId);
                answer.setStudentId(studentId);
                answer.setQuestionId((Integer) answerData.get("questionId"));
                answer.setStudentAnswer(answerData.get("answer").toString());
                answer.setAnswerTime(new Date());
                quizAnswers.add(answer);
            }
            boolean success = answerService.submitAnswers(quizAnswers);
            if (success) {
                // 计算得分
                Integer score = answerService.getStudentScore(studentId, quizId);
                // 获取所有答案
                List<QuizAnswer> studentAnswers = answerService.getAnswersByStudentIdAndQuizId(studentId, quizId);
                // 计算正确率
                int correctCount = 0;
                for (QuizAnswer answer : studentAnswers) {
                    if (answer.getIsCorrect()) {
                        correctCount++;
                    }
                }
                double correctRate = studentAnswers.isEmpty() ? 0.0 : ((double) correctCount / studentAnswers.size()) * 100;
                
                Map<String, Object> data = new HashMap<>();
                data.put("score", score);
                data.put("correctRate", String.format("%.2f", correctRate));
                
                result.put("code", 200);
                result.put("message", "提交成功");
                result.put("data", data);
            } else {
                result.put("code", 400);
                result.put("message", "提交失败");
            }
        } catch (Exception e) {
            result.put("code", 500);
            result.put("message", "提交失败：" + e.getMessage());
        }
        return result;
    }

    // 发送弹幕
    @PostMapping("/student/bullet/send")
    public Map<String, Object> sendBulletScreen(@RequestParam Integer courseId, @RequestParam Integer studentId,
                                               @RequestParam String content) {
        Map<String, Object> result = new HashMap<>();
        BulletScreen bulletScreen = new BulletScreen();
        bulletScreen.setCourseId(courseId);
        bulletScreen.setSenderId(studentId);
        bulletScreen.setContent(content);
        bulletScreen.setSendTime(new Date());
        boolean success = bulletScreenService.sendBulletScreen(bulletScreen);
        if (success) {
            result.put("code", 200);
            result.put("message", "发送成功");
        } else {
            result.put("code", 400);
            result.put("message", "发送失败");
        }
        return result;
    }

    // 获取弹幕列表
    @GetMapping("/student/bullet/list")
    public Map<String, Object> getBulletScreenList(@RequestParam Integer courseId) {
        Map<String, Object> result = new HashMap<>();
        List<BulletScreen> bulletScreens = bulletScreenService.getAllBulletScreens(courseId);
        result.put("code", 200);
        result.put("message", "查询成功");
        result.put("data", bulletScreens);
        return result;
    }

    // 教师创建考勤
    @PostMapping("/teacher/attendance/create")
    public Map<String, Object> createAttendance(@RequestBody Map<String, Object> request) {
        Map<String, Object> result = new HashMap<>();
        try {
            Integer teacherId = (Integer) request.get("teacherId");
            String courseName = (String) request.get("courseName");
            String startTime = (String) request.get("startTime");
            String endTime = (String) request.get("endTime");
            String location = (String) request.get("location");
            Double latitude = request.get("latitude") != null ? Double.valueOf(request.get("latitude").toString()) : null;
            Double longitude = request.get("longitude") != null ? Double.valueOf(request.get("longitude").toString()) : null;
            Integer qrCodeExpiry = request.get("qrCodeExpiry") != null ? Integer.valueOf(request.get("qrCodeExpiry").toString()) : 300;
            Integer range = request.get("range") != null ? Integer.valueOf(request.get("range").toString()) : 50;

            try {
                jdbcTemplate.queryForObject("SELECT location FROM attendance LIMIT 1", String.class);
            } catch (Exception e) {
                try {
                    jdbcTemplate.execute("ALTER TABLE attendance ADD COLUMN location VARCHAR(200)");
                } catch (Exception ex) {
                    System.out.println("添加location字段失败: " + ex.getMessage());
                }
            }

            Attendance attendance = new Attendance();
            attendance.setTeacherId(teacherId);
            attendance.setCourseName(courseName);
            attendance.setStartTime(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").parse(startTime));
            attendance.setEndTime(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").parse(endTime));
            attendance.setLocation(location);
            
            if (latitude != null && longitude != null && range != null) {
                double rangeInDegrees = range / 111000.0;
                attendance.setMinLatitude(latitude - rangeInDegrees);
                attendance.setMaxLatitude(latitude + rangeInDegrees);
                attendance.setMinLongitude(longitude - rangeInDegrees);
                attendance.setMaxLongitude(longitude + rangeInDegrees);
            } else {
                attendance.setMinLatitude(0.0);
                attendance.setMaxLatitude(0.0);
                attendance.setMinLongitude(0.0);
                attendance.setMaxLongitude(0.0);
            }

            boolean success = attendanceService.createAttendance(attendance);
            if (success) {
                result.put("code", 200);
                result.put("message", "考勤创建成功");
                result.put("data", attendance);
            } else {
                result.put("code", 400);
                result.put("message", "考勤创建失败");
            }
        } catch (Exception e) {
            result.put("code", 500);
            result.put("message", "考勤创建失败：" + e.getMessage());
        }
        return result;
    }

    // 获取教师考勤列表
    @GetMapping("/teacher/attendance/list")
    public Map<String, Object> getTeacherAttendanceList(@RequestParam Integer teacherId) {
        Map<String, Object> result = new HashMap<>();
        List<Attendance> attendances = attendanceService.getAttendancesByTeacherId(teacherId);
        result.put("code", 200);
        result.put("message", "查询成功");
        result.put("data", attendances);
        return result;
    }

    // 获取考勤详情（包含二维码）
    @GetMapping("/teacher/attendance/detail")
    public Map<String, Object> getAttendanceDetail(@RequestParam Integer attendanceId) {
        Map<String, Object> result = new HashMap<>();
        Attendance attendance = attendanceService.getAttendanceById(attendanceId);
        List<AttendanceRecord> records = recordService.getRecordsByAttendanceId(attendanceId);
        Map<String, Object> data = new HashMap<>();
        data.put("attendance", attendance);
        data.put("records", records);
        result.put("code", 200);
        result.put("message", "查询成功");
        result.put("data", data);
        return result;
    }

    // 刷新二维码
    @PostMapping("/teacher/attendance/refresh")
    public Map<String, Object> refreshQrCode(@RequestParam Integer attendanceId) {
        Map<String, Object> result = new HashMap<>();
        boolean success = attendanceService.refreshQrCode(attendanceId);
        if (success) {
            Attendance attendance = attendanceService.getAttendanceById(attendanceId);
            result.put("code", 200);
            result.put("message", "二维码刷新成功");
            result.put("data", attendance.getQrCode());
        } else {
            result.put("code", 400);
            result.put("message", "二维码刷新失败");
        }
        return result;
    }

    // 生成二维码图片
    @GetMapping("/teacher/attendance/qrcode/image")
    public Map<String, Object> generateQrCodeImage(@RequestParam Integer attendanceId) {
        Map<String, Object> result = new HashMap<>();
        try {
            Attendance attendance = attendanceService.getAttendanceById(attendanceId);
            if (attendance == null) {
                result.put("code", 400);
                result.put("message", "考勤任务不存在");
                return result;
            }
            
            String qrCodeContent = attendance.getQrCode();
            byte[] qrCodeBytes = QRCodeUtil.generateQRCode(qrCodeContent, 300, 300, "PNG");
            String base64Image = Base64.getEncoder().encodeToString(qrCodeBytes);
            
            result.put("code", 200);
            result.put("message", "二维码生成成功");
            result.put("data", base64Image);
        } catch (Exception e) {
            result.put("code", 500);
            result.put("message", "二维码生成失败：" + e.getMessage());
        }
        return result;
    }
}