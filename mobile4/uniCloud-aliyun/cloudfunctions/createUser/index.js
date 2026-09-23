'use strict';
exports.main = async (event, context) => {
    console.log('创建教师用户 event : ', event);
    
    const db = uniCloud.database();
    const userCollection = db.collection('user');
    
    try {
        const { username, password, realName, role, phone, email } = event;
        
        const checkResult = await userCollection.where({
            username: username
        }).get();
        
        if (checkResult.data.length > 0) {
            return {
                code: -1,
                message: '用户名已存在'
            };
        }
        
        const userData = {
            username: username,
            password: password,
            real_name: realName,
            role: role,
            phone: phone || '',
            email: email || '',
            create_time: new Date(),
            update_time: new Date(),
            status: 1
        };
        
        const result = await userCollection.add(userData);
        
        return {
            code: 0,
            message: '创建用户成功',
            data: {
                id: result.id,
                ...userData
            }
        };
    } catch (error) {
        console.error('创建用户失败:', error);
        return {
            code: -1,
            message: '创建用户失败',
            error: error.message
        };
    }
};
