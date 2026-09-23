<template>
  <view class="gps-page">
    <view class="title-bar">GPS签到</view>
    
    <view class="form-area">
      <view class="form-item">
        <text class="label">选择考勤任务</text>
        <picker 
          class="picker" 
          mode="selector" 
          :range="attendanceOptions" 
          @change="handleAttendanceChange"
        >
          <view>{{ selectedAttendanceName }}</view>
        </picker>
      </view>
      
      <view class="location-info" v-if="location">
        <text class="location-title">当前位置</text>
        <view class="location-details">
          <text>经度: {{ location.longitude }}</text>
          <text>纬度: {{ location.latitude }}</text>
          <text>精度: {{ location.accuracy }}米</text>
        </view>
      </view>
      
      <view class="status-info" v-if="status">
        <text class="status-text" :class="status.success ? 'success' : 'error'">{{ status.message }}</text>
      </view>
    </view>
    
    <view class="btn-area">
      <button @click="getLocation" class="location-btn" :disabled="loading">
        {{ loading ? '获取位置中...' : '获取当前位置' }}
      </button>
      <button @click="gpsSign" class="sign-btn" :disabled="!location || !selectedAttendanceId || loading">
        {{ loading ? '签到中...' : 'GPS签到' }}
      </button>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      location: null,
      status: null,
      loading: false,
      userInfo: uni.getStorageSync('userInfo') || {},
      role: uni.getStorageSync('role') || '',
      attendances: [],
      attendanceOptions: [],
      selectedAttendanceId: null,
      selectedAttendanceName: '请选择考勤任务'
    }
  },
  onShow() {
    if (this.role === '学生') {
      this.loadAttendances()
    }
  },
  methods: {
    loadAttendances() {
      this.$api.getAttendanceList(0)
        .then(res => {
          if (res.code === 200) {
            this.attendances = res.data
            this.attendanceOptions = res.data.map(item => item.course_name)
          }
        }).catch(err => {
          console.error('加载考勤列表失败:', err)
        })
    },
    
    handleAttendanceChange(e) {
      const index = e.detail.value
      if (this.attendances[index]) {
        this.selectedAttendanceId = this.attendances[index].id
        this.selectedAttendanceName = this.attendances[index].courseName
      }
    },
    
    getLocation() {
      this.loading = true
      this.status = null
      
      uni.getLocation({
        type: 'gcj02',
        altitude: true,
        success: (res) => {
          this.location = res
          this.status = {
            success: true,
            message: '位置获取成功'
          }
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
    
    gpsSign() {
      if (!this.location) {
        this.status = {
          success: false,
          message: '请先获取位置信息'
        }
        return
      }
      
      if (!this.selectedAttendanceId) {
        this.status = {
          success: false,
          message: '请选择考勤任务'
        }
        return
      }
      
      this.loading = true
      this.status = null
      
      this.$api.gpsSign(this.selectedAttendanceId, this.userInfo.id, this.location.latitude, this.location.longitude)
        .then(res => {
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
        })
        .catch(err => {
          console.error('签到失败:', err)
          this.status = {
            success: false,
            message: '网络错误，请稍后重试'
          }
        })
        .finally(() => {
          this.loading = false
        })
    }
  }
}
</script>

<style scoped>
.gps-page {
  padding: 20rpx 40rpx;
  background-color: #fff;
  min-height: 100vh;
}
.title-bar {
  font-size: 36rpx;
  font-weight: bold;
  text-align: center;
  padding: 30rpx 0;
  color: #333;
}
.form-area {
  margin-bottom: 40rpx;
}
.form-item {
  margin-bottom: 30rpx;
}
.label {
  font-size: 28rpx;
  color: #666;
  margin-bottom: 10rpx;
  display: block;
}
.picker {
  width: 100%;
  padding: 20rpx;
  border: 1px solid #ddd;
  border-radius: 10rpx;
  font-size: 30rpx;
  background-color: #f9f9f9;
}
.location-info {
  background-color: #fafafa;
  border-radius: 10rpx;
  padding: 20rpx;
  margin-bottom: 20rpx;
}
.location-title {
  font-size: 30rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 15rpx;
  display: block;
}
.location-details {
  font-size: 28rpx;
  color: #666;
  line-height: 1.5;
}
.location-details text {
  display: block;
  margin-bottom: 10rpx;
}
.status-info {
  margin-bottom: 20rpx;
  padding: 20rpx;
  border-radius: 10rpx;
}
.status-text {
  font-size: 30rpx;
  text-align: center;
}
.status-text.success {
  color: #4CAF50;
}
.status-text.error {
  color: #F44336;
}
.btn-area {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
}
.location-btn,
.sign-btn {
  height: 80rpx;
  line-height: 80rpx;
  background-color: #409eff;
  color: #fff;
  border-radius: 10rpx;
  font-size: 30rpx;
}
.sign-btn {
  background-color: #4CAF50;
}
</style>