import { createRouter, createWebHistory } from 'vue-router'

// Aurora Blog 前台路由
const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/home/Home.vue'),
    meta: { title: '首页' }
  },
  {
    path: '/blog/:id',
    name: 'BlogDetail',
    component: () => import('@/views/blog/BlogDetail.vue'),
    meta: { title: '文章详情' }
  },
  {
    path: '/archives',
    name: 'Archives',
    component: () => import('@/views/archives/Archives.vue'),
    meta: { title: '归档' }
  },
  {
    path: '/categories',
    name: 'Categories',
    component: () => import('@/views/category/Categories.vue'),
    meta: { title: '分类' }
  },
  {
    path: '/category/:name',
    name: 'Category',
    component: () => import('@/views/category/CategoryList.vue'),
    meta: { title: '分类文章' }
  },
  {
    path: '/tags',
    name: 'Tags',
    component: () => import('@/views/tag/Tags.vue'),
    meta: { title: '标签' }
  },
  {
    path: '/tag/:name',
    name: 'Tag',
    component: () => import('@/views/tag/TagList.vue'),
    meta: { title: '标签文章' }
  },
  {
    path: '/friends',
    name: 'Friends',
    component: () => import('@/views/friend/Friends.vue'),
    meta: { title: '友链' }
  },
  {
    path: '/about',
    name: 'About',
    component: () => import('@/views/about/About.vue'),
    meta: { title: '关于' }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() {
    return { top: 0 }
  }
})

router.beforeEach((to) => {
  document.title = (to.meta.title ? to.meta.title + ' - ' : '') + 'Aurora Blog'
})

export default router
