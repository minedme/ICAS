'use strict';
exports.main = async (event, context) => {
    console.log('========== 获取课程列表开始 ==========');
    console.log('event : ', JSON.stringify(event));
    
    const db = uniCloud.database();
    const courseCollection = db.collection('course');
    
    try {
        const { teacherId } = event;
        console.log('teacherId:', teacherId);
        
        console.log('开始查询课程列表...');
        let query = courseCollection;
        
        if (teacherId) {
            query = query.where({
                teacher_id: teacherId
            });
        }
        
        const courseRes = await query.orderBy('create_time', 'desc').get();
        console.log('课程列表查询结果:', JSON.stringify(courseRes));
        
        let courses = courseRes.data || [];
        console.log('课程数量:', courses.length);
        
        if (courses.length === 0) {
            console.log('课程列表为空，返回默认课程');
            courses = [
                {
                    _id: 'course_default_1',
                    name: '软件工程',
                    teacher_id: teacherId || '',
                    create_time: new Date()
                },
                {
                    _id: 'course_default_2',
                    name: '人工智能',
                    teacher_id: teacherId || '',
                    create_time: new Date()
                }
            ];
            console.log('默认课程:', JSON.stringify(courses));
        }
        
        console.log('========== 获取课程列表成功 ==========');
        return {
            code: 0,
            message: '查询成功',
            data: courses
        };
    } catch (error) {
        console.error('========== 获取课程列表失败 ==========');
        console.error('错误名称:', error.name);
        console.error('错误消息:', error.message);
        console.error('错误堆栈:', error.stack);
        
        return {
            code: -1,
            message: '获取课程列表失败: ' + error.message,
            error: error.message
        };
    }
};
