import axios from 'axios'

// Aurora Blog 前台请求封装（无需 JWT）
const service = axios.create({
  timeout: 15000
})

service.interceptors.response.use(
  (response) => {
    const res = response.data
    if (res.code === 200) {
      return res
    }
    return Promise.reject(new Error(res.message || '请求失败'))
  },
  (error) => Promise.reject(error)
)

export default service
