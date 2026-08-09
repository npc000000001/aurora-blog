<template>
  <div class="about-page">
    <div class="container">
      <!-- 页面标题 -->
      <div class="page-head">
        <div class="head-meta">
          <span class="meta-num">06</span>
          <span class="meta-line"></span>
        </div>
        <h1 class="head-title">
          <span>About</span>
          <span class="title-it">关于<span class="dot">.</span></span>
        </h1>
        <p class="head-sub">关于我 · 关于本站 · 联系方式</p>
      </div>

      <!-- 内容区 -->
      <div class="about-body">
        <!-- 个人介绍 -->
        <section class="about-section">
          <div class="section-head">
            <span class="section-num">01</span>
            <h2 class="section-title">Profile</h2>
          </div>
          <div class="profile-card">
            <div class="profile-avatar">
              <span>A</span>
              <span class="avatar-status"></span>
            </div>
            <div class="profile-info">
              <h3 class="profile-name">Aurora</h3>
              <p class="profile-role">@ Developer · Writer · Builder</p>
              <p class="profile-bio">
                你好，欢迎来到 Aurora Blog。我是一名软件开发者，热衷于探索技术、记录学习、分享成长。这个博客记录了我在编程之路上的思考与实践。
              </p>
              <div class="profile-socials">
                <a href="https://github.com" target="_blank" class="social-link">
                  <span>GitHub</span>
                  <span class="link-arrow">↗</span>
                </a>
                <a href="mailto:your@email.com" class="social-link">
                  <span>Email</span>
                  <span class="link-arrow">↗</span>
                </a>
              </div>
            </div>
          </div>
        </section>

        <!-- 技术栈 -->
        <section class="about-section">
          <div class="section-head">
            <span class="section-num">02</span>
            <h2 class="section-title">Tech Stack</h2>
          </div>
          <div class="tech-grid">
            <div class="tech-group">
              <h3 class="group-label">Backend</h3>
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
              <h3 class="group-label">Frontend</h3>
              <div class="tech-tags">
                <span class="tech-tag">Vue3</span>
                <span class="tech-tag">Vite</span>
                <span class="tech-tag">Element Plus</span>
                <span class="tech-tag">Pinia</span>
                <span class="tech-tag">Axios</span>
              </div>
            </div>
            <div class="tech-group">
              <h3 class="group-label">Tools</h3>
              <div class="tech-tags">
                <span class="tech-tag">Git</span>
                <span class="tech-tag">Docker</span>
                <span class="tech-tag">Maven</span>
                <span class="tech-tag">Knife4j</span>
              </div>
            </div>
          </div>
        </section>

        <!-- 关于本站 -->
        <section class="about-section">
          <div class="section-head">
            <span class="section-num">03</span>
            <h2 class="section-title">About This Site</h2>
          </div>
          <div class="prose">
            <p>Aurora Blog 是一个基于 <span class="accent">Spring Boot + Vue3</span> 前后端分离架构的个人博客系统。</p>
            <p>项目采用编辑型深色极光主题设计，所有业务代码、数据库设计、工具类、接口逻辑均独立从零开发，项目代码托管在 GitHub。</p>
            <p>博客持续更新中，后续将接入全文搜索、评论系统、访客统计等功能。</p>
          </div>
        </section>

        <!-- 联系方式 -->
        <section class="about-section">
          <div class="section-head">
            <span class="section-num">04</span>
            <h2 class="section-title">Contact</h2>
          </div>
          <div class="contact-list">
            <a href="https://github.com" target="_blank" class="contact-row">
              <span class="contact-label">GitHub</span>
              <span class="contact-value">github.com</span>
              <span class="contact-arrow">↗</span>
            </a>
          </div>
        </section>
      </div>
    </div>
  </div>
</template>

<script setup>
</script>

<style scoped lang="scss">
.about-page {
  padding: 80px 0;
}

// 页面标题
.page-head {
  margin-bottom: 64px;
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

// 内容区
.about-body {
  max-width: 880px;
  display: flex;
  flex-direction: column;
  gap: 72px;
}

.about-section {
  .section-head {
    display: flex;
    align-items: baseline;
    gap: 14px;
    margin-bottom: 28px;

    .section-num {
      font-family: var(--font-mono);
      font-size: 11px;
      color: var(--aurora-green);
      letter-spacing: 0.1em;
    }

    .section-title {
      font-family: var(--font-display);
      font-size: 28px;
      font-weight: 600;
      color: var(--text-primary);
      letter-spacing: -0.015em;
    }
  }
}

// 个人介绍卡
.profile-card {
  display: flex;
  gap: 32px;
  padding: 32px;
  background: var(--bg-elev-1);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius-base);
}

