package com.aurora.blog.service;

import com.aurora.blog.dto.BlogQuery;
import com.aurora.blog.dto.BlogRequest;
import com.aurora.blog.entity.Blog;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * 文章 Service
 *
 * @author aurora
 */
public interface BlogService extends IService<Blog> {

    /**
     * 分页查询文章（后台）
     */
    IPage<Blog> adminPage(BlogQuery query);

    /**
     * 新增文章
     */
    boolean createBlog(BlogRequest request);

    /**
     * 更新文章
     */
    boolean updateBlog(BlogRequest request);

    /**
     * 逻辑删除文章
     */
    boolean deleteBlog(Long id);

    /**
     * 前台分页查询已发布文章
     */
    IPage<Blog> frontPage(Integer pageNum, Integer pageSize, Long categoryId);

    /**
     * 获取文章详情（浏览量 +1）
     */
    Blog getBlogDetail(Long id);

    /**
     * 获取推荐文章
     */
    java.util.List<Blog> listRecommend(int limit);

    /**
     * 随机获取已发布文章（用于侧边栏推荐）
     *
     * @param limit 返回条数
     * @return 随机文章列表
     */
    java.util.List<Blog> listRandom(int limit);
}
