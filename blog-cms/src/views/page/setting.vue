<template>
  <div class="setting-page">
    <!-- 页面标题栏 -->
    <div class="page-title-bar">
      <h2>站点设置</h2>
    </div>

    <!-- 基础设置卡片 -->
    <div class="app-card setting-card">
      <div class="card-header">
        <el-icon class="header-icon"><Setting /></el-icon>
        <h3>基础设置</h3>
      </div>
      <el-form :model="basicForm" label-position="top" class="setting-form">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="博客名称">
              <el-input v-model="basicForm.blogName" placeholder="请输入博客名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="网页标题后缀">
              <el-input v-model="basicForm.titleSuffix" placeholder="如 - Aurora Blog" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="副标题">
              <el-input v-model="basicForm.subtitle" placeholder="请输入副标题" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="页脚文案">
              <el-input v-model="basicForm.footer" placeholder="请输入页脚文案" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </div>

    <!-- 资料卡设置 -->
    <div class="app-card setting-card">
      <div class="card-header">
        <el-icon class="header-icon"><User /></el-icon>
        <h3>资料卡</h3>
      </div>
      <el-form :model="profileForm" label-position="top" class="setting-form">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="头像 URL">
              <el-input v-model="profileForm.avatar" placeholder="请输入头像图片地址" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="昵称">
              <el-input v-model="profileForm.nickname" placeholder="请输入昵称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="个性签名">
              <el-input v-model="profileForm.signature" placeholder="请输入个性签名" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="GitHub 地址">
              <el-input v-model="profileForm.github" placeholder="https://github.com/xxx" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="邮箱">
              <el-input v-model="profileForm.email" placeholder="请输入邮箱" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </div>

    <!-- 备案信息卡片 -->
    <div class="app-card setting-card">
      <div class="card-header">
        <el-icon class="header-icon"><Document /></el-icon>
        <h3>备案信息</h3>
      </div>
      <el-form :model="filingForm" label-position="top" class="setting-form">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="ICP 备案号">
              <el-input v-model="filingForm.icp" placeholder="如：京ICP备XXXXXXXX号" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="公安备案号">
              <el-input v-model="filingForm.police" placeholder="如：京公网安备XXXXXXXXXXXX号" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </div>

    <!-- 底部保存按钮 -->
    <div class="footer-actions">
      <el-button class="aurora-btn" :icon="Check" :loading="saving" @click="handleSave">保存设置</el-button>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { Setting, User, Document, Check } from '@element-plus/icons-vue'

const saving = ref(false)

// 基础设置（接口未实现，静态存储）
const basicForm = reactive({
  blogName: 'Aurora Blog',
  titleSuffix: ' - Aurora Blog',
  subtitle: '记录技术与生活的极光',
  footer: '© 2026 Aurora Blog · Powered by Vue 3 & Spring Boot'
})

// 资料卡
const profileForm = reactive({
  avatar: 'https://i.pravatar.cc/200?img=8',
  nickname: 'Aurora',
  signature: '在代码与文字之间，寻找那道属于自己的极光。',
  github: 'https://github.com/aurora-blog',
  email: 'aurora@admin.com'
})

// 备案信息
const filingForm = reactive({
  icp: '京ICP备2026000001号-1',
  police: '京公网安备11010802000001号'
})

// 保存设置
const handleSave = () => {
  saving.value = true
  setTimeout(() => {
    saving.value = false
    ElMessage.success('保存成功')
  }, 600)
}
</script>

<style scoped lang="scss">
.setting-page {
  animation: fadeInUp 0.4s ease both;
}

.setting-card {
  .card-header {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 20px;
    padding-bottom: 16px;
    border-bottom: 1px solid #ebeef5;

    .header-icon {
      font-size: 20px;
      color: #7c4dff;
    }

    h3 {
      margin: 0;
      font-size: 16px;
      font-weight: 600;
      color: #1a1a2e;
    }
  }
}

.setting-form {
  max-width: 900px;
}

.footer-actions {
  display: flex;
  justify-content: center;
  padding: 20px 0;
}

// 极光渐变按钮
.aurora-btn {
  border: none;
  color: #fff;
  font-weight: 600;
  padding: 12px 36px;
  border-radius: 10px;
  background: linear-gradient(135deg, #00d4ff, #7c4dff);
  box-shadow: 0 6px 16px rgba(124, 77, 255, 0.3);
  transition: all 0.3s;

  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 22px rgba(0, 212, 255, 0.4);
  }
}
</style>
