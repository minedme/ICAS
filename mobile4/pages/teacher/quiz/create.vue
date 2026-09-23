<template>
  <view class="quiz-page">
    <view class="title-bar">{{ isEdit ? '编辑测验' : '创建测验' }}</view>
    
    <view class="form-area">
      <view class="form-item">
        <text class="label">测验标题</text>
        <input 
          type="text" 
          placeholder="请输入测验标题" 
          v-model="quizData.title"
        />
      </view>
      
      <view class="form-item">
        <text class="label">所属课程 <text class="required">*</text></text>
        <picker 
          class="picker" 
          mode="selector" 
          :range="courseOptions" 
          :value="selectedCourseIndex"
          @change="handleCourseChange"
        >
          <view class="picker-content">
            <text :class="{'placeholder': !selectedCourseName}">{{ selectedCourseName || '请选择课程' }}</text>
            <text class="picker-arrow">▼</text>
          </view>
        </picker>
      </view>
      
      <view class="form-item">
        <text class="label">开始时间</text>
        <picker mode="date" :value="quizData.startDate" @change="handleStartDateChange" class="picker">
          <view>{{ quizData.startDate || '选择开始日期' }}</view>
        </picker>
        <picker mode="time" :value="quizData.startTime" @change="handleStartTimeChange" class="picker">
          <view>{{ quizData.startTime || '选择开始时间' }}</view>
        </picker>
      </view>
      
      <view class="form-item">
        <text class="label">结束时间</text>
        <picker mode="date" :value="quizData.endDate" @change="handleEndDateChange" class="picker">
          <view>{{ quizData.endDate || '选择结束日期' }}</view>
        </picker>
        <picker mode="time" :value="quizData.endTime" @change="handleEndTimeChange" class="picker">
          <view>{{ quizData.endTime || '选择结束时间' }}</view>
        </picker>
      </view>
      
      <view class="form-item">
        <text class="label">测验时长(分钟)</text>
        <input 
          type="number" 
          v-model="quizData.duration"
        />
      </view>
      
      <view class="form-item">
        <text class="label">测验描述</text>
        <textarea 
          v-model="quizData.description" 
          placeholder="请输入测验描述"
          class="textarea"
        ></textarea>
      </view>
    </view>
    
    <view class="questions-section">
      <view class="questions-header">
        <text class="questions-title">问题管理</text>
        <button @click="addQuestion" class="add-question-btn">添加问题</button>
      </view>
      
      <view class="questions-list">
        <view class="question-item" v-for="(question, index) in quizData.questions" :key="index">
          <view class="question-header">
            <text class="question-index">问题 {{ index + 1 }}</text>
            <button @click="deleteQuestion(index)" class="delete-question-btn">删除</button>
          </view>
          
          <view class="form-item">
            <text class="label">问题内容</text>
            <textarea 
              :value="question.content" 
              @input="handleQuestionContentInput(question, $event)" 
              placeholder="请输入问题内容"
              class="textarea"
            ></textarea>
          </view>
          
          <view class="form-item">
            <text class="label">问题类型</text>
            <picker 
              class="picker" 
              mode="selector" 
              :range="typeOptions" 
              @change="handleTypeSelectChange(question, $event)"
            >
              <view>{{ getTypeName(question.type) }}</view>
            </picker>
          </view>
          
          <view class="form-item">
            <text class="label">选项</text>
            <view v-if="question.type === 'judgment'">
              <view class="option-item">
                <input 
                  type="radio" 
                  :id="`option-${index}-A`" 
                  :name="`question-${index}`" 
                  :checked="question.answer === 'A'" 
                  @change="handleJudgmentAnswer(question, 'A')"
                />
                <label :for="`option-${index}-A`">正确</label>
              </view>
              <view class="option-item">
                <input 
                  type="radio" 
                  :id="`option-${index}-B`" 
                  :name="`question-${index}`" 
                  :checked="question.answer === 'B'" 
                  @change="handleJudgmentAnswer(question, 'B')"
                />
                <label :for="`option-${index}-B`">错误</label>
              </view>
            </view>
            <view v-else>
              <view class="option-item" v-for="(option, optionIndex) in question.options" :key="optionIndex">
                <input 
                  :type="question.type === 'single' ? 'radio' : 'checkbox'" 
                  :id="`option-${index}-${String.fromCharCode(65 + optionIndex)}`" 
                  :name="`question-${index}`" 
                  :checked="isOptionSelected(question, String.fromCharCode(65 + optionIndex))"
                  @change="handleOptionChange(question, $event, String.fromCharCode(65 + optionIndex))"
                />
                <input 
                  type="text" 
                  v-model="option.text" 
                  placeholder="请输入选项内容" 
                  class="option-input" 
                />
              </view>
              <button @click="addOption(question)" class="add-option-btn">添加选项</button>
            </view>
          </view>
        </view>
      </view>
    </view>
    
    <view class="btn-area">
      <button @click="saveDraft" class="draft-btn" :disabled="isLoading">
        {{ isLoading ? '保存中...' : '保存草稿' }}
      </button>
      <button @click="publishQuiz" class="submit-btn" :disabled="isLoading || quizData.questions.length === 0">
        {{ isLoading ? '发布中...' : '发布测验' }}
      </button>
    </view>
    
    <view v-if="error" class="error-text">{{ error }}</view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      quizData: {
        title: '',
        courseId: '',
        startDate: '',
        startTime: '',
        endDate: '',
        endTime: '',
        duration: 60,
        description: '',
        questions: [
          {
            content: '',
            type: 'single',
            options: [{ text: '' }, { text: '' }],
            answer: ''
          }
        ]
      },
      courses: [],
      courseOptions: [],
      selectedCourseName: '请选择课程',
      selectedCourseIndex: -1,
      typeOptions: ['单选题', '多选题', '判断题'],
      typeValues: ['single', 'multiple', 'judgment'],
      isEdit: false,
      quizId: null,
      isLoading: false,
      error: '',
      tempAnswer: ''
    }
  },
  onLoad(options) {
    if (options.id) {
      this.isEdit = true
      this.quizId = options.id
      this.loadQuizData()
    }
    this.loadCourses()
  },
  methods: {
    handleCourseChange(e) {
      console.log('========== 课程选择变化 ==========');
      console.log('选择索引:', e.detail.value);
      
      const index = e.detail.value;
      this.selectedCourseIndex = index;
      
      if (this.courses[index]) {
        this.quizData.courseId = this.courses[index].id;
        this.selectedCourseName = this.courses[index].name;
        console.log('选择课程:', this.courses[index]);
      }
    },
    handleStartDateChange(e) {
      this.quizData.startDate = e.detail.value
    },
    handleStartTimeChange(e) {
      this.quizData.startTime = e.detail.value
    },
    handleEndDateChange(e) {
      this.quizData.endDate = e.detail.value
    },
    handleEndTimeChange(e) {
      this.quizData.endTime = e.detail.value
    },
    getTypeName(type) {
      const index = this.typeValues.indexOf(type)
      return index >= 0 ? this.typeOptions[index] : type
    },
    handleTypeSelectChange(question, event) {
      const index = event.detail.value
      const newType = this.typeValues[index]
      this.$set(question, 'type', newType)
      
      if (newType === 'multiple' && !Array.isArray(question.answer)) {
        this.$set(question, 'answer', [])
      } else if (newType !== 'multiple' && Array.isArray(question.answer)) {
        this.$set(question, 'answer', '')
      }
    },
    loadCourses() {
      console.log('========== 开始加载课程列表 ==========');
      
      const userInfo = uni.getStorageSync('userInfo') || {};
      const teacherId = userInfo.id || '';
      console.log('teacherId:', teacherId);
      
      uni.showLoading({
        title: '加载课程中...'
      });
      
      this.$api.getCourseList(teacherId)
        .then(res => {
          console.log('课程列表API返回:', JSON.stringify(res));
          uni.hideLoading();
          
          if (res.code === 200) {
            this.courses = res.data || [];
            
            if (this.courses.length === 0) {
              console.log('课程列表为空，添加默认课程');
              const defaultCourses = [
                { _id: 'course_default_1', name: '软件工程' },
                { _id: 'course_default_2', name: '人工智能' }
              ];
              this.courses = defaultCourses;
            }
          } else {
            const existingCourseNames = this.courses.map(course => course.name);
            const defaultCourses = [
              { _id: 'course_default_1', name: '软件工程' },
              { _id: 'course_default_2', name: '人工智能' }
            ];
            const newCourses = defaultCourses.filter(
              defaultCourse => !existingCourseNames.includes(defaultCourse.name)
            );
            
            if (newCourses.length > 0) {
              console.log('添加默认课程:', JSON.stringify(newCourses));
              this.courses = [...this.courses, ...newCourses];
            }
          }
          
          this.courseOptions = this.courses.map(course => course.name);
          console.log('最终课程列表:', JSON.stringify(this.courses));
          console.log('课程选项:', JSON.stringify(this.courseOptions));
        })
        .catch(err => {
          console.error('加载课程列表失败:', err);
          uni.hideLoading();
          console.log('使用默认课程列表');
          
          const defaultCourses = [
            { _id: 'course_default_1', name: '软件工程' },
            { _id: 'course_default_2', name: '人工智能' }
          ];
          this.courses = defaultCourses;
          this.courseOptions = defaultCourses.map(course => course.name);
          
          uni.showToast({
            title: '使用默认课程列表',
            icon: 'none'
          });
        });
    },
    
    loadQuizData() {
      this.isLoading = true
      this.$api.get(`/teacher/quiz/${this.quizId}`)
        .then(res => {
          if (res.code === 200) {
            this.quizData = res.data
            // 确保每个问题的字段正确初始化
            if (this.quizData.questions && this.quizData.questions.length > 0) {
              this.quizData.questions.forEach(question => {
                if (!question.content) {
                  this.$set(question, 'content', '')
                }
                if (!question.type) {
                  this.$set(question, 'type', 'single')
                }
                if (!question.answer) {
                  this.$set(question, 'answer', question.type === 'multiple' ? [] : '')
                }
                if (!question.options || question.options.length === 0) {
                  this.$set(question, 'options', [{ text: '' }, { text: '' }])
                }
              })
            }
          }
        })
        .catch(err => {
          console.error('加载测验数据失败:', err)
          uni.showToast({
            title: '加载测验失败',
            icon: 'none'
          })
        })
        .finally(() => {
          this.isLoading = false
        })
    },
    
    isOptionSelected(question, optionValue) {
      if (question.type === 'single') {
        return question.answer === optionValue
      } else if (question.type === 'multiple') {
        return Array.isArray(question.answer) && question.answer.includes(optionValue)
      }
      return false
    },
    
    handleJudgmentAnswer(question, value) {
      this.$set(question, 'answer', value)
    },
    
    handleOptionChange(question, event, optionValue) {
      if (question.type === 'single') {
        this.$set(question, 'answer', optionValue)
      } else if (question.type === 'multiple') {
        if (!Array.isArray(question.answer)) {
          this.$set(question, 'answer', [])
        }
        const index = question.answer.indexOf(optionValue)
        if (index > -1) {
          question.answer.splice(index, 1)
        } else {
          question.answer.push(optionValue)
        }
      }
    },
    
    handleQuestionContentInput(question, event) {
      this.$set(question, 'content', event.detail.value)
    },
    
    addQuestion() {
      this.quizData.questions.push({
        content: '',
        type: 'single',
        options: [{ text: '' }, { text: '' }],
        answer: ''
      })
    },
    
    deleteQuestion(index) {
      this.quizData.questions.splice(index, 1)
    },
    
    addOption(question) {
      if (question.options.length < 6) {
        this.$set(question.options, question.options.length, { text: '' })
      } else {
        uni.showToast({
          title: '最多添加6个选项',
          icon: 'none'
        })
      }
    },
    
    saveDraft() {
      this.saveQuiz('draft')
    },
    
    publishQuiz() {
      this.saveQuiz('published')
    },
    
    saveQuiz(status) {
      if (!this.validateForm()) {
        return
      }
      
      this.isLoading = true
      this.error = ''
      
      const data = {
        ...this.quizData,
        status: status
      }
      
      const request = this.isEdit
        ? this.$api.put(`/teacher/quiz/${this.quizId}`, data)
        : this.$api.post('/teacher/quiz/create', data)
      
      request.then(res => {
        if (res.code === 200) {
          uni.showToast({
            title: this.isEdit ? '更新成功' : '创建成功',
            icon: 'success'
          })
          // 返回测验列表页面
          uni.navigateBack()
        } else {
          this.error = res.message
        }
      })
      .catch(err => {
        console.error('保存测验失败:', err)
        this.error = '网络错误，请稍后重试'
      })
      .finally(() => {
        this.isLoading = false
      })
    },
    
    validateForm() {
      if (!this.quizData.title.trim()) {
        this.error = '请输入测验标题'
        return false
      }
      
      if (!this.quizData.courseId) {
        this.error = '请选择所属课程'
        return false
      }
      
      if (!this.quizData.startDate || !this.quizData.startTime || !this.quizData.endDate || !this.quizData.endTime) {
        this.error = '请选择开始时间和结束时间'
        return false
      }
      
      const startDateTime = new Date(`${this.quizData.startDate} ${this.quizData.startTime}`)
      const endDateTime = new Date(`${this.quizData.endDate} ${this.quizData.endTime}`)
      
      if (startDateTime >= endDateTime) {
        this.error = '开始时间必须早于结束时间'
        return false
      }
      
      if (this.quizData.questions.length === 0) {
        this.error = '请至少添加一个问题'
        return false
      }
      
      for (let i = 0; i < this.quizData.questions.length; i++) {
        const question = this.quizData.questions[i]
        if (!question.content || !question.content.trim()) {
          this.error = `第${i + 1}个问题内容不能为空`
          return false
        }
        
        if (question.type !== 'judgment') {
          for (let j = 0; j < question.options.length; j++) {
            if (!question.options[j].text || !question.options[j].text.trim()) {
              this.error = `第${i + 1}个问题的第${j + 1}个选项不能为空`
              return false
            }
          }
        }
        
        if (!question.answer || (Array.isArray(question.answer) && question.answer.length === 0)) {
          this.error = `请为第${i + 1}个问题设置正确答案`
          return false
        }
      }
      
      return true
    },
    
    cancel() {
      uni.navigateBack()
    }
  }
}
</script>

