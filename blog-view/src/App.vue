<template>
  <div class="app-wrapper">
    <!-- 极光导航栏 -->
    <header class="navbar" :class="{ scrolled: isScrolled }">
      <div class="container nav-container">
        <router-link to="/" class="logo">
          <span class="logo-icon">✦</span>
          <span class="logo-text">Aurora Blog</span>
        </router-link>

        <nav class="nav-menu" :class="{ active: mobileMenuOpen }">
          <router-link to="/" class="nav-item">
            <span class="nav-icon">⌂</span>首页
          </router-link>
          <router-link to="/archives" class="nav-item">
            <span class="nav-icon">⊞</span>归档
          </router-link>
          <router-link to="/categories" class="nav-item">
            <span class="nav-icon">▤</span>分类
          </router-link>
          <router-link to="/tags" class="nav-item">
            <span class="nav-icon">⬚</span>标签
          </router-link>
          <router-link to="/friends" class="nav-item">
            <span class="nav-icon">❤</span>友链
          </router-link>
          <router-link to="/about" class="nav-item">
            <span class="nav-icon">☉</span>关于
          </router-link>
        </nav>

        <div class="nav-actions">
          <div class="search-box">
            <input
              v-model="searchKeyword"
              type="text"
              placeholder="搜索文章..."
              @keyup.enter="handleSearch"
            />
            <span class="search-icon" @click="handleSearch">⌕</span>
          </div>
          <button class="menu-toggle" @click="mobileMenuOpen = !mobileMenuOpen">
            <span></span><span></span><span></span>
          </button>
        </div>
      </div>
    </header>

    <!-- 主内容区 -->
    <main class="main-content">
      <router-view v-slot="{ Component }">
        <transition name="page" mode="out-in">
          <component :is="Component" />
        </transition>
      </router-view>
    </main>

    <!-- 页脚 -->
    <footer class="footer">
      <div class="container">
        <div class="footer-content">
          <div class="footer-brand">
            <h3>Aurora Blog</h3>
            <p>个人技术博客 · 记录学习与成长</p>
          </div>
          <div class="footer-links">
            <div class="link-group">
              <h4>导航</h4>
              <router-link to="/">首页</router-link>
              <router-link to="/archives">归档</router-link>
              <router-link to="/about">关于</router-link>
            </div>
            <div class="link-group">
              <h4>分类</h4>
              <router-link to="/category/后端开发">后端开发</router-link>
              <router-link to="/category/前端开发">前端开发</router-link>
              <router-link to="/category/技术随笔">技术随笔</router-link>
            </div>
            <div class="link-group">
              <h4>联系</h4>
              <a href="https://github.com" target="_blank">GitHub</a>
              <a href="mailto:your@email.com">Email</a>
            </div>
          </div>
        </div>
        <div class="footer-bottom">
          <p>&copy; {{ year }} Aurora Blog · 基于Spring Boot + Vue3 构建 · 独立开发</p>
        </div>
      </div>
    </footer>

    <!-- 回到顶部 -->
    <transition name="fade">
      <button v-show="isScrolled" class="back-to-top" @click="scrollToTop">
        <span>↑</span>
      </button>
    </transition>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const isScrolled = ref(false)
const mobileMenuOpen = ref(false)
const searchKeyword = ref('')
const year = new Date().getFullYear()

const handleScroll = () => {
  isScrolled.value = window.scrollY > 80
}

