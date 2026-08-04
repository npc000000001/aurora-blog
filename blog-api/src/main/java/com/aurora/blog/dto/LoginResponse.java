package com.aurora.blog.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 登录返回 VO
 *
 * @author aurora
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoginResponse {

    private String token;

    private String tokenHead;

    private String username;

    private String nickname;

    private String avatar;
}
