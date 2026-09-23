<template>
  <view class="login-page">
    <!-- 顶部标题 -->
    <view class="title-bar">登录</view>
    
    <!-- 图标+系统名称 -->
    <view class="logo-area">
      <image class="logo" src="/static/books.png" mode="widthFix"></image>
      <text class="system-name">智能课堂系统</text>
    </view>

    <!-- 输入框区域 -->
    <view class="form-area">
      <!-- 用户名输入框 -->
      <view class="form-item">
        <text class="label">用户名</text>
        <input 
          placeholder="请输入用户名" 
          v-model="form.username"
        />
      </view>

      <!-- 密码输入框 -->
      <view class="form-item">
        <text class="label">密码</text>
        <input 
          type="password"
          placeholder="请输入密码" 
          v-model="form.password"
        />
      </view>

      <!-- 角色选择 -->
      <view class="form-item">
        <text class="label">角色</text>
        <picker 
          class="picker" 
          mode="selector" 
          :range="roleList" 
          @change="handleRoleChange"
        >
          <view>{{ form.role || '请选择角色' }}</view>
        </picker>
      </view>

      <!-- 记住密码 -->
      <view class="remember-area">
        <checkbox 
          class="checkbox" 
          v-model="form.remember"
        />
        <text class="remember-text">记住密码</text>
      </view>
    </view>

    <!-- 按钮区域 -->
    <view class="btn-area">
      <button class="login-btn" @click="handleLogin">登录</button>
      <button class="register-btn" @click="toRegister">立即注册</button>
      <button class="init-btn" @click="handleInit">初始化数据</button>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      // 初始化表单数据（避免编译时undefined报错）
      form: {
        username: '',
        password: '',
        role: '',
        remember: false
      },
      roleList: ['学生', '教师', '管理员'] // 角色选项
    };
  },
  methods: {
    // 角色选择变化
    handleRoleChange(e) {
      this.form.role = this.roleList[e.detail.value];
    },
    // 登录逻辑
    handleLogin() {
      if (!this.form.username) {
        uni.showToast({ title: '请输入用户名', icon: 'none' });
        return;
      }
      if (!this.form.password) {
        uni.showToast({ title: '请输入密码', icon: 'none' });
        return;
      }
      if (!this.form.role) {
        uni.showToast({ title: '请选择角色', icon: 'none' });
        return;
      }
      
      uni.showToast({ title: '登录中...', icon: 'loading' });
      
      this.$api.login(this.form.username, this.form.password).then(res => {
        if (res.code === 200) {
          uni.showToast({ title: '登录成功', icon: 'success' });
          uni.setStorageSync('userInfo', res.data);
          uni.setStorageSync('role', res.data.role);
          
          setTimeout(() => {
            if (res.data.role === '学生') {
              uni.reLaunch({ url: '/pages/index/index' });
            } else if (res.data.role === '教师') {
              uni.reLaunch({ url: '/pages/teacher/dashboard' });
            } else if (res.data.role === '管理员') {
              uni.reLaunch({ url: '/pages/index/index' });
            } else {
              uni.reLaunch({ url: '/pages/index/index' });
            }
          }, 1500);
        } else {
          uni.showToast({ title: res.message, icon: 'none' });
        }
      }).catch(err => {
        console.error('登录失败:', err);
        uni.showToast({ title: '网络错误，请稍后重试', icon: 'none' });
      });
    },
    // 初始化数据
    handleInit() {
      console.log('========== 点击初始化按钮 ==========');
      
      uni.showModal({
        title: '确认初始化',
        content: '确定要创建教师用户12345678和两个考勤任务吗？',
        success: (res) => {
          if (res.confirm) {
            console.log('用户确认初始化');
            uni.showToast({ title: '初始化中...', icon: 'loading' });
            
            this.$api.initData('12345678', '12345678', '教师', '教师')
              .then(res => {
                console.log('========== 初始化API调用完成 ==========');
                console.log('API返回结果:', JSON.stringify(res));
                
                if (res.code === 200) {
                  uni.showToast({ 
                    title: '初始化成功', 
                    icon: 'success',
                    duration: 2000
                  });
                  console.log('初始化成功，数据:', res.data);
                } else {
                  uni.showToast({ 
                    title: res.message || '初始化失败', 
                    icon: 'none',
                    duration: 3000
                  });
                  console.error('初始化失败:', res.message);
                }
              })
              .catch(err => {
                console.error('========== 初始化捕获到异常 ==========');
                console.error('错误对象:', JSON.stringify(err));
                console.error('错误名称:', err.name);
                console.error('错误消息:', err.message);
                console.error('错误堆栈:', err.stack);
                
                uni.showToast({ 
                  title: '网络错误: ' + (err.message || '请稍后重试'), 
                  icon: 'none',
                  duration: 3000
                });
              });
          } else {
            console.log('用户取消初始化');
          }
        }
      });
    },
    // 跳转到注册页
    toRegister() {
      uni.navigateTo({ url: '/pages/register/register' });
    }
  }
};
</script>

<style scoped>
.login-page {
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
.logo-area {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin: 50rpx 0;
}
.logo {
  width: 150rpx;
  height: auto;
}
.system-name {
  font-size: 32rpx;
  font-weight: bold;
  margin-top: 20rpx;
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
.remember-area {
  display: flex;
  align-items: center;
  margin: 20rpx 0;
}
.checkbox {
  transform: scale(0.8);
  margin-right: 10rpx;
}
.remember-text {
  font-size: 26rpx;
  color: #666;
}
.btn-area {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
}
.login-btn {
  height: 80rpx;
  line-height: 80rpx;
  background-color: #409eff;
  color: #fff;
  border-radius: 10rpx;
  font-size: 30rpx;
}
.register-btn {
  height: 80rpx;
  line-height: 80rpx;
  background-color: #f5f5f5;
  color: #666;
  border-radius: 10rpx;
  font-size: 30rpx;
}
.init-btn {
  height: 80rpx;
  line-height: 80rpx;
  background-color: #ff9800;
  color: #fff;
  border-radius: 10rpx;
  font-size: 30rpx;
}
</style>