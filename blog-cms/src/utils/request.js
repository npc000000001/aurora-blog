import axios from 'axios'
import { ElMessage, ElMessageBox } from 'element-plus'
import router from '@/router'

// Aurora Blog 后台请求封装
const service = axios.create({
  baseURL: '/admin',
  timeout: 15000
})

// 请求拦截器：自动携带 JWT
service.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('aurora_blog_token')
    if (token) {
      config.headers['Authorization'] = 'Bearer ' + token
    }
    return config
  },
  (error) => Promise.reject(error)
)

// 响应拦截器：统一处理业务码
service.interceptors.response.use(
  (response) => {
    const res = response.data
    if (res.code === 200) {
      return res
    }
    // 401 未登录 / token 失效
    if (res.code === 401) {
      ElMessageBox.confirm('登录状态已过期，请重新登录', '提示', {
        confirmButtonText: '重新登录',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        localStorage.removeItem('aurora_blog_token')
        router.push('/login')
      })
      return Promise.reject(new Error(res.message || '未登录'))
    }
    // 403 权限不足
    if (res.code === 403) {
      ElMessage.error(res.message || '权限不足')
      return Promise.reject(new Error(res.message || '权限不足'))
    }
    ElMessage.error(res.message || '请求失败')
    return Promise.reject(new Error(res.message || '请求失败'))
  },
  (error) => {
    ElMessage.error(error.message || '网络异常')
    return Promise.reject(error)
  }
)

export default service
