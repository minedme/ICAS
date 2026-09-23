<template>
  <div class="container">
    <div class="header">
      <button @click="goBack" class="btn-back">返回</button>
      <div class="header-title">考勤记录</div>
    </div>
    
    <div class="loading" v-if="loading">
      <div class="loading-icon">⏳</div>
      <div class="loading-text">加载中...</div>
    </div>
    
    <div class="content" v-else>
      <div class="attendance-info">
        <div class="info-title">{{ attendance.course_name || attendance.courseName }}</div>
        <div class="info-item">
          <span class="label">开始时间:</span>
          <span class="value">{{ formatDateTime(attendance.start_time || attendance.startTime) }}</span>
        </div>
        <div class="info-item">
          <span class="label">结束时间:</span>
          <span class="value">{{ formatDateTime(attendance.end_time || attendance.endTime) }}</span>
        </div>
        <div class="info-item">
          <span class="label">地点:</span>
          <span class="value">{{ attendance.location || '未设置' }}</span>
        </div>
      </div>
      
      <div class="statistics">
        <div class="stat-item">
          <div class="stat-value">{{ records.length }}</div>
          <div class="stat-label">总签到人数</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ scanCount }}</div>
          <div class="stat-label">二维码签到</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ gpsCount }}</div>
          <div class="stat-label">GPS签到</div>
        </div>
      </div>
      
      <div class="no-data" v-if="records.length === 0">
        <div class="no-data-icon">📋</div>
        <div class="no-data-text">暂无签到记录</div>
      </div>
      
      <div class="record-list" v-else>
        <div class="record-item" v-for="(record, index) in records" :key="record._id || index">
          <div class="record-header">
            <div class="student-name">{{ record.student_name || record.studentName || '未知学生' }}</div>
            <div class="sign-type" :class="record.sign_type === 'scan' || record.signType === 'scan' ? 'scan' : 'gps'">
              {{ record.sign_type === 'scan' || record.signType === 'scan' ? '二维码签到' : 'GPS签到' }}
            </div>
          </div>
          <div class="record-body">
            <div class="info-item">
              <span class="icon">📅</span>
              <span class="label">签到时间:</span>
              <span class="value">{{ formatDateTime(record.sign_time || record.signTime) }}</span>
            </div>
            <div class="info-item" v-if="record.sign_type === 'gps' || record.signType === 'gps'">
              <span class="icon">📍</span>
              <span class="label">位置:</span>
              <span class="value">{{ record.latitude }}, {{ record.longitude }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      attendanceId: null,
      attendance: {},
      records: [],
      loading: true
    }
  },
  computed: {
    scanCount() {
      return this.records.filter(r => r.sign_type === 'scan' || r.signType === 'scan').length
    },
    gpsCount() {
      return this.records.filter(r => r.sign_type === 'gps' || r.signType === 'gps').length
    }
  },
  onLoad(options) {
    console.log('========== 考勤记录页面加载 ==========');
    console.log('options:', JSON.stringify(options));
    
    if (options.id) {
      this.attendanceId = options.id;
      console.log('attendanceId:', this.attendanceId);
      this.loadAttendanceDetail();
    } else {
      uni.showToast({
        title: '参数错误',
        icon: 'none'
      });
      uni.navigateBack();
    }
  },
  methods: {
    loadAttendanceDetail() {
      this.loading = true
      
      this.$api.getAttendanceDetail(this.attendanceId)
        .then(res => {
          if (res.code === 200) {
            this.attendance = res.data.attendance
            this.records = res.data.records || []
          } else {
            uni.showToast({
              title: res.message,
              icon: 'none'
            })
          }
        })
        .catch(err => {
          console.error('获取考勤记录失败:', err)
          uni.showToast({
            title: '网络错误，请稍后重试',
            icon: 'none'
          })
        })
        .finally(() => {
          this.loading = false
        })
    },
    
    goBack() {
      uni.navigateBack()
    },
    
    formatDateTime(dateString) {
      if (!dateString) return ''
      const date = new Date(dateString)
      return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')} ${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}`
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

.header {
  display: flex;
  align-items: center;
  margin-bottom: 30rpx;
}

.btn-back {
  padding: 15rpx 30rpx;
  background-color: #2196F3;
  color: white;
  border: none;
  border-radius: 10rpx;
  font-size: 28rpx;
  font-weight: bold;
  cursor: pointer;
}

.header-title {
  flex: 1;
  text-align: center;
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
}

.loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 50vh;
  color: #ccc;
}

.loading-icon {
  font-size: 80rpx;
  margin-bottom: 20rpx;
}

.loading-text {
  font-size: 32rpx;
}

.content {
  padding-bottom: 40rpx;
}

.attendance-info {
  background-color: white;
  border-radius: 15rpx;
  padding: 25rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.info-title {
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 20rpx;
}

.info-item {
  display: flex;
  align-items: center;
  margin-bottom: 15rpx;
  font-size: 28rpx;
}

.info-item .label {
  font-weight: bold;
  color: #555;
  margin-right: 10rpx;
  min-width: 140rpx;
}

.info-item .value {
  color: #666;
}

.statistics {
  display: flex;
  justify-content: space-between;
  background-color: white;
  border-radius: 15rpx;
  padding: 25rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.stat-item {
  flex: 1;
  text-align: center;
}

.stat-value {
  font-size: 48rpx;
  font-weight: bold;
  color: #4CAF50;
  margin-bottom: 10rpx;
}

.stat-label {
  font-size: 26rpx;
  color: #666;
}

.no-data {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 30vh;
  color: #ccc;
}

.no-data-icon {
  font-size: 100rpx;
  margin-bottom: 20rpx;
}

.no-data-text {
  font-size: 32rpx;
}

.record-list {
  display: flex;
  flex-direction: column;
  gap: 15rpx;
}

.record-item {
  background-color: white;
  border-radius: 15rpx;
  padding: 25rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.record-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15rpx;
  padding-bottom: 15rpx;
  border-bottom: 1px solid #f0f0f0;
}

.student-name {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.sign-type {
  padding: 8rpx 16rpx;
  border-radius: 20rpx;
  font-size: 24rpx;
  font-weight: bold;
}

.sign-type.scan {
  background-color: #e8f5e9;
  color: #4CAF50;
}

.sign-type.gps {
  background-color: #e3f2fd;
  color: #2196F3;
}

.record-body {
  margin-top: 15rpx;
}

.record-body .info-item {
  font-size: 26rpx;
  color: #666;
}

.record-body .icon {
  margin-right: 10rpx;
  font-size: 28rpx;
}

.record-body .label {
  font-weight: bold;
  color: #555;
  margin-right: 10rpx;
}
</style>
