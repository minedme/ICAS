<template>
  <div class="container">
    <div class="scan-header">
      <div class="scan-title">扫码签到</div>
      <button @click="startScan" class="scan-btn">开始扫码</button>
    </div>
    <div class="scan-result" v-if="result">
      <div class="result-content" :class="{ success: result.code === 200, error: result.code !== 200 }">
        {{ result.message }}
      </div>
    </div>
    <div class="scan-tips">
      <p>1. 请对准教师端生成的二维码</p>
      <p>2. 确保网络连接正常</p>
      <p>3. 签到成功后会收到提示</p>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      result: null
    }
  },
  methods: {
    startScan() {
      // 调用uni-app扫码API
      uni.scanCode({
        success: (res) => {
          // 扫码成功，获取二维码内容
          const qrCode = res.result
          // 调用签到API
          this.scanSign(qrCode)
        },
        fail: (err) => {
          uni.showToast({
            title: '扫码失败',
            icon: 'none'
          })
        }
      })
    },
    scanSign(qrCode) {
      const userInfo = uni.getStorageSync('userInfo')
      if (!userInfo || !userInfo.id) {
        uni.showToast({
          title: '请先登录',
          icon: 'none'
        })
        return
      }
      
      this.$api.scanSign(qrCode, userInfo.id)
        .then(res => {
          this.result = res
          uni.showToast({
            title: res.message,
            icon: res.code === 200 ? 'success' : 'none',
            duration: 2000
          })
        })
        .catch(err => {
          this.result = {
            code: 500,
            message: '网络错误，请稍后重试'
          }
          uni.showToast({
            title: '网络错误',
            icon: 'none'
          })
        })
    }
  }
}
</script>

<style scoped>
.container {
  padding: 20rpx;
  min-height: 100vh;
  background-color: #f5f5f5;
}

.scan-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30rpx;
}

.scan-title {
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
}

.scan-btn {
  padding: 15rpx 30rpx;
  background-color: #2196F3;
  color: white;
  border: none;
  border-radius: 10rpx;
  font-size: 30rpx;
}

.scan-result {
  margin-bottom: 30rpx;
}

.result-content {
  padding: 20rpx;
  border-radius: 10rpx;
  font-size: 32rpx;
  text-align: center;
}

.result-content.success {
  background-color: #e8f5e9;
  color: #4CAF50;
}

.result-content.error {
  background-color: #ffebee;
  color: #F44336;
}

.scan-tips {
  background-color: white;
  padding: 20rpx;
  border-radius: 10rpx;
}

.scan-tips p {
  font-size: 28rpx;
  color: #666;
  margin: 10rpx 0;
}
</style>