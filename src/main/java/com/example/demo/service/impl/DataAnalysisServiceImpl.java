package com.example.demo.service.impl;

import com.example.demo.mapper.AttendanceMapper;
import com.example.demo.mapper.AttendanceRecordMapper;
import com.example.demo.mapper.QuizAnswerMapper;
import com.example.demo.mapper.UserMapper;
import com.example.demo.model.Attendance;
import com.example.demo.model.AttendanceRecord;
import com.example.demo.model.QuizAnswer;
import com.example.demo.model.User;
import com.example.demo.service.DataAnalysisService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class DataAnalysisServiceImpl implements DataAnalysisService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private AttendanceMapper attendanceMapper;

    @Autowired
    private AttendanceRecordMapper attendanceRecordMapper;

    @Autowired
    private QuizAnswerMapper quizAnswerMapper;

    @Override
    public Double getClassAttendanceRate(Integer classId) {
        // 获取班级学生数量
        List<User> students = userMapper.selectByRole("student");
        int studentCount = students.size();
        
        // 获取总考勤次数
        int totalAttendanceCount = attendanceMapper.selectAll().size();
        
        // 获取实际出勤人数总和
        List<AttendanceRecord> records = attendanceRecordMapper.selectAll();
        int attendanceSum = 0;
        for (AttendanceRecord record : records) {
            if (record.getStatus() != null && record.getStatus().equals("正常")) {
                attendanceSum++;
            }
        }
        
        // 计算平均考勤率
        if (studentCount == 0 || totalAttendanceCount == 0) {
            return 0.0;
        }
        
        double totalPossibleAttendance = studentCount * totalAttendanceCount;
        return attendanceSum / totalPossibleAttendance;
    }

    @Override
    public Double getClassAverageScore(Integer classId) {
        // 获取所有学生的测验得分
        List<QuizAnswer> answers = quizAnswerMapper.selectAll();
        
        if (answers == null || answers.isEmpty()) {
            return 0.0;
        }
        
        // 计算总分和学生人数
        double totalScore = 0;
        Set<Integer> studentIds = new HashSet<>();
        
        for (QuizAnswer answer : answers) {
            Integer studentId = answer.getStudentId();
            Integer score = answer.getScore();
            
            studentIds.add(studentId);
            if (score != null) {
                totalScore += score;
            }
        }
        
        if (studentIds.isEmpty()) {
            return 0.0;
        }
        
        return totalScore / studentIds.size();
    }

    @Override
    public List<Map<String, Object>> getAbsentWarningStudents() {
        List<Map<String, Object>> warningStudents = new ArrayList<>();
        
        // 获取所有学生
        List<User> students = userMapper.selectByRole("student");
        
        for (User student : students) {
            // 获取该学生的考勤记录
            List<AttendanceRecord> records = attendanceRecordMapper.selectByStudentId(student.getId());
            
            // 计算总考勤次数和缺勤次数
            int totalAttendance = records.size();
            int absentCount = 0;
            int consecutiveAbsent = 0;
            
            for (AttendanceRecord record : records) {
                if (record.getStatus() != null && record.getStatus().equals("缺勤")) {
                    absentCount++;
                    consecutiveAbsent++;
                } else {
                    consecutiveAbsent = 0;
                }
            }
            
            // 计算出勤率
            double attendanceRate = totalAttendance > 0 ? (double) (totalAttendance - absentCount) / totalAttendance * 100 : 100;
            
            // 如果缺勤次数大于等于2次，添加到预警列表
            if (absentCount >= 2) {
                Map<String, Object> warning = new HashMap<>();
                warning.put("studentId", student.getId());
                warning.put("studentName", student.getRealName());
                warning.put("className", "待分配"); // 暂时使用默认值
                warning.put("absentCount", absentCount);
                warning.put("attendanceRate", Math.round(attendanceRate));
                warning.put("warningLevel", absentCount >= 3 ? "严重" : "警告");
                warningStudents.add(warning);
            }
        }
        
        return warningStudents;
    }

    @Override
    public Double getStudentAttendanceRate(Integer studentId) {
        // 获取该学生的所有考勤记录
        List<AttendanceRecord> records = attendanceRecordMapper.selectByStudentId(studentId);
        
        if (records == null || records.isEmpty()) {
            return 0.0;
        }
        
        // 计算出勤次数
        int attendanceCount = 0;
        for (AttendanceRecord record : records) {
            if (record.getStatus() != null && record.getStatus().equals("正常")) {
                attendanceCount++;
            }
        }
        
        return (double) attendanceCount / records.size();
    }

    @Override
    public Double getStudentAverageScore(Integer studentId) {
        // 获取该学生的所有测验得分
        List<QuizAnswer> answers = quizAnswerMapper.selectByStudentId(studentId);
        
        if (answers == null || answers.isEmpty()) {
            return 0.0;
        }
        
        // 计算总分和测验次数
        double totalScore = 0;
        int quizCount = 0;
        
        for (QuizAnswer answer : answers) {
            Integer score = answer.getScore();
            if (score != null) {
                totalScore += score;
                quizCount++;
            }
        }
        
        if (quizCount == 0) {
            return 0.0;
        }
        
        return totalScore / quizCount;
    }

    @Override
    public Map<String, Integer> getClassSignInDistribution(Integer classId) {
        Map<String, Integer> distribution = new HashMap<>();
        
        // 获取所有考勤任务
        List<Attendance> attendances = attendanceMapper.selectAll();
        
        for (Attendance attendance : attendances) {
            Integer attendanceId = attendance.getId();
            String courseName = attendance.getCourseName();
            
            // 获取该考勤任务的签到记录
            List<AttendanceRecord> records = attendanceRecordMapper.selectByAttendanceId(attendanceId);
            
            // 计算签到人数
            int signInCount = 0;
            for (AttendanceRecord record : records) {
                if (record.getStatus() != null && record.getStatus().equals("正常")) {
                    signInCount++;
                }
            }
            
            distribution.put(courseName, signInCount);
        }
        
        return distribution;
    }

    @Override
    public Map<String, Object> getAttendanceStatistics() {
        Map<String, Object> statistics = new HashMap<>();
        
        // 获取所有考勤记录
        List<AttendanceRecord> records = attendanceRecordMapper.selectAll();
        
        // 计算总记录数
        int totalSignIns = records.size();
        statistics.put("totalSignIns", totalSignIns);
        
        // 计算各状态数量
        int normalCount = 0;
        int absentCount = 0;
        int lateCount = 0;
        
        for (AttendanceRecord record : records) {
            if (record.getStatus() != null) {
                switch (record.getStatus()) {
                    case "正常":
                        normalCount++;
                        break;
                    case "缺勤":
                        absentCount++;
                        break;
                    case "迟到":
                        lateCount++;
                        break;
                }
            }
        }
        
        statistics.put("normalCount", normalCount);
        statistics.put("absentCount", absentCount);
        statistics.put("lateCount", lateCount);
        
        // 计算平均考勤率（百分比）
        double averageAttendanceRate = totalSignIns > 0 ? (double) normalCount / totalSignIns * 100 : 0.0;
        statistics.put("averageAttendanceRate", Math.round(averageAttendanceRate));
        
        return statistics;
    }

    @Override
    public Map<String, Object> getScoreStatistics() {
        Map<String, Object> statistics = new HashMap<>();
        
        // 获取所有测验得分
        List<QuizAnswer> answers = quizAnswerMapper.selectAll();
        
        if (answers == null || answers.isEmpty()) {
            statistics.put("totalQuizzes", 0);
            statistics.put("averageScore", Math.round(0.0));
            return statistics;
        }
        
        // 计算总分、最高分、最低分
        double totalScore = 0;
        int validScoreCount = 0;
        Set<Integer> quizIds = new HashSet<>();
        
        for (QuizAnswer answer : answers) {
            Integer score = answer.getScore();
            if (score != null) {
                totalScore += score;
                validScoreCount++;
            }
            quizIds.add(answer.getQuizId());
        }
        
        // 计算总测试次数
        int totalQuizzes = quizIds.size();
        
        // 计算平均分
        double averageScore = validScoreCount > 0 ? totalScore / validScoreCount : 0.0;
        
        statistics.put("totalQuizzes", totalQuizzes);
        statistics.put("averageScore", Math.round(averageScore));
        
        return statistics;
    }
}