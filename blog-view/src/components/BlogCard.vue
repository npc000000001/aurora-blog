<template>
  <article class="blog-card" :class="{ 'is-top': blog.isTop }" @click="goDetail">
    <!-- 左侧大编号 -->
    <div class="card-index">
      <span class="index-num">{{ paddedIndex }}</span>
      <span class="index-line"></span>
    </div>

    <!-- 中间内容 -->
    <div class="card-body">
      <!-- 元信息行 -->
      <div class="meta-row">
        <span class="meta-category" v-if="blog.categoryName">{{ blog.categoryName }}</span>
        <span class="meta-dot" v-if="blog.categoryName">·</span>
        <span class="meta-date">{{ formatDate(blog.createTime) }}</span>
        <span class="meta-top" v-if="blog.isTop">PINNED</span>
      </div>

      <!-- 标题 -->
      <h2 class="card-title">{{ blog.title }}</h2>

      <!-- 摘要 -->
      <p class="card-summary">{{ blog.summary || stripMarkdown(blog.content) }}</p>

      <!-- 底部 -->
      <div class="card-footer">
        <div class="footer-stats">
          <span class="stat">
            <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" /><circle cx="12" cy="12" r="3" />
            </svg>
            {{ blog.views || 0 }}
          </span>
          <span class="stat" v-if="wordCount">
            <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" /><path d="M14 2v6h6M16 13H8M16 17H8M10 9H8" />
            </svg>
            {{ wordCount }} 字
          </span>
        </div>
        <span class="read-more">
          阅读
          <span class="arrow">→</span>
        </span>
      </div>
    </div>
  </article>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'

const props = defineProps({
  blog: { type: Object, required: true },
  index: { type: Number, default: 0 }
})

const router = useRouter()

const paddedIndex = computed(() => String(props.index ?? (props.blog.id ?? 1)).padStart(2, '0'))

const wordCount = computed(() => {
  const content = props.blog.content || ''
  return props.blog.summary ? null : content.replace(/[#*`>\-\[\]()!\s]/g, '').length
})

const stripMarkdown = (content) => {
  if (!content) return ''
  const text = content.replace(/[#*`>\-\[\]()!]/g, '').replace(/\n+/g, ' ')
  return text.length > 140 ? text.substring(0, 140) + '…' : text
}

const formatDate = (str) => str ? str.substring(0, 10) : ''

const goDetail = () => router.push(`/blog/${props.blog.id}`)
</script>

<style scoped lang="scss">
.blog-card {
  display: grid;
  grid-template-columns: 90px 1fr;
  gap: 28px;
  padding: 32px 0;
  border-bottom: 1px solid var(--border-subtle);
  cursor: pointer;
  position: relative;
  transition: all var(--transition-base);

  &:first-child { padding-top: 8px; }

  &:hover {
    .card-index .index-num {
      color: var(--aurora-green);
      text-shadow: 0 0 24px rgba(77, 255, 175, 0.4);
    }
    .card-title {
      color: var(--aurora-green);
    }
    .read-more .arrow {
      transform: translateX(6px);
    }
    .card-body {
      transform: translateX(4px);
    }
  }

  &.is-top {
    .meta-top {
      display: inline-flex;
    }
  }
}

// 编号列
.card-index {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  padding-top: 4px;

  .index-num {
    font-family: var(--font-display);
    font-size: 44px;
    font-weight: 300;
    line-height: 1;
    color: var(--text-muted);
    transition: all var(--transition-base);
    font-feature-settings: 'lnum', 'tnum';
    letter-spacing: -0.02em;
  }

  .index-line {
    display: block;
    width: 24px;
    height: 1px;
    background: var(--border-base);
    margin-top: 12px;
    transition: background var(--transition-base);
  }
}

.blog-card:hover .card-index .index-line {
  background: var(--aurora-green);
}

// 内容区
.card-body {
  transition: transform var(--transition-base);
  min-width: 0;
}

.meta-row {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 12px;
  font-family: var(--font-mono);
  font-size: 11px;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--text-muted);

  .meta-category {
    color: var(--aurora-cyan);
    font-weight: 500;
  }

  .meta-dot {
    opacity: 0.5;
  }

  .meta-top {
    margin-left: auto;
    padding: 2px 8px;
    background: rgba(240, 171, 252, 0.1);
    color: var(--aurora-pink);
    border: 1px solid rgba(240, 171, 252, 0.25);
    border-radius: var(--radius-xs);
    font-size: 9px;
    font-weight: 600;
    display: none;
  }
}

.card-title {
  font-family: var(--font-display);
  font-size: 26px;
  font-weight: 600;
  line-height: 1.35;
  color: var(--text-primary);
  margin-bottom: 12px;
  letter-spacing: -0.015em;
  transition: color var(--transition-base);
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.card-summary {
  font-size: 14px;
  line-height: 1.75;
  color: var(--text-secondary);
  margin-bottom: 18px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.card-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;

  .footer-stats {
    display: flex;
    gap: 18px;
  }

  .stat {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    font-family: var(--font-mono);
    font-size: 11px;
    color: var(--text-muted);
    letter-spacing: 0.04em;

    svg { opacity: 0.7; }
  }

  .read-more {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-family: var(--font-mono);
    font-size: 11px;
    text-transform: uppercase;
    letter-spacing: 0.12em;
    color: var(--text-secondary);
    transition: color var(--transition-fast);

    .arrow {
      transition: transform var(--transition-base);
      color: var(--aurora-green);
    }
  }
}

.blog-card:hover .read-more {
  color: var(--aurora-green);
}

// 响应式
@media (max-width: 720px) {
  .blog-card {
    grid-template-columns: 60px 1fr;
    gap: 18px;
    padding: 24px 0;
  }
  .card-index .index-num { font-size: 32px; }
  .card-title { font-size: 20px; }
  .card-summary { font-size: 13px; -webkit-line-clamp: 3; }
}
</style>
