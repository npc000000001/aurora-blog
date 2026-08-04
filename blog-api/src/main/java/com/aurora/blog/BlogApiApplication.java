package com.aurora.blog;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Aurora Blog 后端启动类
 *
 * @author aurora
 */
@SpringBootApplication
@MapperScan("com.aurora.blog.mapper")
public class BlogApiApplication {

    public static void main(String[] args) {
        SpringApplication.run(BlogApiApplication.class, args);
        System.out.println("====== Aurora Blog 后端启动成功 ======");
        System.out.println("====== 接口文档地址：http://localhost:8090/doc.html ======");
    }
}
