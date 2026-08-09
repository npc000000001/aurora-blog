import request from '@/utils/request'

// 前台文章分页
export function pageBlog(params) {
  return request({
    url: '/blog/page',
    method: 'get',
    params
  })
}

// 文章详情
export function getBlogDetail(id) {
  return request({
    url: `/blog/${id}`,
    method: 'get'
  })
}

// 随机文章
export function getRandomBlog() {
  return request({
    url: '/blog/random',
    method: 'get'
  })
}
