package com.example.demo.service;

import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.function.Consumer;

public interface OnlineUserService {

    /**
     * 增加在线用户数量
     */
    void increment();

    /**
     * 减少在线用户数量
     */
    void decrement();

    /**
     * 获取当前在线用户数量
     * @return 在线用户数量
     */
    int getCount();

    /**
     * 注册在线人数变化监听器
     * @param listener 监听器回调函数
     */
    void registerListener(Consumer<Integer> listener);

    /**
     * 移除在线人数变化监听器
     * @param listener 监听器回调函数
     */
    void removeListener(Consumer<Integer> listener);
}