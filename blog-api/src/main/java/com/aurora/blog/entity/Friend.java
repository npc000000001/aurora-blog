package com.aurora.blog.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 友链实体
 *
 * @author aurora
 */
@Data
@TableName("friend")
public class Friend {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String name;

    private String description;

    private String avatar;

    private String url;

    private Integer sort;

    @TableLogic
    @JsonIgnore
    private Integer deleted;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
