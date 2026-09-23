package com.example.demo.mapper;

import com.example.demo.model.ClassInfo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface ClassMapper {
    int insert(ClassInfo classInfo);

    int update(ClassInfo classInfo);

    int delete(Integer id);

    ClassInfo selectById(Integer id);

    ClassInfo selectByCode(@Param("classCode") String classCode);

    List<ClassInfo> selectAll();

    List<ClassInfo> selectByTeacherId(@Param("teacherId") Integer teacherId);

    List<ClassInfo> selectByPage(@Param("offset") int offset, @Param("size") int size);

    int count();

    List<ClassInfo> searchClasses(@Param("className") String className, 
                                @Param("classCode") String classCode, 
                                @Param("major") String major);

    int updateStudentCount(@Param("classId") Integer classId, @Param("count") int count);
}
