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

-- ----------------------------
-- 8. 友链表
-- ----------------------------
DROP TABLE IF EXISTS `friend`;
CREATE TABLE `friend` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) NOT NULL COMMENT '站点名称',
  `description` varchar(255) DEFAULT NULL COMMENT '站点描述',
  `avatar` varchar(255) DEFAULT NULL COMMENT '站点头像/Logo',
  `url` varchar(255) NOT NULL COMMENT '站点地址',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序',
  `deleted` tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='友情链接表';

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- 初始化数据
-- ============================================

-- 管理员账号：admin / 123456 （密码使用 BCrypt 算法加密，独立生成）
INSERT INTO `user` (`username`, `password`, `nickname`, `role`, `status`) VALUES
('admin', '$2b$10$qcQqHEU7/t.omoMDTXSLUOc20jDNNG6P.kMepgkWLYXazWN23WD12', 'Aurora 管理员', 'ADMIN', 1);

-- 分类（6 个）
INSERT INTO `category` (`name`, `description`, `sort`) VALUES
('后端开发', 'Java、Spring、数据库相关', 1),
('前端开发', 'Vue、React、CSS 相关', 2),
('技术随笔', '技术思考与总结', 3),
('数据库', 'MySQL、Redis、MongoDB 实战', 4),
('运维部署', 'Docker、CI/CD、Linux', 5),
('开源项目', '优秀项目解读与源码分析', 6);

-- 标签（12 个）
INSERT INTO `tag` (`name`) VALUES
('Spring Boot'), ('MyBatis'), ('Redis'), ('Vue'), ('MySQL'),
('Docker'), ('JWT'), ('TypeScript'), ('Vite'), ('Linux'), ('ECharts'), ('算法');

