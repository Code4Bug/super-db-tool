# 超级数据库管理工具

一个基于 Tauri + React + Material UI 的跨平台数据库管理工具，支持多种主流数据库和异构数据源之间的 ETL 数据同步功能。

## 技术栈

### 前端
- React 18+ with TypeScript
- Material UI (MUI) v5
- Zustand (状态管理)
- TanStack Query (数据请求)
- React Router (路由)

### 后端
- Tauri 2.x
- Rust
- Tokio (异步运行时)

## 支持的数据库

- PostgreSQL
- MySQL
- SQLite
- MongoDB
- Redis
- SQL Server
- ClickHouse
- TDengine

## 开发环境要求

- Node.js 18+
- Rust 1.70+
- npm 或 pnpm

## 快速开始

### 安装依赖

```bash
npm install
```

### 开发模式

```bash
npm run tauri:dev
```

### 构建应用

```bash
# 快速构建
npm run tauri:build

# 使用自动化脚本
./scripts/build-all.sh      # macOS/Linux
scripts\build-all.bat        # Windows
```

详细说明请查看：
- [快速开始指南](GETTING_STARTED.md)
- [构建打包指南](BUILD_GUIDE.md)
- [发布清单](RELEASE_CHECKLIST.md)

## 项目结构

```
super-db-manager/
├── src/                          # 前端源码
│   ├── components/               # React 组件
│   │   ├── common/              # 通用组件
│   │   ├── connection/          # 连接管理
│   │   ├── query/               # 查询执行
│   │   ├── browser/             # 数据浏览
│   │   ├── etl/                 # ETL 模块
│   │   └── monitor/             # 监控模块
│   ├── pages/                   # 页面组件
│   ├── hooks/                   # 自定义 Hooks
│   ├── store/                   # 状态管理
│   ├── services/                # API 服务
│   ├── types/                   # TypeScript 类型
│   └── utils/                   # 工具函数
├── src-tauri/                   # Tauri 后端
│   ├── src/
│   │   ├── commands/            # Tauri 命令
│   │   ├── database/            # 数据库模块
│   │   ├── etl/                 # ETL 引擎
│   │   ├── storage/             # 本地存储
│   │   └── utils/               # 工具函数
│   └── Cargo.toml               # Rust 依赖
└── README.md
```

## 开发计划

详见 [PLAN.md](../PLAN.md)

## 当前进度

- [x] 0.1 创建 Tauri + React + TypeScript 项目
- [x] 0.2 配置 Material UI 主题系统
- [x] 0.3 配置 ESLint, Prettier
- [x] 0.4 设置项目目录结构
- [x] 0.5 配置 Rust 工作空间
- [x] 0.6 创建基础路由结构
- [x] 0.7 实现基础布局组件（侧边栏、顶栏、内容区）

## 📚 文档索引

- **[快速开始指南](GETTING_STARTED.md)** - 项目初始化和运行
- **[构建打包指南](BUILD_GUIDE.md)** - 跨平台打包详细说明
- **[打包配置总结](PACKAGING_SUMMARY.md)** - 打包配置快速概览
- **[发布清单](RELEASE_CHECKLIST.md)** - 发布前检查清单
- **[快速参考](QUICK_REFERENCE.md)** - 常用命令和配置
- **[架构设计](docs/ARCHITECTURE.md)** - 系统架构说明
- **[更新日志](CHANGELOG.md)** - 版本更新记录

## 许可证

MIT
