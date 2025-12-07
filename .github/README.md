# GitHub Actions 配置

## 📁 文件说明

- GitHub Actions 工作流模板文件位于: `docs/github-actions-workflow.yml`
- 由于 GitHub Token 权限限制，模板文件不在此目录下

## 🚀 如何启用

### 方法 1: 使用设置脚本（推荐）

```bash
./scripts/setup-github-actions.sh
```

### 方法 2: 手动启用

```bash
# 1. 创建 workflows 目录（如果不存在）
mkdir -p .github/workflows

# 2. 复制模板文件
cp docs/github-actions-workflow.yml .github/workflows/build.yml

# 3. 提交并推送
git add .github/workflows/build.yml
git commit -m "ci: add GitHub Actions workflow"
git push origin develop
```

## ⚠️ 重要提示

推送 workflow 文件需要你的 GitHub Token 有 **`workflow`** 权限。

如果遇到以下错误：
```
refusing to allow a Personal Access Token to create or update workflow 
without `workflow` scope
```

请参考详细设置指南: [docs/GITHUB_ACTIONS_SETUP.md](../docs/GITHUB_ACTIONS_SETUP.md)

## 🔧 解决方案

### 选项 1: 更新 Token 权限
1. 访问 https://github.com/settings/tokens
2. 编辑你的 token
3. 勾选 `workflow` 权限
4. 保存并更新本地凭证

### 选项 2: 使用 SSH（推荐）
```bash
# 切换到 SSH
git remote set-url origin git@github.com:Code4Bug/super-db-tool.git

# 推送
git push origin develop
```

## 📚 更多信息

详细的设置步骤和故障排除，请查看:
- [GitHub Actions 设置指南](../docs/GITHUB_ACTIONS_SETUP.md)
- [快速参考](../QUICK_REFERENCE.md)