-- 文章（10 篇，覆盖不同分类）
INSERT INTO `blog` (`title`, `summary`, `content`, `category_id`, `views`, `is_top`, `is_published`, `create_time`) VALUES
(
  '欢迎使用 Aurora Blog',
  'Aurora Blog 个人博客系统正式上线，记录技术成长之路。',
  '# 欢迎使用 Aurora Blog\n\nAurora Blog 是一套基于 Spring Boot + Vue3 前后端分离架构的现代化个人博客系统。\n\n## 技术栈\n\n- 后端：Spring Boot 2.7 + MyBatis-Plus + Spring Security + JWT\n- 前端：Vue3 + Vite 6 + Element Plus + Pinia\n- 数据库：MySQL 8.0 + Redis\n- 文档：Knife4j 4.4.0\n\n## 功能特性\n\n- 文章发布与管理（Markdown 编辑）\n- 分类与标签系统\n- 评论与回复\n- 访问统计\n- 极光主题 UI\n\n## 关于\n\n本项目为 100% 原创开发，所有业务代码、数据库设计、工具类、接口逻辑均独立从零编写，完全归属作者本人。\n\n> 极光闪烁，记录属于你的技术故事。',
  3, 1280, 1, 1, '2026-07-12 09:30:00'
),
(
  'Spring Boot 2.7 整合 JWT 实现无状态鉴权',
  '从零搭建 JWT 认证流程，包括过滤器、Spring Security 配置、Token 刷新策略与前端联调。',
  '# Spring Boot 2.7 整合 JWT 实现无状态鉴权\n\n## 为什么用 JWT\n\n传统的 Session 方案在前后端分离架构下存在跨域、扩展性等问题，JWT（JSON Web Token）凭借无状态、自包含的特性成为主流选择。\n\n## 整体流程\n\n1. 用户登录，服务端签发 JWT\n2. 前端将 Token 存入 localStorage\n3. 后续请求在 Header 中携带 `Authorization: Bearer <token>`\n4. 服务端通过过滤器校验 Token\n\n## 关键代码\n\n### JWT 工具类\n\n```java\npublic class JwtUtils {\n    public static String create(String subject, String secret, long expire) {\n        return Jwts.builder()\n            .setSubject(subject)\n            .setExpiration(new Date(System.currentTimeMillis() + expire))\n            .signWith(Keys.hmacShaKeyFor(secret.getBytes()))\n            .compact();\n    }\n}\n```\n\n### Spring Security 配置\n\n关闭 CSRF、使用 STATELESS Session、放行白名单路径，再在 `UsernamePasswordAuthenticationFilter` 之前插入自定义 JWT 过滤器。\n\n## 踩坑记录\n\n- BCrypt 哈希长度必须是 60 字符，少一个 `$` 都会报 `Encoded password does not look like BCrypt`\n- Knife4j 文档接口必须加入白名单，否则 401\n\n## 小结\n\nJWT 看似简单，工程实践中涉及过期续签、单点登录、黑名单等细节，后续会继续分享。',
  1, 892, 0, 1, '2026-07-18 14:22:00'
),
(
  'Vue3 响应式原理深度剖析',
  '从 Proxy、Reflect 到 effect、track、trigger，一文搞懂 Vue3 响应式系统的核心实现。',
  '# Vue3 响应式原理深度剖析\n\n## 从 Object.defineProperty 到 Proxy\n\nVue2 使用 `Object.defineProperty` 实现响应式，存在以下局限：\n\n- 无法监听属性的新增/删除\n- 无法监听数组索引变化\n- 需要递归遍历，性能开销大\n\nVue3 改用 ES6 的 `Proxy`，从根上解决了这些问题。\n\n## 核心实现\n\n```js\nfunction reactive(target) {\n  return new Proxy(target, {\n    get(target, key, receiver) {\n      track(target, key)\n      return Reflect.get(target, key, receiver)\n    },\n    set(target, key, value, receiver) {\n      const result = Reflect.set(target, key, value, receiver)\n      trigger(target, key)\n      return result\n    }\n  })\n}\n```\n\n## track 与 trigger\n\n- `track`：在 get 时收集依赖，建立 `target -> key -> effect` 的映射\n- `trigger`：在 set 时取出对应 effect 执行\n\n## effect 的嵌套\n\nVue3 使用栈结构处理嵌套 effect，外层 effect 执行完后出栈，恢复 activeEffect 指针。\n\n## 小结\n\n理解响应式原理，能帮助我们写出更符合框架心智模型的代码，也能在出现诡异 Bug 时快速定位。',
  2, 1456, 1, 1, '2026-07-22 10:15:00'
),
(
  'MyBatis-Plus 分页与自动填充实战',
  '一文掌握 MyBatis-Plus 的分页插件、MetaObjectHandler 自动填充、逻辑删除等常用特性。',
  '# MyBatis-Plus 分页与自动填充实战\n\n## 引入分页插件\n\n```java\n@Bean\npublic MybatisPlusInterceptor mybatisPlusInterceptor() {\n    MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();\n    interceptor.addInnerInterceptor(new PaginationInnerInterceptor(DbType.MYSQL));\n    return interceptor;\n}\n```\n\n## 自动填充\n\n实体类用 `@TableField(fill = FieldFill.INSERT)` 标记，再实现 `MetaObjectHandler`：\n\n```java\n@Component\npublic class MyMetaObjectHandler implements MetaObjectHandler {\n    @Override\n    public void insertFill(MetaObject metaObject) {\n        this.strictInsertFill(metaObject, \"createTime\", LocalDateTime.class, LocalDateTime.now());\n    }\n}\n```\n\n## 逻辑删除\n\n字段加 `@TableLogic`，配置全局 `logic-delete-field=deleted`，查询自动过滤已删除数据。\n\n## 小结\n\nMyBatis-Plus 在 MyBatis 之上做了一层薄封装，几乎零学习成本，但能显著提升 CRUD 效率。',
  1, 654, 0, 1, '2026-07-26 16:40:00'
),
(
  'Redis 实战：缓存穿透、击穿、雪崩的解决方案',
  '从布隆过滤器、互斥锁到热点 Key 永不过期，全面梳理缓存三大经典问题。',
  '# Redis 实战：缓存穿透、击穿、雪崩\n\n## 缓存穿透\n\n查询一个根本不存在的数据，每次请求都打到数据库。\n\n**方案**：\n1. 缓存空值（设置短 TTL）\n2. 布隆过滤器拦截\n\n## 缓存击穿\n\n某个热点 Key 突然过期，瞬间大量请求打到 DB。\n\n**方案**：\n1. 互斥锁（SETNX）\n2. 热点 Key 永不过期，后台异步刷新\n\n## 缓存雪崩\n\n大量 Key 同时过期，或 Redis 宕机。\n\n**方案**：\n1. TTL 加随机偏移\n2. 多级缓存\n3. Redis 集群保证高可用\n\n## 代码示例\n\n```java\nString value = redis.get(key);\nif (value == null) {\n    if (redis.setnx(lockKey, \"1\", 10)) {\n        value = db.query(key);\n        redis.set(key, value, 300 + RandomUtils.nextInt(60));\n        redis.del(lockKey);\n    }\n}\n```\n\n## 小结\n\n缓存问题是面试高频考点，理解原理比死记方案更重要。',
  4, 1023, 0, 1, '2026-07-30 11:08:00'
),
(
  'TypeScript 进阶类型实战',
  'conditional types、mapped types、infer、模板字面量类型，掌握 TS 高级玩法。',
  '# TypeScript 进阶类型实战\n\n## Conditional Types\n\n```ts\ntype IsString<T> = T extends string ? true : false\ntype A = IsString<\'hi\'> // true\ntype B = IsString<42>    // false\n```\n\n## Mapped Types\n\n```ts\ntype Readonly<T> = { readonly [K in keyof T]: T[K] }\ntype Partial<T>  = { [K in keyof T]?: T[K] }\n```\n\n## infer 关键字\n\n```ts\ntype ReturnType<T> = T extends (...args: any[]) => infer R ? R : never\n```\n\n## 模板字面量类型\n\n```ts\ntype EventName = `on${Capitalize<\'click\' | \'hover\'>}`\n// \'onClick\' | \'onHover\'\n```\n\n## 小结\n\nTS 的类型系统其实是图灵完备的，掌握这些特性后，你能写出类型安全的工具函数，让代码在编译期就消除大量 Bug。',
  2, 487, 0, 1, '2026-08-01 09:50:00'
),
(
  'Docker Compose 一键部署 Spring Boot + Vue + MySQL',
  '从 Dockerfile 到 docker-compose.yml，完整演示前后端项目的容器化部署流程。',
  '# Docker Compose 一键部署\n\n## 整体架构\n\n- backend：Spring Boot Fat Jar\n- frontend：Nginx 静态托管 dist\n- mysql / redis：官方镜像\n\n## Dockerfile 示例\n\n```dockerfile\nFROM openjdk:8-jre-slim\nCOPY target/blog-api.jar /app/app.jar\nEXPOSE 8090\nENTRYPOINT [\"java\",\"-jar\",\"/app/app.jar\"]\n```\n\n## docker-compose.yml\n\n```yaml\nservices:\n  mysql:\n    image: mysql:8.0\n    environment:\n      MYSQL_ROOT_PASSWORD: root\n      MYSQL_DATABASE: aurora_blog\n  redis:\n    image: redis:7\n  backend:\n    build: ./blog-api\n    depends_on: [mysql, redis]\n  frontend:\n    build: ./blog-view\n    ports: [\"80:80\"]\n```\n\n## 小结\n\nDocker Compose 把多容器编排变得极其简单，本地一键拉起完整环境，是开发与部署的利器。',
  5, 765, 0, 1, '2026-08-03 15:30:00'
),
(
  'Vite 6 极速构建原理：ESM 与 Esbuild 的化学反应',
  '为什么 Vite 启动只要几百毫秒？本文从 ESM 原生加载、Esbuild 预构建、HMR 三个角度解析。',
  '# Vite 6 极速构建原理\n\n## 传统打包器的痛点\n\nWebpack 启动时需要先构建完整依赖图，项目越大启动越慢。\n\n## Vite 的思路：No-Bundle\n\n### 启动阶段\n\n利用浏览器原生 ESM，按需加载模块，只有请求到的文件才编译。\n\n### 预构建（Esbuild）\n\n把 CJS 依赖（如 lodash）转成 ESM，用 Go 编写的 Esbuild 比传统工具快 10~100 倍。\n\n### HMR\n\n通过模块图的精确失效，做到修改一个文件只热更新受影响的模块。\n\n## 小结\n\nVite 的设计哲学是「让浏览器做它能做的事」，开发者只需要享受极速反馈。',
  2, 392, 0, 1, '2026-08-05 08:12:00'
),
(
  'MySQL 索引底层原理：B+ 树为什么这么香',
  '从二叉搜索树到 B+ 树，理解 MySQL 选择 B+ 树作为索引结构的根本原因。',
  '# MySQL 索引底层原理\n\n## 为什么不用二叉搜索树\n\n数据量增大时，树高变高，磁盘 IO 次数增多。\n\n## 为什么不用 B 树\n\nB 树每个节点都存数据，导致每个节点能容纳的 key 数量减少，树更高。\n\n## B+ 树的优势\n\n- 非叶子节点只存索引，单个节点能容纳更多 key，树更矮\n- 叶子节点用双向链表相连，范围查询极快\n- 数据都在叶子节点，查询性能稳定\n\n## 聚簇索引 vs 二级索引\n\n- 聚簇索引：叶子节点存整行数据（InnoDB 主键索引）\n- 二级索引：叶子节点存主键，需要回表\n\n## 小结\n\n理解索引底层结构，才能设计出合理的索引，避免「加了索引却没用上」的尴尬。',
  4, 856, 0, 1, '2026-08-05 10:48:00'
),
(
  'Aurora 主题设计系统：从配色到动效',
  '一份完整的极光主题设计规范：青紫渐变、玻璃态、故障风标题、动态光斑背景的实现细节。',
  '# Aurora 主题设计系统\n\n## 设计语言\n\n- 主色：青 `#00d4ff` → 紫 `#7c4dff` 的 135° 渐变\n- 辅色：玻璃态白（rgba 透明白）\n- 背景：深色 `#1a1a2e` 与浅色 `#f0f2f8` 双模式\n\n## 关键视觉\n\n### 故障风标题\n\n```css\n.hero-title {\n  position: relative;\n}\n.hero-title::before,\n.hero-title::after {\n  content: attr(data-text);\n  position: absolute;\n  mix-blend-mode: screen;\n  animation: glitch 2s infinite;\n}\n```\n\n### 动态光斑背景\n\n使用多个绝对定位的 blur 圆形，配合 `@keyframes` 让其缓慢移动。\n\n### 玻璃态卡片\n\n```css\n.card {\n  background: rgba(255,255,255,0.6);\n  backdrop-filter: blur(20px);\n  border: 1px solid rgba(255,255,255,0.3);\n}\n```\n\n## 小结\n\n一套自洽的设计系统能让项目在视觉上保持统一，后续迭代也会更高效。',
  3, 612, 0, 1, '2026-08-05 14:22:00'
);

