<template>
  <div class="list-page">
    <div class="container">
      <!-- 面包屑 -->
      <div class="breadcrumb">
        <router-link to="/" class="crumb">Index</router-link>
        <span class="crumb-sep">/</span>
        <router-link to="/categories" class="crumb">Categories</router-link>
        <span class="crumb-sep">/</span>
        <span class="crumb crumb-current">{{ categoryName }}</span>
      </div>

      <!-- 页面标题 -->
      <div class="page-head">
        <div class="head-meta">
          <span class="meta-num">03</span>
          <span class="meta-line"></span>
        </div>
        <h1 class="head-title">
          <span class="title-it">{{ categoryName }}<span class="dot">.</span></span>
        </h1>
        <p class="head-sub">共 {{ list.length }} 篇文章</p>
      </div>

      <!-- 文章列表 -->
      <div class="blog-list" v-loading="loading">
        <BlogCard
          v-for="(blog, i) in list"
          :key="blog.id"
          :blog="blog"
          :index="i + 1"
        />
      </div>

      <div v-if="!loading && list.length === 0" class="empty-state">
        <div class="empty-mark">∅</div>
        <p class="empty-text">该分类下暂无文章</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { pageBlog } from '@/api/blog'
import BlogCard from '@/components/BlogCard.vue'

const route = useRoute()
const loading = ref(false)
const list = ref([])

const categoryName = ref(route.params.name)

const fetchList = async () => {
  loading.value = true
  try {
    const res = await pageBlog({ pageNum: 1, pageSize: 20, categoryName: categoryName.value })
    list.value = res.data.records
  } catch (e) {
    try {
      const res = await pageBlog({ pageNum: 1, pageSize: 20 })
      list.value = res.data.records
    } catch (e2) {
      list.value = []
    }
  } finally {
    loading.value = false
  }
}

watch(() => route.params.name, (val) => {
  categoryName.value = val
  fetchList()
}, { immediate: true })
</script>

<style scoped lang="scss">
.list-page {
  padding: 60px 0 80px;
}

// 面包屑
.breadcrumb {
  display: flex;
  align-items: center;
  gap: 8px;
  font-family: var(--font-mono);
  font-size: 11px;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--text-muted);
  margin-bottom: 32px;

  .crumb {
    transition: color var(--transition-fast);
    &.crumb-current { color: var(--aurora-cyan); }
    &:hover { color: var(--aurora-green); }
  }

  .crumb-sep { opacity: 0.4; }
}

// 页面标题
.page-head {
  margin-bottom: 40px;
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
    font-size: clamp(40px, 6vw, 64px);
    font-weight: 600;
    line-height: 1;
    letter-spacing: -0.025em;
    color: var(--text-primary);
    margin-bottom: 14px;

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
</style>
