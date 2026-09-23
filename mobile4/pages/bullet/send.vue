<template>
  <div class="container">
    <div class="header">
      <div class="header-title">课堂弹幕</div>
      <div class="header-actions">
        <button @click="goToBulletList" class="list-btn">
          <uni-icons type="list" size="30" color="#2196F3"></uni-icons>
          <span>弹幕列表</span>
        </button>
      </div>
    </div>
    
    <!-- 弹幕显示区域 -->
    <div class="bullet-screen-container" ref="bulletScreen">
      <div 
        class="bullet-item" 
        v-for="(bullet, index) in bullets" 
        :key="bullet.id || index"
        :style="{
          left: bullet.left + 'px',
          top: bullet.top + 'px',
          color: bullet.color,
          fontSize: bullet.fontSize + 'px',
          animationDuration: bullet.duration + 's',
          opacity: bullet.opacity
        }"
      >
        {{ bullet.content }}
      </div>
    </div>
    
    <!-- 输入区域 -->
    <div class="input-container">
      <input 
        type="text" 
        :value="bulletContent" 
        @input="handleInput"
        placeholder="请输入弹幕内容..." 
        class="input"
        @confirm="sendBullet"
        maxlength="50"
      />
      <div class="color-picker">
        <div 
          class="color-item" 
          v-for="color in colors" 
          :key="color"
          :style="{ backgroundColor: color }"
          :class="{ active: selectedColor === color }"
          @click="selectedColor = color"
        ></div>
      </div>
      <button @click="sendBullet" class="send-btn" :disabled="!bulletContent.trim()">
        <uni-icons type="send" size="28" color="#fff"></uni-icons>
        <span>发送</span>
      </button>
    </div>
    
    <!-- 状态提示 -->
    <div class="status" v-if="status">
      <div :class="status.success ? 'success' : 'error'">{{ status.message }}</div>
    </div>
    
    <!-- 弹幕设置 -->
    <div class="settings">
      <div class="setting-item">
        <span>字体大小:</span>
        <input 
          type="range"
          :value="fontSize"
          @input="handleFontSizeChange"
          :min="24" 
          :max="48" 
          :step="2"
        />
        <span>{{ fontSize }}px</span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      bulletContent: '',
      selectedColor: '#333333',
      fontSize: 32,
      bullets: [],
      status: null,
      colors: [
        '#333333', '#2196F3', '#4CAF50', '#FF9800', 
        '#F44336', '#9C27B0', '#E91E63', '#795548'
      ],
      screenWidth: 0,
      screenHeight: 0,
      animationTimer: null,
      userInfo: uni.getStorageSync('userInfo') || {},
      role: uni.getStorageSync('role') || ''
    }
  },
  mounted() {
    // 获取屏幕尺寸
    const systemInfo = uni.getSystemInfoSync();
    this.screenWidth = systemInfo.windowWidth;
    this.screenHeight = systemInfo.windowHeight;
    
    // 开始接收实时弹幕
    this.startReceivingBullets();
    
    // 初始化自动清理定时器
    this.initCleanupTimer();
  },
  onUnload() {
    // 页面卸载时清理定时器
    if (this.animationTimer) {
      clearInterval(this.animationTimer);
    }
  },
  methods: {
    handleInput(e) {
      this.bulletContent = e.detail.value
    },
    
    handleFontSizeChange(e) {
      this.fontSize = e.detail.value
    },
    
    sendBullet() {
      if (!this.bulletContent.trim()) {
        this.status = {
          success: false,
          message: '请输入弹幕内容'
        };
        return;
      }
      
      // 创建本地弹幕对象
      const newBullet = {
        content: this.bulletContent.trim(),
        color: this.selectedColor,
        fontSize: this.fontSize,
        top: this.getRandomTop(),
        left: this.screenWidth,
        duration: this.getRandomDuration(),
        opacity: 0,
        id: Date.now() + Math.random()
      };
      
      // 添加到本地弹幕列表
      this.bullets.push(newBullet);
      
      // 调用后端API发送弹幕
      this.$api.post('/mobile/bullet/send', {
        studentId: this.userInfo.id,
        content: newBullet.content,
        color: newBullet.color,
        fontSize: newBullet.fontSize
      }).then(res => {
        if (res.code === 200) {
          // 更新弹幕ID
          newBullet.id = res.data.id;
          
          // 显示成功状态
          this.status = {
            success: true,
            message: '弹幕发送成功'
          };
          
          // 3秒后隐藏状态提示
          setTimeout(() => {
            this.status = null;
          }, 3000);
        } else {
          this.status = {
            success: false,
            message: res.message
          };
        }
      }).catch(err => {
        console.error('发送弹幕失败:', err);
        this.status = {
          success: false,
          message: '网络错误，请稍后重试'
        };
      });
      
      // 清空输入框
      this.bulletContent = '';
    },
    
    getRandomTop() {
      // 随机生成弹幕Y轴位置
      return Math.random() * (this.screenHeight - 200) + 100;
    },
    
    getRandomDuration() {
      // 随机生成动画时长（8-15秒）
      return Math.random() * 7 + 8;
    },
    
    startReceivingBullets() {
      // 模拟实时接收弹幕
      this.animationTimer = setInterval(() => {
        // 这里应该调用后端API获取最新弹幕
        // 暂时模拟接收新弹幕
        this.updateBulletsAnimation();
      }, 1000);
    },
    
    updateBulletsAnimation() {
      // 更新弹幕动画状态
      this.bullets.forEach(bullet => {
        // 计算新位置（这里简化处理，实际应该使用CSS动画）
        bullet.left -= 5;
        
        // 控制透明度
        if (bullet.opacity < 1) {
          bullet.opacity += 0.1;
        }
        
        // 如果弹幕超出屏幕左侧，移除它
        if (bullet.left < -300) {
          const index = this.bullets.indexOf(bullet);
          if (index > -1) {
            this.bullets.splice(index, 1);
          }
        }
      });
    },
    
    initCleanupTimer() {
      // 定期清理旧弹幕
      setInterval(() => {
        this.bullets = this.bullets.filter(bullet => bullet.left > -300);
      }, 30000);
    },
    
    goToBulletList() {
      // 跳转到弹幕列表页面
      uni.navigateTo({
        url: '/pages/bullet/list'
      });
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
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
}

.header-title {
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
}

.header-actions {
  display: flex;
  gap: 20rpx;
}

.list-btn {
  display: flex;
  align-items: center;
  gap: 10rpx;
  padding: 10rpx 20rpx;
  border-radius: 20rpx;
  font-size: 28rpx;
  color: #2196F3;
  background-color: #e3f2fd;
  border: none;
  cursor: pointer;
}

.bullet-screen-container {
  width: 100%;
  height: calc(100vh - 400rpx);
  background-color: white;
  border-radius: 15rpx;
  margin-bottom: 20rpx;
  position: relative;
  overflow: hidden;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.bullet-item {
  position: absolute;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  font-weight: bold;
  opacity: 0;
  animation: slideLeft linear forwards;
  z-index: 10;
}

@keyframes slideLeft {
  from {
    transform: translateX(100%);
  }
  to {
    transform: translateX(-100%);
  }
}

.input-container {
  display: flex;
  align-items: center;
  gap: 15rpx;
  margin-bottom: 20rpx;
  padding: 20rpx;
  background-color: white;
  border-radius: 15rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.input {
  flex: 1;
  padding: 20rpx;
  border: 1px solid #ddd;
  border-radius: 10rpx;
  font-size: 30rpx;
  color: #333;
}

.color-picker {
  display: flex;
  gap: 10rpx;
  flex-shrink: 0;
}

.color-item {
  width: 40rpx;
  height: 40rpx;
  border-radius: 50%;
  cursor: pointer;
  border: 2px solid transparent;
  transition: all 0.2s;
}

.color-item.active {
  border-color: #2196F3;
  transform: scale(1.1);
}

.send-btn {
  padding: 20rpx 30rpx;
  border-radius: 10rpx;
  font-size: 30rpx;
  font-weight: bold;
  background-color: #2196F3;
  color: white;
  border: none;
  display: flex;
  align-items: center;
  gap: 10rpx;
  cursor: pointer;
  flex-shrink: 0;
}

.send-btn:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}

.status {
  margin-bottom: 20rpx;
  padding: 0 20rpx;
}

.status.success {
  color: #4CAF50;
  font-size: 28rpx;
  text-align: center;
}

.status.error {
  color: #F44336;
  font-size: 28rpx;
  text-align: center;
}

.settings {
  padding: 20rpx;
  background-color: white;
  border-radius: 15rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.setting-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20rpx;
}

.setting-item span {
  font-size: 30rpx;
  color: #666;
  flex-shrink: 0;
}

.setting-item input[type="range"] {
  flex: 1;
}
</style>