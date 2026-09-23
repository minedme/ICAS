package com.example.demo.service;

import com.example.demo.model.BulletScreen;

import java.util.List;

public interface BulletScreenService {
    // 发送弹幕
    boolean sendBulletScreen(BulletScreen bulletScreen);

    // 获取最新的弹幕
    List<BulletScreen> getLatestBulletScreens(Integer courseId, Integer limit);

    // 获取所有弹幕
    List<BulletScreen> getAllBulletScreens(Integer courseId);

    // 获取弹幕总数
    Integer getBulletScreenCount(Integer courseId);
}