package com.example.demo.controller;

import com.example.demo.service.OnlineUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class OnlineUserController {

    @Autowired
    private OnlineUserService onlineUserService;

    @GetMapping("/api/online-users/count")
    public Integer getOnlineUserCount() {
        return onlineUserService.getCount();
    }
}