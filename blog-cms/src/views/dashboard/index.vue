<template>
  <div class="dashboard">
    <!-- 顶部统计卡片 -->
    <div class="stat-grid">
      <div
        v-for="card in statCards"
        :key="card.title"
        class="stat-card"
      >
        <div class="stat-icon" :style="{ background: card.gradient }">
          <el-icon :size="24" color="#fff"><component :is="card.icon" /></el-icon>
        </div>
        <div class="stat-info">
          <div class="stat-value">{{ card.value }}</div>
          <div class="stat-label">{{ card.title }}</div>
        </div>
      </div>
    </div>

    <!-- 图表区 -->
    <div class="chart-grid">
      <div class="chart-card">
        <h3 class="chart-title">分类文章占比</h3>
        <div ref="pieRef" class="chart-box"></div>
      </div>
      <div class="chart-card">
        <h3 class="chart-title">近 7 天访问量</h3>
        <div ref="lineRef" class="chart-box"></div>
      </div>
    </div>

    <!-- 欢迎卡片 -->
    <div class="welcome-card">
      <div class="welcome-left">
        <div class="welcome-avatar">{{ (userStore.nickname || userStore.username || 'A').charAt(0) }}</div>
        <div class="welcome-text">
          <h2>欢迎回来，{{ userStore.nickname || userStore.username || '管理员' }} 👋</h2>
          <p>今天也是充满创造力的一天，开始记录你的灵感吧。</p>
        </div>
      </div>
      <div class="welcome-stack">
        <span class="stack-item">Vue 3</span>
        <span class="stack-item">Vite</span>
        <span class="stack-item">Element Plus</span>
        <span class="stack-item">ECharts</span>
        <span class="stack-item">Pinia</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, onUnmounted, nextTick } from 'vue'
import * as echarts from 'echarts'
import { Document, View, Files, ChatDotRound } from '@element-plus/icons-vue'
import { pageBlog } from '@/api/blog'
import { useUserStore } from '@/stores/user'

const userStore = useUserStore()

// 统计卡片（数字动态填充文章总数）
const statCards = reactive([
  { title: '文章总数', value: '-', icon: Document, gradient: 'linear-gradient(135deg, #00d4ff, #4facfe)' },
  { title: '总浏览量', value: '12,860', icon: View, gradient: 'linear-gradient(135deg, #7c4dff, #fa709a)' },
  { title: '分类数', value: '8', icon: Files, gradient: 'linear-gradient(135deg, #43e97b, #38f9d7)' },
  { title: '评论数', value: '236', icon: ChatDotRound, gradient: 'linear-gradient(135deg, #fa709a, #fee140)' }
])

// 图表 DOM 引用
const pieRef = ref()
const lineRef = ref()
let pieChart = null
let lineChart = null

// 初始化饼图（南丁格尔玫瑰图）
const initPieChart = () => {
  pieChart = echarts.init(pieRef.value)
  pieChart.setOption({
    tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
    legend: { bottom: 0, icon: 'circle', textStyle: { color: '#8c8ca1' } },
    color: ['#00d4ff', '#7c4dff', '#43e97b', '#fa709a', '#fee140'],
    series: [
      {
        name: '分类占比',
        type: 'pie',
        radius: ['25%', '70%'],
        center: ['50%', '45%'],
        roseType: 'area',
        itemStyle: { borderRadius: 8, borderColor: '#fff', borderWidth: 2 },
        label: { color: '#4a4a68' },
        data: [
          { value: 18, name: '前端' },
          { value: 12, name: '后端' },
          { value: 9, name: '随笔' },
          { value: 6, name: '工具' },
          { value: 4, name: '日记' }
        ]
      }
    ]
  })
}