.profile-avatar {
  position: relative;
  width: 80px;
  height: 80px;
  border-radius: var(--radius-sm);
  background: linear-gradient(135deg, rgba(77, 255, 175, 0.18), rgba(167, 139, 250, 0.12));
  border: 1px solid var(--border-aurora);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;

  span:first-child {
    font-family: var(--font-display);
    font-size: 34px;
    font-weight: 600;
    color: var(--aurora-green);
  }

  .avatar-status {
    position: absolute;
    bottom: -3px;
    right: -3px;
    width: 12px;
    height: 12px;
    background: var(--aurora-green);
    border: 2px solid var(--bg-elev-1);
    border-radius: 50%;
    animation: pulse-dot 2s infinite;
  }
}

.profile-info {
  flex: 1;

  .profile-name {
    font-family: var(--font-display);
    font-size: 26px;
    font-weight: 600;
    color: var(--text-primary);
    margin-bottom: 4px;
    letter-spacing: -0.015em;
  }

  .profile-role {
    font-family: var(--font-mono);
    font-size: 12px;
    color: var(--aurora-green);
    margin-bottom: 14px;
    letter-spacing: 0.02em;
  }

  .profile-bio {
    font-size: 14px;
    line-height: 1.75;
    color: var(--text-secondary);
    margin-bottom: 18px;
  }
}

.profile-socials {
  display: flex;
  gap: 10px;
}

.social-link {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 14px;
  border: 1px solid var(--border-base);
  border-radius: var(--radius-xs);
  font-family: var(--font-mono);
  font-size: 12px;
  color: var(--text-secondary);
  transition: all var(--transition-fast);

  .link-arrow {
    font-size: 11px;
    color: var(--text-muted);
    transition: color var(--transition-fast);
  }

  &:hover {
    color: var(--aurora-green);
    border-color: var(--border-aurora);
    background: rgba(77, 255, 175, 0.04);

    .link-arrow { color: var(--aurora-green); transform: translate(2px, -2px); }
  }
}

// 技术栈
.tech-grid {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.tech-group {
  .group-label {
    font-family: var(--font-mono);
    font-size: 11px;
    text-transform: uppercase;
    letter-spacing: 0.18em;
    color: var(--aurora-green);
    margin-bottom: 12px;
    padding-bottom: 8px;
    border-bottom: 1px solid var(--border-subtle);
  }
}

.tech-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.tech-tag {
  padding: 5px 12px;
  font-family: var(--font-mono);
  font-size: 12px;
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

// 散文段
.prose {
  p {
    font-size: 15px;
    line-height: 1.85;
    color: var(--text-regular);
    margin-bottom: 14px;

    &:last-child { margin-bottom: 0; }
  }

  .accent {
    color: var(--aurora-green);
    font-weight: 500;
  }
}

// 联系方式
.contact-list {
  display: flex;
  flex-direction: column;
}

.contact-row {
  display: grid;
  grid-template-columns: 100px 1fr 24px;
  gap: 20px;
  align-items: center;
  padding: 18px 12px;
  margin: 0 -12px;
  border-bottom: 1px solid var(--border-subtle);
  transition: all var(--transition-fast);

  &:first-child { border-top: 1px solid var(--border-subtle); }

  .contact-label {
    font-family: var(--font-mono);
    font-size: 11px;
    text-transform: uppercase;
    letter-spacing: 0.12em;
    color: var(--text-muted);
  }

  .contact-value {
    font-family: var(--font-mono);
    font-size: 14px;
    color: var(--text-regular);
    transition: color var(--transition-fast);
  }

  .contact-arrow {
    color: var(--text-muted);
    opacity: 0;
    transform: translateX(-8px);
    transition: all var(--transition-fast);
  }

  &:hover {
    background: rgba(77, 255, 175, 0.04);

    .contact-value { color: var(--aurora-green); }
    .contact-arrow {
      color: var(--aurora-green);
      opacity: 1;
      transform: translateX(0);
    }
  }
}

@media (max-width: 720px) {
  .about-page { padding: 60px 0; }
  .about-body { gap: 56px; }
  .profile-card {
    flex-direction: column;
    gap: 20px;
    padding: 24px;
  }
  .contact-row {
    grid-template-columns: 80px 1fr;
    .contact-arrow { display: none; }
  }
}
</style>
