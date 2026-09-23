package com.example.demo.service;

import com.example.demo.model.Attendance;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public interface AttendanceService {
    // 创建考勤任务
    boolean createAttendance(Attendance attendance);

    // 更新考勤任务
    boolean updateAttendance(Attendance attendance);

    // 刷新二维码
    boolean refreshQrCode(Integer attendanceId);

    // 根据ID查询考勤任务
    Attendance getAttendanceById(Integer id);

    // 根据教师ID查询考勤任务
    List<Attendance> getAttendancesByTeacherId(Integer teacherId);

    // 查询所有考勤任务
    List<Attendance> getAllAttendances();

    // 根据二维码查询考勤任务
    Attendance getAttendanceByQrCode(String qrCode);

    // 获取学生出勤趋势
    List<Map<String, Object>> getAttendanceTrend(Integer studentId, String period, LocalDate startDate, LocalDate endDate);

    // 获取班级出勤率统计
    Map<String, Object> getClassAttendanceRate(Integer classId, LocalDate startDate, LocalDate endDate);
}