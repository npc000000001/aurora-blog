<template>
  <div class="home">
    <!-- 极光 Hero 区 -->
    <section class="hero">
      <div class="hero-bg">
        <div class="aurora-blob blob-1"></div>
        <div class="aurora-blob blob-2"></div>
        <div class="aurora-blob blob-3"></div>
        <div class="grid-overlay"></div>
      </div>
      <div class="hero-content">
        <h1 class="hero-title" data-text="Aurora Blog">Aurora Blog</h1>
        <p class="hero-subtitle">极光闪烁 · 记录技术成长之路</p>
        <div class="hero-stats">
          <div class="stat">
            <span class="stat-num">{{ stats.blogCount }}</span>
            <span class="stat-label">文章</span>
          </div>
          <div class="stat-divider"></div>
          <div class="stat">
            <span class="stat-num">{{ stats.totalViews }}</span>
            <span class="stat-label">浏览</span>
          </div>
          <div class="stat-divider"></div>
          <div class="stat">
            <span class="stat-num">{{ stats.categoryCount }}</span>
            <span class="stat-label">分类</span>
          </div>
        </div>
      </div>
      <div class="scroll-down" @click="scrollToContent">
        <span class="mouse">
          <span class="wheel"></span>
        </span>
      </div>
    </section>

    <!-- 内容区 -->
    <div class="content-wrapper" id="content">
      <div class="container">
        <div class="layout">
          <!-- 文章列表 -->
          <div class="main-col">
            <div class="section-header" v-if="searchKeyword">
              <h2>搜索：{{ searchKeyword }}</h2>
            </div>

            <div class="blog-list" v-loading="loading">
              <BlogCard v-for="blog in list" :key="blog.id" :blog="blog" />
            </div>

            <div v-if="!loading && list.length === 0" class="empty-state">
              <div class="empty-icon">🌌</div>
              <p>暂无文章，敬请期待</p>
            </div>

            <!-- 分页 -->
            <div v-if="total > pageSize" class="pagination">
              <button :disabled="pageNum <= 1" @click="changePage(pageNum - 1)">← 上一页</button>
              <div class="page-numbers">
                <button
                  v-for="p in displayPages"
                  :key="p"
                  :class="['page-btn', { active: p === pageNum }]"
                  @click="changePage(p)"
                >{{ p }}</button>
              </div>
              <button :disabled="pageNum >= totalPages" @click="changePage(pageNum + 1)">下一页 →</button>
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

// 计算显示的页码
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
    // 更新统计
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
// Hero 区
.hero {
  position: relative;
  height: 100vh;
  min-height: 600px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  background: #0a0a1a;
}

.hero-bg {
  position: absolute;
  inset: 0;
  z-index: 0;
}

// 极光光斑
.aurora-blob {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.6;
  animation: float-blob 12s ease-in-out infinite;

  &.blob-1 {
    width: 500px;
    height: 500px;
    background: #00d4ff;
    top: -100px;
    left: -100px;
    animation-delay: 0s;
  }
  &.blob-2 {
    width: 450px;
    height: 450px;
    background: #7c4dff;
    bottom: -100px;
    right: -50px;
    animation-delay: -4s;
  }
  &.blob-3 {
    width: 400px;
    height: 400px;
    background: #43e97b;
    top: 40%;
    left: 50%;
    animation-delay: -8s;
    opacity: 0.3;
  }
}

@keyframes float-blob {
  0%, 100% { transform: translate(0, 0) scale(1); }
  33% { transform: translate(40px, -30px) scale(1.1); }
  66% { transform: translate(-30px, 40px) scale(0.95); }
}

// 网格叠加
.grid-overlay {
  position: absolute;
  inset: 0;
  background-image:
    linear-gradient(rgba(255,255,255,0.03) 1px, transparent 1px),
    linear-gradient(90deg, rgba(255,255,255,0.03) 1px, transparent 1px);
  background-size: 50px 50px;
  z-index: 1;
}

.hero-content {
  position: relative;
  z-index: 2;
  text-align: center;
  color: #fff;
}

