package com.aurora.blog.service.impl;

import com.aurora.blog.dto.TagQuery;
import com.aurora.blog.dto.TagRequest;
import com.aurora.blog.entity.Tag;
import com.aurora.blog.mapper.TagMapper;
import com.aurora.blog.service.TagService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

/**
 * 标签 Service 实现
 *
 * @author aurora
 */
@Slf4j
@Service
public class TagServiceImpl extends ServiceImpl<TagMapper, Tag> implements TagService {

    @Override
    public List<Tag> listAll() {
        return this.list();
    }

    @Override
    public IPage<Tag> adminPage(TagQuery query) {
        Page<Tag> page = new Page<>(query.getPageNum(), query.getPageSize());
        LambdaQueryWrapper<Tag> wrapper = new LambdaQueryWrapper<Tag>()
                .like(StringUtils.hasText(query.getName()), Tag::getName, query.getName())
                .orderByDesc(Tag::getCreateTime);
        return this.page(page, wrapper);
    }

    @Override
    public boolean createTag(TagRequest request) {
        Tag tag = new Tag();
        BeanUtils.copyProperties(request, tag);
        return this.save(tag);
    }

    @Override
    public boolean updateTag(TagRequest request) {
        if (request.getId() == null) {
            return false;
        }
        Tag tag = new Tag();
        BeanUtils.copyProperties(request, tag);
        return this.updateById(tag);
    }
}
