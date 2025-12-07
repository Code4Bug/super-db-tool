# 跨平台打包配置总结

## ✅ 已完成的配置

### 1. 打包配置文件
- ✅ `src-tauri/tauri.conf.json` - Tauri 主配置
  - 应用信息（名称、版本、标识符）
  - 窗口配置（大小、最小尺寸）
  - 打包目标（macOS、Windows、Linux）
  - 平台特定配置

### 2. 构建脚本
- ✅ `scripts/build-all.sh` - macOS/Linux 自动化构建脚本
- ✅ `scripts/build-all.bat` - Windows 自动化构建脚本
- ✅ npm 脚本配置（package.json）
  - `npm run tauri:build` - 快速构建
  - `npm run tauri:build:debug` - 调试构建

### 3. CI/CD 配置
- ✅ `.github/workflows/build.yml` - GitHub Actions 工作流
  - 支持三大平台自动构建
  - 自动创建 GitHub Release
  - 上传构建产物

### 4. 文档
- ✅ `BUILD_GUIDE.md` - 详细的打包指南
  - 环境要求
  - 打包命令
  - 平台特定说明
  - 代码签名
  - 故障排除
- ✅ `RELEASE_CHECKLIST.md` - 发布清单
- ✅ `QUICK_REFERENCE.md` - 快速参考
- ✅ `PACKAGING_SUMMARY.md` - 本文档

## 📦 支持的平台和格式

### macOS
- **格式**: DMG（磁盘镜像）、.app（应用包）
- **架构**: 
  - Universal Binary（Intel + Apple Silicon）
  - x86_64（Intel）
  - aarch64（Apple Silicon M1/M2/M3）
- **最低系统**: macOS 10.13+

### Windows
- **格式**: MSI（安装程序）、NSIS（可选）
- **架构**: 
  - x86_64（64位）
  - i686（32位）
- **最低系统**: Windows 10+
- **依赖**: WebView2 Runtime

### Linux
- **格式**: 
  - DEB（Debian/Ubuntu）
  - RPM（Fedora/RHEL）
  - AppImage（通用格式）
- **架构**: x86_64
- **最低系统**: 主流发行版

## 🚀 快速开始

### 本地构建

```bash
# 1. 进入项目目录
cd super-db-manager

# 2. 安装依赖
npm install

# 3. 构建当前平台
npm run tauri:build

# 或使用自动化脚本
./scripts/build-all.sh      # macOS/Linux
scripts\build-all.bat        # Windows
```

### 构建输出

安装包位于：`src-tauri/target/release/bundle/`

```
bundle/
├── dmg/                    # macOS DMG
├── macos/                  # macOS .app
├── msi/                    # Windows MSI
├── nsis/                   # Windows NSIS
├── deb/                    # Linux DEB
├── rpm/                    # Linux RPM
└── appimage/               # Linux AppImage
```

## 🔧 配置说明

### 应用信息配置

在 `src-tauri/tauri.conf.json` 中：

```json
{
  "productName": "super-db-manager",
  "version": "0.1.0",
  "identifier": "com.superdb.manager"
}
```

### 窗口配置

```json
{
  "app": {
    "windows": [{
      "title": "超级数据库管理工具",
      "width": 1400,
      "height": 900,
      "minWidth": 1024,
      "minHeight": 768
    }]
  }
}
```

### 打包配置

```json
{
  "bundle": {
    "active": true,
    "targets": "all",
    "identifier": "com.superdb.manager",
    "publisher": "Super DB Team",
    "category": "DeveloperTool"
  }
}
```

## 🎯 构建目标

### 指定平台构建

```bash
# macOS Universal Binary（推荐）
npm run tauri build -- --target universal-apple-darwin

# macOS Intel
npm run tauri build -- --target x86_64-apple-darwin

# macOS Apple Silicon
npm run tauri build -- --target aarch64-apple-darwin

# Windows 64位
npm run tauri build -- --target x86_64-pc-windows-msvc

# Windows 32位
npm run tauri build -- --target i686-pc-windows-msvc

# Linux
npm run tauri build -- --target x86_64-unknown-linux-gnu
```

