package com.aurora.blog.service.impl;

import com.aurora.blog.dto.CategoryQuery;
import com.aurora.blog.dto.CategoryRequest;
import com.aurora.blog.entity.Category;
import com.aurora.blog.mapper.CategoryMapper;
import com.aurora.blog.service.CategoryService;
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
 * 分类 Service 实现
 *
 * @author aurora
 */
@Slf4j
@Service
public class CategoryServiceImpl extends ServiceImpl<CategoryMapper, Category> implements CategoryService {

    @Override
    public List<Category> listAll() {
        return this.list(new LambdaQueryWrapper<Category>()
                .orderByAsc(Category::getSort));
    }

    @Override
    public IPage<Category> adminPage(CategoryQuery query) {
        Page<Category> page = new Page<>(query.getPageNum(), query.getPageSize());
        LambdaQueryWrapper<Category> wrapper = new LambdaQueryWrapper<Category>()
                .like(StringUtils.hasText(query.getName()), Category::getName, query.getName())
                .orderByAsc(Category::getSort);
        return this.page(page, wrapper);
    }

    @Override
    public boolean createCategory(CategoryRequest request) {
        Category category = new Category();
        BeanUtils.copyProperties(request, category);
        return this.save(category);
    }

    @Override
    public boolean updateCategory(CategoryRequest request) {
        if (request.getId() == null) {
            return false;
        }
        Category category = new Category();
        BeanUtils.copyProperties(request, category);
        return this.updateById(category);
    }
}
