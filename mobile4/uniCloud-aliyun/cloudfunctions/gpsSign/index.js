'use strict';
exports.main = async (event, context) => {
    console.log('========== GPS签到开始 ==========');
    console.log('event : ', JSON.stringify(event));
    
    const db = uniCloud.database();
    const attendanceCollection = db.collection('attendance');
    const recordCollection = db.collection('attendance_record');
    const userCollection = db.collection('user');
    
    try {
        const { attendanceId, studentId, latitude, longitude } = event;
        console.log('attendanceId:', attendanceId, 'studentId:', studentId, 'latitude:', latitude, 'longitude:', longitude);
        
        if (!attendanceId || !studentId || !latitude || !longitude) {
            console.log('缺少必要参数');
            return {
                code: -1,
                message: '缺少必要参数'
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
        
        console.log('开始查询学生信息...');
        const studentRes = await userCollection.doc(studentId).get();
        console.log('学生信息查询结果:', JSON.stringify(studentRes));
        
        if (!studentRes.data || studentRes.data.length === 0) {
            console.log('学生不存在');
            return {
                code: -1,
                message: '学生不存在'
            };
        }
        
        const student = studentRes.data[0];
        console.log('学生信息:', JSON.stringify(student));
        
        console.log('开始查询签到记录...');
        const recordRes = await recordCollection.where({
            attendance_id: attendanceId,
            student_id: studentId
        }).get();
        console.log('签到记录查询结果:', JSON.stringify(recordRes));
        
        if (recordRes.data.length > 0) {
            console.log('学生已签到');
            return {
                code: -1,
                message: '您已签到'
            };
        }
        
        let status = '缺勤';
        if (latitude >= attendance.min_latitude && latitude <= attendance.max_latitude &&
            longitude >= attendance.min_longitude && longitude <= attendance.max_longitude) {
            const now = new Date();
            const startTime = new Date(attendance.start_time);
            const endTime = new Date(attendance.end_time);
            
            if (now >= startTime && now <= endTime) {
                status = '正常';
            } else if (now > endTime) {
                status = '迟到';
            }
        }
        
        console.log('开始创建签到记录...');
        const recordData = {
            attendance_id: attendanceId,
            student_id: studentId,
            student_name: student.real_name,
            sign_type: 'gps',
            sign_time: new Date(),
            latitude: latitude,
            longitude: longitude,
            status: status
        };
        console.log('签到记录数据:', JSON.stringify(recordData));
        
        await recordCollection.add(recordData);
        console.log('签到记录创建成功');
        
        console.log('========== GPS签到成功 ==========');
        return {
            code: 0,
            message: '签到成功'
        };
    } catch (error) {
        console.error('========== GPS签到失败 ==========');
        console.error('错误名称:', error.name);
        console.error('错误消息:', error.message);
        console.error('错误堆栈:', error.stack);
        
        return {
            code: -1,
            message: '签到失败: ' + error.message,
            error: error.message
        };
    }
};
