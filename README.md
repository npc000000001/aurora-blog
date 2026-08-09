# Aurora Blog · 个人博客系统

> 基于 Spring Boot + Vue3 前后端分离架构的现代化个人博客系统

## 技术栈

| 层级 | 技术 |
|------|------|
| 后端 | Spring Boot 2.7.18 + MyBatis-Plus 3.5.5 + MySQL 8.0 + Redis |
| 权限 | Spring Security + JWT 无状态鉴权 + BCrypt 密码加密 |
| 文档 | Knife4j 4.4.0 接口文档 |
| 后台前端 | Vue3 + Vite 6 + Element Plus + Pinia + Vue Router + ECharts |
| 博客前台 | Vue3 + Vite 6 + Vue Router + Axios + marked（Markdown 渲染） |
| 构建 | Maven 3.9 + npm |

## 项目结构

```
aurora-blog/
├── blog-api/                后端 Spring Boot 服务
│   ├── src/main/java/com/aurora/blog/
│   │   ├── config/          配置类（Security / MybatisPlus / Redis / WebMvc）
│   │   ├── controller/      控制器（前台 + admin 后台）
│   │   ├── dto/             数据传输对象
│   │   ├── entity/          实体类
│   │   ├── exception/       全局异常处理
│   │   ├── mapper/          MyBatis-Plus Mapper
│   │   ├── security/        JWT 认证过滤器 / 异常响应处理器
│   │   ├── service/         业务逻辑层
│   │   ├── common/          统一返回结果 / 状态码
│   │   └── util/            JWT / Redis 工具类
│   └── src/main/resources/  配置文件
├── blog-cms/                后台管理前端（Vue3 + Element Plus）
│   └── src/
│       ├── api/             接口请求（auth/blog/category/tag）
│       ├── layout/          极光主题后台布局
│       ├── router/          路由配置 + 登录守卫
│       ├── stores/          Pinia 状态管理
│       ├── styles/          全局样式 / 变量
│       ├── utils/           axios 请求封装
│       └── views/           页面（登录 / 仪表盘 / 文章 / 页面 / 日志 / 统计）
├── blog-view/               博客前台前端（Vue3）
│   └── src/
│       ├── api/             前台接口
│       ├── components/      BlogCard / Sidebar 组件
│       ├── router/          路由
│       ├── styles/          极光主题样式
│       ├── utils/           请求封装
│       └── views/           页面（首页 / 详情 / 归档 / 分类 / 标签 / 友链 / 关于）
├── sql/                     数据库脚本
│   └── init.sql            建库建表 + 初始数据
└── README.md
```

## 环境要求

- JDK 8+
- Maven 3.6+
- Node.js 18+ / npm 9+
- MySQL 8.0
- Redis 5.0+

## 快速启动

### 1. 初始化数据库

```sql
CREATE DATABASE aurora_blog DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
```

导入 `sql/init.sql` 脚本，自动创建全部数据表并插入初始数据（管理员账号、默认分类标签、示例文章）。

### 2. 配置后端

修改 `blog-api/src/main/resources/application-dev.yml`：

```yaml
spring:
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/aurora_blog?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true&useSSL=false
    username: root
    password: 你的MySQL密码
  redis:
    host: 127.0.0.1
    port: 6379
    password:
```

### 3. 启动后端

```bash
cd blog-api
mvn spring-boot:run
```

启动成功后访问接口文档：http://localhost:8090/doc.html

### 4. 启动前端

```bash
# 后台管理
cd blog-cms
npm install
npm run dev          # http://localhost:8080

# 博客前台
cd blog-view
npm install
npm run dev          # http://localhost:8081
```

### 5. 默认账号

| 用户名 | 密码 | 角色 |
|--------|------|------|
| admin  | 123456 | 管理员 |

## 功能模块

### 后端（blog-api）

- 用户认证：JWT 登录 / 退出 / 获取用户信息
- 文章管理：新增 / 编辑 / 删除 / 分页查询 / 详情浏览（含浏览量统计）
- 分类管理：分类 CRUD
- 标签管理：标签 CRUD
- 评论模块：评论发表 / 回复（数据库已建表）
- 访问统计：访客日志记录（数据库已建表）

### 后台管理（blog-cms）

- 登录页：极光主题登录界面 + JWT 认证
- 仪表盘：文章 / 访问 / 评论 / 用户统计卡片 + ECharts 图表（分类占比、近 7 天访问量）
- 博客管理：写文章 / 文章列表 / 分类管理 / 标签管理 / 评论管理
- 页面管理：站点设置 / 友链管理 / 关于我
- 日志管理：操作日志 / 访问日志
- 数据统计：访客统计

### 博客前台（blog-view）

- 首页：极光 Hero 区（故障风标题 + 动态光斑背景）+ 文章列表流 + 分页 + 侧边栏
- 文章详情：Markdown 渲染 + 目录联动 + 版权声明
- 归档 / 分类列表 / 标签列表 / 友链 / 关于

## 接口文档

后端启动后访问 Knife4j 文档：http://localhost:8090/doc.html

主要接口：

| 接口 | 方法 | 说明 | 鉴权 |
|------|------|------|------|
| /admin/login | POST | 管理员登录 | 否 |
| /admin/info | GET | 获取用户信息 | 是 |
| /admin/blog | POST | 新增文章 | 是 |
| /admin/blog/{id} | PUT | 更新文章 | 是 |
| /admin/blog/{id} | DELETE | 删除文章 | 是 |
| /admin/blog/page | GET | 后台分页查询 | 是 |
| /blog/page | GET | 前台分页查询 | 否 |
| /blog/{id} | GET | 文章详情 | 否 |

## UI 设计

采用统一的**极光主题**（Aurora Theme）：

- 主色：青 `#00d4ff` → 紫 `#7c4dff` 渐变
- 玻璃态卡片（Glassmorphism）
- 故障风（Glitch）标题效果
- 动态光斑背景
- 响应式布局，适配桌面与移动端


## 后续迭代计划

- [ ] P0：完善评论回复功能前后端联调
- [ ] P1：Redis 缓存热门文章，减轻数据库压力
- [ ] P1：接入访客访问量统计，ECharts 可视化展示
- [ ] P1：Dockerfile + docker-compose 一键容器部署
- [ ] P2：文章全文搜索（Elasticsearch）
- [ ] P2：移动端适配优化
- [ ] P2：文章支持图片上传（OSS / 本地存储）

## License

个人项目，版权归作者所有。如需开源，可添加 MIT 协议。
