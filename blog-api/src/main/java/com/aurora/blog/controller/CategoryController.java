package com.aurora.blog.controller;

import com.aurora.blog.common.Result;
import com.aurora.blog.entity.Category;
import com.aurora.blog.service.CategoryService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 前台-分类展示
 *
 * @author aurora
 */
@RestController
@RequestMapping("/category")
@Api(tags = "前台-分类展示")
public class CategoryController {

    @Autowired
    private CategoryService categoryService;

    @GetMapping("/all")
    @ApiOperation("获取全部分类列表")
    public Result<List<Category>> all() {
        return Result.success(categoryService.listAll());
    }
}
