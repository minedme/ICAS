<template>
  <div id="app">
    <!-- uni-app会自动渲染当前页面内容 -->
  </div>
</template>

<script>
export default {
  onLaunch: function() {
    console.log('App Launch')
    // 检查登录状态
    const userInfo = uni.getStorageSync('userInfo')
    if (!userInfo) {
      uni.navigateTo({ url: '/pages/login/login' })
    }
  },
  onShow: function() {
    console.log('App Show')
  },
  onHide: function() {
    console.log('App Hide')
  }
}
</script>

<style>
/* 全局样式 */
page {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  font-size: 14px;
  color: #333;
  background-color: #f5f5f5;
}

.container {
  padding: 20rpx;
}

.title {
  font-size: 36rpx;
  font-weight: bold;
  margin-bottom: 20rpx;
  text-align: center;
}

.btn {
  width: 100%;
  padding: 20rpx;
  border-radius: 10rpx;
  font-size: 32rpx;
  font-weight: bold;
  background-color: #2196F3;
  color: white;
  border: none;
  margin: 20rpx 0;
}

.input {
  width: 100%;
  padding: 20rpx;
  border: 1px solid #ddd;
  border-radius: 10rpx;
  margin: 20rpx 0;
  font-size: 32rpx;
}

.error {
  color: red;
  font-size: 28rpx;
  margin: 20rpx 0;
}

.success {
  color: green;
  font-size: 28rpx;
  margin: 20rpx 0;
}
</style>