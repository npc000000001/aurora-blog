import request from '@/utils/request'

// 全部标签
export function getAllTags() {
  return request({
    url: '/tag/all',
    method: 'get'
  })
}
