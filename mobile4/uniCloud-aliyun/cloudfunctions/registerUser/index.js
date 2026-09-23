'use strict';
exports.main = async (event, context) => {
    //event为客户端上传的参数
    console.log('event : ', event);
    
    // 获取数据库实例
    const db = uniCloud.database();
    const userCollection = db.collection('user');
    
    try {
        // 获取用户数据
        const userData = event.user;
        
        // 检查用户名是否已存在
        const checkResult = await userCollection.where({
            username: userData.username
        }).get();
        
        if (checkResult.data.length > 0) {
            return {
                code: -1,
                message: '用户名已存在'
            };
        }
        
        // 插入用户数据
        const insertResult = await userCollection.add(userData);
        
        // 返回结果
        return {
            code: 0,
            message: '注册成功',
            data: insertResult
        };
    } catch (error) {
        // 处理错误
        console.error('注册失败:', error);
        return {
            code: -1,
            message: '注册失败',
            error: error.message
        };
    }
};
