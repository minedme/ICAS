<template>
  <view class="register-page">
    <view class="title-bar">注册</view>
    <view class="logo-area">
      <image class="logo" src="/static/books.png" mode="widthFix"></image>
      <text class="system-name">智能课堂系统 - 注册</text>
    </view>
    <view class="form-area">
      <view class="form-item">
        <text class="label">用户名</text>
        <input 
          type="text" 
          placeholder="请输入用户名" 
          v-model="form.username"
        />
      </view>
      <view class="form-item">
        <text class="label">密码</text>
        <input 
          type="password" 
          placeholder="请输入密码" 
          v-model="form.password"
        />
      </view>
      <view class="form-item">
        <text class="label">真实姓名</text>
        <input 
          type="text" 
          placeholder="请输入真实姓名" 
          v-model="form.realName"
        />
      </view>
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
      <view class="form-item">
        <text class="label">手机号</text>
        <input 
          type="number" 
          placeholder="请输入手机号" 
          v-model="form.phone"
        />
      </view>
      <view class="form-item">
        <text class="label">邮箱</text>
        <input 
          type="text" 
          placeholder="请输入邮箱" 
          v-model="form.email"
        />
      </view>
    </view>
    <button class="register-btn" @click="handleRegister">注册</button>
    <view class="login-link" @click="toLogin">已有账号？登录</view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      form: {
        username: '',
        password: '',
        realName: '',
        role: '',
        phone: '',
        email: ''
      },
      roleList: ['学生', '教师', '管理员']
    };
  },
  methods: {
    handleRoleChange(e) {
      this.form.role = this.roleList[e.detail.value];
    },
    handleRegister() {
      if (!this.form.username) {
        uni.showToast({ title: '请输入用户名', icon: 'none' });
        return;
      }
      if (!this.form.password) {
        uni.showToast({ title: '请输入密码', icon: 'none' });
        return;
      }
      if (!this.form.realName) {
        uni.showToast({ title: '请输入真实姓名', icon: 'none' });
        return;
      }
      if (!this.form.role) {
        uni.showToast({ title: '请选择角色', icon: 'none' });
        return;
      }
      
      uni.showToast({ title: '注册中...', icon: 'loading' });
      
      this.$api.register(this.form.username, this.form.password, this.form.realName, this.form.role, this.form.phone, this.form.email).then(res => {
        if (res.code === 200) {
          uni.showToast({ title: '注册成功', icon: 'success' });
          setTimeout(() => {
            uni.navigateTo({ url: '/pages/login/login' });
          }, 1500);
        } else {
          uni.showToast({ title: res.message, icon: 'none' });
        }
      }).catch(err => {
        console.error('注册失败:', err);
        uni.showToast({ title: '网络错误，请稍后重试', icon: 'none' });
      });
    },
    toLogin() {
      uni.navigateTo({ url: '/pages/login/login' });
    }
  }
};
</script>

<style scoped>
/* 样式和登录页一致，可直接复用 */
.register-page {
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
.register-btn {
  height: 80rpx;
  line-height: 80rpx;
  background-color: #409eff;
  color: #fff;
  border-radius: 10rpx;
  font-size: 30rpx;
  margin-bottom: 20rpx;
}
.login-link {
  text-align: center;
  font-size: 28rpx;
  color: #409eff;
}
</style>