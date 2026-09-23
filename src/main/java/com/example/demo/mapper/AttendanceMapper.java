package com.example.demo.mapper;

import com.example.demo.model.Attendance;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface AttendanceMapper {
    // 创建考勤任务
    int insert(Attendance attendance);

    // 更新考勤任务
    int update(Attendance attendance);

    // 根据ID查询考勤任务
    Attendance selectById(Integer id);

    // 根据教师ID查询考勤任务
    List<Attendance> selectByTeacherId(Integer teacherId);

    // 查询所有考勤任务
    List<Attendance> selectAll();

    // 根据二维码查询考勤任务
    Attendance selectByQrCode(String qrCode);

    // 更新二维码
    int updateQrCode(@Param("id") Integer id, @Param("qrCode") String qrCode);
}