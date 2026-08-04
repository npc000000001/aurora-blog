<template>
  <aside class="sidebar">
    <!-- 个人介绍卡 -->
    <div class="card intro-card">
      <div class="avatar-wrapper">
        <div class="avatar-ring"></div>
        <div class="avatar">A</div>
      </div>
      <h3 class="name">Aurora</h3>
      <div class="rolling-text">
        <span class="rolling-char" v-for="(char, i) in displayText" :key="i" :style="{ color: char.color }">
          {{ char.char }}
        </span>
      </div>
      <p class="bio">热爱技术 · 乐于分享 · 持续成长</p>
      <div class="social-icons">
        <a href="https://github.com" target="_blank" class="social-btn github" title="GitHub">
          <svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor"><path d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"/></svg>
        </a>
        <a href="mailto:your@email.com" class="social-btn email" title="邮箱">
          <svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor"><path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z"/></svg>
        </a>
        <a href="#" class="social-btn qq" title="QQ">
          <svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor"><path d="M12.003 0c-2.265 0-6.29 1.366-6.29 7.05 0 1.19.062 2.035.156 2.74-.265.118-.625.395-.625.97 0 1.36 1.47 1.79 1.47 1.79s.04.69.17 1.58c-.43.34-1.13.73-1.13 1.9 0 1.82 2.17 2.55 2.17 2.55s.04 1.36.62 2.03c-.34.21-.65.45-.65.6 0 .86 1.73 2.06 3.62 2.06 1.89 0 3.62-1.2 3.62-2.06 0-.15-.31-.39-.65-.6.58-.67.62-2.03.62-2.03s2.17-.73 2.17-2.55c0-1.17-.7-1.56-1.13-1.9.13-.89.17-1.58.17-1.58s1.47-.43 1.47-1.79c0-.575-.36-.852-.625-.97.094-.705.156-1.55.156-2.74C18.293 1.366 14.268 0 12.003 0z"/></svg>
        </a>
      </div>
    </div>

    <!-- 标签云 -->
    <div class="card tag-card" v-if="tags.length">
      <div class="card-title">
        <span class="title-icon">🏷</span>
        <span>标签云</span>
      </div>
      <div class="tag-cloud">
        <router-link
          v-for="tag in tags"
          :key="tag.id"
          :to="`/tag/${tag.name}`"
          class="tag"
          :style="{ background: getTagBg(tag.id), color: getTagColor(tag.id) }"
        >
          {{ tag.name }}
        </router-link>
      </div>
    </div>

    <!-- 随机文章 -->
    <div class="card random-card" v-if="randomBlogs.length">
      <div class="card-title">
        <span class="title-icon">🎲</span>
        <span>随机文章</span>
      </div>
      <div class="random-list">
        <div
          v-for="item in randomBlogs"
          :key="item.id"
          class="random-item"
          @click="goDetail(item.id)"
        >
          <span class="dot"></span>
          <span class="random-title">{{ item.title }}</span>
        </div>
      </div>
    </div>
  </aside>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import request from '@/utils/request'

const router = useRouter()
const tags = ref([])
const randomBlogs = ref([])

// 彩色滚动字效果
const fullText = 'Keep Coding, Keep Growing'
const colors = ['#00d4ff', '#4facfe', '#7c4dff', '#f093fb', '#43e97b']
const displayText = ref([])
let rollingTimer = null

const startRolling = () => {
  let idx = 0
  rollingTimer = setInterval(() => {
    if (idx >= fullText.length) {
      displayText.value = fullText.split('').map((c, i) => ({ char: c, color: colors[i % colors.length] }))
      setTimeout(() => {
        idx = 0
        displayText.value = []
      }, 3000)
      return
    }
    displayText.value = [
      ...displayText.value,
      { char: fullText[idx], color: colors[idx % colors.length] }
    ]
    idx++
  }, 120)
}

