<template>
  <div class="friend-page">
    <!-- 页面标题栏 -->
    <div class="page-title-bar">
      <h2>友链管理</h2>
      <el-button class="aurora-btn" :icon="Plus" @click="openCreate">新增友链</el-button>
    </div>

    <!-- 友链表格 -->
    <div class="app-card">
      <el-table
        :data="tableData"
        v-loading="loading"
        border
        stripe
        style="width: 100%"
      >
        <el-table-column prop="id" label="ID" width="70" align="center" />
        <el-table-column label="头像" width="80" align="center">
          <template #default="{ row }">
            <el-avatar :size="40" :src="row.avatar">{{ (row.nickname || 'F').charAt(0) }}</el-avatar>
          </template>
        </el-table-column>
        <el-table-column prop="nickname" label="昵称" width="140" />
        <el-table-column prop="description" label="描述" min-width="200" show-overflow-tooltip />
        <el-table-column label="网站 URL" min-width="220">
          <template #default="{ row }">
            <el-link
              v-if="row.website"
              type="primary"
              :href="row.website"
              target="_blank"
              :underline="false"
            >{{ row.website }}</el-link>
            <span v-else class="muted">—</span>
          </template>
        </el-table-column>
        <el-table-column label="公开" width="90" align="center">
          <template #default="{ row }">
            <el-switch
              v-model="row.isPublished"
              :active-value="1"
              :inactive-value="0"
              @change="handleTogglePublish(row)"
            />
          </template>
        </el-table-column>
        <el-table-column prop="viewCount" label="浏览次数" width="100" align="center" />
        <el-table-column prop="createTime" label="创建时间" width="170" align="center" />
        <el-table-column label="操作" width="160" fixed="right" align="center">
          <template #default="{ row }">
            <el-button type="primary" link :icon="Edit" @click="openEdit(row)">编辑</el-button>
            <el-popconfirm
              :title="`确定删除友链「${row.nickname}」吗？`"
              confirm-button-text="删除"
              cancel-button-text="取消"
              @confirm="handleDelete(row)"
            >
              <template #reference>
                <el-button type="danger" link :icon="Delete">删除</el-button>
              </template>
            </el-popconfirm>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 友链页面说明卡片 -->
    <div class="app-card desc-card">
      <div class="card-header">
        <el-icon class="header-icon"><Document /></el-icon>
        <h3>友链页面说明</h3>
      </div>
      <el-input
        v-model="pageDescription"
        type="textarea"
        :rows="4"
        placeholder="请输入友链页面描述（展示在友链页顶部）"
      />
      <div class="desc-actions">
        <el-button class="aurora-btn" :icon="Check" @click="handleSaveDesc">保存说明</el-button>
      </div>
    </div>

    <!-- 新增 / 编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="isEdit ? '编辑友链' : '新增友链'"
      width="520px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-width="90px"
      >
        <el-form-item label="昵称" prop="nickname">
          <el-input v-model="form.nickname" placeholder="请输入友链站点昵称" />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input
            v-model="form.description"
            type="textarea"
            :rows="2"
            placeholder="请输入站点描述"
          />
        </el-form-item>
        <el-form-item label="网站 URL" prop="website">
          <el-input v-model="form.website" placeholder="https://example.com" />
        </el-form-item>
        <el-form-item label="头像 URL" prop="avatar">
          <el-input v-model="form.avatar" placeholder="请输入头像图片地址" />
        </el-form-item>
        <el-form-item label="公开状态">
          <el-switch
            v-model="form.isPublished"
            :active-value="1"
            :inactive-value="0"
            active-text="公开"
            inactive-text="隐藏"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button class="aurora-btn" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Plus, Edit, Delete, Document, Check } from '@element-plus/icons-vue'

const loading = ref(false)
const dialogVisible = ref(false)
const formRef = ref()
const isEdit = ref(false)