// 故障风标题
.hero-title {
  font-size: clamp(48px, 8vw, 96px);
  font-weight: 800;
  letter-spacing: -2px;
  background: linear-gradient(135deg, #00d4ff 0%, #ffffff 50%, #7c4dff 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  position: relative;
  margin-bottom: 16px;

  // 故障双层错位
  &::before, &::after {
    content: attr(data-text);
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    -webkit-background-clip: text;
    background-clip: text;
    opacity: 0.7;
  }
  &::before {
    color: #00d4ff;
    animation: glitch-1 3s infinite;
    clip-path: polygon(0 0, 100% 0, 100% 45%, 0 45%);
  }
  &::after {
    color: #7c4dff;
    animation: glitch-2 3s infinite;
    clip-path: polygon(0 55%, 100% 55%, 100% 100%, 0 100%);
  }
}

@keyframes glitch-1 {
  0%, 100% { transform: translate(0); }
  20% { transform: translate(-3px, 2px); }
  40% { transform: translate(3px, -2px); }
  60% { transform: translate(-2px, 1px); }
  80% { transform: translate(2px, -1px); }
}
@keyframes glitch-2 {
  0%, 100% { transform: translate(0); }
  20% { transform: translate(3px, -2px); }
  40% { transform: translate(-3px, 2px); }
  60% { transform: translate(2px, -1px); }
  80% { transform: translate(-2px, 1px); }
}

.hero-subtitle {
  font-size: clamp(16px, 2vw, 20px);
  color: rgba(255, 255, 255, 0.75);
  letter-spacing: 4px;
  margin-bottom: 40px;
}

// 统计数据
.hero-stats {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 32px;
  margin-bottom: 0;
}

.stat {
  text-align: center;
}

.stat-num {
  display: block;
  font-size: 32px;
  font-weight: 700;
  background: linear-gradient(135deg, #00d4ff, #43e97b);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.stat-label {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.5);
  letter-spacing: 2px;
}

.stat-divider {
  width: 1px;
  height: 36px;
  background: rgba(255, 255, 255, 0.15);
}

// 滚动提示
.scroll-down {
  position: absolute;
  bottom: 40px;
  left: 50%;
  transform: translateX(-50%);
  cursor: pointer;
  z-index: 2;
}

.mouse {
  display: block;
  width: 26px;
  height: 42px;
  border: 2px solid rgba(255, 255, 255, 0.4);
  border-radius: 14px;
  position: relative;

  .wheel {
    position: absolute;
    top: 8px;
    left: 50%;
    transform: translateX(-50%);
    width: 4px;
    height: 8px;
    background: #fff;
    border-radius: 2px;
    animation: wheel 1.8s ease infinite;
  }
}

@keyframes wheel {
  0% { opacity: 1; transform: translate(-50%, 0); }
  100% { opacity: 0; transform: translate(-50%, 16px); }
}

// 内容区
.content-wrapper {
  padding: 48px 0 64px;
}

.layout {
  display: grid;
  grid-template-columns: 1fr 320px;
  gap: 32px;
  align-items: start;
}

.section-header {
  margin-bottom: 24px;
  h2 {
    font-size: 20px;
    color: #1a1a2e;
    padding-left: 12px;
    border-left: 3px solid;
    border-image: linear-gradient(180deg, #00d4ff, #7c4dff) 1;
  }
}

.blog-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.empty-state {
  text-align: center;
  padding: 80px 0;

  .empty-icon { font-size: 48px; margin-bottom: 16px; }
  p { color: #9a9ab0; font-size: 15px; }
}

// 分页
.pagination {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 16px;
  margin-top: 40px;

  button {
    padding: 8px 18px;
    border: 1px solid #ebeef5;
    background: #fff;
    border-radius: 8px;
    color: #4a4a68;
    font-size: 13px;
    cursor: pointer;
    transition: all 0.2s;

    &:hover:not(:disabled) {
      border-color: #7c4dff;
      color: #7c4dff;
    }
    &:disabled { opacity: 0.4; cursor: not-allowed; }
  }

  .page-numbers {
    display: flex;
    gap: 4px;
  }

  .page-btn {
    min-width: 36px;
    height: 36px;
    border: none;
    background: transparent;
    border-radius: 8px;
    color: #4a4a68;
    font-size: 13px;
    cursor: pointer;
    transition: all 0.2s;

    &:hover { background: rgba(124, 77, 255, 0.06); }
    &.active {
      background: linear-gradient(135deg, #00d4ff, #7c4dff);
      color: #fff;
      font-weight: 600;
    }
  }
}

// 响应式
@media (max-width: 1024px) {
  .layout {
    grid-template-columns: 1fr;
  }
  .sidebar {
    order: -1;
  }
}
</style>
