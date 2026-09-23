package com.example.demo.mapper;

import com.example.demo.model.BulletScreen;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface BulletScreenMapper {
    // 发送弹幕
    int insert(BulletScreen bulletScreen);

    // 根据课程ID查询最新的N条弹幕
    List<BulletScreen> selectLatestByCourseId(@Param("courseId") Integer courseId, @Param("limit") Integer limit);

    // 根据课程ID查询所有弹幕
    List<BulletScreen> selectByCourseId(Integer courseId);

    // 根据发送者ID查询弹幕
    List<BulletScreen> selectBySenderId(Integer senderId);

    // 根据ID删除弹幕
    int delete(Integer id);
}