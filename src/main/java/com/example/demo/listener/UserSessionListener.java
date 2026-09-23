package com.example.demo.listener;

import com.example.demo.service.OnlineUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

@Component
public class UserSessionListener implements HttpSessionListener, ApplicationListener<ContextRefreshedEvent> {

    @Autowired
    private OnlineUserService onlineUserService;

    @Override
    public void onApplicationEvent(ContextRefreshedEvent event) {
        // 确保在 Spring 容器完全初始化后获取 OnlineUserService
        ApplicationContext context = event.getApplicationContext();
        onlineUserService = context.getBean(OnlineUserService.class);
    }

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        if (onlineUserService != null) {
            onlineUserService.increment();
        }
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        if (onlineUserService != null) {
            onlineUserService.decrement();
        }
    }
}