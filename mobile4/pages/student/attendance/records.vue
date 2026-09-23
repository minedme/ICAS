<template>
  <div class="container">
    <div class="header">
      <div class="header-title">我的考勤记录</div>
    </div>
    
    <div class="attendance-rate">
      <div class="rate-title">出勤率</div>
      <div class="rate-value">{{ attendanceRate }}%</div>
    </div>
    
    <div class="filter-bar">
      <select :value="filter" @change="filter = $event.target.value; loadRecords()" class="select">
        <option value="all">全部记录</option>
        <option value="today">今日记录</option>
        <option value="this_week">本周记录</option>
        <option value="this_month">本月记录</option>
      </select>
    </div>
    
    <!-- 加载更多 -->
    <div class="load-more" v-if="records.length > 0">
      <div v-if="loadMoreStatus === 'loading'">加载中...</div>
      <div v-else-if="loadMoreStatus === 'noMore'">没有更多数据了</div>
      <div v-else>上拉加载更多</div>
    </div>
    
    <div class="no-data" v-if="records.length === 0 && !loading">
      <div class="no-data-icon">📋</div>
      <div class="no-data-text">暂无考勤记录</div>
    </div>
    
    <div class="loading" v-if="loading && records.length === 0">
      <div class="loading-icon">⏳</div>
      <div class="loading-text">加载中...</div>
    </div>
    
    <scroll-view 
      class="record-list" 
      scroll-y 
      @scrolltolower="loadMore" 
      @refresherrefresh="refresh"
      :refresher-enabled="true"
    >
      <div 
        class="record-item" 
        v-for="(record, index) in records" 
        :key="index"
      >
        <div class="record-header">
          <div class="course-name">{{ record.courseName || '未知课程' }}</div>
          <div class="record-date">{{ formatDate(record.signTime) }}</div>
        </div>
        <div class="record-body">
          <div class="record-info">
          <div class="info-item">
            <span class="icon">⏰</span>
            <span>{{ formatTime(record.signTime) }}</span>
          </div>
          <div class="info-item">
            <span class="icon">{{ record.attendanceType === 'scan' ? '📱' : '📍' }}</span>
            <span>{{ record.attendanceType === 'scan' ? '扫码签到' : 'GPS签到' }}</span>
          </div>
        </div>
          <div class="record-status" :class="getStatusClass(record.status)">
            {{ getStatusText(record.status) }}
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
      records: [],
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
      role: uni.getStorageSync('role') || '',
      attendanceRate: 0
    }
  },
  onShow() {
    // 页面显示时加载考勤记录
    this.page = 1
    this.records = []
    this.loadRecords()
  },
  methods: {
    loadRecords() {
      if (this.loading) return
      
      this.loading = true
      
      this.$api.getStudentRecords(this.userInfo.id, this.page, this.pageSize, this.filter)
        .then(res => {
          if (res.code === 200) {
            if (this.page === 1) {
              this.records = res.data.records
              this.attendanceRate = res.data.attendanceRate || 0
            } else {
              this.records = [...this.records, ...res.data.records]
            }
            this.total = res.data.total
            this.loadMoreStatus = res.data.records.length < this.pageSize ? 'noMore' : 'more'
          } else {
            uni.showToast({
              title: res.message,
              icon: 'none'
            })
          }
        }).catch(err => {
          console.error('获取考勤记录失败:', err)
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
      this.records = []
      this.loadRecords()
    },
    
    loadMore() {
      // 上拉加载更多
      if (this.loadMoreStatus === 'noMore' || this.loading) return
      
      this.page++
      this.loadMoreStatus = 'loading'
      this.loadRecords()
    },
    
    formatDate(dateString) {
      if (!dateString) return ''
      const date = new Date(dateString)
      return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`
    },
    
    formatTime(dateString) {
      if (!dateString) return ''
      const date = new Date(dateString)
      return `${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}:${date.getSeconds().toString().padStart(2, '0')}`
    },
    
    // 获取状态类名
    getStatusClass(status) {
      switch(status) {
        case 1:
          return 'present'
        case 2:
          return 'late'
        case 3:
          return 'absent'
        default:
          return 'absent'
      }
    },
    
    // 获取状态文本
    getStatusText(status) {
      switch(status) {
        case 1:
          return '出勤'
        case 2:
          return '迟到'
        case 3:
          return '缺勤'
        default:
          return '未知'
      }
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

.attendance-rate {
  background-color: #4CAF50;
  color: white;
  padding: 30rpx;
  border-radius: 15rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  text-align: center;
}

.rate-title {
  font-size: 28rpx;
  margin-bottom: 10rpx;
  opacity: 0.9;
}

.rate-value {
  font-size: 60rpx;
  font-weight: bold;
}

.record-list {
  height: calc(100vh - 300rpx);
}

.record-item {
  background-color: white;
  border-radius: 15rpx;
  padding: 25rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.record-header {
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

.record-date {
  font-size: 28rpx;
  color: #666;
}

.record-body {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.record-info {
  display: flex;
  flex-direction: column;
  gap: 15rpx;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 10rpx;
  font-size: 30rpx;
  color: #666;
}

.record-status {
  padding: 10rpx 20rpx;
  border-radius: 20rpx;
  font-size: 28rpx;
  font-weight: bold;
}

.record-status.present {
  background-color: #e8f5e9;
  color: #4CAF50;
}

.record-status.late {
  background-color: #fff3e0;
  color: #FF9800;
}

.record-status.absent {
  background-color: #ffebee;
  color: #F44336;
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


</style>