<template>
  <div class="list-page">
    <div class="container">
      <div class="page-header">
        <div class="header-left">
          <span class="header-icon">⬚</span>
          <h1 class="page-title">标签：{{ tagName }}</h1>
        </div>
        <router-link to="/tags" class="back-btn">← 全部标签</router-link>
      </div>

      <div class="blog-list" v-loading="loading">
        <BlogCard v-for="blog in list" :key="blog.id" :blog="blog" />
      </div>

      <div v-if="!loading && list.length === 0" class="empty">
        <div class="empty-icon">🏷</div>
        <p>该标签下暂无文章</p>
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

const tagName = ref(route.params.name)

const fetchList = async () => {
  loading.value = true
  try {
    const res = await pageBlog({ pageNum: 1, pageSize: 20, tagName: tagName.value })
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
  tagName.value = val
  fetchList()
}, { immediate: true })
</script>

<style scoped lang="scss">
.list-page { padding: 40px 0; }

.page-header {
  display: flex; align-items: center; justify-content: space-between;
  margin-bottom: 32px; flex-wrap: wrap; gap: 12px;
}

.header-left { display: flex; align-items: center; gap: 8px; }

.header-icon {
  font-size: 24px;
  background: linear-gradient(135deg, #00d4ff, #7c4dff);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.page-title { font-size: 24px; font-weight: 700; color: #1a1a2e; }

.back-btn {
  font-size: 13px; color: #7c4dff;
  padding: 6px 16px; border-radius: 20px;
  background: rgba(124, 77, 255, 0.06);
  transition: all 0.2s;
  &:hover { background: rgba(124, 77, 255, 0.12); }
}

.blog-list { display: flex; flex-direction: column; gap: 20px; }

.empty { text-align: center; padding: 80px 0; color: #9a9ab0;
  .empty-icon { font-size: 48px; margin-bottom: 12px; }
}
</style>
