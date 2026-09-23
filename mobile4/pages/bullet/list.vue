<template>
  <div class="container">
    <div class="header">
      <div class="header-left">
        <button @click="goBack" class="back-btn">
          <uni-icons type="left" size="30" color="#2196F3"></uni-icons>
        </button>
      </div>
      <div class="header-title">弹幕列表</div>
      <div class="header-right">
        <button @click="refreshBullets" class="refresh-btn">
          <uni-icons type="refresh" size="30" color="#2196F3"></uni-icons>
        </button>
      </div>
    </div>
    
    <!-- 弹幕列表 -->
    <div class="bullet-list" ref="scrollView" @scrolltolower="loadMore">
      <div 
        class="bullet-item" 
        v-for="(bullet, index) in bullets" 
        :key="bullet.id || index"
      >
        <div class="bullet-header">
          <div class="bullet-info">
            <span class="student-name">{{ bullet.studentName || '未知学生' }}</span>
            <span class="send-time">{{ formatTime(bullet.sendTime) }}</span>
          </div>
        </div>
        <div 
          class="bullet-content"
          :style="{
            color: bullet.color || '#333333',
            fontSize: (bullet.fontSize || 32) + 'px'
          }"
        >
          {{ bullet.content }}
        </div>
      </div>
      
      <!-- 加载状态 -->
      <div v-if="loading" class="loading">
        <uni-icons type="spinner" size="30" color="#2196F3" animation="spin"></uni-icons>
        <span>加载中...</span>
      </div>
      
      <!-- 无数据提示 -->
      <div v-if="!loading && bullets.length === 0" class="empty">
        <uni-icons type="empty" size="60" color="#ccc"></uni-icons>
        <span>暂无弹幕数据</span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      bullets: [],
      loading: false,
      page: 1,
      pageSize: 20,
      hasMore: true,
      userInfo: uni.getStorageSync('userInfo') || {},
      role: uni.getStorageSync('role') || ''
    }
  },
  onLoad() {
    this.loadBullets();
  },
  methods: {
    loadBullets() {
      if (this.loading || !this.hasMore) return;
      
      this.loading = true;
      
      // 调用后端API获取弹幕列表
      this.$api.get('/mobile/bullet/list', {
        page: this.page,
        pageSize: this.pageSize
      }).then(res => {
        this.loading = false;
        
        if (res.code === 200) {
          const newBullets = res.data.bullets || [];
          
          if (newBullets.length > 0) {
            this.bullets = this.page === 1 ? newBullets : [...this.bullets, ...newBullets];
            this.page++;
            this.hasMore = newBullets.length === this.pageSize;
          } else {
            this.hasMore = false;
            if (this.page === 1) {
              this.bullets = [];
            }
          }
        } else {
          uni.showToast({
            title: res.message || '加载失败',
            icon: 'none'
          });
        }
      }).catch(err => {
        console.error('加载弹幕列表失败:', err);
        this.loading = false;
        uni.showToast({
          title: '网络错误，请稍后重试',
          icon: 'none'
        });
      });
    },
    
    refreshBullets() {
      // 下拉刷新
      this.page = 1;
      this.hasMore = true;
      this.loadBullets();
    },
    
    loadMore() {
      // 上拉加载更多
      this.loadBullets();
    },
    
    formatTime(time) {
      if (!time) return '';
      
      const date = new Date(time);
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const day = String(date.getDate()).padStart(2, '0');
      const hours = String(date.getHours()).padStart(2, '0');
      const minutes = String(date.getMinutes()).padStart(2, '0');
      const seconds = String(date.getSeconds()).padStart(2, '0');
      
      return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    },
    
    goBack() {
      uni.navigateBack();
    }
  }
}
</script>

<style scoped>
.container {
  padding: 20rpx;
  background-color: #f5f5f5;
  min-height: 100vh;
  position: relative;
}

.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20rpx;
  padding: 10rpx 0;
  border-bottom: 1px solid #e0e0e0;
}

.header-left, .header-right {
  width: 100rpx;
  display: flex;
  align-items: center;
}

.header-left {
  justify-content: flex-start;
}

.header-right {
  justify-content: flex-end;
}

.header-title {
  flex: 1;
  text-align: center;
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
}

.back-btn, .refresh-btn {
  padding: 10rpx;
  border: none;
  background-color: transparent;
  cursor: pointer;
}

.bullet-list {
  width: 100%;
  background-color: white;
  border-radius: 15rpx;
  padding: 20rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  max-height: calc(100vh - 160rpx);
  overflow-y: auto;
}

.bullet-item {
  padding: 20rpx 0;
  border-bottom: 1px solid #f0f0f0;
}

.bullet-item:last-child {
  border-bottom: none;
}

.bullet-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10rpx;
}

.bullet-info {
  display: flex;
  align-items: center;
  gap: 20rpx;
}

.student-name {
  font-size: 28rpx;
  font-weight: bold;
  color: #2196F3;
}

.send-time {
  font-size: 24rpx;
  color: #999;
}

.bullet-content {
  font-size: 32rpx;
  color: #333;
  line-height: 1.5;
  white-space: pre-wrap;
  word-break: break-word;
}

.loading {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10rpx;
  padding: 30rpx 0;
  color: #2196F3;
  font-size: 28rpx;
}

.empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 100rpx 0;
  color: #999;
  font-size: 28rpx;
}

.empty uni-icons {
  margin-bottom: 20rpx;
}
</style>