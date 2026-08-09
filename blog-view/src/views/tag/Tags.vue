<template>
  <div class="tags-page">
    <div class="container">
      <!-- 页面标题 -->
      <div class="page-head">
        <div class="head-meta">
          <span class="meta-num">04</span>
          <span class="meta-line"></span>
        </div>
        <h1 class="head-title">
          <span>Tags</span>
          <span class="title-it">标签<span class="dot">.</span></span>
        </h1>
        <p class="head-sub">共 {{ tags.length }} 个标签 · 主题关键词</p>
      </div>

      <!-- 标签云 -->
      <div class="tag-cloud" v-loading="loading">
        <router-link
          v-for="(tag, i) in tags"
          :key="tag.id"
          :to="`/tag/${tag.name}`"
          class="tag-item"
          :style="{ fontSize: getTagSize(i), animationDelay: `${i * 0.03}s` }"
        >
          <span class="tag-hash">#</span>
          <span class="tag-name">{{ tag.name }}</span>
        </router-link>
      </div>

      <div v-if="!loading && tags.length === 0" class="empty-state">
        <div class="empty-mark">∅</div>
        <p class="empty-text">暂无标签</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getAllTags } from '@/api/tag'

const loading = ref(false)
const tags = ref([])

// 标签尺寸：每隔几个变大
const sizes = ['14px', '16px', '18px', '20px', '16px', '14px']
const getTagSize = (i) => sizes[i % sizes.length]

const fetchTags = async () => {
  loading.value = true
  try {
    const res = await getAllTags()
    tags.value = res.data || []
  } catch (e) {
    tags.value = []
  } finally {
    loading.value = false
  }
}

onMounted(fetchTags)
</script>

<style scoped lang="scss">
.tags-page {
  padding: 80px 0;
}

// 页面标题
.page-head {
  margin-bottom: 56px;
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

// 标签云
.tag-cloud {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  align-items: baseline;
  max-width: 920px;
}

.tag-item {
  display: inline-flex;
  align-items: baseline;
  gap: 2px;
  padding: 6px 14px;
  color: var(--text-secondary);
  background: rgba(255, 255, 255, 0.02);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius-pill);
  font-family: var(--font-body);
  font-weight: 400;
  line-height: 1.5;
  transition: all var(--transition-fast);
  animation: fadeInUp 0.5s both;

  .tag-hash {
    color: var(--text-muted);
    font-family: var(--font-mono);
    margin-right: 2px;
    transition: color var(--transition-fast);
  }

  .tag-name {
    letter-spacing: -0.005em;
  }

  &:hover {
    color: var(--aurora-green);
    border-color: var(--border-aurora);
    background: rgba(77, 255, 175, 0.06);
    transform: translateY(-2px);

    .tag-hash { color: var(--aurora-green); }
  }
}

@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(8px); }
  to { opacity: 1; transform: translateY(0); }
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
  .tags-page { padding: 60px 0; }
}
</style>
