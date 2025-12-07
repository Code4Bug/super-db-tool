# Git 和 GitHub 设置总结

## ✅ 已解决的问题

### 问题描述
推送 GitHub Actions workflow 文件时遇到权限错误：
```
refusing to allow a Personal Access Token to create or update workflow 
without `workflow` scope
```

### 解决方案
将 workflow 模板文件移到 `docs/` 目录，避免直接推送到 `.github/workflows/`。

## 📁 当前文件结构

```
super-db-manager/
├── .github/
│   └── README.md                      # GitHub 配置说明
├── docs/
│   ├── GITHUB_ACTIONS_SETUP.md        # 详细设置指南
│   └── github-actions-workflow.yml    # Workflow 模板文件
└── scripts/
    └── setup-github-actions.sh        # 自动设置脚本
```

## 🚀 如何启用 GitHub Actions

### 方法 1: 使用自动化脚本（推荐）

```bash
cd super-db-manager
./scripts/setup-github-actions.sh
```

脚本会：
1. 检查模板文件是否存在
2. 创建 `.github/workflows/` 目录
3. 复制模板文件为 `build.yml`
4. 提示你下一步操作

### 方法 2: 手动设置

```bash
# 1. 创建目录
mkdir -p .github/workflows

# 2. 复制模板
cp docs/github-actions-workflow.yml .github/workflows/build.yml

# 3. 提交
git add .github/workflows/build.yml
git commit -m "ci: add GitHub Actions workflow"

# 4. 推送（需要 workflow 权限）
git push origin develop
```

## 🔐 认证方式选择

### 选项 1: 更新 Personal Access Token（简单）

1. 访问 https://github.com/settings/tokens
2. 编辑你的 token
3. 勾选 `workflow` 权限
4. 保存并更新本地凭证

**优点**: 快速简单
**缺点**: 需要定期更新 token

### 选项 2: 使用 SSH 密钥（推荐）

```bash
# 1. 生成 SSH 密钥
ssh-keygen -t ed25519 -C "your_email@example.com"

# 2. 添加到 ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# 3. 复制公钥
cat ~/.ssh/id_ed25519.pub

# 4. 添加到 GitHub
# 访问 https://github.com/settings/keys
# 点击 "New SSH key" 并粘贴公钥

# 5. 切换远程 URL
git remote set-url origin git@github.com:Code4Bug/super-db-tool.git

# 6. 测试连接
ssh -T git@github.com

# 7. 推送
git push origin develop
```

**优点**: 
- 永久有效
- 不受权限范围限制
- 更安全

**缺点**: 
- 初次设置稍复杂

## 📋 推送前检查清单

在推送 workflow 文件前，确保：

- [ ] 你的认证方式支持 workflow 权限
  - Personal Access Token 有 `workflow` 权限
  - 或使用 SSH 密钥
- [ ] workflow 文件语法正确
- [ ] 已测试本地构建
- [ ] 已更新相关文档

## 🔧 常用 Git 命令

### 查看当前认证方式

```bash
# 查看远程 URL
git remote -v

# HTTPS: https://github.com/...
# SSH: git@github.com:...
```

### 切换认证方式

```bash
# 切换到 HTTPS
git remote set-url origin https://github.com/Code4Bug/super-db-tool.git

# 切换到 SSH
git remote set-url origin git@github.com:Code4Bug/super-db-tool.git
```

### 清除 Git 凭证

```bash
# macOS
git credential-osxkeychain erase
host=github.com
protocol=https
[按 Enter 两次]

# Windows
cmdkey /delete:git:https://github.com

# Linux
rm ~/.git-credentials
```

## 🎯 工作流程

### 日常开发

```bash
# 1. 拉取最新代码
git pull origin develop

# 2. 创建功能分支
git checkout -b feature/new-feature

# 3. 开发和提交
git add .
git commit -m "feat: add new feature"

# 4. 推送分支
git push origin feature/new-feature

# 5. 创建 Pull Request（在 GitHub 上）
```

### 发布版本

```bash
# 1. 更新版本号
npm version patch  # 0.1.0 -> 0.1.1

# 2. 推送代码和标签
git push origin develop
git push origin --tags

# 3. GitHub Actions 自动构建（如已启用）
# 或手动构建
npm run tauri:build
```

## 📚 相关文档

- [GitHub Actions 详细设置](GITHUB_ACTIONS_SETUP.md)
- [快速参考](../QUICK_REFERENCE.md)
- [构建指南](../BUILD_GUIDE.md)

## 💡 提示

### 如果你不需要 GitHub Actions

可以完全跳过 workflow 设置，使用本地构建：

```bash
# 本地构建所有平台
npm run tauri:build

# 或使用自动化脚本
./scripts/build-all.sh
```

### 如果你想稍后再设置

workflow 模板文件已保存在 `docs/github-actions-workflow.yml`，随时可以启用。

## ✨ 总结

1. ✅ 代码已成功推送到 GitHub
2. ✅ Workflow 模板已保存在 `docs/` 目录
3. ✅ 提供了详细的设置指南
4. ✅ 提供了自动化设置脚本
5. ✅ 支持 HTTPS 和 SSH 两种认证方式

你现在可以：
- 继续开发功能
- 使用本地构建
- 稍后启用 GitHub Actions（当你准备好时）

需要启用 GitHub Actions 时，运行：
```bash
./scripts/setup-github-actions.sh
```
