package com.aurora.blog.dto;

import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

/**
 * 文章请求 DTO
 *
 * @author aurora
 */
@Data
public class BlogRequest {

    private Long id;

    @NotBlank(message = "标题不能为空")
    @Size(max = 200, message = "标题最长200字")
    private String title;

    @Size(max = 500, message = "摘要最长500字")
    private String summary;

    @NotBlank(message = "正文不能为空")
    private String content;

    private String contentHtml;

    private String cover;

    private Long categoryId;

    private Integer isTop;

    private Integer isPublished;
}
