<template>
  <div class="visit-log-page">
    <!-- 页面标题栏 -->
    <div class="page-title-bar">
      <h2>访问日志</h2>
    </div>

    <!-- 搜索栏 -->
    <div class="app-card">
      <div class="filter-bar">
        <el-input
          v-model="query.ip"
          placeholder="请输入访客 IP"
          clearable
          style="width: 200px"
          @keyup.enter="handleSearch"
        />
        <el-input
          v-model="query.path"
          placeholder="访问路径"
          clearable
          style="width: 220px"
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

      <!-- 访问日志表格 -->
      <el-table
        :data="pagedData"
        v-loading="loading"
        border
        stripe
        style="width: 100%"
      >
        <el-table-column prop="id" label="ID" width="70" align="center" />
        <el-table-column prop="ip" label="访客 IP" width="140" />
        <el-table-column prop="path" label="访问路径" min-width="220" show-overflow-tooltip />
        <el-table-column label="来源" width="160">
          <template #default="{ row }">
            <span v-if="row.referer" class="referer" :title="row.referer">{{ row.referer }}</span>
            <span v-else class="text-secondary">直接访问</span>
          </template>
        </el-table-column>
        <el-table-column label="设备" width="110" align="center">
          <template #default="{ row }">
            <el-tag :type="deviceTagType(row.device)" effect="light" size="small">{{ row.device }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="90" align="center">
          <template #default="{ row }">
            <el-tag :type="statusTagType(row.status)" effect="dark" size="small">{{ row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="userAgent" label="User-Agent" min-width="240" show-overflow-tooltip />
        <el-table-column prop="visitTime" label="访问时间" width="180" align="center" />
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

const query = reactive({
  ip: '',
  path: '',
  dateRange: [],
  pageNum: 1,
  pageSize: 10
})

// mock 访问日志数据
const mockLogs = ref([
  {
    id: 1,
    ip: '123.118.42.15',
    path: '/',
    referer: 'https://www.baidu.com/s?wd=aurora-blog',
    device: 'PC',
    status: 200,
    userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0',
    visitTime: '2026-08-05 08:12:34'
  },
  {
    id: 2,
    ip: '123.118.42.15',
    path: '/blog/18',
    referer: 'http://localhost:8081/',
    device: 'PC',
    status: 200,
    userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0',
    visitTime: '2026-08-05 08:13:02'
  },
  {
    id: 3,
    ip: '58.213.45.91',
    path: '/blog/12',
    referer: 'https://www.google.com/search?q=vue3+blog',
    device: 'Mobile',
    status: 200,
    userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0) Safari/604.1',
    visitTime: '2026-08-05 08:45:18'
  },
  {
    id: 4,
    ip: '114.245.32.8',
    path: '/archives',
    referer: '',
    device: 'PC',
    status: 200,
    userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) Safari/605.1.15',
    visitTime: '2026-08-05 09:22:47'
  },
  {
    id: 5,
    ip: '202.108.45.221',
    path: '/blog/999',
    referer: 'http://localhost:8081/',
    device: 'PC',
    status: 404,
    userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Edge/120.0.0.0',
    visitTime: '2026-08-05 09:58:33'
  },
  {
    id: 6,
    ip: '58.213.45.91',
    path: '/about',
    referer: 'http://localhost:8081/blog/18',
    device: 'Mobile',
    status: 200,
    userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0) Safari/604.1',
    visitTime: '2026-08-05 10:32:09'
  },
  {
    id: 7,
    ip: '36.110.50.83',
    path: '/',
    referer: 'https://www.bing.com/search?q=aurora+blog',
    device: 'PC',
    status: 200,
    userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0',
    visitTime: '2026-08-05 11:15:42'
  },
  {
    id: 8,
    ip: '123.118.42.15',
    path: '/category/前端',
    referer: 'http://localhost:8081/',
    device: 'PC',
    status: 200,
    userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0',
    visitTime: '2026-08-05 12:08:51'
  },
  {
    id: 9,
    ip: '117.89.34.156',
    path: '/blog/page',
    referer: '',
    device: 'Mobile',
    status: 200,
    userAgent: 'Mozilla/5.0 (Linux; Android 14; Pixel 8) Chrome/120.0.0.0',
    visitTime: '2026-08-05 13:42:28'
  },
  {
    id: 10,
    ip: '114.245.32.8',
    path: '/blog/18',
    referer: 'https://github.com/aurora/aurora-blog',
    device: 'PC',
    status: 200,
    userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) Safari/605.1.15',
    visitTime: '2026-08-05 14:19:06'
  },
  {
    id: 11,
    ip: '36.110.50.83',
    path: '/admin/login',
    referer: '',
    device: 'PC',
    status: 401,
    userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0',
    visitTime: '2026-08-05 14:58:21'
  },
  {
    id: 12,
    ip: '58.213.45.91',
    path: '/blog/12',
    referer: 'http://localhost:8081/',
    device: 'Mobile',
    status: 200,
    userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0) Safari/604.1',
    visitTime: '2026-08-05 15:30:44'
  }
])

// 过滤
const filteredData = computed(() => {
  return mockLogs.value.filter((item) => {
    if (query.ip && !item.ip.includes(query.ip.trim())) return false
    if (query.path && !item.path.toLowerCase().includes(query.path.trim().toLowerCase())) return false
    if (query.dateRange && query.dateRange.length === 2) {
      const [start, end] = query.dateRange
      const vDate = item.visitTime.substring(0, 10)
      if (vDate < start || vDate > end) return false
    }
    return true
  })
})

const pagedData = computed(() => {
  const start = (query.pageNum - 1) * query.pageSize
  return filteredData.value.slice(start, start + query.pageSize)
})

const deviceTagType = (device) => {
  return { PC: 'primary', Mobile: 'success', Tablet: 'warning' }[device] || 'info'
}

const statusTagType = (status) => {
  if (status >= 200 && status < 300) return 'success'
  if (status === 401) return 'warning'
  if (status === 403) return 'danger'
  if (status >= 400) return 'danger'
  return 'info'
}

const handleSearch = () => {
  query.pageNum = 1
}

const resetSearch = () => {
  query.ip = ''
  query.path = ''
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
.visit-log-page {
  animation: fadeInUp 0.4s ease both;
}

.referer {
  color: #4facfe;
  display: inline-block;
  max-width: 100%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  vertical-align: middle;
}

.text-secondary {
  color: #8c8ca1;
}

.pagination {
  margin-top: 18px;
  justify-content: flex-end;
}

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
