<template>
  <div class="blog-detail" v-if="blog">
    <!-- 文章头部 -->
    <header class="article-header">
      <div class="container">
        <!-- 面包屑 -->
        <div class="breadcrumb">
          <router-link to="/" class="crumb">Index</router-link>
          <span class="crumb-sep">/</span>
          <span class="crumb crumb-current">{{ blog.categoryName || 'Article' }}</span>
        </div>

        <!-- 元信息条 -->
        <div class="meta-bar">
          <span class="meta-item">
            <span class="meta-dot"></span>
            <span class="meta-text">{{ formatDate(blog.createTime) }}</span>
          </span>
          <span class="meta-sep">·</span>
          <span class="meta-item">{{ blog.views || 0 }} Views</span>
          <span class="meta-sep" v-if="wordCount">·</span>
          <span class="meta-item" v-if="wordCount">{{ wordCount }} Words</span>
          <span class="meta-sep" v-if="readTime">·</span>
          <span class="meta-item" v-if="readTime">{{ readTime }} Min Read</span>
        </div>

        <!-- 标题 -->
        <h1 class="article-title">{{ blog.title }}</h1>

        <p class="article-summary" v-if="blog.summary">{{ blog.summary }}</p>

        <!-- 分隔线 -->
        <div class="header-divider">
          <span class="divider-mark">§</span>
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
            <div class="copyright-header">
              <span class="copyright-mark">©</span>
              <span class="copyright-title">Copyright</span>
            </div>
            <div class="copyright-content">
              <div class="copy-row">
                <span class="copy-label">Author</span>
                <span class="copy-value">{{ blog.author || 'Aurora' }}</span>
              </div>
              <div class="copy-row">
                <span class="copy-label">Posted</span>
                <span class="copy-value">{{ formatDate(blog.createTime) }}</span>
              </div>
              <div class="copy-row" v-if="blog.updateTime !== blog.createTime">
                <span class="copy-label">Updated</span>
                <span class="copy-value">{{ formatDate(blog.updateTime) }}</span>
              </div>
              <p class="license">本博客所有文章除特别声明外，均采用 CC BY 4.0 许可协议。转载请注明来自 Aurora Blog。</p>
            </div>
          </div>

          <!-- 返回首页 -->
          <div class="back-link">
            <router-link to="/">
              <span class="back-arrow">←</span>
              <span>返回首页</span>
            </router-link>
          </div>
        </article>

        <!-- 目录侧边栏 -->
        <aside class="toc-sidebar" v-if="headings.length">
          <div class="toc-card">
            <div class="toc-title">
              <span class="title-text">Contents</span>
              <span class="title-line"></span>
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
    <p class="loading-text">Loading…</p>
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

const scrollTo = (id) => {
  const el = document.getElementById(id)
  if (el) {
    window.scrollTo({ top: el.offsetTop - 80, behavior: 'smooth' })
  }
}

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
// ─── 文章头部 ─────────────────────────────────
.article-header {
  padding: 80px 0 40px;
  position: relative;
}

.breadcrumb {
  display: flex;
  align-items: center;
  gap: 8px;
  font-family: var(--font-mono);
  font-size: 11px;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--text-muted);
  margin-bottom: 28px;

  .crumb {
    transition: color var(--transition-fast);
    &.crumb-current { color: var(--aurora-cyan); }
    &:hover { color: var(--aurora-green); }
  }

  .crumb-sep { opacity: 0.4; }
}

.meta-bar {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 32px;
  font-family: var(--font-mono);
  font-size: 11px;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--text-muted);

  .meta-item {
    display: inline-flex;
    align-items: center;
    gap: 6px;
  }

  .meta-dot {
    width: 5px;
    height: 5px;
    background: var(--aurora-green);
    border-radius: 50%;
  }

  .meta-sep {
    opacity: 0.4;
  }
}

.article-title {
  font-family: var(--font-display);
  font-size: clamp(32px, 5vw, 56px);
  font-weight: 600;
  line-height: 1.15;
  letter-spacing: -0.025em;
  color: var(--text-primary);
  margin-bottom: 20px;
  font-feature-settings: 'ss01', 'ss02';
  max-width: 880px;
}

.article-summary {
  font-size: 17px;
  line-height: 1.7;
  color: var(--text-secondary);
  max-width: 720px;
  font-style: italic;
  font-family: var(--font-display);
  font-weight: 300;
}

.header-divider {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-top: 40px;

  &::before, &::after {
    content: '';
    flex: 1;
    height: 1px;
    background: var(--border-subtle);
  }

  .divider-mark {
    font-family: var(--font-display);
    font-size: 20px;
    color: var(--aurora-green);
    font-style: italic;
  }
}

// ─── 主体布局 ─────────────────────────────────
.detail-layout {
  display: grid;
  grid-template-columns: 1fr 240px;
  gap: 56px;
  align-items: start;
  padding-bottom: 80px;
}

