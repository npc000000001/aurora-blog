<template>
  <div class="tag-page">
    <!-- 页面标题栏 -->
    <div class="page-title-bar">
      <h2>标签管理</h2>
      <el-button class="aurora-btn" :icon="Plus" @click="openCreate">新增标签</el-button>
    </div>

    <!-- 标签表格 -->
    <div class="app-card">
      <el-table
        :data="tableData"
        v-loading="loading"
        border
        stripe
        style="width: 100%"
      >
        <el-table-column prop="id" label="ID" width="80" align="center" />
        <el-table-column prop="name" label="标签名称" min-width="180">
          <template #default="{ row }">
            <el-tag
              :type="row.color || 'purple'"
              effect="light"
              round
            >{{ row.name }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="颜色" width="160" align="center">
          <template #default="{ row }">
            <el-tag
              :type="row.color || 'purple'"
              effect="dark"
              size="small"
            >{{ row.color || 'purple' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="200" align="center" />
        <el-table-column label="操作" width="160" fixed="right" align="center">
          <template #default="{ row }">
            <el-button type="primary" link :icon="Edit" @click="openEdit(row)">编辑</el-button>
            <el-popconfirm
              :title="`确定删除标签「${row.name}」吗？`"
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

    <!-- 新增 / 编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="isEdit ? '编辑标签' : '新增标签'"
      width="460px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-width="80px"
      >
        <el-form-item label="名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入标签名称" maxlength="20" show-word-limit />
        </el-form-item>
        <el-form-item label="颜色" prop="color">
          <el-select v-model="form.color" placeholder="请选择标签颜色" style="width: 100%">
            <el-option
              v-for="c in colorOptions"
              :key="c.value"
              :label="c.label"
              :value="c.value"
            >
              <div class="color-option">
                <el-tag :type="c.value" effect="dark" size="small">{{ c.label }}</el-tag>
                <span class="color-name">{{ c.label }}</span>
              </div>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="预览">
          <el-tag
            :type="form.color || 'purple'"
            effect="light"
            round
            size="large"
          >{{ form.name || '标签预览' }}</el-tag>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button class="aurora-btn" :loading="submitLoading" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Plus, Edit, Delete } from '@element-plus/icons-vue'
import { pageTag, createTag, updateTag, deleteTag } from '@/api/tag'

const loading = ref(false)
const submitLoading = ref(false)
const tableData = ref([])
const total = ref(0)
const dialogVisible = ref(false)
const formRef = ref()
const isEdit = ref(false)

// 13 种标签颜色
const colorOptions = [
  { label: '红色', value: 'danger' },
  { label: '橙色', value: 'warning' },
  { label: '黄色', value: 'warning' },
  { label: '橄榄色', value: 'success' },
  { label: '绿色', value: 'success' },
  { label: '青色', value: 'primary' },
  { label: '蓝色', value: 'primary' },
  { label: '紫罗兰', value: 'primary' },
  { label: '紫色', value: 'info' },
  { label: '粉色', value: 'danger' },
  { label: '棕色', value: 'info' },
  { label: '灰色', value: 'info' },
  { label: '黑色', value: 'info' }
]

// 查询条件
const query = reactive({
  pageNum: 1,
  pageSize: 10
})

// 表单数据
const form = reactive({
  id: null,
  name: '',
  color: 'purple'
})

const rules = {
  name: [{ required: true, message: '请输入标签名称', trigger: 'blur' }],
  color: [{ required: true, message: '请选择标签颜色', trigger: 'change' }]
}

// 拉取标签列表，接口失败时降级为空表格
const fetchList = async () => {
  loading.value = true
  try {
    const res = await pageTag(query)
    tableData.value = res.data.records || []
    total.value = res.data.total || 0
  } catch (e) {
    tableData.value = []
    total.value = 0
  } finally {
    loading.value = false
  }
}

// 重置表单
const resetForm = () => {
  form.id = null
  form.name = ''
  form.color = 'purple'
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
  form.name = row.name
  form.color = row.color || 'purple'
  dialogVisible.value = true
}

// 提交表单
const handleSubmit = async () => {
  await formRef.value.validate()
  submitLoading.value = true
  try {
    if (isEdit.value) {
      await updateTag(form.id, {
        name: form.name,
        color: form.color
      })
      ElMessage.success('更新成功')
    } else {
      await createTag({
        name: form.name,
        color: form.color
      })
      ElMessage.success('新增成功')
    }
    dialogVisible.value = false
    fetchList()
  } finally {
    submitLoading.value = false
  }
}

// 删除
const handleDelete = async (row) => {
  try {
    await deleteTag(row.id)
    ElMessage.success('删除成功')
    fetchList()
  } catch (e) {
    // 错误已在拦截器提示
  }
}

onMounted(() => {
  fetchList()
})
</script>

<style scoped lang="scss">
.tag-page {
  animation: fadeInUp 0.4s ease both;
}

.color-option {
  display: flex;
  align-items: center;
  gap: 10px;

  .color-name {
    color: #4a4a68;
    font-size: 14px;
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
