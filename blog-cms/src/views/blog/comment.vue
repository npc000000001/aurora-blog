<template>
  <div class="comment-page">
    <!-- 页面标题栏 -->
    <div class="page-title-bar">
      <h2>评论管理</h2>
    </div>

    <!-- 搜索栏 -->
    <div class="app-card">
      <div class="filter-bar">
        <el-input
          v-model="query.nickname"
          placeholder="请输入昵称搜索"
          clearable
          style="width: 220px"
          @keyup.enter="handleSearch"
        />
        <el-button class="aurora-btn" :icon="Search" @click="handleSearch">搜索</el-button>
        <el-button :icon="Refresh" @click="resetSearch">重置</el-button>
      </div>

      <!-- 评论树形表格 -->
      <el-table
        :data="filteredData"
        v-loading="loading"
        row-key="id"
        :tree-props="{ children: 'replyComments' }"
        border
        stripe
        default-expand-all
        style="width: 100%"
      >
        <el-table-column prop="id" label="ID" width="80" align="center" />
        <el-table-column label="头像" width="80" align="center">
          <template #default="{ row }">
            <el-avatar :size="40" :src="row.avatar">{{ (row.nickname || 'A').charAt(0) }}</el-avatar>
          </template>
        </el-table-column>
        <el-table-column label="昵称" width="160">
          <template #default="{ row }">
            <span class="nickname">{{ row.nickname }}</span>
            <el-tag v-if="row.isAuthor" size="small" type="warning" effect="dark" round class="author-tag">我</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="email" label="邮箱" width="200" show-overflow-tooltip />
        <el-table-column prop="content" label="内容" min-width="240" show-overflow-tooltip />
        <el-table-column label="所属文章" min-width="180">
          <template #default="{ row }">
            <el-link v-if="row.articleTitle" type="primary" :underline="false">{{ row.articleTitle }}</el-link>
            <span v-else class="muted">—</span>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="时间" width="170" align="center" />
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
        <el-table-column label="操作" width="160" fixed="right" align="center">
          <template #default="{ row }">
            <el-button type="primary" link :icon="Edit" @click="openEdit(row)">编辑</el-button>
            <el-popconfirm
              :title="`确定删除该评论吗？`"
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

    <!-- 编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      title="编辑评论"
      width="520px"
      :close-on-click-modal="false"
    >
      <el-form ref="formRef" :model="form" label-width="80px">
        <el-form-item label="昵称">
          <el-input v-model="form.nickname" placeholder="请输入昵称" />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="form.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="内容">
          <el-input
            v-model="form.content"
            type="textarea"
            :rows="5"
            placeholder="请输入评论内容"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button class="aurora-btn" @click="handleSubmit">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Search, Refresh, Edit, Delete } from '@element-plus/icons-vue'

const loading = ref(false)
const dialogVisible = ref(false)
const formRef = ref()

// 查询条件
const query = reactive({
  nickname: ''
})

// 表单数据
const form = reactive({
  id: null,
  nickname: '',
  email: '',
  content: ''
})

