<template>
  <view class="attendance-page">
    <view class="title-bar">创建考勤</view>
    
    <view class="form-area">
      <view class="form-item">
        <text class="label">课程名称</text>
        <input 
          type="text" 
          placeholder="请输入课程名称" 
          v-model="formData.courseName"
        />
      </view>
      
      <view class="form-item">
        <text class="label">开始时间</text>
        <picker mode="date" :value="formData.startDate" @change="handleStartDateChange" class="picker">
          <view>{{ formData.startDate || '选择开始日期' }}</view>
        </picker>
        <picker mode="time" :value="formData.startTime" @change="handleStartTimeChange" class="picker">
          <view>{{ formData.startTime || '选择开始时间' }}</view>
        </picker>
      </view>
      
      <view class="form-item">
        <text class="label">结束时间</text>
        <picker mode="date" :value="formData.endDate" @change="handleEndDateChange" class="picker">
          <view>{{ formData.endDate || '选择结束日期' }}</view>
        </picker>
        <picker mode="time" :value="formData.endTime" @change="handleEndTimeChange" class="picker">
          <view>{{ formData.endTime || '选择结束时间' }}</view>
        </picker>
      </view>
      
      <view class="form-item">
        <text class="label">考勤地点</text>
        <input 
          type="text" 
          placeholder="如：教学楼B301室" 
          v-model="formData.location"
        />
      </view>
      
      <view class="form-item">
        <text class="label">纬度</text>
        <input 
          type="text" 
          placeholder="自动获取" 
          v-model="formData.latitude"
        />
      </view>
      
      <view class="form-item">
        <text class="label">经度</text>
        <input 
          type="text" 
          placeholder="自动获取" 
          v-model="formData.longitude"
        />
      </view>
      
      <view class="form-item">
        <text class="label">二维码有效期(秒)</text>
        <input 
          type="number" 
          v-model="formData.qrCodeExpiry"
        />
      </view>
      
      <view class="form-item">
        <text class="label">GPS范围验证(米)</text>
        <input 
          type="number" 
          v-model="formData.range"
        />
      </view>
    </view>
    
    <view class="btn-area">
      <button class="submit-btn" @click="createAttendance" :disabled="isLoading">
        {{ isLoading ? '创建中...' : '创建考勤' }}
      </button>
      <button class="cancel-btn" @click="cancel">取消</button>
    </view>
    
    <view v-if="error" class="error-text">{{ error }}</view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      formData: {
        courseName: '',
        startDate: '',
        startTime: '',
        endDate: '',
        endTime: '',
        location: '',
        latitude: '',
        longitude: '',
        qrCodeExpiry: 300,
        range: 50
      },
      isLoading: false,
      error: ''
    }
  },
  onLoad() {
    // 自动获取当前时间作为默认值
    const now = new Date()
    
    // 设置开始日期和时间
    this.formData.startDate = now.toISOString().slice(0, 10)
    this.formData.startTime = now.toTimeString().slice(0, 5)
    
    // 设置结束日期和时间（30分钟后）
    const endTime = new Date(now.getTime() + 30 * 60 * 1000)
    this.formData.endDate = endTime.toISOString().slice(0, 10)
    this.formData.endTime = endTime.toTimeString().slice(0, 5)
    
    // 尝试获取当前位置
    this.getLocation()
  },
  methods: {
    handleStartDateChange(e) {
      this.formData.startDate = e.detail.value
    },
    handleStartTimeChange(e) {
      this.formData.startTime = e.detail.value
    },
    handleEndDateChange(e) {
      this.formData.endDate = e.detail.value
    },
    handleEndTimeChange(e) {
      this.formData.endTime = e.detail.value
    },
    // 获取当前位置
    getLocation() {
      uni.getLocation({
        type: 'gcj02',
        success: (res) => {
          this.formData.latitude = res.latitude
          this.formData.longitude = res.longitude
        },
        fail: (err) => {
          console.error('获取位置失败:', err)
        }
      })
    },
    
    // 创建考勤
    createAttendance() {
      // 表单验证
      if (!this.formData.courseName.trim()) {
        this.error = '请输入课程名称'
        return
      }
      
      if (!this.formData.startDate || !this.formData.startTime || !this.formData.endDate || !this.formData.endTime) {
        this.error = '请选择开始时间和结束时间'
        return
      }
      
      const startDateTime = new Date(`${this.formData.startDate} ${this.formData.startTime}`)
      const endDateTime = new Date(`${this.formData.endDate} ${this.formData.endTime}`)
      
      if (startDateTime >= endDateTime) {
        this.error = '开始时间必须早于结束时间'
        return
      }
      
      this.isLoading = true
      this.error = ''
      
      // 获取教师ID
      const userInfo = uni.getStorageSync('userInfo')
      
      // 构建提交数据
      const submitData = {
        teacherId: userInfo.id,
        courseName: this.formData.courseName,
        startTime: `${this.formData.startDate} ${this.formData.startTime}`,
        endTime: `${this.formData.endDate} ${this.formData.endTime}`,
        location: this.formData.location,
        latitude: this.formData.latitude,
        longitude: this.formData.longitude,
        qrCodeExpiry: this.formData.qrCodeExpiry,
        range: this.formData.range
      }
      
      // 调用后端API创建考勤
      this.$api.createAttendance(submitData)
        .then(res => {
          if (res.code === 200) {
            uni.showToast({
              title: '考勤创建成功',
              icon: 'success'
            })
            // 返回考勤列表页面
            uni.navigateBack()
          } else {
            this.error = res.message
          }
        })
        .catch(err => {
          console.error('创建考勤失败:', err)
          this.error = '网络错误，请稍后重试'
        })
        .finally(() => {
          this.isLoading = false
        })
    },
    
    // 取消操作
    cancel() {
      uni.navigateBack()
    }
  }
}
</script>

<style scoped>
.attendance-page {
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
  margin-bottom: 10rpx;
}
.btn-area {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
}
.submit-btn {
  height: 80rpx;
  line-height: 80rpx;
  background-color: #409eff;
  color: #fff;
  border-radius: 10rpx;
  font-size: 30rpx;
}
.cancel-btn {
  height: 80rpx;
  line-height: 80rpx;
  background-color: #f5f5f5;
  color: #666;
  border-radius: 10rpx;
  font-size: 30rpx;
}
.error-text {
  color: #f44336;
  font-size: 28rpx;
  text-align: center;
  margin-top: 20rpx;
}
</style>