const scrollToTop = () => {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

const handleSearch = () => {
  if (searchKeyword.value.trim()) {
    router.push({ path: '/', query: { keyword: searchKeyword.value.trim() } })
    mobileMenuOpen.value = false
  }
}

onMounted(() => window.addEventListener('scroll', handleScroll))
onUnmounted(() => window.removeEventListener('scroll', handleScroll))
</script>

<style scoped lang="scss">
.app-wrapper {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

// 导航栏
.navbar {
  position: sticky;
  top: 0;
  z-index: 100;
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(235, 238, 245, 0.6);
  transition: all 0.3s ease;

  &.scrolled {
    background: rgba(255, 255, 255, 0.95);
    box-shadow: 0 2px 20px rgba(0, 0, 0, 0.06);
  }
}

.nav-container {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 64px;
}

.logo {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 20px;
  font-weight: 700;

  .logo-icon {
    background: linear-gradient(135deg, #00d4ff, #7c4dff);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    font-size: 24px;
  }

  .logo-text {
    background: linear-gradient(90deg, #00d4ff, #7c4dff);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
  }
}

.nav-menu {
  display: flex;
  gap: 4px;

  .nav-item {
    display: flex;
    align-items: center;
    gap: 4px;
    padding: 8px 16px;
    border-radius: 8px;
    color: var(--text-regular);
    font-size: 14px;
    font-weight: 500;
    transition: all 0.2s;

    .nav-icon {
      font-size: 16px;
      opacity: 0.7;
    }

    &:hover {
      color: var(--aurora-purple);
      background: rgba(124, 77, 255, 0.06);
    }

    &.router-link-active {
      color: var(--aurora-purple);
      background: rgba(124, 77, 255, 0.1);
    }
  }
}

.nav-actions {
  display: flex;
  align-items: center;
  gap: 16px;
}

.search-box {
  position: relative;
  display: flex;
  align-items: center;

  input {
    width: 180px;
    height: 36px;
    padding: 0 36px 0 14px;
    border: 1px solid var(--border-base);
    border-radius: 18px;
    background: var(--bg-page);
    font-size: 13px;
    color: var(--text-primary);
    transition: all 0.2s;

    &::placeholder { color: var(--text-placeholder); }

    &:focus {
      outline: none;
      border-color: var(--aurora-purple);
      box-shadow: 0 0 0 3px rgba(124, 77, 255, 0.1);
      background: #fff;
    }
  }

  .search-icon {
    position: absolute;
    right: 12px;
    color: var(--text-secondary);
    cursor: pointer;
    font-size: 16px;
    transition: color 0.2s;

    &:hover { color: var(--aurora-purple); }
  }
}

.menu-toggle {
  display: none;
  flex-direction: column;
  gap: 4px;
  background: none;
  border: none;
  cursor: pointer;
  padding: 8px;

  span {
    width: 22px;
    height: 2px;
    background: var(--text-primary);
    border-radius: 2px;
    transition: all 0.3s;
  }
}

.main-content {
  flex: 1;
  padding: 32px 0;
}

// 页脚
.footer {
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  color: #fff;
  padding: 48px 0 0;

  .footer-content {
    display: grid;
    grid-template-columns: 1.5fr 2fr;
    gap: 48px;
    padding-bottom: 32px;
  }

  .footer-brand {
    h3 {
      font-size: 22px;
      margin-bottom: 8px;
      background: linear-gradient(90deg, #00d4ff, #7c4dff);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }
    p {
      color: rgba(255, 255, 255, 0.6);
      font-size: 14px;
    }
  }

  .footer-links {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 24px;
  }

  .link-group {
    h4 {
      font-size: 14px;
      margin-bottom: 12px;
      color: rgba(255, 255, 255, 0.9);
    }
    a {
      display: block;
      color: rgba(255, 255, 255, 0.5);
      font-size: 13px;
      padding: 4px 0;
      transition: all 0.2s;
      &:hover {
        color: #00d4ff;
        padding-left: 4px;
      }
    }
  }

  .footer-bottom {
    padding: 20px 0;
    border-top: 1px solid rgba(255, 255, 255, 0.08);
    text-align: center;
    p {
      color: rgba(255, 255, 255, 0.4);
      font-size: 13px;
    }
  }
}

// 回到顶部
.back-to-top {
  position: fixed;
  right: 32px;
  bottom: 32px;
  width: 44px;
  height: 44px;
  border: none;
  border-radius: 50%;
  background: linear-gradient(135deg, #00d4ff, #7c4dff);
  color: #fff;
  font-size: 20px;
  cursor: pointer;
  box-shadow: 0 4px 20px rgba(124, 77, 255, 0.4);
  z-index: 99;
  transition: all 0.3s;

  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 28px rgba(124, 77, 255, 0.5);
  }
}

// 页面过渡
.page-enter-active,
.page-leave-active {
  transition: all 0.3s ease;
}
.page-enter-from {
  opacity: 0;
  transform: translateY(16px);
}
.page-leave-to {
  opacity: 0;
  transform: translateY(-16px);
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

// 响应式
@media (max-width: 900px) {
  .nav-menu {
    position: fixed;
    top: 64px;
    left: 0;
    right: 0;
    flex-direction: column;
    background: rgba(255, 255, 255, 0.98);
    backdrop-filter: blur(20px);
    padding: 16px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
    transform: translateY(-100%);
    opacity: 0;
    pointer-events: none;
    transition: all 0.3s;

    &.active {
      transform: translateY(0);
      opacity: 1;
      pointer-events: auto;
    }
  }
  .menu-toggle {
    display: flex;
  }
  .search-box input {
    width: 140px;
  }
  .footer .footer-content {
    grid-template-columns: 1fr;
    gap: 24px;
  }
}

@media (max-width: 600px) {
  .search-box {
    display: none;
  }
}
</style>
