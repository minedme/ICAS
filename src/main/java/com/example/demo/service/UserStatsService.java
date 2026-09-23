package com.example.demo.service;

import java.util.Map;
import java.util.function.Consumer;

public interface UserStatsService {
    /**
     * 获取当前用户统计数据
     * @return 包含总用户数、教师数、学生数的Map
     */
    Map<String, Integer> getStats();
    
    /**
     * 更新用户统计数据
     */
    void updateStats();
    
    /**
     * 注册统计数据变化监听器
     * @param listener 监听器回调函数
     */
    void registerListener(Consumer<Map<String, Integer>> listener);
    
    /**
     * 移除统计数据变化监听器
     * @param listener 监听器回调函数
     */
    void removeListener(Consumer<Map<String, Integer>> listener);
}