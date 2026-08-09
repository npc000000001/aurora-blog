<template>
  <div class="home">
    <!-- 编辑型 Hero 区 -->
    <section class="hero">
      <div class="hero-bg">
        <div class="grid-lines"></div>
        <div class="aurora-glow glow-1"></div>
        <div class="aurora-glow glow-2"></div>
      </div>

      <div class="container hero-inner">
        <!-- 顶部期刊式信息条 -->
        <div class="hero-meta">
          <span class="meta-left">
            <span class="meta-dot"></span>
            <span class="meta-text">VOL.01 · 个人技术日志</span>
          </span>
          <span class="meta-right">{{ today }}</span>
        </div>

        <!-- 主标题 -->
        <h1 class="hero-title">
          <span class="title-line">Aurora</span>
          <span class="title-line title-italic">Blog<span class="title-dot">.</span></span>
        </h1>

        <!-- 副标题 -->
        <p class="hero-tagline">
          一份关于<span class="accent">代码</span>、<span class="accent">设计</span>与<span class="accent">思考</span>的个人技术日志。
        </p>

        <!-- 统计 -->
        <div class="hero-stats">
          <div class="stat">
            <span class="stat-num">{{ stats.blogCount }}</span>
            <span class="stat-label">Articles</span>
          </div>
          <div class="stat-divider"></div>
          <div class="stat">
            <span class="stat-num">{{ stats.totalViews }}</span>
            <span class="stat-label">Views</span>
          </div>
          <div class="stat-divider"></div>
          <div class="stat">
            <span class="stat-num">{{ stats.categoryCount }}</span>
            <span class="stat-label">Categories</span>
          </div>
        </div>

        <!-- 滚动提示 -->
        <div class="scroll-hint" @click="scrollToContent">
          <span class="hint-text">Scroll</span>
          <span class="hint-line"></span>
        </div>
      </div>
    </section>

    <!-- 内容区 -->
    <div class="content-wrapper" id="content">
      <div class="container">
        <!-- 章节标题 -->
        <div class="section-header">
          <div class="section-meta">
            <span class="section-num">01</span>
            <span class="section-line"></span>
          </div>
          <h2 class="section-title">
            {{ searchKeyword ? `搜索：${searchKeyword}` : '最新文章' }}
          </h2>
          <p class="section-sub">Latest · 按时间倒序排列</p>
        </div>

        <div class="layout">
          <!-- 文章列表 -->
          <div class="main-col">
            <div class="blog-list" v-loading="loading">
              <BlogCard
                v-for="(blog, i) in list"
                :key="blog.id"
                :blog="blog"
                :index="(pageNum - 1) * pageSize + i + 1"
              />
            </div>

            <div v-if="!loading && list.length === 0" class="empty-state">
              <div class="empty-mark">∅</div>
              <p class="empty-text">暂无文章，敬请期待</p>
            </div>

            <!-- 分页 -->
            <div v-if="total > pageSize" class="pagination">
              <button :disabled="pageNum <= 1" @click="changePage(pageNum - 1)" class="page-nav">
                <span class="nav-arrow">←</span>
                <span>Prev</span>
              </button>
              <div class="page-numbers">
                <button
                  v-for="p in displayPages"
                  :key="p"
                  :class="['page-btn', { active: p === pageNum }]"
                  @click="changePage(p)"
                >{{ String(p).padStart(2, '0') }}</button>
              </div>
              <button :disabled="pageNum >= totalPages" @click="changePage(pageNum + 1)" class="page-nav">
                <span>Next</span>
                <span class="nav-arrow">→</span>
              </button>
            </div>
          </div>

          <!-- 侧边栏 -->
          <Sidebar />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import { pageBlog } from '@/api/blog'
import BlogCard from '@/components/BlogCard.vue'
import Sidebar from '@/components/Sidebar.vue'

const route = useRoute()
const loading = ref(false)
const list = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(5)
const searchKeyword = ref(route.query.keyword || '')

const stats = ref({ blogCount: 0, totalViews: 0, categoryCount: 0 })

const totalPages = computed(() => Math.ceil(total.value / pageSize.value))

const today = new Date().toLocaleDateString('zh-CN', { year: 'numeric', month: 'long', day: 'numeric' })

const displayPages = computed(() => {
  const pages = []
  const max = totalPages.value
  const cur = pageNum.value
  let start = Math.max(1, cur - 2)
  let end = Math.min(max, start + 4)
  start = Math.max(1, end - 4)
  for (let i = start; i <= end; i++) pages.push(i)
  return pages
})

