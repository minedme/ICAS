package com.example.demo.controller;

import com.example.demo.model.BulletScreen;
import com.example.demo.model.User;
import com.example.demo.service.BulletScreenService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/student/bullet-screen")
public class StudentBulletScreenController {

    @Autowired
    private BulletScreenService bulletScreenService;

    // 发送弹幕
    @PostMapping("/send")
    @ResponseBody
    public String sendBulletScreen(@ModelAttribute BulletScreen bulletScreen, HttpSession session) {
        User user = (User) session.getAttribute("user");
        bulletScreen.setSenderId(user.getId());
        bulletScreen.setSenderName(user.getRealName());
        
        boolean success = bulletScreenService.sendBulletScreen(bulletScreen);
        if (success) {
            return "success";
        } else {
            return "error";
        }
    }

    // 获取最新的弹幕
    @GetMapping("/latest/{courseId}")
    @ResponseBody
    public Object getLatestBulletScreens(@PathVariable Integer courseId, 
                                        @RequestParam(defaultValue = "10") Integer limit) {
        return bulletScreenService.getLatestBulletScreens(courseId, limit);
    }
}