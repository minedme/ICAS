package com.example.demo.service;

import java.util.Map;
import java.util.List;

public interface DataAnalysisService {
    // 获取班级平均考勤率
    Double getClassAttendanceRate(Integer classId);

    // 获取班级测验平均分
    Double getClassAverageScore(Integer classId);

    // 获取连续缺勤2次及以上的学生列表
    List<Map<String, Object>> getAbsentWarningStudents();

    // 获取学生个人考勤率
    Double getStudentAttendanceRate(Integer studentId);

    // 获取学生个人测验平均分
    Double getStudentAverageScore(Integer studentId);

    // 获取班级签到人数分布
    Map<String, Integer> getClassSignInDistribution(Integer classId);

    // 获取考勤记录统计
    Map<String, Object> getAttendanceStatistics();

    // 获取测验成绩统计
    Map<String, Object> getScoreStatistics();
}