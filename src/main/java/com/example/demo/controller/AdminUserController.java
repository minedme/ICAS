package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/admin/user")
public class AdminUserController {

    @Autowired
    private UserService userService;

    // 查看用户列表
    @GetMapping("/list")
    public String userList(@RequestParam(required = false) String username,
                          @RequestParam(required = false) String role,
                          @RequestParam(defaultValue = "1") int page,
                          Model model) {
        int pageSize = 10;
        List<User> users;
        int totalUsers;
        
        if ((username != null && !username.isEmpty()) || (role != null && !role.isEmpty())) {
            users = userService.searchUsers(username, role);
            totalUsers = users.size();
        } else {
            users = userService.findByPage(page, pageSize);
            totalUsers = userService.count();
        }
        
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        
        model.addAttribute("users", users);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalUsers", totalUsers);
        return "admin/user/list";
    }

    // 跳转到用户详情页面
    @GetMapping("/detail/{id}")
    public String userDetail(@PathVariable Integer id, Model model) {
        User user = userService.findById(id);
        model.addAttribute("user", user);
        return "admin/user/detail";
    }

    // 跳转到编辑用户页面
    @GetMapping("/edit/{id}")
    public String toEditUser(@PathVariable Integer id, Model model) {
        User user = userService.findById(id);
        model.addAttribute("user", user);
        return "admin/user/edit";
    }

    // 更新用户信息
    @PostMapping("/update")
    public String updateUser(User user, Model model) {
        try {
            boolean success = userService.update(user);
            if (success) {
                model.addAttribute("successMessage", "用户信息更新成功！");
            } else {
                model.addAttribute("errorMessage", "用户信息更新失败，请重试！");
            }
        } catch (Exception e) {
            model.addAttribute("errorMessage", "更新过程中发生错误：" + e.getMessage());
        }
        return "redirect:/admin/user/list";
    }

    // 删除用户
    @GetMapping("/delete/{id}")
    public String deleteUser(@PathVariable Integer id) {
        userService.delete(id);
        return "redirect:/admin/user/list";
    }
}