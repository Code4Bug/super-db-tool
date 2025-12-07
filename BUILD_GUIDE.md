# 跨平台打包指南

## 概述

本项目使用 Tauri 构建跨平台桌面应用，支持 Windows、macOS 和 Linux。

## 打包前准备

### 1. 环境要求

#### 所有平台
- Node.js 18+ (推荐 20+)
- Rust 1.82+
- npm 或 pnpm

#### macOS
```bash
# 安装 Xcode Command Line Tools
xcode-select --install
```

#### Windows
```bash
# 安装 Microsoft C++ Build Tools
# 下载地址: https://visualstudio.microsoft.com/visual-cpp-build-tools/

# 安装 WebView2 (Windows 10/11 通常已预装)
# 下载地址: https://developer.microsoft.com/microsoft-edge/webview2/
```

#### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install libwebkit2gtk-4.1-dev \
  build-essential \
  curl \
  wget \
  file \
  libxdo-dev \
  libssl-dev \
  libayatana-appindicator3-dev \
  librsvg2-dev
```

#### Linux (Fedora)
```bash
sudo dnf install webkit2gtk4.1-devel \
  openssl-devel \
  curl \
  wget \
  file \
  libappindicator-gtk3-devel \
  librsvg2-devel
```

#### Linux (Arch)
```bash
sudo pacman -Syu
sudo pacman -S webkit2gtk-4.1 \
  base-devel \
  curl \
  wget \
  file \
  openssl \
  appmenu-gtk-module \
  gtk3 \
  libappindicator-gtk3 \
  librsvg \
  libvips
```

### 2. 安装依赖

```bash
cd super-db-manager
npm install
```

## 打包命令

### 开发模式（测试）

```bash
npm run tauri dev
```

### 生产构建

#### 构建当前平台

```bash
npm run tauri build
```

这将生成当前操作系统的安装包。

#### 指定构建目标

```bash
# macOS
npm run tauri build -- --target universal-apple-darwin  # 通用二进制（Intel + Apple Silicon）
npm run tauri build -- --target aarch64-apple-darwin    # Apple Silicon (M1/M2/M3)
npm run tauri build -- --target x86_64-apple-darwin     # Intel Mac

# Windows
npm run tauri build -- --target x86_64-pc-windows-msvc  # 64位
npm run tauri build -- --target i686-pc-windows-msvc    # 32位

# Linux
npm run tauri build -- --target x86_64-unknown-linux-gnu
```

## 输出文件位置

构建完成后，安装包位于：

```
src-tauri/target/release/bundle/
```

### macOS
- `dmg/` - DMG 磁盘镜像（推荐分发格式）
- `macos/` - .app 应用包

### Windows
- `msi/` - MSI 安装程序（推荐）
- `nsis/` - NSIS 安装程序

### Linux
- `deb/` - Debian/Ubuntu 包
- `rpm/` - Fedora/RHEL 包
- `appimage/` - AppImage 通用格式

## 打包配置

### 应用信息

在 `src-tauri/tauri.conf.json` 中配置：

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
    "windows": [
      {
        "title": "超级数据库管理工具",
        "width": 1400,
        "height": 900,
        "minWidth": 1024,
        "minHeight": 768
      }
    ]
  }
}
```

### 图标

图标文件位于 `src-tauri/icons/`：

- `icon.icns` - macOS 图标
- `icon.ico` - Windows 图标
- `*.png` - Linux 图标

#### 生成图标

使用 Tauri 图标生成工具：

```bash
# 从 1024x1024 的 PNG 生成所有平台图标
npm install -g @tauri-apps/cli
cargo tauri icon path/to/icon.png
```

## 代码签名

### macOS

```bash
# 设置开发者证书
export APPLE_CERTIFICATE="Developer ID Application: Your Name (TEAM_ID)"
export APPLE_CERTIFICATE_PASSWORD="cert_password"

# 构建并签名
npm run tauri build
```

在 `tauri.conf.json` 中配置：

```json
{
  "bundle": {
    "macOS": {
      "signingIdentity": "Developer ID Application: Your Name (TEAM_ID)"
    }
  }
}
```

### Windows

```bash
# 使用证书签名
npm run tauri build
```

在 `tauri.conf.json` 中配置：

```json
{
  "bundle": {
    "windows": {
      "certificateThumbprint": "YOUR_CERT_THUMBPRINT",
      "digestAlgorithm": "sha256"
    }
  }
}
```

