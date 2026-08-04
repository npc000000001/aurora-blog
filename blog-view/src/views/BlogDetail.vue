<template>
  <div class="blog-detail" v-if="blog">
    <!-- 文章头部 -->
    <header class="article-header">
      <div class="container">
        <div class="header-content">
          <span class="category-badge" v-if="blog.categoryName">{{ blog.categoryName }}</span>
          <h1 class="article-title">{{ blog.title }}</h1>
          <div class="article-meta">
            <span><span class="icon">📅</span>{{ formatDate(blog.createTime) }}</span>
            <span><span class="icon">👁</span>{{ blog.views || 0 }} 阅读</span>
            <span v-if="wordCount"><span class="icon">✎</span>{{ wordCount }} 字</span>
            <span v-if="readTime"><span class="icon">⏱</span>约 {{ readTime }} 分钟</span>
          </div>
        </div>
      </div>
    </header>

    <!-- 主体双栏 -->
    <div class="container">
      <div class="detail-layout">
        <!-- 正文 -->
        <article class="article-body">
          <div class="markdown-body" v-html="renderedContent" ref="contentRef"></div>

          <!-- 版权信息 -->
          <div class="copyright-card">
            <div class="copyright-title">
              <span class="icon">📜</span> 版权声明
            </div>
            <div class="copyright-content">
              <p>本文作者：<strong>{{ blog.author || 'Aurora' }}</strong></p>
              <p>发表时间：{{ formatDate(blog.createTime) }}</p>
              <p v-if="blog.updateTime !== blog.createTime">最后修改：{{ formatDate(blog.updateTime) }}</p>
              <p>本文链接：<a href="#">Aurora Blog · {{ blog.title }}</a></p>
              <p class="license">本博客所有文章除特别声明外，均采用 CC BY 4.0 许可协议。转载请注明来自 Aurora Blog！</p>
            </div>
          </div>

          <!-- 返回首页 -->
          <div class="back-link">
            <router-link to="/">← 返回首页</router-link>
          </div>
        </article>

        <!-- 目录侧边栏 -->
        <aside class="toc-sidebar" v-if="headings.length">
          <div class="toc-card">
            <div class="toc-title">
              <span class="icon">📑</span> 目录
            </div>
            <nav class="toc-list">
              <a
                v-for="h in headings"
                :key="h.id"
                :href="`#${h.id}`"
                :class="['toc-link', `level-${h.level}`, { active: activeId === h.id }]"
                @click.prevent="scrollTo(h.id)"
              >{{ h.text }}</a>
            </nav>
          </div>
        </aside>
      </div>
    </div>
  </div>
  <div v-else class="loading-state">
    <div class="loader"></div>
    <p>加载中...</p>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick } from 'vue'
import { useRoute } from 'vue-router'
import { marked } from 'marked'
import { getBlogDetail } from '@/api/blog'

const route = useRoute()
const blog = ref(null)
const contentRef = ref(null)
const headings = ref([])
const activeId = ref('')

// Markdown 渲染配置
marked.setOptions({ breaks: true, gfm: true })

const renderedContent = computed(() => {
  if (!blog.value?.content) return ''
  return marked.parse(blog.value.content)
})

