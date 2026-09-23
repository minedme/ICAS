'use strict';
exports.main = async (event, context) => {
    console.log('========== 初始化课程数据开始 ==========');
    console.log('event : ', JSON.stringify(event));
    
    const db = uniCloud.database();
    const courseCollection = db.collection('course');
    
    try {
        const { teacherId } = event;
        console.log('teacherId:', teacherId);
        
        console.log('开始查询现有课程...');
        const existingRes = await courseCollection.where({
            name: db.command.in(['软件工程', '人工智能'])
        }).get();
        
        console.log('现有课程查询结果:', JSON.stringify(existingRes));
        const existingCourses = existingRes.data || [];
        const existingNames = existingCourses.map(course => course.name);
        console.log('已存在的课程:', existingNames);
        
        const coursesToAdd = [];
        
        if (!existingNames.includes('软件工程')) {
            coursesToAdd.push({
                name: '软件工程',
                teacher_id: teacherId || '',
                description: '软件工程课程',
                create_time: new Date(),
                update_time: new Date()
            });
            console.log('添加课程: 软件工程');
        }
        
        if (!existingNames.includes('人工智能')) {
            coursesToAdd.push({
                name: '人工智能',
                teacher_id: teacherId || '',
                description: '人工智能课程',
                create_time: new Date(),
                update_time: new Date()
            });
            console.log('添加课程: 人工智能');
        }
        
        if (coursesToAdd.length > 0) {
            console.log('开始添加课程...');
            const addRes = await courseCollection.add(coursesToAdd);
            console.log('课程添加结果:', JSON.stringify(addRes));
        } else {
            console.log('所有课程已存在，无需添加');
        }
        
        console.log('========== 初始化课程数据成功 ==========');
        return {
            code: 0,
            message: '课程数据初始化成功',
            data: {
                added: coursesToAdd.length,
                courses: coursesToAdd
            }
        };
    } catch (error) {
        console.error('========== 初始化课程数据失败 ==========');
        console.error('错误名称:', error.name);
        console.error('错误消息:', error.message);
        console.error('错误堆栈:', error.stack);
        
        return {
            code: -1,
            message: '初始化课程数据失败: ' + error.message,
            error: error.message
        };
    }
};
