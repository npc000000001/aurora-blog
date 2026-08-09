package com.aurora.blog.controller.admin;

import com.aurora.blog.common.Result;
import com.aurora.blog.dto.TagQuery;
import com.aurora.blog.dto.TagRequest;
import com.aurora.blog.entity.Tag;
import com.aurora.blog.service.TagService;
import com.baomidou.mybatisplus.core.metadata.IPage;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

/**
 * 后台标签管理
 *
 * @author aurora
 */
@RestController
@RequestMapping("/admin/tag")
@Api(tags = "后台-标签管理")
public class TagAdminController {

    @Autowired
    private TagService tagService;

    @GetMapping("/page")
    @ApiOperation("分页查询标签")
    public Result<IPage<Tag>> page(TagQuery query) {
        return Result.success(tagService.adminPage(query));
    }

    @PostMapping
    @ApiOperation("新增标签")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<Void> create(@Valid @RequestBody TagRequest request) {
        tagService.createTag(request);
        return Result.success();
    }

    @PutMapping("/{id}")
    @ApiOperation("更新标签")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<Void> update(@PathVariable Long id, @Valid @RequestBody TagRequest request) {
        request.setId(id);
        tagService.updateTag(request);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    @ApiOperation("删除标签")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<Void> delete(@PathVariable Long id) {
        tagService.removeById(id);
        return Result.success();
    }

    @GetMapping("/all")
    @ApiOperation("获取全部标签列表")
    public Result<List<Tag>> all() {
        return Result.success(tagService.listAll());
    }
}
