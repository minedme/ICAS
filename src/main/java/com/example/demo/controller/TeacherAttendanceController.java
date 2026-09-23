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
import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.util.List;

@Controller
@RequestMapping("/teacher/attendance")
public class TeacherAttendanceController {

    @Autowired
    private AttendanceService attendanceService;

    @Autowired
    private AttendanceRecordService recordService;

    // 跳转到创建考勤页面
    @GetMapping("/create")
    public String toCreate() {
        return "teacher/attendance/create";
    }

    // 创建考勤任务
    @PostMapping("/create")
    public String createAttendance(Attendance attendance, HttpSession session) {
        User user = (User) session.getAttribute("user");
        Integer teacherId = user.getId();
        attendance.setTeacherId(teacherId);
        attendanceService.createAttendance(attendance);
        return "redirect:/teacher/attendance/list";
    }

    // 查看考勤任务列表
    @GetMapping("/list")
    public String list(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        Integer teacherId = user.getId();
        List<Attendance> attendances = attendanceService.getAttendancesByTeacherId(teacherId);
        model.addAttribute("attendances", attendances);
        return "teacher/attendance/list";
    }

    // 查看考勤详情
    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Integer id, Model model) {
        Attendance attendance = attendanceService.getAttendanceById(id);
        List<AttendanceRecord> records = recordService.getRecordsByAttendanceId(id);
        model.addAttribute("attendance", attendance);
        model.addAttribute("records", records);
        return "teacher/attendance/detail";
    }

    // 刷新二维码
    @GetMapping("/refresh/{id}")
    @ResponseBody
    public String refreshQrCode(@PathVariable Integer id) {
        boolean success = attendanceService.refreshQrCode(id);
        return success ? "success" : "fail";
    }

    // 获取二维码
    @GetMapping("/qrCode/{id}")
    public void getQrCode(@PathVariable Integer id, HttpServletResponse response) throws Exception {
        Attendance attendance = attendanceService.getAttendanceById(id);
        if (attendance != null && attendance.getQrCode() != null) {
            // 使用QRCodeUtil生成二维码图片
            byte[] qrCodeBytes = com.example.demo.util.QRCodeUtil.generateQRCode(attendance.getQrCode());
            
            // 设置响应头
            response.setContentType("image/png");
            response.setContentLength(qrCodeBytes.length);
            
            // 写入响应流
            OutputStream outputStream = response.getOutputStream();
            outputStream.write(qrCodeBytes);
            outputStream.flush();
            outputStream.close();
        }
    }
}