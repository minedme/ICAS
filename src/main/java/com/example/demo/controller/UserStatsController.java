package com.example.demo.controller;

import com.example.demo.service.UserStatsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class UserStatsController {

    @Autowired
    private UserStatsService userStatsService;

    @GetMapping("/api/user-stats/count")
    public Map<String, Integer> getUserStatsCount() {
        return userStatsService.getStats();
    }
    
    @PostMapping("/api/user-stats/update")
    public void updateUserStats() {
        userStatsService.updateStats();
    }
}