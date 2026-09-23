'use strict';
exports.main = async (event, context) => {
    console.log('========== 初始化数据开始 ==========');
    console.log('event : ', JSON.stringify(event));
    console.log('context : ', JSON.stringify(context));
    
    const db = uniCloud.database();
    console.log('数据库实例创建成功');
    
    const userCollection = db.collection('user');
    const attendanceCollection = db.collection('attendance');
    console.log('集合引用创建成功');
    
    try {
        const results = [];
        
        const { username, password, realName, role } = event;
        console.log('接收到的参数:', { username, password, realName, role });
        
        console.log('开始查询用户...');
        const checkUserResult = await userCollection.where({
            username: username
        }).get();
        console.log('查询用户结果:', JSON.stringify(checkUserResult));
        
        let userId;
        if (checkUserResult.data.length > 0) {
            userId = checkUserResult.data[0]._id;
            console.log('用户已存在，ID:', userId);
            results.push({
                action: '用户已存在',
                username: username,
                userId: userId
            });
        } else {
            console.log('开始创建新用户...');
            const userData = {
                username: username,
                password: password,
                real_name: realName,
                role: role,
                phone: '13800138999',
                email: 'teacher12345678@example.com',
                create_time: new Date(),
                update_time: new Date(),
                status: 1
            };
            console.log('用户数据:', JSON.stringify(userData));
            
            const userResult = await userCollection.add(userData);
            userId = userResult.id;
            console.log('用户创建成功，ID:', userId, '完整结果:', JSON.stringify(userResult));
            
            results.push({
                action: '创建用户成功',
                username: username,
                userId: userId
            });
        }
        
        const now = new Date();
        const tomorrow = new Date(now.getTime() + 24 * 60 * 60 * 1000);
        const nextWeek = new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000);
        console.log('时间设置:', { now, tomorrow, nextWeek });
        
        console.log('开始创建第一个考勤任务...');
        const qrCode1 = generateUUID();
        console.log('生成二维码1:', qrCode1);
        
        const attendance1Data = {
            course_name: '软件工程',
            teacher_id: userId,
            start_time: now,
            end_time: nextWeek,
            qr_code: qrCode1,
            location: '教学楼A301室',
            min_latitude: 39.9041,
            max_latitude: 39.9043,
            min_longitude: 116.4073,
            max_longitude: 116.4075,
            status: 1,
            create_time: now
        };
        console.log('考勤1数据:', JSON.stringify(attendance1Data));
        
        const attendance1Result = await attendanceCollection.add(attendance1Data);
        console.log('考勤1创建成功，ID:', attendance1Result.id, '完整结果:', JSON.stringify(attendance1Result));
        
        results.push({
            action: '创建考勤成功',
            courseName: '软件工程',
            attendanceId: attendance1Result.id,
            qrCode: qrCode1
        });
        
        console.log('开始创建第二个考勤任务...');
        const qrCode2 = generateUUID();
        console.log('生成二维码2:', qrCode2);
        
        const attendance2Data = {
            course_name: '人工智能',
            teacher_id: userId,
            start_time: tomorrow,
            end_time: nextWeek,
            qr_code: qrCode2,
            location: '教学楼B302室',
            min_latitude: 39.9041,
            max_latitude: 39.9043,
            min_longitude: 116.4073,
            max_longitude: 116.4075,
            status: 1,
            create_time: now
        };
        console.log('考勤2数据:', JSON.stringify(attendance2Data));
        
        const attendance2Result = await attendanceCollection.add(attendance2Data);
        console.log('考勤2创建成功，ID:', attendance2Result.id, '完整结果:', JSON.stringify(attendance2Result));
        
        results.push({
            action: '创建考勤成功',
            courseName: '人工智能',
            attendanceId: attendance2Result.id,
            qrCode: qrCode2
        });
        
        console.log('========== 初始化数据成功 ==========');
        console.log('返回结果:', JSON.stringify(results));
        
        return {
            code: 0,
            message: '初始化数据成功',
            data: results
        };
    } catch (error) {
        console.error('========== 初始化数据失败 ==========');
        console.error('错误名称:', error.name);
        console.error('错误消息:', error.message);
        console.error('错误堆栈:', error.stack);
        console.error('完整错误对象:', JSON.stringify(error));
        
        return {
            code: -1,
            message: '初始化数据失败: ' + error.message,
            error: error.message,
            errorName: error.name,
            errorStack: error.stack
        };
    }
};

function generateUUID() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        const r = Math.random() * 16 | 0;
        const v = c === 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}