const fetchList = async () => {
  loading.value = true
  try {
    const res = await pageBlog({
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      title: searchKeyword.value || undefined
    })
    list.value = res.data.records
    total.value = res.data.total
    stats.value.blogCount = total.value
    stats.value.totalViews = list.value.reduce((sum, b) => sum + (b.views || 0), 0)
  } finally {
    loading.value = false
  }
}

const changePage = (p) => {
  if (p < 1 || p > totalPages.value) return
  pageNum.value = p
  fetchList()
  document.getElementById('content')?.scrollIntoView({ behavior: 'smooth' })
}

const scrollToContent = () => {
  document.getElementById('content')?.scrollIntoView({ behavior: 'smooth' })
}

watch(() => route.query.keyword, (val) => {
  searchKeyword.value = val || ''
  pageNum.value = 1
  fetchList()
})

onMounted(fetchList)
</script>

<style scoped lang="scss">
// ─── Hero 区 ──────────────────────────────────
.hero {
  position: relative;
  min-height: 92vh;
  display: flex;
  align-items: center;
  overflow: hidden;
  padding: 120px 0 80px;
}

.hero-bg {
  position: absolute;
  inset: 0;
  z-index: 0;
  pointer-events: none;
}

// 网格线背景
.grid-lines {
  position: absolute;
  inset: 0;
  background-image:
    linear-gradient(rgba(255, 255, 255, 0.025) 1px, transparent 1px),
    linear-gradient(90deg, rgba(255, 255, 255, 0.025) 1px, transparent 1px);
  background-size: 80px 80px;
  mask-image: radial-gradient(ellipse 80% 70% at center, black 0%, transparent 80%);
  -webkit-mask-image: radial-gradient(ellipse 80% 70% at center, black 0%, transparent 80%);
}

// 极光光晕
.aurora-glow {
  position: absolute;
  border-radius: 50%;
  filter: blur(100px);
  opacity: 0.4;
  animation: float-glow 14s ease-in-out infinite;

  &.glow-1 {
    width: 500px;
    height: 500px;
    background: var(--aurora-green);
    top: -100px;
    left: -150px;
    opacity: 0.18;
  }

  &.glow-2 {
    width: 400px;
    height: 400px;
    background: var(--aurora-violet);
    bottom: -100px;
    right: -100px;
    opacity: 0.15;
    animation-delay: -7s;
  }
}

@keyframes float-glow {
  0%, 100% { transform: translate(0, 0); }
  50% { transform: translate(40px, 30px); }
}

.hero-inner {
  position: relative;
  z-index: 1;
}

// 顶部期刊信息
.hero-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-family: var(--font-mono);
  font-size: 11px;
  letter-spacing: 0.12em;
  color: var(--text-muted);
  margin-bottom: 48px;
  padding-bottom: 14px;
  border-bottom: 1px solid var(--border-subtle);

  .meta-left {
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .meta-dot {
    width: 6px;
    height: 6px;
    background: var(--aurora-green);
    border-radius: 50%;
    animation: pulse-dot 2s infinite;
  }

  .meta-right {
    text-transform: uppercase;
  }
}

// 主标题
.hero-title {
  font-family: var(--font-display);
  font-size: clamp(72px, 14vw, 180px);
  font-weight: 700;
  line-height: 0.95;
  letter-spacing: -0.04em;
  margin-bottom: 32px;
  font-feature-settings: 'ss01', 'ss02';

  .title-line {
    display: block;
    color: var(--text-primary);
  }

  .title-italic {
    font-style: italic;
    font-weight: 300;
    color: var(--text-regular);

    .title-dot {
      color: var(--aurora-green);
    }
  }
}

// 副标题
.hero-tagline {
  font-size: clamp(16px, 1.6vw, 19px);
  color: var(--text-secondary);
  line-height: 1.7;
  max-width: 520px;
  margin-bottom: 56px;

  .accent {
    color: var(--aurora-green);
    font-weight: 500;
    transition: color var(--transition-fast);

    &:hover { color: var(--text-primary); }
  }
}

// 统计
.hero-stats {
  display: flex;
  align-items: baseline;
  gap: 32px;
  margin-bottom: 56px;
}

.stat {
  display: flex;
  flex-direction: column;
  gap: 4px;

  .stat-num {
    font-family: var(--font-display);
    font-size: 38px;
    font-weight: 600;
    color: var(--text-primary);
    line-height: 1;
    letter-spacing: -0.02em;
    font-feature-settings: 'lnum', 'tnum';
  }

  .stat-label {
    font-family: var(--font-mono);
    font-size: 10px;
    text-transform: uppercase;
    letter-spacing: 0.15em;
    color: var(--text-muted);
  }
}

.stat-divider {
  width: 1px;
  height: 28px;
  background: var(--border-base);
  align-self: center;
}

