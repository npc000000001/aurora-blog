import { createRouter, createWebHistory } from 'vue-router'
import Layout from '@/layout/index.vue'

// Aurora Blog CMS 路由
const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/login/index.vue'),
    meta: { title: '登录' }
  },
  {
    path: '/',
    component: Layout,
    redirect: '/dashboard',
    children: [
      { path: 'dashboard', name: 'Dashboard', component: () => import('@/views/dashboard/index.vue'), meta: { title: '仪表盘' } },

      // 博客管理
      { path: 'blog/write', name: 'BlogWrite', component: () => import('@/views/blog/write.vue'), meta: { title: '写文章' } },
      { path: 'blog/edit/:id', name: 'BlogEdit', component: () => import('@/views/blog/write.vue'), meta: { title: '编辑文章' } },
      { path: 'blog/list', name: 'BlogList', component: () => import('@/views/blog/list.vue'), meta: { title: '文章管理' } },
      { path: 'blog/category', name: 'BlogCategory', component: () => import('@/views/blog/category.vue'), meta: { title: '分类管理' } },
      { path: 'blog/tag', name: 'BlogTag', component: () => import('@/views/blog/tag.vue'), meta: { title: '标签管理' } },
      { path: 'blog/comment', name: 'BlogComment', component: () => import('@/views/blog/comment.vue'), meta: { title: '评论管理' } },

      // 页面管理
      { path: 'page/setting', name: 'PageSetting', component: () => import('@/views/page/setting.vue'), meta: { title: '站点设置' } },
      { path: 'page/friend', name: 'PageFriend', component: () => import('@/views/page/friend.vue'), meta: { title: '友链管理' } },
      { path: 'page/about', name: 'PageAbout', component: () => import('@/views/page/about.vue'), meta: { title: '关于我' } },

      // 日志管理
      { path: 'log/operation', name: 'LogOperation', component: () => import('@/views/log/operation.vue'), meta: { title: '操作日志' } },
      { path: 'log/visit', name: 'LogVisit', component: () => import('@/views/log/visit.vue'), meta: { title: '访问日志' } },

      // 数据统计
      { path: 'statistics/visitor', name: 'StatVisitor', component: () => import('@/views/statistics/visitor.vue'), meta: { title: '访客统计' } }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 登录守卫
router.beforeEach((to, from, next) => {
  document.title = (to.meta.title ? to.meta.title + ' - ' : '') + 'Aurora Admin'
  const token = localStorage.getItem('aurora_blog_token')
  if (to.path === '/login') {
    next()
  } else if (!token) {
    next('/login')
  } else {
    next()
  }
})

export default router
