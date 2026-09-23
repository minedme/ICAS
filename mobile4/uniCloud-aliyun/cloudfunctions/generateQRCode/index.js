'use strict';
const QRCode = require('qrcode');

exports.main = async (event, context) => {
    console.log('========== 生成二维码开始 ==========');
    console.log('event : ', JSON.stringify(event));
    
    try {
        const { qrCode } = event;
        console.log('qrCode:', qrCode);
        
        if (!qrCode) {
            console.log('缺少二维码内容参数');
            return {
                code: -1,
                message: '缺少二维码内容参数'
            };
        }
        
        console.log('开始生成二维码...');
        console.log('使用qrcode库版本:', require('qrcode/package.json').version);
        
        const qrCodeDataURL = await QRCode.toDataURL(qrCode, {
            width: 400,
            margin: 2,
            color: {
                dark: '#000000',
                light: '#ffffff'
            },
            errorCorrectionLevel: 'M'
        });
        console.log('二维码生成成功，长度:', qrCodeDataURL.length);
        console.log('二维码数据前缀:', qrCodeDataURL.substring(0, 50));
        
        if (!qrCodeDataURL || qrCodeDataURL.length === 0) {
            console.log('二维码数据为空');
            return {
                code: -1,
                message: '二维码生成失败：数据为空'
            };
        }
        
        console.log('========== 生成二维码成功 ==========');
        return {
            code: 0,
            message: '二维码生成成功',
            data: qrCodeDataURL
        };
    } catch (error) {
        console.error('========== 生成二维码失败 ==========');
        console.error('错误名称:', error.name);
        console.error('错误消息:', error.message);
        console.error('错误堆栈:', error.stack);
        
        let errorMessage = '生成二维码失败';
        if (error.message) {
            errorMessage += ': ' + error.message;
        }
        
        return {
            code: -1,
            message: errorMessage,
            error: error.message
        };
    }
};