-- 文章-标签关联（每篇文章 2~3 个标签）
INSERT INTO `blog_tag` (`blog_id`, `tag_id`) VALUES
(1, 1), (1, 4),       -- 欢迎使用：Spring Boot, Vue
(2, 1), (2, 7), (2, 8),  -- JWT：Spring Boot, JWT, TypeScript
(3, 4), (3, 8), (3, 9),  -- Vue3 响应式：Vue, TypeScript, Vite
(4, 1), (4, 2), (4, 5),  -- MyBatis-Plus：Spring Boot, MyBatis, MySQL
(5, 3), (5, 5),           -- Redis：Redis, MySQL
(6, 8), (6, 4),           -- TS 进阶：TypeScript, Vue
(7, 6), (7, 10), (7, 1),  -- Docker：Docker, Linux, Spring Boot
(8, 9), (8, 4),           -- Vite：Vite, Vue
(9, 5), (9, 12),          -- MySQL 索引：MySQL, 算法
(10, 4), (10, 11);        -- Aurora 主题：Vue, ECharts

-- 评论（10 条，覆盖多篇文章）
INSERT INTO `comment` (`blog_id`, `parent_id`, `reply_to_id`, `nickname`, `email`, `content`, `is_admin`, `is_published`, `ip`, `create_time`) VALUES
(1, 0, 0, '访客小李', 'li@example.com', '写得非常清晰，期待更多内容！', 0, 1, '123.118.42.15', '2026-07-13 10:15:00'),
(1, 1, 1, 'Aurora', 'admin@aurora.blog', '感谢支持，会持续更新～', 1, 1, '127.0.0.1', '2026-07-13 11:02:00'),
(2, 0, 0, 'Spring 爱好者', 'spring@example.com', 'BCrypt 那个坑我也踩过，血泪教训。', 0, 1, '58.213.45.91', '2026-07-19 09:20:00'),
(3, 0, 0, 'Vue3 学习者', 'vue@example.com', 'Proxy 比 defineProperty 强太多了', 0, 1, '114.245.32.8', '2026-07-23 14:48:00'),
(3, 4, 4, '前端老兵', 'fe@example.com', '其实还有 Reflect 的细节没展开，期待下篇', 0, 1, '36.110.50.83', '2026-07-23 18:30:00'),
(4, 0, 0, 'MyBatis 新手', 'mb@example.com', '自动填充那块终于看懂了，谢谢博主', 0, 1, '202.108.45.221', '2026-07-27 21:10:00'),
(5, 0, 0, '运维小哥', 'ops@example.com', '布隆过滤器补充一下 Redisson 的实现就完美了', 0, 1, '117.89.34.156', '2026-07-31 08:45:00'),
(7, 0, 0, 'Docker 入门', 'dk@example.com', 'compose 文件收藏了，明天就试试', 0, 1, '123.118.42.15', '2026-08-04 12:35:00'),
(9, 0, 0, 'DBA 阿强', 'dba@example.com', 'B+ 树那段讲得最透彻，转给团队看了', 0, 1, '58.213.45.91', '2026-08-05 11:22:00'),
(10, 0, 0, '设计学徒', 'design@example.com', '故障风效果太酷了！', 0, 1, '114.245.32.8', '2026-08-05 15:08:00');

