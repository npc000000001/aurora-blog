package com.aurora.blog.controller;

import com.aurora.blog.common.Result;
import com.aurora.blog.entity.Tag;
import com.aurora.blog.service.TagService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 前台-标签展示
 *
 * @author aurora
 */
@RestController
@RequestMapping("/tag")
@Api(tags = "前台-标签展示")
public class TagController {

    @Autowired
    private TagService tagService;

    @GetMapping("/all")
    @ApiOperation("获取全部标签列表")
    public Result<List<Tag>> all() {
        return Result.success(tagService.listAll());
    }
}
