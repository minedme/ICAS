package com.example.demo.mapper;

import com.example.demo.model.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserMapper {
    // 根据用户名和密码查询用户
    User selectByUsernameAndPassword(@Param("username") String username, @Param("password") String password, @Param("role") String role);

    // 根据用户名和角色查询用户（用于登录 MD5 比对）
    User selectByUsername(@Param("username") String username, @Param("role") String role);

    // 根据ID查询用户
    User selectById(Integer id);

    // 查询所有用户
    List<User> selectAll();

    // 插入用户
    int insert(User user);

    // 更新用户
    int update(User user);

    // 删除用户
    int delete(Integer id);

    // 根据角色查询用户
    List<User> selectByRole(String role);
    
    // 根据用户名和角色搜索用户
    List<User> searchUsers(@Param("username") String username, @Param("role") String role);
    
    // 分页查询用户
    List<User> selectByPage(@Param("offset") int offset, @Param("size") int size);
    
    // 获取用户总数
    int count();

    // 根据班级ID查询学生
    List<User> selectByClassId(@Param("classId") Integer classId);
}