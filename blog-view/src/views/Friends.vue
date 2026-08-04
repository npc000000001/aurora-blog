<template>
  <div class="friends-page">
    <div class="container">
      <div class="page-header">
        <h1 class="page-title"><span class="title-icon">❤</span> 友人帐</h1>
        <p class="page-desc">互相学习，共同成长</p>
      </div>

      <div class="friends-grid">
        <a
          v-for="friend in friends"
          :key="friend.id"
          :href="friend.website"
          target="_blank"
          class="friend-card"
          :style="{ background: getBg(friend.id) }"
        >
          <div class="card-inner">
            <div class="avatar">{{ friend.nickname.charAt(0) }}</div>
            <div class="info">
              <h3>{{ friend.nickname }}</h3>
              <p>{{ friend.description }}</p>
            </div>
          </div>
        </a>
      </div>

      <div class="friend-desc">
        <h3>申请友链</h3>
        <p>欢迎交换友链！请确保你的站点满足以下条件：</p>
        <ul>
          <li>原创技术博客，内容健康</li>
          <li>网站稳定可访问，HTTPS 加密</li>
          <li>至少有 10 篇原创文章</li>
        </ul>
        <p>符合条件请在评论区留言，或邮件联系：your@email.com</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import request from '@/utils/request'

const friends = ref([
  { id: 1, nickname: 'Aurora', description: '热爱技术的开发者', website: '#' },
  { id: 2, nickname: 'Coder', description: '代码改变世界', website: '#' },
  { id: 3, nickname: 'Explorer', description: '探索未知，分享所学', website: '#' },
  { id: 4, nickname: 'Dreamer', description: '追逐梦想的旅人', website: '#' }
])

const bgs = [
  'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
  'linear-gradient(135deg, #00d4ff 0%, #4facfe 100%)',
  'linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)',
  'linear-gradient(135deg, #fa709a 0%, #fee140 100%)',
  'linear-gradient(135deg, #7c4dff 0%, #5b6eff 100%)',
  'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)'
]

const getBg = (id) => bgs[id % bgs.length]

const fetchFriends = async () => {
  try {
    const res = await request({ url: '/friend/all', method: 'get' })
    if (res.data && res.data.length) friends.value = res.data
  } catch (e) {
    // 接口未实现，使用静态友链
  }
}

onMounted(fetchFriends)
</script>

<style scoped lang="scss">
.friends-page { padding: 40px 0; }

.page-header { text-align: center; margin-bottom: 40px; }

.page-title {
  font-size: 32px; font-weight: 700; color: #1a1a2e;
  display: flex; align-items: center; justify-content: center; gap: 8px;
  margin-bottom: 8px;
  .title-icon { font-size: 28px; color: #fa709a; }
}

.page-desc { color: #8c8ca1; font-size: 14px; }

.friends-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px;
  margin-bottom: 48px;
}

.friend-card {
  display: block;
  border-radius: 16px;
  padding: 2px;
  transition: all 0.3s;
  overflow: hidden;

  &:hover {
    transform: translateY(-6px);
    box-shadow: 0 12px 32px rgba(0,0,0,0.15);
  }
}

.card-inner {
  background: #fff;
  border-radius: 14px;
  padding: 24px;
  display: flex;
  align-items: center;
  gap: 16px;
  height: 100%;
}

.avatar {
  flex-shrink: 0;
  width: 56px; height: 56px;
  border-radius: 50%;
  background: linear-gradient(135deg, #00d4ff, #7c4dff);
  color: #fff;
  font-size: 24px; font-weight: 700;
  display: flex; align-items: center; justify-content: center;
}

.info {
  min-width: 0;
  h3 { font-size: 16px; color: #1a1a2e; margin-bottom: 4px; }
  p { font-size: 13px; color: #9a9ab0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
}

.friend-desc {
  max-width: 700px;
  margin: 0 auto;
  padding: 32px;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.04);

  h3 {
    font-size: 18px; color: #1a1a2e; margin-bottom: 16px;
    padding-left: 12px; border-left: 3px solid; border-image: linear-gradient(180deg, #00d4ff, #7c4dff) 1;
  }
  p { font-size: 14px; color: #4a4a68; margin-bottom: 12px; line-height: 1.7; }
  ul { padding-left: 24px; margin-bottom: 16px; }
  li { font-size: 14px; color: #6a6a85; margin: 6px 0; }
}
</style>
