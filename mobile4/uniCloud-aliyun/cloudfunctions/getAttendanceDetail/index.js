'use strict';
exports.main = async (event, context) => {
    console.log('========== 获取考勤详情开始 ==========');
    console.log('event : ', JSON.stringify(event));
    
    const db = uniCloud.database();
    const attendanceCollection = db.collection('attendance');
    const recordCollection = db.collection('attendance_record');
    
    try {
        const { attendanceId } = event;
        console.log('attendanceId:', attendanceId);
        
        if (!attendanceId) {
            return {
                code: -1,
                message: '缺少考勤ID参数'
            };
        }
        
        console.log('开始查询考勤任务...');
        const attendanceRes = await attendanceCollection.doc(attendanceId).get();
        console.log('考勤任务查询结果:', JSON.stringify(attendanceRes));
        
        if (!attendanceRes.data || attendanceRes.data.length === 0) {
            console.log('考勤任务不存在');
            return {
                code: -1,
                message: '考勤任务不存在'
            };
        }
        
        const attendance = attendanceRes.data[0];
        console.log('考勤任务:', JSON.stringify(attendance));
        
        console.log('开始查询签到记录...');
        const recordRes = await recordCollection.where({
            attendance_id: attendanceId
        }).get();
        console.log('签到记录查询结果:', JSON.stringify(recordRes));
        
        const records = recordRes.data || [];
        console.log('签到记录数量:', records.length);
        
        console.log('========== 获取考勤详情成功 ==========');
        return {
            code: 0,
            message: '查询成功',
            data: {
                attendance: attendance,
                records: records
            }
        };
    } catch (error) {
        console.error('========== 获取考勤详情失败 ==========');
        console.error('错误名称:', error.name);
        console.error('错误消息:', error.message);
        console.error('错误堆栈:', error.stack);
        
        return {
            code: -1,
            message: '获取考勤详情失败: ' + error.message,
            error: error.message
        };
    }
};
