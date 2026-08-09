import request from '@/utils/request'

// 全部分类
export function getAllCategories() {
  return request({
    url: '/category/all',
    method: 'get'
  })
}
