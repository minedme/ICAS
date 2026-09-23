'use strict';
exports.main = async (event, context) => {
    console.log('获取考勤列表 event : ', event);
    
    const db = uniCloud.database();
    const attendanceCollection = db.collection('attendance');
    
    try {
        const { teacherId } = event;
        
        let query = attendanceCollection;
        if (teacherId) {
            query = query.where({
                teacher_id: teacherId
            });
        }
        
        const res = await query.orderBy('create_time', 'desc').get();
        
        return {
            code: 0,
            message: '查询成功',
            data: res.data
        };
    } catch (error) {
        console.error('获取考勤列表失败:', error);
        return {
            code: -1,
            message: '获取考勤列表失败',
            error: error.message
        };
    }
};
