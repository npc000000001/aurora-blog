<template>
  <div class="tags-page">
    <div class="container">
      <div class="page-header">
        <h1 class="page-title"><span class="title-icon">⬚</span> 标签</h1>
        <p class="page-desc">共 {{ tags.length }} 个标签</p>
      </div>

      <div class="tag-cloud-card" v-loading="loading">
        <router-link
          v-for="tag in tags"
          :key="tag.id"
          :to="`/tag/${tag.name}`"
          class="tag-item"
          :style="tagStyle(tag.id)"
        >
          <span class="tag-hash">#</span>{{ tag.name }}
        </router-link>
      </div>

      <div v-if="!loading && tags.length === 0" class="empty">
        <div class="empty-icon">🏷</div>
        <p>暂无标签</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import request from '@/utils/request'

const loading = ref(false)
const tags = ref([])

const colors = [
  { bg: 'rgba(0,212,255,0.1)', color: '#00a7c7' },
  { bg: 'rgba(124,77,255,0.1)', color: '#7c4dff' },
  { bg: 'rgba(67,233,123,0.1)', color: '#2bab5e' },
  { bg: 'rgba(250,115,154,0.1)', color: '#d44370' },
  { bg: 'rgba(255,193,7,0.1)', color: '#c49a00' },
  { bg: 'rgba(102,126,234,0.1)', color: '#5a6fd6' }
]

const tagStyle = (id) => {
  const c = colors[id % colors.length]
  return { background: c.bg, color: c.color }
}

const fetchTags = async () => {
  loading.value = true
  try {
    const res = await request({ url: '/tag/all', method: 'get' })
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
.tags-page { padding: 40px 0; }

.page-header { text-align: center; margin-bottom: 40px; }

.page-title {
  font-size: 32px; font-weight: 700; color: #1a1a2e;
  display: flex; align-items: center; justify-content: center; gap: 8px;
  margin-bottom: 8px;
  .title-icon { font-size: 28px; }
}

.page-desc { color: #8c8ca1; font-size: 14px; }

.tag-cloud-card {
  max-width: 800px;
  margin: 0 auto;
  padding: 40px;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.04);
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  justify-content: center;
}

.tag-item {
  display: inline-flex;
  align-items: center;
  padding: 8px 20px;
  border-radius: 24px;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.25s;
  cursor: pointer;

  .tag-hash { opacity: 0.5; margin-right: 2px; }

  &:hover {
    transform: translateY(-3px) scale(1.05);
    box-shadow: 0 4px 16px rgba(0,0,0,0.1);
  }
}

.empty { text-align: center; padding: 80px 0; color: #9a9ab0;
  .empty-icon { font-size: 48px; margin-bottom: 12px; }
}
</style>
