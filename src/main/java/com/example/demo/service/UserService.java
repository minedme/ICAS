package com.example.demo.service;

import com.example.demo.model.User;

import java.util.List;

public interface UserService {
    // 用户登录
    User login(String username, String password, String role);

    // 用户注册
    boolean register(User user);

    // 根据ID查询用户
    User findById(Integer id);

    // 查询所有用户
    List<User> findAll();

    // 更新用户信息
    boolean update(User user);

    // 删除用户
    boolean delete(Integer id);

    // 根据角色查询用户
    List<User> findByRole(String role);
    
    // 根据用户名和角色搜索用户
    List<User> searchUsers(String username, String role);
    
    // 分页查询用户
    List<User> findByPage(int page, int size);
    
    // 获取用户总数
    int count();
    
}