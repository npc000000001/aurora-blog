package com.aurora.blog.service.impl;

import com.aurora.blog.dto.BlogQuery;
import com.aurora.blog.dto.BlogRequest;
import com.aurora.blog.entity.Blog;
import com.aurora.blog.mapper.BlogMapper;
import com.aurora.blog.service.BlogService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

/**
 * 文章 Service 实现
 *
 * @author aurora
 */
@Slf4j
@Service
public class BlogServiceImpl extends ServiceImpl<BlogMapper, Blog> implements BlogService {

    @Override
    public IPage<Blog> adminPage(BlogQuery query) {
        Page<Blog> page = new Page<>(query.getPageNum(), query.getPageSize());
        LambdaQueryWrapper<Blog> wrapper = new LambdaQueryWrapper<Blog>()
                .like(StringUtils.hasText(query.getTitle()), Blog::getTitle, query.getTitle())
                .eq(query.getCategoryId() != null, Blog::getCategoryId, query.getCategoryId())
                .eq(query.getIsPublished() != null, Blog::getIsPublished, query.getIsPublished())
                .orderByDesc(Blog::getIsTop)
                .orderByDesc(Blog::getCreateTime);
        return this.page(page, wrapper);
    }

    @Override
    public boolean createBlog(BlogRequest request) {
        Blog blog = new Blog();
        BeanUtils.copyProperties(request, blog);
        if (blog.getViews() == null) {
            blog.setViews(0L);
        }
        if (blog.getIsTop() == null) {
            blog.setIsTop(0);
        }
        if (blog.getIsPublished() == null) {
            blog.setIsPublished(0);
        }
        return this.save(blog);
    }

    @Override
    public boolean updateBlog(BlogRequest request) {
        if (request.getId() == null) {
            return false;
        }
        Blog blog = new Blog();
        BeanUtils.copyProperties(request, blog);
        return this.updateById(blog);
    }

    @Override
    public boolean deleteBlog(Long id) {
        return this.removeById(id);
    }

    @Override
    public IPage<Blog> frontPage(Integer pageNum, Integer pageSize, Long categoryId) {
        Page<Blog> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<Blog> wrapper = new LambdaQueryWrapper<Blog>()
                .eq(Blog::getIsPublished, 1)
                .eq(categoryId != null, Blog::getCategoryId, categoryId)
                .orderByDesc(Blog::getIsTop)
                .orderByDesc(Blog::getCreateTime);
        return this.page(page, wrapper);
    }

    @Override
    public Blog getBlogDetail(Long id) {
        Blog blog = this.getById(id);
        if (blog != null && blog.getIsPublished() == 1) {
            // 浏览量 +1（直接 SQL 更新，避免并发覆盖）
            this.baseMapper.update(null,
                    new com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper<Blog>()
                            .eq(Blog::getId, id)
                            .setSql("views = views + 1"));
            blog.setViews(blog.getViews() + 1);
        }
        return blog;
    }

    @Override
    public List<Blog> listRecommend(int limit) {
        return this.list(new LambdaQueryWrapper<Blog>()
                .eq(Blog::getIsPublished, 1)
                .orderByDesc(Blog::getViews)
                .last("LIMIT " + limit));
    }
}