// 滚动提示
.scroll-hint {
  display: inline-flex;
  align-items: center;
  gap: 14px;
  cursor: pointer;
  padding: 8px 0;
  transition: transform var(--transition-base);

  .hint-text {
    font-family: var(--font-mono);
    font-size: 11px;
    text-transform: uppercase;
    letter-spacing: 0.2em;
    color: var(--text-secondary);
  }

  .hint-line {
    position: relative;
    width: 60px;
    height: 1px;
    background: var(--border-base);
    overflow: hidden;

    &::after {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 30%;
      height: 100%;
      background: var(--aurora-green);
      animation: hint-sweep 2.5s ease-in-out infinite;
    }
  }

  &:hover {
    transform: translateX(4px);
    .hint-text { color: var(--aurora-green); }
  }
}

@keyframes hint-sweep {
  0% { left: -30%; }
  100% { left: 100%; }
}

// ─── 内容区 ───────────────────────────────────
.content-wrapper {
  padding: 40px 0 80px;
}

// 章节标题
.section-header {
  display: grid;
  grid-template-columns: 60px 1fr auto;
  gap: 20px;
  align-items: end;
  padding-bottom: 24px;
  margin-bottom: 24px;
  border-bottom: 1px solid var(--border-subtle);

  .section-meta {
    display: flex;
    flex-direction: column;
    gap: 10px;
    padding-bottom: 6px;

    .section-num {
      font-family: var(--font-mono);
      font-size: 11px;
      color: var(--aurora-green);
      letter-spacing: 0.1em;
    }

    .section-line {
      width: 24px;
      height: 1px;
      background: var(--aurora-green);
    }
  }

  .section-title {
    font-family: var(--font-display);
    font-size: clamp(28px, 4vw, 44px);
    font-weight: 600;
    color: var(--text-primary);
    letter-spacing: -0.02em;
    line-height: 1.1;
  }

  .section-sub {
    font-family: var(--font-mono);
    font-size: 11px;
    text-transform: uppercase;
    letter-spacing: 0.15em;
    color: var(--text-muted);
    padding-bottom: 10px;
  }
}

// 布局
.layout {
  display: grid;
  grid-template-columns: 1fr 320px;
  gap: 48px;
  align-items: start;
}

.main-col { min-width: 0; }

// 空状态
.empty-state {
  text-align: center;
  padding: 80px 20px;

  .empty-mark {
    font-family: var(--font-display);
    font-size: 72px;
    color: var(--text-muted);
    margin-bottom: 16px;
  }

  .empty-text {
    color: var(--text-secondary);
    font-size: 14px;
  }
}

// ─── 分页 ─────────────────────────────────────
.pagination {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 16px;
  margin-top: 48px;
  padding-top: 32px;
  border-top: 1px solid var(--border-subtle);

  .page-nav {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 8px 16px;
    background: transparent;
    border: 1px solid var(--border-subtle);
    border-radius: var(--radius-xs);
    color: var(--text-secondary);
    font-family: var(--font-mono);
    font-size: 12px;
    letter-spacing: 0.05em;
    transition: all var(--transition-fast);

    &:hover:not(:disabled) {
      color: var(--aurora-green);
      border-color: var(--border-aurora);
    }

    &:disabled {
      opacity: 0.3;
      cursor: not-allowed;
    }
  }

  .page-numbers {
    display: flex;
    gap: 4px;
  }

  .page-btn {
    min-width: 36px;
    height: 36px;
    padding: 0 10px;
    background: transparent;
    border: 1px solid transparent;
    border-radius: var(--radius-xs);
    color: var(--text-secondary);
    font-family: var(--font-mono);
    font-size: 12px;
    transition: all var(--transition-fast);

    &:hover {
      color: var(--text-primary);
      background: rgba(255, 255, 255, 0.04);
    }

    &.active {
      color: var(--aurora-green);
      border-color: var(--border-aurora);
      background: rgba(77, 255, 175, 0.06);
    }
  }
}

// ─── 响应式 ───────────────────────────────────
@media (max-width: 960px) {
  .layout {
    grid-template-columns: 1fr;
    gap: 32px;
  }
  .hero {
    min-height: 80vh;
    padding: 100px 0 60px;
  }
  .hero-stats { gap: 20px; }
  .stat .stat-num { font-size: 30px; }
}

@media (max-width: 600px) {
  .section-header {
    grid-template-columns: 1fr;
    gap: 8px;

    .section-sub { padding-bottom: 0; }
  }
  .hero-meta .meta-right { display: none; }
  .pagination {
    flex-wrap: wrap;
    gap: 8px;
  }
}
</style>
