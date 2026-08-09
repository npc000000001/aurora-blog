import request from '@/utils/request'

// 全部友链
export function getAllFriends() {
  return request({
    url: '/friend/all',
    method: 'get'
  })
}
