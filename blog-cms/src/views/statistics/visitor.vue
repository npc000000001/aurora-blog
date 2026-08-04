<template>
  <div class="visitor-page">
    <!-- 页面标题栏 -->
    <div class="page-title-bar">
      <h2>访客统计</h2>
    </div>

    <!-- 顶部统计卡片 -->
    <div class="stat-grid">
      <div
        v-for="card in statCards"
        :key="card.title"
        class="stat-card"
      >
        <div class="stat-icon" :style="{ background: card.gradient }">
          <el-icon :size="20" color="#fff"><component :is="card.icon" /></el-icon>
        </div>
        <div class="stat-info">
          <div class="stat-value">{{ card.value }}</div>
          <div class="stat-label">{{ card.title }}</div>
        </div>
      </div>
    </div>

    <!-- 搜索栏 -->
    <div class="app-card">
      <div class="filter-bar">
        <el-input
          v-model="query.ip"
          placeholder="请输入 IP"
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

      <!-- 访客表格 -->
      <el-table
        :data="pagedData"
        v-loading="loading"
        border
        stripe
        style="width: 100%"
      >
        <el-table-column prop="id" label="ID" width="70" align="center" />
        <el-table-column label="访客标识" width="140" align="center">
          <template #default="{ row }">
            <span class="uuid-tag">{{ row.uuid }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="ip" label="IP" width="140" align="center" />
        <el-table-column prop="ipSource" label="IP 来源" min-width="160" show-overflow-tooltip />
        <el-table-column label="操作系统" width="120" align="center">
          <template #default="{ row }">
            <el-tag :type="osTagType(row.os)" effect="light" size="small">{{ row.os }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="browser" label="浏览器" width="140" align="center" />
        <el-table-column prop="firstTime" label="首次访问" width="170" align="center" />
        <el-table-column prop="lastTime" label="最后访问" width="170" align="center" />
        <el-table-column prop="pv" label="PV" width="80" align="center" />
        <el-table-column label="操作" width="100" fixed="right" align="center">
          <template #default="{ row }">
            <el-button type="primary" link :icon="View" @click="handleViewRecord(row)">查看记录</el-button>
          </template>
        </el-table-column>
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

    <!-- 访问记录对话框 -->
    <el-dialog
      v-model="recordDialogVisible"
      title="访问记录"
      width="640px"
    >
      <div class="record-info">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="访客标识">{{ currentRecord.uuid }}</el-descriptions-item>
          <el-descriptions-item label="IP">{{ currentRecord.ip }}</el-descriptions-item>
          <el-descriptions-item label="IP 来源">{{ currentRecord.ipSource }}</el-descriptions-item>
          <el-descriptions-item label="操作系统">{{ currentRecord.os }}</el-descriptions-item>
          <el-descriptions-item label="浏览器">{{ currentRecord.browser }}</el-descriptions-item>
          <el-descriptions-item label="访问 PV">{{ currentRecord.pv }}</el-descriptions-item>
          <el-descriptions-item label="首次访问">{{ currentRecord.firstTime }}</el-descriptions-item>
          <el-descriptions-item label="最后访问">{{ currentRecord.lastTime }}</el-descriptions-item>
        </el-descriptions>

        <h4 class="record-title">近期访问路径</h4>
        <el-timeline class="record-timeline">
          <el-timeline-item
            v-for="(record, idx) in visitRecords"
            :key="idx"
            :timestamp="record.time"
            placement="top"
            :color="idx === 0 ? '#7c4dff' : '#00d4ff'"
          >
            <div class="record-item">
              <el-tag size="small" :type="record.method === 'GET' ? 'success' : 'primary'" effect="light">{{ record.method }}</el-tag>
              <span class="record-path">{{ record.path }}</span>
            </div>
          </el-timeline-item>
        </el-timeline>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { Search, Refresh, View, Histogram, UserFilled } from '@element-plus/icons-vue'

const loading = ref(false)
const recordDialogVisible = ref(false)

// 顶部统计卡片
const statCards = reactive([
  { title: '今日 PV', value: '1,286', icon: View, gradient: 'linear-gradient(135deg, #00d4ff, #4facfe)' },
  { title: '今日 UV', value: '342', icon: UserFilled, gradient: 'linear-gradient(135deg, #7c4dff, #fa709a)' },
  { title: '总 PV', value: '128,640', icon: Histogram, gradient: 'linear-gradient(135deg, #43e97b, #38f9d7)' },
  { title: '总 UV', value: '36,820', icon: UserFilled, gradient: 'linear-gradient(135deg, #fa709a, #fee140)' }
])

// 查询条件
const query = reactive({
  ip: '',
  dateRange: [],
  pageNum: 1,
  pageSize: 10
})

// mock 访客数据
const mockVisitors = ref([
  {
    id: 1,
    uuid: 'a3f8c1d2',
    ip: '112.45.128.66',
    ipSource: '中国·北京·北京 联通',
    os: 'Windows',
    browser: 'Chrome 126',
    firstTime: '2026-07-21 09:12:38',
    lastTime: '2026-08-05 08:42:15',
    pv: 28
  },
  {
    id: 2,
    uuid: 'b7e29f4a',
    ip: '58.246.22.18',
    ipSource: '中国·上海·上海 电信',
    os: 'macOS',
    browser: 'Safari 17',
    firstTime: '2026-07-23 14:35:09',
    lastTime: '2026-08-05 09:18:42',
    pv: 45
  },
  {
    id: 3,
    uuid: 'c1a8d5e3',
    ip: '120.229.34.207',
    ipSource: '中国·广东·深圳 移动',
    os: 'Android',
    browser: 'Chrome 126',
    firstTime: '2026-07-25 21:08:55',
    lastTime: '2026-08-04 22:45:30',
    pv: 16
  },
  {
    id: 4,
    uuid: 'd9f3b27e',
    ip: '218.19.50.142',
    ipSource: '中国·广东·广州 电信',
    os: 'Windows',
    browser: 'Edge 126',
    firstTime: '2026-07-28 10:23:11',
    lastTime: '2026-08-05 10:32:48',
    pv: 33
  },
  {
    id: 5,
    uuid: 'e5c7a9f1',
    ip: '123.139.42.88',
    ipSource: '中国·陕西·西安 联通',
    os: 'Linux',
    browser: 'Firefox 127',
    firstTime: '2026-07-30 16:48:25',
    lastTime: '2026-08-04 19:12:09',
    pv: 21
  },
  {
    id: 6,
    uuid: 'f2b8e6c4',
    ip: '117.136.38.99',
    ipSource: '中国·四川·成都 移动',
    os: 'iOS',
    browser: 'Safari 17',
    firstTime: '2026-08-01 08:15:42',
    lastTime: '2026-08-05 07:55:30',
    pv: 12
  },
  {
    id: 7,
    uuid: 'a8d3f5b9',
    ip: '202.108.22.5',
    ipSource: '中国·北京·北京 电信',
    os: 'macOS',
    browser: 'Chrome 126',
    firstTime: '2026-08-02 11:25:18',
    lastTime: '2026-08-05 11:08:42',
    pv: 19
  },
  {
    id: 8,
    uuid: 'b4e7c2d8',
    ip: '61.183.12.177',
    ipSource: '中国·湖北·武汉 电信',
    os: 'Windows',
    browser: 'Chrome 126',
    firstTime: '2026-08-03 19:32:55',
    lastTime: '2026-08-04 23:18:11',
    pv: 8
  }
])

// 当前查看的访客记录
const currentRecord = reactive({
  uuid: '',
  ip: '',
  ipSource: '',
  os: '',
  browser: '',
  pv: 0,
  firstTime: '',
  lastTime: ''
})

// 访问路径记录（mock）
const visitRecords = ref([])

// 过滤后的数据
const filteredData = computed(() => {
  return mockVisitors.value.filter((item) => {
    // IP 过滤
    if (query.ip && !item.ip.includes(query.ip.trim())) {
      return false
    }
    // 时间范围过滤（按最后访问时间）
    if (query.dateRange && query.dateRange.length === 2) {
      const [start, end] = query.dateRange
      const visitDate = item.lastTime.substring(0, 10)
      if (visitDate < start || visitDate > end) return false
    }
    return true
  })
})

// 当前页数据
const pagedData = computed(() => {
  const start = (query.pageNum - 1) * query.pageSize
  return filteredData.value.slice(start, start + query.pageSize)
})

// 操作系统标签类型
const osTagType = (os) => {
  const map = {
    Windows: 'primary',
    macOS: 'success',
    Linux: 'warning',
    Android: 'danger',
    iOS: 'info'
  }
  return map[os] || 'info'
}

const handleSearch = () => {
  query.pageNum = 1
}

const resetSearch = () => {
  query.ip = ''
  query.dateRange = []
  query.pageNum = 1
}

// 查看访问记录
const handleViewRecord = (row) => {
  Object.assign(currentRecord, row)
  // 生成 mock 访问路径记录
  const paths = [
    { method: 'GET', path: '/', time: row.lastTime },
    { method: 'GET', path: '/blog/detail/18', time: subtractMinutes(row.lastTime, 5) },
    { method: 'GET', path: '/category/前端', time: subtractMinutes(row.lastTime, 12) },
    { method: 'GET', path: '/about', time: subtractMinutes(row.lastTime, 28) },
    { method: 'GET', path: '/blog/page/1', time: subtractMinutes(row.lastTime, 45) }
  ]
  visitRecords.value = paths
  recordDialogVisible.value = true
}

// 简单的时间减法工具（mock 用）
const subtractMinutes = (timeStr, minutes) => {
  const d = new Date(timeStr.replace(' ', 'T'))
  d.setMinutes(d.getMinutes() - minutes)
  const pad = (n) => String(n).padStart(2, '0')
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}`
}

onMounted(() => {
  loading.value = true
  setTimeout(() => {
    loading.value = false
  }, 300)
})
</script>

<style scoped lang="scss">
.visitor-page {
  animation: fadeInUp 0.4s ease both;
}

// 顶部统计卡片（更小尺寸）
.stat-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 20px;
}

.stat-card {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 18px 20px;
  background: #fff;
  border-radius: 14px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);

  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 12px 32px rgba(124, 77, 255, 0.18);
  }
}

.stat-icon {
  width: 40px;
  height: 40px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  box-shadow: 0 4px 12px rgba(124, 77, 255, 0.2);
}

.stat-info {
  flex: 1;
  min-width: 0;

  .stat-value {
    font-size: 22px;
    font-weight: 700;
    color: #1a1a2e;
    line-height: 1.2;
  }

  .stat-label {
    margin-top: 2px;
    font-size: 12px;
    color: #8c8ca1;
  }
}

.uuid-tag {
  font-family: 'Consolas', 'Monaco', monospace;
  font-size: 13px;
  color: #5e3dcc;
  background: linear-gradient(135deg, rgba(0, 212, 255, 0.08), rgba(124, 77, 255, 0.08));
  padding: 2px 8px;
  border-radius: 6px;
}

// 访问记录
.record-info {
  .record-title {
    margin: 20px 0 12px;
    font-size: 14px;
    font-weight: 600;
    color: #1a1a2e;
    padding-left: 10px;
    border-left: 3px solid;
    border-image: linear-gradient(135deg, #00d4ff, #7c4dff) 1;
  }

  .record-item {
    display: flex;
    align-items: center;
    gap: 10px;

    .record-path {
      font-family: 'Consolas', 'Monaco', monospace;
      font-size: 13px;
      color: #4a4a68;
    }
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

// 响应式
@media (max-width: 992px) {
  .stat-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}
</style>
