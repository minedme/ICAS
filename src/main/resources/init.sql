-- 创建数据库
CREATE DATABASE IF NOT EXISTS icas4 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE icas;

-- 创建用户表
CREATE TABLE IF NOT EXISTS user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(50) NOT NULL,
    real_name VARCHAR(50) NOT NULL comment '真实姓名',
    role VARCHAR(20) NOT NULL comment '角色',
    phone VARCHAR(20) comment '手机号',
    email VARCHAR(50) comment '邮箱',
    class_id INT comment '班级ID',
    create_time DATETIME NOT NULL comment '创建时间',
    update_time DATETIME NOT NULL comment '更新时间',
    status INT NOT NULL DEFAULT 1 comment '状态'
);

-- 创建考勤任务表
CREATE TABLE IF NOT EXISTS attendance (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    teacher_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    qr_code VARCHAR(100) NOT NULL UNIQUE comment '二维码',
    location VARCHAR(200) comment '地点',
    min_latitude DOUBLE comment '最小纬度',
    max_latitude DOUBLE comment '最大纬度',
    min_longitude DOUBLE comment '最小经度',
    max_longitude DOUBLE comment '最大经度',
    status INT NOT NULL DEFAULT 1 comment '考勤状态',
    create_time DATETIME NOT NULL comment '创建时间',
    FOREIGN KEY (teacher_id) REFERENCES user(id) comment '教师外键'
);

-- 创建考勤记录表
CREATE TABLE IF NOT EXISTS attendance_record (
    id INT PRIMARY KEY AUTO_INCREMENT comment '考勤记录ID',
    attendance_id INT NOT NULL comment '考勤任务ID',
    student_id INT NOT NULL comment '学生ID',
    attendance_type VARCHAR(20) NOT NULL comment '考勤类型',
    attendance_time DATETIME NOT NULL comment '考勤时间',
    latitude DOUBLE comment '纬度',
    longitude DOUBLE comment '经度',
    status VARCHAR(20) NOT NULL comment '状态',
    remark VARCHAR(200) comment '备注',
    FOREIGN KEY (attendance_id) REFERENCES attendance(id) comment '考勤任务外键',
    FOREIGN KEY (student_id) REFERENCES user(id) comment '学生外键' 
);

-- 创建测验表
CREATE TABLE IF NOT EXISTS quiz (
    id INT PRIMARY KEY AUTO_INCREMENT comment '测验ID',
    title VARCHAR(100) NOT NULL comment '测验标题',
    teacher_id INT NOT NULL comment '教师ID',
    course_name VARCHAR(100) NOT NULL comment '课程名称',
    start_time DATETIME NOT NULL comment '开始时间',
    end_time DATETIME NOT NULL comment '结束时间',
    status INT NOT NULL DEFAULT 1 comment '测验状态',
    create_time DATETIME NOT NULL comment '创建时间',
    FOREIGN KEY (teacher_id) REFERENCES user(id) comment '教师外键'
);

-- 创建测验问题表
CREATE TABLE IF NOT EXISTS quiz_question (
    id INT PRIMARY KEY AUTO_INCREMENT comment '问题ID',
    quiz_id INT NOT NULL comment '测验ID',
    content TEXT NOT NULL comment '问题内容',
    type VARCHAR(20) NOT NULL comment '问题类型',
    option_a VARCHAR(200) comment '选项A',
    option_b VARCHAR(200) comment '选项B',
    option_c VARCHAR(200) comment '选项C',
    option_d VARCHAR(200) comment '选项D',
    correct_answer VARCHAR(20) NOT NULL comment '正确答案',
    score INT NOT NULL DEFAULT 10 comment '分数',
    FOREIGN KEY (quiz_id) REFERENCES quiz(id) comment '测验外键'
);

-- 修改quiz_question表的content字段类型为TEXT（如果已存在）
ALTER TABLE quiz_question MODIFY COLUMN content TEXT NOT NULL;

-- 创建测验答案表
CREATE TABLE IF NOT EXISTS quiz_answer (
    id INT PRIMARY KEY AUTO_INCREMENT comment '测验答案ID',
    quiz_id INT NOT NULL comment '测验ID',
    student_id INT NOT NULL comment '学生ID',
    question_id INT NOT NULL comment '问题ID',
    student_answer VARCHAR(20) NOT NULL comment '学生答案',
    is_correct BOOLEAN NOT NULL comment '是否正确',
    score INT NOT NULL DEFAULT 0 comment '分数',
    answer_time DATETIME NOT NULL comment '回答时间',
    FOREIGN KEY (quiz_id) REFERENCES quiz(id) comment '测验外键',
    FOREIGN KEY (student_id) REFERENCES user(id) comment '学生外键',
    FOREIGN KEY (question_id) REFERENCES quiz_question(id) comment '问题外键'
);

