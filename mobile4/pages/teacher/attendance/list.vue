<template>
  <div class="container">
    <div class="header">
      <div class="header-title">考勤管理</div>
      <button @click="createAttendance" class="btn btn-primary">创建新考勤</button>
    </div>
    
    <div class="filter-bar">
      <select :value="filter" @change="filter = $event.target.value; loadAttendances()" class="select">
        <option value="all">全部考勤</option>
        <option value="active">进行中</option>
        <option value="ended">已结束</option>
      </select>
    </div>
    
    <div class="loading" v-if="loading && attendances.length === 0">
      <div class="loading-icon">⏳</div>
      <div class="loading-text">加载中...</div>
    </div>
    
    <div class="no-data" v-if="attendances.length === 0 && !loading">
      <div class="no-data-icon">📋</div>
      <div class="no-data-text">暂无考勤记录</div>
    </div>
    
    <scroll-view 
      class="attendance-list" 
      scroll-y 
      @refresherrefresh="refresh"
      :refresher-enabled="true"
    >
      <div 
        class="attendance-item" 
        v-for="(attendance, index) in attendances" 
        :key="attendance._id || index"
      >
        <div class="attendance-header">
          <div class="course-name">{{ attendance.course_name || attendance.courseName }}</div>
          <div class="attendance-status" :class="getStatusClass(attendance.status)">
            {{ getStatusText(attendance.status) }}
          </div>
        </div>
        
        <div class="attendance-body">
          <div class="info-item">
            <span class="icon">📅</span>
            <span class="label">开始时间:</span>
            <span class="value">{{ formatDateTime(attendance.start_time || attendance.startTime) }}</span>
          </div>
          <div class="info-item">
            <span class="icon">⏰</span>
            <span class="label">结束时间:</span>
            <span class="value">{{ formatDateTime(attendance.end_time || attendance.endTime) }}</span>
          </div>
          <div class="info-item">
            <span class="icon">📍</span>
            <span class="label">地点:</span>
            <span class="value">{{ attendance.location || '未设置' }}</span>
          </div>
        </div>
        
        <div class="attendance-actions">
          <button @click.stop="viewRecords(attendance._id)" class="btn btn-view">查看记录</button>
          <button 
            v-if="attendance.status === 1" 
            @click.stop="viewQRCode(attendance._id)" 
            class="btn btn-qrcode"
          >
            查看二维码
          </button>
          <button 
            v-if="attendance.status === 1" 
            @click.stop="endAttendance(attendance._id)" 
            class="btn btn-end"
          >
            结束考勤
          </button>
          <button 
            v-if="attendance.status === 0" 
            @click.stop="startAttendance(attendance._id)" 
            class="btn btn-start"
          >
            开始考勤
          </button>
        </div>
      </div>
    </scroll-view>
  </div>
</template>

