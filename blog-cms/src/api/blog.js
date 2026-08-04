import request from '@/utils/request'

// 后台文章分页查询
export function pageBlog(params) {
  return request({
    url: '/blog/page',
    method: 'get',
    params
  })
}

// 新增文章
export function createBlog(data) {
  return request({
    url: '/blog',
    method: 'post',
    data
  })
}

// 更新文章
export function updateBlog(id, data) {
  return request({
    url: `/blog/${id}`,
    method: 'put',
    data
  })
}

// 删除文章
export function deleteBlog(id) {
  return request({
    url: `/blog/${id}`,
    method: 'delete'
  })
}

// 获取文章详情（后台）
export function getBlogDetail(id) {
  return request({
    url: `/blog/${id}`,
    method: 'get'
  })
}