// 初始化折线图（PV / UV）
const initLineChart = () => {
  lineChart = echarts.init(lineRef.value)
  const days = ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
  lineChart.setOption({
    tooltip: { trigger: 'axis' },
    legend: { data: ['PV', 'UV'], bottom: 0, icon: 'circle', textStyle: { color: '#8c8ca1' } },
    grid: { left: 40, right: 20, top: 20, bottom: 40 },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: days,
      axisLine: { lineStyle: { color: '#ebeef5' } },
      axisLabel: { color: '#8c8ca1' }
    },
    yAxis: {
      type: 'value',
      axisLine: { show: false },
      axisTick: { show: false },
      splitLine: { lineStyle: { color: '#f0f2f8' } },
      axisLabel: { color: '#8c8ca1' }
    },
    series: [
      {
        name: 'PV',
        type: 'line',
        smooth: true,
        symbol: 'circle',
        symbolSize: 6,
        data: [820, 932, 901, 1290, 1330, 1620, 1450],
        lineStyle: { width: 3, color: '#FF005A' },
        itemStyle: { color: '#FF005A' },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(255,0,90,0.35)' },
            { offset: 1, color: 'rgba(255,0,90,0.02)' }
          ])
        }
      },
      {
        name: 'UV',
        type: 'line',
        smooth: true,
        symbol: 'circle',
        symbolSize: 6,
        data: [320, 432, 401, 590, 530, 820, 650],
        lineStyle: { width: 3, color: '#3888fa' },
        itemStyle: { color: '#3888fa' },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(56,136,250,0.35)' },
            { offset: 1, color: 'rgba(56,136,250,0.02)' }
          ])
        }
      }
    ]
  })
}

// 窗口 resize 时重绘图表
const handleResize = () => {
  pieChart && pieChart.resize()
  lineChart && lineChart.resize()
}

onMounted(async () => {
  // 拉取用户信息（若未拉取）
  if (!userStore.username) {
    userStore.fetchInfo().catch(() => {})
  }
  // 通过文章分页接口获取文章总数
  try {
    const res = await pageBlog({ pageNum: 1, pageSize: 1 })
    statCards[0].value = res.data.total ?? '-'
  } catch (e) {
    statCards[0].value = '-'
  }
  // 初始化图表
  await nextTick()
  initPieChart()
  initLineChart()
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  pieChart && pieChart.dispose()
  lineChart && lineChart.dispose()
})
</script>

<style scoped lang="scss">
.dashboard {
  animation: fadeInUp 0.4s ease both;
}

// 统计卡片
.stat-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  margin-bottom: 20px;
}

.stat-card {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 24px;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);

  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 12px 32px rgba(124, 77, 255, 0.18);
  }
}

.stat-icon {
  width: 48px;
  height: 48px;
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  box-shadow: 0 6px 16px rgba(124, 77, 255, 0.2);
}

.stat-info {
  flex: 1;
  min-width: 0;

  .stat-value {
    font-size: 26px;
    font-weight: 700;
    color: #1a1a2e;
    line-height: 1.2;
  }

  .stat-label {
    margin-top: 4px;
    font-size: 13px;
    color: #8c8ca1;
  }
}

// 图表区
.chart-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
  margin-bottom: 20px;
}

.chart-card {
  background: #fff;
  border-radius: 16px;
  padding: 20px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
  transition: all 0.3s;

  &:hover {
    box-shadow: 0 12px 32px rgba(0, 212, 255, 0.14);
  }

  .chart-title {
    margin: 0 0 8px;
    font-size: 16px;
    font-weight: 600;
    color: #1a1a2e;
    padding-left: 10px;
    border-left: 3px solid;
    border-image: linear-gradient(135deg, #00d4ff, #7c4dff) 1;
  }

  .chart-box {
    height: 320px;
  }
}

// 欢迎卡片
.welcome-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  padding: 24px 28px;
  background: linear-gradient(135deg, rgba(0, 212, 255, 0.08) 0%, rgba(124, 77, 255, 0.08) 100%);
  border-radius: 16px;
  border: 1px solid rgba(124, 77, 255, 0.12);
  flex-wrap: wrap;
}

.welcome-left {
  display: flex;
  align-items: center;
  gap: 16px;

  .welcome-avatar {
    width: 52px;
    height: 52px;
    border-radius: 50%;
    background: linear-gradient(135deg, #00d4ff, #7c4dff);
    color: #fff;
    font-size: 22px;
    font-weight: 700;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 6px 16px rgba(124, 77, 255, 0.3);
  }

  .welcome-text {
    h2 {
      margin: 0 0 4px;
      font-size: 18px;
      font-weight: 600;
      color: #1a1a2e;
    }
    p {
      margin: 0;
      font-size: 13px;
      color: #8c8ca1;
    }
  }
}

.welcome-stack {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;

  .stack-item {
    padding: 4px 12px;
    font-size: 12px;
    color: #5e3dcc;
    background: #fff;
    border-radius: 20px;
    border: 1px solid rgba(124, 77, 255, 0.2);
  }
}

// 响应式
@media (max-width: 992px) {
  .stat-grid { grid-template-columns: repeat(2, 1fr); }
  .chart-grid { grid-template-columns: 1fr; }
}
</style>
