# 更新日志

## [0.1.0] - 2025-12-07

### 阶段 0: 项目初始化 ✅

#### 新增
- 创建 Tauri + React + TypeScript 项目基础框架
- 集成 Material UI v5 UI 组件库
- 配置亮色和暗色主题系统
- 集成 Zustand 状态管理
- 集成 TanStack Query 数据请求库
- 集成 React Router 路由管理
- 配置 ESLint 和 Prettier 代码规范工具
- 创建完整的前端目录结构
- 创建完整的 Rust 后端模块结构
- 实现响应式布局组件（侧边栏、顶栏、内容区）
- 创建四个主要页面框架：
  - 连接管理页面
  - 数据浏览页面
  - SQL 查询页面
  - ETL 同步页面
- 定义基础 TypeScript 类型（数据库连接、连接状态等）
- 创建基础 Tauri 命令框架
- 添加项目文档：
  - README.md
  - ARCHITECTURE.md
  - GETTING_STARTED.md
  - CHANGELOG.md

#### 技术栈
- 前端: React 18, TypeScript, Material UI v5, Zustand, TanStack Query, React Router
- 后端: Tauri 2.x, Rust 1.91.1, Tokio
- 构建工具: Vite, Cargo
- 代码规范: ESLint, Prettier

#### 环境要求
- Node.js 18+ (建议 20+)
- Rust 1.82+
- npm 或 pnpm

### 下一步计划
- 阶段 1: 实现连接管理功能（数据库连接的增删改查）
