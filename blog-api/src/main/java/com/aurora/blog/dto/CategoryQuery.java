package com.aurora.blog.dto;

import lombok.Data;

/**
 * 分类列表查询条件
 *
 * @author aurora
 */
@Data
public class CategoryQuery {

    private String name;

    private Integer pageNum = 1;

    private Integer pageSize = 10;
}
