package com.aurora.blog.service;

import com.aurora.blog.dto.CategoryQuery;
import com.aurora.blog.dto.CategoryRequest;
import com.aurora.blog.entity.Category;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;

/**
 * 分类 Service
 *
 * @author aurora
 */
public interface CategoryService extends IService<Category> {

    /**
     * 查询全部分类（按 sort 升序）
     *
     * @return 分类列表
     */
    List<Category> listAll();

    /**
     * 分页查询分类（后台，按 name 模糊查询）
     *
     * @param query 查询条件
     * @return 分页结果
     */
    IPage<Category> adminPage(CategoryQuery query);

    /**
     * 新增分类
     *
     * @param request 分类请求
     * @return 是否成功
     */
    boolean createCategory(CategoryRequest request);

    /**
     * 更新分类
     *
     * @param request 分类请求
     * @return 是否成功
     */
    boolean updateCategory(CategoryRequest request);
}
