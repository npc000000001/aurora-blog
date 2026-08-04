<template>
  <div class="login-container">
    <!-- 极光光斑背景 -->
    <div class="aurora-bg">
      <span class="blob blob-cyan"></span>
      <span class="blob blob-purple"></span>
      <span class="blob blob-green"></span>
    </div>

    <!-- 登录卡片 -->
    <div class="login-card">
      <div class="brand">
        <span class="brand-icon">✦</span>
        <h1 class="brand-title">Aurora Admin</h1>
        <p class="brand-sub">极光博客后台管理系统</p>
      </div>

      <el-form ref="formRef" :model="form" :rules="rules" @keyup.enter="handleLogin">
        <el-form-item prop="username">
          <el-input
            v-model="form.username"
            placeholder="用户名"
            :prefix-icon="User"
            size="large"
          />
        </el-form-item>
        <el-form-item prop="password">
          <el-input
            v-model="form.password"
            type="password"
            placeholder="密码"
            :prefix-icon="Lock"
            size="large"
            show-password
          />
        </el-form-item>
        <el-button
          class="aurora-btn"
          size="large"
          :loading="loading"
          @click="handleLogin"
        >
          登 录
        </el-button>
      </el-form>

      <div class="login-tip">默认账号：admin / 123456</div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { User, Lock } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const userStore = useUserStore()
const formRef = ref()
const loading = ref(false)

// 表单预填默认账号
const form = reactive({
  username: 'admin',
  password: '123456'
})

const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
}

// 登录逻辑
const handleLogin = async () => {
  await formRef.value.validate()
  loading.value = true
  try {
    await userStore.login(form)
    ElMessage.success('登录成功')
    router.push('/')
  } catch (e) {
    // 错误已由请求拦截器统一处理
  } finally {
    loading.value = false
  }
}
</script>

<style scoped lang="scss">
.login-container {
  position: relative;
  height: 100vh;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #0a0a1a;
}

// 极光光斑背景
.aurora-bg {
  position: absolute;
  inset: 0;
  z-index: 0;
  overflow: hidden;

  .blob {
    position: absolute;
    border-radius: 50%;
    filter: blur(80px);
    opacity: 0.55;
    will-change: transform;
  }

  .blob-cyan {
    width: 480px;
    height: 480px;
    background: #00d4ff;
    top: -120px;
    left: -80px;
    animation: float1 12s ease-in-out infinite;
  }

  .blob-purple {
    width: 520px;
    height: 520px;
    background: #7c4dff;
    bottom: -160px;
    right: -100px;
    animation: float2 12s ease-in-out infinite;
  }

  .blob-green {
    width: 380px;
    height: 380px;
    background: #43e97b;
    bottom: 10%;
    left: 35%;
    animation: float3 12s ease-in-out infinite;
  }
}

@keyframes float1 {
  0%, 100% { transform: translate(0, 0) scale(1); }
  50% { transform: translate(120px, 80px) scale(1.15); }
}
@keyframes float2 {
  0%, 100% { transform: translate(0, 0) scale(1); }
  50% { transform: translate(-100px, -90px) scale(1.1); }
}
@keyframes float3 {
  0%, 100% { transform: translate(0, 0) scale(1); }
  50% { transform: translate(80px, -70px) scale(1.2); }
}

// 登录卡片
.login-card {
  position: relative;
  z-index: 1;
  width: 400px;
  padding: 44px 40px 32px;
  background: #fff;
  border-radius: 20px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.35);
  animation: cardIn 0.6s ease both;
}

@keyframes cardIn {
  from { opacity: 0; transform: translateY(24px); }
  to { opacity: 1; transform: translateY(0); }
}

.brand {
  text-align: center;
  margin-bottom: 32px;

  .brand-icon {
    font-size: 36px;
    background: linear-gradient(135deg, #00d4ff, #7c4dff);
    -webkit-background-clip: text;
    background-clip: text;
    -webkit-text-fill-color: transparent;
  }

  .brand-title {
    margin: 8px 0 6px;
    font-size: 30px;
    font-weight: 700;
    letter-spacing: 1px;
    background: linear-gradient(135deg, #00d4ff 0%, #7c4dff 100%);
    -webkit-background-clip: text;
    background-clip: text;
    -webkit-text-fill-color: transparent;
  }

  .brand-sub {
    margin: 0;
    font-size: 13px;
    color: #8c8ca1;
  }
}

// 极光渐变按钮
.aurora-btn {
  width: 100%;
  border: none;
  color: #fff;
  font-size: 16px;
  font-weight: 600;
  letter-spacing: 4px;
  border-radius: 10px;
  background: linear-gradient(135deg, #00d4ff, #7c4dff);
  box-shadow: 0 8px 20px rgba(124, 77, 255, 0.35);
  transition: all 0.3s;

  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 12px 28px rgba(0, 212, 255, 0.4);
  }

  &:active {
    transform: translateY(0);
  }
}

.login-tip {
  margin-top: 18px;
  text-align: center;
  font-size: 12px;
  color: #b8b8c8;
}
</style>
