package com.example.demo.service;

import com.example.demo.model.AttendanceRecord;

import java.util.List;

public interface AttendanceRecordService {
    // 扫码签到
    boolean scanSign(AttendanceRecord record);
    // GPS签到
    boolean gpsSign(AttendanceRecord record, double latitude, double longitude);
    // 根据考勤ID获取记录
    List<AttendanceRecord> getRecordsByAttendanceId(Integer attendanceId);
    // 根据学生ID获取记录
    List<AttendanceRecord> getRecordsByStudentId(Integer studentId);
    // 根据学生ID和考勤任务ID获取记录
    List<AttendanceRecord> getRecordsByStudentIdAndAttendanceId(Integer studentId, Integer attendanceId);
    // 根据学生ID和考勤任务ID获取单个记录
    AttendanceRecord getRecordByStudentIdAndAttendanceId(Integer studentId, Integer attendanceId);
    // 获取所有记录
    List<AttendanceRecord> getAllRecords();
    // 检查学生是否已签到
    boolean isStudentSigned(Integer attendanceId, Integer studentId);
}