<style scoped>
.quiz-page {
  padding: 20rpx 40rpx;
  background-color: #fff;
  min-height: 100vh;
}
.title-bar {
  font-size: 36rpx;
  font-weight: bold;
  text-align: center;
  padding: 30rpx 0;
  color: #333;
}
.form-area {
  margin-bottom: 40rpx;
}
.form-item {
  margin-bottom: 30rpx;
}
.label {
  font-size: 28rpx;
  color: #666;
  margin-bottom: 10rpx;
  display: block;
}
.picker {
  width: 100%;
  padding: 20rpx;
  border: 1px solid #ddd;
  border-radius: 10rpx;
  font-size: 30rpx;
  background-color: #f9f9f9;
  margin-bottom: 10rpx;
}
.textarea {
  width: 100%;
  padding: 20rpx;
  border: 1px solid #ddd;
  border-radius: 10rpx;
  font-size: 30rpx;
  background-color: #f9f9f9;
  min-height: 150rpx;
}
.questions-section {
  margin-bottom: 40rpx;
}
.questions-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
}
.questions-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}
.add-question-btn {
  padding: 15rpx 30rpx;
  background-color: #409eff;
  color: #fff;
  border-radius: 10rpx;
  font-size: 28rpx;
}
.questions-list {
  margin-bottom: 30rpx;
}
.question-item {
  border: 1px solid #eee;
  border-radius: 10rpx;
  padding: 20rpx;
  margin-bottom: 20rpx;
  background-color: #fafafa;
}
.question-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15rpx;
}
.question-index {
  font-size: 30rpx;
  font-weight: bold;
  color: #333;
}
.delete-question-btn {
  padding: 10rpx 20rpx;
  background-color: #f44336;
  color: #fff;
  border-radius: 8rpx;
  font-size: 24rpx;
}
.option-item {
  display: flex;
  align-items: center;
  margin-bottom: 10rpx;
  gap: 15rpx;
}
.option-item input[type="radio"],
.option-item input[type="checkbox"] {
  width: 30rpx;
  height: 30rpx;
}
.option-input {
  flex: 1;
  padding: 15rpx;
  border: 1px solid #ddd;
  border-radius: 8rpx;
  font-size: 28rpx;
}
.add-option-btn {
  margin-top: 10rpx;
  padding: 15rpx 30rpx;
  background-color: #409eff;
  color: #fff;
  border-radius: 8rpx;
  font-size: 26rpx;
}
.btn-area {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
}
.draft-btn {
  height: 80rpx;
  line-height: 80rpx;
  background-color: #f5f5f5;
  color: #666;
  border-radius: 10rpx;
  font-size: 30rpx;
}
.submit-btn {
  height: 80rpx;
  line-height: 80rpx;
  background-color: #409eff;
  color: #fff;
  border-radius: 10rpx;
  font-size: 30rpx;
}
.error-text {
  color: #f44336;
  font-size: 28rpx;
  text-align: center;
  margin-top: 20rpx;
}
.required {
  color: #f44336;
  margin-left: 5rpx;
}
.picker-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
}
.picker-content .placeholder {
  color: #999;
}
.picker-arrow {
  color: #999;
  font-size: 24rpx;
}
</style>