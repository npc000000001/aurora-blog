package com.aurora.blog.security;

import com.aurora.blog.common.Result;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.access.AccessDeniedHandler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Security 响应处理器
 * 处理未登录和无权限的 JSON 响应
 *
 * @author aurora
 */
@Slf4j
public class SecurityResponseHandlers {

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    /**
     * 未登录处理器
     */
    public static AuthenticationEntryPoint authenticationEntryPoint() {
        return (request, response, authException) -> {
            log.warn("未登录访问：{} | {}", request.getRequestURI(), authException.getMessage());
            writeJson(response, Result.unauthorized("未登录或登录已过期"));
        };
    }

    /**
     * 权限不足处理器
     */
    public static AccessDeniedHandler accessDeniedHandler() {
        return (request, response, accessDeniedException) -> {
            log.warn("权限不足：{} | {}", request.getRequestURI(), accessDeniedException.getMessage());
            writeJson(response, Result.forbidden("权限不足，无法访问"));
        };
    }

    private static void writeJson(HttpServletResponse response, Result<?> result) throws IOException {
        response.setStatus(HttpServletResponse.SC_OK);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(OBJECT_MAPPER.writeValueAsString(result));
    }
}
