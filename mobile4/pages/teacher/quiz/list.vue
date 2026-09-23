<template>
  <div class="container">
    <div class="header">
      <div class="header-title">测验管理</div>
      <button @click="navigateToCreate" class="create-btn">创建测验</button>
    </div>
    
    <div class="filter-section">
      <div class="filter-group">
        <select :value="filterStatus" @change="handleFilterChange" class="select">
          <option value="">全部状态</option>
          <option value="draft">草稿</option>
          <option value="published">已发布</option>
          <option value="completed">已结束</option>
        </select>
      </div>
    </div>
    
    <div class="quiz-list">
      <div v-if="loading" class="loading">
        <div class="loading-text">加载中...</div>
      </div>
      
      <div v-else-if="quizzes.length === 0" class="empty">
        <div class="empty-text">暂无测验</div>
        <button @click="navigateToCreate" class="empty-btn">创建第一个测验</button>
      </div>
      
      <div v-else class="quiz-item" v-for="quiz in quizzes" :key="quiz.id" @click="viewQuiz(quiz.id)">
        <div class="quiz-header">
          <div class="quiz-title">{{ quiz.title }}</div>
          <div class="quiz-status" :class="quiz.status">
            {{ getStatusText(quiz.status) }}
          </div>
        </div>
        
        <div class="quiz-info">
          <div class="info-item">
            <span class="info-label">课程：</span>
            <span class="info-value">{{ quiz.courseName }}</span>
          </div>
          <div class="info-item">
            <span class="info-label">问题数量：</span>
            <span class="info-value">{{ quiz.questionCount }}</span>
          </div>
          <div class="info-item">
            <span class="info-label">创建时间：</span>
            <span class="info-value">{{ formatDate(quiz.createTime) }}</span>
          </div>
          <div class="info-item">
            <span class="info-label">参与人数：</span>
            <span class="info-value">{{ quiz.participantCount }}</span>
          </div>
        </div>
        
        <div class="quiz-actions">
          <button @click.stop="editQuiz(quiz.id)" class="action-btn edit-btn">编辑</button>
          <button @click.stop="deleteQuiz(quiz.id)" class="action-btn delete-btn">删除</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      quizzes: [],
      loading: false,
      filterStatus: ''
    }
  },
  onLoad() {
    this.loadQuizzes()
  },
  onShow() {
    // 页面显示时重新加载数据
    this.loadQuizzes()
  },
  methods: {
    handleFilterChange(e) {
      this.filterStatus = e.target.value
      this.loadQuizzes()
    },
    
    loadQuizzes() {
      this.loading = true
      const params = {
        status: this.filterStatus
      }
      
      this.$api.get('/teacher/quiz/list', params)
        .then(res => {
          if (res.code === 200) {
            this.quizzes = res.data
          }
        })
        .catch(err => {
          console.error('加载测验列表失败:', err)
          uni.showToast({
            title: '加载失败',
            icon: 'none'
          })
        })
        .finally(() => {
          this.loading = false
        })
    },
    
    navigateToCreate() {
      uni.navigateTo({
        url: '/pages/teacher/quiz/create'
      })
    },
    
    viewQuiz(quizId) {
      uni.navigateTo({
        url: `/pages/teacher/quiz/detail?id=${quizId}`
      })
    },
    
    editQuiz(quizId) {
      uni.navigateTo({
        url: `/pages/teacher/quiz/create?id=${quizId}`
      })
    },
    
    deleteQuiz(quizId) {
      uni.showModal({
        title: '提示',
        content: '确定要删除这个测验吗？',
        success: (res) => {
          if (res.confirm) {
            this.$api.delete(`/teacher/quiz/${quizId}`)
              .then(res => {
                if (res.code === 200) {
                  uni.showToast({
                    title: '删除成功',
                    icon: 'success'
                  })
                  // 重新加载测验列表
                  this.loadQuizzes()
                }
              })
              .catch(err => {
                console.error('删除测验失败:', err)
                uni.showToast({
                  title: '删除失败',
                  icon: 'none'
                })
              })
          }
        }
      })
    },
    
    getStatusText(status) {
      const statusMap = {
        draft: '草稿',
        published: '已发布',
        completed: '已结束'
      }
      return statusMap[status] || status
    },
    
    formatDate(dateString) {
      const date = new Date(dateString)
      return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`
    }
  },
  watch: {
    filterStatus() {
      this.loadQuizzes()
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
  background-color: white;
  padding: 30rpx;
  border-radius: 15rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  margin-bottom: 20rpx;
}

.header-title {
  font-size: 40rpx;
  font-weight: bold;
  color: #333;
}

.create-btn {
  padding: 20rpx 40rpx;
  background-color: #4CAF50;
  color: white;
  border: none;
  border-radius: 10rpx;
  font-size: 28rpx;
  cursor: pointer;
}

.filter-section {
  background-color: white;
  padding: 20rpx 30rpx;
  border-radius: 15rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  margin-bottom: 20rpx;
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
}

.quiz-list {
  background-color: white;
  border-radius: 15rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.loading {
  padding: 100rpx;
  text-align: center;
}

.loading-text {
  color: #666;
  font-size: 30rpx;
}

.empty {
  padding: 100rpx;
  text-align: center;
}

.empty-text {
  color: #999;
  font-size: 30rpx;
  margin-bottom: 30rpx;
}

.empty-btn {
  padding: 20rpx 40rpx;
  background-color: #4CAF50;
  color: white;
  border: none;
  border-radius: 10rpx;
  font-size: 28rpx;
  cursor: pointer;
}

.quiz-item {
  padding: 30rpx;
  border-bottom: 1px solid #eee;
  cursor: pointer;
  transition: background-color 0.2s ease;
}

.quiz-item:last-child {
  border-bottom: none;
}

.quiz-item:hover {
  background-color: #f9f9f9;
}

.quiz-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
}

.quiz-title {
  font-size: 34rpx;
  font-weight: bold;
  color: #333;
}

.quiz-status {
  padding: 8rpx 16rpx;
  border-radius: 20rpx;
  font-size: 24rpx;
  font-weight: bold;
}

.quiz-status.draft {
  background-color: #ffe0b2;
  color: #ff9800;
}

.quiz-status.published {
  background-color: #c8e6c9;
  color: #4caf50;
}

.quiz-status.completed {
  background-color: #e0e0e0;
  color: #757575;
}

.quiz-info {
  margin-bottom: 20rpx;
}

.info-item {
  margin-bottom: 10rpx;
  font-size: 28rpx;
  color: #666;
}

.info-label {
  font-weight: bold;
}

.quiz-actions {
  display: flex;
  gap: 10rpx;
  justify-content: flex-end;
}

.action-btn {
  padding: 15rpx 30rpx;
  border: none;
  border-radius: 8rpx;
  font-size: 26rpx;
  cursor: pointer;
}

.edit-btn {
  background-color: #2196F3;
  color: white;
}

.delete-btn {
  background-color: #F44336;
  color: white;
}
</style>