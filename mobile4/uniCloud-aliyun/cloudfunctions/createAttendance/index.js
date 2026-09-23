'use strict';
exports.main = async (event, context) => {
    console.log('创建考勤 event : ', event);
    
    const db = uniCloud.database();
    const attendanceCollection = db.collection('attendance');
    
    try {
        const { teacherId, courseName, startTime, endTime, location, latitude, longitude, qrCodeExpiry, range } = event;
        
        if (!teacherId || !courseName || !startTime || !endTime) {
            return {
                code: -1,
                message: '缺少必要参数'
            };
        }
        
        const qrCode = generateUUID();
        
        let minLatitude = 0, maxLatitude = 0, minLongitude = 0, maxLongitude = 0;
        if (latitude !== null && longitude !== null && range !== null) {
            const rangeInDegrees = range / 111000.0;
            minLatitude = latitude - rangeInDegrees;
            maxLatitude = latitude + rangeInDegrees;
            minLongitude = longitude - rangeInDegrees;
            maxLongitude = longitude + rangeInDegrees;
        }
        
        const attendanceData = {
            course_name: courseName,
            teacher_id: teacherId,
            start_time: new Date(startTime),
            end_time: new Date(endTime),
            qr_code: qrCode,
            location: location || '',
            min_latitude: minLatitude,
            max_latitude: maxLatitude,
            min_longitude: minLongitude,
            max_longitude: maxLongitude,
            status: 1,
            create_time: new Date()
        };
        
        const result = await attendanceCollection.add(attendanceData);
        
        return {
            code: 0,
            message: '考勤创建成功',
            data: {
                id: result.id,
                ...attendanceData
            }
        };
    } catch (error) {
        console.error('创建考勤失败:', error);
        return {
            code: -1,
            message: '创建考勤失败',
            error: error.message
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
