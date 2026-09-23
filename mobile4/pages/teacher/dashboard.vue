<template>
  <div class="container">
    <scroll-view 
      scroll-y 
      class="scroll-container"
      @refresherrefresh="refreshStatistics"
      :refresher-enabled="true"
      :refresher-triggered="isLoading"
    >
      <div class="header">
        <div class="header-title">教师仪表盘</div>
        <div class="user-info">
          <span class="user-name">{{ userName }}</span>
          <button @click="logout" class="logout-btn">退出登录</button>
        </div>
      </div>
      
      <div class="statistic-section">
        <div class="stat-card attendance-card">
          <div class="stat-icon">📋</div>
          <div class="stat-number">{{ attendanceTotalCount }}</div>
          <div class="stat-label">考勤课程总数</div>
        </div>
        <div class="stat-card quiz-card">
          <div class="stat-icon">📚</div>
          <div class="stat-number">{{ quizTotalCount }}</div>
          <div class="stat-label">测验总数</div>
        </div>
        <div class="stat-card active-card">
          <div class="stat-icon">📊</div>
          <div class="stat-number">{{ activeQuizCount }}</div>
          <div class="stat-label">进行中的测验</div>
        </div>
      </div>
      
      <div class="menu-section">
        <div class="menu-title">功能菜单</div>
        <div class="menu-grid">
          <div class="menu-item" @click="navigateTo('/pages/teacher/attendance/list')">
            <div class="menu-icon">📋</div>
            <div class="menu-text">考勤管理</div>
          </div>
          <div class="menu-item" @click="navigateTo('/pages/teacher/attendance/create')">
            <div class="menu-icon">📝</div>
            <div class="menu-text">创建考勤</div>
          </div>
          <div class="menu-item" @click="navigateTo('/pages/teacher/quiz/list')">
            <div class="menu-icon">📚</div>
            <div class="menu-text">测验管理</div>
          </div>
          <div class="menu-item" @click="navigateTo('/pages/teacher/quiz/create')">
            <div class="menu-icon">➕</div>
            <div class="menu-text">创建测验</div>
          </div>
          <div class="menu-item" @click="navigateTo('/pages/teacher/analysis')">
            <div class="menu-icon">📊</div>
            <div class="menu-text">数据分析</div>
          </div>
        </div>
      </div>
    </scroll-view>
  </div>
</template>

