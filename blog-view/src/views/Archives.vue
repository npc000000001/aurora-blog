<template>
  <div class="archives-page">
    <div class="container">
      <div class="page-header">
        <h1 class="page-title">
          <span class="title-icon">📚</span> 归档
        </h1>
        <p class="page-desc">共记录 {{ total }} 篇文章</p>
      </div>

      <div class="timeline" v-loading="loading">
        <div v-for="(group, year) in groupedBlogs" :key="year" class="timeline-year">
          <div class="year-label">
            <span class="year-text">{{ year }}</span>
            <span class="year-count">{{ group.length }} 篇</span>
          </div>
          <div class="timeline-items">
            <div
              v-for="blog in group"
              :key="blog.id"
              class="timeline-item"
              @click="goDetail(blog.id)"
            >
              <div class="timeline-dot"></div>
              <div class="timeline-content">
                <span class="item-date">{{ formatDate(blog.createTime) }}</span>
                <span class="item-title">{{ blog.title }}</span>
              </div>
            </div>
          </div>
        </div>

        <div v-if="!loading && list.length === 0" class="empty">
          <div class="empty-icon">📂</div>
          <p>暂无文章归档</p>
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
  padding: 40px 0;
}

.page-header {
  text-align: center;
  margin-bottom: 48px;
}

.page-title {
  font-size: 32px;
  font-weight: 700;
  color: #1a1a2e;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  margin-bottom: 8px;

  .title-icon { font-size: 28px; }
}

.page-desc {
  color: #8c8ca1;
  font-size: 14px;
}

// 时间轴
.timeline-year {
  margin-bottom: 48px;
}

.year-label {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 20px;

  .year-text {
    font-size: 28px;
    font-weight: 800;
    background: linear-gradient(135deg, #00d4ff, #7c4dff);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
  }
  .year-count {
    font-size: 13px;
    color: #9a9ab0;
    padding: 2px 10px;
    background: rgba(124, 77, 255, 0.08);
    border-radius: 20px;
  }
}

.timeline-items {
  padding-left: 24px;
  border-left: 2px solid rgba(124, 77, 255, 0.15);
}

.timeline-item {
  position: relative;
  padding: 12px 20px;
  margin-bottom: 12px;
  background: #fff;
  border-radius: 10px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
  cursor: pointer;
  transition: all 0.25s;

  &:hover {
    transform: translateX(8px);
    box-shadow: 0 4px 16px rgba(124, 77, 255, 0.1);

    .timeline-dot {
      background: linear-gradient(135deg, #00d4ff, #7c4dff);
      transform: scale(1.3);
    }
  }
}

.timeline-dot {
  position: absolute;
  left: -30px;
  top: 50%;
  transform: translateY(-50%);
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: #fff;
  border: 2px solid #7c4dff;
  transition: all 0.25s;
}

.timeline-content {
  display: flex;
  align-items: center;
  gap: 16px;

  .item-date {
    font-size: 13px;
    color: #9a9ab0;
    white-space: nowrap;
  }
  .item-title {
    font-size: 15px;
    color: #1a1a2e;
    font-weight: 500;
  }
}

.empty {
  text-align: center;
  padding: 80px 0;
  color: #9a9ab0;

  .empty-icon { font-size: 48px; margin-bottom: 12px; }
}
</style>