<script>
export default {
  data() {
    return {
      attendances: [],
      loading: false,
      filter: 'all'
    }
  },
  onShow() {
    this.loadAttendances()
  },
  methods: {
    // 加载考勤列表
    loadAttendances() {
      this.loading = true
      
      const userInfo = uni.getStorageSync('userInfo') || {}
      const teacherId = userInfo.id || 0
      
      this.$api.getAttendanceList(teacherId)
        .then(res => {
          if (res.code === 200) {
            this.attendances = res.data || []
          } else {
            uni.showToast({
              title: res.message,
              icon: 'none'
            })
          }
        })
        .catch(err => {
          console.error('获取考勤列表失败:', err)
          uni.showToast({
            title: '网络错误，请稍后重试',
            icon: 'none'
          })
        })
        .finally(() => {
          this.loading = false
        })
    },
    
    // 下拉刷新
    refresh() {
      this.loadAttendances()
    },
    
    // 创建新考勤
    createAttendance() {
      uni.navigateTo({
        url: '/pages/teacher/attendance/create'
      })
    },
    
    // 查看考勤记录
    viewRecords(id) {
      console.log('========== 点击查看记录 ==========');
      console.log('attendanceId:', id);
      
      if (!id) {
        uni.showToast({
          title: '考勤ID不存在',
          icon: 'none'
        });
        return;
      }
      
      uni.showLoading({
        title: '加载中...'
      });
      
      uni.navigateTo({
        url: `/pages/teacher/attendance/view?id=${id}`,
        success: () => {
          uni.hideLoading();
        },
        fail: (err) => {
          uni.hideLoading();
          console.error('页面跳转失败:', err);
          uni.showToast({
            title: '页面跳转失败',
            icon: 'none'
          });
        }
      });
    },
    
    // 查看二维码
    viewQRCode(id) {
      console.log('========== 点击查看二维码 ==========');
      console.log('attendanceId:', id);
      
      if (!id) {
        uni.showToast({
          title: '考勤ID不存在',
          icon: 'none'
        });
        return;
      }
      
      uni.showLoading({
        title: '加载中...'
      });
      
      uni.navigateTo({
        url: `/pages/teacher/attendance/qrcode?id=${id}`,
        success: () => {
          uni.hideLoading();
        },
        fail: (err) => {
          uni.hideLoading();
          console.error('页面跳转失败:', err);
          uni.showToast({
            title: '页面跳转失败',
            icon: 'none'
          });
        }
      });
    },
    
    // 开始考勤
    startAttendance(id) {
      uni.showModal({
        title: '确认开始考勤',
        content: '确定要开始此考勤吗？',
        success: (res) => {
          if (res.confirm) {
            this.$api.post('/teacher/attendance/start', { id })
              .then(res => {
                if (res.code === 200) {
                  uni.showToast({
                    title: '考勤已开始',
                    icon: 'success'
                  })
                  this.loadAttendances()
                } else {
                  uni.showToast({
                    title: res.message,
                    icon: 'none'
                  })
                }
              })
              .catch(err => {
                console.error('开始考勤失败:', err)
                uni.showToast({
                  title: '网络错误，请稍后重试',
                  icon: 'none'
                })
              })
          }
        }
      })
    },
    
    // 结束考勤
    endAttendance(id) {
      uni.showModal({
        title: '确认结束考勤',
        content: '确定要结束此考勤吗？',
        success: (res) => {
          if (res.confirm) {
            this.$api.post('/teacher/attendance/end', { id })
              .then(res => {
                if (res.code === 200) {
                  uni.showToast({
                    title: '考勤已结束',
                    icon: 'success'
                  })
                  this.loadAttendances()
                } else {
                  uni.showToast({
                    title: res.message,
                    icon: 'none'
                  })
                }
              })
              .catch(err => {
                console.error('结束考勤失败:', err)
                uni.showToast({
                  title: '网络错误，请稍后重试',
                  icon: 'none'
                })
              })
          }
        }
      })
    },
    
    // 获取状态类名
    getStatusClass(status) {
      return status === 1 ? 'active' : 'ended'
    },
    
    // 获取状态文本
    getStatusText(status) {
      return status === 1 ? '进行中' : '已结束'
    },
    
    // 格式化日期时间
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
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
}

.header-title {
  font-size: 40rpx;
  font-weight: bold;
  color: #333;
}

.btn-primary {
  padding: 20rpx 30rpx;
  background-color: #4CAF50;
  color: white;
  border: none;
  border-radius: 10rpx;
  font-size: 28rpx;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-primary:hover {
  background-color: #45a049;
  transform: translateY(-4rpx);
  box-shadow: 0 10rpx 20rpx rgba(76, 175, 80, 0.2);
}

.filter-bar {
  background-color: white;
  padding: 20rpx;
  border-radius: 10rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.filter-bar select {
  width: 100%;
  padding: 15rpx;
  border: 1px solid #ddd;
  border-radius: 8rpx;
  font-size: 30rpx;
  color: #333;
}

.attendance-list {
  height: calc(100vh - 300rpx);
}

.attendance-item {
  background-color: white;
  border-radius: 15rpx;
  padding: 25rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.attendance-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
  padding-bottom: 15rpx;
  border-bottom: 1px solid #f0f0f0;
}

.course-name {
  font-size: 34rpx;
  font-weight: bold;
  color: #333;
}

.attendance-status {
  padding: 10rpx 20rpx;
  border-radius: 20rpx;
  font-size: 24rpx;
  font-weight: bold;
}

.attendance-status.active {
  background-color: #e8f5e9;
  color: #4CAF50;
}

.attendance-status.ended {
  background-color: #ffebee;
  color: #F44336;
}

.attendance-body {
  margin-bottom: 20rpx;
}

.info-item {
  display: flex;
  align-items: center;
  margin-bottom: 15rpx;
  font-size: 28rpx;
  color: #666;
}

.info-item .icon {
  margin-right: 10rpx;
  font-size: 30rpx;
}

.info-item .label {
  margin-right: 10rpx;
  font-weight: bold;
  color: #555;
}

.attendance-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 15rpx;
}

.attendance-actions .btn {
  padding: 15rpx 25rpx;
  border: none;
  border-radius: 10rpx;
  font-size: 26rpx;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s ease;
  flex: 1;
  min-width: 120rpx;
  text-align: center;
}

.btn-view {
  background-color: #4CAF50;
  color: white;
}

.btn-view:hover {
  background-color: #45a049;
}

.btn-qrcode {
  background-color: #ff9800;
  color: white;
}

.btn-qrcode:hover {
  background-color: #fb8c00;
}

.btn-end {
  background-color: #f44336;
  color: white;
}

.btn-end:hover {
  background-color: #e53935;
}

.btn-start {
  background-color: #2196F3;
  color: white;
}

.btn-start:hover {
  background-color: #1976D2;
}

.no-data, .loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 50vh;
  color: #ccc;
}

.no-data-text, .loading-text {
  margin-top: 20rpx;
  font-size: 32rpx;
}
</style>