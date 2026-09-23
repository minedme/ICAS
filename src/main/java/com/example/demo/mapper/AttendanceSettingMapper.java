package com.example.demo.mapper;

import com.example.demo.model.AttendanceSetting;
import org.apache.ibatis.annotations.*;

@Mapper
public interface AttendanceSettingMapper {

    @Select("SELECT * FROM attendance_setting WHERE id = #{id}")
    AttendanceSetting selectById(@Param("id") Integer id);

    @Select("SELECT * FROM attendance_setting WHERE teacher_id = #{teacherId}")
    AttendanceSetting selectByTeacherId(@Param("teacherId") Integer teacherId);

    @Insert("INSERT INTO attendance_setting (teacher_id, latitude, longitude, radius, duration, early_sign_minutes, late_sign_minutes, enable_location, enable_face_recognition, create_time, update_time) VALUES (#{teacherId}, #{latitude}, #{longitude}, #{radius}, #{duration}, #{earlySignMinutes}, #{lateSignMinutes}, #{enableLocation}, #{enableFaceRecognition}, #{createTime}, #{updateTime})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(AttendanceSetting attendanceSetting);

    @Update("UPDATE attendance_setting SET latitude = #{latitude}, longitude = #{longitude}, radius = #{radius}, duration = #{duration}, early_sign_minutes = #{earlySignMinutes}, late_sign_minutes = #{lateSignMinutes}, enable_location = #{enableLocation}, enable_face_recognition = #{enableFaceRecognition}, update_time = #{updateTime} WHERE id = #{id}")
    int update(AttendanceSetting attendanceSetting);

    @Delete("DELETE FROM attendance_setting WHERE id = #{id}")
    int deleteById(@Param("id") Integer id);
}