## 自动化构建

### GitHub Actions

创建 `.github/workflows/build.yml`：

```yaml
name: Build

on:
  push:
    tags:
      - 'v*'

jobs:
  build:
    strategy:
      matrix:
        platform: [macos-latest, ubuntu-latest, windows-latest]
    
    runs-on: ${{ matrix.platform }}
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: 20
      
      - name: Setup Rust
        uses: dtolnay/rust-toolchain@stable
      
      - name: Install dependencies (Ubuntu)
        if: matrix.platform == 'ubuntu-latest'
        run: |
          sudo apt update
          sudo apt install -y libwebkit2gtk-4.1-dev build-essential curl wget file libssl-dev libayatana-appindicator3-dev librsvg2-dev
      
      - name: Install frontend dependencies
        run: |
          cd super-db-manager
          npm install
      
      - name: Build
        run: |
          cd super-db-manager
          npm run tauri build
      
      - name: Upload artifacts
        uses: actions/upload-artifact@v4
        with:
          name: ${{ matrix.platform }}-build
          path: super-db-manager/src-tauri/target/release/bundle/
```

## 优化构建

### 减小包体积

在 `src-tauri/Cargo.toml` 中添加：

```toml
[profile.release]
opt-level = "z"     # 优化体积
lto = true          # 链接时优化
codegen-units = 1   # 更好的优化
panic = "abort"     # 减小二进制大小
strip = true        # 移除调试符号
```

### 加速构建

```bash
# 使用 sccache 缓存编译结果
cargo install sccache
export RUSTC_WRAPPER=sccache

# 并行编译
export CARGO_BUILD_JOBS=8
```

## 测试安装包

### macOS
```bash
# 打开 DMG
open src-tauri/target/release/bundle/dmg/*.dmg

# 或直接运行 .app
open src-tauri/target/release/bundle/macos/*.app
```

### Windows
```bash
# 运行 MSI 安装程序
start src-tauri/target/release/bundle/msi/*.msi
```

### Linux
```bash
# Debian/Ubuntu
sudo dpkg -i src-tauri/target/release/bundle/deb/*.deb

# Fedora/RHEL
sudo rpm -i src-tauri/target/release/bundle/rpm/*.rpm

# AppImage
chmod +x src-tauri/target/release/bundle/appimage/*.AppImage
./src-tauri/target/release/bundle/appimage/*.AppImage
```

## 常见问题

### 1. 构建失败：找不到 webkit2gtk

**Linux**: 确保安装了 `libwebkit2gtk-4.1-dev`

```bash
sudo apt install libwebkit2gtk-4.1-dev
```

### 2. macOS 签名失败

确保已安装 Xcode 并配置了开发者证书：

```bash
xcode-select --install
security find-identity -v -p codesigning
```

### 3. Windows 缺少 WebView2

下载并安装 WebView2 Runtime：
https://developer.microsoft.com/microsoft-edge/webview2/

### 4. 构建速度慢

使用增量编译和缓存：

```bash
# 启用增量编译
export CARGO_INCREMENTAL=1

# 使用 sccache
cargo install sccache
export RUSTC_WRAPPER=sccache
```

### 5. 包体积过大

- 启用 release 优化（见上文）
- 移除未使用的依赖
- 使用 `cargo bloat` 分析体积

```bash
cargo install cargo-bloat
cargo bloat --release
```

## 发布清单

- [ ] 更新版本号（`package.json` 和 `tauri.conf.json`）
- [ ] 更新 CHANGELOG.md
- [ ] 测试所有平台构建
- [ ] 代码签名（macOS/Windows）
- [ ] 创建 GitHub Release
- [ ] 上传安装包
- [ ] 更新文档

## 分发

### GitHub Releases

1. 创建 Git tag：
```bash
git tag v0.1.0
git push origin v0.1.0
```

2. 在 GitHub 创建 Release
3. 上传构建的安装包

### 自动更新

Tauri 支持自动更新功能，配置方法见：
https://tauri.app/v1/guides/distribution/updater

## 参考资源

- [Tauri 官方文档](https://tauri.app/)
- [Tauri 构建指南](https://tauri.app/v1/guides/building/)
- [Tauri 分发指南](https://tauri.app/v1/guides/distribution/)
