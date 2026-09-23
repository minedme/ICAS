package com.example.demo.service;

import com.example.demo.model.AttendanceSetting;

public interface AttendanceSettingService {
    AttendanceSetting getSettingByTeacherId(Integer teacherId);
    int saveSetting(AttendanceSetting setting);
    int updateSetting(AttendanceSetting setting);
}