-- 访问日志（12 条，覆盖近 7 天）
INSERT INTO `visit_log` (`ip`, `ip_source`, `os`, `browser`, `uri`, `create_time`) VALUES
('123.118.42.15', '北京', 'Windows 10', 'Chrome 120', '/', '2026-08-05 08:12:34'),
('123.118.42.15', '北京', 'Windows 10', 'Chrome 120', '/blog/3', '2026-08-05 08:13:02'),
('58.213.45.91', '江苏南京', 'iOS 17', 'Safari 17', '/blog/2', '2026-08-05 08:45:18'),
('114.245.32.8', '北京', 'macOS 14', 'Safari 17', '/archives', '2026-08-05 09:22:47'),
('202.108.45.221', '北京', 'Windows 10', 'Edge 120', '/blog/999', '2026-08-05 09:58:33'),
('58.213.45.91', '江苏南京', 'iOS 17', 'Safari 17', '/about', '2026-08-05 10:32:09'),
('36.110.50.83', '北京', 'Windows 10', 'Chrome 120', '/', '2026-08-05 11:15:42'),
('123.118.42.15', '北京', 'Windows 10', 'Chrome 120', '/category/前端开发', '2026-08-05 12:08:51'),
('117.89.34.156', '江苏苏州', 'Android 14', 'Chrome 120', '/tags', '2026-08-05 13:42:28'),
('114.245.32.8', '北京', 'macOS 14', 'Safari 17', '/blog/3', '2026-08-05 14:19:06'),
('36.110.50.83', '北京', 'Windows 10', 'Chrome 120', '/friends', '2026-08-05 14:58:21'),
('58.213.45.91', '江苏南京', 'iOS 17', 'Safari 17', '/blog/5', '2026-08-05 15:30:44');

-- 友链（6 个）
INSERT INTO `friend` (`name`, `description`, `avatar`, `url`, `sort`) VALUES
('Vue 官方文档', 'Vue3 官方文档，最权威的中文教程', 'https://cn.vuejs.org/logo.svg', 'https://cn.vuejs.org', 1),
('Spring 官方', 'Spring 全家桶官方文档', 'https://spring.io/favicon.ico', 'https://spring.io', 2),
('MyBatis-Plus', 'MyBatis-Plus 官方文档', 'https://baomidou.com/favicon.ico', 'https://baomidou.com', 3),
('MDN Web Docs', '最权威的 Web 开发文档', 'https://developer.mozilla.org/favicon-48x48.png', 'https://developer.mozilla.org', 4),
('掘金', '技术成长之路的同行者', 'https://juejin.cn/favicon.ico', 'https://juejin.cn', 5),
('GitHub', '全球最大同性交友网站', 'https://github.githubassets.com/favicons/favicon.svg', 'https://github.com', 6);
