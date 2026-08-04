<template>
  <div class="operation-log-page">
    <!-- 页面标题栏 -->
    <div class="page-title-bar">
      <h2>操作日志</h2>
    </div>

    <!-- 搜索栏 -->
    <div class="app-card">
      <div class="filter-bar">
        <el-input
          v-model="query.operator"
          placeholder="请输入操作者"
          clearable
          style="width: 200px"
          @keyup.enter="handleSearch"
        />
        <el-date-picker
          v-model="query.dateRange"
          type="daterange"
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          value-format="YYYY-MM-DD"
          style="width: 260px"
        />
        <el-button class="aurora-btn" :icon="Search" @click="handleSearch">搜索</el-button>
        <el-button :icon="Refresh" @click="resetSearch">重置</el-button>
      </div>

      <!-- 操作日志表格 -->
      <el-table
        :data="pagedData"
        v-loading="loading"
        border
        stripe
        style="width: 100%"
      >
        <el-table-column prop="id" label="ID" width="70" align="center" />
        <el-table-column prop="operator" label="操作者" width="120" />
        <el-table-column prop="uri" label="请求接口" min-width="220" show-overflow-tooltip />
        <el-table-column label="请求方式" width="100" align="center">
          <template #default="{ row }">
            <el-tag :type="methodTagType(row.method)" effect="light" size="small">{{ row.method }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="description" label="描述" min-width="200" show-overflow-tooltip />
        <el-table-column prop="ip" label="IP" width="140" align="center" />
        <el-table-column label="耗时" width="100" align="center">
          <template #default="{ row }">
            <span :class="['cost', row.cost > 500 ? 'cost-slow' : 'cost-fast']">{{ row.cost }}ms</span>
          </template>
        </el-table-column>
        <el-table-column prop="operateTime" label="操作时间" width="180" align="center" />
      </el-table>

      <!-- 分页 -->
      <el-pagination
        class="pagination"
        background
        v-model:current-page="query.pageNum"
        v-model:page-size="query.pageSize"
        :total="filteredData.length"
        :page-sizes="[10, 20, 50]"
        layout="total, sizes, prev, pager, next, jumper"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { Search, Refresh } from '@element-plus/icons-vue'

const loading = ref(false)

// 查询条件
const query = reactive({
  operator: '',
  dateRange: [],
  pageNum: 1,
  pageSize: 10
})

// mock 操作日志数据
const mockLogs = ref([
  {
    id: 1,
    operator: 'admin',
    uri: '/admin/login',
    method: 'POST',
    description: '管理员登录',
    ip: '192.168.1.108',
    cost: 86,
    operateTime: '2026-08-05 08:32:14'
  },
  {
    id: 2,
    operator: 'admin',
    uri: '/admin/blog',
    method: 'POST',
    description: '发布文章《Vue3 响应式原理深度剖析》',
    ip: '192.168.1.108',
    cost: 245,
    operateTime: '2026-08-05 09:15:42'
  },
  {
    id: 3,
    operator: 'admin',
    uri: '/admin/category',
    method: 'POST',
    description: '新增分类「前端框架」',
    ip: '192.168.1.108',
    cost: 78,
    operateTime: '2026-08-05 09:42:08'
  },
  {
    id: 4,
    operator: 'admin',
    uri: '/admin/blog/12',
    method: 'PUT',
    description: '更新文章《TypeScript 进阶类型实战》',
    ip: '192.168.1.108',
    cost: 132,
    operateTime: '2026-08-05 10:23:51'
  },
  {
    id: 5,
    operator: 'admin',
    uri: '/admin/comment/35',
    method: 'DELETE',
    description: '删除评论 ID=35',
    ip: '192.168.1.108',
    cost: 56,
    operateTime: '2026-08-05 11:08:33'
  },
  {
    id: 6,
    operator: 'editor',
    uri: '/admin/blog/page',
    method: 'GET',
    description: '查询文章列表',
    ip: '192.168.1.221',
    cost: 92,
    operateTime: '2026-08-05 11:45:19'
  },
  {
    id: 7,
    operator: 'admin',
    uri: '/admin/tag',
    method: 'POST',
    description: '新增标签「Vite」',
    ip: '192.168.1.108',
    cost: 64,
    operateTime: '2026-08-05 13:22:07'
  },
  {
    id: 8,
    operator: 'editor',
    uri: '/admin/blog/18',
    method: 'PUT',
    description: '更新文章《ECharts 数据可视化实践》',
    ip: '192.168.1.221',
    cost: 580,
    operateTime: '2026-08-05 14:10:45'
  },
  {
    id: 9,
    operator: 'admin',
    uri: '/admin/category/3',
    method: 'DELETE',
    description: '删除分类 ID=3',
    ip: '192.168.1.108',
    cost: 73,
    operateTime: '2026-08-05 14:58:21'
  },
  {
    id: 10,
    operator: 'admin',
    uri: '/admin/logout',
    method: 'POST',
    description: '管理员退出登录',
    ip: '192.168.1.108',
    cost: 38,
    operateTime: '2026-08-05 15:30:02'
  }
])

// 过滤后的数据
const filteredData = computed(() => {
  return mockLogs.value.filter((item) => {
    // 操作者过滤
    if (query.operator && !item.operator.toLowerCase().includes(query.operator.trim().toLowerCase())) {
      return false
    }
    // 时间范围过滤
    if (query.dateRange && query.dateRange.length === 2) {
      const [start, end] = query.dateRange
      const opDate = item.operateTime.substring(0, 10)
      if (opDate < start || opDate > end) return false
    }
    return true
  })
})

// 当前页数据
const pagedData = computed(() => {
  const start = (query.pageNum - 1) * query.pageSize
  return filteredData.value.slice(start, start + query.pageSize)
})

// 请求方式对应的标签类型
const methodTagType = (method) => {
  const map = {
    GET: 'success',
    POST: 'primary',
    PUT: 'warning',
    DELETE: 'danger'
  }
  return map[method] || 'info'
}

const handleSearch = () => {
  query.pageNum = 1
}

const resetSearch = () => {
  query.operator = ''
  query.dateRange = []
  query.pageNum = 1
}

onMounted(() => {
  loading.value = true
  setTimeout(() => {
    loading.value = false
  }, 300)
})
</script>

<style scoped lang="scss">
.operation-log-page {
  animation: fadeInUp 0.4s ease both;
}

.cost {
  font-weight: 600;

  &.cost-fast {
    color: #43e97b;
  }

  &.cost-slow {
    color: #fa709a;
  }
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