// mock 友链数据（接口未实现时使用）
const mockFriends = [
  {
    id: 1,
    nickname: '拾光博客',
    description: '记录前端学习与生活随笔，分享技术心得。',
    website: 'https://blog.shiguang.dev',
    avatar: 'https://api.dicebear.com/7.x/identicon/svg?seed=shiguang',
    isPublished: 1,
    viewCount: 328,
    createTime: '2026-05-12 10:23:45'
  },
  {
    id: 2,
    nickname: '码农夜话',
    description: '后端工程师的技术博客，专注 Java 与分布式系统。',
    website: 'https://coder.night.io',
    avatar: 'https://api.dicebear.com/7.x/identicon/svg?seed=coder',
    isPublished: 1,
    viewCount: 215,
    createTime: '2026-05-20 16:08:12'
  },
  {
    id: 3,
    nickname: '云边的小店',
    description: '一个全栈开发者的成长记录，包含 DevOps 实践。',
    website: 'https://cloudedge.dev',
    avatar: 'https://api.dicebear.com/7.x/identicon/svg?seed=cloud',
    isPublished: 1,
    viewCount: 187,
    createTime: '2026-06-03 09:42:30'
  },
  {
    id: 4,
    nickname: '星河笔记',
    description: '设计转前端的奇思妙想，分享 UI/UX 实践。',
    website: 'https://galaxy.notes.cn',
    avatar: 'https://api.dicebear.com/7.x/identicon/svg?seed=galaxy',
    isPublished: 0,
    viewCount: 96,
    createTime: '2026-06-18 21:15:09'
  },
  {
    id: 5,
    nickname: '极客实验室',
    description: '探索开源项目与前沿技术的极客空间。',
    website: 'https://geeklab.tech',
    avatar: 'https://api.dicebear.com/7.x/identicon/svg?seed=geek',
    isPublished: 1,
    viewCount: 412,
    createTime: '2026-07-02 14:55:21'
  }
]

const tableData = ref([])

// 友链页面说明
const pageDescription = ref('这里收录了一群热爱技术与生活的朋友，欢迎在评论区申请友链，让我们一起在互联网的星海中相互照亮。')

// 表单数据
const form = reactive({
  id: null,
  nickname: '',
  description: '',
  website: '',
  avatar: '',
  isPublished: 1
})

const rules = {
  nickname: [{ required: true, message: '请输入昵称', trigger: 'blur' }],
  website: [
    { required: true, message: '请输入网站 URL', trigger: 'blur' },
    { type: 'url', message: '请输入合法的 URL', trigger: 'blur' }
  ]
}

// 拉取友链列表（接口未实现时使用 mock 数据）
const fetchList = async () => {
  loading.value = true
  try {
    tableData.value = mockFriends
  } catch (e) {
    tableData.value = []
  } finally {
    loading.value = false
  }
}

// 重置表单
const resetForm = () => {
  form.id = null
  form.nickname = ''
  form.description = ''
  form.website = ''
  form.avatar = ''
  form.isPublished = 1
}

// 打开新增
const openCreate = () => {
  isEdit.value = false
  resetForm()
  dialogVisible.value = true
}

// 打开编辑
const openEdit = (row) => {
  isEdit.value = true
  form.id = row.id
  form.nickname = row.nickname
  form.description = row.description || ''
  form.website = row.website || ''
  form.avatar = row.avatar || ''
  form.isPublished = row.isPublished
  dialogVisible.value = true
}

// 提交表单
const handleSubmit = async () => {
  await formRef.value.validate()
  if (isEdit.value) {
    const target = tableData.value.find((item) => item.id === form.id)
    if (target) {
      Object.assign(target, {
        nickname: form.nickname,
        description: form.description,
        website: form.website,
        avatar: form.avatar,
        isPublished: form.isPublished
      })
    }
    ElMessage.success('更新成功')
  } else {
    const newId = tableData.value.length
      ? Math.max(...tableData.value.map((i) => i.id)) + 1
      : 1
    tableData.value.push({
      id: newId,
      nickname: form.nickname,
      description: form.description,
      website: form.website,
      avatar: form.avatar,
      isPublished: form.isPublished,
      viewCount: 0,
      createTime: new Date().toLocaleString('zh-CN', { hour12: false }).replace(/\//g, '-')
    })
    ElMessage.success('新增成功')
  }
  dialogVisible.value = false
}

// 切换公开状态
const handleTogglePublish = (row) => {
  ElMessage.success(row.isPublished ? '已公开' : '已隐藏')
}

// 删除
const handleDelete = (row) => {
  const idx = tableData.value.findIndex((item) => item.id === row.id)
  if (idx > -1) {
    tableData.value.splice(idx, 1)
    ElMessage.success('删除成功')
  }
}

// 保存页面说明
const handleSaveDesc = () => {
  ElMessage.success('保存成功')
}

onMounted(() => {
  fetchList()
})
</script>

<style scoped lang="scss">
.friend-page {
  animation: fadeInUp 0.4s ease both;
}

.muted {
  color: #c0c4cc;
}

.desc-card {
  .card-header {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 16px;
    padding-bottom: 12px;
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

  .desc-actions {
    margin-top: 14px;
    text-align: right;
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
