# GitHub Actions 设置指南

## 问题说明

GitHub Actions workflow 文件需要特殊的 `workflow` 权限才能推送。如果你遇到以下错误：

```
refusing to allow a Personal Access Token to create or update workflow 
`.github/workflows/build.yml` without `workflow` scope
```

这是因为你的 Personal Access Token (PAT) 缺少 `workflow` 权限。

## 解决方案

### 方法 1: 更新 Personal Access Token 权限（推荐）

#### 步骤 1: 访问 GitHub Token 设置

1. 登录 GitHub
2. 访问: https://github.com/settings/tokens
3. 或者: Settings → Developer settings → Personal access tokens → Tokens (classic)

#### 步骤 2: 编辑现有 Token

1. 找到你当前使用的 token
2. 点击 token 名称或 "Edit" 按钮
3. 在权限列表中找到并勾选 `workflow`
4. 滚动到底部，点击 "Update token"
5. **重要**: 复制新的 token（如果 GitHub 重新生成了）

#### 步骤 3: 更新本地 Git 凭证

**macOS (使用 Keychain)**:
```bash
# Git 会在下次推送时提示输入新密码
# 输入你的新 token 即可
```

**Windows (使用 Credential Manager)**:
```bash
# 打开 Credential Manager
# 找到 git:https://github.com
# 删除旧凭证，下次推送时输入新 token
```

**Linux**:
```bash
# 如果使用 credential helper
git config --global credential.helper store
# 下次推送时输入新 token
```

**或者直接更新**:
```bash
# 临时使用 token
git remote set-url origin https://<TOKEN>@github.com/Code4Bug/super-db-tool.git

# 推送
git push origin develop
```

#### 步骤 4: 恢复 GitHub Actions 文件

创建 `.github/workflows/build.yml` 文件：

```yaml
name: Build and Release

on:
  push:
    tags:
      - 'v*'
  workflow_dispatch:

jobs:
  build:
    strategy:
      fail-fast: false
      matrix:
        platform:
          - os: macos-latest
            target: universal-apple-darwin
            name: macOS
          - os: ubuntu-22.04
            target: x86_64-unknown-linux-gnu
            name: Linux
          - os: windows-latest
            target: x86_64-pc-windows-msvc
            name: Windows

    runs-on: ${{ matrix.platform.os }}
    
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
          cache-dependency-path: package-lock.json

      - name: Setup Rust
        uses: dtolnay/rust-toolchain@stable
        with:
          targets: ${{ matrix.platform.target }}

      - name: Rust cache
        uses: swatinem/rust-cache@v2
        with:
          workspaces: './src-tauri -> target'

      - name: Install dependencies (Ubuntu)
        if: matrix.platform.os == 'ubuntu-22.04'
        run: |
          sudo apt-get update
          sudo apt-get install -y \
            libwebkit2gtk-4.1-dev \
            build-essential \
            curl \
            wget \
            file \
            libxdo-dev \
            libssl-dev \
            libayatana-appindicator3-dev \
            librsvg2-dev

      - name: Install frontend dependencies
        run: npm ci

      - name: Build Tauri app
        uses: tauri-apps/tauri-action@v0
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tagName: ${{ github.ref_name }}
          releaseName: 'Super DB Manager ${{ github.ref_name }}'
          releaseBody: 'See the assets to download this version and install.'
          releaseDraft: true
          prerelease: false
          args: --target ${{ matrix.platform.target }}

      - name: Upload artifacts
        uses: actions/upload-artifact@v4
        with:
          name: ${{ matrix.platform.name }}-build
          path: |
            src-tauri/target/${{ matrix.platform.target }}/release/bundle/
          retention-days: 7
```

然后提交并推送：

```bash
git add .github/workflows/build.yml
git commit -m "ci: add GitHub Actions workflow"
git push origin develop
```

### 方法 2: 创建新的 Token（如果无法编辑现有 Token）

#### 步骤 1: 创建新 Token

1. 访问: https://github.com/settings/tokens/new
2. 填写 Token 描述，例如: "Super DB Tool Development"
3. 设置过期时间（建议 90 天或更长）
4. 选择权限范围（Scopes）:
   - ✅ `repo` (完整仓库访问)
   - ✅ `workflow` (更新 GitHub Actions)
   - ✅ `write:packages` (如果需要发布包)
5. 点击 "Generate token"
6. **立即复制 token**（只显示一次！）

#### 步骤 2: 更新 Git 远程 URL

```bash
# 方式 1: 在 URL 中包含 token（不推荐，会暴露在历史记录中）
git remote set-url origin https://<YOUR_TOKEN>@github.com/Code4Bug/super-db-tool.git

# 方式 2: 使用 credential helper（推荐）
git config --global credential.helper store
git push origin develop
# 输入用户名和新 token
```

### 方法 3: 使用 SSH 密钥（推荐长期使用）

SSH 密钥不受 workflow 权限限制。

#### 步骤 1: 生成 SSH 密钥

```bash
# 生成新的 SSH 密钥
ssh-keygen -t ed25519 -C "your_email@example.com"

# 启动 ssh-agent
eval "$(ssh-agent -s)"

# 添加密钥
ssh-add ~/.ssh/id_ed25519
```

#### 步骤 2: 添加公钥到 GitHub

1. 复制公钥:
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```
2. 访问: https://github.com/settings/keys
3. 点击 "New SSH key"
4. 粘贴公钥并保存

#### 步骤 3: 切换到 SSH URL

```bash
# 更改远程 URL 为 SSH
git remote set-url origin git@github.com:Code4Bug/super-db-tool.git

# 测试连接
ssh -T git@github.com

# 推送
git push origin develop
```

## 验证设置

### 测试 Token 权限

```bash
# 使用 GitHub API 测试
curl -H "Authorization: token YOUR_TOKEN" \
  https://api.github.com/user
```

### 测试 SSH 连接

```bash
ssh -T git@github.com
# 应该看到: Hi username! You've successfully authenticated...
```

## 常见问题

### Q: 我已经更新了 token，但还是推送失败？

A: 清除本地 Git 凭证缓存：

```bash
# macOS
git credential-osxkeychain erase
host=github.com
protocol=https

# Windows
cmdkey /delete:git:https://github.com

# Linux
rm ~/.git-credentials
```

### Q: 如何查看当前使用的认证方式？

```bash
# 查看远程 URL
git remote -v

# HTTPS: https://github.com/...
# SSH: git@github.com:...
```

### Q: 我不想使用 GitHub Actions，可以删除吗？

A: 可以。GitHub Actions 是可选的，你可以：

1. 完全删除 `.github/workflows/` 目录
2. 或者保留文件但不推送到 GitHub
3. 使用 `.gitignore` 忽略:
   ```
   .github/workflows/
   ```

## 推荐配置

对于长期开发，推荐使用 **SSH 密钥**：

✅ 优点:
- 不需要记住 token
- 不受权限范围限制
- 更安全
- 永久有效（除非删除）

❌ Personal Access Token 的缺点:
- 需要定期更新
- 需要管理权限范围
- 容易泄露

## 下一步

1. ✅ 选择一种认证方式（SSH 推荐）
2. ✅ 更新 Git 凭证
3. ✅ 恢复 GitHub Actions 文件
4. ✅ 推送并验证

## 参考资源

- [GitHub Token 文档](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [GitHub SSH 设置](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [GitHub Actions 文档](https://docs.github.com/en/actions)
