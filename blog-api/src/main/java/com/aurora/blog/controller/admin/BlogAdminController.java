package com.aurora.blog.controller.admin;

import com.aurora.blog.common.Result;
import com.aurora.blog.dto.BlogQuery;
import com.aurora.blog.dto.BlogRequest;
import com.aurora.blog.entity.Blog;
import com.aurora.blog.service.BlogService;
import com.baomidou.mybatisplus.core.metadata.IPage;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

/**
 * 后台文章管理
 *
 * @author aurora
 */
@RestController
@RequestMapping("/admin/blog")
@Api(tags = "后台-文章管理")
public class BlogAdminController {

    @Autowired
    private BlogService blogService;

    @GetMapping("/page")
    @ApiOperation("分页查询文章")
    public Result<IPage<Blog>> page(BlogQuery query) {
        return Result.success(blogService.adminPage(query));
    }

    @GetMapping("/{id}")
    @ApiOperation("根据ID查询文章")
    public Result<Blog> get(@PathVariable Long id) {
        return Result.success(blogService.getById(id));
    }

    @PostMapping
    @ApiOperation("新增文章")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<Void> create(@Valid @RequestBody BlogRequest request) {
        blogService.createBlog(request);
        return Result.success();
    }

    @PutMapping("/{id}")
    @ApiOperation("更新文章")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<Void> update(@PathVariable Long id, @Valid @RequestBody BlogRequest request) {
        request.setId(id);
        blogService.updateBlog(request);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    @ApiOperation("删除文章")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<Void> delete(@PathVariable Long id) {
        blogService.deleteBlog(id);
        return Result.success();
    }
}
