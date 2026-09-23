package com.example.demo.service.impl;

import com.example.demo.service.OnlineUserService;
import org.springframework.stereotype.Service;

import java.util.Set;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.function.Consumer;

/**
 * 在线用户服务实现类
 * 提供线程安全的在线用户数量管理和变化通知机制
 */
@Service
public class OnlineUserServiceImpl implements OnlineUserService {

    private final AtomicInteger onlineCount = new AtomicInteger(0);
    private final Set<Consumer<Integer>> listeners = new CopyOnWriteArraySet<>();

    @Override
    public void increment() {
        int newCount = onlineCount.incrementAndGet();
        notifyListeners(newCount);
    }

    @Override
    public void decrement() {
        int newCount = Math.max(0, onlineCount.decrementAndGet());
        notifyListeners(newCount);
    }

    @Override
    public int getCount() {
        return onlineCount.get();
    }

    @Override
    public void registerListener(Consumer<Integer> listener) {
        listeners.add(listener);
        // 立即通知新注册的监听器当前在线人数
        listener.accept(onlineCount.get());
    }

    @Override
    public void removeListener(Consumer<Integer> listener) {
        listeners.remove(listener);
    }

    /**
     * 通知所有监听器在线人数变化
     * @param count 新的在线人数
     */
    private void notifyListeners(int count) {
        for (Consumer<Integer> listener : listeners) {
            try {
                listener.accept(count);
            } catch (Exception e) {
                // 移除有问题的监听器
                listeners.remove(listener);
            }
        }
    }
}