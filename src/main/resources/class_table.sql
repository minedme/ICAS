-- 创建班级表
CREATE TABLE IF NOT EXISTS class_info (
    id INT PRIMARY KEY AUTO_INCREMENT comment '班级ID',
    class_name VARCHAR(100) NOT NULL comment '班级名称',
    class_code VARCHAR(20) NOT NULL UNIQUE comment '班级代码',
    major VARCHAR(100) NOT NULL comment '专业',
    grade VARCHAR(20) NOT NULL comment '年级',
    teacher_id INT comment '教师ID',
    student_count INT DEFAULT 0 comment '学生数量',
    description TEXT comment '班级描述',
    status INT NOT NULL DEFAULT 1 comment '状态',
    create_time DATETIME NOT NULL comment '创建时间',
    update_time DATETIME NOT NULL comment '更新时间',
    FOREIGN KEY (teacher_id) REFERENCES user(id)
);

-- 为用户表添加班级ID字段
ALTER TABLE user ADD COLUMN class_id INT comment '班级ID';

-- 插入初始班级数据
INSERT INTO class_info (class_name, class_code, major, grade, teacher_id, description, status, create_time, update_time)
VALUES ('软件工程1班', 'SE2024001', '软件工程', '2024级', 2, '软件工程专业2024级1班', 1, NOW(), NOW()),
       ('人工智能1班', 'AI2024001', '人工智能', '2024级', 2, '人工智能专业2024级1班', 1, NOW(), NOW());

-- 更新学生账号的班级ID
-- 更新学生账号的班级ID
UPDATE user SET class_id = 1 WHERE id = 3 comment '将学生账号3分配到软件工程1班';
UPDATE user SET class_id = 1 WHERE id = 4 comment '将学生账号4分配到软件工程1班';