-- 创建弹幕表
CREATE TABLE IF NOT EXISTS bullet_screen (
    id INT PRIMARY KEY AUTO_INCREMENT comment '弹幕ID',
    content VARCHAR(200) NOT NULL comment '弹幕内容',
    user_id INT NOT NULL comment '用户ID',
    is_anonymous BOOLEAN NOT NULL DEFAULT FALSE comment '是否匿名',
    create_time DATETIME NOT NULL comment '创建时间',
    FOREIGN KEY (user_id) REFERENCES user(id)
);

-- 创建课程表
CREATE TABLE IF NOT EXISTS course (
    id INT PRIMARY KEY AUTO_INCREMENT comment '课程ID',
    course_name VARCHAR(100) NOT NULL comment '课程名称',
    teacher_id INT NOT NULL comment '教师ID',
    course_code VARCHAR(20) NOT NULL UNIQUE comment '课程编码',
    credit INT NOT NULL comment '学分',
    description TEXT comment '课程描述',
    status INT NOT NULL DEFAULT 1 comment '状态',
    create_time DATETIME NOT NULL comment '创建时间',
    update_time DATETIME NOT NULL comment '更新时间',
    FOREIGN KEY (teacher_id) REFERENCES user(id) comment '教师外键'
);

-- 创建班级表
CREATE TABLE IF NOT EXISTS class_info (
    id INT PRIMARY KEY AUTO_INCREMENT comment '班级ID',
    class_name VARCHAR(100) NOT NULL comment '班级名称',
    class_code VARCHAR(20) NOT NULL UNIQUE comment '班级编码',
    major VARCHAR(100) NOT NULL comment '专业',
    grade VARCHAR(20) NOT NULL comment '年级',
    teacher_id INT comment '教师ID',
    student_count INT DEFAULT 0 comment '学生数量',
    description TEXT comment '班级描述',
    status INT NOT NULL DEFAULT 1 comment '状态',
    create_time DATETIME NOT NULL comment '创建时间',
    update_time DATETIME NOT NULL comment '更新时间',
    FOREIGN KEY (teacher_id) REFERENCES user(id) comment '教师外键'
);

-- 插入初始数据：管理员账号
INSERT INTO user (username, password, real_name, role, phone, email, create_time, update_time, status)
VALUES ('admin', 'admin123', '管理员', 'admin', '13800138000', 'admin@example.com', NOW(), NOW(), 1);

-- 插入初始数据：教师账号
INSERT INTO user (username, password, real_name, role, phone, email, create_time, update_time, status)
VALUES ('teacher001', 'teacher123', '张老师', 'teacher', '13800138001', 'teacher@example.com', NOW(), NOW(), 1);

-- 插入初始数据：学生账号
INSERT INTO user (username, password, real_name, role, phone, email, create_time, update_time, status)
VALUES ('student001', 'student123', '李同学', 'student', '13800138002', 'student@example.com', NOW(), NOW(), 1),
       ('student002', 'student123', '王同学', 'student', '13800138003', 'student2@example.com', NOW(), NOW(), 1);

-- 插入初始数据：班级
INSERT INTO class_info (class_name, class_code, major, grade, teacher_id, description, status, create_time, update_time)
VALUES ('软件工程1班', 'SE2024001', '软件工程', '2024级', 2, '软件工程专业2024级1班', 1, NOW(), NOW()),
       ('人工智能1班', 'AI2024001', '人工智能', '2024级', 2, '人工智能专业2024级1班', 1, NOW(), NOW());

-- 插入初始数据：考勤任务
INSERT INTO attendance (course_name, teacher_id, start_time, end_time, qr_code, 
                       min_latitude, max_latitude, min_longitude, max_longitude, 
                       status, create_time)
VALUES ('Java程序设计', 2, NOW(), DATE_ADD(NOW(), INTERVAL 2 HOUR), 'qrcode1234567890', 
        39.9042, 39.9052, 116.4074, 116.4084, 1, NOW());

-- 插入初始数据：弹幕
INSERT INTO bullet_screen (content, user_id, is_anonymous, create_time)
VALUES ('老师讲得真好！', 3, FALSE, NOW()),
       ('这个知识点我不太懂', 4, TRUE, NOW());

-- 为考勤任务表添加文件路径列
ALTER TABLE attendance ADD COLUMN file_path VARCHAR(200);

-- 为考勤记录表添加文件路径列
ALTER TABLE attendance_record ADD COLUMN file_path VARCHAR(200);
