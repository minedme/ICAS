'use strict';
exports.main = async (event, context) => {
    console.log('========== 获取学生考勤记录开始 ==========');
    console.log('event : ', JSON.stringify(event));
    
    const db = uniCloud.database();
    const recordCollection = db.collection('attendance_record');
    const attendanceCollection = db.collection('attendance');
    
    try {
        const { studentId, page = 1, pageSize = 10, filter = 'all' } = event;
        console.log('studentId:', studentId, 'page:', page, 'pageSize:', pageSize, 'filter:', filter);
        
        if (!studentId) {
            console.log('缺少学生ID');
            return {
                code: -1,
                message: '缺少学生ID'
            };
        }
        
        console.log('开始查询签到记录...');
        let query = recordCollection.where({
            student_id: studentId
        });
        
        const skip = (page - 1) * pageSize;
        const recordRes = await query.skip(skip).limit(pageSize).get();
        console.log('签到记录查询结果:', JSON.stringify(recordRes));
        
        const records = [];
        let presentCount = 0;
        
        for (const record of recordRes.data) {
            console.log('开始查询考勤任务...');
            const attendanceRes = await attendanceCollection.doc(record.attendance_id).get();
            console.log('考勤任务查询结果:', JSON.stringify(attendanceRes));
            
            if (attendanceRes.data && attendanceRes.data.length > 0) {
                const attendance = attendanceRes.data[0];
                
                const recordData = {
                    id: record._id,
                    attendanceId: record.attendance_id,
                    studentId: record.student_id,
                    studentName: record.student_name,
                    courseName: attendance.course_name,
                    signTime: record.sign_time,
                    attendanceType: record.sign_type,
                    status: record.status === '正常' ? 1 : record.status === '迟到' ? 2 : 3,
                    latitude: record.latitude,
                    longitude: record.longitude
                };
                
                records.push(recordData);
                
                if (record.status === '正常' || record.status === '早到') {
                    presentCount++;
                }
            }
        }
        
        const totalRes = await recordCollection.where({
            student_id: studentId
        }).count();
        const total = totalRes.total;
        
        const attendanceRate = total > 0 ? Math.round((presentCount / total) * 100) : 0;
        
        console.log('========== 获取学生考勤记录成功 ==========');
        return {
            code: 0,
            message: '获取成功',
            data: {
                records: records,
                total: total,
                attendanceRate: attendanceRate
            }
        };
    } catch (error) {
        console.error('========== 获取学生考勤记录失败 ==========');
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