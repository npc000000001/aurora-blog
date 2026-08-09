package com.aurora.blog.service;

import com.aurora.blog.dto.TagQuery;
import com.aurora.blog.dto.TagRequest;
import com.aurora.blog.entity.Tag;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;

/**
 * 标签 Service
 *
 * @author aurora
 */
public interface TagService extends IService<Tag> {

    /**
     * 查询全部标签
     *
     * @return 标签列表
     */
    List<Tag> listAll();

    /**
     * 分页查询标签（后台，按 name 模糊查询）
     *
     * @param query 查询条件
     * @return 分页结果
     */
    IPage<Tag> adminPage(TagQuery query);

    /**
     * 新增标签
     *
     * @param request 标签请求
     * @return 是否成功
     */
    boolean createTag(TagRequest request);

    /**
     * 更新标签
     *
     * @param request 标签请求
     * @return 是否成功
     */
    boolean updateTag(TagRequest request);
}
