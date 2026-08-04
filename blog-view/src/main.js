import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import './styles/global.scss'

// Aurora Blog 前台入口
const app = createApp(App)
app.use(router)
app.mount('#app')
