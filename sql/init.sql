-- ============================================
-- Aurora Blog 数据库初始化脚本
-- 数据库：aurora_blog
-- 字符集：utf8mb4
-- 作者：aurora
-- ============================================

CREATE DATABASE IF NOT EXISTS `aurora_blog` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `aurora_blog`;

SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- 1. 用户表
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(100) NOT NULL COMMENT '密码（BCrypt加密）',
  `nickname` varchar(50) DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像URL',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `role` varchar(20) NOT NULL DEFAULT 'ADMIN' COMMENT '角色：ADMIN管理员/USER普通用户',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1启用 0禁用',
  `deleted` tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除：1已删除 0正常',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ----------------------------
-- 2. 分类表
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序（越小越靠前）',
  `deleted` tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文章分类表';

-- ----------------------------
-- 3. 标签表
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) NOT NULL COMMENT '标签名称',
  `deleted` tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文章标签表';

-- ----------------------------
-- 4. 文章表
-- ----------------------------
DROP TABLE IF EXISTS `blog`;
CREATE TABLE `blog` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(200) NOT NULL COMMENT '标题',
  `summary` varchar(500) DEFAULT NULL COMMENT '摘要',
  `content` longtext NOT NULL COMMENT '正文（Markdown）',
  `content_html` longtext COMMENT '渲染后的HTML',
  `cover` varchar(255) DEFAULT NULL COMMENT '封面图URL',
  `category_id` bigint DEFAULT NULL COMMENT '分类ID',
  `views` bigint NOT NULL DEFAULT 0 COMMENT '浏览量',
  `is_top` tinyint NOT NULL DEFAULT 0 COMMENT '是否置顶：1是 0否',
  `is_published` tinyint NOT NULL DEFAULT 0 COMMENT '是否发布：1已发布 0草稿',
  `deleted` tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文章表';

-- ----------------------------
-- 5. 文章-标签关联表
-- ----------------------------
DROP TABLE IF EXISTS `blog_tag`;
CREATE TABLE `blog_tag` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `blog_id` bigint NOT NULL COMMENT '文章ID',
  `tag_id` bigint NOT NULL COMMENT '标签ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_blog_tag` (`blog_id`, `tag_id`),
  KEY `idx_tag` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文章标签关联表';

-- ----------------------------
-- 6. 评论表
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `blog_id` bigint NOT NULL COMMENT '文章ID',
  `parent_id` bigint DEFAULT 0 COMMENT '父评论ID（0为顶级）',
  `reply_to_id` bigint DEFAULT 0 COMMENT '回复目标评论ID',
  `nickname` varchar(50) NOT NULL COMMENT '评论人昵称',
  `email` varchar(100) DEFAULT NULL COMMENT '评论人邮箱',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像URL',
  `content` text NOT NULL COMMENT '评论内容',
  `is_admin` tinyint NOT NULL DEFAULT 0 COMMENT '是否博主：1是 0否',
  `is_published` tinyint NOT NULL DEFAULT 1 COMMENT '是否显示：1显示 0隐藏',
  `ip` varchar(50) DEFAULT NULL COMMENT 'IP地址',
  `deleted` tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_blog` (`blog_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论表';

-- ----------------------------
-- 7. 访问记录表
-- ----------------------------
DROP TABLE IF EXISTS `visit_log`;
CREATE TABLE `visit_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ip` varchar(50) DEFAULT NULL COMMENT '访客IP',
  `ip_source` varchar(100) DEFAULT NULL COMMENT 'IP归属地',
  `os` varchar(50) DEFAULT NULL COMMENT '操作系统',
  `browser` varchar(50) DEFAULT NULL COMMENT '浏览器',
  `uri` varchar(255) DEFAULT NULL COMMENT '访问路径',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='访问日志表';

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- 初始化数据
-- ============================================

-- 管理员账号：admin / 123456 （密码使用 BCrypt 算法加密，独立生成）
INSERT INTO `user` (`username`, `password`, `nickname`, `role`, `status`) VALUES
('admin', '$2b$10$qcQqHEU7/t.omoMDTXSLUOc20jDNNG6P.kMepgkWLYXazWN23WD12', 'Aurora管理员', 'ADMIN', 1);

-- 默认分类
INSERT INTO `category` (`name`, `description`, `sort`) VALUES
('后端开发', 'Java、Spring、数据库相关', 1),
('前端开发', 'Vue、React、CSS相关', 2),
('技术随笔', '技术思考与总结', 3);

-- 默认标签
INSERT INTO `tag` (`name`) VALUES
('Spring Boot'), ('MyBatis'), ('Redis'), ('Vue'), ('MySQL');

-- 示例文章
INSERT INTO `blog` (`title`, `summary`, `content`, `category_id`, `is_published`, `is_top`) VALUES
('欢迎使用 Aurora Blog', 'Aurora Blog 个人博客系统正式上线', '# 欢迎使用 Aurora Blog\n\n这是一个基于 Spring Boot + Vue 构建的个人博客系统。\n\n## 技术栈\n\n- Spring Boot 2.7\n- MyBatis-Plus\n- Redis\n- Vue 2 + Element UI\n\n## 功能特性\n\n- 文章发布与管理\n- 分类标签\n- 评论系统\n- 访问统计\n', 1, 1, 1);