// mock 评论数据（接口未实现时使用，含回复树结构）
const mockComments = ref([
  {
    id: 1,
    nickname: '林深时见鹿',
    avatar: 'https://i.pravatar.cc/80?img=1',
    email: 'linshen@example.com',
    content: '文章写得很棒，对 Vue3 的响应式原理讲解得很透彻，受益匪浅！',
    articleTitle: '深入理解 Vue3 响应式系统',
    createTime: '2026-07-28 14:23:08',
    isPublished: 1,
    isAuthor: 0,
    replyComments: [
      {
        id: 2,
        nickname: 'Aurora',
        avatar: 'https://i.pravatar.cc/80?img=8',
        email: 'aurora@admin.com',
        content: '感谢支持，后续会更新更多源码分析文章~',
        articleTitle: '深入理解 Vue3 响应式系统',
        createTime: '2026-07-28 15:10:42',
        isPublished: 1,
        isAuthor: 1,
        replyComments: []
      }
    ]
  },
  {
    id: 3,
    nickname: '程序员小张',
    avatar: 'https://i.pravatar.cc/80?img=3',
    email: 'xzhang.dev@example.com',
    content: '请问 Pinia 与 Vuex 在大型项目中的取舍有什么建议吗？',
    articleTitle: '前端状态管理方案对比',
    createTime: '2026-07-29 09:45:21',
    isPublished: 1,
    isAuthor: 0,
    replyComments: []
  },
  {
    id: 4,
    nickname: '海上的风',
    avatar: 'https://i.pravatar.cc/80?img=5',
    email: 'sea.wind@example.com',
    content: 'Vite 的按需引入真的提升了开发体验，热更新秒级响应。',
    articleTitle: 'Vite 6 新特性解析',
    createTime: '2026-07-30 18:02:55',
    isPublished: 1,
    isAuthor: 0,
    replyComments: [
      {
        id: 5,
        nickname: '夜航星',
        avatar: 'https://i.pravatar.cc/80?img=12',
        email: 'night.star@example.com',
        content: '同感，比 webpack 快太多了。',
        articleTitle: 'Vite 6 新特性解析',
        createTime: '2026-07-30 19:18:30',
        isPublished: 1,
        isAuthor: 0,
        replyComments: []
      }
    ]
  },
  {
    id: 6,
    nickname: '江南旧客',
    avatar: 'https://i.pravatar.cc/80?img=7',
    email: 'jiangnan@example.com',
    content: '这篇 TypeScript 教程讲得非常细致，已收藏。',
    articleTitle: 'TypeScript 进阶类型实战',
    createTime: '2026-08-01 21:34:09',
    isPublished: 1,
    isAuthor: 0,
    replyComments: []
  },
  {
    id: 7,
    nickname: '码农阿吉',
    avatar: 'https://i.pravatar.cc/80?img=15',
    email: 'aji.code@example.com',
    content: '建议加一段关于 ECharts 性能优化的内容，大数据量下还是有明显卡顿。',
    articleTitle: 'ECharts 数据可视化实践',
    createTime: '2026-08-02 10:55:18',
    isPublished: 0,
    isAuthor: 0,
    replyComments: []
  }
])

// 表格展示数据
const tableData = ref([])

// 前端过滤搜索
const filteredData = computed(() => {
  if (!query.nickname.trim()) return tableData.value
  const kw = query.nickname.trim().toLowerCase()
  // 同时匹配父评论及包含的子评论
  return tableData.value
    .map((parent) => {
      if (parent.nickname.toLowerCase().includes(kw)) return parent
      const matchedReplies = (parent.replyComments || []).filter((r) =>
        r.nickname.toLowerCase().includes(kw)
      )
      if (matchedReplies.length) {
        return { ...parent, replyComments: matchedReplies }
      }
      return null
    })
    .filter(Boolean)
})

// 拉取评论列表（接口未实现时使用 mock 数据）
const fetchList = async () => {
  loading.value = true
  try {
    // 接口未实现，直接使用 mock 数据
    tableData.value = mockComments.value
  } catch (e) {
    tableData.value = []
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  // 前端搜索，filteredData 自动响应
}

const resetSearch = () => {
  query.nickname = ''
}

// 打开编辑
const openEdit = (row) => {
  form.id = row.id
  form.nickname = row.nickname
  form.email = row.email
  form.content = row.content
  dialogVisible.value = true
}

// 提交编辑
const handleSubmit = () => {
  // 接口未实现，直接更新本地数据
  const updateNode = (list) => {
    list.forEach((item) => {
      if (item.id === form.id) {
        item.nickname = form.nickname
        item.email = form.email
        item.content = form.content
      }
      if (item.replyComments && item.replyComments.length) {
        updateNode(item.replyComments)
      }
    })
  }
  updateNode(tableData.value)
  ElMessage.success('保存成功')
  dialogVisible.value = false
}

// 切换公开状态
const handleTogglePublish = (row) => {
  ElMessage.success(row.isPublished ? '已公开' : '已隐藏')
}

// 删除
const handleDelete = (row) => {
  const removeNode = (list) => {
    const idx = list.findIndex((item) => item.id === row.id)
    if (idx > -1) {
      list.splice(idx, 1)
      return true
    }
    for (const item of list) {
      if (item.replyComments && item.replyComments.length) {
        if (removeNode(item.replyComments)) return true
      }
    }
    return false
  }
  removeNode(tableData.value)
  ElMessage.success('删除成功')
}

onMounted(() => {
  fetchList()
})
</script>

<style scoped lang="scss">
.comment-page {
  animation: fadeInUp 0.4s ease both;
}

.muted {
  color: #c0c4cc;
}

.nickname {
  font-weight: 500;
  color: #1a1a2e;
  margin-right: 6px;
}

.author-tag {
  margin-left: 4px;
}

.pagination {
  margin-top: 18px;
  justify-content: flex-end;
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
