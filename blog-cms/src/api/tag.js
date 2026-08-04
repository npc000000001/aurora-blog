import request from '@/utils/request'

// 标签分页查询
export function pageTag(params) {
  return request({ url: '/tag/page', method: 'get', params })
}

// 新增标签
export function createTag(data) {
  return request({ url: '/tag', method: 'post', data })
}

// 更新标签
export function updateTag(id, data) {
  return request({ url: `/tag/${id}`, method: 'put', data })
}

// 删除标签
export function deleteTag(id) {
  return request({ url: `/tag/${id}`, method: 'delete' })
}

// 获取全部标签（下拉选项用）
export function getAllTags() {
  return request({ url: '/tag/all', method: 'get' })
}
