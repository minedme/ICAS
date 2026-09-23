package com.example.demo.controller;

import com.example.demo.model.Course;
import com.example.demo.service.CourseService;
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
@RequestMapping("/admin/course")
public class AdminCourseController {

    @Autowired
    private CourseService courseService;

    // 查看课程列表
    @GetMapping("/list")
    public String courseList(@RequestParam(required = false) String courseName,
                            @RequestParam(required = false) String courseCode,
                            Model model) {
        List<Course> courses;
        if ((courseName != null && !courseName.isEmpty()) || (courseCode != null && !courseCode.isEmpty())) {
            courses = courseService.searchCourses(courseName, courseCode);
        } else {
            courses = courseService.findAll();
        }
        model.addAttribute("courses", courses);
        return "admin/course/list";
    }

    // 跳转到课程详情页面
    @GetMapping("/detail/{id}")
    public String courseDetail(@PathVariable Integer id, Model model) {
        Course course = courseService.findById(id);
        model.addAttribute("course", course);
        return "admin/course/detail";
    }

    // 跳转到添加课程页面
    @GetMapping("/add")
    public String toAddCourse() {
        return "admin/course/add";
    }

    // 添加课程
    @PostMapping("/add")
    public String addCourse(Course course, Model model) {
        try {
            boolean success = courseService.addCourse(course);
            if (success) {
                model.addAttribute("successMessage", "课程添加成功！");
            } else {
                model.addAttribute("errorMessage", "课程添加失败，请重试！");
            }
        } catch (Exception e) {
            model.addAttribute("errorMessage", "添加过程中发生错误：" + e.getMessage());
        }
        return "redirect:/admin/course/list";
    }

    // 跳转到编辑课程页面
    @GetMapping("/edit/{id}")
    public String toEditCourse(@PathVariable Integer id, Model model) {
        Course course = courseService.findById(id);
        model.addAttribute("course", course);
        return "admin/course/edit";
    }

    // 更新课程信息
    @PostMapping("/update")
    public String updateCourse(Course course, Model model) {
        try {
            boolean success = courseService.updateCourse(course);
            if (success) {
                model.addAttribute("successMessage", "课程信息更新成功！");
            } else {
                model.addAttribute("errorMessage", "课程信息更新失败，请重试！");
            }
        } catch (Exception e) {
            model.addAttribute("errorMessage", "更新过程中发生错误：" + e.getMessage());
        }
        return "redirect:/admin/course/list";
    }

    // 删除课程
    @GetMapping("/delete/{id}")
    public String deleteCourse(@PathVariable Integer id, Model model) {
        try {
            boolean success = courseService.deleteCourse(id);
            if (success) {
                model.addAttribute("successMessage", "课程删除成功！");
            } else {
                model.addAttribute("errorMessage", "课程删除失败，请重试！");
            }
        } catch (Exception e) {
            model.addAttribute("errorMessage", "删除过程中发生错误：" + e.getMessage());
        }
        return "redirect:/admin/course/list";
    }
}