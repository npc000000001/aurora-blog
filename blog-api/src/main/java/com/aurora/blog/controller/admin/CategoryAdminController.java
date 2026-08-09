package com.aurora.blog.controller.admin;

import com.aurora.blog.common.Result;
import com.aurora.blog.dto.CategoryQuery;
import com.aurora.blog.dto.CategoryRequest;
import com.aurora.blog.entity.Category;
import com.aurora.blog.service.CategoryService;
import com.baomidou.mybatisplus.core.metadata.IPage;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

/**
 * 后台分类管理
 *
 * @author aurora
 */
@RestController
@RequestMapping("/admin/category")
@Api(tags = "后台-分类管理")
public class CategoryAdminController {

    @Autowired
    private CategoryService categoryService;

    @GetMapping("/page")
    @ApiOperation("分页查询分类")
    public Result<IPage<Category>> page(CategoryQuery query) {
        return Result.success(categoryService.adminPage(query));
    }

    @PostMapping
    @ApiOperation("新增分类")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<Void> create(@Valid @RequestBody CategoryRequest request) {
        categoryService.createCategory(request);
        return Result.success();
    }

    @PutMapping("/{id}")
    @ApiOperation("更新分类")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<Void> update(@PathVariable Long id, @Valid @RequestBody CategoryRequest request) {
        request.setId(id);
        categoryService.updateCategory(request);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    @ApiOperation("删除分类")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<Void> delete(@PathVariable Long id) {
        categoryService.removeById(id);
        return Result.success();
    }

    @GetMapping("/all")
    @ApiOperation("获取全部分类列表")
    public Result<List<Category>> all() {
        return Result.success(categoryService.listAll());
    }
}
