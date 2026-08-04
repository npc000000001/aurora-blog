package com.aurora.blog.dto;

import lombok.Data;

/**
 * 文章列表查询条件
 *
 * @author aurora
 */
@Data
public class BlogQuery {

    private String title;

    private Long categoryId;

    private Integer isPublished;

    private Integer pageNum = 1;

    private Integer pageSize = 10;
}