.article-body {
  min-width: 0;
}

// 版权卡
.copyright-card {
  margin-top: 56px;
  padding: 24px 28px;
  background: var(--bg-elev-1);
  border: 1px solid var(--border-subtle);
  border-left: 2px solid var(--aurora-green);
  border-radius: 0 var(--radius-sm) var(--radius-sm) 0;
}

.copyright-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 16px;

  .copyright-mark {
    font-family: var(--font-display);
    font-size: 18px;
    color: var(--aurora-green);
  }

  .copyright-title {
    font-family: var(--font-mono);
    font-size: 11px;
    text-transform: uppercase;
    letter-spacing: 0.18em;
    color: var(--aurora-green);
  }
}

.copyright-content {
  .copy-row {
    display: flex;
    align-items: center;
    padding: 5px 0;
    font-size: 13px;

    .copy-label {
      width: 70px;
      font-family: var(--font-mono);
      font-size: 10px;
      text-transform: uppercase;
      letter-spacing: 0.1em;
      color: var(--text-muted);
    }

    .copy-value {
      color: var(--text-regular);
    }
  }

  .license {
    margin-top: 14px;
    padding-top: 14px;
    border-top: 1px dashed var(--border-base);
    font-size: 12px;
    line-height: 1.7;
    color: var(--text-muted);
  }
}

.back-link {
  margin-top: 40px;
  text-align: center;

  a {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 10px 22px;
    border: 1px solid var(--border-base);
    border-radius: var(--radius-xs);
    font-family: var(--font-mono);
    font-size: 12px;
    letter-spacing: 0.08em;
    color: var(--text-secondary);
    transition: all var(--transition-fast);

    .back-arrow { color: var(--aurora-green); }

    &:hover {
      color: var(--aurora-green);
      border-color: var(--border-aurora);
      background: rgba(77, 255, 175, 0.04);

      .back-arrow { transform: translateX(-4px); }
    }
  }
}

// ─── 目录 ─────────────────────────────────────
.toc-sidebar {
  position: sticky;
  top: 88px;
}

.toc-card {
  padding: 4px 0;
}

.toc-title {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 16px;

  .title-text {
    font-family: var(--font-mono);
    font-size: 11px;
    font-weight: 500;
    text-transform: uppercase;
    letter-spacing: 0.18em;
    color: var(--aurora-green);
  }

  .title-line {
    flex: 1;
    height: 1px;
    background: var(--border-subtle);
  }
}

.toc-list {
  display: flex;
  flex-direction: column;
  gap: 2px;
  max-height: 70vh;
  overflow-y: auto;
  padding-right: 4px;
}

.toc-link {
  display: block;
  font-size: 13px;
  line-height: 1.5;
  color: var(--text-secondary);
  padding: 6px 10px;
  border-left: 1px solid transparent;
  transition: all var(--transition-fast);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;

  &.level-1 {
    font-weight: 600;
    color: var(--text-regular);
  }
  &.level-2 { padding-left: 22px; }
  &.level-3 { padding-left: 34px; font-size: 12px; }
  &.level-4 { padding-left: 46px; font-size: 12px; }

  &:hover {
    color: var(--aurora-green);
    border-left-color: var(--border-aurora);
    background: rgba(77, 255, 175, 0.04);
  }

  &.active {
    color: var(--aurora-green);
    border-left-color: var(--aurora-green);
    background: rgba(77, 255, 175, 0.06);
  }
}

// ─── 加载状态 ─────────────────────────────────
.loading-state {
  text-align: center;
  padding: 160px 20px;
  color: var(--text-muted);
}

.loader {
  width: 32px;
  height: 32px;
  margin: 0 auto 16px;
  border: 1.5px solid var(--border-base);
  border-top-color: var(--aurora-green);
  border-radius: 50%;
  animation: spin 0.9s linear infinite;
}

.loading-text {
  font-family: var(--font-mono);
  font-size: 12px;
  letter-spacing: 0.15em;
  text-transform: uppercase;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

// ─── 响应式 ───────────────────────────────────
@media (max-width: 1024px) {
  .detail-layout {
    grid-template-columns: 1fr;
    gap: 32px;
  }
  .toc-sidebar {
    order: -1;
    position: relative;
    top: 0;
  }
  .toc-list {
    max-height: 200px;
    flex-direction: row;
    flex-wrap: wrap;
    gap: 4px;
  }
  .toc-link {
    border-left: none;
    border-bottom: 1px solid transparent;
    &.active {
      border-left: none;
      border-bottom-color: var(--aurora-green);
    }
  }
}

@media (max-width: 600px) {
  .article-header { padding: 60px 0 32px; }
  .meta-bar { font-size: 10px; }
}
</style>
