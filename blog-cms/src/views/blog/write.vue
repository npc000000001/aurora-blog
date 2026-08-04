<template>
  <div class="blog-write">
    <!-- 顶部标题栏 -->
    <div class="page-title-bar">
      <h2>{{ isEdit ? '编辑文章' : '写文章' }}</h2>
      <el-button :icon="ArrowLeft" @click="goBack">返回</el-button>
    </div>

    <!-- 表单卡片 -->
    <div class="app-card form-card">
      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-position="top"
        v-loading="detailLoading"
      >
        <el-form-item label="标题" prop="title">
          <el-input v-model="form.title" size="large" placeholder="请输入文章标题" />
        </el-form-item>

        <el-form-item label="摘要">
          <el-input
            v-model="form.summary"
            type="textarea"
            :rows="2"
            placeholder="一句话概括文章内容"
          />
        </el-form-item>

        <el-form-item label="分类">
          <el-select
            v-model="form.categoryId"
            placeholder="请选择分类"
            clearable
            style="width: 240px"
          >
            <el-option
              v-for="c in categories"
              :key="c.id"
              :label="c.name"
              :value="c.id"
            />
          </el-select>
        </el-form-item>

        <el-form-item label="正文" prop="content">
          <el-input
            v-model="form.content"
            type="textarea"
            :rows="15"
            placeholder="支持 Markdown 语法"
          />
        </el-form-item>

        <el-form-item label="封面 URL">
          <el-input v-model="form.cover" placeholder="文章封面图片地址（可选）" />
        </el-form-item>

        <el-form-item label="发布选项">
          <div class="switch-row">
            <div class="switch-item">
              <span class="switch-label">置顶</span>
              <el-switch v-model="form.isTop" :active-value="1" :inactive-value="0" />
            </div>
            <div class="switch-item">
              <span class="switch-label">发布状态</span>
              <el-switch v-model="form.isPublished" :active-value="1" :inactive-value="0" />
            </div>
          </div>
        </el-form-item>

        <el-form-item>
          <el-button class="aurora-btn" :loading="submitLoading" @click="handleSubmit">
            保存
          </el-button>
          <el-button @click="goBack">取消</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ArrowLeft } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { createBlog, updateBlog, getBlogDetail } from '@/api/blog'
import { getAllCategories } from '@/api/category'

const route = useRoute()
const router = useRouter()
const formRef = ref()
const detailLoading = ref(false)
const submitLoading = ref(false)

// 根据路由参数判断编辑/新建
const isEdit = computed(() => !!route.params.id)

// 分类列表
const categories = ref([])

// 表单数据
const form = reactive({
  title: '',
  summary: '',
  content: '',
  categoryId: null,
  cover: '',
  isTop: 0,
  isPublished: 1
})

const rules = {
  title: [{ required: true, message: '请输入标题', trigger: 'blur' }],
  content: [{ required: true, message: '请输入正文', trigger: 'blur' }]
}

// 获取分类列表，失败降级为静态选项
const fetchCategories = async () => {
  try {
    const res = await getAllCategories()
    categories.value = res.data || []
  } catch (e) {
    categories.value = [
      { id: 1, name: '前端' },
      { id: 2, name: '后端' },
      { id: 3, name: '随笔' },
      { id: 4, name: '工具' }
    ]
  }
}

// 编辑模式：拉取文章详情填充表单
const fetchDetail = async (id) => {
  detailLoading.value = true
  try {
    const res = await getBlogDetail(id)
    Object.assign(form, res.data)
  } finally {
    detailLoading.value = false
  }
}

// 保存：新建调用 createBlog，编辑调用 updateBlog
const handleSubmit = async () => {
  await formRef.value.validate()
  submitLoading.value = true
  try {
    if (isEdit.value) {
      await updateBlog(route.params.id, form)
    } else {
      await createBlog(form)
    }
    ElMessage.success('保存成功')
    router.push('/blog/list')
  } finally {
    submitLoading.value = false
  }
}

const goBack = () => router.push('/blog/list')

onMounted(() => {
  fetchCategories()
  if (isEdit.value) {
    fetchDetail(route.params.id)
  }
})
</script>

<style scoped lang="scss">
.form-card {
  max-width: 860px;
}

.switch-row {
  display: flex;
  gap: 40px;
}

.switch-item {
  display: flex;
  align-items: center;
  gap: 10px;

  .switch-label {
    font-size: 14px;
    color: #4a4a68;
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
