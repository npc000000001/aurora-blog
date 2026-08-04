import request from '@/utils/request'

// 分类分页查询
export function pageCategory(params) {
  return request({ url: '/category/page', method: 'get', params })
}

// 新增分类
export function createCategory(data) {
  return request({ url: '/category', method: 'post', data })
}

// 更新分类
export function updateCategory(id, data) {
  return request({ url: `/category/${id}`, method: 'put', data })
}

// 删除分类
export function deleteCategory(id) {
  return request({ url: `/category/${id}`, method: 'delete' })
}

// 获取全部分类（下拉选项用）
export function getAllCategories() {
  return request({ url: '/category/all', method: 'get' })
}
