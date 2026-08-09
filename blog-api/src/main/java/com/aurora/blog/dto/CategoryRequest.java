package com.aurora.blog.dto;

import lombok.Data;

import javax.validation.constraints.NotBlank;

/**
 * 分类请求 DTO
 *
 * @author aurora
 */
@Data
public class CategoryRequest {

    private Long id;

    @NotBlank(message = "名称不能为空")
    private String name;

    private String description;

    private Integer sort;
}
