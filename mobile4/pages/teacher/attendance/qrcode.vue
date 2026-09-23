<template>
  <div class="container">
    <div class="header">
      <button @click="goBack" class="btn-back">返回</button>
      <div class="header-title">考勤二维码</div>
    </div>
    
    <div class="loading" v-if="loading">
      <div class="loading-icon">⏳</div>
      <div class="loading-text">加载中...</div>
    </div>
    
    <div class="qrcode-container" v-else>
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
      
      <div class="qrcode-area">
        <div class="qrcode-wrapper">
          <image v-if="qrCodeImage" :src="qrCodeImage" class="qrcode-image" mode="aspectFit"></image>
          <div v-else class="qrcode-placeholder">
            <div class="placeholder-icon">📱</div>
            <div class="placeholder-text">二维码加载中...</div>
          </div>
        </div>
        <div class="qrcode-tips">请学生扫描此二维码进行签到</div>
      </div>
      
      <div class="actions">
        <button @click="refreshQrCode" class="btn btn-refresh" :disabled="refreshing">
          {{ refreshing ? '刷新中...' : '刷新二维码' }}
        </button>
        <button @click="viewRecords" class="btn btn-records">查看签到记录</button>
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
      qrCodeImage: '',
      loading: true,
      refreshing: false
    }
  },
  onLoad(options) {
    console.log('========== 二维码页面加载 ==========');
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
      console.log('========== 开始加载考勤详情 ==========');
      console.log('attendanceId:', this.attendanceId);
      this.loading = true;
      
      this.$api.getAttendanceDetail(this.attendanceId)
        .then(res => {
          console.log('考勤详情返回结果:', JSON.stringify(res));
          
          if (res.code === 200) {
            this.attendance = res.data.attendance;
            console.log('考勤信息:', JSON.stringify(this.attendance));
            this.generateQRCode(this.attendance.qr_code);
          } else {
            uni.showToast({
              title: res.message,
              icon: 'none'
            });
          }
        })
        .catch(err => {
          console.error('获取考勤详情失败:', err);
          uni.showToast({
            title: '网络错误，请稍后重试',
            icon: 'none'
          });
        })
        .finally(() => {
          this.loading = false;
        });
    },
    
    generateQRCode(qrCode) {
      console.log('========== 开始生成二维码 ==========');
      console.log('qrCode:', qrCode);
      
      uniCloud.callFunction({
        name: 'generateQRCode',
        data: {
          qrCode: qrCode
        },
        success: (res) => {
          console.log('二维码生成结果:', JSON.stringify(res));
          
          if (res.result.code === 0) {
            this.qrCodeImage = res.result.data;
            console.log('二维码图片已设置');
          } else {
            uni.showToast({
              title: res.result.message,
              icon: 'none'
            });
          }
        },
        fail: (err) => {
          console.error('生成二维码失败:', err);
          this.qrCodeImage = '';
          uni.showToast({
            title: '生成二维码失败',
            icon: 'none'
          });
        }
      });
    },
    
    refreshQrCode() {
      console.log('========== 刷新二维码 ==========');
      this.refreshing = true;
      
      this.$api.post('/teacher/attendance/refresh', {
        attendanceId: this.attendanceId
      }).then(res => {
        if (res.code === 200) {
          this.loadAttendanceDetail();
          uni.showToast({
            title: '二维码已刷新',
            icon: 'success'
          });
        } else {
          uni.showToast({
            title: res.message,
            icon: 'none'
          });
        }
      }).catch(err => {
        console.error('刷新二维码失败:', err);
        uni.showToast({
          title: '网络错误，请稍后重试',
          icon: 'none'
        });
      }).finally(() => {
        this.refreshing = false;
      });
    },
    
    viewRecords() {
      uni.navigateTo({
        url: `/pages/teacher/attendance/view?id=${this.attendanceId}`
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

.qrcode-container {
  background-color: white;
  border-radius: 20rpx;
  padding: 30rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.attendance-info {
  margin-bottom: 30rpx;
  padding-bottom: 20rpx;
  border-bottom: 1px solid #f0f0f0;
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

.qrcode-area {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 30rpx;
  padding: 40rpx;
  background-color: #fafafa;
  border-radius: 15rpx;
}

.qrcode-wrapper {
  width: 500rpx;
  height: 500rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: white;
  border-radius: 10rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.qrcode-image {
  width: 100%;
  height: 100%;
}

.qrcode-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: #ccc;
}

.placeholder-icon {
  font-size: 100rpx;
  margin-bottom: 20rpx;
}

.placeholder-text {
  font-size: 28rpx;
}

.qrcode-tips {
  font-size: 28rpx;
  color: #666;
  text-align: center;
}

.actions {
  display: flex;
  gap: 20rpx;
}

.actions .btn {
  flex: 1;
  padding: 25rpx;
  border: none;
  border-radius: 10rpx;
  font-size: 30rpx;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-refresh {
  background-color: #ff9800;
  color: white;
}

.btn-refresh:hover {
  background-color: #fb8c00;
}

.btn-records {
  background-color: #4CAF50;
  color: white;
}

.btn-records:hover {
  background-color: #45a049;
}
</style>
