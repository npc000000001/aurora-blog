<template>
  <div class="app-wrapper" :class="{ collapsed: isCollapse }">
    <!-- 侧边栏 -->
    <aside class="sidebar">
      <div class="logo">
        <span class="logo-icon">✦</span>
        <transition name="fade">
          <span v-show="!isCollapse" class="logo-text">Aurora Admin</span>
        </transition>
      </div>
      <el-scrollbar class="menu-scroll">
        <el-menu
          :default-active="activeMenu"
          :collapse="isCollapse"
          :collapse-transition="false"
          router
          unique-opened
          background-color="transparent"
          text-color="#b8b8d0"
          active-text-color="#fff"
        >
          <el-menu-item index="/dashboard">
            <el-icon><DataLine /></el-icon>
            <span>仪表盘</span>
          </el-menu-item>

          <el-sub-menu index="/blog">
            <template #title>
              <el-icon><Document /></el-icon>
              <span>博客管理</span>
            </template>
            <el-menu-item index="/blog/write">写文章</el-menu-item>
            <el-menu-item index="/blog/list">文章管理</el-menu-item>
            <el-menu-item index="/blog/category">分类管理</el-menu-item>
            <el-menu-item index="/blog/tag">标签管理</el-menu-item>
            <el-menu-item index="/blog/comment">评论管理</el-menu-item>
          </el-sub-menu>

          <el-sub-menu index="/page">
            <template #title>
              <el-icon><Files /></el-icon>
              <span>页面管理</span>
            </template>
            <el-menu-item index="/page/setting">站点设置</el-menu-item>
            <el-menu-item index="/page/friend">友链管理</el-menu-item>
            <el-menu-item index="/page/about">关于我</el-menu-item>
          </el-sub-menu>

          <el-sub-menu index="/log">
            <template #title>
              <el-icon><Notebook /></el-icon>
              <span>日志管理</span>
            </template>
            <el-menu-item index="/log/operation">操作日志</el-menu-item>
            <el-menu-item index="/log/visit">访问日志</el-menu-item>
          </el-sub-menu>

          <el-sub-menu index="/statistics">
            <template #title>
              <el-icon><TrendCharts /></el-icon>
              <span>数据统计</span>
            </template>
            <el-menu-item index="/statistics/visitor">访客统计</el-menu-item>
          </el-sub-menu>
        </el-menu>
      </el-scrollbar>
    </aside>

    <!-- 主区域 -->
    <div class="main-area">
      <!-- 顶栏 -->
      <header class="navbar">
        <div class="navbar-left">
          <el-icon class="collapse-btn" @click="isCollapse = !isCollapse">
            <Fold v-if="!isCollapse" />
            <Expand v-else />
          </el-icon>
          <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/dashboard' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item v-for="item in breadcrumbs" :key="item.path">
              {{ item.title }}
            </el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        <div class="navbar-right">
          <el-dropdown @command="handleCommand">
            <div class="user-info">
              <div class="avatar">{{ (userStore.nickname || userStore.username || 'A').charAt(0) }}</div>
              <span class="username">{{ userStore.nickname || userStore.username || '管理员' }}</span>
              <el-icon><ArrowDown /></el-icon>
            </div>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="github">GitHub</el-dropdown-item>
                <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </header>

      <!-- 内容区 -->
      <main class="app-main">
        <router-view v-slot="{ Component }">
          <transition name="fade-transform" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { DataLine, Document, Files, Notebook, TrendCharts, Fold, Expand, ArrowDown } from '@element-plus/icons-vue'
import { useUserStore } from '@/stores/user'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const isCollapse = ref(false)

const activeMenu = computed(() => route.path)

// 面包屑
const breadcrumbs = computed(() => {
  const matched = route.matched.filter(item => item.meta && item.meta.title)
  return matched.map(item => ({ path: item.path, title: item.meta.title }))
})

const handleCommand = async (command) => {
  if (command === 'logout') {
    await userStore.logout()
    router.push('/login')
  } else if (command === 'github') {
    window.open('https://github.com', '_blank')
  }
}

// 拉取用户信息
userStore.fetchInfo().catch(() => {})
</script>

<style scoped lang="scss">
.app-wrapper {
  display: flex;
  height: 100vh;
}

// 侧边栏
.sidebar {
  width: 220px;
  background: #1a1a2e;
  display: flex;
  flex-direction: column;
  transition: width 0.28s;
  overflow: hidden;
  flex-shrink: 0;
}

.collapsed .sidebar {
  width: 64px;
}

.logo {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
  flex-shrink: 0;

  .logo-icon {
    font-size: 24px;
    background: linear-gradient(135deg, #00d4ff, #7c4dff);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
  }

  .logo-text {
    font-size: 16px;
    font-weight: 700;
    background: linear-gradient(90deg, #00d4ff, #7c4dff);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    white-space: nowrap;
  }
}

.menu-scroll {
  flex: 1;
  padding: 12px 0;
}

// Element Plus 菜单覆盖
:deep(.el-menu) {
  border-right: none;
}

:deep(.el-menu-item),
:deep(.el-sub-menu__title) {
  height: 44px;
  line-height: 44px;
  margin: 2px 12px;
  border-radius: 8px;
  transition: all 0.2s;

  &:hover {
    background: rgba(124, 77, 255, 0.15) !important;
  }
}

:deep(.el-menu-item.is-active) {
  background: linear-gradient(135deg, rgba(0, 212, 255, 0.2), rgba(124, 77, 255, 0.2)) !important;
  font-weight: 500;
}

// 主区域
.main-area {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.navbar {
  height: 60px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  border-bottom: 1px solid #ebeef5;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
  flex-shrink: 0;
}

.navbar-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.collapse-btn {
  font-size: 20px;
  cursor: pointer;
  color: #4a4a68;
  transition: color 0.2s;
  &:hover { color: #7c4dff; }
}

.navbar-right {
  display: flex;
  align-items: center;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 6px 12px;
  border-radius: 20px;
  transition: background 0.2s;

  &:hover { background: rgba(124, 77, 255, 0.05); }

  .avatar {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    background: linear-gradient(135deg, #00d4ff, #7c4dff);
    color: #fff;
    font-size: 14px;
    font-weight: 600;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .username {
    font-size: 14px;
    color: #4a4a68;
  }
}

.app-main {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
  background: #f0f2f8;
}

// 过渡动画
.fade-transform-enter-active,
.fade-transform-leave-active {
  transition: all 0.25s;
}
.fade-transform-enter-from {
  opacity: 0;
  transform: translateX(10px);
}
.fade-transform-leave-to {
  opacity: 0;
  transform: translateX(-10px);
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

// 响应式
@media (max-width: 768px) {
  .sidebar {
    position: fixed;
    z-index: 200;
    height: 100vh;
    transform: translateX(0);
  }
  .collapsed .sidebar {
    transform: translateX(-100%);
    width: 220px;
  }
}
</style>
