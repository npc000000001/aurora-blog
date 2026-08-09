package com.aurora.blog.controller;

import com.aurora.blog.common.Result;
import com.aurora.blog.entity.Blog;
import com.aurora.blog.service.BlogService;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 前台文章展示
 *
 * @author aurora
 */
@RestController
@RequestMapping("/blog")
@Api(tags = "前台-文章展示")
public class BlogController {

    @Autowired
    private BlogService blogService;

    @GetMapping("/page")
    @ApiOperation("分页查询已发布文章")
    public Result<IPage<Blog>> page(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) Long categoryId) {
        return Result.success(blogService.frontPage(pageNum, pageSize, categoryId));
    }

    @GetMapping("/{id}")
    @ApiOperation("获取文章详情")
    public Result<Blog> detail(@PathVariable Long id) {
        return Result.success(blogService.getBlogDetail(id));
    }

    @GetMapping("/recommend")
    @ApiOperation("获取推荐文章")
    public Result<List<Blog>> recommend(
            @RequestParam(defaultValue = "5") Integer limit) {
        return Result.success(blogService.listRecommend(limit));
    }

    @GetMapping("/random")
    @ApiOperation("随机获取已发布文章")
    public Result<List<Blog>> random(
            @RequestParam(defaultValue = "5") Integer limit) {
        return Result.success(blogService.listRandom(limit));
    }
}
