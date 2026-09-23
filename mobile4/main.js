import Vue from 'vue'
import App from './App'

Vue.config.productionTip = false

App.mpType = 'app'

Vue.prototype.$cloud = uniCloud.init({
  provider: 'aliyun',
  spaceId: 'mp-44d8765e-5b2e-47a6-bb16-8341a8ef6a7d',
  clientSecret: 'gLmrYJYdnGrRZzeHKwJedg=='
})

Vue.prototype.$api = {
  request: function(url, method, data) {
    return new Promise((resolve, reject) => {
      uni.request({
        url: 'http://192.168.91.93:8091' + url,
        method: method,
        data: data,
        header: {
          'content-type': 'application/json'
        },
        success: (res) => {
          resolve(res.data)
        },
        fail: (err) => {
          reject(err)
        }
      })
    })
  },
  get: function(url, data) {
    return this.request(url, 'GET', data)
  },
  post: function(url, data) {
    return this.request(url, 'POST', data)
  },
  put: function(url, data) {
    return this.request(url, 'PUT', data)
  },
  createAttendance: function(attendanceData) {
    return new Promise((resolve, reject) => {
      uniCloud.callFunction({
        name: 'createAttendance',
        data: attendanceData,
        success: (res) => {
          if (res.result.code === 0) {
            resolve({
              code: 200,
              message: res.result.message,
              data: res.result.data
            })
          } else {
            resolve({
              code: 400,
              message: res.result.message
            })
          }
        },
        fail: (err) => {
          reject(err)
        }
      })
    })
  },
  getAttendanceList: function(teacherId) {
    return new Promise((resolve, reject) => {
      uniCloud.callFunction({
        name: 'getAttendanceList',
        data: {
          teacherId: teacherId
        },
        success: (res) => {
          if (res.result.code === 0) {
            resolve({
              code: 200,
              message: res.result.message,
              data: res.result.data
            })
          } else {
            resolve({
              code: 400,
              message: res.result.message
            })
          }
        },
        fail: (err) => {
          reject(err)
        }
      })
    })
  },
  getAttendanceDetail: function(attendanceId) {
    return new Promise((resolve, reject) => {
      uniCloud.callFunction({
        name: 'getAttendanceDetail',
        data: {
          attendanceId: attendanceId
        },
        success: (res) => {
          if (res.result.code === 0) {
            resolve({
              code: 200,
              message: res.result.message,
              data: res.result.data
            })
          } else {
            resolve({
              code: 400,
              message: res.result.message
            })
          }
        },
        fail: (err) => {
          reject(err)
        }
      })
    })
  },
  scanSign: function(qrCode, studentId) {
    return new Promise((resolve, reject) => {
      uniCloud.callFunction({
        name: 'scanSign',
        data: {
          qrCode: qrCode,
          studentId: studentId
        },
        success: (res) => {
          if (res.result.code === 0) {
            resolve({
              code: 200,
              message: res.result.message
            })
          } else {
            resolve({
              code: 400,
              message: res.result.message
            })
          }
        },
        fail: (err) => {
          reject(err)
        }
      })
    })
  },
  gpsSign: function(attendanceId, studentId, latitude, longitude) {
    return new Promise((resolve, reject) => {
      uniCloud.callFunction({
        name: 'gpsSign',
        data: {
          attendanceId: attendanceId,
          studentId: studentId,
          latitude: latitude,
          longitude: longitude
        },
        success: (res) => {
          if (res.result.code === 0) {
            resolve({
              code: 200,
              message: res.result.message
            })
          } else {
            resolve({
              code: 400,
              message: res.result.message
            })
          }
        },
        fail: (err) => {
          reject(err)
        }
      })
    })
  },
  initData: function(username, password, realName, role) {
    console.log('========== 开始调用initData云函数 ==========');
    console.log('参数:', { username, password, realName, role });
    
    return new Promise((resolve, reject) => {
      uniCloud.callFunction({
        name: 'initData',
        data: {
          username: username,
          password: password,
          realName: realName,
          role: role
        },
        success: (res) => {
          console.log('========== 云函数调用成功 ==========');
          console.log('返回结果:', JSON.stringify(res));
          console.log('res.result:', JSON.stringify(res.result));
          
          if (res.result.code === 0) {
            console.log('初始化成功，数据:', res.result.data);
            resolve({
              code: 200,
              message: res.result.message,
              data: res.result.data
            })
          } else {
            console.log('初始化失败，错误信息:', res.result.message);
            resolve({
              code: 400,
              message: res.result.message
            })
          }
        },
        fail: (err) => {
          console.error('========== 云函数调用失败 ==========');
          console.error('错误对象:', JSON.stringify(err));
          console.error('错误名称:', err.name);
          console.error('错误消息:', err.message);
          console.error('错误堆栈:', err.stack);
          console.error('完整错误:', err);
          reject(err)
        }
      })
    })
  },
  login: function(username, password) {
    return new Promise((resolve, reject) => {
      uniCloud.callFunction({
        name: 'loginUser',
        data: {
          username: username,
          password: password
        },
        success: (res) => {
          if (res.result.code === 0) {
            resolve({
              code: 200,
              message: res.result.message,
              data: res.result.data
            })
          } else {
            resolve({
              code: 400,
              message: res.result.message
            })
          }
        },
        fail: (err) => {
          reject(err)
        }
      })
    })
  },
  register: function(username, password, realName, role, phone, email) {
    return new Promise((resolve, reject) => {
      uniCloud.callFunction({
        name: 'registerUser',
        data: {
          user: {
            username: username,
            password: password,
            realName: realName,
            role: role,
            phone: phone,
            email: email
          }
        },
        success: (res) => {
          if (res.result.code === 0) {
            resolve({
              code: 200,
              message: res.result.message
            })
          } else {
            resolve({
              code: 400,
              message: res.result.message
            })
          }
        },
        fail: (err) => {
          reject(err)
        }
      })
    })
  },
  getUserList: function() {
    return new Promise((resolve, reject) => {
      uniCloud.callFunction({
        name: 'getUserList',
        success: (res) => {
          if (res.result.code === 0) {
            resolve({
              code: 200,
              message: res.result.message,
              data: res.result.data
            })
          } else {
            resolve({
              code: 400,
              message: res.result.message
            })
          }
        },
        fail: (err) => {
          reject(err)
        }
      })
    })
  },
  getQuizList: function(teacherId) {
    return new Promise((resolve, reject) => {
      uniCloud.callFunction({
        name: 'getQuizList',
        data: {
          teacherId: teacherId
        },
        success: (res) => {
          if (res.result.code === 0) {
            resolve({
              code: 200,
              message: res.result.message,
              data: res.result.data
            })
          } else {
            resolve({
              code: 400,
              message: res.result.message
            })
          }
        },
        fail: (err) => {
          reject(err)
        }
      })
    })
  },
  getCourseList: function(teacherId) {
    return new Promise((resolve, reject) => {
      uniCloud.callFunction({
        name: 'getCourseList',
        data: {
          teacherId: teacherId
        },
        success: (res) => {
          if (res.result.code === 0) {
            resolve({
              code: 200,
              message: res.result.message,
              data: res.result.data
            })
          } else {
            resolve({
              code: 400,
              message: res.result.message
            })
          }
        },
        fail: (err) => {
          reject(err)
        }
      })
    })
  },
  getStudentRecords: function(studentId, page, pageSize, filter) {
    return new Promise((resolve, reject) => {
      uniCloud.callFunction({
        name: 'getStudentRecords',
        data: {
          studentId: studentId,
          page: page,
          pageSize: pageSize,
          filter: filter
        },
        success: (res) => {
          if (res.result.code === 0) {
            resolve({
              code: 200,
              message: res.result.message,
              data: res.result.data
            })
          } else {
            resolve({
              code: 400,
              message: res.result.message
            })
          }
        },
        fail: (err) => {
          reject(err)
        }
      })
    })
  },
  getStudentQuizList: function(studentId, page, pageSize, filter) {
    return new Promise((resolve, reject) => {
      uniCloud.callFunction({
        name: 'getStudentQuizList',
        data: {
          studentId: studentId,
          page: page,
          pageSize: pageSize,
          filter: filter
        },
        success: (res) => {
          if (res.result.code === 0) {
            resolve({
              code: 200,
              message: res.result.message,
              data: res.result.data
            })
          } else {
            resolve({
              code: 400,
              message: res.result.message
            })
          }
        },
        fail: (err) => {
          reject(err)
        }
      })
    })
  }
}

const app = new Vue({
  ...App
})
app.$mount()