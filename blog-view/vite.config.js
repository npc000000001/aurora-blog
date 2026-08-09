import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

// Aurora Blog 前台 - Vite 配置
export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, 'src')
    }
  },
  server: {
    port: 8081,
    open: true,
    proxy: {
      '/blog': {
        target: 'http://localhost:8090',
        changeOrigin: true
      },
      '/category': {
        target: 'http://localhost:8090',
        changeOrigin: true
      },
      '/tag': {
        target: 'http://localhost:8090',
        changeOrigin: true
      },
      '/friend': {
        target: 'http://localhost:8090',
        changeOrigin: true
      },
      '/comment': {
        target: 'http://localhost:8090',
        changeOrigin: true
      }
    }
  }
})
