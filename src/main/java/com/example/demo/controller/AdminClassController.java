package com.example.demo.controller;

import com.example.demo.model.ClassInfo;
import com.example.demo.model.User;
import com.example.demo.service.ClassService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/class")
public class AdminClassController {

    @Autowired
    private ClassService classService;

    @GetMapping("/list")
    public String classList(@RequestParam(defaultValue = "1") int page,
                         @RequestParam(defaultValue = "10") int size,
                         @RequestParam(required = false) String className,
                         @RequestParam(required = false) String classCode,
                         @RequestParam(required = false) String major,
                         Model model) {
        int offset = (page - 1) * size;
        List<ClassInfo> classes;

        if ((className != null && !className.isEmpty()) || 
            (classCode != null && !classCode.isEmpty()) || 
            (major != null && !major.isEmpty())) {
            classes = classService.searchClasses(className, classCode, major);
            model.addAttribute("total", classes.size());
        } else {
            classes = classService.getClassesByPage(offset, size);
            model.addAttribute("total", classService.getClassCount());
        }

        int total = (Integer) model.getAttribute("total");
        int totalPages = (int) Math.ceil((double) total / size);

        model.addAttribute("classes", classes);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("className", className);
        model.addAttribute("classCode", classCode);
        model.addAttribute("major", major);

        return "admin/class/list";
    }

    @GetMapping("/create")
    public String createForm(Model model) {
        model.addAttribute("classInfo", new ClassInfo());
        return "admin/class/create";
    }

    @PostMapping("/create")
    @ResponseBody
    public Map<String, Object> create(@RequestBody ClassInfo classInfo, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            boolean success = classService.createClass(classInfo);
            if (success) {
                result.put("success", true);
                result.put("message", "班级创建成功");
            } else {
                result.put("success", false);
                result.put("message", "班级创建失败");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "班级创建失败：" + e.getMessage());
        }
        return result;
    }

    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Integer id, Model model) {
        ClassInfo classInfo = classService.getClassById(id);
        if (classInfo == null) {
            return "redirect:/admin/class/list";
        }
        model.addAttribute("classInfo", classInfo);
        return "admin/class/edit";
    }

    @PostMapping("/edit")
    @ResponseBody
    public Map<String, Object> edit(@RequestBody ClassInfo classInfo) {
        Map<String, Object> result = new HashMap<>();
        try {
            boolean success = classService.updateClass(classInfo);
            if (success) {
                result.put("success", true);
                result.put("message", "班级更新成功");
            } else {
                result.put("success", false);
                result.put("message", "班级更新失败");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "班级更新失败：" + e.getMessage());
        }
        return result;
    }

    @PostMapping("/delete/{id}")
    @ResponseBody
    public Map<String, Object> delete(@PathVariable Integer id) {
        Map<String, Object> result = new HashMap<>();
        try {
            boolean success = classService.deleteClass(id);
            if (success) {
                result.put("success", true);
                result.put("message", "班级删除成功");
            } else {
                result.put("success", false);
                result.put("message", "班级删除失败");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "班级删除失败：" + e.getMessage());
        }
        return result;
    }
}
