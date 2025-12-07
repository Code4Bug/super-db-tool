#!/bin/bash

# GitHub Actions 快速设置脚本
# 用法: ./scripts/setup-github-actions.sh

set -e

echo "🚀 GitHub Actions 设置向导"
echo ""

# 检查是否存在模板文件
if [ ! -f "docs/github-actions-workflow.yml" ]; then
    echo "❌ 错误: 找不到模板文件 docs/github-actions-workflow.yml"
    exit 1
fi

# 确保 .github/workflows 目录存在
mkdir -p .github/workflows

# 检查是否已存在 workflow 文件
if [ -f ".github/workflows/build.yml" ]; then
    echo "⚠️  警告: .github/workflows/build.yml 已存在"
    read -p "是否覆盖? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ 已取消"
        exit 0
    fi
fi

echo ""
echo "📋 设置前检查清单:"
echo ""
echo "请确保你已完成以下步骤:"
echo ""
echo "1. ✅ 你的 GitHub Personal Access Token 有 'workflow' 权限"
echo "   访问: https://github.com/settings/tokens"
echo ""
echo "2. ✅ 或者你使用 SSH 密钥连接 GitHub"
echo "   测试: ssh -T git@github.com"
echo ""
echo "详细设置指南: docs/GITHUB_ACTIONS_SETUP.md"
echo ""

read -p "是否继续? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ 已取消"
    exit 0
fi

# 复制模板文件
echo ""
echo "📝 创建 workflow 文件..."
cp docs/github-actions-workflow.yml .github/workflows/build.yml

echo "✅ 已创建 .github/workflows/build.yml"
echo ""

# 提示下一步
echo "🎯 下一步:"
echo ""
echo "1. 提交更改:"
echo "   git add .github/workflows/build.yml"
echo "   git commit -m 'ci: add GitHub Actions workflow'"
echo ""
echo "2. 推送到 GitHub:"
echo "   git push origin develop"
echo ""
echo "3. 创建标签触发构建:"
echo "   git tag v0.1.0"
echo "   git push origin v0.1.0"
echo ""
echo "4. 或在 GitHub 手动触发:"
echo "   Actions → Build and Release → Run workflow"
echo ""

echo "✨ 设置完成！"
