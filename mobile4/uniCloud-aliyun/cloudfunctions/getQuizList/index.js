'use strict';
exports.main = async (event, context) => {
    console.log('========== 获取测验列表开始 ==========');
    console.log('event : ', JSON.stringify(event));
    
    const db = uniCloud.database();
    const quizCollection = db.collection('quiz');
    
    try {
        const { teacherId } = event;
        console.log('teacherId:', teacherId);
        
        console.log('开始查询测验列表...');
        let query = quizCollection;
        
        if (teacherId) {
            query = query.where({
                teacher_id: teacherId
            });
        }
        
        const quizRes = await query.orderBy('create_time', 'desc').get();
        console.log('测验列表查询结果:', JSON.stringify(quizRes));
        
        const quizzes = quizRes.data || [];
        console.log('测验数量:', quizzes.length);
        
        console.log('========== 获取测验列表成功 ==========');
        return {
            code: 0,
            message: '查询成功',
            data: quizzes
        };
    } catch (error) {
        console.error('========== 获取测验列表失败 ==========');
        console.error('错误名称:', error.name);
        console.error('错误消息:', error.message);
        console.error('错误堆栈:', error.stack);
        
        return {
            code: -1,
            message: '获取测验列表失败: ' + error.message,
            error: error.message
        };
    }
};
