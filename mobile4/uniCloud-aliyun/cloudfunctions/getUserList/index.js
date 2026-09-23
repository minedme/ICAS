'use strict';
exports.main = async (event, context) => {
	//event为客户端上传的参数
	console.log('event : ', event)
	
	// 获取数据库实例
	const db = uniCloud.database();
	const userCollection = db.collection('user');
	
	try {
		// 查询用户列表
		const res = await userCollection.get();
		
		// 返回查询结果
		return {
			code: 0,
			message: '查询成功',
			data: res.data
		};
	} catch (error) {
		// 处理查询错误
		console.error('查询用户列表失败:', error);
		return {
			code: -1,
			message: '查询失败',
			error: error.message
		};
	}
};
