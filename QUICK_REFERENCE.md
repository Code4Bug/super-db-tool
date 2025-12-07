# 快速参考

## 常用命令

### 开发
```bash
npm run tauri:dev          # 启动开发模式
npm run dev                # 仅启动前端开发服务器
npm run lint               # 代码检查
npm run lint:fix           # 自动修复代码问题
npm run format             # 格式化代码
```

### 构建
```bash
npm run tauri:build        # 构建生产版本
npm run tauri:build:debug  # 构建调试版本
./scripts/build-all.sh     # 自动化构建（macOS/Linux）
scripts\build-all.bat      # 自动化构建（Windows）
```

### 版本管理
```bash
npm version patch          # 0.1.0 -> 0.1.1
npm version minor          # 0.1.0 -> 0.2.0
npm version major          # 0.1.0 -> 1.0.0
```

## 目录结构

```
super-db-manager/
├── src/                   # 前端源码
│   ├── components/        # React 组件
│   ├── pages/            # 页面
│   ├── types/            # 类型定义
│   └── App.tsx           # 根组件
├── src-tauri/            # Rust 后端
│   ├── src/              # Rust 源码
│   └── target/           # 构建输出
├── scripts/              # 构建脚本
├── docs/                 # 文档
└── .github/              # GitHub Actions
```

## 构建输出位置

```
src-tauri/target/release/bundle/
├── dmg/          # macOS 安装包
├── msi/          # Windows 安装包
├── deb/          # Linux Debian 包
└── appimage/     # Linux AppImage
```

## 配置文件

| 文件 | 用途 |
|------|------|
| `package.json` | 前端依赖和脚本 |
| `src-tauri/tauri.conf.json` | Tauri 配置 |
| `src-tauri/Cargo.toml` | Rust 依赖 |
| `.eslintrc.json` | ESLint 配置 |
| `.prettierrc` | Prettier 配置 |
| `tsconfig.json` | TypeScript 配置 |
| `vite.config.ts` | Vite 配置 |

## 端口

- 开发服务器: `http://localhost:1420`
- Vite HMR: `http://localhost:5173`

## 环境要求

| 工具 | 最低版本 | 推荐版本 |
|------|---------|---------|
| Node.js | 18.x | 20.x+ |
| Rust | 1.82+ | 最新稳定版 |
| npm | 9.x | 10.x+ |

## 平台特定依赖

### macOS
```bash
xcode-select --install
```

### Windows
- Visual Studio Build Tools
- WebView2 Runtime

### Linux (Ubuntu/Debian)
```bash
sudo apt install libwebkit2gtk-4.1-dev build-essential curl wget file libssl-dev libayatana-appindicator3-dev librsvg2-dev
```

## 故障排除

### 构建失败
```bash
# 清理缓存
rm -rf node_modules package-lock.json
npm install

# 清理 Rust 构建
cd src-tauri
cargo clean
```

### 端口占用
```bash
# 查找占用端口的进程
lsof -i :1420  # macOS/Linux
netstat -ano | findstr :1420  # Windows

# 杀死进程
kill -9 <PID>  # macOS/Linux
taskkill /PID <PID> /F  # Windows
```

### Rust 版本问题
```bash
# 更新 Rust
rustup update stable

# 检查版本
rustc --version
cargo --version
```

## 有用的链接

- [Tauri 文档](https://tauri.app/)
- [React 文档](https://react.dev/)
- [Material UI 文档](https://mui.com/)
- [Rust 文档](https://doc.rust-lang.org/)

## Git 工作流

```bash
# 创建功能分支
git checkout -b feature/new-feature

# 提交更改
git add .
git commit -m "feat: add new feature"

# 推送到远程
git push origin feature/new-feature

# 创建发布标签
git tag v0.1.0
git push origin v0.1.0
```

## 性能优化

### 减小包体积
在 `src-tauri/Cargo.toml` 添加：
```toml
[profile.release]
opt-level = "z"
lto = true
codegen-units = 1
strip = true
```

### 加速构建
```bash
# 使用 sccache
cargo install sccache
export RUSTC_WRAPPER=sccache

# 并行编译
export CARGO_BUILD_JOBS=8
```

## 调试

### 前端调试
- 打开开发者工具: `Cmd+Option+I` (macOS) / `Ctrl+Shift+I` (Windows/Linux)
- React DevTools: 浏览器扩展

### 后端调试
```bash
# 查看 Rust 日志
RUST_LOG=debug npm run tauri:dev

# 使用 rust-analyzer
# 在 VS Code 中安装 rust-analyzer 扩展
```

## 测试

```bash
# 前端测试（待实现）
npm test

# Rust 测试
cd src-tauri
cargo test
```

## 代码规范

### Commit 消息格式
```
<type>(<scope>): <subject>

feat: 新功能
fix: 修复 bug
docs: 文档更新
style: 代码格式
refactor: 重构
test: 测试
chore: 构建/工具
```

### 示例
```bash
git commit -m "feat(connection): add PostgreSQL support"
git commit -m "fix(query): resolve SQL parsing error"
git commit -m "docs: update build guide"
```
