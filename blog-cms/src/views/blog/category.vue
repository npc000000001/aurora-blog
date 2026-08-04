<template>
  <div class="category-page">
    <!-- 页面标题栏 -->
    <div class="page-title-bar">
      <h2>分类管理</h2>
      <el-button class="aurora-btn" :icon="Plus" @click="openCreate">新增分类</el-button>
    </div>

    <!-- 分类表格 -->
    <div class="app-card">
      <el-table
        :data="tableData"
        v-loading="loading"
        border
        stripe
        style="width: 100%"
      >
        <el-table-column prop="id" label="ID" width="80" align="center" />
        <el-table-column prop="name" label="分类名称" min-width="160">
          <template #default="{ row }">
            <el-tag
              class="cat-tag"
              effect="light"
              round
            >{{ row.name }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="description" label="描述" min-width="220" show-overflow-tooltip />
        <el-table-column prop="sort" label="排序" width="100" align="center" />
        <el-table-column prop="createTime" label="创建时间" width="180" align="center" />
        <el-table-column label="操作" width="160" fixed="right" align="center">
          <template #default="{ row }">
            <el-button type="primary" link :icon="Edit" @click="openEdit(row)">编辑</el-button>
            <el-popconfirm
              :title="`确定删除分类「${row.name}」吗？`"
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
      :title="isEdit ? '编辑分类' : '新增分类'"
      width="480px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-width="80px"
      >
        <el-form-item label="名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入分类名称" maxlength="20" show-word-limit />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input
            v-model="form.description"
            type="textarea"
            :rows="3"
            placeholder="请输入分类描述"
            maxlength="100"
            show-word-limit
          />
        </el-form-item>
        <el-form-item label="排序" prop="sort">
          <el-input-number v-model="form.sort" :min="0" :max="9999" controls-position="right" />
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
import { pageCategory, createCategory, updateCategory, deleteCategory } from '@/api/category'

const loading = ref(false)
const submitLoading = ref(false)
const tableData = ref([])
const total = ref(0)
const dialogVisible = ref(false)
const formRef = ref()
const isEdit = ref(false)

// 查询条件
const query = reactive({
  pageNum: 1,
  pageSize: 10
})

// 表单数据
const form = reactive({
  id: null,
  name: '',
  description: '',
  sort: 0
})

const rules = {
  name: [{ required: true, message: '请输入分类名称', trigger: 'blur' }]
}

// 拉取分类列表，接口失败时降级为空表格
const fetchList = async () => {
  loading.value = true
  try {
    const res = await pageCategory(query)
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
  form.description = ''
  form.sort = 0
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
  form.description = row.description || ''
  form.sort = row.sort ?? 0
  dialogVisible.value = true
}

// 提交表单
const handleSubmit = async () => {
  await formRef.value.validate()
  submitLoading.value = true
  try {
    if (isEdit.value) {
      await updateCategory(form.id, {
        name: form.name,
        description: form.description,
        sort: form.sort
      })
      ElMessage.success('更新成功')
    } else {
      await createCategory({
        name: form.name,
        description: form.description,
        sort: form.sort
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
    await deleteCategory(row.id)
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
.category-page {
  animation: fadeInUp 0.4s ease both;
}

.cat-tag {
  color: #5e3dcc;
  background: linear-gradient(135deg, rgba(0, 212, 255, 0.12), rgba(124, 77, 255, 0.12));
  border: 1px solid rgba(124, 77, 255, 0.2);
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