// 标签颜色（循环色板）
const tagColors = [
  { bg: 'rgba(0,212,255,0.1)', color: '#00a7c7' },
  { bg: 'rgba(124,77,255,0.1)', color: '#7c4dff' },
  { bg: 'rgba(67,233,123,0.1)', color: '#2bab5e' },
  { bg: 'rgba(250,115,154,0.1)', color: '#d44370' },
  { bg: 'rgba(255,193,7,0.1)', color: '#c49a00' }
]

const getTagBg = (id) => tagColors[id % tagColors.length].bg
const getTagColor = (id) => tagColors[id % tagColors.length].color

const goDetail = (id) => router.push(`/blog/${id}`)

// 拉取数据（接口失败优雅降级）
const fetchData = async () => {
  try {
    const res = await request({ url: '/tag/all', method: 'get' })
    tags.value = res.data || []
  } catch (e) {
    // 标签接口未实现，静默降级
  }
  try {
    const res = await request({ url: '/blog/random', method: 'get' })
    randomBlogs.value = res.data || []
  } catch (e) {
    // 随机文章接口未实现，静默降级
  }
}

onMounted(() => {
  startRolling()
  fetchData()
})
onUnmounted(() => {
  if (rollingTimer) clearInterval(rollingTimer)
})
</script>

<style scoped lang="scss">
.sidebar {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.card {
  background: #fff;
  border-radius: 16px;
  padding: 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  transition: box-shadow 0.3s;

  &:hover {
    box-shadow: 0 8px 30px rgba(124, 77, 255, 0.08);
  }
}

.card-title {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 15px;
  font-weight: 600;
  color: #1a1a2e;
  margin-bottom: 16px;

  .title-icon { font-size: 16px; }
}

// 介绍卡
.intro-card {
  text-align: center;
  background: linear-gradient(180deg, rgba(0,212,255,0.04) 0%, rgba(124,77,255,0.04) 100%);
}

.avatar-wrapper {
  position: relative;
  width: 90px;
  height: 90px;
  margin: 0 auto 12px;
}

.avatar-ring {
  position: absolute;
  inset: -4px;
  border-radius: 50%;
  background: linear-gradient(135deg, #00d4ff, #7c4dff);
  animation: ring-rotate 3s linear infinite;

  &::before {
    content: '';
    position: absolute;
    inset: 4px;
    border-radius: 50%;
    background: #fff;
  }
}

.avatar {
  position: relative;
  width: 90px;
  height: 90px;
  line-height: 90px;
  border-radius: 50%;
  background: linear-gradient(135deg, #00d4ff, #7c4dff);
  color: #fff;
  font-size: 36px;
  font-weight: 700;
  z-index: 1;
}

@keyframes ring-rotate {
  to { transform: rotate(360deg); }
}

.name {
  font-size: 18px;
  font-weight: 600;
  color: #1a1a2e;
  margin-bottom: 8px;
}

.rolling-text {
  min-height: 22px;
  font-size: 13px;
  font-weight: 500;
  margin-bottom: 8px;
  letter-spacing: 0.5px;
}

.bio {
  font-size: 13px;
  color: #8c8ca1;
  margin-bottom: 16px;
}

.social-icons {
  display: flex;
  justify-content: center;
  gap: 10px;
}

.social-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  color: #6a6a85;
  background: rgba(255, 255, 255, 0.8);
  border: 1px solid #ebeef5;
  transition: all 0.25s;

  &:hover {
    color: #fff;
    border-color: transparent;
    transform: translateY(-3px);
  }

  &.github:hover { background: #333; }
  &.email:hover { background: #ea4335; }
  &.qq:hover { background: #12b7f5; }
}

// 标签云
.tag-cloud {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.tag {
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 500;
  transition: all 0.2s;

  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  }
}

// 随机文章
.random-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.random-item {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 6px 0;
  transition: all 0.2s;

  .dot {
    flex-shrink: 0;
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background: linear-gradient(135deg, #00d4ff, #7c4dff);
  }

  .random-title {
    font-size: 13px;
    color: #4a4a68;
    line-height: 1.5;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    transition: color 0.2s;
  }

  &:hover .random-title {
    color: #7c4dff;
  }
}
</style>
