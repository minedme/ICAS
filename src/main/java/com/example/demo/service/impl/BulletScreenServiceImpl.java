package com.example.demo.service.impl;

import com.example.demo.mapper.BulletScreenMapper;
import com.example.demo.model.BulletScreen;
import com.example.demo.service.BulletScreenService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class BulletScreenServiceImpl implements BulletScreenService {

    @Autowired
    private BulletScreenMapper bulletScreenMapper;

    @Override
    public boolean sendBulletScreen(BulletScreen bulletScreen) {
        // 设置发送时间
        bulletScreen.setSendTime(new Date());
        // 如果是匿名发送，设置发送者名称为"匿名"
        if (bulletScreen.getIsAnonymous() != null && bulletScreen.getIsAnonymous()) {
            bulletScreen.setSenderName("匿名");
        }
        int result = bulletScreenMapper.insert(bulletScreen);
        return result > 0;
    }

    @Override
    public List<BulletScreen> getLatestBulletScreens(Integer courseId, Integer limit) {
        return bulletScreenMapper.selectLatestByCourseId(courseId, limit);
    }

    @Override
    public List<BulletScreen> getAllBulletScreens(Integer courseId) {
        return bulletScreenMapper.selectByCourseId(courseId);
    }

    @Override
    public Integer getBulletScreenCount(Integer courseId) {
        List<BulletScreen> bulletScreens = bulletScreenMapper.selectByCourseId(courseId);
        return bulletScreens != null ? bulletScreens.size() : 0;
    }
}