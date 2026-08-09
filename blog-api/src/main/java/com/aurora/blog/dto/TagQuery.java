package com.aurora.blog.dto;

import lombok.Data;

/**
 * 标签列表查询条件
 *
 * @author aurora
 */
@Data
public class TagQuery {

    private String name;

    private Integer pageNum = 1;

    private Integer pageSize = 10;
}
