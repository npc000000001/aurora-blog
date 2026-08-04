<template>
  <div class="about-page">
    <div class="container">
      <div class="about-card">
        <div class="about-header">
          <div class="avatar-ring">
            <div class="avatar">A</div>
          </div>
          <h1 class="name">Aurora</h1>
          <p class="tagline">热爱技术 · 乐于分享 · 持续成长</p>
          <div class="social-links">
            <a href="https://github.com" target="_blank" class="social-link">GitHub</a>
            <a href="mailto:your@email.com" class="social-link">Email</a>
          </div>
        </div>

        <div class="about-content">
          <div class="content-section">
            <h2>关于我</h2>
            <p>你好，欢迎来到 Aurora Blog！</p>
            <p>我是一名软件开发者，热衷于探索技术、记录学习、分享成长。这个博客记录了我在编程之路上的思考与实践，内容涵盖后端开发、前端技术和工程实践。</p>
            <p>相信技术的力量可以改变世界，也相信持续学习是最好的投资。在这里，你会找到我踩过的坑、解决过的问题、以及一些技术随笔。</p>
          </div>

          <div class="content-section">
            <h2>技术栈</h2>
            <div class="tech-list">
              <div class="tech-group">
                <h3>后端</h3>
                <div class="tech-tags">
                  <span class="tech-tag">Java</span>
                  <span class="tech-tag">Spring Boot</span>
                  <span class="tech-tag">MyBatis-Plus</span>
                  <span class="tech-tag">MySQL</span>
                  <span class="tech-tag">Redis</span>
                  <span class="tech-tag">Spring Security</span>
                  <span class="tech-tag">JWT</span>
                </div>
              </div>
              <div class="tech-group">
                <h3>前端</h3>
                <div class="tech-tags">
                  <span class="tech-tag">Vue3</span>
                  <span class="tech-tag">Vite</span>
                  <span class="tech-tag">Element Plus</span>
                  <span class="tech-tag">Pinia</span>
                  <span class="tech-tag">Axios</span>
                </div>
              </div>
              <div class="tech-group">
                <h3>工具</h3>
                <div class="tech-tags">
                  <span class="tech-tag">Git</span>
                  <span class="tech-tag">Docker</span>
                  <span class="tech-tag">Maven</span>
                  <span class="tech-tag">Knife4j</span>
                </div>
              </div>
            </div>
          </div>

          <div class="content-section">
            <h2>关于本站</h2>
            <p>Aurora Blog 是一个基于 Spring Boot + Vue3 前后端分离架构的个人博客系统。</p>
            <p>项目采用极光主题设计，所有业务代码、数据库设计、工具类、接口逻辑均独立从零开发，项目代码托管在 GitHub。</p>
            <p>博客持续更新中，后续将接入全文搜索、评论系统、访客统计等功能。</p>
          </div>

          <div class="content-section">
            <h2>联系方式</h2>
            <div class="contact-list">
              <div class="contact-item">
                <span class="contact-icon">✉</span>
                <span>your@email.com</span>
              </div>
              <div class="contact-item">
                <span class="contact-icon">⌥</span>
                <a href="https://github.com" target="_blank">GitHub</a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
</script>

<style scoped lang="scss">
.about-page { padding: 40px 0; }

.about-card {
  max-width: 800px;
  margin: 0 auto;
  background: #fff;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 4px 24px rgba(0,0,0,0.06);
}

.about-header {
  text-align: center;
  padding: 48px 32px 40px;
  background: linear-gradient(135deg, rgba(0,212,255,0.06) 0%, rgba(124,77,255,0.06) 100%);
}

.avatar-ring {
  position: relative;
  width: 100px; height: 100px;
  margin: 0 auto 16px;

  &::before {
    content: '';
    position: absolute; inset: -4px;
    border-radius: 50%;
    background: linear-gradient(135deg, #00d4ff, #7c4dff);
    animation: ring-rotate 3s linear infinite;
  }
  &::after {
    content: '';
    position: absolute; inset: 0;
    border-radius: 50%;
    background: #fff;
    margin: 4px;
  }
}

.avatar {
  position: absolute; inset: 0;
  width: 100px; height: 100px;
  border-radius: 50%;
  background: linear-gradient(135deg, #00d4ff, #7c4dff);
  color: #fff;
  font-size: 40px; font-weight: 700;
  display: flex; align-items: center; justify-content: center;
  z-index: 1;
}

@keyframes ring-rotate { to { transform: rotate(360deg); } }

.name {
  font-size: 28px; font-weight: 700; color: #1a1a2e;
  margin-bottom: 8px;
}

.tagline { font-size: 14px; color: #8c8ca1; margin-bottom: 20px; }

.social-links {
  display: flex; justify-content: center; gap: 12px;
}

.social-link {
  padding: 6px 20px;
  border-radius: 20px;
  font-size: 13px; font-weight: 500;
  color: #7c4dff;
  background: rgba(124, 77, 255, 0.08);
  transition: all 0.2s;

  &:hover {
    background: linear-gradient(135deg, #00d4ff, #7c4dff);
    color: #fff;
    transform: translateY(-2px);
  }
}

.about-content { padding: 40px 48px; }

.content-section {
  margin-bottom: 40px;

  &:last-child { margin-bottom: 0; }

  h2 {
    font-size: 20px; font-weight: 600; color: #1a1a2e;
    margin-bottom: 16px;
    padding-left: 12px;
    border-left: 3px solid;
    border-image: linear-gradient(180deg, #00d4ff, #7c4dff) 1;
  }

  p {
    font-size: 15px; color: #4a4a68;
    line-height: 1.9; margin-bottom: 12px;
  }
}

.tech-list { display: flex; flex-direction: column; gap: 20px; }

.tech-group {
  h3 { font-size: 14px; color: #6a6a85; margin-bottom: 10px; }
}

.tech-tags { display: flex; flex-wrap: wrap; gap: 8px; }

.tech-tag {
  padding: 4px 14px;
  border-radius: 20px;
  font-size: 13px;
  background: rgba(124, 77, 255, 0.06);
  color: #7c4dff;
  transition: all 0.2s;

  &:hover {
    background: linear-gradient(135deg, #00d4ff, #7c4dff);
    color: #fff;
    transform: translateY(-2px);
  }
}

.contact-list { display: flex; flex-direction: column; gap: 12px; }

.contact-item {
  display: flex; align-items: center; gap: 10px;
  font-size: 14px; color: #4a4a68;

  .contact-icon {
    width: 32px; height: 32px;
    border-radius: 8px;
    background: rgba(124, 77, 255, 0.08);
    color: #7c4dff;
    display: flex; align-items: center; justify-content: center;
    font-size: 16px;
  }

  a { color: #7c4dff; &:hover { opacity: 0.8; } }
}

@media (max-width: 600px) {
  .about-content { padding: 24px; }
}
</style>
