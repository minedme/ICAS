package com.example.demo.controller;

import com.example.demo.mapper.UserMapper;
import com.example.demo.model.ClassInfo;
import com.example.demo.model.User;
import com.example.demo.service.ClassService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ClassJoinController {

    @Autowired
    private ClassService classService;

    @Autowired
    private UserMapper userMapper;

    @GetMapping("/class/join")
    public String joinForm(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        List<ClassInfo> classes = classService.getAllClasses();
        model.addAttribute("classes", classes);
        model.addAttribute("user", user);
        
        return "class/join";
    }

    @PostMapping("/class/join")
    @ResponseBody
    public Map<String, Object> join(@RequestParam String classCode, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            return result;
        }
        
        if ("student".equals(user.getRole())) {
            if (user.getClassId() != null) {
                result.put("success", false);
                result.put("message", "您已经加入了一个班级，不能重复加入");
                return result;
            }
        }
        
        try {
            ClassInfo classInfo = classService.getClassByCode(classCode);
            if (classInfo == null) {
                result.put("success", false);
                result.put("message", "班级代码不存在");
                return result;
            }
            
            if (classInfo.getStatus() != 1) {
                result.put("success", false);
                result.put("message", "该班级已禁用");
                return result;
            }
            
            if ("student".equals(user.getRole())) {
                user.setClassId(classInfo.getId());
                user.setUpdateTime(new Date());
                userMapper.update(user);
                
                session.setAttribute("user", user);
                
                int newCount = (classInfo.getStudentCount() != null ? classInfo.getStudentCount() : 0) + 1;
                classService.updateStudentCount(classInfo.getId(), newCount);
                
                result.put("success", true);
                result.put("message", "加入班级成功");
                result.put("classInfo", classInfo);
            } else if ("teacher".equals(user.getRole())) {
                if (classInfo.getTeacherId() != null && !classInfo.getTeacherId().equals(user.getId())) {
                    result.put("success", false);
                    result.put("message", "该班级已有班主任");
                    return result;
                }
                
                classInfo.setTeacherId(user.getId());
                classInfo.setUpdateTime(new Date());
                classService.updateClass(classInfo);
                
                user.setClassId(classInfo.getId());
                user.setUpdateTime(new Date());
                userMapper.update(user);
                
                session.setAttribute("user", user);
                
                result.put("success", true);
                result.put("message", "成功担任班级班主任");
                result.put("classInfo", classInfo);
            } else {
                result.put("success", false);
                result.put("message", "只有学生和教师可以加入班级");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "加入班级失败：" + e.getMessage());
        }
        
        return result;
    }
}
