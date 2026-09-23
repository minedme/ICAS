<template>
  <div class="container">
    <div class="header">
      <div class="header-title">数据分析</div>
    </div>
    
    <div class="filter-section">
      <div class="filter-group">
        <select :value="selectedCourseId" @change="selectedCourseId = $event.target.value; loadAnalysisData()" class="select">
          <option value="">选择课程</option>
          <option v-for="course in courses" :key="course.id" :value="course.id">{{ course.name }}</option>
        </select>
      </div>
    </div>
    
    <div v-if="loading" class="loading">
      <div class="loading-text">加载中...</div>
    </div>
    
    <div v-else-if="!selectedCourseId" class="empty">
      <div class="empty-text">请选择要查看的课程</div>
    </div>
    
    <div v-else class="analysis-content">
      <div class="section attendance-section">
        <div class="section-title">考勤分析</div>
        
        <div class="stat-card">
          <div class="stat-number">{{ attendanceAnalysis.totalSessions }}</div>
          <div class="stat-label">考勤总次数</div>
        </div>
        
        <div class="stat-card">
          <div class="stat-number">{{ attendanceAnalysis.totalStudents }}</div>
          <div class="stat-label">参与学生数</div>
        </div>
        
        <div class="stat-card">
          <div class="stat-number">{{ attendanceAnalysis.averageAttendanceRate.toFixed(1) }}%</div>
          <div class="stat-label">平均出勤率</div>
        </div>
        
        <div class="chart-container">
          <div class="chart-title">最近考勤记录</div>
          <div class="attendance-list">
            <div v-for="record in attendanceAnalysis.recentSessions" :key="record.id" class="attendance-item">
              <div class="session-date">{{ formatDate(record.date) }}</div>
              <div class="session-rate">
                <div class="rate-bar">
                  <div class="rate-fill" :style="{ width: record.attendanceRate + '%' }"></div>
                </div>
                <div class="rate-text">{{ record.attendanceRate }}%</div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <div class="section quiz-section">
        <div class="section-title">测验分析</div>
        
        <div v-if="quizAnalysis.length === 0" class="empty">
          <div class="empty-text">暂无测验数据</div>
        </div>
        
        <div v-else class="quiz-list">
          <div class="quiz-item" v-for="quiz in quizAnalysis" :key="quiz.id" @click="viewQuizDetails(quiz.id)">
            <div class="quiz-title">{{ quiz.title }}</div>
            <div class="quiz-stats">
              <div class="quiz-stat">
                <span class="stat-value">{{ quiz.totalParticipants }}</span>
                <span class="stat-label">参与人数</span>
              </div>
              <div class="quiz-stat">
                <span class="stat-value">{{ quiz.averageScore.toFixed(1) }}</span>
                <span class="stat-label">平均分数</span>
              </div>
              <div class="quiz-stat">
                <span class="stat-value">{{ quiz.passRate.toFixed(1) }}%</span>
                <span class="stat-label">通过率</span>
              </div>
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
      selectedCourseId: '',
      courses: [],
      attendanceAnalysis: {
        totalSessions: 0,
        totalStudents: 0,
        averageAttendanceRate: 0,
        recentSessions: []
      },
      quizAnalysis: [],
      loading: false
    }
  },
  onLoad() {
    this.loadCourses()
  },
  methods: {
    loadCourses() {
      this.$api.get('/teacher/courses')
        .then(res => {
          if (res.code === 200) {
            this.courses = res.data
          }
        })
        .catch(err => {
          console.error('加载课程列表失败:', err)
          uni.showToast({
            title: '加载课程失败',
            icon: 'none'
          })
        })
    },
    
    loadAnalysisData() {
      if (!this.selectedCourseId) {
        return
      }
      
      this.loading = true
      const params = {
        courseId: this.selectedCourseId
      }
      
      this.$api.get('/teacher/analysis', params)
        .then(res => {
          if (res.code === 200) {
            this.attendanceAnalysis = res.data.attendance
            this.quizAnalysis = res.data.quizzes
          }
        })
        .catch(err => {
          console.error('加载分析数据失败:', err)
          uni.showToast({
            title: '加载数据失败',
            icon: 'none'
          })
        })
        .finally(() => {
          this.loading = false
        })
    },
    
    viewQuizDetails(quizId) {
      uni.navigateTo({
        url: `/pages/teacher/quiz/analysis?id=${quizId}`
      })
    },
    
    formatDate(dateString) {
      const date = new Date(dateString)
      return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`
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
  background-color: white;
  padding: 30rpx;
  border-radius: 15rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  margin-bottom: 30rpx;
}

.header-title {
  font-size: 40rpx;
  font-weight: bold;
  color: #333;
}

.filter-section {
  background-color: white;
  padding: 20rpx 30rpx;
  border-radius: 15rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  margin-bottom: 30rpx;
}

.filter-group {
  display: flex;
  gap: 20rpx;
}

.select {
  padding: 20rpx;
  border: 1px solid #ddd;
  border-radius: 10rpx;
  font-size: 28rpx;
  background-color: #f9f9f9;
  width: 100%;
}

.loading, .empty {
  padding: 100rpx;
  text-align: center;
  background-color: white;
  border-radius: 15rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.loading-text, .empty-text {
  color: #666;
  font-size: 30rpx;
}

.analysis-content {
  background-color: white;
  border-radius: 15rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.section {
  padding: 30rpx;
  border-bottom: 1px solid #eee;
}

.section:last-child {
  border-bottom: none;
}

.section-title {
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 30rpx;
}

.stat-card {
  display: inline-block;
  width: 32%;
  background-color: #f9f9f9;
  padding: 30rpx;
  border-radius: 15rpx;
  text-align: center;
  margin-right: 2%;
  margin-bottom: 30rpx;
}

.stat-card:nth-child(3n) {
  margin-right: 0;
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

.chart-container {
  margin-top: 30rpx;
}

.chart-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 20rpx;
}

.attendance-list {
  background-color: #f9f9f9;
  border-radius: 10rpx;
  padding: 20rpx;
}

.attendance-item {
  margin-bottom: 20rpx;
  padding-bottom: 20rpx;
  border-bottom: 1px solid #eee;
}

.attendance-item:last-child {
  margin-bottom: 0;
  padding-bottom: 0;
  border-bottom: none;
}

.session-date {
  font-size: 28rpx;
  color: #333;
  margin-bottom: 10rpx;
}

.session-rate {
  display: flex;
  align-items: center;
  gap: 20rpx;
}

.rate-bar {
  flex: 1;
  height: 20rpx;
  background-color: #e0e0e0;
  border-radius: 10rpx;
  overflow: hidden;
}

.rate-fill {
  height: 100%;
  background-color: #4CAF50;
  border-radius: 10rpx;
  transition: width 0.3s ease;
}

.rate-text {
  font-size: 28rpx;
  font-weight: bold;
  color: #4CAF50;
  min-width: 80rpx;
  text-align: right;
}

.quiz-list {
  background-color: #f9f9f9;
  border-radius: 10rpx;
  padding: 20rpx;
}

.quiz-item {
  background-color: white;
  padding: 30rpx;
  border-radius: 10rpx;
  margin-bottom: 20rpx;
  cursor: pointer;
  transition: all 0.3s ease;
}

.quiz-item:hover {
  box-shadow: 0 10rpx 20rpx rgba(0, 0, 0, 0.1);
}

.quiz-title {
  font-size: 34rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 20rpx;
}

.quiz-stats {
  display: flex;
  justify-content: space-around;
}

.quiz-stat {
  text-align: center;
}

.stat-value {
  display: block;
  font-size: 40rpx;
  font-weight: bold;
  color: #2196F3;
  margin-bottom: 5rpx;
}

.stat-label {
  font-size: 24rpx;
  color: #666;
}
</style>