'use strict';
exports.main = async (event, context) => {
    //event为客户端上传的参数
    console.log('event : ', event);
    
    // 获取数据库实例
    const db = uniCloud.database();
    const userCollection = db.collection('user');
    
    try {
        const { username, password } = event;
        
        // 查询用户
        const res = await userCollection.where({
            username: username,
            password: password
        }).get();
        
        if (res.data.length === 0) {
            return {
                code: -1,
                message: '用户名或密码错误'
            };
        }
        
        const user = res.data[0];
        
        // 返回登录成功结果
        return {
            code: 0,
            message: '登录成功',
            data: {
                id: user._id,
                username: user.username,
                realName: user.realName,
                role: user.role,
                phone: user.phone,
                email: user.email
            }
        };
    } catch (error) {
        // 处理错误
        console.error('登录失败:', error);
        return {
            code: -1,
            message: '登录失败',
            error: error.message
        };
    }
};
