package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    // 跳转到登录页面
    @GetMapping("/login")
    public String toLogin() {
        return "login";
    }

    // 用户登录
    @PostMapping("/login")
    public String login(@RequestParam String username, @RequestParam String password, @RequestParam String role,
                       HttpSession session, Model model) {
        User user = userService.login(username, password, role);
        if (user != null) {
            session.setAttribute("user", user);
            session.setAttribute("role", role);
            // 根据角色跳转到对应页面
            if ("admin".equals(role)) {
                return "redirect:/admin/index";
            } else if ("teacher".equals(role)) {
                return "redirect:/teacher/index";
            } else if ("student".equals(role)) {
                return "redirect:/student/index";
            }
        }
        model.addAttribute("error", "用户名、密码或角色错误");
        return "login";
    }

    // 跳转到注册页面
    @GetMapping("/register")
    public String toRegister() {
        return "register";
    }

    // 用户注册
    @PostMapping("/register")
    public String register(User user, Model model) {
        // 验证角色，只允许教师和学生注册
        if (!"teacher".equals(user.getRole()) && !"student".equals(user.getRole())) {
            model.addAttribute("error", "只能注册教师和学生账号");
            return "register";
        }
        boolean success = userService.register(user);
        if (success) {
            model.addAttribute("success", "注册成功，请登录");
            return "redirect:/user/login";
        }
        model.addAttribute("error", "注册失败，用户名可能已存在");
        return "register";
    }

    // 用户注销
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/user/login";
    }

    // 管理员查看所有用户
    @GetMapping("/list")
    public String list(Model model) {
        List<User> users = userService.findAll();
        model.addAttribute("users", users);
        return "user/list";
    }

    // 根据ID查看用户详情
    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Integer id, Model model) {
        User user = userService.findById(id);
        model.addAttribute("user", user);
        return "user/detail";
    }

    // 跳转到编辑用户页面
    @GetMapping("/edit/{id}")
    public String toEdit(@PathVariable Integer id, Model model) {
        User user = userService.findById(id);
        model.addAttribute("user", user);
        return "user/edit";
    }

    // 更新用户信息
    @PostMapping("/update")
    public String update(User user) {
        userService.update(user);
        return "redirect:/user/list";
    }

    // 删除用户
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Integer id) {
        userService.delete(id);
        return "redirect:/user/list";
    }
}