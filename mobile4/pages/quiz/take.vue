<template>
  <div class="container">
    <!-- 测验信息 -->
    <div class="quiz-info" v-if="quizInfo">
      <div class="quiz-title">{{ quizInfo.title }}</div>
      <div class="quiz-meta">
        <div class="meta-item">
          <uni-icons type="bookmark" size="20" color="#666"></uni-icons>
          <span>{{ quizInfo.courseName }}</span>
        </div>
        <div class="meta-item" v-if="quizInfo.duration">
          <uni-icons type="time" size="20" color="#666"></uni-icons>
          <span>时长: {{ quizInfo.duration }}分钟</span>
        </div>
      </div>
    </div>
    
    <!-- 倒计时 -->
    <div class="countdown" v-if="countdown > 0">
      <uni-icons type="clock" size="24" color="#FF9800"></uni-icons>
      <span>剩余时间: {{ formatCountdown(countdown) }}</span>
    </div>
    
    <!-- 答题区域 -->
    <div class="question-container" v-if="questions.length > 0">
      <!-- 题目导航 -->
      <div class="question-nav">
        <div 
          class="nav-item" 
          v-for="(q, index) in questions" 
          :key="index"
          :class="{
            'active': currentIndex === index,
            'answered': answers[index] !== null
          }"
          @click="goToQuestion(index)"
        >
          {{ index + 1 }}
        </div>
      </div>
      
      <!-- 题目内容 -->
      <div class="question-content">
        <div class="question-header">
          <div class="question-number">第 {{ currentIndex + 1 }} / {{ questions.length }} 题</div>
          <div class="question-type">{{ getQuestionTypeText(currentQuestion.type) }}</div>
        </div>
        
        <div class="question-text" v-html="currentQuestion.content"></div>
        
        <!-- 选项 -->
        <div class="options" v-if="currentQuestion.options">
          <!-- 单选题 -->
          <div v-if="currentQuestion.type === 'single'" class="option-list">
            <div 
              class="option-item" 
              v-for="(option, optIndex) in currentQuestion.options" 
              :key="optIndex"
              :class="{'selected': answers[currentIndex] === optIndex}"
              @click="selectOption(optIndex)"
            >
              <div class="option-letter">{{ getOptionLetter(optIndex) }}</div>
              <div class="option-text" v-html="option"></div>
            </div>
          </div>
          
          <!-- 多选题 -->
          <div v-else-if="currentQuestion.type === 'multiple'" class="option-list">
            <div 
              class="option-item" 
              v-for="(option, optIndex) in currentQuestion.options" 
              :key="optIndex"
              :class="{'selected': isOptionSelected(optIndex)}"
              @click="toggleOption(optIndex)"
            >
              <div class="option-checkbox">
                <uni-icons 
                  type="success" 
                  size="24" 
                  color="#fff" 
                  v-if="isOptionSelected(optIndex)"
                ></uni-icons>
              </div>
              <div class="option-text" v-html="option"></div>
            </div>
          </div>
          
          <!-- 判断题 -->
          <div v-else-if="currentQuestion.type === 'judge'" class="option-list">
            <div 
              class="option-item judge" 
              :class="{'selected': answers[currentIndex] === 0}"
              @click="selectOption(0)"
            >
              <div class="option-text">正确</div>
            </div>
            <div 
              class="option-item judge" 
              :class="{'selected': answers[currentIndex] === 1}"
              @click="selectOption(1)"
            >
              <div class="option-text">错误</div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 导航按钮 -->
      <div class="navigation">
        <button @click="prevQuestion" class="nav-btn" :disabled="currentIndex === 0">
          <uni-icons type="left" size="28" color="#fff"></uni-icons>
          上一题
        </button>
        <div class="progress-info">
          <span>{{ answeredCount }} / {{ questions.length }} 已答</span>
        </div>
        <button @click="nextQuestion" class="nav-btn" :disabled="currentIndex === questions.length - 1">
          下一题
          <uni-icons type="right" size="28" color="#fff"></uni-icons>
        </button>
      </div>
    </div>
    
    <!-- 提交按钮 -->
    <div class="submit-section" v-if="questions.length > 0">
      <button @click="submitAnswers" class="submit-btn" :disabled="submitting">
        <span v-if="submitting">提交中...</span>
        <span v-else>提交答案</span>
      </button>
    </div>
    
    <!-- 加载中 -->
    <div class="loading" v-if="loading && questions.length === 0">
      <uni-icons type="spinner" size="40" color="#2196F3" spin></uni-icons>
      <div class="loading-text">加载测验中...</div>
    </div>
    
    <!-- 错误信息 -->
    <div class="error" v-if="error">
      <uni-icons type="close-circle" size="40" color="#F44336"></uni-icons>
      <div class="error-text">{{ error }}</div>
      <button @click="loadQuiz" class="retry-btn">重试</button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      quizId: '',
      quizInfo: null,
      questions: [],
      currentIndex: 0,
      answers: [],
      loading: false,
      submitting: false,
      error: '',
      countdown: 0,
      countdownTimer: null
    }
  },
  computed: {
    currentQuestion() {
      return this.questions[this.currentIndex] || {};
    },
    answeredCount() {
      return this.answers.filter(answer => answer !== null).length;
    }
  },
  onLoad(options) {
    // 获取测验ID
    this.quizId = options.id;
    if (!this.quizId) {
      this.error = '测验ID无效';
      return;
    }
    
    // 加载测验
    this.loadQuiz();
  },
  onUnload() {
    // 页面卸载时清除倒计时
    if (this.countdownTimer) {
      clearInterval(this.countdownTimer);
    }
  },
  methods: {
    loadQuiz() {
      this.loading = true;
      this.error = '';
      
      // 调用后端API获取测验信息和题目
      this.$api.get('/mobile/student/quiz/detail', {
        quizId: this.quizId,
        studentId: uni.getStorageSync('userInfo').id
      }).then(res => {
        if (res.code === 200) {
          this.quizInfo = res.data.quiz;
          this.questions = res.data.questions;
          
          // 初始化答案数组
          this.answers = new Array(this.questions.length).fill(null);
          
          // 设置倒计时
          if (this.quizInfo.duration) {
            this.countdown = this.quizInfo.duration * 60;
            this.startCountdown();
          }
        } else {
          this.error = res.message;
        }
      }).catch(err => {
        console.error('加载测验失败:', err);
        this.error = '网络错误，请稍后重试';
      }).finally(() => {
        this.loading = false;
      });
    },
    
    startCountdown() {
      this.countdownTimer = setInterval(() => {
        if (this.countdown > 0) {
          this.countdown--;
        } else {
          // 时间到，自动提交
          clearInterval(this.countdownTimer);
          this.submitAnswers();
        }
      }, 1000);
    },
    
    formatCountdown(seconds) {
      const mins = Math.floor(seconds / 60);
      const secs = seconds % 60;
      return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
    },
    
    getQuestionTypeText(type) {
      const typeMap = {
        'single': '单选题',
        'multiple': '多选题',
        'judge': '判断题',
        'essay': '简答题'
      };
      return typeMap[type] || '未知题型';
    },
    
    getOptionLetter(index) {
      return String.fromCharCode(65 + index);
    },
    
    selectOption(index) {
      this.answers[this.currentIndex] = index;
    },
    
    toggleOption(index) {
      if (!Array.isArray(this.answers[this.currentIndex])) {
        this.answers[this.currentIndex] = [];
      }
      
      const optionIndex = this.answers[this.currentIndex].indexOf(index);
      if (optionIndex > -1) {
        // 取消选择
        this.answers[this.currentIndex].splice(optionIndex, 1);
      } else {
        // 选择
        this.answers[this.currentIndex].push(index);
      }
    },
    
    isOptionSelected(index) {
      if (!Array.isArray(this.answers[this.currentIndex])) {
        return false;
      }
      return this.answers[this.currentIndex].indexOf(index) > -1;
    },
    
    goToQuestion(index) {
      this.currentIndex = index;
    },
    
    prevQuestion() {
      if (this.currentIndex > 0) {
        this.currentIndex--;
      }
    },
    
    nextQuestion() {
      if (this.currentIndex < this.questions.length - 1) {
        this.currentIndex++;
      }
    },
    
    submitAnswers() {
      // 检查是否有未答题目
      if (this.answeredCount < this.questions.length) {
        uni.showModal({
          title: '提示',
          content: `还有 ${this.questions.length - this.answeredCount} 道题未答，确定要提交吗？`,
          success: (res) => {
            if (res.confirm) {
              this.doSubmit();
            }
          }
        });
      } else {
        this.doSubmit();
      }
    },
    
    doSubmit() {
      this.submitting = true;
      
      // 准备提交数据
      const submitData = {
        quizId: this.quizId,
        studentId: uni.getStorageSync('userInfo').id,
        answers: this.answers.map((answer, index) => ({
          questionId: this.questions[index].id,
          answer: answer
        }))
      };
      
      // 调用后端API提交答案
      this.$api.post('/mobile/student/quiz/submit', submitData).then(res => {
        if (res.code === 200) {
          // 提交成功，显示结果
          uni.showModal({
            title: '提交成功',
            content: `您的得分：${res.data.score}分\n正确率：${res.data.correctRate}%`,
            showCancel: false,
            success: () => {
              // 返回测验列表
              uni.navigateBack({
                delta: 1
              });
            }
          });
        } else {
          uni.showToast({
            title: res.message,
            icon: 'none'
          });
        }
      }).catch(err => {
        console.error('提交答案失败:', err);
        uni.showToast({
          title: '网络错误，请稍后重试',
          icon: 'none'
        });
      }).finally(() => {
        this.submitting = false;
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
}

.quiz-info {
  background-color: white;
  border-radius: 15rpx;
  padding: 25rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.quiz-title {
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 15rpx;
}

.quiz-meta {
  display: flex;
  gap: 30rpx;
  flex-wrap: wrap;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 10rpx;
  font-size: 30rpx;
  color: #666;
}

.countdown {
  background-color: #fff8e1;
  border-radius: 10rpx;
  padding: 20rpx;
  margin-bottom: 20rpx;
  display: flex;
  align-items: center;
  gap: 10rpx;
  font-size: 32rpx;
  color: #FF9800;
  font-weight: bold;
}

.question-container {
  background-color: white;
  border-radius: 15rpx;
  padding: 25rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.question-nav {
  display: flex;
  flex-wrap: wrap;
  gap: 15rpx;
  margin-bottom: 25rpx;
  padding-bottom: 25rpx;
  border-bottom: 1px solid #f0f0f0;
}

.nav-item {
  width: 50rpx;
  height: 50rpx;
  border-radius: 50%;
  background-color: #f5f5f5;
  color: #999;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28rpx;
  font-weight: bold;
  cursor: pointer;
}

.nav-item.active {
  background-color: #2196F3;
  color: white;
}

.nav-item.answered {
  background-color: #e8f5e9;
  color: #4CAF50;
}

.question-content {
  margin-bottom: 30rpx;
}

.question-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
}

.question-number {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.question-type {
  padding: 8rpx 15rpx;
  border-radius: 20rpx;
  font-size: 26rpx;
  background-color: #e3f2fd;
  color: #2196F3;
}

.question-text {
  font-size: 34rpx;
  color: #333;
  margin-bottom: 30rpx;
  line-height: 1.5;
}

.options {
  margin-bottom: 30rpx;
}

.option-list {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
}

.option-item {
  display: flex;
  align-items: flex-start;
  gap: 20rpx;
  padding: 20rpx;
  border: 2px solid #e0e0e0;
  border-radius: 10rpx;
  cursor: pointer;
  transition: all 0.3s;
}

.option-item.selected {
  border-color: #2196F3;
  background-color: #e3f2fd;
}

.option-letter {
  width: 50rpx;
  height: 50rpx;
  border-radius: 50%;
  background-color: #e0e0e0;
  color: #666;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28rpx;
  font-weight: bold;
  flex-shrink: 0;
}

.option-item.selected .option-letter {
  background-color: #2196F3;
  color: white;
}

.option-checkbox {
  width: 50rpx;
  height: 50rpx;
  border-radius: 8rpx;
  background-color: #e0e0e0;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.option-item.selected .option-checkbox {
  background-color: #2196F3;
}

.option-text {
  flex: 1;
  font-size: 32rpx;
  color: #333;
  line-height: 1.5;
}

.option-item.judge {
  justify-content: center;
  padding: 30rpx;
}

.navigation {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 25rpx;
  border-top: 1px solid #f0f0f0;
}

.nav-btn {
  padding: 15rpx 40rpx;
  border-radius: 25rpx;
  font-size: 30rpx;
  font-weight: bold;
  background-color: #2196F3;
  color: white;
  border: none;
  display: flex;
  align-items: center;
  gap: 10rpx;
  cursor: pointer;
}

.nav-btn:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}

.progress-info {
  font-size: 28rpx;
  color: #666;
}

.submit-section {
  margin-bottom: 40rpx;
}

.submit-btn {
  width: 100%;
  padding: 25rpx;
  border-radius: 15rpx;
  font-size: 34rpx;
  font-weight: bold;
  background-color: #4CAF50;
  color: white;
  border: none;
  cursor: pointer;
}

.submit-btn:disabled {
  background-color: #ccc;
  cursor: not-allowed;
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

.error {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 50vh;
  gap: 20rpx;
}

.error-text {
  font-size: 32rpx;
  color: #F44336;
  text-align: center;
}

.retry-btn {
  padding: 15rpx 40rpx;
  border-radius: 25rpx;
  font-size: 30rpx;
  font-weight: bold;
  background-color: #2196F3;
  color: white;
  border: none;
  cursor: pointer;
}
</style>