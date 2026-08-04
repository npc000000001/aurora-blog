<template>
  <div class="about-page">
    <!-- 页面标题栏 -->
    <div class="page-title-bar">
      <h2>关于我</h2>
    </div>

    <!-- 编辑表单 -->
    <div class="app-card form-card">
      <el-form :model="form" label-position="top">
        <el-form-item label="标题">
          <el-input
            v-model="form.title"
            placeholder="请输入页面标题"
            maxlength="50"
            show-word-limit
          />
        </el-form-item>

        <el-form-item label="正文">
          <el-input
            v-model="form.content"
            type="textarea"
            :rows="15"
            placeholder="支持 Markdown 语法，例如：## 简介、**强调**、[链接](url)"
          />
        </el-form-item>

        <el-form-item label="评论开关">
          <div class="switch-row">
            <el-switch v-model="form.commentEnabled" />
            <span class="switch-tip">开启后访问者可在关于页发表评论</span>
          </div>
        </el-form-item>

        <el-form-item>
          <el-button class="aurora-btn" :icon="Check" :loading="saving" @click="handleSave">
            保存
          </el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { Check } from '@element-plus/icons-vue'

const saving = ref(false)

// 关于我页面数据（接口未实现，静态存储）
const form = reactive({
  title: '关于我',
  content: `## 你好，我是 Aurora 👋

一名前端工程师，热爱代码也热爱文字。

- 技术栈：Vue 3 / TypeScript / Node.js / Spring Boot
- 兴趣：开源、写作、摄影、长跑
- 座右铭：在代码与文字之间，寻找那道属于自己的极光。

这里是我记录技术思考与生活点滴的小角落，欢迎留言交流，也欢迎在 [GitHub](https://github.com/aurora-blog) 上找我玩。

> 「极光之所以绚烂，是因为它在黑暗中盛开。」`,
  commentEnabled: true
})

// 保存
const handleSave = () => {
  saving.value = true
  setTimeout(() => {
    saving.value = false
    ElMessage.success('保存成功')
  }, 600)
}
</script>

<style scoped lang="scss">
.about-page {
  animation: fadeInUp 0.4s ease both;
}

.form-card {
  max-width: 860px;
}

.switch-row {
  display: flex;
  align-items: center;
  gap: 12px;

  .switch-tip {
    font-size: 13px;
    color: #8c8ca1;
  }
}

// 极光渐变按钮
.aurora-btn {
  border: none;
  color: #fff;
  font-weight: 600;
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
