<template>
  <div class="archives-page">
    <div class="container">
      <!-- 页面标题 -->
      <div class="page-head">
        <div class="head-meta">
          <span class="meta-num">02</span>
          <span class="meta-line"></span>
        </div>
        <h1 class="head-title">
          <span>Archives</span>
          <span class="title-it">归档<span class="dot">.</span></span>
        </h1>
        <p class="head-sub">共 {{ total }} 篇文章 · 按年份分组</p>
      </div>

      <!-- 时间轴 -->
      <div class="timeline" v-loading="loading">
        <div v-for="(group, year) in groupedBlogs" :key="year" class="year-block">
          <div class="year-head">
            <h2 class="year-text">{{ year }}</h2>
            <span class="year-count">{{ group.length }} Posts</span>
            <span class="year-line"></span>
          </div>

          <div class="year-items">
            <div
              v-for="blog in group"
              :key="blog.id"
              class="archive-item"
              @click="goDetail(blog.id)"
            >
              <span class="item-date">{{ formatDate(blog.createTime) }}</span>
              <span class="item-sep">—</span>
              <span class="item-title">{{ blog.title }}</span>
              <span class="item-arrow">→</span>
            </div>
          </div>
        </div>

        <div v-if="!loading && list.length === 0" class="empty-state">
          <div class="empty-mark">∅</div>
          <p class="empty-text">暂无文章归档</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { pageBlog } from '@/api/blog'

const router = useRouter()
const loading = ref(false)
const list = ref([])
const total = ref(0)

const groupedBlogs = computed(() => {
  const groups = {}
  list.value.forEach((blog) => {
    const year = blog.createTime?.substring(0, 4) || '未知'
    if (!groups[year]) groups[year] = []
    groups[year].push(blog)
  })
  return groups
})

const formatDate = (str) => str ? str.substring(5, 10) : ''
const goDetail = (id) => router.push(`/blog/${id}`)

const fetchList = async () => {
  loading.value = true
  try {
    const res = await pageBlog({ pageNum: 1, pageSize: 100 })
    list.value = res.data.records
    total.value = res.data.total
  } finally {
    loading.value = false
  }
}

onMounted(fetchList)
</script>

<style scoped lang="scss">
.archives-page {
  padding: 80px 0;
}

// 页面标题
.page-head {
  margin-bottom: 64px;
  padding-bottom: 24px;
  border-bottom: 1px solid var(--border-subtle);

  .head-meta {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 20px;

    .meta-num {
      font-family: var(--font-mono);
      font-size: 11px;
      color: var(--aurora-green);
      letter-spacing: 0.1em;
    }

    .meta-line {
      width: 24px;
      height: 1px;
      background: var(--aurora-green);
    }
  }

  .head-title {
    font-family: var(--font-display);
    font-size: clamp(40px, 7vw, 80px);
    font-weight: 600;
    line-height: 1;
    letter-spacing: -0.03em;
    color: var(--text-primary);
    margin-bottom: 16px;

    .title-it {
      font-style: italic;
      font-weight: 300;
      color: var(--text-regular);

      .dot { color: var(--aurora-green); }
    }
  }

  .head-sub {
    font-family: var(--font-mono);
    font-size: 12px;
    text-transform: uppercase;
    letter-spacing: 0.12em;
    color: var(--text-muted);
  }
}

// 年份块
.year-block {
  margin-bottom: 56px;
}

.year-head {
  display: flex;
  align-items: baseline;
  gap: 16px;
  margin-bottom: 20px;

  .year-text {
    font-family: var(--font-display);
    font-size: 48px;
    font-weight: 700;
    color: var(--text-primary);
    line-height: 1;
    letter-spacing: -0.02em;
    font-feature-settings: 'lnum', 'tnum';
  }

  .year-count {
    font-family: var(--font-mono);
    font-size: 11px;
    text-transform: uppercase;
    letter-spacing: 0.15em;
    color: var(--aurora-green);
  }

  .year-line {
    flex: 1;
    height: 1px;
    background: var(--border-subtle);
  }
}

.year-items {
  display: flex;
  flex-direction: column;
}

.archive-item {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 14px 16px;
  margin: 0 -16px;
  border-bottom: 1px solid var(--border-subtle);
  cursor: pointer;
  transition: all var(--transition-fast);

  .item-date {
    font-family: var(--font-mono);
    font-size: 12px;
    color: var(--text-muted);
    letter-spacing: 0.05em;
    flex-shrink: 0;
    transition: color var(--transition-fast);
  }

  .item-sep {
    color: var(--text-muted);
    opacity: 0.5;
  }

  .item-title {
    flex: 1;
    font-size: 15px;
    color: var(--text-regular);
    line-height: 1.5;
    transition: color var(--transition-fast);
  }

  .item-arrow {
    color: var(--text-muted);
    opacity: 0;
    transform: translateX(-8px);
    transition: all var(--transition-fast);
  }

  &:hover {
    background: rgba(77, 255, 175, 0.04);

    .item-date { color: var(--aurora-green); }
    .item-title { color: var(--text-primary); }
    .item-arrow {
      color: var(--aurora-green);
      opacity: 1;
      transform: translateX(0);
    }
  }
}

// 空状态
.empty-state {
  text-align: center;
  padding: 80px 20px;

  .empty-mark {
    font-family: var(--font-display);
    font-size: 64px;
    color: var(--text-muted);
    margin-bottom: 12px;
  }

  .empty-text {
    color: var(--text-secondary);
    font-size: 14px;
  }
}

@media (max-width: 720px) {
  .archives-page { padding: 60px 0; }
  .year-head .year-text { font-size: 36px; }
  .archive-item {
    flex-wrap: wrap;
    gap: 8px;
    .item-sep { display: none; }
  }
}
</style>
