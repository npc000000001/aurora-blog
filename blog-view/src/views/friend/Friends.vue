<template>
  <div class="friends-page">
    <div class="container">
      <!-- 页面标题 -->
      <div class="page-head">
        <div class="head-meta">
          <span class="meta-num">05</span>
          <span class="meta-line"></span>
        </div>
        <h1 class="head-title">
          <span>Friends</span>
          <span class="title-it">友链<span class="dot">.</span></span>
        </h1>
        <p class="head-sub">互相学习 · 共同成长</p>
      </div>

      <!-- 友链网格 -->
      <div class="friends-grid">
        <a
          v-for="(friend, i) in friends"
          :key="friend.id"
          :href="friend.website"
          target="_blank"
          class="friend-card"
          :style="{ animationDelay: `${i * 0.05}s` }"
        >
          <div class="card-top">
            <span class="card-index">{{ String(i + 1).padStart(2, '0') }}</span>
            <span class="card-external">↗</span>
          </div>
          <div class="card-body">
            <h3 class="card-name">{{ friend.nickname }}</h3>
            <p class="card-desc">{{ friend.description }}</p>
          </div>
          <div class="card-foot">
            <span class="foot-line"></span>
            <span class="foot-text">{{ friend.website !== '#' ? 'Visit' : 'Soon' }}</span>
          </div>
        </a>
      </div>

      <!-- 申请友链 -->
      <div class="apply-card">
        <div class="apply-head">
          <span class="apply-mark">§</span>
          <h2 class="apply-title">Apply for Link Exchange</h2>
        </div>
        <div class="apply-content">
          <p>欢迎交换友链，请确保你的站点满足以下条件：</p>
          <ul class="apply-list">
            <li>
              <span class="list-marker">01</span>
              <span>原创技术博客，内容健康向上</span>
            </li>
            <li>
              <span class="list-marker">02</span>
              <span>网站稳定可访问，HTTPS 加密</span>
            </li>
            <li>
              <span class="list-marker">03</span>
              <span>至少有 10 篇原创文章</span>
            </li>
          </ul>
          <p class="apply-contact">符合条件请邮件联系：<a href="mailto:your@email.com">your@email.com</a></p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getAllFriends } from '@/api/friend'

const friends = ref([
  { id: 1, nickname: 'Aurora', description: '热爱技术的开发者', website: '#' },
  { id: 2, nickname: 'Coder', description: '代码改变世界', website: '#' },
  { id: 3, nickname: 'Explorer', description: '探索未知，分享所学', website: '#' },
  { id: 4, nickname: 'Dreamer', description: '追逐梦想的旅人', website: '#' }
])

const fetchFriends = async () => {
  try {
    const res = await getAllFriends()
    if (res.data && res.data.length) friends.value = res.data
  } catch (e) { /* 静默降级 */ }
}

onMounted(fetchFriends)
</script>

<style scoped lang="scss">
.friends-page {
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

// 友链网格
.friends-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 16px;
  margin-bottom: 64px;
}

.friend-card {
  display: flex;
  flex-direction: column;
  padding: 22px 24px;
  background: var(--bg-elev-1);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius-base);
  transition: all var(--transition-base);
  animation: fadeInUp 0.5s both;
  min-height: 180px;

  &:hover {
    border-color: var(--border-aurora);
    background: var(--bg-elev-2);
    transform: translateY(-3px);

    .card-external { color: var(--aurora-green); transform: translate(2px, -2px); }
    .card-name { color: var(--aurora-green); }
    .foot-line { background: var(--aurora-green); }
  }
}

.card-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;

  .card-index {
    font-family: var(--font-mono);
    font-size: 11px;
    color: var(--text-muted);
    letter-spacing: 0.1em;
  }

  .card-external {
    color: var(--text-muted);
    font-size: 16px;
    transition: all var(--transition-base);
  }
}

.card-body {
  flex: 1;

  .card-name {
    font-family: var(--font-display);
    font-size: 22px;
    font-weight: 600;
    color: var(--text-primary);
    margin-bottom: 8px;
    letter-spacing: -0.01em;
    transition: color var(--transition-base);
  }

  .card-desc {
    font-size: 13px;
    line-height: 1.6;
    color: var(--text-secondary);
  }
}

.card-foot {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-top: 18px;
  padding-top: 16px;
  border-top: 1px solid var(--border-subtle);

  .foot-line {
    width: 16px;
    height: 1px;
    background: var(--border-base);
    transition: background var(--transition-base);
  }

  .foot-text {
    font-family: var(--font-mono);
    font-size: 10px;
    text-transform: uppercase;
    letter-spacing: 0.15em;
    color: var(--text-muted);
  }
}

// 申请友链卡
.apply-card {
  max-width: 720px;
  margin: 0 auto;
  padding: 36px 40px;
  background: var(--bg-elev-1);
  border: 1px solid var(--border-subtle);
  border-left: 2px solid var(--aurora-green);
  border-radius: 0 var(--radius-sm) var(--radius-sm) 0;
}

.apply-head {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 20px;

  .apply-mark {
    font-family: var(--font-display);
    font-size: 24px;
    color: var(--aurora-green);
    font-style: italic;
  }

  .apply-title {
    font-family: var(--font-display);
    font-size: 22px;
    font-weight: 600;
    color: var(--text-primary);
    letter-spacing: -0.01em;
  }
}

.apply-content {
  p {
    font-size: 14px;
    line-height: 1.7;
    color: var(--text-secondary);
    margin-bottom: 16px;
  }

  a {
    color: var(--aurora-green);
    border-bottom: 1px solid rgba(77, 255, 175, 0.3);
    transition: border-color var(--transition-fast);
    &:hover { border-bottom-color: var(--aurora-green); }
  }
}

.apply-list {
  list-style: none;
  padding: 0;
  margin-bottom: 20px;

  li {
    display: flex;
    align-items: baseline;
    gap: 14px;
    padding: 10px 0;
    border-bottom: 1px dashed var(--border-subtle);
    font-size: 14px;
    color: var(--text-regular);

    .list-marker {
      font-family: var(--font-mono);
      font-size: 11px;
      color: var(--aurora-green);
      letter-spacing: 0.1em;
      flex-shrink: 0;
    }
  }
}

.apply-contact {
  padding-top: 8px;
}

@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(12px); }
  to { opacity: 1; transform: translateY(0); }
}

@media (max-width: 720px) {
  .friends-page { padding: 60px 0; }
  .apply-card { padding: 28px 22px; }
}
</style>
