package com.aurora.blog.service;

import com.aurora.blog.entity.Friend;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;

/**
 * 友链 Service
 *
 * @author aurora
 */
public interface FriendService extends IService<Friend> {

    /**
     * 查询全部友链（按 sort 升序）
     *
     * @return 友链列表
     */
    List<Friend> listAll();
}
