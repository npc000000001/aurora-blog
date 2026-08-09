<template>
  <div class="categories-page">
    <div class="container">
      <!-- 页面标题 -->
      <div class="page-head">
        <div class="head-meta">
          <span class="meta-num">03</span>
          <span class="meta-line"></span>
        </div>
        <h1 class="head-title">
          <span>Categories</span>
          <span class="title-it">分类<span class="dot">.</span></span>
        </h1>
        <p class="head-sub">共 {{ categories.length }} 个分类 · 按主题归集</p>
      </div>

      <!-- 分类列表 -->
      <div class="category-list" v-loading="loading">
        <div
          v-for="(cat, i) in categories"
          :key="cat.id"
          class="category-row"
          @click="goCategory(cat.name)"
        >
          <span class="row-index">{{ String(i + 1).padStart(2, '0') }}</span>
          <div class="row-info">
            <h3 class="row-name">{{ cat.name }}</h3>
            <p class="row-desc">{{ cat.description || '暂无描述' }}</p>
          </div>
          <span class="row-arrow">→</span>
        </div>
      </div>

      <div v-if="!loading && categories.length === 0" class="empty-state">
        <div class="empty-mark">∅</div>
        <p class="empty-text">暂无分类</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getAllCategories } from '@/api/category'

const router = useRouter()
const loading = ref(false)
const categories = ref([])

const goCategory = (name) => router.push(`/category/${name}`)

const fetchCategories = async () => {
  loading.value = true
  try {
    const res = await getAllCategories()
    categories.value = res.data || []
  } catch (e) {
    categories.value = [
      { id: 1, name: '后端开发', description: 'Java、Spring、数据库相关' },
      { id: 2, name: '前端开发', description: 'Vue、React、CSS相关' },
      { id: 3, name: '技术随笔', description: '技术思考与总结' }
    ]
  } finally {
    loading.value = false
  }
}

onMounted(fetchCategories)
</script>

<style scoped lang="scss">
.categories-page {
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

// 分类列表
.category-list {
  display: flex;
  flex-direction: column;
}

.category-row {
  display: grid;
  grid-template-columns: 60px 1fr 24px;
  gap: 24px;
  align-items: center;
  padding: 28px 16px;
  margin: 0 -16px;
  border-bottom: 1px solid var(--border-subtle);
  cursor: pointer;
  transition: all var(--transition-base);

  &:first-child { border-top: 1px solid var(--border-subtle); }

  .row-index {
    font-family: var(--font-display);
    font-size: 28px;
    font-weight: 300;
    color: var(--text-muted);
    line-height: 1;
    font-feature-settings: 'lnum', 'tnum';
    transition: color var(--transition-base);
  }

  .row-info {
    min-width: 0;

    .row-name {
      font-family: var(--font-display);
      font-size: 24px;
      font-weight: 600;
      color: var(--text-primary);
      margin-bottom: 6px;
      letter-spacing: -0.01em;
      transition: color var(--transition-base);
    }

    .row-desc {
      font-size: 13px;
      color: var(--text-secondary);
      line-height: 1.6;
    }
  }

  .row-arrow {
    color: var(--text-muted);
    opacity: 0;
    transform: translateX(-8px);
    transition: all var(--transition-base);
    font-size: 18px;
  }

  &:hover {
    background: rgba(77, 255, 175, 0.04);

    .row-index {
      color: var(--aurora-green);
      text-shadow: 0 0 24px rgba(77, 255, 175, 0.4);
    }
    .row-name { color: var(--aurora-green); }
    .row-arrow {
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
  .categories-page { padding: 60px 0; }
  .category-row {
    grid-template-columns: 40px 1fr;
    gap: 14px;
    padding: 20px 12px;
    margin: 0 -12px;

    .row-index { font-size: 20px; }
    .row-info .row-name { font-size: 18px; }
    .row-arrow { display: none; }
  }
}
</style>
