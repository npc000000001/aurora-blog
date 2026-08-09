package com.aurora.blog.dto;

import lombok.Data;

import javax.validation.constraints.NotBlank;

/**
 * 标签请求 DTO
 *
 * @author aurora
 */
@Data
public class TagRequest {

    private Long id;

    @NotBlank(message = "名称不能为空")
    private String name;
}
