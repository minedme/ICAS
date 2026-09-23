'use strict';
exports.main = async (event, context) => {
    console.log('========== 获取学生测验列表开始 ==========');
    console.log('event : ', JSON.stringify(event));
    
    const db = uniCloud.database();
    const quizCollection = db.collection('quiz');
    const recordCollection = db.collection('quiz_record');
    
    try {
        const { studentId, page = 1, pageSize = 10, filter = 'all' } = event;
        console.log('studentId:', studentId, 'page:', page, 'pageSize:', pageSize, 'filter:', filter);
        
        const skip = (page - 1) * pageSize;
        console.log('开始查询测验列表...');
        const quizRes = await quizCollection.skip(skip).limit(pageSize).get();
        console.log('测验列表查询结果:', JSON.stringify(quizRes));
        
        const quizzes = [];
        const now = new Date();
        
        for (const quiz of quizRes.data) {
            let status = 'pending';
            let statusText = '未开始';
            
            const startTime = new Date(quiz.start_time);
            const endTime = new Date(quiz.end_time);
            
            if (now < startTime) {
                status = 'pending';
                statusText = '未开始';
            } else if (now > endTime) {
                status = 'completed';
                statusText = '已结束';
            } else {
                status = 'ongoing';
                statusText = '进行中';
            }
            
            console.log('开始查询参与人数...');
            const recordRes = await recordCollection.where({
                quiz_id: quiz._id
            }).count();
            const participantCount = recordRes.total;
            
            const quizData = {
                id: quiz._id,
                title: quiz.title,
                courseName: quiz.course_name,
                startTime: quiz.start_time,
                endTime: quiz.end_time,
                duration: quiz.duration,
                description: quiz.description,
                status: status,
                statusText: statusText,
                participantCount: participantCount,
                questionCount: quiz.questions ? quiz.questions.length : 0
            };
            
            quizzes.push(quizData);
        }
        
        const totalRes = await quizCollection.count();
        const total = totalRes.total;
        
        console.log('========== 获取学生测验列表成功 ==========');
        return {
            code: 0,
            message: '获取成功',
            data: {
                quizzes: quizzes,
                total: total
            }
        };
    } catch (error) {
        console.error('========== 获取学生测验列表失败 ==========');
        console.error('错误名称:', error.name);
        console.error('错误消息:', error.message);
        console.error('错误堆栈:', error.stack);
        
        return {
            code: -1,
            message: '获取失败: ' + error.message,
            error: error.message
        };
    }
};