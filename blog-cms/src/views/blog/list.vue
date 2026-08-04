<template>
  <div class="blog-list">
    <!-- 页面标题 -->
    <div class="page-title-bar">
      <h2>文章管理</h2>
    </div>

    <!-- 搜索栏 -->
    <div class="app-card">
      <div class="filter-bar">
        <el-input
          v-model="query.title"
          placeholder="请输入文章标题"
          clearable
          style="width: 240px"
          @keyup.enter="handleSearch"
        />
        <el-button class="aurora-btn" :icon="Search" @click="handleSearch">搜索</el-button>
        <el-button :icon="Refresh" @click="resetSearch">重置</el-button>
        <el-button class="aurora-btn" :icon="EditPen" @click="goCreate">发布文章</el-button>
      </div>

      <!-- 文章表格 -->
      <el-table
        :data="tableData"
        v-loading="loading"
        border
        stripe
        style="width: 100%"
      >
        <el-table-column prop="id" label="ID" width="70" align="center" />
        <el-table-column prop="title" label="标题" show-overflow-tooltip min-width="200" />
        <el-table-column label="分类" width="110" align="center">
          <template #default="{ row }">
            {{ getCategoryName(row.categoryId) }}
          </template>
        </el-table-column>
        <el-table-column label="置顶" width="80" align="center">
          <template #default="{ row }">
            <el-tag v-if="row.isTop" type="danger" effect="light" round>置顶</el-tag>
            <span v-else class="muted">—</span>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="90" align="center">
          <template #default="{ row }">
            <el-tag v-if="row.isPublished" type="success" effect="light" round>已发布</el-tag>
            <el-tag v-else type="warning" effect="light" round>草稿</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="views" label="浏览量" width="90" align="center" />
        <el-table-column prop="createTime" label="创建时间" width="170" align="center" />
        <el-table-column label="操作" width="170" fixed="right" align="center">
          <template #default="{ row }">
            <el-button type="primary" link :icon="Edit" @click="goEdit(row.id)">编辑</el-button>
            <el-popconfirm
              :title="`确定删除文章「${row.title}」吗？`"
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

      <!-- 分页 -->
      <el-pagination
        class="pagination"
        background
        v-model:current-page="query.pageNum"
        v-model:page-size="query.pageSize"
        :total="total"
        :page-sizes="[10, 20, 50]"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="fetchList"
        @current-change="fetchList"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Search, Refresh, EditPen, Edit, Delete } from '@element-plus/icons-vue'
import { pageBlog, deleteBlog } from '@/api/blog'
import { getAllCategories } from '@/api/category'

const router = useRouter()
const loading = ref(false)
const tableData = ref([])
const total = ref(0)
const categories = ref([])

// 查询条件
const query = reactive({
  pageNum: 1,
  pageSize: 10,
  title: ''
})

// 拉取文章列表
const fetchList = async () => {
  loading.value = true
  try {
    const res = await pageBlog(query)
    tableData.value = res.data.records || []
    total.value = res.data.total || 0
  } finally {
    loading.value = false
  }
}

// 拉取分类列表（用于展示分类名）
const fetchCategories = async () => {
  try {
    const res = await getAllCategories()
    categories.value = res.data || []
  } catch (e) {
    categories.value = []
  }
}

// 根据分类 ID 取分类名
const getCategoryName = (id) => {
  if (!id) return '-'
  const c = categories.value.find((item) => item.id === id)
  return c ? c.name : id
}

const handleSearch = () => {
  query.pageNum = 1
  fetchList()
}

const resetSearch = () => {
  query.title = ''
  query.pageNum = 1
  fetchList()
}

// 发布文章 -> 写文章页
const goCreate = () => router.push('/blog/write')

// 编辑 -> 编辑页
const goEdit = (id) => router.push(`/blog/edit/${id}`)

// 删除确认后调用接口
const handleDelete = async (row) => {
  await deleteBlog(row.id)
  ElMessage.success('删除成功')
  fetchList()
}

onMounted(() => {
  fetchCategories()
  fetchList()
})
</script>

<style scoped lang="scss">
.muted {
  color: #c0c4cc;
}

.pagination {
  margin-top: 18px;
  justify-content: flex-end;
}

// 极光渐变按钮
.aurora-btn {
  border: none;
  color: #fff;
  border-radius: 10px;
  background: linear-gradient(135deg, #00d4ff, #7c4dff);
  box-shadow: 0 4px 12px rgba(124, 77, 255, 0.25);
  transition: all 0.3s;

  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 18px rgba(0, 212, 255, 0.4);
  }
}
</style>
