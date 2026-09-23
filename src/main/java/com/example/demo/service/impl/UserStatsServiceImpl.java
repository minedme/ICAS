package com.example.demo.service.impl;

import com.example.demo.mapper.UserMapper;
import com.example.demo.model.User;
import com.example.demo.service.UserStatsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import javax.annotation.PostConstruct;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.function.Consumer;

@Service
public class UserStatsServiceImpl implements UserStatsService {

    @Autowired
    private UserMapper userMapper;

    private final Map<String, Integer> stats = new HashMap<>();
    private final Set<Consumer<Map<String, Integer>>> listeners = new CopyOnWriteArraySet<>();

    @PostConstruct
    public void init() {
        // 初始化统计数据
        updateStats();
    }

    @Override
    public Map<String, Integer> getStats() {
        return new HashMap<>(stats);
    }

    @Override
    public void updateStats() {
        // 获取所有用户
        List<User> allUsers = userMapper.selectAll();
        int total = allUsers.size();
        
        // 统计教师数
        int teachers = (int) allUsers.stream()
                .filter(user -> "teacher".equals(user.getRole()))
                .count();
        
        // 统计学生数
        int students = (int) allUsers.stream()
                .filter(user -> "student".equals(user.getRole()))
                .count();
        
        // 更新统计数据
        stats.put("total", total);
        stats.put("teachers", teachers);
        stats.put("students", students);
        
        // 通知所有监听器
        notifyListeners();
    }

    @Override
    public void registerListener(Consumer<Map<String, Integer>> listener) {
        listeners.add(listener);
        // 立即通知新注册的监听器当前统计数据
        listener.accept(getStats());
    }

    @Override
    public void removeListener(Consumer<Map<String, Integer>> listener) {
        listeners.remove(listener);
    }

    /**
     * 通知所有监听器统计数据变化
     */
    private void notifyListeners() {
        Map<String, Integer> currentStats = getStats();
        for (Consumer<Map<String, Integer>> listener : listeners) {
            try {
                listener.accept(currentStats);
            } catch (Exception e) {
                // 移除有问题的监听器
                listeners.remove(listener);
            }
        }
    }
}