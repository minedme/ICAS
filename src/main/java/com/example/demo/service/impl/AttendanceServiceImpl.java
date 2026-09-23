package com.example.demo.service.impl;

import com.example.demo.mapper.AttendanceMapper;
import com.example.demo.mapper.AttendanceRecordMapper;
import com.example.demo.model.Attendance;
import com.example.demo.model.AttendanceRecord;
import com.example.demo.service.AttendanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;

@Service
public class AttendanceServiceImpl implements AttendanceService {

    @Autowired
    private AttendanceMapper attendanceMapper;

    @Autowired
    private AttendanceRecordMapper attendanceRecordMapper;

    @Value("${file.storage.path}")
    private String fileStoragePath;

    @Override
    public boolean createAttendance(Attendance attendance) {
        String qrCode = generateQrCode();
        attendance.setQrCode(qrCode);
        attendance.setCreateTime(new Date());
        attendance.setStatus(1);
        
        String filePath = fileStoragePath + "\\attendance_" + System.currentTimeMillis() + ".json";
        attendance.setFilePath(filePath);
        
        if (attendance.getMinLatitude() == null) {
            attendance.setMinLatitude(0.0);
        }
        if (attendance.getMaxLatitude() == null) {
            attendance.setMaxLatitude(0.0);
        }
        if (attendance.getMinLongitude() == null) {
            attendance.setMinLongitude(0.0);
        }
        if (attendance.getMaxLongitude() == null) {
            attendance.setMaxLongitude(0.0);
        }
        
        return attendanceMapper.insert(attendance) > 0;
    }

    @Override
    public boolean updateAttendance(Attendance attendance) {
        return attendanceMapper.update(attendance) > 0;
    }

    @Override
    public boolean refreshQrCode(Integer attendanceId) {
        String newQrCode = generateQrCode();
        return attendanceMapper.updateQrCode(attendanceId, newQrCode) > 0;
    }

    @Override
    public Attendance getAttendanceById(Integer id) {
        return attendanceMapper.selectById(id);
    }

    @Override
    public List<Attendance> getAttendancesByTeacherId(Integer teacherId) {
        return attendanceMapper.selectByTeacherId(teacherId);
    }

    @Override
    public List<Attendance> getAllAttendances() {
        return attendanceMapper.selectAll();
    }

    @Override
    public Attendance getAttendanceByQrCode(String qrCode) {
        return attendanceMapper.selectByQrCode(qrCode);
    }

    // 生成唯一二维码
    private String generateQrCode() {
        return UUID.randomUUID().toString().replaceAll("-", "");
    }

    @Override
    public List<Map<String, Object>> getAttendanceTrend(Integer studentId, String period, LocalDate startDate, LocalDate endDate) {
        List<AttendanceRecord> records = attendanceRecordMapper.selectByStudentIdAndDateRange(
            studentId, 
            Timestamp.valueOf(startDate.atStartOfDay()), 
            Timestamp.valueOf(endDate.plusDays(1).atStartOfDay())
        );

        List<Map<String, Object>> result = new ArrayList<>();
        
        if ("daily".equals(period)) {
            Map<LocalDate, Integer> dailyMap = new TreeMap<>();
            for (AttendanceRecord record : records) {
                LocalDate date = record.getAttendanceTime().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
                dailyMap.put(date, dailyMap.getOrDefault(date, 0) + 1);
            }
            
            for (Map.Entry<LocalDate, Integer> entry : dailyMap.entrySet()) {
                Map<String, Object> data = new HashMap<>();
                data.put("date", entry.getKey().toString());
                data.put("count", entry.getValue());
                data.put("status", entry.getValue() > 0 ? "present" : "absent");
                result.add(data);
            }
        } else if ("weekly".equals(period)) {
            Map<LocalDate, Integer> weeklyMap = new TreeMap<>();
            for (AttendanceRecord record : records) {
                LocalDate date = record.getAttendanceTime().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
                LocalDate weekStart = date.minusDays(date.getDayOfWeek().getValue() - 1);
                weeklyMap.put(weekStart, weeklyMap.getOrDefault(weekStart, 0) + 1);
            }
            
            for (Map.Entry<LocalDate, Integer> entry : weeklyMap.entrySet()) {
                Map<String, Object> data = new HashMap<>();
                data.put("date", entry.getKey().toString());
                data.put("week", entry.getKey().getYear() + "-W" + (entry.getKey().getDayOfYear() / 7 + 1));
                data.put("count", entry.getValue());
                result.add(data);
            }
        } else if ("monthly".equals(period)) {
            Map<LocalDate, Integer> monthlyMap = new TreeMap<>();
            for (AttendanceRecord record : records) {
                LocalDate date = record.getAttendanceTime().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
                LocalDate monthStart = LocalDate.of(date.getYear(), date.getMonthValue(), 1);
                monthlyMap.put(monthStart, monthlyMap.getOrDefault(monthStart, 0) + 1);
            }
            
            for (Map.Entry<LocalDate, Integer> entry : monthlyMap.entrySet()) {
                Map<String, Object> data = new HashMap<>();
                data.put("date", entry.getKey().toString());
                data.put("month", entry.getKey().getYear() + "-" + String.format("%02d", entry.getKey().getMonthValue()));
                data.put("count", entry.getValue());
                result.add(data);
            }
        }
        
        return result;
    }

    @Override
    public Map<String, Object> getClassAttendanceRate(Integer classId, LocalDate startDate, LocalDate endDate) {
        List<AttendanceRecord> records = attendanceRecordMapper.selectByClassIdAndDateRange(
            classId, 
            Timestamp.valueOf(startDate.atStartOfDay()), 
            Timestamp.valueOf(endDate.plusDays(1).atStartOfDay())
        );

        Map<String, Object> result = new HashMap<>();
        
        if (records.isEmpty()) {
            result.put("overallRate", 0.0);
            result.put("totalStudents", 0);
            result.put("presentCount", 0);
            result.put("absentCount", 0);
            return result;
        }

        int totalStudents = records.size();
        int presentCount = 0;
        Map<LocalDate, Integer> dailyPresent = new TreeMap<>();
        Map<LocalDate, Integer> dailyTotal = new TreeMap<>();

        for (AttendanceRecord record : records) {
            LocalDate date = record.getAttendanceTime().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
            dailyTotal.put(date, dailyTotal.getOrDefault(date, 0) + 1);
            if ("正常".equals(record.getStatus()) || "present".equals(record.getStatus())) {
                presentCount++;
                dailyPresent.put(date, dailyPresent.getOrDefault(date, 0) + 1);
            }
        }

        double overallRate = (double) presentCount / totalStudents * 100;
        
        List<Map<String, Object>> dailyRates = new ArrayList<>();
        for (Map.Entry<LocalDate, Integer> entry : dailyTotal.entrySet()) {
            Map<String, Object> dayData = new HashMap<>();
            dayData.put("date", entry.getKey().toString());
            int present = dailyPresent.getOrDefault(entry.getKey(), 0);
            dayData.put("rate", (double) present / entry.getValue() * 100);
            dayData.put("present", present);
            dayData.put("total", entry.getValue());
            dailyRates.add(dayData);
        }

        result.put("attendanceRate", Math.round(overallRate * 100.0) / 100.0);
        result.put("totalAttendance", presentCount);
        result.put("totalAbsent", totalStudents - presentCount);
        result.put("totalStudents", totalStudents);
        result.put("dailyRates", dailyRates);

        return result;
    }
}