import { defineStore } from 'pinia'
import { login as loginApi, getInfo, logout as logoutApi } from '@/api/auth'

// 用户状态管理
export const useUserStore = defineStore('user', {
  state: () => ({
    token: localStorage.getItem('aurora_blog_token') || '',
    username: '',
    nickname: '',
    avatar: ''
  }),
  actions: {
    async login(loginForm) {
      const res = await loginApi(loginForm)
      this.token = res.data.token
      localStorage.setItem('aurora_blog_token', this.token)
      return res
    },
    async fetchInfo() {
      const res = await getInfo()
      this.username = res.data.username
      this.nickname = res.data.nickname
      this.avatar = res.data.avatar
      return res
    },
    async logout() {
      try {
        await logoutApi()
      } finally {
        this.reset()
      }
    },
    reset() {
      this.token = ''
      this.username = ''
      this.nickname = ''
      this.avatar = ''
      localStorage.removeItem('aurora_blog_token')
    }
  }
})
