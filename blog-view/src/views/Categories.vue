<template>
  <div class="categories-page">
    <div class="container">
      <div class="page-header">
        <h1 class="page-title"><span class="title-icon">▤</span> 分类</h1>
        <p class="page-desc">共 {{ categories.length }} 个分类</p>
      </div>

      <div class="category-grid" v-loading="loading">
        <div
          v-for="cat in categories"
          :key="cat.id"
          class="category-card"
          @click="goCategory(cat.name)"
        >
          <div class="card-icon" :style="{ background: getGradient(cat.id) }">
            <span>{{ cat.name.charAt(0) }}</span>
          </div>
          <div class="card-info">
            <h3>{{ cat.name }}</h3>
            <p>{{ cat.description || '暂无描述' }}</p>
          </div>
          <div class="card-arrow">→</div>
        </div>
      </div>

      <div v-if="!loading && categories.length === 0" class="empty">
        <div class="empty-icon">📂</div>
        <p>暂无分类</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import request from '@/utils/request'

const router = useRouter()
const loading = ref(false)
const categories = ref([])

const gradients = [
  'linear-gradient(135deg, #00d4ff, #4facfe)',
  'linear-gradient(135deg, #7c4dff, #5b6eff)',
  'linear-gradient(135deg, #43e97b, #38f9d7)',
  'linear-gradient(135deg, #fa709a, #fee140)',
  'linear-gradient(135deg, #667eea, #764ba2)',
  'linear-gradient(135deg, #f093fb, #f5576c)'
]

const getGradient = (id) => gradients[id % gradients.length]

const goCategory = (name) => router.push(`/category/${name}`)

const fetchCategories = async () => {
  loading.value = true
  try {
    const res = await request({ url: '/category/all', method: 'get' })
    categories.value = res.data || []
  } catch (e) {
    // 接口未实现，使用静态分类
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
.categories-page { padding: 40px 0; }

.page-header {
  text-align: center;
  margin-bottom: 40px;
}

.page-title {
  font-size: 32px; font-weight: 700; color: #1a1a2e;
  display: flex; align-items: center; justify-content: center; gap: 8px;
  margin-bottom: 8px;
  .title-icon { font-size: 28px; }
}

.page-desc { color: #8c8ca1; font-size: 14px; }

.category-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 20px;
}

.category-card {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 20px;
  background: #fff;
  border-radius: 14px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.04);
  cursor: pointer;
  transition: all 0.25s;

  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 28px rgba(124, 77, 255, 0.12);
    .card-arrow { transform: translateX(4px); color: #7c4dff; }
  }
}

.card-icon {
  flex-shrink: 0;
  width: 56px; height: 56px;
  border-radius: 14px;
  display: flex; align-items: center; justify-content: center;
  color: #fff; font-size: 24px; font-weight: 700;
}

.card-info {
  flex: 1;
  min-width: 0;
  h3 { font-size: 16px; color: #1a1a2e; margin-bottom: 4px; }
  p { font-size: 13px; color: #9a9ab0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
}

.card-arrow { color: #c8c8d8; font-size: 18px; transition: all 0.2s; }

.empty { text-align: center; padding: 80px 0; color: #9a9ab0;
  .empty-icon { font-size: 48px; margin-bottom: 12px; }
}
</style>
