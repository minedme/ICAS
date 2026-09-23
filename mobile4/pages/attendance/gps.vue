<template>
  <div class="container">
    <div class="location-info" v-if="location">
      <div class="location-title">当前位置</div>
      <div class="location-details">
        <div>经度: {{ location.longitude }}</div>
        <div>纬度: {{ location.latitude }}</div>
        <div>精度: {{ location.accuracy }}米</div>
      </div>
    </div>
    <div class="status-info" v-if="status">
      <div class="status-text" :class="status.success ? 'success' : 'error'">{{ status.message }}</div>
    </div>
    <button @click="getLocation" class="btn" :disabled="loading">
      <span v-if="loading">获取位置中...</span>
      <span v-else>获取当前位置</span>
    </button>
    <button @click="gpsSign" class="btn" :disabled="!location || loading">
      <span v-if="loading">签到中...</span>
      <span v-else>GPS签到</span>
    </button>
  </div>
</template>

<script>
export default {
  data() {
    return {
      location: null,
      status: null,
      loading: false,
      userInfo: uni.getStorageSync('userInfo') || {},
      role: uni.getStorageSync('role') || ''
    }
  },
  onShow() {
    // 页面显示时自动获取位置
    this.getLocation()
  },
  methods: {
    getLocation() {
      this.loading = true
      this.status = null
      
      // 调用uni-app的位置API
      uni.getLocation({
        type: 'gcj02', // 国家测绘局坐标系
        altitude: true, // 高精度定位
        success: (res) => {
          this.location = res
          this.status = {
            success: true,
            message: '位置获取成功，正在检查是否在教室范围内...'
          }
          
          // 可以在这里调用后端API检查是否在教室范围内
          this.checkLocation(res.longitude, res.latitude)
        },
        fail: (err) => {
          console.error('获取位置失败:', err)
          this.status = {
            success: false,
            message: '位置获取失败，请检查GPS权限设置'
          }
          this.location = null
        },
        complete: () => {
          this.loading = false
        }
      })
    },
    
    checkLocation(longitude, latitude) {
      // 这里可以调用后端API检查是否在教室范围内
      // 暂时模拟检查
      setTimeout(() => {
        this.status = {
          success: true,
          message: '您已在教室范围内，可以进行签到'
        }
      }, 1000)
    },
    
    gpsSign() {
      if (!this.location) {
        this.status = {
          success: false,
          message: '请先获取位置信息'
        }
        return
      }
      
      this.loading = true
      this.status = null
      
      // 调用GPS签到API
      this.$api.post('/mobile/attendance/gps', {
        studentId: this.userInfo.id,
        longitude: this.location.longitude,
        latitude: this.location.latitude,
        accuracy: this.location.accuracy
      }).then(res => {
        if (res.code === 200) {
          this.status = {
            success: true,
            message: '签到成功！'
          }
        } else {
          this.status = {
            success: false,
            message: res.message
          }
        }
      }).catch(err => {
        console.error('签到失败:', err)
        this.status = {
          success: false,
          message: '网络错误，请稍后重试'
        }
      }).finally(() => {
        this.loading = false
      })
    }
  }
}
</script>

<style scoped>
.container {
  padding: 20rpx;
  background-color: #f5f5f5;
  min-height: 100vh;
}

.location-info {
  background-color: white;
  border-radius: 20rpx;
  padding: 30rpx;
  margin-bottom: 30rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.location-title {
  font-size: 36rpx;
  font-weight: bold;
  margin-bottom: 20rpx;
  color: #333;
}

.location-details {
  font-size: 32rpx;
  color: #666;
  line-height: 1.5;
}

.status-info {
  margin-bottom: 30rpx;
  padding: 20rpx;
  border-radius: 10rpx;
}

.status-text {
  font-size: 32rpx;
  text-align: center;
}

.status-text.success {
  color: #4CAF50;
}

.status-text.error {
  color: #F44336;
}

.btn {
  width: 100%;
  padding: 25rpx;
  border-radius: 15rpx;
  font-size: 32rpx;
  font-weight: bold;
  background-color: #2196F3;
  color: white;
  border: none;
  margin: 20rpx 0;
  box-sizing: border-box;
}

.btn:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}
</style>