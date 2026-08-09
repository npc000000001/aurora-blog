<template>
  <div class="app-wrapper">
    <!-- 顶部细条导航 -->
    <header class="navbar" :class="{ scrolled: isScrolled }">
      <div class="container nav-container">
        <!-- 左侧 Logo -->
        <router-link to="/" class="logo">
          <span class="logo-mark">✦</span>
          <span class="logo-text">Aurora<span class="logo-dot">.</span>Blog</span>
        </router-link>

        <!-- 中间导航 -->
        <nav class="nav-menu" :class="{ active: mobileMenuOpen }">
          <router-link
            v-for="(item, i) in navItems"
            :key="item.path"
            :to="item.path"
            class="nav-item"
            @click="mobileMenuOpen = false"
          >
            <span class="nav-index">{{ String(i + 1).padStart(2, '0') }}</span>
            <span class="nav-label">{{ item.label }}</span>
          </router-link>
        </nav>

        <!-- 右侧操作 -->
        <div class="nav-actions">
          <div class="search-box" :class="{ active: searchActive }">
            <button class="search-trigger" @click="searchActive = !searchActive" aria-label="搜索">
              <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="11" cy="11" r="7" /><path d="M21 21l-4.3-4.3" />
              </svg>
            </button>
            <input
              v-model="searchKeyword"
              ref="searchInput"
              type="text"
              placeholder="搜索文章…"
              @keyup.enter="handleSearch"
              @blur="searchActive = false"
            />
          </div>
          <button class="menu-toggle" :class="{ active: mobileMenuOpen }" @click="mobileMenuOpen = !mobileMenuOpen" aria-label="菜单">
            <span></span><span></span>
          </button>
        </div>
      </div>

      <!-- 顶部极光线 -->
      <div class="aurora-line"></div>
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
        <div class="footer-top">
          <div class="footer-brand">
            <div class="brand-mark">
              <span class="mark">✦</span>
              <span class="brand-text">Aurora<span class="dot">.</span>Blog</span>
            </div>
            <p class="brand-tagline">个人技术日志 · 代码 · 设计 · 思考</p>
            <p class="brand-desc">基于 Spring Boot + Vue3 独立构建，以编辑型深色极光为美学基调。</p>
          </div>

          <div class="footer-cols">
            <div class="col">
              <h4 class="col-title">导航</h4>
              <router-link to="/" class="col-link">首页</router-link>
              <router-link to="/archives" class="col-link">归档</router-link>
              <router-link to="/about" class="col-link">关于</router-link>
            </div>
            <div class="col">
              <h4 class="col-title">分类</h4>
              <router-link to="/category/后端开发" class="col-link">后端开发</router-link>
              <router-link to="/category/前端开发" class="col-link">前端开发</router-link>
              <router-link to="/category/技术随笔" class="col-link">技术随笔</router-link>
            </div>
            <div class="col">
              <h4 class="col-title">联系</h4>
              <a href="https://github.com" target="_blank" class="col-link">GitHub ↗</a>
              <a href="mailto:your@email.com" class="col-link">Email ↗</a>
            </div>
          </div>
        </div>

        <div class="footer-bottom">
          <span>&copy; {{ year }} Aurora Blog</span>
          <span class="sep">·</span>
          <span>Built with intention</span>
          <span class="sep">·</span>
          <span class="back-top" @click="scrollToTop">回到顶部 ↑</span>
        </div>
      </div>
    </footer>

    <!-- 回到顶部浮动按钮 -->
    <transition name="fade">
      <button v-show="isScrolled" class="back-to-top-btn" @click="scrollToTop" aria-label="回到顶部">
        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M12 19V5M5 12l7-7 7 7" />
        </svg>
      </button>
    </transition>
  </div>
</template>

