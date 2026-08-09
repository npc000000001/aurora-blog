<template>
  <aside class="sidebar">
    <!-- 个人介绍卡 -->
    <div class="card intro-card">
      <div class="intro-header">
        <div class="avatar">
          <span>A</span>
          <span class="avatar-status"></span>
        </div>
        <div class="intro-info">
          <h3 class="name">Aurora</h3>
          <p class="role">@ Developer · Writer</p>
        </div>
      </div>
      <p class="bio">热爱技术，乐于分享，记录代码、设计与思考的个人技术日志。</p>
      <div class="social-icons">
        <a href="https://github.com" target="_blank" class="social-btn" title="GitHub" aria-label="GitHub">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"/></svg>
        </a>
        <a href="mailto:your@email.com" class="social-btn" title="邮箱" aria-label="邮箱">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" /><path d="M22 6l-10 7L2 6" />
          </svg>
        </a>
        <a href="#" class="social-btn" title="RSS" aria-label="RSS">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M4 11a9 9 0 0 1 9 9M4 4a16 16 0 0 1 16 16" /><circle cx="5" cy="19" r="1" />
          </svg>
        </a>
      </div>
    </div>

    <!-- 标签云 -->
    <div class="card" v-if="tags.length">
      <div class="card-title">
        <span class="title-text">Tags</span>
        <span class="title-line"></span>
        <span class="title-count">{{ tags.length }}</span>
      </div>
      <div class="tag-cloud">
        <router-link
          v-for="tag in tags"
          :key="tag.id"
          :to="`/tag/${tag.name}`"
          class="tag"
        >
          <span class="tag-hash">#</span>{{ tag.name }}
        </router-link>
      </div>
    </div>

    <!-- 随机文章 -->
    <div class="card" v-if="randomBlogs.length">
      <div class="card-title">
        <span class="title-text">Random</span>
        <span class="title-line"></span>
      </div>
      <div class="random-list">
        <div
          v-for="(item, i) in randomBlogs"
          :key="item.id"
          class="random-item"
          @click="goDetail(item.id)"
        >
          <span class="random-index">{{ String(i + 1).padStart(2, '0') }}</span>
          <span class="random-title">{{ item.title }}</span>
        </div>
      </div>
    </div>

    <!-- 站点信息卡 -->
    <div class="card mini-card">
      <div class="mini-row">
        <span class="mini-label">站点</span>
        <span class="mini-value">Aurora.Blog</span>
      </div>
      <div class="mini-row">
        <span class="mini-label">引擎</span>
        <span class="mini-value">Spring Boot · Vue3</span>
      </div>
      <div class="mini-row">
        <span class="mini-label">主题</span>
        <span class="mini-value">Editorial Aurora</span>
      </div>
    </div>
  </aside>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getAllTags } from '@/api/tag'
import { getRandomBlog } from '@/api/blog'

const router = useRouter()
const tags = ref([])
const randomBlogs = ref([])

const goDetail = (id) => router.push(`/blog/${id}`)

const fetchData = async () => {
  try {
    const res = await getAllTags()
    tags.value = res.data || []
  } catch (e) { /* 静默降级 */ }
  try {
    const res = await getRandomBlog()
    randomBlogs.value = res.data || []
  } catch (e) { /* 静默降级 */ }
}

onMounted(fetchData)
</script>

<style scoped lang="scss">
.sidebar {
  display: flex;
  flex-direction: column;
  gap: 20px;
  position: sticky;
  top: 88px;
}

.card {
  background: var(--bg-elev-1);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius-base);
  padding: 22px;
  transition: border-color var(--transition-base);

  &:hover {
    border-color: var(--border-base);
  }
}

.card-title {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 16px;

  .title-text {
    font-family: var(--font-mono);
    font-size: 11px;
    font-weight: 500;
    text-transform: uppercase;
    letter-spacing: 0.18em;
    color: var(--aurora-green);
  }

  .title-line {
    flex: 1;
    height: 1px;
    background: var(--border-subtle);
  }

  .title-count {
    font-family: var(--font-mono);
    font-size: 11px;
    color: var(--text-muted);
  }
}

// 介绍卡
.intro-card {
  padding: 24px;
}

.intro-header {
  display: flex;
  align-items: center;
  gap: 14px;
  margin-bottom: 14px;
}

.avatar {
  position: relative;
  width: 52px;
  height: 52px;
  border-radius: var(--radius-sm);
  background: linear-gradient(135deg, rgba(77, 255, 175, 0.2), rgba(167, 139, 250, 0.15));
  border: 1px solid var(--border-aurora);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;

  span:first-child {
    font-family: var(--font-display);
    font-size: 22px;
    font-weight: 600;
    color: var(--aurora-green);
  }

  .avatar-status {
    position: absolute;
    bottom: -2px;
    right: -2px;
    width: 10px;
    height: 10px;
    background: var(--aurora-green);
    border: 2px solid var(--bg-elev-1);
    border-radius: 50%;
    animation: pulse-dot 2s infinite;
  }
}

.intro-info {
  .name {
    font-family: var(--font-display);
    font-size: 18px;
    font-weight: 600;
    color: var(--text-primary);
    line-height: 1.2;
    margin-bottom: 4px;
  }

  .role {
    font-family: var(--font-mono);
    font-size: 11px;
    color: var(--text-muted);
    letter-spacing: 0.02em;
  }
}

.bio {
  font-size: 13px;
  line-height: 1.7;
  color: var(--text-secondary);
  margin-bottom: 16px;
}

.social-icons {
  display: flex;
  gap: 8px;
}

.social-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  color: var(--text-secondary);
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius-xs);
  transition: all var(--transition-fast);

  &:hover {
    color: var(--aurora-green);
    border-color: var(--border-aurora);
    background: rgba(77, 255, 175, 0.06);
    transform: translateY(-2px);
  }
}

// 标签云
.tag-cloud {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.tag {
  display: inline-flex;
  align-items: center;
  padding: 4px 10px;
  font-family: var(--font-mono);
  font-size: 12px;
  color: var(--text-secondary);
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius-xs);
  transition: all var(--transition-fast);

  .tag-hash {
    color: var(--text-muted);
    margin-right: 2px;
  }

  &:hover {
    color: var(--aurora-green);
    border-color: var(--border-aurora);
    background: rgba(77, 255, 175, 0.06);

    .tag-hash { color: var(--aurora-green); }
  }
}

// 随机文章
.random-list {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.random-item {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  padding: 10px 8px;
  margin: 0 -8px;
  cursor: pointer;
  border-radius: var(--radius-xs);
  transition: all var(--transition-fast);

  .random-index {
    font-family: var(--font-mono);
    font-size: 10px;
    color: var(--text-muted);
    margin-top: 3px;
    flex-shrink: 0;
    transition: color var(--transition-fast);
  }

  .random-title {
    font-size: 13px;
    line-height: 1.5;
    color: var(--text-regular);
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    transition: color var(--transition-fast);
  }

  &:hover {
    background: rgba(77, 255, 175, 0.04);

    .random-index { color: var(--aurora-green); }
    .random-title { color: var(--text-primary); }
  }
}

// 站点信息卡
.mini-card {
  padding: 18px 22px;
}

.mini-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 6px 0;
  font-family: var(--font-mono);
  font-size: 11px;

  .mini-label {
    color: var(--text-muted);
    text-transform: uppercase;
    letter-spacing: 0.1em;
  }

  .mini-value {
    color: var(--text-secondary);
  }
}

@media (max-width: 960px) {
  .sidebar { position: static; }
}
</style>
