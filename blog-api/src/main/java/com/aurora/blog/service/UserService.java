package com.aurora.blog.service;

import com.aurora.blog.entity.User;
import com.baomidou.mybatisplus.extension.service.IService;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

/**
 * 用户 Service
 *
 * @author aurora
 */
public interface UserService extends IService<User>, UserDetailsService {

    /**
     * 根据用户名查询用户
     */
    User getByUsername(String username);

    /**
     * 登录验证（Spring Security 调用）
     */
    @Override
    org.springframework.security.core.userdetails.UserDetails loadUserByUsername(String username) throws UsernameNotFoundException;
}
