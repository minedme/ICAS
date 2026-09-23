package com.example.demo.mapper;

import com.example.demo.model.AttendanceRecord;
import org.apache.ibatis.annotations.Param;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public interface AttendanceRecordMapper {
    // 插入考勤记录
    int insert(AttendanceRecord record);

    // 根据考勤任务ID查询记录
    List<AttendanceRecord> selectByAttendanceId(Integer attendanceId);

    // 根据学生ID查询记录
    List<AttendanceRecord> selectByStudentId(Integer studentId);

    // 根据学生ID和日期范围查询记录
    List<AttendanceRecord> selectByStudentIdAndDateRange(@Param("studentId") Integer studentId, 
                                                        @Param("startDate") Timestamp startDate, 
                                                        @Param("endDate") Timestamp endDate);

    // 根据班级ID和日期范围查询记录
    List<AttendanceRecord> selectByClassIdAndDateRange(@Param("classId") Integer classId,
                                                     @Param("startDate") Timestamp startDate,
                                                     @Param("endDate") Timestamp endDate);

    // 根据考勤任务ID和学生ID查询记录
    AttendanceRecord selectByAttendanceIdAndStudentId(@Param("attendanceId") Integer attendanceId, @Param("studentId") Integer studentId);

    // 查询所有考勤记录
    List<AttendanceRecord> selectAll();

    // 根据状态查询考勤记录
    List<AttendanceRecord> selectByStatus(String status);
}