<script setup>
import { ref, nextTick, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const isScrolled = ref(false)
const mobileMenuOpen = ref(false)
const searchActive = ref(false)
const searchKeyword = ref('')
const searchInput = ref(null)
const year = new Date().getFullYear()

const navItems = [
  { path: '/', label: '首页' },
  { path: '/archives', label: '归档' },
  { path: '/categories', label: '分类' },
  { path: '/tags', label: '标签' },
  { path: '/friends', label: '友链' },
  { path: '/about', label: '关于' }
]

const handleScroll = () => {
  isScrolled.value = window.scrollY > 80
}

const scrollToTop = () => {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

const handleSearch = () => {
  if (searchKeyword.value.trim()) {
    router.push({ path: '/', query: { keyword: searchKeyword.value.trim() } })
    searchActive.value = false
    mobileMenuOpen.value = false
  }
}

const onSearchActive = async (val) => {
  if (val) {
    await nextTick()
    searchInput.value?.focus()
  }
}

import { watch } from 'vue'
watch(searchActive, onSearchActive)

onMounted(() => window.addEventListener('scroll', handleScroll))
onUnmounted(() => window.removeEventListener('scroll', handleScroll))
</script>

<style scoped lang="scss">
.app-wrapper {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

// ─── 顶部导航 ─────────────────────────────────
.navbar {
  position: sticky;
  top: 0;
  z-index: 100;
  background: rgba(10, 14, 26, 0.72);
  backdrop-filter: blur(16px) saturate(180%);
  -webkit-backdrop-filter: blur(16px) saturate(180%);
  border-bottom: 1px solid var(--border-subtle);
  transition: background var(--transition-base);

  &.scrolled {
    background: rgba(10, 14, 26, 0.92);
    border-bottom-color: var(--border-base);
  }
}

.aurora-line {
  position: absolute;
  bottom: -1px;
  left: 0;
  height: 1px;
  width: 100%;
  background: linear-gradient(90deg, transparent 0%, var(--aurora-green) 50%, transparent 100%);
  opacity: 0.4;
  transform: scaleX(0.3);
  transition: transform var(--transition-slow);
}

.navbar.scrolled .aurora-line {
  transform: scaleX(1);
  opacity: 0.6;
}

.nav-container {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 64px;
}

// Logo
.logo {
  display: flex;
  align-items: center;
  gap: 8px;
  font-family: var(--font-display);
  font-size: 20px;
  font-weight: 600;
  letter-spacing: -0.01em;

  .logo-mark {
    color: var(--aurora-green);
    font-size: 18px;
    text-shadow: 0 0 12px rgba(77, 255, 175, 0.5);
  }

  .logo-text {
    color: var(--text-primary);

    .logo-dot {
      color: var(--aurora-green);
    }
  }
}

// 导航菜单
.nav-menu {
  display: flex;
  gap: 2px;

  .nav-item {
    display: flex;
    align-items: baseline;
    gap: 6px;
    padding: 8px 14px;
    color: var(--text-secondary);
    font-size: 13px;
    font-weight: 500;
    transition: color var(--transition-fast);
    position: relative;

    .nav-index {
      font-family: var(--font-mono);
      font-size: 10px;
      color: var(--text-muted);
      transition: color var(--transition-fast);
    }

    .nav-label {
      letter-spacing: 0.02em;
    }

    &::after {
      content: '';
      position: absolute;
      bottom: 2px;
      left: 14px;
      right: 14px;
      height: 1px;
      background: var(--aurora-green);
      transform: scaleX(0);
      transform-origin: left;
      transition: transform var(--transition-base);
    }

    &:hover {
      color: var(--text-primary);
      .nav-index { color: var(--aurora-green); }
    }

    &.router-link-active {
      color: var(--text-primary);
      .nav-index { color: var(--aurora-green); }
      &::after { transform: scaleX(1); }
    }
  }
}

.nav-actions {
  display: flex;
  align-items: center;
  gap: 14px;
}

// 搜索
.search-box {
  display: flex;
  align-items: center;
  gap: 6px;
  height: 34px;
  padding: 0 6px 0 10px;
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius-pill);
  background: rgba(255, 255, 255, 0.02);
  transition: all var(--transition-base);

  .search-trigger {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 24px;
    height: 24px;
    color: var(--text-secondary);
    background: none;
    border: none;
    transition: color var(--transition-fast);

    &:hover { color: var(--aurora-green); }
  }

  input {
    width: 0;
    height: 100%;
    border: none;
    background: transparent;
    color: var(--text-primary);
    font-size: 13px;
    outline: none;
    transition: width var(--transition-base);

    &::placeholder { color: var(--text-muted); }
  }

  &.active {
    border-color: var(--border-aurora);
    background: rgba(77, 255, 175, 0.04);
    input { width: 180px; }
  }
}

// 移动端菜单按钮
.menu-toggle {
  display: none;
  flex-direction: column;
  justify-content: center;
  gap: 5px;
  width: 32px;
  height: 32px;
  background: none;
  border: none;
  padding: 0;

  span {
    display: block;
    width: 20px;
    height: 1.5px;
    background: var(--text-primary);
    margin: 0 auto;
    transition: all var(--transition-base);

    &:first-child { transform: translateY(0); }
  }

  &.active {
    span:first-child { transform: translateY(3.25px) rotate(45deg); }
    span:last-child { transform: translateY(-3.25px) rotate(-45deg); }
  }
}

.main-content {
  flex: 1;
}

// ─── 页脚 ─────────────────────────────────────
.footer {
  margin-top: 80px;
  padding: 64px 0 32px;
  border-top: 1px solid var(--border-subtle);
  background: linear-gradient(to bottom, transparent, rgba(0, 0, 0, 0.2));
}

.footer-top {
  display: grid;
  grid-template-columns: 1.4fr 2fr;
  gap: 64px;
  padding-bottom: 40px;
  border-bottom: 1px solid var(--border-subtle);
}

.footer-brand {
  .brand-mark {
    display: flex;
    align-items: center;
    gap: 8px;
    font-family: var(--font-display);
    font-size: 22px;
    font-weight: 600;
    color: var(--text-primary);
    margin-bottom: 12px;

    .mark { color: var(--aurora-green); }
    .dot { color: var(--aurora-green); }
  }

  .brand-tagline {
    color: var(--text-secondary);
    font-size: 14px;
    margin-bottom: 8px;
  }

  .brand-desc {
    color: var(--text-muted);
    font-size: 13px;
    line-height: 1.7;
    max-width: 340px;
  }
}

.footer-cols {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 32px;
}

.col {
  .col-title {
    font-family: var(--font-mono);
    font-size: 11px;
    font-weight: 500;
    text-transform: uppercase;
    letter-spacing: 0.15em;
    color: var(--aurora-green);
    margin-bottom: 14px;
  }

  .col-link {
    display: block;
    color: var(--text-secondary);
    font-size: 14px;
    padding: 5px 0;
    transition: all var(--transition-fast);

    &:hover {
      color: var(--text-primary);
      transform: translateX(4px);
    }
  }
}

.footer-bottom {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  padding-top: 28px;
  color: var(--text-muted);
  font-family: var(--font-mono);
  font-size: 11px;
  letter-spacing: 0.05em;

  .sep { color: var(--border-base); }

  .back-top {
    cursor: pointer;
    transition: color var(--transition-fast);
    &:hover { color: var(--aurora-green); }
  }
}

// ─── 回到顶部浮动按钮 ─────────────────────────
.back-to-top-btn {
  position: fixed;
  right: 28px;
  bottom: 28px;
  width: 42px;
  height: 42px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--bg-elev-1);
  color: var(--aurora-green);
  border: 1px solid var(--border-aurora);
  border-radius: var(--radius-sm);
  cursor: pointer;
  z-index: 99;
  opacity: 0.9;
  transition: all var(--transition-base);

  &:hover {
    background: var(--aurora-green);
    color: var(--text-inverse);
    transform: translateY(-3px);
    box-shadow: 0 8px 24px rgba(77, 255, 175, 0.25);
  }
}

// ─── 页面过渡 ─────────────────────────────────
.page-enter-active,
.page-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}
.page-enter-from {
  opacity: 0;
  transform: translateY(8px);
}
.page-leave-to {
  opacity: 0;
  transform: translateY(-8px);
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

// ─── 响应式 ───────────────────────────────────
@media (max-width: 960px) {
  .nav-menu {
    position: fixed;
    top: 64px;
    left: 0;
    right: 0;
    flex-direction: column;
    gap: 0;
    padding: 16px var(--container-pad) 24px;
    background: rgba(10, 14, 26, 0.98);
    backdrop-filter: blur(20px);
    border-bottom: 1px solid var(--border-base);
    transform: translateY(-100%);
    opacity: 0;
    pointer-events: none;
    transition: all var(--transition-base);

    &.active {
      transform: translateY(0);
      opacity: 1;
      pointer-events: auto;
    }

    .nav-item {
      padding: 12px 4px;
      border-bottom: 1px solid var(--border-subtle);

      &::after { display: none; }
    }
  }

  .menu-toggle { display: flex; }

  .footer-top {
    grid-template-columns: 1fr;
    gap: 36px;
  }
}

@media (max-width: 600px) {
  .search-box input { display: none; }
  .search-box.active input { width: 140px; display: block; }
}
</style>
