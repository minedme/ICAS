package com.example.demo.service.impl;

import com.example.demo.mapper.AttendanceSettingMapper;
import com.example.demo.model.AttendanceSetting;
import com.example.demo.service.AttendanceSettingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
public class AttendanceSettingServiceImpl implements AttendanceSettingService {

    @Autowired
    private AttendanceSettingMapper attendanceSettingMapper;

    @Override
    public AttendanceSetting getSettingByTeacherId(Integer teacherId) {
        return attendanceSettingMapper.selectByTeacherId(teacherId);
    }

    @Override
    public int saveSetting(AttendanceSetting setting) {
        setting.setCreateTime(new Date());
        setting.setUpdateTime(new Date());
        return attendanceSettingMapper.insert(setting);
    }

    @Override
    public int updateSetting(AttendanceSetting setting) {
        setting.setUpdateTime(new Date());
        return attendanceSettingMapper.update(setting);
    }
}