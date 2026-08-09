package com.aurora.blog.service.impl;

import com.aurora.blog.entity.Friend;
import com.aurora.blog.mapper.FriendMapper;
import com.aurora.blog.service.FriendService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 友链 Service 实现
 *
 * @author aurora
 */
@Slf4j
@Service
public class FriendServiceImpl extends ServiceImpl<FriendMapper, Friend> implements FriendService {

    @Override
    public List<Friend> listAll() {
        return this.list(new LambdaQueryWrapper<Friend>()
                .orderByAsc(Friend::getSort));
    }
}
