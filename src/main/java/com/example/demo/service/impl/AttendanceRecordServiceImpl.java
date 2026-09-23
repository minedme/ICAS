package com.example.demo.service.impl;

import com.example.demo.mapper.AttendanceMapper;
import com.example.demo.mapper.AttendanceRecordMapper;
import com.example.demo.model.Attendance;
import com.example.demo.model.AttendanceRecord;
import com.example.demo.service.AttendanceRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.ArrayList;

@Service
public class AttendanceRecordServiceImpl implements AttendanceRecordService {

    @Autowired
    private AttendanceRecordMapper recordMapper;

    @Autowired
    private AttendanceMapper attendanceMapper;

    @Value("${file.storage.path}")
    private String fileStoragePath;

    @Override
    public boolean scanSign(AttendanceRecord record) {
        // 查询考勤任务
        Attendance attendance = attendanceMapper.selectById(record.getAttendanceId());
        if (attendance == null) {
            return false;
        }

        // 检查签到时间
        Date now = new Date();
        if (now.before(attendance.getStartTime()) || now.after(attendance.getEndTime())) {
            record.setStatus("迟到"); // 迟到
        } else {
            record.setStatus("正常"); // 正常出勤
        }

        record.setAttendanceTime(now);
        record.setAttendanceType("扫码签到");
        
        // 设置签到截图文件路径
        String screenshotPath = fileStoragePath + "\\screenshot_" + System.currentTimeMillis() + "_" + record.getStudentId() + ".png";
        record.setFilePath(screenshotPath);
        
        return recordMapper.insert(record) > 0;
    }

    @Override
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        public boolean gpsSign(AttendanceRecord record, double latitude, double longitude) {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            // 查询考勤任务
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            Attendance attendance = attendanceMapper.selectById(record.getAttendanceId());
        if (attendance == null) {
            return false;
        }

        // 检查GPS位置是否在范围内
        if (latitude < attendance.getMinLatitude() || latitude > attendance.getMaxLatitude() ||
            longitude < attendance.getMinLongitude() || longitude > attendance.getMaxLongitude()) {
            record.setStatus("缺勤"); // 缺勤（位置异常）
        } else {
            // 检查签到时间
            Date now = new Date();
            if (now.before(attendance.getStartTime()) || now.after(attendance.getEndTime())) {
                record.setStatus("迟到"); // 迟到
            } else {
                record.setStatus("正常"); // 正常出勤
            }
        }

        record.setLatitude(latitude);
        record.setLongitude(longitude);
        record.setAttendanceTime(new Date());
        record.setAttendanceType("GPS签到");
        
        // 设置签到截图文件路径
        String screenshotPath = fileStoragePath + "\\screenshot_" + System.currentTimeMillis() + "_" + record.getStudentId() + ".png";
        record.setFilePath(screenshotPath);
        
        return recordMapper.insert(record) > 0;
    }

    @Override
    public List<AttendanceRecord> getRecordsByAttendanceId(Integer attendanceId) {
        return recordMapper.selectByAttendanceId(attendanceId);
    }

    @Override
    public List<AttendanceRecord> getRecordsByStudentId(Integer studentId) {
        List<AttendanceRecord> records = recordMapper.selectByStudentId(studentId);
        // 为每个记录补充课程信息和考勤时间
        for (AttendanceRecord record : records) {
            Attendance attendance = attendanceMapper.selectById(record.getAttendanceId());
            if (attendance != null) {
                // 设置课程名称
                record.setCourseName(attendance.getCourseName());
                // 设置考勤日期
                record.setAttendanceDate(attendance.getStartTime());
                // 设置签到时间
                record.setSignTime(record.getAttendanceTime());
                // 确保状态是整数类型
                if (record.getStatus() == null) {
                    // 默认设置为缺勤
                    record.setStatus("缺勤");
                }
            }
        }
        return records;
    }
    
    @Override
    public List<AttendanceRecord> getRecordsByStudentIdAndAttendanceId(Integer studentId, Integer attendanceId) {
        List<AttendanceRecord> records = new ArrayList<>();
        AttendanceRecord record = recordMapper.selectByAttendanceIdAndStudentId(attendanceId, studentId);
        if (record != null) {
            // 为记录补充课程信息和考勤时间
            Attendance attendance = attendanceMapper.selectById(record.getAttendanceId());
            if (attendance != null) {
                // 设置课程名称
                record.setCourseName(attendance.getCourseName());
                // 设置考勤日期
                record.setAttendanceDate(attendance.getStartTime());
                // 设置签到时间
                record.setSignTime(record.getAttendanceTime());
                // 确保状态是整数类型
                if (record.getStatus() == null) {
                    // 默认设置为缺勤
                    record.setStatus("缺勤");
                }
            }
            records.add(record);
        }
        return records;
    }
    
    @Override
    public AttendanceRecord getRecordByStudentIdAndAttendanceId(Integer studentId, Integer attendanceId) {
        AttendanceRecord record = recordMapper.selectByAttendanceIdAndStudentId(attendanceId, studentId);
        if (record != null) {
            // 为记录补充课程信息和考勤时间
            Attendance attendance = attendanceMapper.selectById(record.getAttendanceId());
            if (attendance != null) {
                // 设置课程名称
                record.setCourseName(attendance.getCourseName());
                // 设置考勤日期
                record.setAttendanceDate(attendance.getStartTime());
                // 设置签到时间
                record.setSignTime(record.getAttendanceTime());
                // 确保状态是整数类型
                if (record.getStatus() == null) {
                    // 默认设置为缺勤
                    record.setStatus("缺勤");
                }
            }
        }
        return record;
    }

    @Override
    public List<AttendanceRecord> getAllRecords() {
        return recordMapper.selectAll();
    }

    @Override
    public boolean isStudentSigned(Integer attendanceId, Integer studentId) {
        AttendanceRecord record = recordMapper.selectByAttendanceIdAndStudentId(attendanceId, studentId);
        return record != null;
    }
}