## 🔐 代码签名（可选）

### macOS

```bash
# 设置环境变量
export APPLE_CERTIFICATE="Developer ID Application: Your Name"
export APPLE_CERTIFICATE_PASSWORD="password"

# 构建并签名
npm run tauri:build
```

### Windows

在 `tauri.conf.json` 中配置：

```json
{
  "bundle": {
    "windows": {
      "certificateThumbprint": "YOUR_CERT_THUMBPRINT"
    }
  }
}
```

## 🤖 自动化构建（GitHub Actions）

### 触发方式

1. **标签推送**（推荐）
```bash
git tag v0.1.0
git push origin v0.1.0
```

2. **手动触发**
- 在 GitHub 仓库的 Actions 页面
- 选择 "Build and Release" 工作流
- 点击 "Run workflow"

### 构建流程

1. 检出代码
2. 设置 Node.js 和 Rust 环境
3. 安装依赖
4. 构建三大平台
5. 创建 GitHub Release
6. 上传安装包

## 📊 构建优化

### 减小包体积

在 `src-tauri/Cargo.toml` 添加：

```toml
[profile.release]
opt-level = "z"      # 优化体积
lto = true           # 链接时优化
codegen-units = 1    # 更好的优化
panic = "abort"      # 减小二进制大小
strip = true         # 移除调试符号
```

### 加速构建

```bash
# 使用 sccache 缓存
cargo install sccache
export RUSTC_WRAPPER=sccache

# 并行编译
export CARGO_BUILD_JOBS=8
```

## 🐛 常见问题

### 1. 构建失败

```bash
# 清理并重新构建
rm -rf node_modules package-lock.json
npm install
cd src-tauri && cargo clean
```

### 2. 缺少依赖

**Linux**:
```bash
sudo apt install libwebkit2gtk-4.1-dev build-essential
```

**macOS**:
```bash
xcode-select --install
```

**Windows**:
- 安装 Visual Studio Build Tools
- 安装 WebView2 Runtime

### 3. 包体积过大

- 启用 release 优化
- 移除未使用的依赖
- 使用 `cargo bloat` 分析

```bash
cargo install cargo-bloat
cd src-tauri
cargo bloat --release
```

## 📝 发布流程

1. **更新版本号**
   - `package.json`
   - `src-tauri/tauri.conf.json`
   - `src-tauri/Cargo.toml`

2. **更新文档**
   - `CHANGELOG.md`
   - `README.md`

3. **本地测试**
   ```bash
   npm run tauri:build
   # 测试安装包
   ```

4. **创建标签**
   ```bash
   git tag v0.1.0
   git push origin v0.1.0
   ```

5. **等待 CI/CD 完成**
   - 检查 GitHub Actions
   - 验证构建产物

6. **发布 Release**
   - 编辑 GitHub Release
   - 添加更新说明
   - 发布

## 📚 相关文档

- [BUILD_GUIDE.md](BUILD_GUIDE.md) - 详细构建指南
- [RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md) - 发布清单
- [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - 快速参考
- [Tauri 官方文档](https://tauri.app/)

## ✨ 下一步

- [ ] 配置代码签名（macOS/Windows）
- [ ] 设置自动更新功能
- [ ] 优化包体积
- [ ] 添加更多平台支持
- [ ] 配置 CI/CD 缓存加速构建

## 🎉 总结

跨平台打包配置已完成！你现在可以：

1. ✅ 在本地构建所有平台的安装包
2. ✅ 使用自动化脚本简化构建流程
3. ✅ 通过 GitHub Actions 自动构建和发布
4. ✅ 参考详细文档解决问题

开始构建你的第一个版本：

```bash
cd super-db-manager
npm run tauri:build
```

祝你构建顺利！🚀
