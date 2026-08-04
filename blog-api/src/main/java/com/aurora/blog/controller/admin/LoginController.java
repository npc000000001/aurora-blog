package com.aurora.blog.controller.admin;

import com.aurora.blog.common.Result;
import com.aurora.blog.dto.LoginRequest;
import com.aurora.blog.dto.LoginResponse;
import com.aurora.blog.entity.User;
import com.aurora.blog.service.UserService;
import com.aurora.blog.util.JwtUtils;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

/**
 * 后台登录控制器
 *
 * @author aurora
 */
@Slf4j
@RestController
@RequestMapping("/admin")
@Api(tags = "后台-登录管理")
public class LoginController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtUtils jwtUtils;

    @Autowired
    private UserService userService;

    /**
     * 登录
     */
    @PostMapping("/login")
    @ApiOperation("管理员登录")
    public Result<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        // Spring Security 认证
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUsername(), request.getPassword()));
        SecurityContextHolder.getContext().setAuthentication(authentication);

        // 生成 JWT
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String token = jwtUtils.generateToken(userDetails);

        // 查询用户信息
        User user = userService.getByUsername(request.getUsername());

        return Result.success(new LoginResponse(
                token,
                "Bearer ",
                user.getUsername(),
                user.getNickname(),
                user.getAvatar()
        ));
    }

    /**
     * 获取当前登录用户信息
     */
    @GetMapping("/info")
    @ApiOperation("获取当前用户信息")
    public Result<User> info(Principal principal) {
        if (principal == null) {
            return Result.failed("未登录");
        }
        User user = userService.getByUsername(principal.getName());
        if (user != null) {
            user.setPassword(null);
        }
        return Result.success(user);
    }

    /**
     * 退出登录
     */
    @PostMapping("/logout")
    @ApiOperation("退出登录")
    public Result<Void> logout() {
        SecurityContextHolder.clearContext();
        return Result.success();
    }
}
