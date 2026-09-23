<template>
  <div class="container">
    <div class="header">
      <div class="header-title">测验列表</div>
      <div class="header-info">共 {{ total }} 个测验</div>
    </div>
    
    <div class="filter-bar">
      <uni-select :value="filter" @change="handleFilterChange">
        <uni-select-option value="all">全部测验</uni-select-option>
        <uni-select-option value="ongoing">进行中</uni-select-option>
        <uni-select-option value="pending">未开始</uni-select-option>
        <uni-select-option value="completed">已结束</uni-select-option>
      </uni-select>
    </div>
    
    <uni-load-more :status="loadMoreStatus" :content-text="loadMoreContent" v-if="quizzes.length > 0"></uni-load-more>
    
    <div class="no-data" v-if="quizzes.length === 0 && !loading">
      <uni-icons type="empty" size="100" color="#ccc"></uni-icons>
      <div class="no-data-text">暂无测验</div>
    </div>
    
    <div class="loading" v-if="loading && quizzes.length === 0">
      <uni-icons type="spinner" size="40" color="#2196F3" spin></uni-icons>
      <div class="loading-text">加载中...</div>
    </div>
    
    <scroll-view 
      class="quiz-list" 
      scroll-y 
      @scrolltolower="loadMore" 
      @refresherrefresh="refresh"
      :refresher-enabled="true"
    >
      <div 
        class="quiz-item" 
        v-for="(quiz, index) in quizzes" 
        :key="index"
        @click="goToTakeQuiz(quiz.id)"
      >
        <div class="quiz-header">
          <div class="quiz-title">{{ quiz.title }}</div>
          <div class="quiz-status" :class="quiz.status">{{ quiz.statusText }}</div>
        </div>
        <div class="quiz-body">
          <div class="quiz-info">
            <div class="info-item">
              <uni-icons type="bookmark" size="20" color="#666"></uni-icons>
              <span>{{ quiz.courseName || '未知课程' }}</span>
            </div>
            <div class="info-item">
              <uni-icons type="time" size="20" color="#666"></uni-icons>
              <span>{{ formatDateTime(quiz.startTime) }}</span>
            </div>
            <div class="info-item">
              <uni-icons type="calendar" size="20" color="#666"></uni-icons>
              <span>{{ formatDateTime(quiz.endTime) }}</span>
            </div>
            <div class="info-item">
              <uni-icons type="eye" size="20" color="#666"></uni-icons>
              <span>已参加: {{ quiz.participantCount }}人</span>
            </div>
          </div>
          <div class="quiz-actions">
            <button 
              class="action-btn" 
              :class="quiz.status"
              :disabled="quiz.status !== 'ongoing'"
              @click.stop="goToTakeQuiz(quiz.id)"
            >
              {{ quiz.status === 'ongoing' ? '参加测验' : quiz.statusText }}
            </button>
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
      quizzes: [],
      total: 0,
      page: 1,
      pageSize: 10,
      loading: false,
      loadMoreStatus: 'more',
      loadMoreContent: {
        contentdown: '上拉加载更多',
        contentrefresh: '加载中...',
        contentnomore: '没有更多数据了'
      },
      filter: 'all',
      userInfo: uni.getStorageSync('userInfo') || {},
      role: uni.getStorageSync('role') || ''
    }
  },
  onShow() {
    // 页面显示时加载测验列表
    this.page = 1
    this.quizzes = []
    this.loadQuizzes()
  },
  methods: {
    handleFilterChange(e) {
      this.filter = e.detail.value
      this.loadQuizzes()
    },
    
    loadQuizzes() {
      if (this.loading) return
      
      this.loading = true
      
      // 调用后端API获取测验列表
      this.$api.get('/mobile/student/quiz/list', {
        studentId: this.userInfo.id,
        page: this.page,
        pageSize: this.pageSize,
        filter: this.filter
      }).then(res => {
        if (res.code === 200) {
          const processedQuizzes = res.data.quizzes.map(quiz => {
            // 添加状态文本和状态标识
            const now = new Date()
            const startTime = new Date(quiz.startTime)
            const endTime = new Date(quiz.endTime)
            
            let status = 'pending'
            let statusText = '未开始'
            
            if (now < startTime) {
              status = 'pending'
              statusText = '未开始'
            } else if (now > endTime) {
              status = 'completed'
              statusText = '已结束'
            } else {
              status = 'ongoing'
              statusText = '进行中'
            }
            
            return {
              ...quiz,
              status,
              statusText
            }
          })
          
          if (this.page === 1) {
            this.quizzes = processedQuizzes
          } else {
            this.quizzes = [...this.quizzes, ...processedQuizzes]
          }
          
          this.total = res.data.total
          this.loadMoreStatus = processedQuizzes.length < this.pageSize ? 'noMore' : 'more'
        } else {
          uni.showToast({
            title: res.message,
            icon: 'none'
          })
        }
      }).catch(err => {
        console.error('获取测验列表失败:', err)
        uni.showToast({
          title: '网络错误，请稍后重试',
          icon: 'none'
        })
      }).finally(() => {
        this.loading = false
      })
    },
    
    refresh() {
      // 下拉刷新
      this.page = 1
      this.quizzes = []
      this.loadQuizzes()
    },
    
    loadMore() {
      // 上拉加载更多
      if (this.loadMoreStatus === 'noMore' || this.loading) return
      
      this.page++
      this.loadMoreStatus = 'loading'
      this.loadQuizzes()
    },
    
    goToTakeQuiz(quizId) {
      // 跳转到参加测验页面
      uni.navigateTo({
        url: `/pages/quiz/take?id=${quizId}`
      })
    },
    
    formatDateTime(dateString) {
      if (!dateString) return ''
      const date = new Date(dateString)
      const year = date.getFullYear()
      const month = (date.getMonth() + 1).toString().padStart(2, '0')
      const day = date.getDate().toString().padStart(2, '0')
      const hours = date.getHours().toString().padStart(2, '0')
      const minutes = date.getMinutes().toString().padStart(2, '0')
      
      return `${year}-${month}-${day} ${hours}:${minutes}`
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
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
}

.header-info {
  font-size: 28rpx;
  color: #666;
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

.quiz-list {
  height: calc(100vh - 300rpx);
}

.quiz-item {
  background-color: white;
  border-radius: 15rpx;
  padding: 25rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  cursor: pointer;
}

.quiz-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 20rpx;
}

.quiz-title {
  font-size: 34rpx;
  font-weight: bold;
  color: #333;
  flex: 1;
  margin-right: 20rpx;
}

.quiz-status {
  padding: 8rpx 15rpx;
  border-radius: 20rpx;
  font-size: 26rpx;
  font-weight: bold;
  white-space: nowrap;
}

.quiz-status.ongoing {
  background-color: #e3f2fd;
  color: #2196F3;
}

.quiz-status.pending {
  background-color: #fff8e1;
  color: #FF9800;
}

.quiz-status.completed {
  background-color: #f5f5f5;
  color: #9e9e9e;
}

.quiz-body {
  display: flex;
  flex-direction: column;
}

.quiz-info {
  display: flex;
  flex-direction: column;
  gap: 15rpx;
  margin-bottom: 20rpx;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 10rpx;
  font-size: 30rpx;
  color: #666;
}

.quiz-actions {
  display: flex;
  justify-content: flex-end;
}

.action-btn {
  padding: 15rpx 30rpx;
  border-radius: 20rpx;
  font-size: 28rpx;
  font-weight: bold;
  border: none;
  cursor: pointer;
}

.action-btn.ongoing {
  background-color: #2196F3;
  color: white;
}

.action-btn.pending {
  background-color: #FF9800;
  color: white;
}

.action-btn.completed {
  background-color: #ccc;
  color: white;
  cursor: not-allowed;
}

.no-data {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 50vh;
  color: #ccc;
}

.no-data-text {
  margin-top: 20rpx;
  font-size: 32rpx;
}

.loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 50vh;
}

.loading-text {
  margin-top: 20rpx;
  font-size: 32rpx;
  color: #2196F3;
}

uni-load-more {
  margin: 30rpx 0;
}
</style>