<script>
export default {
  data() {
    return {
      userName: '',
      attendanceTotalCount: 0,
      quizTotalCount: 0,
      activeQuizCount: 0,
      isLoading: false
    }
  },
  onShow() {
    console.log('========== 仪表盘页面显示 ==========');
    this.getUserInfo();
    this.loadStatistics();
  },
  onLoad() {
    this.getUserInfo();
    this.loadStatistics();
  },
  methods: {
    getUserInfo() {
      const userInfo = uni.getStorageSync('userInfo')
      if (userInfo) {
        this.userName = userInfo.realName || userInfo.username
      }
    },
    
    loadStatistics() {
      console.log('========== 开始加载统计数据 ==========');
      this.isLoading = true;
      
      const userInfo = uni.getStorageSync('userInfo') || {};
      const teacherId = userInfo.id || 0;
      console.log('teacherId:', teacherId);
      
      Promise.all([
        this.loadAttendanceCount(teacherId),
        this.loadQuizCount(teacherId),
        this.loadActiveQuizCount(teacherId)
      ]).then(([attendanceCount, quizCount, activeCount]) => {
        console.log('统计数据加载完成:', { attendanceCount, quizCount, activeCount });
        this.attendanceTotalCount = attendanceCount;
        this.quizTotalCount = quizCount;
        this.activeQuizCount = activeCount;
      }).catch(err => {
        console.error('加载统计数据失败:', err);
        uni.showToast({
          title: '加载统计数据失败',
          icon: 'none'
        });
      }).finally(() => {
        this.isLoading = false;
      });
    },
    
    loadAttendanceCount(teacherId) {
      console.log('开始加载考勤总数...');
      return new Promise((resolve, reject) => {
        this.$api.getAttendanceList(teacherId)
          .then(res => {
            if (res.code === 200) {
              const count = res.data ? res.data.length : 0;
              console.log('考勤总数:', count);
              resolve(count);
            } else {
              resolve(0);
            }
          })
          .catch(err => {
            console.error('加载考勤总数失败:', err);
            resolve(0);
          });
      });
    },
    
    loadQuizCount(teacherId) {
      console.log('开始加载测验总数...');
      return new Promise((resolve, reject) => {
        this.$api.get('/teacher/quiz/list')
          .then(res => {
            if (res.code === 200) {
              const count = res.data ? res.data.length : 0;
              console.log('测验总数:', count);
              resolve(count);
            } else {
              resolve(0);
            }
          })
          .catch(err => {
            console.error('加载测验总数失败:', err);
            resolve(0);
          });
      });
    },
    
    loadActiveQuizCount(teacherId) {
      console.log('开始加载进行中的测验数...');
      return new Promise((resolve, reject) => {
        this.$api.get('/teacher/quiz/list')
          .then(res => {
            if (res.code === 200) {
              const activeCount = res.data ? res.data.filter(quiz => quiz.status === 'published' || quiz.status === 1).length : 0;
              console.log('进行中的测验数:', activeCount);
              resolve(activeCount);
            } else {
              resolve(0);
            }
          })
          .catch(err => {
            console.error('加载进行中的测验数失败:', err);
            resolve(0);
          });
      });
    },
    
    refreshStatistics() {
      console.log('========== 下拉刷新统计数据 ==========');
      this.loadStatistics();
    },
    
    navigateTo(path) {
      uni.navigateTo({
        url: path
      })
    },
    
    logout() {
      uni.showModal({
        title: '提示',
        content: '确定要退出登录吗？',
        success: (res) => {
          if (res.confirm) {
            // 清除登录信息
            uni.removeStorageSync('userInfo')
            uni.removeStorageSync('token')
            // 跳转到登录页面
            uni.reLaunch({
              url: '/pages/login/login'
            })
          }
        }
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

.scroll-container {
  height: 100vh;
}

.header {
  background-color: white;
  padding: 30rpx;
  border-radius: 15rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  margin-bottom: 30rpx;
}

.header-title {
  font-size: 44rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 20rpx;
}

.user-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.user-name {
  font-size: 32rpx;
  color: #666;
}

.logout-btn {
  padding: 10rpx 20rpx;
  background-color: #f44336;
  color: white;
  border: none;
  border-radius: 8rpx;
  font-size: 28rpx;
  cursor: pointer;
}

.statistic-section {
  margin-bottom: 30rpx;
}

.stat-card {
  background-color: white;
  padding: 30rpx;
  border-radius: 15rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  margin-bottom: 20rpx;
  text-align: center;
  transition: all 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-4rpx);
  box-shadow: 0 10rpx 20rpx rgba(0, 0, 0, 0.15);
}

.stat-icon {
  font-size: 60rpx;
  margin-bottom: 15rpx;
}

.stat-number {
  font-size: 60rpx;
  font-weight: bold;
  color: #4CAF50;
  margin-bottom: 10rpx;
}

.stat-label {
  font-size: 28rpx;
  color: #666;
}

.attendance-card .stat-number {
  color: #2196F3;
}

.quiz-card .stat-number {
  color: #ff9800;
}

.active-card .stat-number {
  color: #4CAF50;
}

.menu-section {
  background-color: white;
  padding: 30rpx;
  border-radius: 15rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.menu-title {
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 30rpx;
}

.menu-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20rpx;
}

.menu-item {
  background-color: #f9f9f9;
  padding: 30rpx 20rpx;
  border-radius: 15rpx;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 1px solid #ddd;
}

.menu-item:hover {
  background-color: #e8f5e9;
  transform: translateY(-4rpx);
  box-shadow: 0 10rpx 20rpx rgba(76, 175, 80, 0.1);
  border-color: #4CAF50;
}

.menu-icon {
  font-size: 60rpx;
  margin-bottom: 10rpx;
}

.menu-text {
  font-size: 28rpx;
  color: #333;
  font-weight: bold;
}
</style>