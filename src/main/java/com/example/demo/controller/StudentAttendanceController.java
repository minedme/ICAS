package com.example.demo.controller;

import com.example.demo.model.Attendance;
import com.example.demo.model.AttendanceRecord;
import com.example.demo.model.User;
import com.example.demo.service.AttendanceService;
import com.example.demo.service.AttendanceRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/student/attendance")
public class StudentAttendanceController {

    @Autowired
    private AttendanceService attendanceService;

    @Autowired
    private AttendanceRecordService recordService;

    // 跳转到扫码签到页面
    @GetMapping("/scan")
    public String toScan() {
        return "student/attendance/sign";
    }

    // 扫码签到
    @PostMapping("/scan")
    @ResponseBody
    public String scanSign(@RequestParam String qrCode, HttpSession session) {
        User user = (User) session.getAttribute("user");
        Integer studentId = user.getId();

        // 根据二维码查询考勤任务
        Attendance attendance = attendanceService.getAttendanceByQrCode(qrCode);
        if (attendance == null) {
            return "考勤任务不存在";
        }

        // 检查是否已签到
        if (recordService.isStudentSigned(attendance.getId(), studentId)) {
            return "您已签到";
        }

        // 创建考勤记录
        AttendanceRecord record = new AttendanceRecord();
        record.setAttendanceId(attendance.getId());
        record.setStudentId(studentId);

        boolean success = recordService.scanSign(record);
        return success ? "签到成功" : "签到失败";
    }

    // 跳转到GPS签到页面
    @GetMapping("/gps")
    public String toGps(Model model) {
        List<Attendance> attendances = attendanceService.getAllAttendances();
        model.addAttribute("attendances", attendances);
        return "student/attendance/sign";
    }

    // GPS定位签到
    @PostMapping("/gps")
    @ResponseBody
    public String gpsSign(@RequestParam Integer attendanceId, @RequestParam Double latitude, @RequestParam Double longitude, HttpSession session) {
        User user = (User) session.getAttribute("user");
        Integer studentId = user.getId();

        // 检查是否已签到
        if (recordService.isStudentSigned(attendanceId, studentId)) {
            return "您已签到";
        }

        // 创建考勤记录
        AttendanceRecord record = new AttendanceRecord();
        record.setAttendanceId(attendanceId);
        record.setStudentId(studentId);

        boolean success = recordService.gpsSign(record, latitude, longitude);
        return success ? "签到成功" : "签到失败";
    }

    // 查看个人考勤记录
    @GetMapping({"/records", "/list"})
    public String records(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        Integer studentId = user.getId();
        
        // 获取所有考勤任务
        List<Attendance> attendances = attendanceService.getAllAttendances();
        
        // 转换为学生考勤记录列表，包含已签到和未签到的任务
        List<AttendanceRecord> records = new ArrayList<>();
        
        for (Attendance attendance : attendances) {
            AttendanceRecord record;
            
            // 检查学生是否已签到
            if (recordService.isStudentSigned(attendance.getId(), studentId)) {
                // 如果已签到，获取具体的签到记录
                List<AttendanceRecord> signedRecords = new ArrayList<>();
                signedRecords.add(recordService.getRecordByStudentIdAndAttendanceId(studentId, attendance.getId()));
                if (!signedRecords.isEmpty()) {
                    record = signedRecords.get(0);
                } else {
                    continue;
                }
            } else {
                // 如果未签到，创建一个新的记录对象
                record = new AttendanceRecord();
                record.setAttendanceId(attendance.getId());
                record.setStudentId(studentId);
                record.setStatus("未签到"); // 设置为未签到状态
                // 设置课程名称和考勤日期
                record.setCourseName(attendance.getCourseName());
                record.setAttendanceDate(attendance.getStartTime());
                record.setSignTime(null); // 未签到，无签到时间
            }
            
            records.add(record);
        }
        
        model.addAttribute("attendanceRecords", records);
        // 计算出勤率（示例，实际需要根据业务逻辑计算）
        model.addAttribute("attendanceRate", 100);
        return "student/attendance/list";
    }
}