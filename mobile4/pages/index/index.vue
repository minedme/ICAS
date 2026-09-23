<template>
  <div class="container">
    <!-- 用户信息卡片 -->
    <div class="user-card">
      <div class="user-info">
        <div class="user-avatar">
          {{ userInfo.realName.charAt(0) }}
        </div>
        <div class="user-details">
          <div class="user-name">{{ userInfo.realName }}</div>
          <div class="user-role">{{ role }}</div>
          <div class="user-id">{{ role === '学生' ? '学号：' + userInfo.username : '工号：' + userInfo.username }}</div>
        </div>
      </div>
    </div>

    <!-- 功能入口 -->
    <div class="function-grid">
      <div class="function-item" @click="goToScan">
        <div class="function-text">扫码签到</div>
      </div>
      <div class="function-item" @click="goToGPS">
        <div class="function-text">GPS签到</div>
      </div>
      <div class="function-item" @click="goToQuiz">
        <div class="function-text">参加测验</div>
      </div>
      <div class="function-item" @click="goToBullet">
        <div class="function-text">发送弹幕</div>
      </div>
      <div class="function-item" @click="goToRecords">
        <div class="function-text">考勤记录</div>
      </div>
      <div class="function-item" @click="logout">
        <div class="function-text">退出登录</div>
      </div>
    </div>

    <!-- 学习统计 -->
    <div class="stats-card" v-if="role === 'student'">
      <div class="card-title">学习统计</div>
      <div class="stats-grid">
        <div class="stat-item">
          <div class="stat-value">{{ stats.attendanceRate || 0 }}%</div>
          <div class="stat-label">出勤率</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ stats.averageScore || 0 }}</div>
          <div class="stat-label">平均成绩</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ stats.completedQuizzes || 0 }}</div>
          <div class="stat-label">已完成测验</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      userInfo: {},
      role: '',
      stats: {
        attendanceRate: 0,
        averageScore: 0,
        completedQuizzes: 0
      }
    }
  },
  onShow() {
    this.getUserInfo()
  },
  methods: {
    getUserInfo() {
      this.userInfo = uni.getStorageSync('userInfo') || {}
      this.role = uni.getStorageSync('role') || ''
      
      if (this.role === 'student' && this.userInfo.role) {
        this.role = this.userInfo.role
      }
      
      if (this.role === '学生' && this.userInfo.id) {
        this.stats = {
          attendanceRate: 95,
          averageScore: 85,
          completedQuizzes: 12
        }
      }
    },
    goToScan() {
      uni.navigateTo({ url: '/pages/student/attendance/scan' })
    },
    goToGPS() {
      uni.navigateTo({ url: '/pages/student/attendance/gps' })
    },
    goToQuiz() {
      uni.navigateTo({ url: '/pages/student/quiz/list' })
    },
    goToBullet() {
      uni.navigateTo({ url: '/pages/bullet/send' })
    },
    goToRecords() {
      uni.navigateTo({ url: '/pages/student/attendance/records' })
    },
    logout() {
      // 清除用户信息
      uni.removeStorageSync('userInfo')
      uni.removeStorageSync('role')
      // 跳转到登录页面
      uni.redirectTo({ url: '/pages/login/login' })
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

.user-card {
  background-color: white;
  border-radius: 20rpx;
  padding: 30rpx;
  margin-bottom: 30rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.user-info {
  display: flex;
  align-items: center;
}

.user-avatar {
  width: 120rpx;
  height: 120rpx;
  border-radius: 50%;
  background-color: #2196F3;
  color: white;
  font-size: 48rpx;
  font-weight: bold;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 30rpx;
}

.user-details {
  flex: 1;
}

.user-name {
  font-size: 40rpx;
  font-weight: bold;
  margin-bottom: 10rpx;
}

.user-role {
  font-size: 30rpx;
  color: #666;
  margin-bottom: 10rpx;
}

.user-id {
  font-size: 28rpx;
  color: #999;
}

.function-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20rpx;
  margin-bottom: 30rpx;
}

.function-item {
  background-color: white;
  border-radius: 20rpx;
  padding: 30rpx 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.function-icon {
  margin-bottom: 20rpx;
}

.function-text {
  font-size: 30rpx;
  color: #333;
}

.stats-card {
  background-color: white;
  border-radius: 20rpx;
  padding: 30rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.card-title {
  font-size: 36rpx;
  font-weight: bold;
  margin-bottom: 30rpx;
  color: #333;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20rpx;
}

.stat-item {
  text-align: center;
}

.stat-value {
  font-size: 48rpx;
  font-weight: bold;
  color: #2196F3;
  margin-bottom: 10rpx;
}

.stat-label {
  font-size: 28rpx;
  color: #666;
}
</style>