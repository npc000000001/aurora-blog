package com.aurora.blog.config;

import com.aurora.blog.security.JwtAuthenticationFilter;
import com.aurora.blog.security.SecurityResponseHandlers;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

/**
 * Spring Security 配置
 *
 * @author aurora
 */
@Configuration
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(
            AuthenticationConfiguration authenticationConfiguration) throws Exception {
        return authenticationConfiguration.getAuthenticationManager();
    }

    @Bean
    public JwtAuthenticationFilter jwtAuthenticationFilter() {
        return new JwtAuthenticationFilter();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // 关闭 CSRF（前后端分离不需要）
                .csrf().disable()
                // 基于 JWT，不需要 session
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
                .authorizeRequests()
                // 放行预检请求
                .antMatchers(HttpMethod.OPTIONS).permitAll()
                // 白名单路径
                .antMatchers(
                        "/admin/login",
                        "/admin/register",
                        "/doc.html",
                        "/swagger-ui/**",
                        "/swagger-resources/**",
                        "/webjars/**",
                        "/v2/api-docs",
                        "/v3/api-docs/**",
                        "/favicon.ico",
                        "/upload/**"
                ).permitAll()
                // 前台接口全部放行（公开访问）
                .antMatchers(HttpMethod.GET,
                        "/", "/blog/**", "/category/**", "/tag/**",
                        "/comment/**", "/about", "/archives", "/friend/**",
                        "/index/**", "/moment/**"
                ).permitAll()
                // 后台接口需要登录
                .antMatchers("/admin/**").authenticated()
                .anyRequest().authenticated()
                .and()
                // 异常处理
                .exceptionHandling()
                .authenticationEntryPoint(SecurityResponseHandlers.authenticationEntryPoint())
                .accessDeniedHandler(SecurityResponseHandlers.accessDeniedHandler());

        // 添加 JWT 过滤器
        http.addFilterBefore(jwtAuthenticationFilter(), UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
