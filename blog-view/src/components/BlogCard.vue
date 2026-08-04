<template>
  <article class="blog-card" @click="goDetail">
    <!-- 置顶标识 -->
    <div v-if="blog.isTop" class="top-badge">
      <span>置顶</span>
    </div>

    <!-- 封面区（渐变占位，后续可接封面图） -->
    <div class="cover" :style="coverStyle">
      <div class="cover-overlay">
        <span class="category-tag" v-if="blog.categoryName">{{ blog.categoryName }}</span>
      </div>
    </div>

    <!-- 内容区 -->
    <div class="content">
      <h2 class="title">{{ blog.title }}</h2>
      <p class="summary">{{ blog.summary || stripMarkdown(blog.content) }}</p>

      <!-- 元信息 -->
      <div class="meta">
        <span class="meta-item">
          <span class="icon">📅</span>
          {{ formatDate(blog.createTime) }}
        </span>
        <span class="meta-item">
          <span class="icon">👁</span>
          {{ blog.views || 0 }}
        </span>
        <span class="meta-item" v-if="wordCount">
          <span class="icon">✎</span>
          {{ wordCount }} 字
        </span>
      </div>

      <!-- 阅读全文按钮 -->
      <div class="footer">
        <span class="read-btn">
          阅读全文
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
  blog: {
    type: Object,
    required: true
  }
})

const router = useRouter()

// 极光渐变色板（根据id循环取色，作为封面占位）
const gradients = [
  'linear-gradient(135deg, #00d4ff 0%, #4facfe 100%)',
  'linear-gradient(135deg, #7c4dff 0%, #5b6eff 100%)',
  'linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)',
  'linear-gradient(135deg, #fa709a 0%, #fee140 100%)',
  'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
  'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)'
]

const coverStyle = computed(() => ({
  background: gradients[props.blog.id % gradients.length]
}))

const wordCount = computed(() => {
  const content = props.blog.content || ''
  return props.blog.summary ? null : content.replace(/[#*`>\-\[\]()!\s]/g, '').length
})

const stripMarkdown = (content) => {
  if (!content) return ''
  const text = content.replace(/[#*`>\-\[\]()!]/g, '').replace(/\n+/g, ' ')
  return text.length > 120 ? text.substring(0, 120) + '...' : text
}

const formatDate = (str) => str ? str.substring(0, 10) : ''

const goDetail = () => router.push(`/blog/${props.blog.id}`)
</script>

<style scoped lang="scss">
.blog-card {
  position: relative;
  background: #fff;
  border-radius: 16px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);

  &:hover {
    transform: translateY(-6px);
    box-shadow: 0 12px 36px rgba(124, 77, 255, 0.15);

    .title {
      color: #7c4dff;
    }
    .cover-overlay {
      opacity: 1;
    }
    .read-btn .arrow {
      transform: translateX(4px);
    }
  }
}

.top-badge {
  position: absolute;
  top: 12px;
  right: -28px;
  z-index: 2;
  background: linear-gradient(135deg, #ff6b6b, #ee5a24);
  color: #fff;
  padding: 4px 32px;
  font-size: 11px;
  font-weight: 600;
  transform: rotate(45deg);
  box-shadow: 0 2px 8px rgba(238, 90, 36, 0.4);
}

.cover {
  height: 180px;
  position: relative;
  display: flex;
  align-items: flex-end;
  padding: 16px;
}

.cover-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(to top, rgba(0, 0, 0, 0.3) 0%, transparent 60%);
  opacity: 0.8;
  transition: opacity 0.3s;
}

.category-tag {
  position: relative;
  z-index: 1;
  display: inline-block;
  padding: 4px 12px;
  background: rgba(255, 255, 255, 0.95);
  color: #7c4dff;
  font-size: 12px;
  font-weight: 600;
  border-radius: 20px;
  backdrop-filter: blur(10px);
}

.content {
  padding: 20px 22px 18px;
}

.title {
  font-size: 18px;
  font-weight: 600;
  line-height: 1.5;
  color: #1a1a2e;
  margin-bottom: 8px;
  transition: color 0.2s;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.summary {
  font-size: 14px;
  color: #6a6a85;
  line-height: 1.7;
  margin-bottom: 14px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.meta {
  display: flex;
  gap: 16px;
  flex-wrap: wrap;
  margin-bottom: 14px;

  .meta-item {
    display: flex;
    align-items: center;
    gap: 4px;
    font-size: 12px;
    color: #9a9ab0;

    .icon {
      font-size: 13px;
    }
  }
}

.footer {
  display: flex;
  justify-content: flex-end;
  padding-top: 12px;
  border-top: 1px solid #f0f2f8;
}

.read-btn {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-size: 13px;
  font-weight: 500;
  color: #7c4dff;

  .arrow {
    transition: transform 0.2s;
  }
}
</style>