const wordCount = computed(() => {
  const content = blog.value?.content || ''
  return content.replace(/[#*`>\-\[\]()!\s]/g, '').length
})

const readTime = computed(() => {
  if (!wordCount.value) return 0
  return Math.max(1, Math.round(wordCount.value / 300))
})

const formatDate = (str) => str ? str.substring(0, 10) : ''

// 从渲染后的 DOM 提取标题
const extractHeadings = () => {
  const els = contentRef.value?.querySelectorAll('h1, h2, h3, h4')
  if (!els) return
  headings.value = Array.from(els).map((el, i) => {
    const id = `heading-${i}`
    el.id = id
    return {
      id,
      text: el.textContent,
      level: parseInt(el.tagName[1])
    }
  })
}

// 滚动到指定标题
const scrollTo = (id) => {
  const el = document.getElementById(id)
  if (el) {
    window.scrollTo({ top: el.offsetTop - 80, behavior: 'smooth' })
  }
}

// 滚动联动高亮目录
const handleScroll = () => {
  const els = contentRef.value?.querySelectorAll('h1, h2, h3, h4')
  if (!els) return
  for (const el of els) {
    if (el.getBoundingClientRect().top > 100) return
    activeId.value = el.id
  }
}

onMounted(async () => {
  const res = await getBlogDetail(route.params.id)
  blog.value = res.data
  await nextTick()
  extractHeadings()
  window.addEventListener('scroll', handleScroll)
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped lang="scss">
// 文章头部
.article-header {
  background: linear-gradient(135deg, rgba(0,212,255,0.04) 0%, rgba(124,77,255,0.04) 100%);
  padding: 56px 0 40px;
  margin-bottom: 32px;
}

.header-content {
  text-align: center;
}

.category-badge {
  display: inline-block;
  padding: 4px 16px;
  background: linear-gradient(135deg, #00d4ff, #7c4dff);
  color: #fff;
  font-size: 12px;
  font-weight: 500;
  border-radius: 20px;
  margin-bottom: 16px;
}

.article-title {
  font-size: clamp(24px, 4vw, 36px);
  font-weight: 700;
  color: #1a1a2e;
  line-height: 1.4;
  margin-bottom: 16px;
}

.article-meta {
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  gap: 20px;
  font-size: 13px;
  color: #8c8ca1;

  .icon { margin-right: 4px; }
}

// 主体布局
.detail-layout {
  display: grid;
  grid-template-columns: 1fr 240px;
  gap: 40px;
  align-items: start;
}

.article-body {
  background: #fff;
  border-radius: 16px;
  padding: 40px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.04);
}

// 版权信息
.copyright-card {
  margin-top: 40px;
  padding: 24px;
  background: linear-gradient(135deg, rgba(0,212,255,0.05), rgba(124,77,255,0.05));
  border-left: 4px solid;
  border-image: linear-gradient(180deg, #00d4ff, #7c4dff) 1;
  border-radius: 0 12px 12px 0;
}

.copyright-title {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 15px;
  font-weight: 600;
  color: #1a1a2e;
  margin-bottom: 12px;
}

.copyright-content {
  p {
    font-size: 13px;
    color: #4a4a68;
    margin-bottom: 6px;
    line-height: 1.7;
  }
  a { color: #7c4dff; }
  .license {
    margin-top: 12px;
    padding-top: 12px;
    border-top: 1px dashed rgba(124, 77, 255, 0.2);
    color: #8c8ca1;
  }
}

.back-link {
  margin-top: 32px;
  text-align: center;
  a {
    color: #7c4dff;
    font-size: 14px;
    &:hover { opacity: 0.8; }
  }
}

// 目录
.toc-sidebar {
  position: sticky;
  top: 80px;
}

.toc-card {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.04);
}

.toc-title {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  font-weight: 600;
  color: #1a1a2e;
  margin-bottom: 16px;
  padding-bottom: 12px;
  border-bottom: 1px solid #f0f2f8;
}

.toc-list {
  display: flex;
  flex-direction: column;
  gap: 6px;
  max-height: 60vh;
  overflow-y: auto;
}

.toc-link {
  font-size: 13px;
  color: #6a6a85;
  padding: 4px 8px;
  border-radius: 6px;
  border-left: 2px solid transparent;
  transition: all 0.2s;
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;

  &.level-1 { font-weight: 600; color: #1a1a2e; }
  &.level-2 { padding-left: 16px; }
  &.level-3 { padding-left: 28px; font-size: 12px; }
  &.level-4 { padding-left: 40px; font-size: 12px; }

  &:hover {
    color: #7c4dff;
    background: rgba(124, 77, 255, 0.05);
  }

  &.active {
    color: #7c4dff;
    border-left-color: #7c4dff;
    background: rgba(124, 77, 255, 0.08);
    font-weight: 500;
  }
}

// 加载状态
.loading-state {
  text-align: center;
  padding: 120px 0;
  color: #9a9ab0;
}

.loader {
  width: 40px;
  height: 40px;
  margin: 0 auto 16px;
  border: 3px solid rgba(124, 77, 255, 0.1);
  border-top-color: #7c4dff;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

// 响应式
@media (max-width: 1024px) {
  .detail-layout {
    grid-template-columns: 1fr;
  }
  .toc-sidebar {
    order: -1;
    position: relative;
    top: 0;
  }
  .article-body {
    padding: 24px;
  }
}
</style>
