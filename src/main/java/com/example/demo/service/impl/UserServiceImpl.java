package com.example.demo.service.impl;

import com.example.demo.mapper.UserMapper;
import com.example.demo.model.User;
import com.example.demo.service.UserService;
import com.example.demo.util.MD5Util;
import com.example.demo.utils.UniCloudFunctionClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;
    
    @Autowired
    private UniCloudFunctionClient uniCloudFunctionClient;

    @Override
    public User login(String username, String password, String role) {
        User user = userMapper.selectByUsername(username, role);
        if (user != null && MD5Util.matches(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    @Override
    public boolean register(User user) {
        System.out.println("========================================");
        System.out.println("开始注册用户: " + user.getUsername());
        user.setPassword(MD5Util.encrypt(user.getPassword()));
        user.setCreateTime(new Date());
        user.setUpdateTime(new Date());
        user.setStatus(1); // 1表示正常
        
        try {
            // 直接写入本地数据库
            int insertResult = userMapper.insert(user);
            System.out.println("用户注册成功，ID: " + user.getId());
            return insertResult > 0;
        } catch (org.springframework.dao.DuplicateKeyException e) {
            System.out.println("用户名已存在: " + user.getUsername());
            return false;
        }
    }

    @Override
    public User findById(Integer id) {
        return userMapper.selectById(id);
    }

    @Override
    public List<User> findAll() {
        // 调用云函数获取用户列表
        Map<String, Object> result = uniCloudFunctionClient.callFunction("getUserList");
        
        // 处理云函数返回结果
        if (result != null && 0 == (Integer) result.get("code")) {
            List<Map<String, Object>> userDataList = (List<Map<String, Object>>) result.get("data");
            List<User> userList = new ArrayList<>();
            
            // 转换为User对象列表
            for (Map<String, Object> userData : userDataList) {
                User user = new User();
                user.setId(convertInteger(userData.get("id")));
                user.setUsername((String) userData.get("username"));
                user.setPassword((String) userData.get("password"));
                user.setRealName((String) userData.get("realName"));
                user.setRole((String) userData.get("role"));
                user.setEmail((String) userData.get("email"));
                user.setPhone((String) userData.get("phone"));
                user.setStatus(convertInteger(userData.get("status")));
                user.setCreateTime((Date) userData.get("createTime"));
                user.setUpdateTime((Date) userData.get("updateTime"));
                userList.add(user);
            }
            
            return userList;
        } else {
            // 云函数调用失败时，回退到本地数据库查询
            return userMapper.selectAll();
        }
    }

    @Override
    public boolean update(User user) {
        user.setUpdateTime(new Date());
        return userMapper.update(user) > 0;
    }

    @Override
    public boolean delete(Integer id) {
        return userMapper.delete(id) > 0;
    }
    
    /**
     * 安全转换为Integer
     * @param value 要转换的值
     * @return Integer值，转换失败返回null
     */
    private Integer convertInteger(Object value) {
        if (value == null) {
            return null;
        } else if (value instanceof Integer) {
            return (Integer) value;
        } else if (value instanceof String) {
            try {
                return Integer.parseInt((String) value);
            } catch (NumberFormatException e) {
                return null;
            }
        } else if (value instanceof Long) {
            return ((Long) value).intValue();
        } else {
            return null;
        }
    }

    @Override
    public List<User> findByRole(String role) {
        return userMapper.selectByRole(role);
    }

    @Override
    public List<User> searchUsers(String username, String role) {
        return userMapper.searchUsers(username, role);
    }
    
    @Override
    public List<User> findByPage(int page, int size) {
        int offset = (page - 1) * size;
        return userMapper.selectByPage(offset, size);
    }
    
    @Override
    public int count() {
        return userMapper.count();
    }
}