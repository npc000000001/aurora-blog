package com.aurora.blog.controller;

import com.aurora.blog.common.Result;
import com.aurora.blog.entity.Friend;
import com.aurora.blog.service.FriendService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 前台-友链展示
 *
 * @author aurora
 */
@RestController
@RequestMapping("/friend")
@Api(tags = "前台-友链展示")
public class FriendController {

    @Autowired
    private FriendService friendService;

    @GetMapping("/all")
    @ApiOperation("获取全部友链列表")
    public Result<List<Friend>> all() {
        return Result.success(friendService.listAll());
    }
}
